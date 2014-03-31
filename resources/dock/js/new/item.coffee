launcher_mouseout_id = null
_lastCliengGroup = null
pop_id = null
hide_id = null
class Item extends Widget
    constructor:(@id, icon, title, @container)->
        super()
        @imgWarp = create_element(tag:'div', class:"imgWarp", @element)
        @img = create_element(tag:'div',class:"AppItemImg", @imgWarp)
        # @img.src = icon || NOT_FOUND_ICON
        @img.style.backgroundImage = "url(#{icon || NOT_FOUND_ICON})"
        @img.classList.add("ReflectImg")
        @img.style.pointerEvents = "auto"
        @img.addEventListener("mouseover", @on_mouseover)
        @img.addEventListener("mouseout", @on_mouseout)
        @img.addEventListener("click", @on_click)
        @img.addEventListener("contextmenu", @on_rightclick)

        calc_app_item_size()
        @tooltip = null
        @element.classList.add("AppItem")
        @element.draggable=true
        @container?.appendChild?(@element)

    set_tooltip: (text) ->
        if @tooltip == null
            # @tooltip = new ToolTip(@element, text)
            @tooltip = new ArrowToolTip(@element, text)
            @tooltip.set_delay_time(200)  # set delay time to the same as scale time
            return
        @tooltip.set_text(text)

    destroy_tooltip:->
        @tooltip?.hide()
        @tooltip?.destroy()
        @tooltip = null

    update_scale:->

    on_mouseover:(e)=>
        # console.log("mouseover, require_all_region")
        DCore.Dock.require_all_region()
        @imgWarp.style.webkitTransform = 'translateY(-5px)'
        @imgWarp.style.webkitTransition = 'all 100ms'

    on_mouseout:(e)=>
        @imgWarp.style.webkitTransform = 'translateY(0px)'
        @imgWarp.style.webkitTransition = 'all 400ms'
        #calc_app_item_size()
        update_dock_region()

    on_rightclick:(e)=>
        e.preventDefault()
        e.stopPropagation()
        @tooltip?.hide()

    on_click:(e)=>
        e.preventDefault()
        e.stopPropagation()


class AppItem extends Item
    is_fixed_pos: false
    constructor:(@id, @icon, @title, @container)->
        super

        @core = new EntryProxy($DBus[@id])

        @indicatorWarp = create_element(tag:'div', class:"indicatorWarp", @element)
        @openingIndicator = create_img(src:OPENING_INDICATOR, class:"indicator OpeningIndicator", @indicatorWarp)
        @openIndicator = create_img(src:OPEN_INDICATOR, class:"indicator OpenIndicator", @indicatorWarp)

        @tooltip = null

        if @isNormal()
            @init_activator()
        else
            @init_clientgroup()


        if app_list._insert_anchor_item
            app_list.append(@)
        else
            app_list.append_app_item?(@)

        @core?.connect("DataChanged", (name, value)=>
            # console.log("#{name} is changed to #{value}")

            if name == ITEM_DATA_FIELD.xids
                # [{Xid:0, Title:""}]
                xids = JSON.parse(value)
                for info in xids
                    @update_client(info.Xid, info.Title)

                ids = @n_clients.slice(0)
                for id in ids
                    needDelete = true
                    for info in xids
                        if id == info.Xid
                            needDelete = false
                            break
                    if needDelete
                        @remove_client(id)

                return
            else if name == ITEM_DATA_FIELD.status
                if @isActive()
                    @swap_to_clientgroup()
                else if @isNormal()
                    @swap_to_activator()
        )

    init_clientgroup:->
        console.log("init_clientgroup #{@core.id()}")
        @n_clients = []
        @client_infos = {}
        if @core
            # console.log "#{@id}: #{@core.type()}, #{@core.xids()}"
            if (xids = JSON.parse(@core.xids()))
                for xidInfo in xids
                    @n_clients.push(xidInfo.Xid)
                    @update_client(xidInfo.Xid, xidInfo.Title)
                    # console.log "ClientGroup:: Key: #{xidInfo.Xid}, Valvue:#{xidInfo.Title}"
                if @isApplet()
                    @embedWindows = new EmbedWindow(xids)
        @leader = null

    init_activator:->
        console.log("init_activator #{@core.id()}")
        @openIndicator.style.display = 'none'
        @set_tooltip(@title)

    swap_to_clientgroup:->
        @openingIndicator.style.display = 'none'
        @openingIndicator.style.webkitAnimationName = ''
        @openIndicator.style.display = 'inline'
        @destroy_tooltip()
        @init_clientgroup()

    swap_to_activator:->
        @init_activator()

    update_client: (id, title)->
        @client_infos[id] =
            "id": id
            "title": title
        @add_client(id)
        @update_scale()

    add_client: (id)->
        if @n_clients.indexOf(id) == -1
            @n_clients.unshift(id)
            apply_rotate(@img, 1)

            if @leader != id
                @leader = id

        @element.style.display = "block"

    remove_client: (id, used_internal=false) ->
        if not used_internal
            delete @client_infos[id]

        @n_clients.remove(id)

        if @n_clients.length == 0
            @destroy()
        else if @leader == id
            @next_leader()

    next_leader: ->
        @n_clients.push(@n_clients.shift())
        @leader = @n_clients[0]

    destroy: ->
        if @isNormal()
            super
            @destroy_tooltip()
            calc_app_item_size()
        else
            Preview_close_now(@)
            @element.style.display = "block"
            super

    destroyWidthAnimation:->
        @img.classList.remove("ReflectImg")
        calc_app_item_size()
        @rotate()
        setTimeout(=>
            @destroy()
        ,500)

    isNormal:->
        @core.isNormal?()

    isActive:->
        @core.isActive?()

    isApp:->
        @core.isApp?()

    isApplet:->
        @core.isApplet?()

    on_mouseover:(e)=>
        super
        if @isNormal()
            Preview_close_now(Preview_container._current_group)
            clearTimeout(hide_id)
        else
            _lastCliengGroup?.embedWindows?.hide?()
            super
            xy = get_page_xy(@element)
            w = @element.clientWidth || 0
            # console.log("mouseover: "+xy.y + ","+xy.x, +"clientWidth"+w)
            e.stopPropagation()
            __clear_timeout()
            clearTimeout(hide_id)
            clearTimeout(tooltip_hide_id)
            clearTimeout(launcher_mouseout_id)
            DCore.Dock.require_all_region()
            # console.log("ClientGroup mouseover")
            # console.log(@core.type())
            if @core && @isApp()
                console.log("App show preview")
                if @n_clients.length != 0
                    Preview_show(@)
            else if @embedWindows
                console.log("Applet show preview")
                size = @embedWindows.window_size(@embedWindows.xids[0])
                # console.log size
                width = size.width
                height = size.height
                # console.log("size: #{width}x#{height}")
                Preview_show(@, width:width, height:height, (c)=>
                    ew = @embedWindows
                    # 6 for container's blur
                    extraHeight = PREVIEW_TRIANGLE.height + 6 + PREVIEW_WINDOW_MARGIN + PREVIEW_WINDOW_BORDER_WIDTH + PREVIEW_CONTAINER_BORDER_WIDTH + height
                    # console.log("Preview_show callback: #{c}")
                    x = xy.x + w/2 - width/2
                    y = xy.y - extraHeight
                    # console.log("Move Window to #{x}, #{y}")
                    ew.move(ew.xids[0], x, y)
                    ew.show()
                    ew.draw_to_canvas(c)
                    for i in [1..3]
                        setTimeout(->
                            ew.draw_to_canvas(c)
                        , 100*i)
                    setTimeout(->
                        ew.draw_to_canvas(null)
                        ew.show()
                    , 500)
                )

    on_mouseout:(e)=>
        super
        if @isNormal()
            super
            if Preview_container.is_showing
                __clear_timeout()
                clearTimeout(tooltip_hide_id)
                DCore.Dock.require_all_region()
                launcher_mouseout_id = setTimeout(->
                    calc_app_item_size()
                    # update_dock_region()
                , 1000)
            else
                calc_app_item_size()
                # update_dock_region()
                setTimeout(->
                    DCore.Dock.update_hide_mode()
                , 500)
        else
            _lastCliengGroup = @
            super
            if not Preview_container.is_showing
                console.log "Preview_container is not showing"
                # update_dock_region()
                calc_app_item_size()
                hide_id = setTimeout(=>
                    DCore.Dock.update_hide_mode()
                    @embedWindows?.hide()
                , 300)
            else
                console.log "Preview_container is showing"
                DCore.Dock.require_all_region()
                hide_id = setTimeout(=>
                    @embedWindows?.hide()
                    calc_app_item_size()
                    # update_dock_region()
                    Preview_close_now(@)
                    DCore.Dock.update_hide_mode()
                , 1000)

    on_rightclick:(e)=>
        super
        Preview_close_now()
        _lastCliengGroup?.embedWindows?.hide?()
        console.log("rightclick")
        xy = get_page_xy(@element)

        clientHalfWidth = @element.clientWidth / 2
        menuContent = @core.menuContent?()
        menu =
            x: xy.x + clientHalfWidth
            y: xy.y
            isDockMenu: true
            cornerDirection: DEEPIN_MENU_CORNER_DIRECTION.DOWN
            menuJsonContent: menuContent

        menuJson = JSON.stringify(menu)

        # console.log(menuJson)

        manager = get_dbus(
            "session",
            name:DEEPIN_MENU_NAME,
            path:DEEPIN_MENU_PATH,
            interface:DEEPIN_MENU_MANAGER_INTERFACE
        )

        menu_dbus_path = manager.RegisterMenu_sync()
        # echo "menu path is: #{menu_dbus_path}"
        dbus = get_dbus(
            "session",
            name:DEEPIN_MENU_NAME,
            path:menu_dbus_path,
            interface:DEEPIN_MENU_INTERFACE
        )

        if dbus
            dbus.connect("ItemInvoked", @on_itemselected($DBus[@id]))
            dbus.ShowMenu(menuJson)
        else
            conosle.log("get menu dbus failed")

    on_itemselected: (d)->
        (id)->
            console.log("select id: #{id}")
            d?.HandleMenuItem(parseInt(id))

    on_click:(e)=>
        super
        @core.activate?(0,0)
        console.log("on_click")
        if @isNormal()
            @openNotify()

    openNotify:->
        @openingIndicator.style.display = 'inline'
        @openingIndicator.style.webkitAnimationName = 'Breath'

    to_active_status : (id)->
        @leader = id
        @n_clients.remove(id)
        @n_clients.unshift(id)

    do_dragleave: (e) =>
        super
        clearTimeout(pop_id) if e.dataTransfer.getData('text/plain') != "swap"

    do_dragenter: (e) =>
        e.preventDefault()
        flag = e.dataTransfer.getData("text/plain")
        if flag != "swap" and @n_clients.length == 1
            pop_id = setTimeout(=>
                @to_active_status(@leader)
                pop_id = null
            , 1000)
        super

    do_drop: (e) =>
        super
        clearTimeout(pop_id) if e.dataTransfer.getData('text/plain') != "swap"

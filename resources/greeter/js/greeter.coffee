#Copyright (c) 2011 ~ 2013 Deepin, Inc.
#              2011 ~ 2013 yilang
#
#Author:      LongWei <yilang2007lw@gmail.com>
#Maintainer:  LongWei <yilang2007lw@gmail.com>
#
#This program is free software; you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation; either version 3 of the License, or
#(at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program; if not, see <http://www.gnu.org/licenses/>.

class Greeter extends Widget

    constructor:->
        super
        echo "Greeter"
        inject_css(_b,"css/greeter.css")

    webview_ok:(_current_user)->
        DCore.Greeter.webview_ok(_current_user.id) if hide_face_login

    start_login_connect:(_current_user)->
        DCore.signal_connect("start-login", ->
            # echo "receive start login"
            # TODO: maybe some animation or some reflection.
            _current_user.is_recognizing = false
            DCore.Greeter.start_session(_current_user.id, _current_user.password, _current_user.session)
        )

    mousewheel_listener:(user)->
        document.body.addEventListener("mousewheel", (e) =>
            if e.wheelDelta >= 120 then user?.switchtonext_userinfo()
            else if e.wheelDelta <= -120 then user?.switchtoprev_userinfo()
        )


    keydown_listener:(e,user)->
        echo "greeter keydown_listener"
        if e.which == LEFT_ARROW
            user?.switch_userinfo("next")
        else if e.which == RIGHT_ARROW
            user?.switch_userinfo("prev")

    isOnlyOneSession:->
        @sessions = DCore.Greeter.get_sessions()
        @is_one_session = false
        if @sessions.length == 0
            echo "your system has no session!!!"
            new NoSessionMessage()
        else if @sessions.length == 1 then @is_one_session = true
        return @is_one_session

    layout: ->
        @layouts = DCore.Greeter.get_layouts()
        echo @layouts.length
        echo @layouts
        @currentlayout = DCore.Greeter.get_current_layout()
        echo @currentlayout

greeter = new Greeter()
greeter.isOnlyOneSession()
#greeter.layout()

_b = document.body

desktopmenu = null
if greeter.sessions.length > 1
    div_desktop = create_element("div","div_desktop",_b)
    div_desktop.setAttribute("id","div_desktop")
    desktopmenu = new DesktopMenu(div_desktop)
    desktopmenu.new_desktop_menu()
        

div_users = create_element("div","div_users",_b)
div_users.setAttribute("id","div_users")
left = (screen.width  - 250) / 2
top = (screen.height  - 180) / 2 * 0.8
div_users.style.left = left
div_users.style.top = top
div_keyboard = create_element("div","div_keyboard",_b)
div_keyboard.style.left = left + 10
div_keyboard.style.top = top + 180 + 10

user = new User("greeter_users",div_users)
user.new_userinfo_for_greeter()
userinfo = user.get_current_userinfo()
_current_user = user.get_current_userinfo()

greeter.start_login_connect(userinfo)
greeter.webview_ok(_current_user) if hide_face_login

div_version = create_element("div","div_version",_b)
div_version.setAttribute("id","div_version")
version = new Version()
div_version.appendChild(version.element)

powermenu = null
div_power = create_element("div","div_power",_b)
div_power.setAttribute("id","div_power")
powermenu = new PowerMenu(div_power)
powermenu.new_power_menu()
        

usermenu = null
#user.prev_next_userinfo_create() if user.userinfo_all.length > 1
if user.userinfo_all.length > 1
    div_userchoose = create_element("div","div_userchoose",_b)
    div_userchoose.setAttribute("id","div_userchoose")
    usermenu = new UserMenu(user.userinfo_all,div_userchoose)
    usermenu.new_user_menu()
    if _current_user.is_logined then usermenu.menuShow()
else
    $("#div_desktop")?.style.right = "11em"

document.body.addEventListener("keydown",(e)->
    try
        if is_greeter
            echo "greeter keydown"
            powermenu?.keydown_listener(e)
            desktopmenu?.keydown_listener(e)
            if user.userinfo_all.length < 2 then return
            usermenu?.keydown_listener(e)
            if powermenu.ComboBox.menu.is_hide()
                if not desktopmenu?
                    greeter.keydown_listener(e,user)
                else if desktopmenu.ComboBox.menu.is_hide()
                    greeter.keydown_listener(e,user)
    catch e
        echo "#{e}"
)

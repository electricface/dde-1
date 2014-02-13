#Copyright (c) 2011 ~ 2012 Deepin, Inc.
#              2011 ~ 2012 yilang
#
#Author:      LongWei <yilang2007lw@gmail.com>
#                     <snyh@snyh.org>
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

class DesktopMenu extends Widget
    parent = null
    img_before = null
    
    constructor: (parent_el) ->
        super
        parent = parent_el
        img_before = "images/desktopmenu/"
   
    new_desktop_menu: ->
        echo "new_desktop_menu"
        de_menu_cb = (id, title)->
            id = de_menu.set_current(id)
        
        de_menu = new ComboBox("desktop", de_menu_cb)
        
        sessions = DCore.Greeter.get_sessions()
        echo "-------sessions-------------"
        echo sessions
        if sessions.length <= 1 then return
        
        for session in sessions
            id = session
            name = id
            #name = DCore.Greeter.get_session_name(id)
            icon = DCore.Greeter.get_session_icon(session)
            icon_path_normal = img_before + "#{icon}_normal.png"
            icon_path_hover = img_before + "#{icon}_hover.png"
            icon_path_press = img_before + "#{icon}_press.png"
            de_menu.insert(id, name, icon_path_normal,icon_path_hover,icon_path_press)
        de_menu.frame_build()
        if not parent? then parent = document.body
        parent.appendChild(de_menu.element)
        
        
        current_session_icon_name = DCore.Greeter.get_session_icon(localStorage.getItem("de_current_id"))
        echo "current_session_icon_name:#{current_session_icon_name}"
        #de_menu.current_img.title = current_session_icon_name
        
        try
            de_menu.current_img.src = img_before + "current/#{current_session_icon_name}.png"
        catch e
            echo "de_menu.current_img.src:#{e}"
            de_menu.current_img.src = img_before + "current/unkown.png"

    keydown_listener:(e)->
        echo "de_menu keydown_listener"
        de_menu.menu.keydown(e)
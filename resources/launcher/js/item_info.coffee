#Copyright (c) 2011 ~  Deepin, Inc.
#              2013 ~  Lee Liqiang
#
#Author:      Lee Liqiang <liliqiang@linuxdeepin.com>
#Maintainer:  Lee Liqiang <liliqiang@linuxdeepin.com>
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

class ItemInfo
    constructor:(@id, @name, @path, @icon)->
        @basename = get_path_name(@path)
        @isAutostart = false
        @status = SOFTWARE_STATE.IDLE
        @displayMode = 'display'
        @observers = {}
        @element = null
        @searchElement = null
        @favorElement = null

    register:(id, o)->
        @observers[id] = o
        @

    remove: (id)->
        delete @observers[id]
        @

    notify: ->
        for own o, k of @observers
            k.update(@)
        @

    setAutostart:(isAutostart)->
        @isAutostart = isAutostart
        @

    setStatus:(status)->
        @status = status
        @

    setDisplayMode:(mode)->
        @displayMode = mode
        @
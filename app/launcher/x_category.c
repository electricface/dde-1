/**
 * Copyright (c) 2011 ~ 2012 Deepin, Inc.
 *               2011 ~ 2012 Liqiang Lee
 *
 * Author:      Liqiang Lee <liliqiang@linuxdeepin.com>
 * Maintainer:  Liqiang Lee <liliqiang@linuxdeepin.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 **/
#include "x_category.h"

XCategory x_category_name_index_map[X_CATEGORY_NUM] = {
    {"internet", 0},
    {"webbrowser", 0},
    {"email", 0},
    {"contactmanagement", 0},
    {"filetransfer", 0},
    {"p2p", 0},
    {"instantmessaging", 0},
    {"chat", 0},
    {"videoconference", 0},
    {"ircclient", 0},
    {"news", 0},
    {"remoteaccess", 0},
    {"multimedia", 1},
    {"tv", 1},
    {"audio", 1},
    {"video", 1},
    {"audiovideo", 1},
    {"x-jack", 1},
    {"x-alsa", 1},
    {"x-multitrack", 1},
    {"x-sound", 1},
    {"audiovideoediting", 1},
    {"cd", 1},
    {"discburning", 1},
    {"midi", 1},
    {"x-midi", 1},
    {"mixer", 1},
    {"player", 1},
    {"music", 1},
    {"recorder", 1},
    {"sequencer", 1},
    {"x-sequencers", 1},
    {"x-suse-sequencer", 1},
    {"tuner", 1},
    {"game", 2},
    {"amusement", 2},
    {"actiongame", 2},
    {"adventuregame", 2},
    {"arcadegame", 2},
    {"boardgame", 2},
    {"cardgame", 2},
    {"emulator", 2},
    {"x-debian-applications-emulators", 2},
    {"simulation", 2},
    {"kidsgame", 2},
    {"logicgame", 2},
    {"puzzlegame", 2},
    {"blocksgame", 2},
    {"x-suse-core-game", 2},
    {"roleplaying", 2},
    {"sportsgame", 2},
    {"strategygame", 2},
    {"graphics", 3},
    {"2dgraphics", 3},
    {"3dgraphics", 3},
    {"imageprocessing", 3},
    {"ocr", 3},
    {"photography", 3},
    {"rastergraphics", 3},
    {"vectorgraphics", 3},
    {"x-geeqie", 3},
    {"viewer", 3},
    {"spreadsheet", 4},
    {"office", 4},
    {"x-suse-core-office", 4},
    {"x-mandrivalinux-office-other", 4},
    {"x-turbolinux-office", 4},
    {"wordprocessor", 4},
    {"projectmanagement", 4},
    {"chart", 4},
    {"numericalanalysis", 4},
    {"presentation", 4},
    {"scanning", 4},
    {"printing", 4},
    {"engineering", 5},
    {"telephonytools", 5},
    {"telephony", 5},
    {"technical", 5},
    {"finance", 5},
    {"hamradio", 5},
    {"medicalsoftware", 5},
    {"x-mandriva-office-publishing", 5},
    {"publishing", 5},
    {"x-kde-edu-misc", 6},
    {"education", 6},
    {"art", 6},
    {"literature", 6},
    {"translation", 6},
    {"dictionary", 6},
    {"x-religion", 6},
    {"x-bible", 6},
    {"x-islamic-software", 6},
    {"x-quran", 6},
    {"artificialintelligence", 6},
    {"electricity", 6},
    {"robotics", 6},
    {"geography", 6},
    {"computerscience", 6},
    {"math", 6},
    {"biology", 6},
    {"geoscience", 6},
    {"physics", 6},
    {"meteorology", 6},
    {"chemistry", 6},
    {"electronics", 6},
    {"geology", 6},
    {"astronomy", 6},
    {"science", 6},
    {"development", 7},
    {"debugger", 7},
    {"ide", 7},
    {"building", 7},
    {"guidesigner", 7},
    {"webdevelopment", 7},
    {"revisioncontrol", 7},
    {"system", 8},
    {"trayicon", 8},
    {"x-lxde-settings", 8},
    {"x-xfce-toplevel", 8},
    {"x-xfcesettingsdialog", 8},
    {"x-xfce", 8},
    {"x-kde-utilities-pim", 8},
    {"x-kde-internet", 8},
    {"x-kde-more", 8},
    {"x-kde-utilities-peripherals", 8},
    {"kde", 8},
    {"x-kde-utilities-file", 8},
    {"x-kde-utilities-desktop", 8},
    {"x-gnome-networksettings", 8},
    {"gnome", 8},
    {"x-gnome-settings-panel", 8},
    {"x-gnome-personalsettings", 8},
    {"x-gnome-systemsettings", 8},
    {"desktoputility", 8},
    {"x-misc", 8},
    {"x-suse-core", 8},
    {"x-red-hat-base-only", 8},
    {"x-novell-main", 8},
    {"x-red-hat-extra", 8},
    {"x-suse-yast", 8},
    {"x-sun-supported", 8},
    {"x-suse-yast-high_availability", 8},
    {"x-suse-controlcenter-lookandfeel", 8},
    {"x-suse-controlcenter-system", 8},
    {"x-red-hat-serverconfig", 8},
    {"x-mandrivalinux-system-archiving-backup", 8},
    {"x-suse-backup", 8},
    {"x-red-hat-base", 8},
    {"panel", 8},
    {"x-gnustep", 8},
    {"x-bluetooth", 8},
    {"x-ximian-main", 8},
    {"x-synthesis", 8},
    {"x-digital_processing", 8},
    {"desktopsettings", 8},
    {"monitor", 8},
    {"dialup", 8},
    {"x-mandrivalinux-internet-other", 8},
    {"packagemanager", 8},
    {"systemsettings", 8},
    {"hardwaresettings", 8},
    {"settings", 8},
    {"advancedsettings", 8},
    {"filesystem", 8},
    {"x-enlightenment", 8},
    {"compiz", 8},
    {"utility", 9},
    {"consoleonly", 9},
    {"pda", 9},
    {"core", 9},
    {"favorites", 9},
    {"pim", 9},
    {"gpe", 9},
    {"motif", 9},
    {"accessibility", 9},
    {"applet", 9},
    {"accessories", 9},
    {"clock", 9},
    {"calendar", 9},
    {"calculator", 9},
    {"documentation", 9},
    {"archiving", 9},
    {"compression", 9},
    {"wine", 9},
    {"wine-programs-accessories", 9},
    {"playonlinux", 9},
    {"filemanager", 9},
    {"filetools", 9},
    {"screensaver", 9},
    {"terminalemulator", 9},
    {"editors", 9},
    {"texteditor", 9},
    {"texttools", 9},
    {"network", 0},
};


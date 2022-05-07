-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification handling library
local naughty = require("naughty")

-- Ruled
local ruled = require("ruled")

-- Helpers
local helpers = require("helpers")

-- Get screen geometry
local screen_width = awful.screen.focused().geometry.width
local screen_height = awful.screen.focused().geometry.height

local tag1 = "1"
local tag2 = "2"
local tag3 = "3"
local tag4 = "4"
local tag5 = "5"
local tag6 = "6"
local tag7 = "7"
local tag8 = "8"
local tag9 = "9"

ruled.client.connect_signal("request::rules", function()
	-- Global
	ruled.client.append_rule({
		id = "global",
		rule = {},
		properties = {
			focus = awful.client.focus.filter,
			raise = true,
			size_hints_honor = false,
			screen = awful.screen.preferred,
			titlebars_enabled = beautiful.titlebar_enabled,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
		},
	})

	-- Tasklist order
	ruled.client.append_rule({
		id = "tasklist_order",
		rule = {},
		properties = {},
		callback = awful.client.setslave,
	})

	-- Titlebar rules
	ruled.client.append_rule({
		id = "titlebars",
		rule_any = {
			class = {
				"discord",
				"Spotify",
				"Org.gnome.Nautilus",
			},
			type = {
				"splash",
			},
			name = {
				"^discord.com is sharing your screen.$", -- Discord (running in browser) screen sharing popup
			},
		},
		properties = {
			titlebars_enabled = beautiful.titlebar_enabled,
		},
	})

	-- Maximized
	ruled.client.append_rule({
		id = "maximized",
		rule_any = {
			class = {
				"TelegramDesktop",
				"discord",
			},
		},
		properties = {
			maximized_vertical = true,
			maximized_horizontal = true,
		},
	})

	-- Float
	ruled.client.append_rule({
		id = "floating",
		rule_any = {
			instance = {
				"Devtools", -- Firefox devtools
			},
			class = {
				"Nm-connection-editor",
				"Arandr",
				"Blueman-manager",
				"Gpick",
				"Kruler",
				"MessageWin", -- kalarm.
				"Sxiv",
				"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
				"Wpa_gui",
				"veromix",
				"xtightvncviewer",
				"jetbrains-toolbox",
				"Wine",
				"Lxappearance",
				"Nitrogen",
				"Org.gnome.Nautilus",
				"Timeshift-gtk",
			},
			name = {
				"Event Tester", -- xev
				"图片查看",
			},
			role = {
				"AlarmWindow",
				"pop-up",
				"GtkFileChooserDialog",
				"conversation",
				"ConfigManager", -- Thunderbird's about:config.
			},
			type = {
				"dialog",
			},
		},
		properties = { floating = true, placement = helpers.centered_client_placement },
	})

	-- Centered
	ruled.client.append_rule({
		id = "centered",
		rule_any = {
			type = {
				"dialog",
			},
			class = {
				-- "discord",
			},
			role = {
				"GtkFileChooserDialog",
				"conversation",
			},
		},
		properties = { placement = helpers.centered_client_placement },
	})

	-- Image viewers
	ruled.client.append_rule({
		rule_any = {
			class = {
				"feh",
				"imv",
			},
		},
		properties = {
			floating = true,
			width = screen_width * 0.7,
			height = screen_height * 0.75,
		},
		callback = function(c)
			awful.placement.centered(c, { honor_padding = true, honor_workarea = true })
		end,
	})

	-- Mpv
	ruled.client.append_rule({
		rule = { class = "mpv" },
		properties = {},
		callback = function(c)
			-- make it floating, ontop and move it out of the way if the current tag is maximized
			if awful.layout.get(awful.screen.focused()) == awful.layout.suit.floating then
				c.floating = true
				c.ontop = true
				c.width = screen_width * 0.30
				c.height = screen_height * 0.35
				awful.placement.bottom_right(c, {
					honor_padding = true,
					honor_workarea = true,
					margins = { bottom = beautiful.useless_gap * 2, right = beautiful.useless_gap * 2 },
				})
				awful.titlebar.hide(c, beautiful.titlebar_pos)
			end

			-- restore `ontop` after fullscreen is disabled
			c:connect_signal("property::fullscreen", function()
				if not c.fullscreen then
					c.ontop = true
				end
			end)
		end,
	})

	-- App rules
	ruled.client.append_rule({ rule = { class = "firefox" }, properties = { screen = 1, tag = tag1 } })

	ruled.client.append_rule({ rule = { class = "jetbrains-webstorm" }, properties = { screen = 1, tag = tag2 } })
	ruled.client.append_rule({ rule = { class = "jetbrains-pycharm" }, properties = { screen = 1, tag = tag2 } })

	ruled.client.append_rule({ rule = { class = "Google-chrome" }, properties = { screen = 1, tag = tag3 } })
	ruled.client.append_rule({ rule = { instance = "spotify" }, properties = { screen = 1, tag = tag4 } })
	ruled.client.append_rule({
		rule = { class = "electron-netease-cloud-music" },
		properties = { screen = 1, tag = tag4 },
	})

	ruled.client.append_rule({ rule = { class = "icalingua" }, properties = { screen = 1, tag = tag6 } })
	ruled.client.append_rule({ rule = { class = "Wine" }, properties = { screen = 1, tag = tag6 } })
	ruled.client.append_rule({ rule = { class = "wechat.exe" }, properties = { screen = 1, tag = tag6 } })

	ruled.client.append_rule({ rule = { class = "Solaar" }, properties = { screen = 1, tag = tag7 } })
	ruled.client.append_rule({ rule = { class = "qBittorrent" }, properties = { screen = 1, tag = tag7 } })

	ruled.client.append_rule({ rule = { class = "Joplin" }, properties = { screen = 1, tag = tag8 } })

	if screen[2] ~= nil then
		ruled.client.append_rule({ rule = { instance = "Devtools" }, properties = { screen = 2, tag = tag1 } })
		ruled.client.append_rule({ rule = { class = "obsidian" }, properties = { screen = 2, tag = tag1 } })
		ruled.client.append_rule({ rule = { instance = "ncmpcpp" }, properties = { screen = 2, tag = tag4 } })
		ruled.client.append_rule({ rule = { class = "yesplaymusic" }, properties = { screen = 2, tag = tag4 } })

		ruled.client.append_rule({ rule = { class = "Steam" }, properties = { screen = 2, tag = tag5 } })

		ruled.client.append_rule({ rule = { class = "discord" }, properties = { screen = 2, tag = tag6 } })
		ruled.client.append_rule({ rule = { class = "TelegramDesktop" }, properties = { screen = 2, tag = tag6 } })

		ruled.client.append_rule({ rule = { class = "Clash for Windows" }, properties = { screen = 2, tag = tag7 } })
	else
		ruled.client.append_rule({ rule = { instance = "Devtools" }, properties = { screen = 1, tag = tag1 } })
		ruled.client.append_rule({ rule = { class = "obsidian" }, properties = { screen = 1, tag = tag1 } })
		ruled.client.append_rule({ rule = { instance = "ncmpcpp" }, properties = { screen = 1, tag = tag4 } })
		ruled.client.append_rule({ rule = { class = "yesplaymusic" }, properties = { screen = 1, tag = tag4 } })

		ruled.client.append_rule({ rule = { class = "Steam" }, properties = { screen = 1, tag = tag5 } })

		ruled.client.append_rule({ rule = { class = "discord" }, properties = { screen = 1, tag = tag6 } })
		ruled.client.append_rule({ rule = { class = "TelegramDesktop" }, properties = { screen = 1, tag = tag6 } })

		ruled.client.append_rule({ rule = { class = "Clash for Windows" }, properties = { screen = 1, tag = tag7 } })
	end
end)

-- Standard awesome library
local gfs = gears.filesystem
local wibox = require("wibox")

-- Helpers
local helpers = require("helpers")

-- Bling Module
local bling = require("module.bling")

-- Layout Machi
local machi = require("module.layout-machi")
beautiful.layout_machi = machi.get_icon()

-- Desktop
-------------

-- Custom Layouts
local mstab = bling.layout.mstab
local centered = bling.layout.centered
local horizontal = bling.layout.horizontal
local equal = bling.layout.equalarea
local deck = bling.layout.deck

machi.editor.nested_layouts = {
	["0"] = deck,
	["1"] = awful.layout.suit.spiral,
	["2"] = awful.layout.suit.fair,
	["3"] = awful.layout.suit.fair.horizontal,
}

-- Set the layouts
tag.connect_signal("request::default_layouts", function()
	awful.layout.append_default_layouts({
		awful.layout.suit.tile,
		awful.layout.suit.floating,
		centered,
		mstab,
		horizontal,
		machi.default_layout,
		equal,
		deck,
	})
end)

-- Screen Padding and Tags
screen.connect_signal("request::desktop_decoration", function(s)
	-- Screen padding
	screen[s].padding = { left = dpi(10), right = dpi(10), top = dpi(20), bottom = dpi(10) }
	-- -- Each screen has its own tag table.
	awful.tag({ tag1, tag2, tag3, tag4, tag5, tag6, tag7, tag8, tag9 }, s, awful.layout.layouts[1])
end)

-- Wallpapers
awful.screen.connect_for_each_screen(function(s)
	gears.wallpaper.maximized(gears.surface.load_uncached(beautiful.wallpaper), s, false, nil)
end)

-- Set tile wallpaper
-- bling.module.tiled_wallpaper("", s, {
--     fg = beautiful.lighter_bg,
--     bg = beautiful.xbackground,
--     offset_y = 6,
--     offset_x = 18,
--     font = "Iosevka",
--     font_size = 17,
--     padding = 70,
--     zickzack = true
-- })

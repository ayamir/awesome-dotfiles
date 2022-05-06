-- Standard awesome library
local awful = require("awful")

-- Theme handling library
local beautiful = require("beautiful")

-- Widget library
local wibox = require("wibox")

-- Helpers
local helpers = require("helpers")

-- Time
---------
local hours = wibox.widget({
	font = beautiful.font_name .. "Bold 35",
	align = "right",
	format = "%H",
	valign = "top",
	widget = wibox.widget.textclock,
})

local minutes = wibox.widget({
	font = beautiful.font_name .. "Bold 35",
	align = "right",
	format = "%M",
	valign = "top",
	widget = wibox.widget.textclock,
})

local make_little_dot = function(color)
	return wibox.widget({
		bg = color,
		forced_width = dpi(10),
		forced_height = dpi(10),
		shape = helpers.rrect(dpi(2)),
		widget = wibox.container.background,
	})
end

local time = {
	hours,
	{
		nil,
		{
			make_little_dot(beautiful.xcolor1),
			make_little_dot(beautiful.xcolor4),
			make_little_dot(beautiful.xcolor5),
			spacing = dpi(10),
			widget = wibox.layout.fixed.vertical,
		},
		expand = "none",
		widget = wibox.layout.align.vertical,
	},
	minutes,
	spacing = dpi(20),
	layout = wibox.layout.fixed.horizontal,
}

return time

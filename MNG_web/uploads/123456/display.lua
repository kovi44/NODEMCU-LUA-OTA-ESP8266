local display = {}

local disp

display.init = function(oledAddr)
    sda = 2
    scl = 1 
    i2c.setup(0, sda, scl, i2c.SLOW)
    disp = u8g.ssd1306_64x48_i2c(oledAddr)
    return true
end

function draw(data)
    disp:setFont(u8g.font_6x10)
    disp:setFontRefHeightExtendedText()
    disp:setDefaultForegroundColor()
    disp:setFontPosTop()
    disp:drawStr( 0+0, 8+0, ""..data.text1)
    disp:drawStr( 0+0, 16+0, ""..data.text2)
    disp:drawStr( 0+0, 24+0, ""..data.text3)
end

display.render = function(data)
    disp:firstPage()
    repeat
        draw(data)
    until disp:nextPage() == false
end


display.weather = function(xbm_data, weather, lastUpdate, n)
        disp:firstPage()
        repeat
                if weather ~= nil then
                  if n == 0 or n == nil then
                    disp:drawXBM(8, 0, 48, 48, xbm_data )
                  end
                  if n == 1 then
                    disp:setScale2x2()
                    disp:drawStr(7,1, math.floor(weather.main.temp).."C")
                    disp:drawStr(7,11, weather.main.humidity.."%")
                    disp:undoScale()
                    disp:drawStr(0+6, 40+0, lastUpdate)
                  end
                  if n == 2 then
                    disp:setScale2x2()
                    disp:drawStr(7,1, math.floor(weather.main.temp_max).."C")
                    disp:drawStr(7,11, math.floor(weather.main.temp_min).."C")
                    disp:undoScale()
                    disp:drawStr(0+6, 40+0, "Now: "..math.floor(weather.main.temp).."C")
                  end
                end

        until disp:nextPage() == false
end

display.icon = function(icon_Data, te1, te2, te3, n)
        disp:firstPage()
        repeat
                if te1 ~= nil then
                  if n == 0 or n == nil then
                    disp:drawXBM(8, 0, 48, 48, icon_Data )
                  end
                  if n == 1 then
                    disp:drawStr( 0+0, 8+0, ""..te1)
                    disp:drawStr( 0+0, 16+0, ""..te2)
                    disp:drawStr( 0+0, 24+0, ""..te3)
                  end
                end
        until disp:nextPage() == false
end

return display

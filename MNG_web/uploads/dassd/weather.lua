config = require "config"
        
local w = {}

function w.fetch(callback)
    local sck2=net.createConnection(net.TCP, 0)
    sck2:on("connection",function(sck2, payload)
    sck2:send("GET /data/2.5/weather?q="..config.CITY.."&units=metric&APPID="..config.APPID..
                " HTTP/1.1\r\n".. 
                "Host: api.openweathermap.org\r\n"..
                "Accept: */*\r\n"..
                "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua;)"..
                "\r\n\r\n") 
            end)

    sck2:on("receive", function(sck2, payload)
        lastUpdate = string.sub(payload,string.find(payload,"Date: ")+23,string.find(payload,"Date: ")+31)
        local hour = string.sub(lastUpdate, 0, 2) + config.UTC_OFFSET
        lastUpdate = hour..string.sub(lastUpdate, 3, 9)
        local payload = string.match(payload, "{.*}")
        weather = nil
        weather = cjson.decode(payload)
        local icon = weather.weather[1].icon
        icon = string.gsub(icon, "n", "d")
        file.open(icon..".MONO", "r")
        xbm_data = file.read()
        file.close()
        
        payload = nil
        sck2:close()
        sck2 = nil
    end)
    sck2:connect(80,'api.openweathermap.org')

    collectgarbage()
    callback(xbm_data, weather, lastUpdate)
end

return w


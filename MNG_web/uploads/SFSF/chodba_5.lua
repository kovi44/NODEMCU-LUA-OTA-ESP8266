config = require("config")
local display = require('display')
local data = {
    text1 = "",
    text2 = "",
    text3 = "",
}

data.text1 = config.text1 or "?"
data.text2 = config.text2 or "?"
data.text3 = config.text3 or "?"

display.init(config.oledAddr)
display.render(data)


gpio.mode(config.b1, gpio.INPUT, gpio.PULLUP)
gpio.mode(config.b2, gpio.INPUT, gpio.PULLUP)
gpio.mode(config.r1, gpio.OUTPUT) 
gpio.mode(config.r2, gpio.OUTPUT)

function disp_text(t)
  tmr.stop(1)
  tmr.stop(2) 
  data.text1 = t;
  data.text2 = "";
  data.text3 = "";
  display.render(data)
end

function disp_end()
showWeatherData()
end

w = require "weather"

function getWeatherData() 
    w.fetch(function(xbm_data, weather, lastUpdate)
        weather = weather or "?"
        lastUpdate = lastUpdate or "?"
        xbm_data = xbm_data or "?"
    end) 
end

function showWeatherData() 
        local pic = 0
      	tmr.alarm(2, 7000, 1, function()
                 if pic == 0 then
                      display.weather(xbm_data, weather, lastUpdate,0)
                 end
                 if pic == 1 then
                      display.weather(xbm_data, weather, lastUpdate,1)
                 end
                 if pic == 2 then
                      display.weather(xbm_data, weather, lastUpdate,2)
                 end
                  pic = pic + 1
                  if pic == 3 then
                      pic = 0
                 end
              end)	
end

tmr.alarm(0, config.INTERVAL * 60000, 1, function() getWeatherData() end )
getWeatherData()
tmr.alarm(1, 30000, 0, function() getWeatherData() end )
tmr.alarm(4, 60000, 0, function() showWeatherData() end )

local button1_repetition = 0;
local button2_repetition = 0; 
local button1_state = 0
local button2_state = 0

function ild(p)
  button1_repetition = 0;
  button2_repetition = 0;
  local te1 = "Otvaram ";
  local te2 = "branu ";
  local te3 = "";
  if p == 0 then te3 = "Margaretova" else te3 = "Hrusovska"; end

  file.open("parking.MONO", "r")
  local icon_data = file.read()
  file.close()

  display.icon(icon_data, te1, te2, te3, 1)

  local pic = 0
  tmr.alarm(2, 3000, 1, function()
    if pic == 0  then
      display.icon(icon_data, te1, te2, te3, 0)
    end
    
    if pic == 1 then
      display.icon(icon_data, te1, te2, te3, 1)
    end
    
    pic = pic + 1
    if pic == 2 then
      pic = 0
    end
  end)

  gpio.write(p, gpio.HIGH);
  tmr.delay(config.k_press);
  gpio.write(p, gpio.LOW);
end


function http_request (m)
  button1_repetition = 0;
  button2_repetition = 0;
  
  local te1 = ""
  local te2 = ""
  local te3 = ""
  local sck = net.createConnection(net.TCP, false) 
    sck:on("sent",function(sck) sck:close() end)
    if m == "garaz" then
        te1 = "Otvaram / ";
        te2 = "zatvaram ";
        te3 = "garaz ";
        file.open("garage.MONO", "r")
        sck:on("connection",function(sck)
        sck:send("GET /?garage&flic"..
                " HTTP/1.1\r\n".. 
                "Host: 192.168.0.8\r\n"..
                "Accept: */*\r\n"..
                "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua;)"..
                "\r\n\r\n") 
        end)
        sck:connect(80,"192.168.0.8")

    elseif m == "zavlaha" then  
        te1 = "Spustena ";
        te2 = "automaticka ";
        te3 = "zavlaha";
        file.open("sprinkler.MONO", "r")
        sck:on("connection",function(sck)
        sck:send("GET /?pin=all&delay=5&cmd=on"..
                " HTTP/1.1\r\n".. 
                "Host: 192.168.0.124\r\n"..
                "Accept: */*\r\n"..
                "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua;)"..
                "\r\n\r\n") 
        end)
        sck:connect(80,"192.168.0.124")

    elseif m == "velux_up" then  
        te1 = "Rolety ";
        te2 = "velux ";
        te3 = "hore";
        file.open("blinds.MONO", "r")
        sck:on("connection",function(sck)
        sck:send("GET /?pin=4"..
                " HTTP/1.1\r\n".. 
                "Host: 192.168.0.13\r\n"..
                "Accept: */*\r\n"..
                "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua;)"..
                "\r\n\r\n") 
        end)
        sck:connect(80,"192.168.0.13")

    elseif m == "velux_down" then  
        te1 = "Rolety";
        te2 = "velux ";
        te3 = "dole";
        file.open("blinds.MONO", "r")
        sck:on("connection",function(sck)
        sck:send("GET /?pin=1"..
                " HTTP/1.1\r\n".. 
                "Host: 192.168.0.13\r\n"..
                "Accept: */*\r\n"..
                "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua;)"..
                "\r\n\r\n") 
        end)
        sck:connect(80,"192.168.0.13")

    elseif m == "zav1" then  
        te1 = "Spustena ";
        te2 = "zavlaha ";
        te3 = "Zone #1";
        file.open("sprinkler.MONO", "r")
        		sck:on("connection",function(sck)
        sck:send("GET /?pin=1&delay=5&cmd=on"..
                " HTTP/1.1\r\n".. 
                "Host: 192.168.0.124\r\n"..
                "Accept: */*\r\n"..
                "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua;)"..
                "\r\n\r\n") 
        end)
        sck:connect(80,"192.168.0.124")

    elseif m == "zav3" then  
        te1 = "Spustena ";
        te2 = "zavlaha ";
        te3 = "Zone #3";
        file.open("sprinkler.MONO", "r")
        sck:on("connection",function(sck)
        sck:send("GET /?pin=3&delay=5&cmd=on"..
                " HTTP/1.1\r\n".. 
                "Host: 192.168.0.124\r\n"..
                "Accept: */*\r\n"..
                "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua;)"..
                "\r\n\r\n") 
        end)
        sck:connect(80,"192.168.0.124")

    elseif m == "zav4" then  
        te1 = "Spustena ";
        te2 = "zavlaha ";
        te3 = "Zone #4";
        file.open("sprinkler.MONO", "r")
        sck:on("connection",function(sck)
        sck:send("GET /?pin=4&delay=5&cmd=on"..
                " HTTP/1.1\r\n".. 
                "Host: 192.168.0.124\r\n"..
                "Accept: */*\r\n"..
                "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua;)"..
                "\r\n\r\n") 
        end)
        sck:connect(80,"192.168.0.124")
    
    elseif m == "zav_off" then  
        te1 = "Zavlaha ";
        te2 = "je";
        te3 = "vypnuta";
        file.open("sprinkler.MONO", "r")
        sck:on("connection",function(sck)
        sck:send("GET /?pin=all&delay=5&cmd=off"..
                " HTTP/1.1\r\n".. 
                "Host: 192.168.0.124\r\n"..
                "Accept: */*\r\n"..
                "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua;)"..
                "\r\n\r\n") 
        end)
        sck:connect(80,"192.168.0.124")
    end

    local icon2_data = file.read()
    file.close()
    display.icon(icon2_data, te1, te2, te3, 1)

    local pic = 0
    
    tmr.alarm(2, 3000, 1, function()
      if pic == 0 or pic == nil then
        display.icon(icon2_data, te1, te2, te3, 0)
      end
      
      if pic == 1 then
        display.icon(icon2_data, te1, te2, te3, 1)
      end
      
      pic = pic + 1
      if pic == 2 then
        pic = 0
      end
    end)
     
     collectgarbage();
end 


local function buttonHandler()

  button1_state_new = gpio.read(config.b1)
  button2_state_new = gpio.read(config.b2)

  if button1_state == 1 and button1_state_new == 0 then
    button1_repetition = button1_repetition + 1
    delay = 5
    if button1_repetition == 1 then
      disp_text("Margaretova")
      tmr.alarm(3,2000,0, function ()
        ild(config.r1)
      end)
      tmr.alarm(6, config.pdelay*20000, 0, disp_end)
    end

    if button1_repetition == 2 then
      disp_text("Hrusovska")
      tmr.alarm(3,2000,0, function ()
        ild(config.r2)
      end)
      tmr.alarm(6, config.pdelay*20000, 0, disp_end)
    end

    if button1_repetition == 3 then
      disp_text("Garaz")
      tmr.alarm(3,2000,0, function ()
        http_request("garaz")
      end)
      tmr.alarm(6, config.pdelay*20000, 0, disp_end)
    end

    if button1_repetition == 4 then
      disp_text("Zavlaha")
      tmr.alarm(3,2000,0, function ()
        http_request("zavlaha")
      end)
      tmr.alarm(6, config.pdelay*20000, 0, disp_end)
    end

    if button1_repetition == 5 then
      disp_text("Pocasie")
      tmr.alarm(3,2000,0, function ()
        button1_repetition = 0;
        showWeatherData()
      end)
    end

    if button1_repetition == 6 then
      disp_text("Velux hore")
      tmr.alarm(3,2000,0, function ()
        http_request("velux_up")
      end)
      tmr.alarm(6, config.pdelay*20000, 0, disp_end)
    end

    if button1_repetition == 7 then
      button1_repetition = 0;
      disp_text("Velux dole")
      tmr.alarm(3,2000,0, function ()
        http_request("velux_down")
      end)
      tmr.alarm(6, config.pdelay*20000, 0, disp_end)
    end 
   end

    if button2_state == 1 and button2_state_new == 0 then
    button2_repetition = button2_repetition + 1
    delay = 5
    if button2_repetition == 1 then
      disp_text("Zavlaha #1")
      tmr.alarm(3,2000,0, function ()
        http_request("zav1")
      end)
      tmr.alarm(6, config.pdelay*20000, 0, disp_end)
    end

    if button2_repetition == 2 then
      disp_text("Zavlaha #3")
      tmr.alarm(3,2000,0, function ()
        http_request("zav3")
      end)
      tmr.alarm(6, config.pdelay*20000, 0, disp_end)
    end

    if button2_repetition == 3 then
      disp_text("Zavlaha #4")
      tmr.alarm(3,2000,0, function ()
        http_request("zav4")
      end)
      tmr.alarm(6, config.pdelay*20000, 0, disp_end)
    end

    if button2_repetition == 4 then
      button2_repetition = 0;
      disp_text("Zavlaha OFF")
      tmr.alarm(3,2000,0, function ()
        http_request("zav_off")
      end)
      tmr.alarm(6, config.pdelay*20000, 0, disp_end)
    end
   end
  button1_state = button1_state_new
  button2_state = button2_state_new
end

tmr.alarm(5, config.TIME_ALARM, 1, buttonHandler)

srv=net.createServer(net.TCP)
srv:listen(8081,function(conn)
    conn:on("receive", function(client,request)
        local buf = "";
        local html_file = "";
        buf = buf.."HTTP/1.1 200 OK\n\n"
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if(method == nil)then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
        end
        local _GET = {}
        local _GET2 = {}
        if (vars ~= nil)then
            for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                _GET[k] = v
            end

            for q in string.gmatch(vars, "(%w+)") do
                _GET2[q] = "true"
            end

        end
        if (_GET2.garage == "true") then
                      disp_text("Garaz")
                      tmr.alarm(3,2000,0, function ()
                        http_request("garaz") 
                      end)
                      tmr.alarm(6, config.pdelay*20000, 0, disp_end)

        elseif(_GET2.zavlaha == "true")then
                      disp_text("Zavlaha")
                      tmr.alarm(3,2000,0, function ()
                        http_request("zavlaha")
                      end)
                      tmr.alarm(6, config.pdelay*20000, 0, disp_end)

        elseif(_GET2.hru == "true")then
                      disp_text("Hrusovska")
                      tmr.alarm(3,2000,0, function ()
                        ild(config.r2)
                      end)
                      tmr.alarm(6, config.pdelay*20000, 0, disp_end)

        elseif(_GET2.mar == "true")then
                      disp_text("Margaretova")
                      tmr.alarm(3,2000,0, function ()
                        ild(config.r1)
                      end)
                      tmr.alarm(6, config.pdelay*20000, 0, disp_end)
        end
        html_file = "ha.html" 
        file.open(html_file,"r")
        buf = buf..file.read()
        file.close()
        
        client:send(buf);
        client:close();
        collectgarbage();
    end)
end)





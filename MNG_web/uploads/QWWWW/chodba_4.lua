
local UTC_OFFSET = 2
local CITY = "Bratislava,sk"
local APPID = "601651a03cce28b35bc7b7bfa7f398d7"
local INTERVAL = 15
local pic = 0

function disp_end()
updateWeather()
tmr.alarm(1, INTERVAL * 60000, 1, function() 
          updateWeather()
        end )
end


function disp_text(t)
  tmr.stop(1)
  tmr.stop(2) 
  text = t;
  text2 = "";
  text3 = "";
  display();
end

function ild(p)
  button1_repetition = 0;
  button2_repetition = 0;
  te1 = "Otvaram ";
  te2 = "branu ";
  if p == 0 then te3 = "Margaretova" else  te3 = "Hrusovska"; end

  file.open("parking.MONO", "r")
  xbm_data = file.read()
  file.close()
  display_o(xbm_data, te1, te2, te3, 1)

  tmr.alarm(2, 3000, 1, function()
    if pic == 0 or pic == nil then
      display_o(xbm_data, te1, te2, te3, 0)
    end
    
    if pic == 1 then
      display_o(xbm_data, te1, te2, te3, 1)
    end
    
    pic = pic + 1
    if pic == 2 then
      pic = 0
    end
  end)
  gpio.write(p, gpio.HIGH);
  tmr.delay(k_press);
  gpio.write(p, gpio.LOW);
end

function http_request (m)
  button1_repetition = 0;
  button2_repetition = 0;
    if m == "garaz" then
        te1 = "Otvaram / ";
        te2 = "zatvaram ";
        te3 = "garaz ";
        file.open("garage.MONO", "r")
    elseif m == "zavlaha" then  
        te1 = "Spustena ";
        te2 = "automaticka ";
        te3 = "zavlaha";
        file.open("sprinkler.MONO", "r")
    elseif m == "velux_up" then  
        te1 = "Rolety ";
        te2 = "velux ";
        te3 = "hore";
        file.open("blinds.MONO", "r")
    elseif m == "velux_down" then  
        te1 = "Rolety";
        te2 = "velux ";
        te3 = "dole";
        file.open("blinds.MONO", "r")
    elseif m == "zav1" then  
        te1 = "Spustena ";
        te2 = "zavlaha ";
        te3 = "Zone #1";
        file.open("sprinkler.MONO", "r")
    elseif m == "zav3" then  
        te1 = "Spustena ";
        te2 = "zavlaha ";
        te3 = "Zone #3";
        file.open("sprinkler.MONO", "r")
    elseif m == "zav4" then  
        te1 = "Spustena ";
        te2 = "zavlaha ";
        te3 = "Zone #4";
        file.open("sprinkler.MONO", "r")
    elseif m == "zav_off" then  
        te1 = "Zavlaha ";
        te2 = "je";
        te3 = "vypnuta";
        file.open("sprinkler.MONO", "r")
    end
    xbm_data = file.read()
    file.close()
    display_o(xbm_data, te1, te2, te3, 1)

    tmr.alarm(2, 3000, 1, function()
      if pic == 0 or pic == nil then
        display_o(xbm_data, te1, te2, te3, 0)
      end
      
      if pic == 1 then
        display_o(xbm_data, te1, te2, te3, 1)
      end
      
      pic = pic + 1
      if pic == 2 then
        pic = 0
      end
    end)
     
     local sck = net.createConnection(net.TCP, false) 
     sck:on("sent",function(sck)
          sck:close()  
     end)
     if m == "garaz" then
        sck:on("connection",function(sck)
        sck:send("GET /?garage&flic"..
                " HTTP/1.1\r\n".. 
                "Host: 192.168.0.8\r\n"..
                "Accept: */*\r\n"..
                "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua;)"..
                "\r\n\r\n") 
        end)
        sck:connect(80,"192.168.0.8")
     end

     if m == "zavlaha" then
        sck:on("connection",function(sck)
        sck:send("GET /?pin=all&delay=5&cmd=on"..
                " HTTP/1.1\r\n".. 
                "Host: 192.168.0.124\r\n"..
                "Accept: */*\r\n"..
                "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua;)"..
                "\r\n\r\n") 
        end)
        sck:connect(80,"192.168.0.124")
     end

    if m == "zav1" then
        sck:on("connection",function(sck)
        sck:send("GET /?pin=1&delay=5&cmd=on"..
                " HTTP/1.1\r\n".. 
                "Host: 192.168.0.124\r\n"..
                "Accept: */*\r\n"..
                "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua;)"..
                "\r\n\r\n") 
        end)
        sck:connect(80,"192.168.0.124")
     end

    if m == "zav3" then
        sck:on("connection",function(sck)
        sck:send("GET /?pin=3&delay=5&cmd=on"..
                " HTTP/1.1\r\n".. 
                "Host: 192.168.0.124\r\n"..
                "Accept: */*\r\n"..
                "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua;)"..
                "\r\n\r\n") 
        end)
        sck:connect(80,"192.168.0.124")
     end

    if m == "zav4" then
        sck:on("connection",function(sck)
        sck:send("GET /?pin=4&delay=5&cmd=on"..
                " HTTP/1.1\r\n".. 
                "Host: 192.168.0.124\r\n"..
                "Accept: */*\r\n"..
                "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua;)"..
                "\r\n\r\n") 
        end)
        sck:connect(80,"192.168.0.124")
     end

     if m == "zav_off" then
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

     if m == "velux_down" then
        sck:on("connection",function(sck)
        sck:send("GET /?pin=1"..
                " HTTP/1.1\r\n".. 
                "Host: 192.168.0.13\r\n"..
                "Accept: */*\r\n"..
                "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua;)"..
                "\r\n\r\n") 
        end)
        sck:connect(80,"192.168.0.13")
     end

     if m == "velux_up" then
        sck:on("connection",function(sck)
        sck:send("GET /?pin=4"..
                " HTTP/1.1\r\n".. 
                "Host: 192.168.0.13\r\n"..
                "Accept: */*\r\n"..
                "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua;)"..
                "\r\n\r\n") 
        end)
        sck:connect(80,"192.168.0.13")
     end
     collectgarbage();
end 


function buttonHandler()

  button1_state_new = gpio.read(b1)
  button2_state_new = gpio.read(b2)

  if button1_state == 1 and button1_state_new == 0 then
    button1_repetition = button1_repetition + 1
    delay = 5
    if button1_repetition == 1 then
      disp_text("Margaretova")
      tmr.alarm(3,2000,0, function ()
        ild(r1)
      end)
      tmr.alarm(6, pdelay*20000, 0, disp_end)
    end

    if button1_repetition == 2 then
      disp_text("Hrusovska")
      tmr.alarm(3,2000,0, function ()
        ild(r2)
      end)
      tmr.alarm(6, pdelay*20000, 0, disp_end)
    end

    if button1_repetition == 3 then
      disp_text("Garaz")
      tmr.alarm(3,2000,0, function ()
        http_request("garaz")
      end)
      tmr.alarm(6, pdelay*20000, 0, disp_end)
    end

    if button1_repetition == 4 then
      disp_text("Zavlaha")
      tmr.alarm(3,2000,0, function ()
        http_request("zavlaha")
      end)
      tmr.alarm(6, pdelay*20000, 0, disp_end)
    end

    if button1_repetition == 5 then
      disp_text("Pocasie")
      tmr.alarm(3,2000,0, function ()
        button1_repetition = 0;
        updateWeather()
        tmr.alarm(1, INTERVAL * 60000, 1, function() 
          updateWeather()
        end )
      end)
    end

    if button1_repetition == 6 then
      disp_text("Velux hore")
      tmr.alarm(3,2000,0, function ()
        http_request("velux_up")
      end)
      tmr.alarm(6, pdelay*20000, 0, disp_end)
    end

    if button1_repetition == 7 then
      button1_repetition = 0;
      disp_text("Velux dole")
      tmr.alarm(3,2000,0, function ()
        http_request("velux_down")
      end)
      tmr.alarm(6, pdelay*20000, 0, disp_end)
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
      tmr.alarm(6, pdelay*20000, 0, disp_end)
    end

    if button2_repetition == 2 then
      disp_text("Zavlaha #3")
      tmr.alarm(3,2000,0, function ()
        http_request("zav3")
      end)
      tmr.alarm(6, pdelay*20000, 0, disp_end)
    end

    if button2_repetition == 3 then
      disp_text("Zavlaha #4")
      tmr.alarm(3,2000,0, function ()
        http_request("zav4")
      end)
      tmr.alarm(6, pdelay*20000, 0, disp_end)
    end

    if button2_repetition == 4 then
      button2_repetition = 0;
      disp_text("Zavlaha OFF")
      tmr.alarm(3,2000,0, function ()
        http_request("zav_off")
      end)
      tmr.alarm(6, pdelay*20000, 0, disp_end)
    end
   end
  button1_state = button1_state_new
  button2_state = button2_state_new
end

tmr.alarm(5, TIME_ALARM, 1, buttonHandler)

function updateWeather()
    print("Updating weather")
    local sck2=net.createConnection(net.TCP, 0)
    sck2:on("connection",function(sck2, payload)
    sck2:send("GET /data/2.5/weather?q="..CITY.."&units=metric&APPID="..APPID..
                " HTTP/1.1\r\n".. 
                "Host: api.openweathermap.org\r\n"..
                "Accept: */*\r\n"..
                "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua;)"..
                "\r\n\r\n") 
            end)

    sck2:on("receive", function(sck2, payload)
        local lastUpdate = string.sub(payload,string.find(payload,"Date: ")+23,string.find(payload,"Date: ")+31)
        local hour = string.sub(lastUpdate, 0, 2) + UTC_OFFSET
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

        tmr.alarm(2, 7000, 1, function()
           if pic == 0 or pic == nil then
                display_w(xbm_data, weather, lastUpdate,0)
           end
           if pic == 1 then
                display_w(xbm_data, weather, lastUpdate,1)
           end
           if pic == 2 then
                display_w(xbm_data, weather, lastUpdate,2)
           end
            pic = pic + 1
            if pic == 3 then
                pic = 0
           end
        end)
    end)
    sck2:connect(80,'api.openweathermap.org')
    collectgarbage();
end

function display_w(xbmData, weather, lastUpdate, n)
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
                else
                  file.open("no_internet.MONO", "r")
                  xbm_data = file.read()
                  file.close()
                  disp:drawXBM(8, 0, 48, 48, xbm_data )
                end

        until disp:nextPage() == false
end

function display_o(xbmData, te1, te2, te3, n)
        disp:firstPage()
        repeat
                if te1 ~= nil then
                  if n == 0 or n == nil then
                    disp:drawXBM(8, 0, 48, 48, xbm_data )
                  end
                  if n == 1 then
                    disp:drawStr( 0+0, 8+0, ""..te1)
                    disp:drawStr( 0+0, 16+0, ""..te2)
                    disp:drawStr( 0+0, 24+0, ""..te3)
                  end
                end
        until disp:nextPage() == false
end



dofile('http_server.lc');


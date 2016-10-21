
b1 = 3 -- button 1
b2 = 4 -- button 2

r1 = 0 -- ild1 
r2 = 5 -- ild2

TIME_ALARM = 25 
button1_state = 0
button2_state = 0
button1_repetition = 0
button2_repetition = 0
delay = 0 
max_delay = 15
page = 0;
i = 0;
k_press = 200000
local UTC_OFFSET = 2
local CITY = "Bratislava,sk"
local APPID = "601651a03cce28b35bc7b7bfa7f398d7"
local INTERVAL = 10
local pic = 0

gpio.mode(b1, gpio.INPUT, gpio.PULLUP)
gpio.mode(b2, gpio.INPUT, gpio.PULLUP)

text = "Home";
text2 = "Automation";
text3 = "(C) Lukas";
text4 = "";
text5 = "";
text6 = "";
text7 = "";
text8 = "";
text9 = "";
text10 = "";
text11 = "";
text12= "";
t4 = "";
t5 = "";
t6 = "";

gpio.mode(r1, gpio.OUTPUT) 
gpio.mode(r2, gpio.OUTPUT)

function disp_text(t) 
  text = t;
  text2 = "";
  text3 = "";
  display();
end

function ild(p)
  text = "Otvaram ";
  text2 = "branu ";
  if p == 0 then text3 = "Margaretova" else  text3 = "Hrusovska"; end
  display();
  gpio.write(p, gpio.HIGH);
  tmr.delay(k_press);
  gpio.write(p, gpio.LOW);
end

function http_request (m)
     -- Command clients to do something
     text = "Otvaram ";
     text2 = "garaz ";
     text3 = " ";
     display();
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

     -- Return result
     return 'Recieved'
end 


function buttonHandler()
  
  i = i + 1;
  if i==200 then
      if (page == 0) then
         t4 = text4
         t5 = text5
         t6 = text6
      end
      if (page == 1) then
         t4 = text7
         t5 = text8
         t6 = text9
      end
      page =page + 1
      if (page == 2) then page = 0 end
      display();
      i = 0;
  end

  button1_state_new = gpio.read(b1)
  button2_state_new = gpio.read(b2)

  if button1_state == 1 and button1_state_new == 0 then
    print("BUTTON PRESSED")
    button1_repetition = button1_repetition + 1
    delay = 5
    if button1_repetition == 1 then
      disp_text("Margaretova")
      tmr.alarm(3,2000,0, function ()
        ild(r1)
      end)
      
    end

    if button1_repetition == 2 then
      disp_text("Hrusovska")
      tmr.alarm(3,2000,0, function ()
        ild(r2)
      end)
    end

    if button1_repetition == 3 then
      disp_text("Garaz")
      tmr.alarm(3,2000,0, function ()
        http_request("garaz")
      end)
    end

    if button1_repetition == 4 then
      disp_text("Zavlaha")
      tmr.alarm(3,2000,0, function ()
        http_request("zavlaha")
      end)
    end

    if button1_repetition == 5 then
      disp_text("Pocasie")
      tmr.alarm(3,2000,0, function ()
        updateWeather()
      end)
    end
    
    if button1_repetition == 6 then
        button1_repetition = 0;
        disp_text("B1 #6")
    end
   end

    if button2_state == 1 and button2_state_new == 0 then
    print("BUTTON PRESSED")
    button2_repetition = button2_repetition + 1
    delay = 5
    if button2_repetition == 1 then
      disp_text("B2 #1")
    end

    if button2_repetition == 2 then
      disp_text("B2 #2")
    end

    if button2_repetition == 3 then
      disp_text("B2 #3")
    end

    if button2_repetition == 4 then
      disp_text("B2 #4")
    end

    if button2_repetition == 5 then
      disp_text("B2 #5")
    end
    
    if button2_repetition == 6 then
        button2_repetition = 0;
        disp_text("B2 #6")
    end
   end

  button1_state = button1_state_new
  button2_state = button2_state_new
end
tmr.alarm(1, TIME_ALARM, 1, buttonHandler)

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
        --conn:close()
        print(payload)
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

    end)
    sck2:connect(80,'api.openweathermap.org')

end

function init_i2c_display()
     sda = 2
     scl = 1 
     sla = 0x3c
     i2c.setup(0, sda, scl, i2c.SLOW)
     disp = u8g.ssd1306_64x48_i2c(sla)
end
function drawNode()
     disp:setFont(u8g.font_6x10)
     disp:drawStr( 0+0, 8+0, ""..text)
     disp:drawStr( 0+0, 16+0, ""..text2)
     disp:drawStr( 0+0, 24+0, ""..text3)
     disp:drawStr( 0+0, 32+0, ""..t4)
     disp:drawStr( 0+0, 40+0, ""..t5)
     disp:drawStr( 0+0, 48+0, ""..t6)
end
function display()
    disp:firstPage()
        repeat
            drawNode(draw_state)
        until disp:nextPage() == false
end

init_i2c_display()
display();


--init_screen()
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("receive", function(client,request)
        local buf = "";
        buf = buf.."HTTP/1.1 200 OK\n\n"
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if(method == nil)then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
        end
        local _GET = {}
        if (vars ~= nil)then
            for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                _GET[k] = v
            end
        end

        if(_GET.pin == "all")then
                  if (_GET.cmd == 'on')then
                  delay = _GET.delay;
                  button_repetition = 0
              end

              if (_GET.cmd == 'off')then
                  delay = _GET.delay;
                  button_repetition = 0
              end        
        
        elseif(_GET.pin == "1")then
                  if (_GET.cmd == 'on')then
                  delay = _GET.delay;
                  button_repetition = 0
              end

        elseif(_GET.pin == "2")then
                  if (_GET.cmd == 'on')then
                  delay = _GET.delay;
                  button_repetition = 0
              end             

        elseif(_GET.pin == "3")then
                  if (_GET.cmd == 'on')then
                  delay = _GET.delay;
                  button_repetition = 0
              end

        elseif(_GET.pin == "4")then
                  if (_GET.cmd == 'on')then
                  delay = _GET.delay;
                  button_repetition = 0
              end


        elseif(_GET.weather == "update")then
                  text4 = "Temp:".._GET.temp..""..string.char(0xb0).."C";
                  text5 = "Humi:".._GET.humi.."%";
                  text6 = "Rain:".._GET.wind.."%";
                  print ("ok");
                  if (_GET.t7) then text7 = "tTemp:".._GET.t7..""..string.char(0xb0).."C"; end
                  if (_GET.t8) then text8 = "tHumi:".._GET.t8.."%"; end
                  if (_GET.t9) then text9 = "tRain:".._GET.t9.."%"; end
                  --if (_GET.t10) then text10 = _GET.t10; end
                  --if (_GET.t11) then text11 = _GET.t10; end
                  --if (_GET.t12) then text12 = _GET.t12; end
                  display();
        end
        client:send(buf);
        client:close();
        collectgarbage();
    end)
end)


function SaveX(sErr)
    if (sErr) then
        s.err = sErr
    end
    file.remove("s.txt")
    file.open("s.txt","w+")
    for k, v in pairs(s) do
        file.writeline(k .. "=" .. v)
    end                
    file.close()
    collectgarbage()
end

function mysplit(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end

function dwn()
    -- body
    n = n + 1
    v = data[n]
    if v == nil then 
        --dofile(data[1]..".lc")
        bootfile= string.gsub(data[1], '\.lua$','') --string.gsub(s, '\....$','')
        s.boot = bootfile..".lc"
        SaveX("No error")
        node.restart()

    else 
        print("Filename: "..v)
        filename=v

            file.remove(v);
            file.open(v, "w+")

            payloadFound = false
            conn=net.createConnection(net.TCP, false) 
            conn:on("receive", function(conn, payload)

                if (payloadFound == true) then
                    file.write(payload)
                    file.flush()
                else
                    if (string.find(payload,"\r\n\r\n") ~= nil) then
                        file.write(string.sub(payload,string.find(payload,"\r\n\r\n") + 4))
                        file.flush()
                        payloadFound = true
                    end
                end

                payload = nil
                collectgarbage()
            end)
            conn:on("disconnection", function(conn) 
                conn = nil
                file.close()
                ext = string.sub(v, -3)
                if (ext == "lua") then
                    node.compile(filename)
                end
                dwn()

            end)
            conn:on("connection", function(conn)
                conn:send("GET /"..s.path.."/uploads/"..id.."/"..v.." HTTP/1.0\r\n"..
                      "Host: "..s.host.."\r\n"..
                      "Connection: close\r\n"..
                      "Accept-Charset: utf-8\r\n"..
                      "Accept-Encoding: \r\n"..
                      "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n".. 
                      "Accept: */*\r\n\r\n")
            end)
            conn:connect(80,s.host)
    end

end

function FileList(sck,c)
    print "initialized"
    local nStart, nEnd = string.find(c, "\n\n")
    if (nEnde == nil) then
        nStart, nEnd = string.find(c, "\r\n\r\n")
    end
    c = string.sub(c,nEnd+1)
    print("length: "..string.len(c))

    data = mysplit(c, "\n") -- fill the field with filenames
    
    --for k,v in pairs(data) do
    n = 1
    v = data[n]
        print("Filename: "..v)
        filename=v
        
            file.remove(v);
            file.open(v, "w+")

            payloadFound = false
            conn=net.createConnection(net.TCP, false) 
            conn:on("receive", function(conn, payload)

                if (payloadFound == true) then
                    file.write(payload)
                    file.flush()
                else
                    if (string.find(payload,"\r\n\r\n") ~= nil) then
                        file.write(string.sub(payload,string.find(payload,"\r\n\r\n") + 4))
                        file.flush()
                        payloadFound = true
                    end
                end

                payload = nil
                collectgarbage()
            end)
            conn:on("disconnection", function(conn) 
                conn = nil
                file.close()
                ext = string.sub(v, -3)
                if (ext == "lua") then
                    node.compile(v)
                end
                dwn()
            end)
            conn:on("connection", function(conn)
                conn:send("GET /"..s.path.."/uploads/"..id.."/"..v.." HTTP/1.0\r\n"..
                      "Host: "..s.host.."\r\n"..
                      "Connection: close\r\n"..
                      "Accept-Charset: utf-8\r\n"..
                      "Accept-Encoding: \r\n"..
                      "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n".. 
                      "Accept: */*\r\n\r\n")
            end)
            conn:connect(80,s.host)




    --end
    collectgarbage()

end

print("fetch lua..")
data = {}
filename=nil
LoadX()

wifi.setmode (wifi.STATION)
wifi.sta.config(s.ssid, s.pwd)
wifi.sta.autoconnect (1)

iFail = 20 -- trying to connect to AP in 20sec, if not then reboot
tmr.alarm (1, 1000, 1, function ( )
  iFail = iFail -1
  print(iFail)
  if (iFail == 0) then
    SaveX("could not access "..s.ssid)
    node.restart()
  end      
  

  if wifi.sta.getip ( ) == nil then
    print(s.ssid..": "..iFail)
  else
    print ("ip: " .. wifi.sta.getip ( ))
    tmr.stop (1)
    -- get list of files
    sk=net.createConnection(net.TCP, 0)
    sk:on("connection",function(conn, payload)
                sk:send("GET /".. s.path .."/node.php?id="..id.."&list"..
                " HTTP/1.1\r\n".. 
                "Host: "..s.domain.."\r\n"..
                "Accept: */*\r\n"..
                "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua;)"..
                "\r\n\r\n") 
            end)
    sk:on("receive", FileList)
    
    --sGet = "GET /".. s.path .. " HTTP/1.1\r\nHost: " .. s.domain .. "\r\nConnection: keep-alive\r\nAccept: */*\r\n\r\n"
    sk:connect(80,s.host) 
    
  end
  collectgarbage()
 
end)



 print(collectgarbage("count").." kB used")

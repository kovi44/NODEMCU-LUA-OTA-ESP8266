-- save config file
function SaveX(vars)
    file.remove("s.txt")
    file.open("s.txt","w+")
    for k, v in pairs(s) do
        file.writeline(k .. "=" .. v)
    end                
    file.close()
    collectgarbage()
    node.restart()
end


print(collectgarbage("count").." kB used")
LoadX()

wifi.setmode(wifi.SOFTAP)
cfg = {}
cfg.ssid = "WiFi_to_Config"
wifi.ap.config(cfg)
--dofile("dns-liar.lua")

srv = net.createServer(net.TCP)
srv:listen(80, function(conn)
  local responseBytes = 0
  local method = ""
  local url = ""
  local vars = ""
  conn:on("receive",function(conn, payload)
    _, _, method, url, vars = string.find(payload, "([A-Z]+) /([^?]*)%??(.*) HTTP")
    print(method, url, vars)

    print ("|"..vars.."|")
    if (vars~=nil and vars~="") then
            for k, v in string.gmatch(vars, "(%w+)=([^&]*)&*") do
                s[k],n = string.gsub(v,"%%2F","/")
                print(k .. " = " .. s[k])
              end
        SaveX()
    end
    if url == "favicon.ico" then
      conn:send("HTTP/1.1 404 file not found")
      responseBytes = -1
      return
    end
    -- Only support one sending one file
    url = "config.htm"
    responseBytes = 0
    conn:send("HTTP/1.1 200 OK\r\n\r\n")
  end)

  conn:on("sent", function(conn)
    if responseBytes>=0 and method=="GET" then
      if file.open(url, "r") then
        file.seek("set", responseBytes)
        local line = file.read(512)
        file.close()
        if line then
          conn:send(line)
          responseBytes = responseBytes + 512
          if (string.len(line) == 512) then
            return
          end
        end
      end
    end
    conn:close()
  end)
end)

print("HTTP Server: Started")
print(collectgarbage("count").." kB used")

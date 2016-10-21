- Configure access point 
wifi.setmode(wifi.STATIONAP)
-- Declare configuration variable
cfg={}
cfg.ssid="SSID"
cfg.pwd="password"
-- Pass to access point and configure
wifi.ap.config(cfg)
-- Get current internal state
-- Load internal server to handle all communications
-- Check if server is available or create
if srv == nil then 
-- Create server
srv=net.createServer(net.TCP)
-- a simple http server
srv:listen(80,function(conn)
    conn:on("receive",function(conn,payload)
    -- Print payload message
    print(payload)
    -- Call task function and pass payload
    local output = Task(payload)
    -- Send back any response to caller or all clients
    conn:send(output)
    end)
end)
end

-- Depending on payload call certain functions
function Task (command)
     -- Declare variable to hold output
     local output = ""
     -- Select task
     if command == "0" then
          -- Do something '0' 
          output = DoSomething()
     end
     -- Return output
     return output
end

function DoSomething ()
     -- Command clients to do something
     print("Step 1")
     sck = net.createConnection(net.TCP, false) 
     sck:connect(80,"192.168.4.2")
     sck:send("Step 1")
     -- Sleep
     tmr.delay(1000)
     -- Return result
     return 'Recieved'
end
- See more at: http://www.esp8266.com/viewtopic.php?f=24&t=1283#sthash.HFymypod.dpuf
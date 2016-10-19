-- Download a file
tmr.wdclr()

httpDL = require("httpDL")
collectgarbage()

--               IP/Host        URL                                  Destination  Finished Callback
httpDL.download("192.168.0.8", 80, "/test.lua", "test2.lua", function (payload)
    -- Finished downloading
end)

httpDL = nil
package.loaded["httpDL"]=nil
collectgarbage()
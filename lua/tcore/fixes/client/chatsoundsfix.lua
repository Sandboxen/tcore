//GOD HAVE MERCY
local luadata = requirex("luadata")
local data = luadata.Decode(cookie.GetString("userdata_chatsounds_subscriptions"))["value"]
 for i,v in pairs(data) do
    if v == "PolskiSandbox/chatsound" then
        data[i] = "PolskiSandbox/chatsounds"
    end
 end
 cookie.Set("userdata_chatsounds_subscriptions",luadata.Encode(data))
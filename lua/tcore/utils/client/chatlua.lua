net.Receive("TCoreLuaReturn",function()
    local chunkname = net.ReadString()
    local script = net.ReadString()
    local ok = net.ReadBool()
    local returnvals = net.ReadTable()
    local color = ok and Color(0,255,0) or Color(255,0,0)
    PrintTable(returnvals)
    timer.Simple(0.1,function()
    chat.AddText(color,ok and "[Sukces] " or "[Błąd] ",Color(255,255,255),chunkname," Return: ",unpack(returnvals)) 
    end)
end)

EasyChat.FilterString = function(str) return str end --DONT CENSOR ME KTHXBYE
--CHATSOUNDS COMPILING INFO
if chatsounds then
    local data = chatsounds.Module("Data")
    local loadmat = Material("widgets/disc.png")
    local loadingtext = "Loading"
    hook.Add("HUDPaint","ChatsoundsLoadInfo",function()
        if data.Loading then
            local cur_perc = math.max(0, math.min(100, math.Round((data.Loading.Current / math.max(1, data.Loading.Target)) * 100)))
            surface.SetMaterial(loadmat)
            surface.SetDrawColor(Color(255,255,255))
            surface.DrawTexturedRectRotated(ScrW()/2,ScrH()/2,256,256,CurTime()*20)
            draw.SimpleTextOutlined("Chatsounds","Trebuchet24",ScrW()/2,ScrH()/2-15,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0))
            draw.SimpleTextOutlined((data.Loading.Text):format(cur_perc),"Trebuchet24",ScrW()/2,ScrH()/2+15,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0))
        end
    end)
end
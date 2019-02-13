local dyngma = {}

local gmameta = {
    __index = {
        AddFile = function(self,filename,gmdir)
            local f = file.Open(filename,"rb","DATA")
            f:Seek(0)
            local data = f:Read(f:Size())
            f:Close()
            self.files[gmdir] = data
        end,
        Save = function(self,path)
            local f = file.Open(path,"wb","DATA")
            if (not f) then
                return
            end
            f:Write("GMAD")
            f:WriteByte(3)
            f:WriteLong(0) f:WriteLong(0)
            f:WriteLong(0) f:WriteLong(0)
            f:WriteByte(0)
            f:Write("name here") f:WriteByte(0)
            f:Write("description here") f:WriteByte(0)
            f:Write("author here") f:WriteByte(0)
            f:WriteLong(1)
            local counter = 0
            local files = {}
            for name,content in pairs(self.files) do
                counter = counter + 1
                f:WriteLong(counter)
                files[counter] = content
                f:Write(name:lower()) f:WriteByte(0)
                f:WriteLong(content:len()) f:WriteLong(0)
                f:WriteLong(util.CRC(content))
            end
            f:WriteLong(0)
            for _,content in pairs(files) do
            f:Write(content)
            end
            f:WriteLong(0)
            f:Close()
            --print('saved')
        end,
    }
}


function dyngma.Prepare()
    local gma = {files = {}}
    gma = setmetatable(gma,gmameta)
    PrintTable(setmetatable(gma,gmameta))
    return gma
end

return dyngma
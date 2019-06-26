local entbl = {
    "m9k_davy_crockett"
}

hook.Add("Think","Thenkong",function()
    for i,v in ipairs(ents.GetAll()) do
        if table.HasValue(entbl,v:GetClass()) then 
        print(v)
        v:Remove() 
        end
    end
end)
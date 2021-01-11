function util.GetApiKey()
    return file.Read("apikey.txt","DATA") or ""
end

function util.GetLvlUpApiKey()
    return file.Read("lvlupapikey.txt","DATA") or ""
end
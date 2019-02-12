function util.GetApiKey()
    return file.Read("apikey.txt","DATA") or ""
end
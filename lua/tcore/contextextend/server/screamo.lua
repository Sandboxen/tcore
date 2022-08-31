if _G.rb655_dissolve then
    _G.oldrb655_dissolve = _G.oldrb655_dissolve or _G.rb655_dissolve
    function rb655_dissolve( ent )
        oldrb655_dissolve( ent )
        local scream = math.Rand(0,100) > 50 and "vo/coast/odessa/male01/nlo_cubdeath02.wav" or "vo/ravenholm/monk_death07.wav"
        ent:EmitSound(scream,100,math.Rand(100,255),1)
    end
end

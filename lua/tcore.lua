AddCSLuaFile()
TCore = TCore or {}
TCore.loaded = false
TCore.modules = {}
TCore.libs = {}
TCore.errors = {}
TCore.clienterrors = {}
TCore.othererrors = {}
TCore.otherclienterrors = {}
TCore.CSFiles = {}
local function msg(...)
  if (SERVER) then
    MsgC("[TCoreSV]",unpack({...}))
    MsgC("\n")
  end
  if (CLIENT) then
    MsgC("[TCoreCL]",unpack({...}))
    MsgC("\n")
  end
end

local function errCleaner(tab)
  while #tab > 0 and (tab[1][1] + 60 * 10 < os.time() ) do
    table.RemoveByValue(tab, tab[1])
  end
end

local function betterErr()
  if (luaerror) then
    msg("LuaError Module: ",luaerror.VersionNum)
    luaerror.EnableRuntimeDetour(true)
    luaerror.EnableCompiletimeDetour(true)
    luaerror.EnableClientDetour(true)
    msg("Detoured!")
    hook.Add("LuaError","TCoreLuaError",function(isruntime,fullerror,sourcefile,sourceline,errorstr,stack)
      local errordata = {os.time(),isruntime,fullerror,sourcefile,sourceline,errorstr,stack}
      if string.StartWith(sourcefile,"addons/tcore/") then
        table.insert(TCore.errors,errordata)
      else
        table.insert(TCore.othererrors,errordata)
      end
    end)
    hook.Add("ClientLuaError","TCoreClientEror",function(player, fullerror, sourcefile, sourceline, errorstr, stack)
      local errordata
      if IsValid(player) then
        errordata = {os.time(),player:Nick(),player:SteamID64(),fullerror, sourcefile, sourceline, errorstr, stack}
      else
        errordata = {os.time(),"none","none",fullerror, sourcefile, sourceline, errorstr, stack}
      end
      if string.StartWith(sourcefile,"addons/tcore/") then
        table.insert(TCore.clienterrors,errordata)
      else
        table.insert(TCore.otherclienterrors,errordata)
      end
    end)
    msg("Hooked!")
    hook.Add("LuaError","TCoreErrCleaner",function()
      errCleaner(TCore.errors)
    end)
    hook.Add("ClientLuaError","TCoreErrCleaner",function()
      errCleaner(TCore.clienterrors)
    end)
  else
    msg("No LuaError Module Found")
  end
end

local function load_file(path)
  if not file.Exists(path,"LUA") then
    return nil,"nofile"
  end
  local err
  local load = CompileFile(path)
  local res = {xpcall(load,function(m) err = m .. "\n" .. debug.traceback() end)}
  if err then
    res[2] = err
  end
  return unpack(res)
end

local function run_dir(dir)
  if (CLIENT or SERVER) then
    local files = file.Find(dir .. "/*.lua","LUA")
    for i,v in ipairs(files) do
      msg("Loading ",dir .. "/" .. v)
      load_file(dir .. "/" .. v)
    end
  end
  if (SERVER) then
    local files = file.Find(dir .. "/server/*.lua","LUA")
    for i,v in ipairs(files) do
      msg("Loading ",dir .. "/server/" .. v)
      load_file(dir .. "/server/" .. v)
    end
  end
  if (CLIENT) then
    local files = file.Find(dir .. "/client/*.lua","LUA")
      for i,v in ipairs(files) do
        msg("Loading ",dir .. "/client/" .. v)
        load_file(dir .. "/client/" .. v)
      end
  end
end

local function init_dir(dir)
  local files = {}
  for i,res in ipairs(file.Find("tcore/" .. dir .. "/*.lua","LUA")) do
    msg("CSAdding ","tcore/" .. dir .. "/" .. res)
    AddCSLuaFile("tcore/" .. dir .. "/" .. res)
    table.insert(files,"tcore/" .. dir .. "/" .. res)
  end
  for i,res in ipairs(file.Find("tcore/" .. dir .. "/client/*.lua","LUA")) do
    msg("CSAdding ","tcore/" .. dir .. "/client/" .. res)
    AddCSLuaFile("tcore/" .. dir .. "/client/" .. res)
    table.insert(files,"tcore/" .. dir .. "/client/" .. res)
  end
  TCore.CSFiles[dir] = files
end

local function loadmodule(name)
  run_dir("tcore/" .. name)
  for i,v in ipairs(file.Find("tcore/" .. name .. "/entities/*.lua","LUA")) do
    local ok, ent = load_file("tcore/" .. name .. "/entities/" .. v)
    msg("Loading ","tcore/" .. name .. "/entities/" .. v)
    if ok and istable(ent) then
      scripted_ents.Register(ent,string.StripExtension(v))
    end
  end
  for i,v in ipairs(file.Find("tcore/" .. name .. "/weapons/*.lua","LUA")) do
    local ok, swep = load_file("tcore/" .. name .. "/weapons/" .. v)
    msg("Loading ","tcore/" .. name .. "/weapons/" .. v)
    if ok and istable(swep) then
      weapons.Register(swep,string.StripExtension(v))
    end
  end
  TCore.modules[name] = "tcore/" .. name
end

local function initfiles()
local _,folders = file.Find("tcore/*","LUA")
  for i,v in ipairs(folders) do
    if (SERVER) then
      init_dir(v .. "/libraries")
      init_dir(v .. "/preinit")
      init_dir(v .. "/postinit")
      init_dir(v .. "/entities")
      init_dir(v .. "/weapons")
      init_dir(v)
    end
    loadmodule(v)
  end
  if (CLIENT) then
    msg("Checking Files")
    net.Start("TCoreRequestCSFiles")
    net.SendToServer()
  end
end

local function reload_dir(dir)
  local _,folders = file.Find("tcore/*","LUA")
  if (table.HasValue(folders,dir)) then
    if (SERVER) then
      init_dir(dir .. "/libraries")
      init_dir(dir .. "/preinit")
      init_dir(dir .. "/postinit")
      init_dir(dir .. "/entities")
      init_dir(dir .. "/weapons")
      init_dir(dir)
    end
    loadmodule(dir)
  end
    if (CLIENT) then
    msg("Checking Files")
    net.Start("TCoreRequestCSFiles")
    net.SendToServer()
  end
end


local function find_lib(dir,name)
  local res
  res = {load_file(dir .. "/libraries/" .. name .. ".lua")}
  if SERVER and (not res or res[2] == "nofile") then
    res = {load_file(dir .. "/libraries/server/" .. name .. ".lua")}
  end
  if CLIENT and (not res or  res[2] == "nofile") then
    res = {load_file(dir .. "/libraries/client/" .. name .. ".lua")}
  end
  if not res or res[2] == "nofile" then
    return nil
  end
  return unpack(res)
end

function TCore.getLib(lib)
  if not TCore.loaded then return nil end
  if TCore.libs[lib] then return unpack(TCore.libs[lib]) end
  for i,v in pairs(TCore.modules) do
    local libr = {find_lib(v,lib)}
    if (istable(libr)) and libr[1] == true then
      TCore.libs[lib] = libr
      return unpack(libr)
    end
  end
end

function trequire(name)
  local ok,lib = TCore.getLib(name)
  if (ok) then
    return lib
  else
    return nil
  end
end

function TCore.PreInit()
msg("PreInit")
local _,folders = file.Find("tcore/*","LUA")
    for i,v in ipairs(folders) do
      run_dir("tcore/" .. v .. "/preinit")
  end
end

function TCore.PostInit()
msg("PostInit")
local _,folders = file.Find("tcore/*","LUA")
    for i,v in ipairs(folders) do
      run_dir("tcore/" .. v .. "/postinit")
  end
end


function TCore.init()
TCore.libs = {}
  if SERVER then
    util.AddNetworkString("TCoreRequestCSFiles")
    util.AddNetworkString("TCoreRequestCSFile")
    util.AddNetworkString("TCoreForceReload")
    msg("Detouring Errors")
    betterErr()
  end
  msg("Init Files")
  initfiles()
  msg("Loaded!")

  if CLIENT then
    net.Receive("TCoreForceReload",function()
    local what = net.ReadString()
    if what == "all" then
      initfiles()
    else
      reload_dir(what)
    end
    end)
  end

  if SERVER then
    concommand.Add("tcore_reloadlua",function(ply,_,args)
      if ply:IsSuperAdmin() or ply:IsTomek() then
        net.Start("TCoreForceReload")
        if args[1] then
          net.WriteString(args[1])
        else
          net.WriteString("all")
        end
        net.Broadcast()
        if args[1] then
          reload_dir(args[1])
        else
          initfiles()
        end
      end
    end)
  end
  if (SERVER)then
    net.Receive("TCoreRequestCSFile",function(_,ply)
      local what = net.ReadString()
      local this = file.Read(what,"LUA")
      msg(ply:Nick(), "is requesting ",what)
      net.Start("TCoreRequestCSFile")
      net.WriteString(this)
      net.WriteString(what)
      net.Send(ply)
    end)
  end
  if (CLIENT) then
  net.Receive("TCoreRequestCSFiles",function()
    local files = net.ReadTable()
    for i,v in pairs(files) do
      for _,filename in ipairs(v) do
       local s = CompileFile(filename)
       if not s then
        msg("Requesting File And Loading Manually")
        net.Start("TCoreRequestCSFile")
        net.WriteString(filename)
        net.SendToServer()
       end
      end
    end
  end)
  net.Receive("TCoreRequestCSFile",function()
    local file = net.ReadString()
    local filename = net.ReadString()
    msg("Got File")
    local load,err = CompileString(file,"requested")
    if not err then
      if string.find(filename,"/entities/") then
        scripted_ents.Register(load(), string.StripExtension(string.GetFileFromFilename(filename)))
      elseif string.find(filename,"/weapons/") then
        weapons.Register(load(), string.StripExtension(string.GetFileFromFilename(filename)))
      else
        load()
      end
    else
      msg("Requested File Error ",err)
    end
  end)
end

if (SERVER) then

net.Receive("TCoreRequestCSFiles",function(_,ply)
  net.Start("TCoreRequestCSFiles")
  net.WriteTable(TCore.CSFiles)
  net.Send(ply)
end)
end

  TCore.loaded = true
end
--TCore.init()
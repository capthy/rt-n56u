local cjson = require "cjson"
local server_section = arg[1]
--local proto = arg[2]
local local_port = arg[2]

local function shell_quote(value)
    value = tostring(value or "")
    return "\'" .. value:gsub("\'", "\'\\\\\'\'") .. "\'"
end

local ssrindext = io.popen("dbus get ssconf_basic_json_" .. server_section)
local servertmp = ssrindext:read("*all")
local server = cjson.decode(servertmp)

local auth = ""
if server.server_user and server.server_user ~= "" then
    auth = " -a " .. shell_quote(server.server_user) ..
           " -k " .. shell_quote(server.server_pwd or "")
end

io.popen(
    "ipt2socks -s " .. shell_quote(server.server) ..
    " -p " .. shell_quote(server.server_port) ..
    " -l " .. shell_quote(local_port) ..
    " -r -4 -R" .. auth ..
    " >/dev/null 2>&1 &"
)
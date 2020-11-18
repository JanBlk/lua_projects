local json = require 'json'
local date = require 'date'

get = function(message)
    io.write(message)
    local result = io.read()
    return result
end

num = function(string)
    return tonumber(string)
end

inserttable = function(table1, table2)
    table.insert(table1, table2)
end

writeFile = function(content)
    local file = io.open('D:\\[Programme]\\Lua\\lua_source\\ha.json', "w")
    file:write(json.encode(content))
    file:close()
end

readFile = function()
    local file = io.open('D:\\[Programme]\\Lua\\lua_source\\ha.json', "r")
    if not file then return nil end
    local content = json.decode(file:read "*a")
    file:close()
    if content[1] ~= nil then
        getDeadline(content[1].deadlineyear, content[1].deadlinemonth, content[1].deadlineday)
    end
    return content
end

getDeadline = function(deady, deadm, deadd)
    local y, m, d = os.date('%Y'), os.date('%m'), os.date('%d')
    local currentdate = date(y, m, d)
    local deadlinedate = date(deady, deadm, deadd)
    local datediff = date.diff(currentdate, deadlinedate)
    if datediff:spandays() >= 0 then
        --ha removen
    end
    --print(datediff:spandays() >= 0)
end

insertNewHa = function(content)
    local table = readFile()
    print(json.encode(table))
    inserttable(table, content)
    writeFile(table)
end

local ha = {
    task = 'Parabeln',
    fach = 'Mathe',
    note = get('(Standard: Keine Notiz) | Notiz: '),
    deadlineyear = num(get('(Standard: Momentanes Jahr) | Deadline Jahr: ')),
    deadlinemonth = num(get('(Standard: Momentaner Monat) | Deadline Monat: ')),
    deadlineday = num(get('Deadline Tag: ')),
}

if ha.deadlineyear == nil then ha.deadlineyear = num(os.date('%Y')) end
if ha.deadlinemonth == nil then ha.deadlinemonth = num(os.date('%m')) end
if ha.note == "" then ha.note = 'Keine Notiz' end

insertNewHa(ha)
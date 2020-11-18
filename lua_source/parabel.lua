Config = {}

Config.Lang = {
    inputinvalid =  'Du hast eine Eingabe falsch angegeben oder es ist ein Fehler aufgetreten | ',
    firstinput =    '\nwenn du bei den folgenden Eingaben keinen Wert eingibst wird der Wert auf den Standard gesetzt. [ENTER]',
    a =             '(Standard: 1) | Definiere [a]: ',
    b =             '(Standard: 0) | Definiere [b]: ',
    c =             '(Standard: 0) | Definiere [c]: ',
    bool1 =         'Definiere folgende Stelle: a * x^2 [deine Eingabe] b * x + c: ',
    bool2 =         'Definiere folgende Stelle: a * x^2 + b * x [deine Eingabe] c: ',
    from =          '(Standard: -100) | Von (-1000 - 1000): ',
    to =            '(Standard: 100) | Bis (-1000 - 1000): ',
    width =         '(Standard: 0.01) | Schrittweite (0.01 - 1): ',
    firsttry =      'Die Nullstellen der Parabel: %sx^2 %s %sx %s %s sind: %s',
    next =          'Die Nullstellen der Parabel: %sx^2 %s %sx %s %s wurden nicht gefunden. Sie liegen zwischen: %s bis %s und %s bis %s\nStarte naechste Phase...\n',
    finish =        'Die Nullstellen der Parabel: %sx^2 %s %sx %s %s wurden nicht gefunden. Sie sind auf die 6te Nachkommastelle gerundet genau: %s\n',
}

get = function(message)
    io.output():write(message)
    local result = io.input():read()
    return result
end

round = function(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

num = function(string)
    return tonumber(string)
end

get(Config.Lang.firstinput)

print()

local data = {
    a      = {value = num(get(Config.Lang.a)),      name = "",                                                          default = 1},
    b      = {value = num(get(Config.Lang.b)),      name = "",                                                          default = 0},
    c      = {value = num(get(Config.Lang.c)),      name = "",                                                          default = 0},
    bool1  = {value = get(Config.Lang.bool1),       name = Config.Lang.bool1,   validinput1 = '+',  validinput2 = '-'}, --wollte keinen extra array für die valid inputs machen
    bool2  = {value = get(Config.Lang.bool2),       name = Config.Lang.bool2,   validinput1 = '+',  validinput2 = '-'}, --wollte keinen extra array für die valid inputs machen
    from   = {value = num(get(Config.Lang.from)),   name = Config.Lang.from,    limitfrom = -1000,  limitto = 1000,     default = -100},
    to     = {value = num(get(Config.Lang.to)),     name = Config.Lang.to,      limitfrom = -1000,  limitto = 1000,     default = 100},
    width  = {value = num(get(Config.Lang.width)),  name = Config.Lang.width,   limitfrom = 0.01,   limitto = 1,        default = 0.01},
}

if data.a.value == nil              then data.a.value           = data.a.default end
if data.b.value == nil              then data.b.value           = data.b.default end
if data.c.value == nil              then data.c.value           = data.c.default end
if data.from.value == nil           then data.from.value        = data.from.default end
if data.to.value == nil             then data.to.value          = data.to.default end
if data.width.value == nil          then data.width.value       = data.width.default end

while 
    (data.from.value        < data.from.limitfrom       or data.from.value      > data.from.limitto) or 
    (data.to.value          < data.to.limitfrom         or data.to.value        > data.to.limitto) or 
    (data.width.value       < data.width.limitfrom      or data.width.value     > data.width.limitto) or 
    (data.bool1.value       ~= data.bool1.validinput1   and data.bool1.value    ~= data.bool1.validinput2) or 
    (data.bool2.value       ~= data.bool2.validinput1   and data.bool2.value    ~= data.bool2.validinput2)
do
    for k,v in pairs(data) do
        if k == 'from' or k == 'to' or k == 'width' then
            if 
                (k == 'from'    and v.value < v.limitfrom or v.value > v.limitto) or 
                (k == 'to'      and v.value < v.limitfrom or v.value > v.limitto) or
                (k == 'width'   and v.value < v.limitfrom or v.value > v.limitto)
            then
                data[k].value = num(get(Config.Lang.inputinvalid..v.name))
            end
        end

        if k == 'bool1' or k == 'bool2' then
            if
                (k == 'bool1' and v.value ~= v.validinput1 and v.value ~= v.validinput2) or 
                (k == 'bool2' and v.value ~= v.validinput1 and v.value ~= v.validinput2) 
            then
                data[k].value = get(Config.Lang.inputinvalid..v.name)
            end
        end
    end
end

print()

function requestNull(from, to, width, a, b, c, firstscan, from1, to1, from2, to2, minclose)
    local nullstellen = {}
    local closenums = {}
    local parabel = nil
    if firstscan then
        for x = from, to, width do
            x = round(x, string.len(tostring(width)))

            if data.bool1.value == '+' and data.bool2.value == '+' then
                parabel = a * x^2 + b * x + c
            end

            if data.bool1.value == '-' and data.bool2.value == '-' then
                parabel = a * x^2 - b * x - c
            end

            if data.bool1.value == '+' and data.bool2.value == '-' then
                parabel = a * x^2 + b * x - c
            end

            if data.bool1.value == '-' and data.bool2.value == '+' then
                parabel = a * x^2 - b * x + c
            end

            if parabel == 0.0 then
                table.insert(nullstellen, x)
            end
        
            if parabel <= 2 and parabel >= -2 then
                table.insert(closenums, x)
            end
        
            if #nullstellen >= 2 then
                break
            end
        end
    elseif not firstscan then
        for x = from1, to1, width do
            x = round(x, string.len(tostring(width)))
            
            if data.bool1.value == '+' and data.bool2.value == '+' then
                parabel = a * x^2 + b * x + c
            end

            if data.bool1.value == '-' and data.bool2.value == '-' then
                parabel = a * x^2 - b * x - c
            end

            if data.bool1.value == '+' and data.bool2.value == '-' then
                parabel = a * x^2 + b * x - c
            end

            if data.bool1.value == '-' and data.bool2.value == '+' then
                parabel = a * x^2 - b * x + c
            end

            if parabel == 0.0 then
                table.insert(nullstellen, x)
                break
            end
        
            if parabel <= minclose and parabel >= -minclose then
                table.insert(closenums, x)
            end
        end

        for x = from2, to2, width do
            x = round(x, string.len(tostring(width)))
            
            if data.bool1.value == '+' and data.bool2.value == '+' then
                parabel = a * x^2 + b * x + c
            end

            if data.bool1.value == '-' and data.bool2.value == '-' then
                parabel = a * x^2 - b * x - c
            end

            if data.bool1.value == '+' and data.bool2.value == '-' then
                parabel = a * x^2 + b * x - c
            end

            if data.bool1.value == '-' and data.bool2.value == '+' then
                parabel = a * x^2 - b * x + c
            end

            if parabel == 0.0 then
                table.insert(nullstellen, x)
                break
            end
        
            if parabel <= minclose and parabel >= -minclose then
                table.insert(closenums, x)
            end
        end
    end
    return nullstellen, closenums
end

local nullstellen, closenums = requestNull(data.from.value, data.to.value, data.width.value, data.a.value, data.b.value, data.c.value, true)

if #nullstellen == 2 then
    print(string.format(Config.Lang.firsttry,
        data.a.value, 
        data.bool1.value, 
        data.b.value, 
        data.bool2.value, 
        data.c.value,
        table.concat(nullstellen, ' und '))
    )
else
    local minclose = 0.01
    local null1
    local null2
    local result = {}
    repeat
        if #closenums > 0 then
            null1 = closenums[1] + closenums[math.floor(#closenums / 2)]
            null2 = closenums[math.ceil(#closenums / 2 + 1)] + closenums[#closenums]
            result = {null1 / 2, null2 / 2}
            print(string.format(Config.Lang.next, 
                data.a.value, 
                data.bool1.value, 
                data.b.value, 
                data.bool2.value, 
                data.c.value, 
                closenums[1], 
                closenums[math.floor(#closenums / 2)], 
                closenums[math.ceil(#closenums / 2 + 1)], 
                closenums[#closenums])
            )
            minclose = minclose / 4
            nullstellen, closenums = requestNull(nil, nil, 0.000001, data.a.value, data.b.value, data.c.value, false, closenums[1], closenums[math.floor(#closenums / 2)], closenums[math.ceil(#closenums / 2 + 1)], closenums[#closenums], minclose)
        else
            print(string.format(Config.Lang.finish, 
                data.a.value, 
                data.bool1.value, 
                data.b.value, 
                data.bool2.value, 
                data.c.value,
                table.concat(result, ' und '))
            )
            break
        end
    until #nullstellen == 2

    print('wichtig zu beachten ist, dass wenn die Parabel ueber der X-Achse liegt oder der Scheitelpunkt der Parabel genau auf der X-Achste liegt, diese Loesung falsch ist')
end
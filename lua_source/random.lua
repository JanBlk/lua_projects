charset = {}

for i = 48,  57 do table.insert(charset, string.char(i)) end
for i = 65,  90 do table.insert(charset, string.char(i)) end
for i = 97, 122 do table.insert(charset, string.char(i)) end

function string.random(length)
    math.randomseed(os.time())

    if length > 0 then
        return string.random(length - 1) .. charset[math.random(1, #charset)]
    else
        return ""
    end
end

function wait(seconds)
    local start = os.clock()
    repeat until os.clock() > start + seconds
end

while true do
    local randoms = {}

    for i = 1, 6 do 
        wait(1)
        randomstring = string.random(1)
        randomnum = math.random(0,9)
        print(randomnum, randomstring)
        if i == 1 or i == 3 or i == 5 then
            table.insert(randoms, randomstring)
        else
            table.insert(randoms, randomnum)
        end
    end
    local randomstring = tostring(table.concat(randoms))
    local args = "start https://prnt.sc/"..randomstring

    os.execute(args)
end
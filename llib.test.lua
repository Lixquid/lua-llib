local llib = require("llib")

do
    local indent = 0
    function describe(name, fn)
        print(name)
        indent = indent + 1
        local ok, err = pcall(fn)
        if not ok then
            print(("    "):rep(indent) .. err)
        end
        indent = indent - 1
    end

    function assertFail(msg)
        error("Failed assertion " .. (msg or ""), 2)
    end

    function assertTrue(cond, msg)
        if not cond then
            error("Condition not true " .. (msg or ""), 2)
        end
    end

    function assertFalse(cond, msg)
        if cond then
            error("Condition not false " .. (msg or ""), 2)
        end
    end

    function assertEqual(actual, expected, msg)
        if actual ~= expected then
            error(tostring(actual) .. " is not equal to " .. tostring(expected) .. " " .. (msg or ""), 2)
        end
    end

    function assertEqualDeep(actual, expected, msg)
        for k, v in pairs(actual) do
            if type(v) == "table" and type(expected[v]) == "table" then
                assertEqualDeep(v, expected[v], msg)
            else
                if v ~= expected[k] then
                    error(tostring(actual) .. "[" .. tostring(k) ..
                        "] is not equal to " .. tostring(expected) .. "[" ..
                        tostring(k) .. "] " .. (msg or ""), 2)
                end
            end
        end
    end
end

describe("llib.util.truthy", function()
    local f = llib.util.truthy
    assertFalse(f())
    assertFalse(f(false))
    assertFalse(f(0))
    assertTrue(f(5))
    assertTrue(f(-5))
    assertFalse(f(""))
    assertFalse(f("0"))
    assertFalse(f("false"))
    assertTrue(f("true"))
    assertTrue(f("hello"))
    assertFalse(f({}))
    assertTrue(f({1}))
    assertTrue(f({a = 1}))
end)

describe("llib.math.clamp", function()
    local f = llib.math.clamp
    assertEqual(f(0, 5, 10), 5)
    assertEqual(f(0, -5, 10), 0)
    assertEqual(f(0, 15, 10), 10)
    assertEqual(f(-2.2, -5, 0), -2.2)
end)

describe("llib.math.lerp", function()
    local f = llib.math.lerp
    assertEqual(f(0, 10, -1), 0)
    assertEqual(f(0, 10, 0), 0)
    assertEqual(f(0, 10, 0.5), 5)
    assertEqual(f(0, 10, 1), 10)
    assertEqual(f(0, 10, 2), 10)
end)

describe("llib.math.round", function()
    local f = llib.math.round
    assertEqual(f(5.2), 5)
    assertEqual(f(5.5), 6)
    assertEqual(f(5), 5)
    assertEqual(f(-1.2), -1)
    assertEqual(f(-1.5), -1)

    assertEqual(f(5.12, 1), 5.1)
    assertEqual(f(5.17, 1), 5.2)
    assertEqual(f(152, -1), 150)
    assertEqual(f(-157, -1), -160)
end)

describe("llib.math.isNaN", function()
    local f = llib.math.isNaN
    assertFalse(f(5))
    assertTrue(f(0/0))
end)

describe("llib.string.comma", function()
    local f = llib.string.comma
    assertEqual(f(100), "100")
    assertEqual(f(1000), "1,000")
    assertEqual(f(10000), "10,000")
    assertEqual(f(1000000), "1,000,000")
    assertEqual(f(100.15), "100.15")
    assertEqual(f(1000.15), "1,000.15")

    assertEqual(f(1000, "."), "1.000")
    assertEqual(f(1000000, "."), "1.000.000")

    assertEqual(f(10000, ",", 4), "1,0000")
    assertEqual(f(10000.15, ",", 4), "1,0000.15")
end)

describe("llib.string.ordinal", function()
    local f = llib.string.ordinal
    assertEqual(f(1), "st")
    assertEqual(f(2), "nd")
    assertEqual(f(3), "rd")
    assertEqual(f(4), "th")
    assertEqual(f(8), "th")
    assertEqual(f(108), "th")
    assertEqual(f(101), "st")
    assertEqual(f(11), "th")
    assertEqual(f(111), "th")
end)

describe("llib.string.metricSI", function()
    local f = llib.string.metricSI
    assertEqualDeep({f(1)}, {1, "", ""})
    assertEqualDeep({f(1000)}, {1, "k", "kilo"})
    assertEqualDeep({f(1230000)}, {1.23, "M", "mega"})
    assertEqualDeep({f(0.004)}, {4, "m", "milli"})

    assertEqualDeep({f(1024, 1024)}, {1, "k", "kilo"})
    assertEqualDeep({f(8, 2)}, {1, "G", "giga"})
end)

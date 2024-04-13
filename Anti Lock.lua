getgenv().Kirbsware = {
    AimViewer = {
        ["Enabled"] = (true),
        ["Keybind"] = "T",
        ["Width"] = (0.2), -- keep like this if you do not wanna have it thick
        ["Color"] = {R = (250); G = (0); B = (0)},
    },
    Version = {
        ["Gui"] = (false), --// gui or not. 
    },
    Underground = {
        ["Enabled"] = (true), -- makes them aim Underground
        ["Keybind"] = "Z",
    },
    Sky = {
        ["Enabled"] = (true), -- makes them aim the sky
        ["Keybind"] = "N",
    },
    PredictionBreaker = {
        ["Enabled"] = (true), -- breaks the prediction
        ["Keybind"] = "C",
    },
    VelocityMultiplier = {
        ["Enabled"] = (true), -- multiplies the prediction
        ["Keybind"] = "V",
        ["Power"] = (5),
    },
    Mouse_Control = {
        ["Enabled"] = (true),
        ["Keybind"] = "B",
    }
}

loadstring(game:HttpGet'http://kirbsware.xyz/r/Free.lua')()

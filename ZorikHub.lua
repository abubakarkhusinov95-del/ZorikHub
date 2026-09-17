-- ═══════════════════════════════════════════════════════
-- ⭐ ZorikHub Blox Strike v13 ⭐
-- 📱 Telegram: @ZorikHub
-- 🎁 ESP всем через FREE TRIAL | 🔒 Аим/Хитбокс по ключу
-- ═══════════════════════════════════════════════════════
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

-- ═══════════════════════════════════════════════════════
-- 🔒 КЛЮЧИ (base64)
-- ═══════════════════════════════════════════════════════
local _k = {
    ["Wm9yaWs="] = {d=7, t="wh"},
    ["Wm9yaWtQcmVtbWl1bQ=="] = {d=14, t="full"},
    ["Wm9yaWtIdWI5Nzg="] = {d=60, t="full"},
    ["Wm9yaWtfMWQ="] = {d=1, t="full"},
    ["Wm9yaWtfM2Q="] = {d=3, t="full"},
    ["Wm9yaWtfNWQ="] = {d=5, t="full"},
    ["Wm9yaWtfN2Q="] = {d=7, t="full"},
    ["Wm9yaWtfMTBk"] = {d=10, t="full"},
    ["Wm9yaWtfMTVk"] = {d=15, t="full"},
    ["Wm9yaWtfMjBk"] = {d=20, t="full"},
    ["Wm9yaWtfMjVk"] = {d=25, t="full"},
    ["Wm9yaWtfMzBk"] = {d=30, t="full"},
    ["Wm9yaWtfNDVk"] = {d=45, t="full"},
    ["Wm9yaWtfNjBk"] = {d=60, t="full"},
    ["Wm9yaWtfNzVk"] = {d=75, t="full"},
    ["Wm9yaWtfOTBk"] = {d=90, t="full"},
    ["Wm9yaWtfV0hfMzBk"] = {d=30, t="wh"},
    ["Wm9yaWtfV0hfOTBk"] = {d=90, t="wh"},
    ["Wm9yaWtfTGlmZV85OTk5ZA=="] = {d=9999, t="full"},
}

local B64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local function Decode(s)
    s = s:gsub("[^" .. B64 .. "=]", "")
    return (s:gsub('.', function(x)
        if x == '=' then return '' end
        local r, f = '', (B64:find(x) - 1)
        for i = 6, 1, -1 do
            r = r .. (f % 2^i - f % 2^(i-1) > 0 and '1' or '0')
        end
        return r
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if #x ~= 8 then return '' end
        local c = 0
        for i = 1, 8 do
            c = c + (x:sub(i, i) == '1' and 2^(8-i) or 0)
        end
        return string.char(c)
    end))
end

local function GetKeyData(inputKey)
    for encoded, data in pairs(_k) do
        if Decode(encoded) == inputKey then
            return data
        end
    end
    return nil
end

-- ═══════════════════════════════════════════════════════
-- СОХРАНЕНИЕ
-- ═══════════════════════════════════════════════════════
local HAS_FILES = writefile and readfile and isfile

local function SaveKey(key, expiry)
    if not HAS_FILES then return end
    pcall(function()
        writefile("ZH_k.txt", key)
        writefile("ZH_t.txt", tostring(expiry))
    end)
end

local function LoadKey()
    if not HAS_FILES then return nil end
    local r = nil
    pcall(function()
        if isfile("ZH_k.txt") and isfile("ZH_t.txt") then
            local k = readfile("ZH_k.txt")
            local t = tonumber(readfile("ZH_t.txt"))
            if k and t then r = {key = k, time = t} end
        end
    end)
    return r
end

local function DeleteKey()
    if not HAS_FILES then return end
    pcall(function()
        if isfile("ZH_k.txt") then delfile("ZH_k.txt") end
        if isfile("ZH_t.txt") then delfile("ZH_t.txt") end
    end)
end

-- ═══════════════════════════════════════════════════════
-- СОСТОЯНИЕ
-- ═══════════════════════════════════════════════════════
local HAS_KEY = false
local FREE_TRIAL = false
local CURRENT_KEY = nil
local MY_NAME = LP.Name

local function ActivateKey(inputKey)
    if not inputKey or inputKey == "" then return false, "❌ Введи ключ" end
    local data = GetKeyData(inputKey)
    if not data then return false, "❌ Неверный ключ" end
    local now = os.time()
    local expiry = now + (data.d * 86400)
    SaveKey(inputKey, expiry)
    CURRENT_KEY = {key = inputKey, type = data.t, expiry = expiry}
    HAS_KEY = true
    FREE_TRIAL = false
    return true, "✅ Активирован на " .. data.d .. " дней"
end

local function ValidateSaved()
    local s = LoadKey()
    if not s then return false end
    if os.time() >= s.time then
        DeleteKey()
        return false
    end
    local data = GetKeyData(s.key)
    if not data then
        DeleteKey()
        return false
    end
    CURRENT_KEY = {key = s.key, type = data.t, expiry = s.time}
    HAS_KEY = true
    return true
end

local function TimeLeft()
    if not CURRENT_KEY then return "—" end
    local diff = CURRENT_KEY.expiry - os.time()
    if diff <= 0 then return "Истёк" end
    local d = math.floor(diff / 86400)
    local h = math.floor((diff % 86400) / 3600)
    if d > 0 then return d .. "д " .. h .. "ч" end
    local m = math.floor((diff % 3600) / 60)
    if h > 0 then return h .. "ч " .. m .. "м" end
    return m .. "мин"
end

-- ═══════════════════════════════════════════════════════
-- GUI
-- ═══════════════════════════════════════════════════════
local old = LP.PlayerGui:FindFirstChild("ZorikHub")
if old then old:Destroy() end

local SG = Instance.new("ScreenGui")
SG.Name = "ZorikHub"
SG.ResetOnSpawn = false
SG.IgnoreGuiInset = true
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.Parent = LP:WaitForChild("PlayerGui")

local Blur = Instance.new("BlurEffect")
Blur.Size = 12
Blur.Parent = game.Lighting

-- ═══════════════════════════════════════════════════════
-- ЭКРАН КЛЮЧА
-- ═══════════════════════════════════════════════════════
local function ShowKeyScreen()
    local KS = Instance.new("Frame")
    KS.Size = UDim2.new(0, 420, 0, 340)
    KS.Position = UDim2.new(0.5, -210, 0.5, -170)
    KS.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
    KS.BorderSizePixel = 0
    KS.ZIndex = 500
    KS.Parent = SG
    Instance.new("UICorner", KS).CornerRadius = UDim.new(0, 18)

    local St = Instance.new("UIStroke")
    St.Color = Color3.fromRGB(255, 60, 110)
    St.Thickness = 3
    St.Parent = KS

    local Gr = Instance.new("UIGradient")
    Gr.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 60, 110)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 100, 180)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 60, 255))
    })
    Gr.Rotation = 45
    Gr.Parent = St

    -- Заголовок
    local T = Instance.new("TextLabel")
    T.Size = UDim2.new(1, 0, 0, 50)
    T.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
    T.Text = "🔑 ZorikHub"
    T.TextColor3 = Color3.fromRGB(255, 255, 255)
    T.TextSize = 20
    T.Font = Enum.Font.GothamBold
    T.BorderSizePixel = 0
    T.ZIndex = 501
    T.Parent = KS
    Instance.new("UICorner", T).CornerRadius = UDim.new(0, 18)

    -- Поле ввода ключа
    local Inp = Instance.new("TextBox")
    Inp.Size = UDim2.new(1, -40, 0, 50)
    Inp.Position = UDim2.new(0, 20, 0, 65)
    Inp.BackgroundColor3 = Color3.fromRGB(30, 30, 48)
    Inp.PlaceholderText = "Введи ключ..."
    Inp.Text = ""
    Inp.TextColor3 = Color3.fromRGB(255, 255, 255)
    Inp.PlaceholderColor3 = Color3.fromRGB(130, 130, 160)
    Inp.TextSize = 16
    Inp.Font = Enum.Font.GothamBold
    Inp.ClearTextOnFocus = false
    Inp.BorderSizePixel = 0
    Inp.ZIndex = 501
    Inp.Parent = KS
    Instance.new("UICorner", Inp).CornerRadius = UDim.new(0, 10)

    -- Кнопка активации
    local AB = Instance.new("TextButton")
    AB.Size = UDim2.new(1, -40, 0, 48)
    AB.Position = UDim2.new(0, 20, 0, 125)
    AB.BackgroundColor3 = Color3.fromRGB(255, 60, 110)
    AB.Text = "🔓 АКТИВИРОВАТЬ КЛЮЧ"
    AB.TextColor3 = Color3.fromRGB(255, 255, 255)
    AB.TextSize = 16
    AB.Font = Enum.Font.GothamBold
    AB.BorderSizePixel = 0
    AB.ZIndex = 501
    AB.Parent = KS
    Instance.new("UICorner", AB).CornerRadius = UDim.new(0, 10)

    -- Статус
    local S = Instance.new("TextLabel")
    S.Size = UDim2.new(1, -40, 0, 25)
    S.Position = UDim2.new(0, 20, 0, 180)
    S.BackgroundTransparency = 1
    S.Text = ""
    S.TextColor3 = Color3.fromRGB(0, 255, 100)
    S.TextSize = 12
    S.Font = Enum.Font.GothamBold
    S.ZIndex = 501
    S.Parent = KS

    -- Разделитель
    local Div = Instance.new("Frame")
    Div.Size = UDim2.new(1, -60, 0, 1)
    Div.Position = UDim2.new(0, 30, 0, 215)
    Div.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    Div.BorderSizePixel = 0
    Div.ZIndex = 501
    Div.Parent = KS

    -- 🔥 FREE TRIAL КНОПКА
    local FT = Instance.new("TextButton")
    FT.Size = UDim2.new(1, -40, 0, 48)
    FT.Position = UDim2.new(0, 20, 0, 230)
    FT.BackgroundColor3 = Color3.fromRGB(0, 150, 90)
    FT.Text = "🎁 FREE TRIAL (ESP)"
    FT.TextColor3 = Color3.fromRGB(255, 255, 255)
    FT.TextSize = 15
    FT.Font = Enum.Font.GothamBold
    FT.BorderSizePixel = 0
    FT.ZIndex = 501
    FT.Parent = KS
    Instance.new("UICorner", FT).CornerRadius = UDim.new(0, 10)

    -- Свечение на FREE TRIAL
    local FTS = Instance.new("UIStroke")
    FTS.Color = Color3.fromRGB(0, 255, 150)
    FTS.Thickness = 2
    FTS.Transparency = 0.3
    FTS.Parent = FT

    -- Пульсация
    task.spawn(function()
        while FT.Parent do
            TS:Create(FTS, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.85}):Play()
            task.wait(1.2)
            TS:Create(FTS, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.3}):Play()
            task.wait(1.2)
        end
    end)

    -- Подпись под кнопкой
    local FTSub = Instance.new("TextLabel")
    FTSub.Size = UDim2.new(1, -40, 0, 20)
    FTSub.Position = UDim2.new(0, 20, 0, 282)
    FTSub.BackgroundTransparency = 1
    FTSub.Text = "📱 Полный доступ: @ZorikHub"
    FTSub.TextColor3 = Color3.fromRGB(100, 200, 255)
    FTSub.TextSize = 11
    FTSub.Font = Enum.Font.GothamBold
    FTSub.ZIndex = 501
    FTSub.Parent = KS

    -- Версия
    local V = Instance.new("TextLabel")
    V.Size = UDim2.new(1, -40, 0, 18)
    V.Position = UDim2.new(0, 20, 0, 308)
    V.BackgroundTransparency = 1
    V.Text = "ZorikHub v13"
    V.TextColor3 = Color3.fromRGB(120, 120, 140)
    V.TextSize = 10
    V.Font = Enum.Font.GothamMedium
    V.ZIndex = 501
    V.Parent = KS

    -- Активация ключа
    local function Try()
        local ok, msg = ActivateKey(Inp.Text)
        S.Text = msg
        if ok then
            S.TextColor3 = Color3.fromRGB(0, 255, 100)
            task.wait(1.5)
            KS:Destroy()
            if Blur then Blur:Destroy() Blur = nil end
            BuildMenu()
        else
            S.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end

    AB.MouseButton1Click:Connect(Try)
    Inp.FocusLost:Connect(function(e) if e then Try() end end)

    -- FREE TRIAL
    FT.MouseButton1Click:Connect(function()
        HAS_KEY = false
        FREE_TRIAL = true
        KS:Destroy()
        if Blur then Blur:Destroy() Blur = nil end
        BuildMenu()
    end)
end

-- ═══════════════════════════════════════════════════════
-- НАСТРОЙКИ
-- ═══════════════════════════════════════════════════════
_G.Z = {
    Aim=false, Silent=false, Legit=false,
    Team=true, Wall=true, FOV=300, Smooth=5, AimPart="Head",
    ESP=false, Name=true, Dist=true, Box=false,
    Hitbox=false, HitboxSize=25,
    Fly=false, FlySpeed=50
}

-- ═══════════════════════════════════════════════════════
-- МЕНЮ
-- ═══════════════════════════════════════════════════════
function BuildMenu()
    local FovC = Instance.new("Frame")
    FovC.BackgroundTransparency = 1
    FovC.Visible = false
    FovC.ZIndex = 5
    FovC.Parent = SG
    local FS = Instance.new("UIStroke")
    FS.Color = Color3.fromRGB(255, 60, 110)
    FS.Thickness = 2
    FS.Transparency = 0.3
    FS.Parent = FovC
    Instance.new("UICorner", FovC).CornerRadius = UDim.new(1, 0)

    local ZBtn = Instance.new("TextButton")
    ZBtn.Size = UDim2.new(0, 55, 0, 55)
    ZBtn.Position = UDim2.new(0, 15, 0, 200)
    ZBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ZBtn.Text = "Z"
    ZBtn.TextColor3 = Color3.fromRGB(255, 60, 110)
    ZBtn.TextSize = 26
    ZBtn.Font = Enum.Font.GothamBlack
    ZBtn.BorderSizePixel = 0
    ZBtn.Draggable = true
    ZBtn.ZIndex = 100
    ZBtn.Parent = SG
    Instance.new("UICorner", ZBtn).CornerRadius = UDim.new(1, 0)

    local ZG = Instance.new("UIGradient")
    ZG.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 60, 110)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 60, 255))
    })
    ZG.Parent = ZBtn

    local ZS = Instance.new("UIStroke")
    ZS.Color = Color3.fromRGB(255, 255, 255)
    ZS.Thickness = 3
    ZS.Transparency = 0.3
    ZS.Parent = ZBtn

    local Stat = Instance.new("TextLabel")
    Stat.Size = UDim2.new(0, 220, 0, 25)
    Stat.Position = UDim2.new(0, 15, 0, 265)
    Stat.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
    Stat.BackgroundTransparency = 0.3
    if HAS_KEY then
        Stat.Text = "🔒 " .. MY_NAME .. " | ⏰ " .. TimeLeft()
        Stat.TextColor3 = Color3.fromRGB(100, 255, 150)
    elseif FREE_TRIAL then
        Stat.Text = "🎁 FREE TRIAL • ESP"
        Stat.TextColor3 = Color3.fromRGB(0, 255, 150)
    else
        Stat.Text = "🎁 ESP Free Mode"
        Stat.TextColor3 = Color3.fromRGB(255, 200, 100)
    end
    Stat.TextSize = 11
    Stat.Font = Enum.Font.GothamBold
    Stat.ZIndex = 100
    Stat.Parent = SG
    Instance.new("UICorner", Stat).CornerRadius = UDim.new(0, 6)

    local M = Instance.new("Frame")
    M.Size = UDim2.new(0, 700, 0, 480)
    M.Position = UDim2.new(0.5, -350, 0.5, -240)
    M.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
    M.BorderSizePixel = 0
    M.Visible = false
    M.ZIndex = 50
    M.Parent = SG
    Instance.new("UICorner", M).CornerRadius = UDim.new(0, 18)

    local MS = Instance.new("UIStroke")
    MS.Color = Color3.fromRGB(255, 60, 110)
    MS.Thickness = 2
    MS.Transparency = 0.2
    MS.Parent = M

    local H = Instance.new("Frame")
    H.Size = UDim2.new(1, 0, 0, 60)
    H.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
    H.BorderSizePixel = 0
    H.ZIndex = 51
    H.Parent = M
    Instance.new("UICorner", H).CornerRadius = UDim.new(0, 18)

    local HF = Instance.new("Frame")
    HF.Size = UDim2.new(1, 0, 0, 20)
    HF.Position = UDim2.new(0, 0, 1, -20)
    HF.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
    HF.BorderSizePixel = 0
    HF.ZIndex = 51
    HF.Parent = H

    local HG = Instance.new("UIGradient")
    HG.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 60, 110)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 60, 255))
    })
    HG.Parent = H

    local Logo = Instance.new("Frame")
    Logo.Size = UDim2.new(0, 44, 0, 44)
    Logo.Position = UDim2.new(0, 12, 0.5, -22)
    Logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Logo.BorderSizePixel = 0
    Logo.ZIndex = 52
    Logo.Parent = H
    Instance.new("UICorner", Logo).CornerRadius = UDim.new(1, 0)

    local LT = Instance.new("TextLabel")
    LT.Size = UDim2.new(1, 0, 1, 0)
    LT.BackgroundTransparency = 1
    LT.Text = "Z"
    LT.TextColor3 = Color3.fromRGB(255, 60, 110)
    LT.TextSize = 24
    LT.Font = Enum.Font.GothamBlack
    LT.ZIndex = 53
    LT.Parent = Logo

    local Ti = Instance.new("TextLabel")
    Ti.Size = UDim2.new(1, -220, 0, 26)
    Ti.Position = UDim2.new(0, 65, 0, 10)
    Ti.BackgroundTransparency = 1
    Ti.Text = "ZorikHub v13"
    Ti.TextColor3 = Color3.fromRGB(255, 255, 255)
    Ti.TextXAlignment = Enum.TextXAlignment.Left
    Ti.TextSize = 20
    Ti.Font = Enum.Font.GothamBold
    Ti.ZIndex = 52
    Ti.Parent = H

    local Au = Instance.new("TextLabel")
    Au.Size = UDim2.new(1, -220, 0, 20)
    Au.Position = UDim2.new(0, 65, 0, 36)
    Au.BackgroundTransparency = 1
    if HAS_KEY then
        Au.Text = "📱 @ZorikHub | 🔒 Premium"
        Au.TextColor3 = Color3.fromRGB(100, 200, 255)
    elseif FREE_TRIAL then
        Au.Text = "📱 @ZorikHub | 🎁 FREE TRIAL"
        Au.TextColor3 = Color3.fromRGB(0, 255, 150)
    else
        Au.Text = "📱 @ZorikHub | 🎁 Free"
        Au.TextColor3 = Color3.fromRGB(255, 200, 100)
    end
    Au.TextXAlignment = Enum.TextXAlignment.Left
    Au.TextSize = 12
    Au.Font = Enum.Font.GothamBold
    Au.ZIndex = 52
    Au.Parent = H

    local XB = Instance.new("TextButton")
    XB.Size = UDim2.new(0, 36, 0, 36)
    XB.Position = UDim2.new(1, -48, 0.5, -18)
    XB.BackgroundColor3 = Color3.fromRGB(255, 60, 80)
    XB.Text = "✕"
    XB.TextColor3 = Color3.fromRGB(255, 255, 255)
    XB.TextSize = 16
    XB.Font = Enum.Font.GothamBold
    XB.BorderSizePixel = 0
    XB.ZIndex = 52
    XB.Parent = H
    Instance.new("UICorner", XB).CornerRadius = UDim.new(0, 10)

    local Sb = Instance.new("Frame")
    Sb.Size = UDim2.new(0, 130, 1, -80)
    Sb.Position = UDim2.new(0, 10, 0, 70)
    Sb.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
    Sb.BorderSizePixel = 0
    Sb.ZIndex = 51
    Sb.Parent = M
    Instance.new("UICorner", Sb).CornerRadius = UDim.new(0, 12)

    local SL = Instance.new("UIListLayout")
    SL.Padding = UDim.new(0, 6)
    SL.SortOrder = Enum.SortOrder.LayoutOrder
    SL.Parent = Sb

    local SP = Instance.new("UIPadding")
    SP.PaddingTop = UDim.new(0, 8)
    SP.PaddingLeft = UDim.new(0, 6)
    SP.PaddingRight = UDim.new(0, 6)
    SP.Parent = Sb

    local C = Instance.new("Frame")
    C.Size = UDim2.new(1, -155, 1, -80)
    C.Position = UDim2.new(0, 150, 0, 70)
    C.BackgroundTransparency = 1
    C.ZIndex = 51
    C.Parent = M

    local Pg = {}
    local TB = {}

    local function MakeTab(n, i, o)
        local B = Instance.new("TextButton")
        B.Size = UDim2.new(1, 0, 0, 42)
        B.BackgroundColor3 = Color3.fromRGB(32, 32, 50)
        B.Text = "  " .. i .. "  " .. n
        B.TextColor3 = Color3.fromRGB(170, 170, 200)
        B.TextXAlignment = Enum.TextXAlignment.Left
        B.TextSize = 14
        B.Font = Enum.Font.GothamBold
        B.BorderSizePixel = 0
        B.LayoutOrder = o
        B.ZIndex = 52
        B.Parent = Sb
        Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8)

        local P = Instance.new("ScrollingFrame")
        P.Size = UDim2.new(1, 0, 1, 0)
        P.BackgroundTransparency = 1
        P.BorderSizePixel = 0
        P.ScrollBarThickness = 6
        P.ScrollBarImageColor3 = Color3.fromRGB(255, 60, 110)
        P.CanvasSize = UDim2.new(0, 0, 0, 0)
        P.Visible = false
        P.ZIndex = 52
        P.Parent = C
        P.Active = true
        P.Selectable = true

        local L = Instance.new("UIListLayout")
        L.Padding = UDim.new(0, 6)
        L.SortOrder = Enum.SortOrder.LayoutOrder
        L.Parent = P

        local Pd = Instance.new("UIPadding")
        Pd.PaddingTop = UDim.new(0, 4)
        Pd.PaddingLeft = UDim.new(0, 4)
        Pd.PaddingRight = UDim.new(0, 4)
        Pd.PaddingBottom = UDim.new(0, 15)
        Pd.Parent = P

        L:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            P.CanvasSize = UDim2.new(0, 0, 0, L.AbsoluteContentSize.Y + 15)
        end)

        B.MouseButton1Click:Connect(function()
            for _, pg in pairs(Pg) do pg.Visible = false end
            for _, tb in pairs(TB) do
                TS:Create(tb, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(32, 32, 50)}):Play()
                tb.TextColor3 = Color3.fromRGB(170, 170, 200)
            end
            P.Visible = true
            TS:Create(B, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(255, 60, 110)}):Play()
            B.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        Pg[n] = P
        TB[n] = B
        return P
    end

    local function Sec(p, t, o)
        local F = Instance.new("Frame")
        F.Size = UDim2.new(1, -8, 0, 26)
        F.BackgroundTransparency = 1
        F.LayoutOrder = o
        F.Parent = p
        local L = Instance.new("TextLabel")
        L.Size = UDim2.new(1, 0, 1, 0)
        L.Position = UDim2.new(0, 6, 0, 0)
        L.BackgroundTransparency = 1
        L.Text = "▸ " .. t
        L.TextColor3 = Color3.fromRGB(255, 150, 180)
        L.TextXAlignment = Enum.TextXAlignment.Left
        L.TextSize = 12
        L.Font = Enum.Font.GothamBold
        L.Parent = F
    end

    local function LockMsg()
        local N = Instance.new("TextLabel")
        N.Size = UDim2.new(0, 320, 0, 70)
        N.Position = UDim2.new(0.5, -160, 0.5, -35)
        N.BackgroundColor3 = Color3.fromRGB(200, 30, 50)
        N.Text = "🔒 Premium функция!\n📱 Купить ключ: @ZorikHub"
        N.TextColor3 = Color3.fromRGB(255, 255, 255)
        N.TextSize = 14
        N.Font = Enum.Font.GothamBold
        N.TextWrapped = true
        N.ZIndex = 999
        N.Parent = SG
        Instance.new("UICorner", N).CornerRadius = UDim.new(0, 12)
        task.wait(2)
        N:Destroy()
    end

    local function Tg(p, t, d, o, cb, rk)
        local F = Instance.new("Frame")
        F.Size = UDim2.new(1, -8, 0, 40)
        F.BackgroundColor3 = Color3.fromRGB(26, 26, 42)
        F.BorderSizePixel = 0
        F.LayoutOrder = o
        F.Parent = p
        Instance.new("UICorner", F).CornerRadius = UDim.new(0, 8)

        local L = Instance.new("TextLabel")
        L.Size = UDim2.new(0.7, 0, 1, 0)
        L.Position = UDim2.new(0, 12, 0, 0)
        L.BackgroundTransparency = 1
        if rk and not HAS_KEY then
            L.Text = "🔒 " .. t
            L.TextColor3 = Color3.fromRGB(120, 120, 140)
        else
            L.Text = t
            L.TextColor3 = Color3.fromRGB(230, 230, 245)
        end
        L.TextXAlignment = Enum.TextXAlignment.Left
        L.TextSize = 13
        L.Font = Enum.Font.GothamMedium
        L.Parent = F

        local B = Instance.new("TextButton")
        B.Size = UDim2.new(0, 54, 0, 26)
        B.Position = UDim2.new(1, -62, 0.5, -13)
        B.BackgroundColor3 = d and Color3.fromRGB(0, 220, 100) or Color3.fromRGB(55, 55, 80)
        B.Text = d and "ON" or "OFF"
        B.TextColor3 = Color3.fromRGB(255, 255, 255)
        B.TextSize = 11
        B.Font = Enum.Font.GothamBold
        B.BorderSizePixel = 0
        B.Parent = F
        Instance.new("UICorner", B).CornerRadius = UDim.new(1, 0)

        local s = d
        B.MouseButton1Click:Connect(function()
            if rk and not HAS_KEY then
                LockMsg()
                return
            end
            s = not s
            TS:Create(B, TweenInfo.new(0.15), {BackgroundColor3 = s and Color3.fromRGB(0, 220, 100) or Color3.fromRGB(55, 55, 80)}):Play()
            B.Text = s and "ON" or "OFF"
            cb(s)
        end)
    end

    local function Sl(p, t, mn, mx, df, o, cb, rk)
        local F = Instance.new("Frame")
        F.Size = UDim2.new(1, -8, 0, 58)
        F.BackgroundColor3 = Color3.fromRGB(26, 26, 42)
        F.BorderSizePixel = 0
        F.LayoutOrder = o
        F.Parent = p
        Instance.new("UICorner", F).CornerRadius = UDim.new(0, 8)

        local L = Instance.new("TextLabel")
        L.Size = UDim2.new(0.6, 0, 0, 20)
        L.Position = UDim2.new(0, 12, 0, 6)
        L.BackgroundTransparency = 1
        if rk and not HAS_KEY then
            L.Text = "🔒 " .. t
            L.TextColor3 = Color3.fromRGB(120, 120, 140)
        else
            L.Text = t
            L.TextColor3 = Color3.fromRGB(230, 230, 245)
        end
        L.TextXAlignment = Enum.TextXAlignment.Left
        L.TextSize = 13
        L.Font = Enum.Font.GothamMedium
        L.Parent = F

        local V = Instance.new("TextLabel")
        V.Size = UDim2.new(0.3, 0, 0, 20)
        V.Position = UDim2.new(0.65, 0, 0, 6)
        V.BackgroundTransparency = 1
        V.Text = tostring(df)
        V.TextColor3 = Color3.fromRGB(255, 100, 150)
        V.TextSize = 13
        V.Font = Enum.Font.GothamBold
        V.Parent = F

        local Hd = Instance.new("TextButton")
        Hd.Size = UDim2.new(1, -24, 0, 22)
        Hd.Position = UDim2.new(0, 12, 0, 32)
        Hd.BackgroundTransparency = 1
        Hd.Text = ""
        Hd.Parent = F

        local Br = Instance.new("Frame")
        Br.Size = UDim2.new(1, 0, 0, 6)
        Br.Position = UDim2.new(0, 0, 0.5, -3)
        Br.BackgroundColor3 = Color3.fromRGB(50, 50, 75)
        Br.BorderSizePixel = 0
        Br.Parent = Hd
        Instance.new("UICorner", Br).CornerRadius = UDim.new(1, 0)

        local Fi = Instance.new("Frame")
        Fi.Size = UDim2.new((df - mn) / (mx - mn), 0, 1, 0)
        Fi.BackgroundColor3 = Color3.fromRGB(255, 60, 110)
        Fi.BorderSizePixel = 0
        Fi.Parent = Br
        Instance.new("UICorner", Fi).CornerRadius = UDim.new(1, 0)

        local dg = false
        local function Upd(x)
            if rk and not HAS_KEY then return end
            local pos = math.clamp((x - Br.AbsolutePosition.X) / Br.AbsoluteSize.X, 0, 1)
            local val = math.floor(mn + (mx - mn) * pos + 0.5)
            Fi.Size = UDim2.new(pos, 0, 1, 0)
            V.Text = tostring(val)
            cb(val)
        end
        Hd.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                if rk and not HAS_KEY then
                    LockMsg()
                    return
                end
                dg = true
                Upd(i.Position.X)
            end
        end)
        Hd.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dg = false
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if dg and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                Upd(i.Position.X)
            end
        end)
    end

    local function Dd(p, t, opts, df, o, cb, rk)
        local F = Instance.new("Frame")
        F.Size = UDim2.new(1, -8, 0, 40)
        F.BackgroundColor3 = Color3.fromRGB(26, 26, 42)
        F.BorderSizePixel = 0
        F.LayoutOrder = o
        F.Parent = p
        Instance.new("UICorner", F).CornerRadius = UDim.new(0, 8)

        local L = Instance.new("TextLabel")
        L.Size = UDim2.new(0.45, 0, 1, 0)
        L.Position = UDim2.new(0, 12, 0, 0)
        L.BackgroundTransparency = 1
        if rk and not HAS_KEY then
            L.Text = "🔒 " .. t
            L.TextColor3 = Color3.fromRGB(120, 120, 140)
        else
            L.Text = t
            L.TextColor3 = Color3.fromRGB(230, 230, 245)
        end
        L.TextXAlignment = Enum.TextXAlignment.Left
        L.TextSize = 13
        L.Font = Enum.Font.GothamMedium
        L.Parent = F

        local B = Instance.new("TextButton")
        B.Size = UDim2.new(0.45, 0, 0, 28)
        B.Position = UDim2.new(0.53, 0, 0.5, -14)
        B.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
        B.Text = df
        B.TextColor3 = Color3.fromRGB(255, 255, 255)
        B.TextSize = 12
        B.Font = Enum.Font.GothamBold
        B.BorderSizePixel = 0
        B.Parent = F
        Instance.new("UICorner", B).CornerRadius = UDim.new(0, 6)

        B.MouseButton1Click:Connect(function()
            if rk and not HAS_KEY then
                LockMsg()
                return
            end
            local lb = F:FindFirstChild("DL")
            if lb then lb:Destroy() return end
            lb = Instance.new("Frame")
            lb.Name = "DL"
            lb.Size = UDim2.new(0.45, 0, 0, #opts * 28 + 8)
            lb.Position = UDim2.new(0.53, 0, 1, 3)
            lb.BackgroundColor3 = Color3.fromRGB(35, 35, 52)
            lb.BorderSizePixel = 0
            lb.ZIndex = 60
            lb.Parent = F
            Instance.new("UICorner", lb).CornerRadius = UDim.new(0, 6)
            local LL = Instance.new("UIListLayout")
            LL.Padding = UDim.new(0, 2)
            LL.HorizontalAlignment = Enum.HorizontalAlignment.Center
            LL.Parent = lb
            local LP = Instance.new("UIPadding")
            LP.PaddingTop = UDim.new(0, 4)
            LP.Parent = lb
            for _, op in ipairs(opts) do
                local OB = Instance.new("TextButton")
                OB.Size = UDim2.new(1, -8, 0, 26)
                OB.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
                OB.Text = op
                OB.TextColor3 = Color3.fromRGB(255, 255, 255)
                OB.TextSize = 12
                OB.Font = Enum.Font.GothamBold
                OB.BorderSizePixel = 0
                OB.ZIndex = 61
                OB.Parent = lb
                Instance.new("UICorner", OB).CornerRadius = UDim.new(0, 4)
                OB.MouseButton1Click:Connect(function()
                    B.Text = op
                    lb:Destroy()
                    cb(op)
                end)
            end
        end)
    end

    local CombatT = MakeTab("Combat", "🎯", 1)
    local VisT = MakeTab("Visuals", "👁", 2)
    local MiscT = MakeTab("Misc", "⚙", 3)

    Sec(CombatT, "AIMBOT 🔒", 1)
    Tg(CombatT, "Aimbot Master", false, 2, function(s) _G.Z.Aim = s end, true)
    Tg(CombatT, "Silent Aim", false, 3, function(s) _G.Z.Silent = s end, true)
    Tg(CombatT, "Legit Aim", false, 4, function(s) _G.Z.Legit = s end, true)
    Tg(CombatT, "Team Check", true, 5, function(s) _G.Z.Team = s end, true)
    Tg(CombatT, "Wall Check", true, 6, function(s) _G.Z.Wall = s end, true)
    Dd(CombatT, "Aim Part", {"Head", "Torso", "HumanoidRootPart"}, "Head", 7, function(o) _G.Z.AimPart = o end, true)
    Sl(CombatT, "FOV", 50, 800, 300, 8, function(v) _G.Z.FOV = v end, true)
    Sl(CombatT, "Smoothness", 1, 20, 5, 9, function(v) _G.Z.Smooth = v end, true)

    Sec(VisT, "ESP 🎁 FREE TRIAL", 1)
    Tg(VisT, "ESP Master", false, 2, function(s) _G.Z.ESP = s end, false)
    Tg(VisT, "Name ESP", true, 3, function(s) _G.Z.Name = s end, false)
    Tg(VisT, "Distance ESP", true, 4, function(s) _G.Z.Dist = s end, false)
    Tg(VisT, "Box ESP", false, 5, function(s) _G.Z.Box = s end, false)

    Sec(VisT, "HITBOX 🔒", 6)
    Tg(VisT, "Hitbox Expander", false, 7, function(s) _G.Z.Hitbox = s end, true)
    Sl(VisT, "Head Size", 1, 50, 25, 8, function(v) _G.Z.HitboxSize = v end, true)

    Sec(MiscT, "MOVEMENT 🔒", 1)
    Tg(MiscT, "Fly", false, 2, function(s) _G.Z.Fly = s end, true)
    Sl(MiscT, "Fly Speed", 10, 200, 50, 3, function(v) _G.Z.FlySpeed = v end, true)

    Sec(MiscT, "INFO", 4)
    local Info = Instance.new("TextLabel")
    Info.Size = UDim2.new(1, -8, 0, 140)
    Info.BackgroundColor3 = Color3.fromRGB(26, 26, 42)
    Info.BackgroundTransparency = 0.3
    if HAS_KEY then
        Info.Text = "⭐ ZorikHub v13 ⭐\n📱 @ZorikHub\n\n🔒 Привязан к: " .. MY_NAME .. "\n⏰ Осталось: " .. TimeLeft() .. "\n\nLeftShift / Z = меню"
    else
        Info.Text = "⭐ ZorikHub v13 ⭐\n📱 @ZorikHub\n\n🎁 Режим: FREE TRIAL\n🔒 Аим/Хитбокс/Флай по ключу\n\nКупить: @ZorikHub"
    end
    Info.TextColor3 = Color3.fromRGB(230, 230, 245)
    Info.TextSize = 12
    Info.Font = Enum.Font.GothamMedium
    Info.TextWrapped = true
    Info.LayoutOrder = 5
    Info.Parent = MiscT
    Instance.new("UICorner", Info).CornerRadius = UDim.new(0, 8)

    Pg["Visuals"].Visible = true
    TB["Visuals"].BackgroundColor3 = Color3.fromRGB(255, 60, 110)
    TB["Visuals"].TextColor3 = Color3.fromRGB(255, 255, 255)

    local drag, ds, sp = false, nil, nil
    H.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = true
            ds = i.Position
            sp = M.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then drag = false end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - ds
            M.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
        end
    end)

    local open = false
    ZBtn.MouseButton1Click:Connect(function()
        open = not open
        M.Visible = open
    end)
    XB.MouseButton1Click:Connect(function()
        open = false
        M.Visible = false
    end)

    if not isMobile then
        UIS.InputBegan:Connect(function(i, g)
            if g then return end
            if i.KeyCode == Enum.KeyCode.LeftShift then
                open = not open
                M.Visible = open
            end
        end)
    end

    -- ═══ ИГРОВЫЕ ФУНКЦИИ ═══
    local function Alive(p)
        if not p or not p.Character then return false end
        local c = p.Character
        if c:GetAttribute("Dead") == true then return false end
        local h = c:FindFirstChildOfClass("Humanoid")
        if h and h.Health <= 0 then return false end
        local hd = c:FindFirstChild("Head")
        if not hd or not hd:IsDescendantOf(workspace) then return false end
        return true
    end

    local function Team(p)
        if not p then return nil end
        local t = p:GetAttribute("Team")
        if t then return tostring(t) end
        if p.Character then
            local ct = p.Character:GetAttribute("Team")
            if ct then return tostring(ct) end
        end
        if p.Team then return tostring(p.Team) end
        return nil
    end

    local function IsT(p)
        if not _G.Z.Team then return false end
        if p == LP then return true end
        local mt, pt = Team(LP), Team(p)
        if mt and pt then return mt == pt end
        return false
    end

    local function CanSee(pt)
        if not _G.Z.Wall then return true end
        local rp = RaycastParams.new()
        rp.FilterType = Enum.RaycastFilterType.Exclude
        rp.FilterDescendantsInstances = {LP.Character}
        local r = workspace:Raycast(Cam.CFrame.Position, pt.Position - Cam.CFrame.Position, rp)
        if not r then return true end
        return r.Instance:IsDescendantOf(pt.Parent)
    end

    local function Valid(p)
        if p == LP then return false end
        if not Alive(p) then return false end
        if IsT(p) then return false end
        local h = p.Character:FindFirstChild(_G.Z.AimPart or "Head") or p.Character:FindFirstChild("Head")
        if not h then return false end
        if (h.Position - Cam.CFrame.Position).Magnitude > 1500 then return false end
        if not CanSee(h) then return false end
        return true
    end

    local espO = {}
    local function ClrESP()
        for _, o in ipairs(espO) do pcall(function() o:Destroy() end) end
        espO = {}
    end

    local function ESP()
        ClrESP()
        if not _G.Z.ESP then return end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and Alive(p) then
                local hd = p.Character:FindFirstChild("Head")
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hd and hrp then
                    local t = IsT(p)
                    local c = t and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 60, 110)
                    local hl = Instance.new("Highlight")
                    hl.Adornee = p.Character
                    hl.FillColor = c
                    hl.FillTransparency = 0.5
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.OutlineTransparency = 0
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Parent = p.Character
                    table.insert(espO, hl)
                    if _G.Z.Box then
                        local b = Instance.new("BoxHandleAdornment")
                        b.Size = Vector3.new(3, 5, 2.5)
                        b.Adornee = hrp
                        b.Color3 = c
                        b.Transparency = 0.5
                        b.AlwaysOnTop = true
                        b.ZIndex = 5
                        b.Parent = hrp
                        table.insert(espO, b)
                    end
                    if _G.Z.Name or _G.Z.Dist then
                        local bg = Instance.new("BillboardGui")
                        bg.Size = UDim2.new(0, 150, 0, 60)
                        bg.StudsOffset = Vector3.new(0, 3, 0)
                        bg.Adornee = hd
                        bg.AlwaysOnTop = true
                        bg.Parent = hd
                        table.insert(espO, bg)
                        if _G.Z.Name then
                            local n = Instance.new("TextLabel")
                            n.Size = UDim2.new(1, 0, 0, 22)
                            n.BackgroundTransparency = 1
                            n.Text = p.Name .. (t and " ★" or "")
                            n.TextColor3 = c
                            n.TextStrokeTransparency = 0
                            n.TextScaled = true
                            n.Font = Enum.Font.GothamBold
                            n.Parent = bg
                        end
                        if _G.Z.Dist then
                            local d = Instance.new("TextLabel")
                            d.Size = UDim2.new(1, 0, 0, 18)
                            d.Position = UDim2.new(0, 0, 0, 26)
                            d.BackgroundTransparency = 1
                            d.Text = math.floor((Cam.CFrame.Position - hd.Position).Magnitude) .. "m"
                            d.TextColor3 = Color3.fromRGB(255, 255, 255)
                            d.TextStrokeTransparency = 0
                            d.TextScaled = true
                            d.Font = Enum.Font.Gotham
                            d.Parent = bg
                        end
                    end
                end
            end
        end
    end

    task.spawn(function()
        while task.wait(0.3) do pcall(ESP) end
    end)

    task.spawn(function()
        while task.wait(0.1) do
            if _G.Z.Hitbox and HAS_KEY then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LP and Alive(p) and not IsT(p) then
                        if p.Character then
                            for _, pt in ipairs(p.Character:GetDescendants()) do
                                if pt:IsA("BasePart") and pt.Name == "Head" then
                                    local s = _G.Z.HitboxSize
                                    if pt.Size.X ~= s then
                                        pt.Size = Vector3.new(s, s, s)
                                        pt.CanCollide = false
                                        pt.Massless = true
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)

    local function Tgt()
        local best, bd = nil, math.huge
        local c = Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y/2)
        for _, p in ipairs(Players:GetPlayers()) do
            if Valid(p) then
                local h = p.Character:FindFirstChild(_G.Z.AimPart or "Head") or p.Character:FindFirstChild("Head")
                if h then
                    local sp, on = Cam:WorldToViewportPoint(h.Position)
                    if on then
                        local d = (Vector2.new(sp.X, sp.Y) - c).Magnitude
                        if d <= _G.Z.FOV and d < bd then
                            bd = d
                            best = h
                        end
                    end
                end
            end
        end
        return best
    end

    RS.RenderStepped:Connect(function()
        if _G.Z.Aim and HAS_KEY then
            local s = _G.Z.FOV * 2
            FovC.Size = UDim2.new(0, s, 0, s)
            FovC.Position = UDim2.new(0.5, -s/2, 0.5, -s/2)
            FovC.Visible = true
        else
            FovC.Visible = false
        end
    end)

    RS:BindToRenderStep("ZAim", 201, function()
        if not _G.Z.Aim or not HAS_KEY then return end
        if not LP.Character then return end
        local h = Tgt()
        if not h then return end
        local tp = h.Position
        local mp = Cam.CFrame.Position
        if _G.Z.Silent then
            local o = Cam.CFrame
            Cam.CFrame = CFrame.new(o.Position, tp)
            task.spawn(function()
                task.wait()
                if Cam then Cam.CFrame = o end
            end)
        elseif _G.Z.Legit then
            local cd = Cam.CFrame.LookVector
            local td = (tp - mp).Unit
            local s = math.max(0.01, 1 / _G.Z.Smooth)
            Cam.CFrame = CFrame.new(mp, mp + cd:Lerp(td, s))
        else
            Cam.CFrame = CFrame.new(mp, tp)
        end
    end)

    RS.Heartbeat:Connect(function()
        pcall(function()
            local ch = LP.Character
            if not ch then return end
            local hm = ch:FindFirstChildOfClass("Humanoid")
            if not hm then return end
            if _G.Z.Fly and HAS_KEY then
                local hrp = ch:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local bv = hrp:FindFirstChild("ZFly")
                    if not bv then
                        bv = Instance.new("BodyVelocity")
                        bv.Name = "ZFly"
                        bv.MaxForce = Vector3.new(1,1,1)*9e9
                        bv.Parent = hrp
                    end
                    local spd = _G.Z.FlySpeed
                    local mv = Vector3.new(0,0,0)
                    if UIS:IsKeyDown(Enum.KeyCode.W) then mv = mv + hrp.CFrame.LookVector * spd end
                    if UIS:IsKeyDown(Enum.KeyCode.S) then mv = mv - hrp.CFrame.LookVector * spd end
                    if UIS:IsKeyDown(Enum.KeyCode.A) then mv = mv - hrp.CFrame.RightVector * spd end
                    if UIS:IsKeyDown(Enum.KeyCode.D) then mv = mv + hrp.CFrame.RightVector * spd end
                    if UIS:IsKeyDown(Enum.KeyCode.Space) then mv = mv + Vector3.new(0,spd,0) end
                    bv.Velocity = mv
                end
            else
                local hrp = ch:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local bv = hrp:FindFirstChild("ZFly")
                    if bv then bv:Destroy() end
                end
            end
        end)
    end)
end

-- ═══════════════════════════════════════════════════════
-- ЗАПУСК
-- ═══════════════════════════════════════════════════════
task.spawn(function()
    if ValidateSaved() then
        task.wait(0.3)
        if Blur then Blur:Destroy() Blur = nil end
        BuildMenu()
    else
        ShowKeyScreen()
    end
end)

print("═══ ZorikHub v13 ═══")
print("📱 @ZorikHub")

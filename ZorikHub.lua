-- ═══════════════════════════════════════════════════════
-- ⭐ ZorikHub Blox Strike v10 ⭐
-- 🔓 ESP БЕСПЛАТНО ДЛЯ ВСЕХ | 🔒 Остальное по ключу
-- 📱 Telegram: @ZorikHub
-- ═══════════════════════════════════════════════════════
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local HTTP = game:GetService("HttpService")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

-- ═══════════════════════════════════════════════════════
-- 🔒 KEY SYSTEM
-- ═══════════════════════════════════════════════════════
local KEYS_URL = "https://raw.githubusercontent.com/ТВОЙ_НИК/ZorikHub/main/keys.json"
local BINDS_URL = "https://raw.githubusercontent.com/ТВОЙ_НИК/ZorikHub/main/binds.json"
local KEY_FILE = "ZorikHub_Key.txt"
local TIME_FILE = "ZorikHub_Time.txt"
local BIND_FILE = "ZorikHub_Bind.txt"

local KEYS_DATA = nil
local BINDS_DATA = nil
local CURRENT_KEY = nil
local HAS_KEY = false  -- Есть ли доступ к полным функциям

local MY_USERNAME = LP.Name
local MY_USERID = tostring(LP.UserId)

local function HasFileAccess()
    return writefile ~= nil and readfile ~= nil and isfile ~= nil
end

local function LoadKeysFromServer()
    local ok, res = pcall(function()
        return game:HttpGet(KEYS_URL, true)
    end)
    if ok and res and res ~= "" then
        local ok2, decoded = pcall(function()
            return HTTP:JSONDecode(res)
        end)
        if ok2 and decoded then
            KEYS_DATA = decoded
            return true
        end
    end
    return false
end

local function LoadBindsFromServer()
    local ok, res = pcall(function()
        return game:HttpGet(BINDS_URL, true)
    end)
    if ok and res and res ~= "" then
        local ok2, decoded = pcall(function()
            return HTTP:JSONDecode(res)
        end)
        if ok2 and decoded then
            BINDS_DATA = decoded
            return true
        end
    end
    return false
end

local function LoadSaved()
    if not HasFileAccess() then return nil end
    local result = nil
    pcall(function()
        if isfile(KEY_FILE) and isfile(TIME_FILE) then
            local key = readfile(KEY_FILE)
            local time = tonumber(readfile(TIME_FILE))
            local bind = "none"
            if isfile(BIND_FILE) then
                bind = readfile(BIND_FILE)
            end
            if key and time then
                result = {key = key, time = time, bind = bind}
            end
        end
    end)
    return result
end

local function SaveKey(key, expiryTime, bindUsername)
    if not HasFileAccess() then return end
    pcall(function()
        writefile(KEY_FILE, key)
        writefile(TIME_FILE, tostring(expiryTime))
        writefile(BIND_FILE, bindUsername or "none")
    end)
end

local function DeleteKey()
    if not HasFileAccess() then return end
    pcall(function()
        if isfile(KEY_FILE) then delfile(KEY_FILE) end
        if isfile(TIME_FILE) then delfile(TIME_FILE) end
        if isfile(BIND_FILE) then delfile(BIND_FILE) end
    end)
end

local function CheckKey(inputKey)
    if not inputKey or inputKey == "" then
        return false, "❌ Пустой ключ"
    end
    if not KEYS_DATA then
        return false, "❌ Сервер недоступен"
    end
    
    local data = KEYS_DATA.keys[inputKey]
    if not data then
        return false, "❌ Неверный ключ"
    end
    
    if BINDS_DATA and BINDS_DATA.binds and BINDS_DATA.binds[inputKey] then
        local boundUser = BINDS_DATA.binds[inputKey]
        if boundUser ~= MY_USERNAME and boundUser ~= "none" then
            return false, "❌ Ключ привязан к другому игроку"
        end
    end
    
    local now = os.time()
    local expiry = now + (data.days * 86400)
    
    SaveKey(inputKey, expiry, MY_USERNAME)
    CURRENT_KEY = {
        key = inputKey,
        type = data.type,
        expiry = expiry,
        bind = MY_USERNAME
    }
    HAS_KEY = true
    
    return true, "✅ Ключ активирован • " .. MY_USERNAME
end

local function ValidateSavedKey()
    local saved = LoadSaved()
    if not saved then return false end
    if not KEYS_DATA then return false end
    
    if saved.bind and saved.bind ~= "none" and saved.bind ~= MY_USERNAME then
        DeleteKey()
        return false
    end
    
    local now = os.time()
    if now >= saved.time then
        DeleteKey()
        return false
    end
    
    local data = KEYS_DATA.keys[saved.key]
    if not data then
        DeleteKey()
        return false
    end
    
    if BINDS_DATA and BINDS_DATA.binds and BINDS_DATA.binds[saved.key] then
        local boundUser = BINDS_DATA.binds[saved.key]
        if boundUser ~= MY_USERNAME and boundUser ~= "none" then
            DeleteKey()
            return false
        end
    end
    
    CURRENT_KEY = {
        key = saved.key,
        type = data.type,
        expiry = saved.time,
        bind = saved.bind
    }
    HAS_KEY = true
    return true
end

local function GetTimeLeft()
    if not CURRENT_KEY then return "—" end
    local now = os.time()
    local diff = CURRENT_KEY.expiry - now
    if diff <= 0 then return "Истёк" end
    local days = math.floor(diff / 86400)
    local hours = math.floor((diff % 86400) / 3600)
    local minutes = math.floor((diff % 3600) / 60)
    if days > 0 then
        return days .. "д " .. hours .. "ч"
    elseif hours > 0 then
        return hours .. "ч " .. minutes .. "м"
    else
        return minutes .. "мин"
    end
end

-- ═══════════════════════════════════════════════════════
-- GUI
-- ═══════════════════════════════════════════════════════
local SG = Instance.new("ScreenGui")
SG.Name = "ZorikHub"
SG.ResetOnSpawn = false
SG.IgnoreGuiInset = true
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.Parent = LP:WaitForChild("PlayerGui")

local Blur = Instance.new("BlurEffect")
Blur.Size = 0
Blur.Parent = game.Lighting

-- ═══════════════════════════════════════════════════════
-- ЭКРАН ВВОДА КЛЮЧА (можно пропустить — ESP доступен без ключа)
-- ═══════════════════════════════════════════════════════
local function ShowKeyScreen()
    local KS = Instance.new("Frame")
    KS.Size = UDim2.new(0, 420, 0, 340)
    KS.Position = UDim2.new(0.5, -210, 0.5, -170)
    KS.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
    KS.BorderSizePixel = 0
    KS.Parent = SG
    Instance.new("UICorner", KS).CornerRadius = UDim.new(0, 18)

    local KS_Stroke = Instance.new("UIStroke")
    KS_Stroke.Color = Color3.fromRGB(255, 60, 110)
    KS_Stroke.Thickness = 3
    KS_Stroke.Parent = KS

    local KS_Grad = Instance.new("UIGradient")
    KS_Grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 60, 110)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 100, 180)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 60, 255))
    })
    KS_Grad.Rotation = 45
    KS_Grad.Parent = KS_Stroke

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
    Title.Text = "🔑 ZorikHub"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.BorderSizePixel = 0
    Title.Parent = KS
    Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 18)

    -- Инфо что ESP бесплатно
    local FreeInfo = Instance.new("TextLabel")
    FreeInfo.Size = UDim2.new(1, -20, 0, 30)
    FreeInfo.Position = UDim2.new(0, 10, 0, 55)
    FreeInfo.BackgroundColor3 = Color3.fromRGB(0, 150, 90)
    FreeInfo.BackgroundTransparency = 0.3
    FreeInfo.Text = "🎁 ESP (WH) БЕСПЛАТНО ДЛЯ ВСЕХ!"
    FreeInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
    FreeInfo.TextSize = 13
    FreeInfo.Font = Enum.Font.GothamBold
    FreeInfo.Parent = KS
    Instance.new("UICorner", FreeInfo).CornerRadius = UDim.new(0, 8)

    local Sub = Instance.new("TextLabel")
    Sub.Size = UDim2.new(1, -20, 0, 20)
    Sub.Position = UDim2.new(0, 10, 0, 90)
    Sub.BackgroundTransparency = 1
    Sub.Text = "🔒 Ключ привяжется к: " .. MY_USERNAME
    Sub.TextColor3 = Color3.fromRGB(255, 200, 100)
    Sub.TextSize = 11
    Sub.Font = Enum.Font.GothamBold
    Sub.Parent = KS

    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(1, -60, 0, 50)
    Input.Position = UDim2.new(0, 30, 0, 115)
    Input.BackgroundColor3 = Color3.fromRGB(30, 30, 48)
    Input.PlaceholderText = "Введи ключ..."
    Input.Text = ""
    Input.TextColor3 = Color3.fromRGB(255, 255, 255)
    Input.PlaceholderColor3 = Color3.fromRGB(130, 130, 160)
    Input.TextSize = 16
    Input.Font = Enum.Font.GothamBold
    Input.ClearTextOnFocus = false
    Input.BorderSizePixel = 0
    Input.Parent = KS
    Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 10)

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -60, 0, 45)
    Btn.Position = UDim2.new(0, 30, 0, 175)
    Btn.BackgroundColor3 = Color3.fromRGB(255, 60, 110)
    Btn.Text = "🔓 АКТИВИРОВАТЬ КЛЮЧ"
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.TextSize = 14
    Btn.Font = Enum.Font.GothamBold
    Btn.BorderSizePixel = 0
    Btn.Parent = KS
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 10)

    -- Кнопка "Продолжить без ключа"
    local SkipBtn = Instance.new("TextButton")
    SkipBtn.Size = UDim2.new(1, -60, 0, 40)
    SkipBtn.Position = UDim2.new(0, 30, 0, 230)
    SkipBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 90)
    SkipBtn.Text = "🎁 ПРОДОЛЖИТЬ С ESP (БЕЗ КЛЮЧА)"
    SkipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SkipBtn.TextSize = 13
    SkipBtn.Font = Enum.Font.GothamBold
    SkipBtn.BorderSizePixel = 0
    SkipBtn.Parent = KS
    Instance.new("UICorner", SkipBtn).CornerRadius = UDim.new(0, 10)

    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(1, -60, 0, 25)
    Status.Position = UDim2.new(0, 30, 0, 275)
    Status.BackgroundTransparency = 1
    Status.Text = ""
    Status.TextColor3 = Color3.fromRGB(0, 255, 100)
    Status.TextSize = 12
    Status.Font = Enum.Font.GothamBold
    Status.Parent = KS

    local Info = Instance.new("TextLabel")
    Info.Size = UDim2.new(1, -60, 0, 20)
    Info.Position = UDim2.new(0, 30, 0, 305)
    Info.BackgroundTransparency = 1
    Info.Text = "📱 @ZorikHub"
    Info.TextColor3 = Color3.fromRGB(100, 200, 255)
    Info.TextSize = 11
    Info.Font = Enum.Font.GothamBold
    Info.Parent = KS

    local function TryActivate()
        if not KEYS_DATA then
            Status.Text = "⏳ Загрузка..."
            Status.TextColor3 = Color3.fromRGB(255, 200, 0)
            task.wait(1)
            if not KEYS_DATA then
                Status.Text = "❌ Нет связи с сервером"
                Status.TextColor3 = Color3.fromRGB(255, 100, 100)
                return
            end
        end
        local ok, msg = CheckKey(Input.Text)
        Status.Text = msg
        if ok then
            Status.TextColor3 = Color3.fromRGB(0, 255, 100)
            task.wait(1.5)
            KS:Destroy()
            BuildMainMenu()
        else
            Status.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end

    Btn.MouseButton1Click:Connect(TryActivate)
    Input.FocusLost:Connect(function(enter) if enter then TryActivate() end end)
    
    -- Пропустить и играть только с ESP
    SkipBtn.MouseButton1Click:Connect(function()
        HAS_KEY = false
        KS:Destroy()
        BuildMainMenu()
    end)
end

-- ═══════════════════════════════════════════════════════
-- ГЛАВНОЕ МЕНЮ
-- ═══════════════════════════════════════════════════════
function BuildMainMenu()
    -- FOV Circle
    local FovCircle = Instance.new("Frame")
    FovCircle.BackgroundTransparency = 1
    FovCircle.Visible = false
    FovCircle.ZIndex = 5
    FovCircle.Parent = SG
    local FS = Instance.new("UIStroke")
    FS.Color = Color3.fromRGB(255, 60, 110)
    FS.Thickness = 2
    FS.Transparency = 0.3
    FS.Parent = FovCircle
    Instance.new("UICorner", FovCircle).CornerRadius = UDim.new(1, 0)

    -- Кнопка Z
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

    local ZGrad = Instance.new("UIGradient")
    ZGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 60, 110)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 60, 255))
    })
    ZGrad.Parent = ZBtn

    local ZStroke = Instance.new("UIStroke")
    ZStroke.Color = Color3.fromRGB(255, 255, 255)
    ZStroke.Thickness = 3
    ZStroke.Transparency = 0.3
    ZStroke.Parent = ZBtn

    -- Инфо о статусе
    local KeyInfo = Instance.new("TextLabel")
    KeyInfo.Size = UDim2.new(0, 220, 0, 25)
    KeyInfo.Position = UDim2.new(0, 15, 0, 265)
    KeyInfo.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
    KeyInfo.BackgroundTransparency = 0.3
    if HAS_KEY then
        KeyInfo.Text = "🔒 " .. MY_USERNAME .. " | ⏰ " .. GetTimeLeft()
        KeyInfo.TextColor3 = Color3.fromRGB(100, 255, 150)
    else
        KeyInfo.Text = "🎁 ESP Free Mode"
        KeyInfo.TextColor3 = Color3.fromRGB(255, 200, 100)
    end
    KeyInfo.TextSize = 11
    KeyInfo.Font = Enum.Font.GothamBold
    KeyInfo.ZIndex = 100
    KeyInfo.Parent = SG
    Instance.new("UICorner", KeyInfo).CornerRadius = UDim.new(0, 6)

    -- МЕНЮ
    local M = Instance.new("Frame")
    M.Size = UDim2.new(0, 700, 0, 480)
    M.Position = UDim2.new(0.5, -350, 0.5, -240)
    M.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
    M.BorderSizePixel = 0
    M.Visible = false
    M.ZIndex = 50
    M.Parent = SG
    Instance.new("UICorner", M).CornerRadius = UDim.new(0, 18)

    local MStroke = Instance.new("UIStroke")
    MStroke.Color = Color3.fromRGB(255, 60, 110)
    MStroke.Thickness = 2
    MStroke.Transparency = 0.2
    MStroke.Parent = M

    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 60)
    Header.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
    Header.BorderSizePixel = 0
    Header.ZIndex = 51
    Header.Parent = M
    Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 18)
    local HFix = Instance.new("Frame")
    HFix.Size = UDim2.new(1, 0, 0, 20)
    HFix.Position = UDim2.new(0, 0, 1, -20)
    HFix.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
    HFix.BorderSizePixel = 0
    HFix.ZIndex = 51
    HFix.Parent = Header

    local HGrad = Instance.new("UIGradient")
    HGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 60, 110)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 60, 255))
    })
    HGrad.Parent = Header

    local Logo = Instance.new("Frame")
    Logo.Size = UDim2.new(0, 44, 0, 44)
    Logo.Position = UDim2.new(0, 12, 0.5, -22)
    Logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Logo.BorderSizePixel = 0
    Logo.ZIndex = 52
    Logo.Parent = Header
    Instance.new("UICorner", Logo).CornerRadius = UDim.new(1, 0)

    local LText = Instance.new("TextLabel")
    LText.Size = UDim2.new(1, 0, 1, 0)
    LText.BackgroundTransparency = 1
    LText.Text = "Z"
    LText.TextColor3 = Color3.fromRGB(255, 60, 110)
    LText.TextSize = 24
    LText.Font = Enum.Font.GothamBlack
    LText.ZIndex = 53
    LText.Parent = Logo

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -220, 0, 26)
    Title.Position = UDim2.new(0, 65, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = "ZorikHub v10"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.ZIndex = 52
    Title.Parent = Header

    local AuthorSign = Instance.new("TextLabel")
    AuthorSign.Size = UDim2.new(1, -220, 0, 20)
    AuthorSign.Position = UDim2.new(0, 65, 0, 36)
    AuthorSign.BackgroundTransparency = 1
    if HAS_KEY then
        AuthorSign.Text = "📱 @ZorikHub | 🔒 " .. MY_USERNAME
        AuthorSign.TextColor3 = Color3.fromRGB(100, 200, 255)
    else
        AuthorSign.Text = "📱 @ZorikHub | 🎁 ESP FREE MODE"
        AuthorSign.TextColor3 = Color3.fromRGB(255, 200, 100)
    end
    AuthorSign.TextXAlignment = Enum.TextXAlignment.Left
    AuthorSign.TextSize = 12
    AuthorSign.Font = Enum.Font.GothamBold
    AuthorSign.ZIndex = 52
    AuthorSign.Parent = Header

    local XBtn = Instance.new("TextButton")
    XBtn.Size = UDim2.new(0, 36, 0, 36)
    XBtn.Position = UDim2.new(1, -48, 0.5, -18)
    XBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 80)
    XBtn.Text = "✕"
    XBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    XBtn.TextSize = 16
    XBtn.Font = Enum.Font.GothamBold
    XBtn.BorderSizePixel = 0
    XBtn.ZIndex = 52
    XBtn.Parent = Header
    Instance.new("UICorner", XBtn).CornerRadius = UDim.new(0, 10)

    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 130, 1, -80)
    Sidebar.Position = UDim2.new(0, 10, 0, 70)
    Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
    Sidebar.BorderSizePixel = 0
    Sidebar.ZIndex = 51
    Sidebar.Parent = M
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

    local SideList = Instance.new("UIListLayout")
    SideList.Padding = UDim.new(0, 6)
    SideList.SortOrder = Enum.SortOrder.LayoutOrder
    SideList.Parent = Sidebar

    local SidePad = Instance.new("UIPadding")
    SidePad.PaddingTop = UDim.new(0, 8)
    SidePad.PaddingLeft = UDim.new(0, 6)
    SidePad.PaddingRight = UDim.new(0, 6)
    SidePad.Parent = Sidebar

    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -155, 1, -80)
    Content.Position = UDim2.new(0, 150, 0, 70)
    Content.BackgroundTransparency = 1
    Content.ZIndex = 51
    Content.Parent = M

    local Pages = {}
    local TabButtons = {}

    local function MakeTab(name, icon, order)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, 0, 0, 42)
        Btn.BackgroundColor3 = Color3.fromRGB(32, 32, 50)
        Btn.Text = "  " .. icon .. "  " .. name
        Btn.TextColor3 = Color3.fromRGB(170, 170, 200)
        Btn.TextXAlignment = Enum.TextXAlignment.Left
        Btn.TextSize = 14
        Btn.Font = Enum.Font.GothamBold
        Btn.BorderSizePixel = 0
        Btn.LayoutOrder = order
        Btn.ZIndex = 52
        Btn.Parent = Sidebar
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.ScrollBarThickness = 6
        Page.ScrollBarImageColor3 = Color3.fromRGB(255, 60, 110)
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.Visible = false
        Page.ZIndex = 52
        Page.Parent = Content
        Page.Active = true
        Page.Selectable = true

        local L = Instance.new("UIListLayout")
        L.Padding = UDim.new(0, 6)
        L.SortOrder = Enum.SortOrder.LayoutOrder
        L.Parent = Page

        local P = Instance.new("UIPadding")
        P.PaddingTop = UDim.new(0, 4)
        P.PaddingLeft = UDim.new(0, 4)
        P.PaddingRight = UDim.new(0, 4)
        P.PaddingBottom = UDim.new(0, 15)
        P.Parent = Page

        L:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, L.AbsoluteContentSize.Y + 15)
        end)

        Btn.MouseButton1Click:Connect(function()
            for _, pg in pairs(Pages) do pg.Visible = false end
            for _, tb in pairs(TabButtons) do
                TS:Create(tb, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(32, 32, 50)}):Play()
                tb.TextColor3 = Color3.fromRGB(170, 170, 200)
            end
            Page.Visible = true
            TS:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(255, 60, 110)}):Play()
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        Pages[name] = Page
        TabButtons[name] = Btn
        return Page
    end

    local function Section(parent, text, order)
        local F = Instance.new("Frame")
        F.Size = UDim2.new(1, -8, 0, 26)
        F.BackgroundTransparency = 1
        F.LayoutOrder = order
        F.Parent = parent
        local L = Instance.new("TextLabel")
        L.Size = UDim2.new(1, 0, 1, 0)
        L.Position = UDim2.new(0, 6, 0, 0)
        L.BackgroundTransparency = 1
        L.Text = "▸ " .. text
        L.TextColor3 = Color3.fromRGB(255, 150, 180)
        L.TextXAlignment = Enum.TextXAlignment.Left
        L.TextSize = 12
        L.Font = Enum.Font.GothamBold
        L.Parent = F
    end

    local function Toggle(parent, text, default, order, cb, requiresKey)
        local F = Instance.new("Frame")
        F.Size = UDim2.new(1, -8, 0, 40)
        F.BackgroundColor3 = Color3.fromRGB(26, 26, 42)
        F.BorderSizePixel = 0
        F.LayoutOrder = order
        F.Parent = parent
        Instance.new("UICorner", F).CornerRadius = UDim.new(0, 8)

        local L = Instance.new("TextLabel")
        L.Size = UDim2.new(0.7, 0, 1, 0)
        L.Position = UDim2.new(0, 12, 0, 0)
        L.BackgroundTransparency = 1
        if requiresKey and not HAS_KEY then
            L.Text = "🔒 " .. text
            L.TextColor3 = Color3.fromRGB(120, 120, 140)
        else
            L.Text = text
            L.TextColor3 = Color3.fromRGB(230, 230, 245)
        end
        L.TextXAlignment = Enum.TextXAlignment.Left
        L.TextSize = 13
        L.Font = Enum.Font.GothamMedium
        L.Parent = F

        local B = Instance.new("TextButton")
        B.Size = UDim2.new(0, 54, 0, 26)
        B.Position = UDim2.new(1, -62, 0.5, -13)
        B.BackgroundColor3 = default and Color3.fromRGB(0, 220, 100) or Color3.fromRGB(55, 55, 80)
        B.Text = default and "ON" or "OFF"
        B.TextColor3 = Color3.fromRGB(255, 255, 255)
        B.TextSize = 11
        B.Font = Enum.Font.GothamBold
        B.BorderSizePixel = 0
        B.Parent = F
        Instance.new("UICorner", B).CornerRadius = UDim.new(1, 0)

        local st = default
        B.MouseButton1Click:Connect(function()
            if requiresKey and not HAS_KEY then
                -- Показываем сообщение что нужен ключ
                local N = Instance.new("TextLabel")
                N.Size = UDim2.new(0, 300, 0, 50)
                N.Position = UDim2.new(0.5, -150, 0.5, -25)
                N.BackgroundColor3 = Color3.fromRGB(200, 30, 50)
                N.Text = "🔒 Нужен ключ!\n📱 Купить: @ZorikHub"
                N.TextColor3 = Color3.fromRGB(255, 255, 255)
                N.TextSize = 14
                N.Font = Enum.Font.GothamBold
                N.TextWrapped = true
                N.ZIndex = 999
                N.Parent = SG
                Instance.new("UICorner", N).CornerRadius = UDim.new(0, 12)
                task.wait(2)
                N:Destroy()
                return
            end
            st = not st
            TS:Create(B, TweenInfo.new(0.15), {BackgroundColor3 = st and Color3.fromRGB(0, 220, 100) or Color3.fromRGB(55, 55, 80)}):Play()
            B.Text = st and "ON" or "OFF"
            cb(st)
        end)
    end

    local function Slider(parent, text, mn, mx, def, order, cb, requiresKey)
        local F = Instance.new("Frame")
        F.Size = UDim2.new(1, -8, 0, 58)
        F.BackgroundColor3 = Color3.fromRGB(26, 26, 42)
        F.BorderSizePixel = 0
        F.LayoutOrder = order
        F.Parent = parent
        Instance.new("UICorner", F).CornerRadius = UDim.new(0, 8)

        local L = Instance.new("TextLabel")
        L.Size = UDim2.new(0.6, 0, 0, 20)
        L.Position = UDim2.new(0, 12, 0, 6)
        L.BackgroundTransparency = 1
        if requiresKey and not HAS_KEY then
            L.Text = "🔒 " .. text
            L.TextColor3 = Color3.fromRGB(120, 120, 140)
        else
            L.Text = text
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
        V.Text = tostring(def)
        V.TextColor3 = Color3.fromRGB(255, 100, 150)
        V.TextSize = 13
        V.Font = Enum.Font.GothamBold
        V.Parent = F

        local Holder = Instance.new("TextButton")
        Holder.Size = UDim2.new(1, -24, 0, 22)
        Holder.Position = UDim2.new(0, 12, 0, 32)
        Holder.BackgroundTransparency = 1
        Holder.Text = ""
        Holder.Parent = F

        local Bar = Instance.new("Frame")
        Bar.Size = UDim2.new(1, 0, 0, 6)
        Bar.Position = UDim2.new(0, 0, 0.5, -3)
        Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 75)
        Bar.BorderSizePixel = 0
        Bar.Parent = Holder
        Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

        local Fill = Instance.new("Frame")
        Fill.Size = UDim2.new((def - mn) / (mx - mn), 0, 1, 0)
        Fill.BackgroundColor3 = Color3.fromRGB(255, 60, 110)
        Fill.BorderSizePixel = 0
        Fill.Parent = Bar
        Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

        local dg = false
        local function upd(x)
            if requiresKey and not HAS_KEY then return end
            local pos = math.clamp((x - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
            local val = math.floor(mn + (mx - mn) * pos + 0.5)
            Fill.Size = UDim2.new(pos, 0, 1, 0)
            V.Text = tostring(val)
            cb(val)
        end
        Holder.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dg = true
                upd(i.Position.X)
            end
        end)
        Holder.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dg = false
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if dg and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                upd(i.Position.X)
            end
        end)
    end

    local function Dropdown(parent, text, options, default, order, cb, requiresKey)
        local F = Instance.new("Frame")
        F.Size = UDim2.new(1, -8, 0, 40)
        F.BackgroundColor3 = Color3.fromRGB(26, 26, 42)
        F.BorderSizePixel = 0
        F.LayoutOrder = order
        F.Parent = parent
        Instance.new("UICorner", F).CornerRadius = UDim.new(0, 8)

        local L = Instance.new("TextLabel")
        L.Size = UDim2.new(0.45, 0, 1, 0)
        L.Position = UDim2.new(0, 12, 0, 0)
        L.BackgroundTransparency = 1
        if requiresKey and not HAS_KEY then
            L.Text = "🔒 " .. text
            L.TextColor3 = Color3.fromRGB(120, 120, 140)
        else
            L.Text = text
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
        B.Text = default
        B.TextColor3 = Color3.fromRGB(255, 255, 255)
        B.TextSize = 12
        B.Font = Enum.Font.GothamBold
        B.BorderSizePixel = 0
        B.Parent = F
        Instance.new("UICorner", B).CornerRadius = UDim.new(0, 6)

        B.MouseButton1Click:Connect(function()
            if requiresKey and not HAS_KEY then
                local N = Instance.new("TextLabel")
                N.Size = UDim2.new(0, 300, 0, 50)
                N.Position = UDim2.new(0.5, -150, 0.5, -25)
                N.BackgroundColor3 = Color3.fromRGB(200, 30, 50)
                N.Text = "🔒 Нужен ключ!\n📱 Купить: @ZorikHub"
                N.TextColor3 = Color3.fromRGB(255, 255, 255)
                N.TextSize = 14
                N.Font = Enum.Font.GothamBold
                N.TextWrapped = true
                N.ZIndex = 999
                N.Parent = SG
                Instance.new("UICorner", N).CornerRadius = UDim.new(0, 12)
                task.wait(2)
                N:Destroy()
                return
            end
            local list = F:FindFirstChild("DList")
            if list then list:Destroy() return end
            list = Instance.new("Frame")
            list.Name = "DList"
            list.Size = UDim2.new(0.45, 0, 0, #options * 28 + 8)
            list.Position = UDim2.new(0.53, 0, 1, 3)
            list.BackgroundColor3 = Color3.fromRGB(35, 35, 52)
            list.BorderSizePixel = 0
            list.ZIndex = 60
            list.Parent = F
            Instance.new("UICorner", list).CornerRadius = UDim.new(0, 6)
            local LL = Instance.new("UIListLayout")
            LL.Padding = UDim.new(0, 2)
            LL.HorizontalAlignment = Enum.HorizontalAlignment.Center
            LL.Parent = list
            local LP2 = Instance.new("UIPadding")
            LP2.PaddingTop = UDim.new(0, 4)
            LP2.Parent = list
            for _, opt in ipairs(options) do
                local OB = Instance.new("TextButton")
                OB.Size = UDim2.new(1, -8, 0, 26)
                OB.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
                OB.Text = opt
                OB.TextColor3 = Color3.fromRGB(255, 255, 255)
                OB.TextSize = 12
                OB.Font = Enum.Font.GothamBold
                OB.BorderSizePixel = 0
                OB.ZIndex = 61
                OB.Parent = list
                Instance.new("UICorner", OB).CornerRadius = UDim.new(0, 4)
                OB.MouseButton1Click:Connect(function()
                    B.Text = opt
                    list:Destroy()
                    cb(opt)
                end)
            end
        end)
    end

    local CombatTab = MakeTab("Combat", "🎯", 1)
    local VisualTab = MakeTab("Visuals", "👁", 2)
    local MiscTab = MakeTab("Misc", "⚙", 3)

    -- ═══ COMBAT (требует ключ) ═══
    Section(CombatTab, "AIMBOT 🔒", 1)
    Toggle(CombatTab, "Aimbot Master", false, 2, function(s) _G.Z.Aim = s end, true)
    Toggle(CombatTab, "Silent Aim", false, 3, function(s) _G.Z.Silent = s end, true)
    Toggle(CombatTab, "Legit Aim", false, 4, function(s) _G.Z.Legit = s end, true)
    Toggle(CombatTab, "Team Check", true, 5, function(s) _G.Z.Team = s end, true)
    Toggle(CombatTab, "Wall Check", true, 6, function(s) _G.Z.Wall = s end, true)
    Dropdown(CombatTab, "Aim Part", {"Head", "Torso", "HumanoidRootPart"}, "Head", 7, function(o) _G.Z.AimPart = o end, true)
    Slider(CombatTab, "FOV", 50, 800, 300, 8, function(v) _G.Z.FOV = v end, true)
    Slider(CombatTab, "Smoothness", 1, 20, 5, 9, function(v) _G.Z.Smooth = v end, true)

    -- ═══ VISUALS (ESP бесплатно, Хитбокс по ключу) ═══
    Section(VisualTab, "ESP 🎁 FREE", 1)
    Toggle(VisualTab, "ESP Master", false, 2, function(s) _G.Z.ESP = s end, false)
    Toggle(VisualTab, "Name ESP", true, 3, function(s) _G.Z.Name = s end, false)
    Toggle(VisualTab, "Distance ESP", true, 4, function(s) _G.Z.Dist = s end, false)
    Toggle(VisualTab, "Box ESP", false, 5, function(s) _G.Z.Box = s end, false)

    Section(VisualTab, "HITBOX 🔒", 6)
    Toggle(VisualTab, "Hitbox Expander", false, 7, function(s) _G.Z.Hitbox = s end, true)
    Slider(VisualTab, "Head Size", 1, 50, 25, 8, function(v) _G.Z.HitboxSize = v end, true)

    -- ═══ MISC (требует ключ) ═══
    Section(MiscTab, "MOVEMENT 🔒", 1)
    Toggle(MiscTab, "Fly", false, 2, function(s) _G.Z.Fly = s end, true)
    Slider(MiscTab, "Fly Speed", 10, 200, 50, 3, function(v) _G.Z.FlySpeed = v end, true)

    Section(MiscTab, "INFO", 4)
    local InfoLbl = Instance.new("TextLabel")
    InfoLbl.Size = UDim2.new(1, -8, 0, 140)
    InfoLbl.BackgroundColor3 = Color3.fromRGB(26, 26, 42)
    InfoLbl.BackgroundTransparency = 0.3
    if HAS_KEY then
        InfoLbl.Text = "⭐ ZorikHub v10 ⭐\n📱 @ZorikHub\n\n🔒 Привязан к: " .. MY_USERNAME .. "\n⏰ Осталось: " .. GetTimeLeft() .. "\n\nLeftShift / Z = меню"
    else
        InfoLbl.Text = "⭐ ZorikHub v10 ⭐\n📱 @ZorikHub\n\n🎁 Режим: ESP FREE\n🔒 Для аима/флая нужен ключ\n\nКупить: @ZorikHub"
    end
    InfoLbl.TextColor3 = Color3.fromRGB(230, 230, 245)
    InfoLbl.TextSize = 12
    InfoLbl.Font = Enum.Font.GothamMedium
    InfoLbl.TextWrapped = true
    InfoLbl.LayoutOrder = 5
    InfoLbl.Parent = MiscTab
    Instance.new("UICorner", InfoLbl).CornerRadius = UDim.new(0, 8)

    Pages["Visuals"].Visible = true
    TabButtons["Visuals"].BackgroundColor3 = Color3.fromRGB(255, 60, 110)
    TabButtons["Visuals"].TextColor3 = Color3.fromRGB(255, 255, 255)

    -- Перетаскивание
    local dragging = false
    local dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = M.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            M.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local open = false
    local function ToggleMenu()
        open = not open
        M.Visible = open
    end

    ZBtn.MouseButton1Click:Connect(ToggleMenu)
    XBtn.MouseButton1Click:Connect(function() if open then ToggleMenu() end end)

    if not isMobile then
        UIS.InputBegan:Connect(function(i, gpe)
            if gpe then return end
            if i.KeyCode == Enum.KeyCode.LeftShift then ToggleMenu() end
        end)
    end

    -- ═══ ИГРОВЫЕ ФУНКЦИИ ═══
    local function IsAlive(p)
        if not p or not p.Character then return false end
        local c = p.Character
        if c:GetAttribute("Dead") == true then return false end
        local hum = c:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health <= 0 then return false end
        local head = c:FindFirstChild("Head")
        if not head or not head:IsDescendantOf(workspace) then return false end
        return true
    end

    local function GetTeam(p)
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

    local function IsTeam(p)
        if not _G.Z.Team then return false end
        if p == LP then return true end
        local mt, pt = GetTeam(LP), GetTeam(p)
        if mt and pt then return mt == pt end
        return false
    end

    local function CanSee(part)
        if not _G.Z.Wall then return true end
        local rp = RaycastParams.new()
        rp.FilterType = Enum.RaycastFilterType.Exclude
        rp.FilterDescendantsInstances = {LP.Character}
        local res = workspace:Raycast(Cam.CFrame.Position, part.Position - Cam.CFrame.Position, rp)
        if not res then return true end
        return res.Instance:IsDescendantOf(part.Parent)
    end

    local function Valid(p)
        if p == LP then return false end
        if not IsAlive(p) then return false end
        if IsTeam(p) then return false end
        local h = p.Character:FindFirstChild(_G.Z.AimPart or "Head") or p.Character:FindFirstChild("Head")
        if not h then return false end
        if (h.Position - Cam.CFrame.Position).Magnitude > 1500 then return false end
        if not CanSee(h) then return false end
        return true
    end

    local espObjects = {}
    local function ClearESP()
        for _, o in ipairs(espObjects) do pcall(function() o:Destroy() end) end
        espObjects = {}
    end

    local function DrawESP()
        ClearESP()
        if not _G.Z.ESP then return end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and IsAlive(p) then
                local head = p.Character:FindFirstChild("Head")
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if head and hrp then
                    local isT = IsTeam(p)
                    local col = isT and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 60, 110)
                    local hl = Instance.new("Highlight")
                    hl.Adornee = p.Character
                    hl.FillColor = col
                    hl.FillTransparency = 0.5
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.OutlineTransparency = 0
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Parent = p.Character
                    table.insert(espObjects, hl)
                    if _G.Z.Box then
                        local b = Instance.new("BoxHandleAdornment")
                        b.Size = Vector3.new(3, 5, 2.5)
                        b.Adornee = hrp
                        b.Color3 = col
                        b.Transparency = 0.5
                        b.AlwaysOnTop = true
                        b.ZIndex = 5
                        b.Parent = hrp
                        table.insert(espObjects, b)
                    end
                    if _G.Z.Name or _G.Z.Dist then
                        local bg = Instance.new("BillboardGui")
                        bg.Size = UDim2.new(0, 150, 0, 60)
                        bg.StudsOffset = Vector3.new(0, 3, 0)
                        bg.Adornee = head
                        bg.AlwaysOnTop = true
                        bg.Parent = head
                        table.insert(espObjects, bg)
                        if _G.Z.Name then
                            local n = Instance.new("TextLabel")
                            n.Size = UDim2.new(1, 0, 0, 22)
                            n.BackgroundTransparency = 1
                            n.Text = p.Name .. (isT and " ★" or "")
                            n.TextColor3 = col
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
                            d.Text = math.floor((Cam.CFrame.Position - head.Position).Magnitude) .. "m"
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
        while task.wait(0.3) do pcall(DrawESP) end
    end)

    task.spawn(function()
        while task.wait(0.1) do
            if _G.Z.Hitbox and HAS_KEY then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LP and IsAlive(p) and not IsTeam(p) then
                        if p.Character then
                            for _, part in ipairs(p.Character:GetDescendants()) do
                                if part:IsA("BasePart") and part.Name == "Head" then
                                    local s = _G.Z.HitboxSize
                                    if part.Size.X ~= s then
                                        part.Size = Vector3.new(s, s, s)
                                        part.CanCollide = false
                                        part.Massless = true
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)

    local function GetTarget()
        local best, bd = nil, math.huge
        local center = Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y/2)
        for _, p in ipairs(Players:GetPlayers()) do
            if Valid(p) then
                local h = p.Character:FindFirstChild(_G.Z.AimPart or "Head") or p.Character:FindFirstChild("Head")
                if h then
                    local sp, on = Cam:WorldToViewportPoint(h.Position)
                    if on then
                        local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
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
            local size = _G.Z.FOV * 2
            FovCircle.Size = UDim2.new(0, size, 0, size)
            FovCircle.Position = UDim2.new(0.5, -size/2, 0.5, -size/2)
            FovCircle.Visible = true
        else
            FovCircle.Visible = false
        end
    end)

    RS:BindToRenderStep("ZorikAim", 201, function()
        if not _G.Z.Aim then return end
        if not HAS_KEY then return end
        if not LP.Character then return end
        local head = GetTarget()
        if not head then return end
        local tp = head.Position
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
            local char = LP.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            if _G.Z.Fly and HAS_KEY then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local bv = hrp:FindFirstChild("ZK_Fly")
                    if not bv then
                        bv = Instance.new("BodyVelocity")
                        bv.Name = "ZK_Fly"
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
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local bv = hrp:FindFirstChild("ZK_Fly")
                    if bv then bv:Destroy() end
                end
            end
        end)
    end)
end

-- ═══════════════════════════════════════════════════════
-- НАСТРОЙКИ
-- ═══════════════════════════════════════════════════════
_G.Z = {
    Aim = false, Silent = false, Legit = false,
    Team = true, Wall = true, FOV = 300, Smooth = 5,
    AimPart = "Head",
    ESP = false, Name = true, Dist = true, Box = false,
    Hitbox = false, HitboxSize = 25,
    Fly = false, FlySpeed = 50
}

-- ═══ ЗАПУСК ═══
task.spawn(function()
    local keysLoaded = LoadKeysFromServer()
    LoadBindsFromServer()
    
    if not keysLoaded then
        -- ESP всё равно работает даже если сервер недоступен
        HAS_KEY = false
        task.wait(1)
        BuildMainMenu()
        return
    end
    
    if ValidateSavedKey() then
        task.wait(0.3)
        BuildMainMenu()
    else
        ShowKeyScreen()
    end
end)

print("═══ ZorikHub v10 ═══")
print("🎁 ESP FREE | 🔒 Aimbot/Hitbox/Fly by Key")
print("📱 @ZorikHub")

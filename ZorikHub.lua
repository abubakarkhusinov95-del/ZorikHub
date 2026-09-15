-- ═══════════════════════════════════════════════
-- ⭐ ZorikHub v15 ⭐
-- Мультиязычное меню (EN/RU/FR/ES)
-- ═══════════════════════════════════════════════
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

_G.Z = {
    Aim = false, UseKey = false, AimKey = Enum.KeyCode.E,
    Silent = false, Legit = false, Instant = true,
    Team = true, Wall = true,
    FOV = 250, Smooth = 8,
    ESP = false, Name = true, Dist = true, Box = false,
    Hitbox = false, HitboxSize = 25
}

-- ═══ ЛОКАЛИЗАЦИЯ ═══
local LANG = {
    en = {
        title = "Choose Language",
        subtitle = "Select your language to continue",
        english = "English",
        russian = "Русский",
        french = "Français",
        spanish = "Español",
        -- Menu
        aimbot = "Aimbot", visuals = "Visuals", misc = "Misc",
        aimMaster = "Aimbot Master", useKey = "Activate by E (PC)",
        instant = "Instant Aim (fast)", silent = "Silent Aim",
        legit = "Legit Aim (smooth)", teamCheck = "Team Check",
        wallCheck = "Wall Check", fov = "FOV", smoothness = "Smoothness",
        espMaster = "ESP Master", names = "Names", dist = "Distance",
        box = "Boxes", hitbox = "Hitbox Expander", headSize = "Head Size",
        info = "INFO", telegram = "TELEGRAM",
        leftShift = "LeftShift = menu (PC)", zButton = "Z button = menu (phone)",
        aimAlways = "Aimbot works always when enabled!",
        aimByKey = "If you want only by E — enable 'Activate by E'",
        version = "v15"
    },
    ru = {
        title = "Выбери язык",
        subtitle = "Выбери язык чтобы продолжить",
        english = "English",
        russian = "Русский",
        french = "Français",
        spanish = "Español",
        aimbot = "Аимбот", visuals = "Визуалы", misc = "Разное",
        aimMaster = "Аимбот Мастер", useKey = "Активация по E (ПК)",
        instant = "Instant Aim (быстрый)", silent = "Silent Aim",
        legit = "Legit Aim (плавный)", teamCheck = "Team Check",
        wallCheck = "Wall Check", fov = "FOV", smoothness = "Плавность",
        espMaster = "ESP Мастер", names = "Имена", dist = "Расстояние",
        box = "Квадраты", hitbox = "Hitbox Expander", headSize = "Размер головы",
        info = "ИНФО", telegram = "ТЕЛЕГРАМ",
        leftShift = "LeftShift = меню (ПК)", zButton = "Кнопка Z = меню (телефон)",
        aimAlways = "Аимбот работает ПОСТОЯННО когда включён!",
        aimByKey = "Если хочешь только по E — включи «Активация по E»",
        version = "v15"
    },
    fr = {
        title = "Choisir la langue",
        subtitle = "Sélectionnez votre langue pour continuer",
        english = "English",
        russian = "Русский",
        french = "Français",
        spanish = "Español",
        aimbot = "Aimbot", visuals = "Visuels", misc = "Divers",
        aimMaster = "Aimbot Principal", useKey = "Activer par E (PC)",
        instant = "Instant Aim (rapide)", silent = "Silent Aim",
        legit = "Legit Aim (fluide)", teamCheck = "Vérif. Équipe",
        wallCheck = "Vérif. Mur", fov = "FOV", smoothness = "Fluidité",
        espMaster = "ESP Principal", names = "Noms", dist = "Distance",
        box = "Boîtes", hitbox = "Hitbox Élargie", headSize = "Taille Tête",
        info = "INFO", telegram = "TÉLÉGRAMME",
        leftShift = "LeftShift = menu (PC)", zButton = "Bouton Z = menu (tél)",
        aimAlways = "L'aimbot fonctionne toujours quand activé!",
        aimByKey = "Si vous voulez seulement par E — activez 'Activer par E'",
        version = "v15"
    },
    es = {
        title = "Elige idioma",
        subtitle = "Selecciona tu idioma para continuar",
        english = "English",
        russian = "Русский",
        french = "Français",
        spanish = "Español",
        aimbot = "Aimbot", visuals = "Visuales", misc = "Varios",
        aimMaster = "Aimbot Principal", useKey = "Activar por E (PC)",
        instant = "Instant Aim (rápido)", silent = "Silent Aim",
        legit = "Legit Aim (suave)", teamCheck = "Verif. Equipo",
        wallCheck = "Verif. Pared", fov = "FOV", smoothness = "Suavidad",
        espMaster = "ESP Principal", names = "Nombres", dist = "Distancia",
        box = "Cajas", hitbox = "Hitbox Ampliada", headSize = "Tamaño Cabeza",
        info = "INFO", telegram = "TELEGRAM",
        leftShift = "LeftShift = menú (PC)", zButton = "Botón Z = menú (tlf)",
        aimAlways = "¡El aimbot funciona siempre cuando está activo!",
        aimByKey = "Si quieres solo por E — activa 'Activar por E'",
        version = "v15"
    }
}

local T = LANG.en  -- текущий язык
local selectedLang = nil

local old = LP.PlayerGui:FindFirstChild("ZorikHub")
if old then old:Destroy() end

local SG = Instance.new("ScreenGui")
SG.Name = "ZorikHub"
SG.ResetOnSpawn = false
SG.IgnoreGuiInset = true
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.Parent = LP:WaitForChild("PlayerGui")

local Blur = Instance.new("BlurEffect")
Blur.Size = 0
Blur.Parent = game.Lighting

-- ═══════════════════════════════════════════════
-- ЭКРАН ВЫБОРА ЯЗЫКА
-- ═══════════════════════════════════════════════
local LangScreen = Instance.new("Frame")
LangScreen.Size = UDim2.new(1, 0, 1, 0)
LangScreen.BackgroundColor3 = Color3.fromRGB(8, 8, 14)
LangScreen.BackgroundTransparency = 0.15
LangScreen.BorderSizePixel = 0
LangScreen.ZIndex = 200
LangScreen.Parent = SG

-- Задний фон с блюром
TS:Create(Blur, TweenInfo.new(0.3), {Size = 20}):Play()

-- Контейнер
local LangBox = Instance.new("Frame")
LangBox.Size = UDim2.new(0, 480, 0, 460)
LangBox.Position = UDim2.new(0.5, -240, 0.5, -230)
LangBox.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
LangBox.BorderSizePixel = 0
LangBox.ZIndex = 201
LangBox.Parent = LangScreen
Instance.new("UICorner", LangBox).CornerRadius = UDim.new(0, 20)

local LBStroke = Instance.new("UIStroke")
LBStroke.Color = Color3.fromRGB(255, 60, 110)
LBStroke.Thickness = 3
LBStroke.Parent = LangBox

local LBGrad = Instance.new("UIGradient")
LBGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 60, 110)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 100, 180)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 60, 255))
})
LBGrad.Rotation = 45
LBGrad.Parent = LBStroke

-- Логотип сверху
local LangLogo = Instance.new("Frame")
LangLogo.Size = UDim2.new(0, 80, 0, 80)
LangLogo.Position = UDim2.new(0.5, -40, 0, 30)
LangLogo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LangLogo.BorderSizePixel = 0
LangLogo.ZIndex = 202
LangLogo.Parent = LangBox
Instance.new("UICorner", LangLogo).CornerRadius = UDim.new(1, 0)

local LangLogoGrad = Instance.new("UIGradient")
LangLogoGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 60, 110)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 60, 255))
})
LangLogoGrad.Parent = LangLogo

local LangLogoText = Instance.new("TextLabel")
LangLogoText.Size = UDim2.new(1, 0, 1, 0)
LangLogoText.BackgroundTransparency = 1
LangLogoText.Text = "Z"
LangLogoText.TextColor3 = Color3.fromRGB(255, 255, 255)
LangLogoText.TextSize = 44
LangLogoText.Font = Enum.Font.GothamBlack
LangLogoText.ZIndex = 203
LangLogoText.Parent = LangLogo

-- Заголовок
local LangTitle = Instance.new("TextLabel")
LangTitle.Size = UDim2.new(1, 0, 0, 34)
LangTitle.Position = UDim2.new(0, 0, 0, 125)
LangTitle.BackgroundTransparency = 1
LangTitle.Text = T.title
LangTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LangTitle.TextSize = 26
LangTitle.Font = Enum.Font.GothamBold
LangTitle.ZIndex = 202
LangTitle.Parent = LangBox

local LangSub = Instance.new("TextLabel")
LangSub.Size = UDim2.new(1, 0, 0, 20)
LangSub.Position = UDim2.new(0, 0, 0, 162)
LangSub.BackgroundTransparency = 1
LangSub.Text = T.subtitle
LangSub.TextColor3 = Color3.fromRGB(180, 180, 210)
LangSub.TextSize = 13
LangSub.Font = Enum.Font.GothamMedium
LangSub.ZIndex = 202
LangSub.Parent = LangBox

-- Кнопки языков
local LangFlags = {
    {code = "en", name = "English", flag = "🇬🇧", color = Color3.fromRGB(0, 100, 200)},
    {code = "ru", name = "Русский", flag = "🇷🇺", color = Color3.fromRGB(200, 30, 30)},
    {code = "fr", name = "Français", flag = "🇫🇷", color = Color3.fromRGB(30, 60, 200)},
    {code = "es", name = "Español", flag = "🇪🇸", color = Color3.fromRGB(220, 180, 0)}
}

local LangButtons = {}

for i, lang in ipairs(LangFlags) do
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -60, 0, 55)
    Btn.Position = UDim2.new(0, 30, 0, 200 + (i-1) * 62)
    Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    Btn.Text = ""
    Btn.BorderSizePixel = 0
    Btn.ZIndex = 202
    Btn.Parent = LangBox
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 12)

    local BStroke = Instance.new("UIStroke")
    BStroke.Color = lang.color
    BStroke.Thickness = 2
    BStroke.Transparency = 0.5
    BStroke.Parent = Btn

    -- Флаг
    local FlagLbl = Instance.new("TextLabel")
    FlagLbl.Size = UDim2.new(0, 50, 1, 0)
    FlagLbl.Position = UDim2.new(0, 10, 0, 0)
    FlagLbl.BackgroundTransparency = 1
    FlagLbl.Text = lang.flag
    FlagLbl.TextSize = 30
    FlagLbl.Font = Enum.Font.GothamBold
    FlagLbl.ZIndex = 203
    FlagLbl.Parent = Btn

    -- Название
    local NameLbl = Instance.new("TextLabel")
    NameLbl.Size = UDim2.new(1, -80, 1, 0)
    NameLbl.Position = UDim2.new(0, 70, 0, 0)
    NameLbl.BackgroundTransparency = 1
    NameLbl.Text = lang.name
    NameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameLbl.TextXAlignment = Enum.TextXAlignment.Left
    NameLbl.TextSize = 20
    NameLbl.Font = Enum.Font.GothamBold
    NameLbl.ZIndex = 203
    NameLbl.Parent = Btn

    -- Стрелка справа
    local Arrow = Instance.new("TextLabel")
    Arrow.Size = UDim2.new(0, 30, 1, 0)
    Arrow.Position = UDim2.new(1, -40, 0, 0)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "→"
    Arrow.TextColor3 = lang.color
    Arrow.TextSize = 24
    Arrow.Font = Enum.Font.GothamBold
    Arrow.ZIndex = 203
    Arrow.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        selectedLang = lang.code
        T = LANG[lang.code]
        -- Анимация выбора
        TS:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = lang.color}):Play()
        task.wait(0.3)
        -- Закрываем экран выбора
        LangScreen:Destroy()
        TS:Create(Blur, TweenInfo.new(0.4), {Size = 0}):Play()
        -- Открываем меню на выбранном языке
        BuildMenu()
    end)

    -- Ховер-эффект
    Btn.MouseEnter:Connect(function()
        TS:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(50, 50, 75)}):Play()
        TS:Create(BStroke, TweenInfo.new(0.15), {Transparency = 0.1, Thickness = 3}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TS:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 35, 55)}):Play()
        TS:Create(BStroke, TweenInfo.new(0.15), {Transparency = 0.5, Thickness = 2}):Play()
    end)

    table.insert(LangButtons, Btn)
end

-- Подпись автора внизу
local AuthorLbl = Instance.new("TextLabel")
AuthorLbl.Size = UDim2.new(1, 0, 0, 24)
AuthorLbl.Position = UDim2.new(0, 0, 1, -30)
AuthorLbl.BackgroundTransparency = 1
AuthorLbl.Text = "📱 Telegram: @ZorikHub"
AuthorLbl.TextColor3 = Color3.fromRGB(100, 200, 255)
AuthorLbl.TextSize = 13
AuthorLbl.Font = Enum.Font.GothamBold
AuthorLbl.ZIndex = 202
AuthorLbl.Parent = LangBox

-- ═══════════════════════════════════════════════
-- ВСЁ МЕНЮ (создаётся после выбора языка)
-- ═══════════════════════════════════════════════
function BuildMenu()
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
    ZBtn.Size = UDim2.new(0, 65, 0, 65)
    ZBtn.Position = UDim2.new(0, 15, 0, 200)
    ZBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ZBtn.Text = "Z"
    ZBtn.TextColor3 = Color3.fromRGB(255, 60, 110)
    ZBtn.TextSize = 30
    ZBtn.Font = Enum.Font.GothamBlack
    ZBtn.BorderSizePixel = 0
    ZBtn.Active = true
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

    local MGrad = Instance.new("UIGradient")
    MGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 60, 110)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 100, 180)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 60, 255))
    })
    MGrad.Rotation = 45
    MGrad.Parent = MStroke

    -- ЗАГОЛОВОК
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 70)
    Header.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    Header.BorderSizePixel = 0
    Header.ZIndex = 51
    Header.Parent = M
    Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 18)

    local HFix = Instance.new("Frame")
    HFix.Size = UDim2.new(1, 0, 0, 20)
    HFix.Position = UDim2.new(0, 0, 1, -20)
    HFix.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
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
    Title.Size = UDim2.new(1, -200, 0, 26)
    Title.Position = UDim2.new(0, 65, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = "ZorikHub " .. T.version
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.ZIndex = 52
    Title.Parent = Header

    local AuthorSign = Instance.new("TextLabel")
    AuthorSign.Size = UDim2.new(1, -200, 0, 20)
    AuthorSign.Position = UDim2.new(0, 65, 0, 38)
    AuthorSign.BackgroundTransparency = 1
    AuthorSign.Text = "📱 " .. T.telegram .. ": @ZorikHub"
    AuthorSign.TextColor3 = Color3.fromRGB(100, 200, 255)
    AuthorSign.TextXAlignment = Enum.TextXAlignment.Left
    AuthorSign.TextSize = 13
    AuthorSign.Font = Enum.Font.GothamBold
    AuthorSign.ZIndex = 52
    AuthorSign.Parent = Header

    -- Кнопка смены языка (флаг)
    local ChangeLangBtn = Instance.new("TextButton")
    ChangeLangBtn.Size = UDim2.new(0, 36, 0, 36)
    ChangeLangBtn.Position = UDim2.new(1, -132, 0.5, -18)
    ChangeLangBtn.BackgroundColor3 = Color3.fromRGB(70, 100, 180)
    ChangeLangBtn.Text = "🌐"
    ChangeLangBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ChangeLangBtn.TextSize = 18
    ChangeLangBtn.Font = Enum.Font.GothamBold
    ChangeLangBtn.BorderSizePixel = 0
    ChangeLangBtn.ZIndex = 52
    ChangeLangBtn.Parent = Header
    Instance.new("UICorner", ChangeLangBtn).CornerRadius = UDim.new(0, 10)

    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Size = UDim2.new(0, 36, 0, 36)
    MinimizeBtn.Position = UDim2.new(1, -90, 0.5, -18)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
    MinimizeBtn.Text = "—"
    MinimizeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    MinimizeBtn.TextSize = 22
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.BorderSizePixel = 0
    MinimizeBtn.ZIndex = 52
    MinimizeBtn.Parent = Header
    Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 10)

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 36, 0, 36)
    CloseBtn.Position = UDim2.new(1, -48, 0.5, -18)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 80)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 18
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.BorderSizePixel = 0
    CloseBtn.ZIndex = 52
    CloseBtn.Parent = Header
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 10)

    -- САЙДБАР
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 130, 1, -90)
    Sidebar.Position = UDim2.new(0, 10, 0, 80)
    Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
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
    Content.Size = UDim2.new(1, -155, 1, -90)
    Content.Position = UDim2.new(0, 150, 0, 80)
    Content.BackgroundTransparency = 1
    Content.ZIndex = 51
    Content.Parent = M

    local Pages = {}
    local TabButtons = {}

    local function MakeTab(name, icon, order)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, 0, 0, 42)
        Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
        Btn.Text = "  " .. icon .. "  " .. name
        Btn.TextColor3 = Color3.fromRGB(180, 180, 210)
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
        Page.ScrollBarThickness = 8
        Page.ScrollBarImageColor3 = Color3.fromRGB(255, 60, 110)
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.Visible = false
        Page.ZIndex = 52
        Page.Parent = Content
        Page.Active = true
        Page.Selectable = true
        Page.ScrollingDirection = Enum.ScrollingDirection.Y

        local L = Instance.new("UIListLayout")
        L.Padding = UDim.new(0, 8)
        L.SortOrder = Enum.SortOrder.LayoutOrder
        L.Parent = Page

        local P = Instance.new("UIPadding")
        P.PaddingTop = UDim.new(0, 5)
        P.PaddingLeft = UDim.new(0, 5)
        P.PaddingRight = UDim.new(0, 5)
        P.PaddingBottom = UDim.new(0, 20)
        P.Parent = Page

        L:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, L.AbsoluteContentSize.Y + 20)
        end)

        Btn.MouseButton1Click:Connect(function()
            for _, pg in pairs(Pages) do pg.Visible = false end
            for _, tb in pairs(TabButtons) do
                TS:Create(tb, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 55)}):Play()
                tb.TextColor3 = Color3.fromRGB(180, 180, 210)
            end
            Page.Visible = true
            TS:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 60, 110)}):Play()
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        Pages[name] = Page
        TabButtons[name] = Btn
        return Page
    end

    local function Section(parent, text, order)
        local F = Instance.new("Frame")
        F.Size = UDim2.new(1, -10, 0, 26)
        F.BackgroundTransparency = 1
        F.LayoutOrder = order
        F.Parent = parent
        local L = Instance.new("TextLabel")
        L.Size = UDim2.new(1, 0, 1, 0)
        L.Position = UDim2.new(0, 8, 0, 0)
        L.BackgroundTransparency = 1
        L.Text = text
        L.TextColor3 = Color3.fromRGB(255, 150, 180)
        L.TextXAlignment = Enum.TextXAlignment.Left
        L.TextSize = 14
        L.Font = Enum.Font.GothamBold
        L.Parent = F
    end

    local function Toggle(parent, text, default, order, cb)
        local F = Instance.new("Frame")
        F.Size = UDim2.new(1, -10, 0, 42)
        F.BackgroundColor3 = Color3.fromRGB(28, 28, 45)
        F.BorderSizePixel = 0
        F.LayoutOrder = order
        F.Parent = parent
        Instance.new("UICorner", F).CornerRadius = UDim.new(0, 10)

        local L = Instance.new("TextLabel")
        L.Size = UDim2.new(0.7, 0, 1, 0)
        L.Position = UDim2.new(0, 15, 0, 0)
        L.BackgroundTransparency = 1
        L.Text = text
        L.TextColor3 = Color3.fromRGB(230, 230, 245)
        L.TextXAlignment = Enum.TextXAlignment.Left
        L.TextSize = 14
        L.Font = Enum.Font.GothamMedium
        L.Parent = F

        local B = Instance.new("TextButton")
        B.Size = UDim2.new(0, 60, 0, 28)
        B.Position = UDim2.new(1, -72, 0.5, -14)
        B.BackgroundColor3 = default and Color3.fromRGB(0, 220, 100) or Color3.fromRGB(60, 60, 90)
        B.Text = default and "ON" or "OFF"
        B.TextColor3 = Color3.fromRGB(255, 255, 255)
        B.TextSize = 12
        B.Font = Enum.Font.GothamBold
        B.BorderSizePixel = 0
        B.Parent = F
        Instance.new("UICorner", B).CornerRadius = UDim.new(1, 0)

        local BStroke = Instance.new("UIStroke")
        BStroke.Color = default and Color3.fromRGB(0, 220, 100) or Color3.fromRGB(60, 60, 90)
        BStroke.Thickness = 2
        BStroke.Transparency = default and 0.3 or 1
        BStroke.Parent = B

        local st = default
        B.MouseButton1Click:Connect(function()
            st = not st
            TS:Create(B, TweenInfo.new(0.2), {BackgroundColor3 = st and Color3.fromRGB(0, 220, 100) or Color3.fromRGB(60, 60, 90)}):Play()
            BStroke.Color = st and Color3.fromRGB(0, 220, 100) or Color3.fromRGB(60, 60, 90)
            BStroke.Transparency = st and 0.3 or 1
            B.Text = st and "ON" or "OFF"
            cb(st)
        end)
    end

    local function Slider(parent, text, mn, mx, def, order, cb)
        local F = Instance.new("Frame")
        F.Size = UDim2.new(1, -10, 0, 62)
        F.BackgroundColor3 = Color3.fromRGB(28, 28, 45)
        F.BorderSizePixel = 0
        F.LayoutOrder = order
        F.Parent = parent
        Instance.new("UICorner", F).CornerRadius = UDim.new(0, 10)

        local L = Instance.new("TextLabel")
        L.Size = UDim2.new(0.6, 0, 0, 22)
        L.Position = UDim2.new(0, 15, 0, 8)
        L.BackgroundTransparency = 1
        L.Text = text
        L.TextColor3 = Color3.fromRGB(230, 230, 245)
        L.TextXAlignment = Enum.TextXAlignment.Left
        L.TextSize = 14
        L.Font = Enum.Font.GothamMedium
        L.Parent = F

        local V = Instance.new("TextLabel")
        V.Size = UDim2.new(0.3, 0, 0, 22)
        V.Position = UDim2.new(0.65, 0, 0, 8)
        V.BackgroundTransparency = 1
        V.Text = tostring(def)
        V.TextColor3 = Color3.fromRGB(255, 100, 150)
        V.TextSize = 14
        V.Font = Enum.Font.GothamBold
        V.Parent = F

        local Holder = Instance.new("TextButton")
        Holder.Size = UDim2.new(1, -30, 0, 26)
        Holder.Position = UDim2.new(0, 15, 0, 34)
        Holder.BackgroundTransparency = 1
        Holder.Text = ""
        Holder.Parent = F

        local Bar = Instance.new("Frame")
        Bar.Size = UDim2.new(1, 0, 0, 8)
        Bar.Position = UDim2.new(0, 0, 0.5, -4)
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

        local FGrad = Instance.new("UIGradient")
        FGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 60, 110)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 60, 255))
        })
        FGrad.Parent = Fill

        local Knob = Instance.new("Frame")
        Knob.Size = UDim2.new(0, 18, 0, 18)
        Knob.Position = UDim2.new(Fill.Size.X.Scale, -9, 0.5, -9)
        Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Knob.BorderSizePixel = 0
        Knob.ZIndex = 53
        Knob.Parent = Holder
        Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

        local KStroke = Instance.new("UIStroke")
        KStroke.Color = Color3.fromRGB(255, 60, 110)
        KStroke.Thickness = 2
        KStroke.Parent = Knob

        local dg = false
        local function upd(x)
            local pos = math.clamp((x - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
            local val = math.floor(mn + (mx - mn) * pos + 0.5)
            Fill.Size = UDim2.new(pos, 0, 1, 0)
            Knob.Position = UDim2.new(pos, -9, 0.5, -9)
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

    -- ВКЛАДКИ
    local CombatTab = MakeTab(T.aimbot, "🎯", 1)
    local VisualTab = MakeTab(T.visuals, "👁", 2)
    local MiscTab = MakeTab(T.misc, "⚙", 3)

    Section(CombatTab, "▸ " .. T.aimbot:upper(), 1)
    Toggle(CombatTab, T.aimMaster, false, 2, function(s) _G.Z.Aim = s end)
    Toggle(CombatTab, T.useKey, false, 3, function(s) _G.Z.UseKey = s end)
    Toggle(CombatTab, T.instant, true, 4, function(s) _G.Z.Instant = s; if s then _G.Z.Silent = false; _G.Z.Legit = false end end)
    Toggle(CombatTab, T.silent, false, 5, function(s) _G.Z.Silent = s; if s then _G.Z.Instant = false; _G.Z.Legit = false end end)
    Toggle(CombatTab, T.legit, false, 6, function(s) _G.Z.Legit = s; if s then _G.Z.Instant = false; _G.Z.Silent = false end end)
    Toggle(CombatTab, T.teamCheck, true, 7, function(s) _G.Z.Team = s end)
    Toggle(CombatTab, T.wallCheck, true, 8, function(s) _G.Z.Wall = s end)
    Slider(CombatTab, T.fov, 50, 800, 250, 9, function(v) _G.Z.FOV = v end)
    Slider(CombatTab, T.smoothness, 1, 20, 8, 10, function(v) _G.Z.Smooth = v end)

    Section(VisualTab, "▸ ESP", 1)
    Toggle(VisualTab, T.espMaster, false, 2, function(s) _G.Z.ESP = s end)
    Toggle(VisualTab, T.names, true, 3, function(s) _G.Z.Name = s end)
    Toggle(VisualTab, T.dist, true, 4, function(s) _G.Z.Dist = s end)
    Toggle(VisualTab, T.box, false, 5, function(s) _G.Z.Box = s end)

    Section(VisualTab, "▸ HITBOX", 6)
    Toggle(VisualTab, T.hitbox, false, 7, function(s) _G.Z.Hitbox = s end)
    Slider(VisualTab, T.headSize, 1, 50, 25, 8, function(v) _G.Z.HitboxSize = v end)

    Section(MiscTab, "▸ " .. T.info, 1)
    local InfoLbl = Instance.new("TextLabel")
    InfoLbl.Size = UDim2.new(1, -10, 0, 140)
    InfoLbl.BackgroundColor3 = Color3.fromRGB(28, 28, 45)
    InfoLbl.BackgroundTransparency = 0.3
    InfoLbl.Text = "⭐ ZorikHub " .. T.version .. " ⭐\n\n📱 " .. T.telegram .. ": @ZorikHub\n\n" .. T.leftShift .. "\n" .. T.zButton .. "\n\n" .. T.aimAlways .. "\n" .. T.aimByKey
    InfoLbl.TextColor3 = Color3.fromRGB(230, 230, 245)
    InfoLbl.TextSize = 12
    InfoLbl.Font = Enum.Font.GothamMedium
    InfoLbl.TextWrapped = true
    InfoLbl.LayoutOrder = 2
    InfoLbl.Parent = MiscTab
    Instance.new("UICorner", InfoLbl).CornerRadius = UDim.new(0, 10)

    Pages[T.aimbot].Visible = true
    TabButtons[T.aimbot].BackgroundColor3 = Color3.fromRGB(255, 60, 110)
    TabButtons[T.aimbot].TextColor3 = Color3.fromRGB(255, 255, 255)

    -- Перетаскивание
    local dragging = false
    local dragStart, startPos

    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = M.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            M.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Открытие / сворачивание
    local open = false
    local minimized = false

    local function ToggleMenu()
        open = not open
        if open then
            M.Visible = true
            M.Size = UDim2.new(0, 300, 0, 200)
            M.Position = UDim2.new(0.5, -150, 0.5, -100)
            TS:Create(M, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 700, 0, 480),
                Position = UDim2.new(0.5, -350, 0.5, -240)
            }):Play()
            TS:Create(Blur, TweenInfo.new(0.3), {Size = 8}):Play()
            minimized = false
        else
            TS:Create(Blur, TweenInfo.new(0.3), {Size = 0}):Play()
            M.Visible = false
        end
    end

    MinimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Sidebar.Visible = false
            Content.Visible = false
            TS:Create(M, TweenInfo.new(0.25), {Size = UDim2.new(0, 700, 0, 70)}):Play()
        else
            Sidebar.Visible = true
            Content.Visible = true
            TS:Create(M, TweenInfo.new(0.25), {Size = UDim2.new(0, 700, 0, 480)}):Play()
        end
    end)

    -- Кнопка смены языка — открывает экран выбора снова
    ChangeLangBtn.MouseButton1Click:Connect(function()
        M.Visible = false
        -- Пересоздаём экран выбора языка
        local NewLangScreen = Instance.new("Frame")
        NewLangScreen.Size = UDim2.new(1, 0, 1, 0)
        NewLangScreen.BackgroundColor3 = Color3.fromRGB(8, 8, 14)
        NewLangScreen.BackgroundTransparency = 0.15
        NewLangScreen.BorderSizePixel = 0
        NewLangScreen.ZIndex = 300
        NewLangScreen.Parent = SG

        local Box = Instance.new("Frame")
        Box.Size = UDim2.new(0, 480, 0, 460)
        Box.Position = UDim2.new(0.5, -240, 0.5, -230)
        Box.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
        Box.BorderSizePixel = 0
        Box.ZIndex = 301
        Box.Parent = NewLangScreen
        Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 20)

        local BStroke = Instance.new("UIStroke")
        BStroke.Color = Color3.fromRGB(255, 60, 110)
        BStroke.Thickness = 3
        BStroke.Parent = Box

        local BTitle = Instance.new("TextLabel")
        BTitle.Size = UDim2.new(1, 0, 0, 40)
        BTitle.Position = UDim2.new(0, 0, 0, 30)
        BTitle.BackgroundTransparency = 1
        BTitle.Text = "🌐 " .. T.title
        BTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        BTitle.TextSize = 24
        BTitle.Font = Enum.Font.GothamBold
        BTitle.ZIndex = 302
        BTitle.Parent = Box

        for i, lang in ipairs(LangFlags) do
            local B = Instance.new("TextButton")
            B.Size = UDim2.new(1, -60, 0, 65)
            B.Position = UDim2.new(0, 30, 0, 90 + (i-1) * 75)
            B.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
            B.Text = lang.flag .. "   " .. lang.name
            B.TextColor3 = Color3.fromRGB(255, 255, 255)
            B.TextSize = 20
            B.Font = Enum.Font.GothamBold
            B.BorderSizePixel = 0
            B.ZIndex = 302
            B.Parent = Box
            Instance.new("UICorner", B).CornerRadius = UDim.new(0, 12)

            local BS = Instance.new("UIStroke")
            BS.Color = lang.color
            BS.Thickness = 2
            BS.Transparency = 0.5
            BS.Parent = B

            B.MouseButton1Click:Connect(function()
                T = LANG[lang.code]
                NewLangScreen:Destroy()
                M:Destroy()
                ZBtn:Destroy()
                FovCircle:Destroy()
                BuildMenu()
            end)
        end
    end)

    ZBtn.MouseButton1Click:Connect(ToggleMenu)
    CloseBtn.MouseButton1Click:Connect(function() if open then ToggleMenu() end end)

    if not isMobile then
        UIS.InputBegan:Connect(function(i, gpe)
            if gpe then return end
            if i.KeyCode == Enum.KeyCode.LeftShift then ToggleMenu() end
        end)
    end

    -- ═══ ФУНКЦИИ ═══
    local function IsAlive(p)
        if not p or not p.Character then return false end
        local c = p.Character
        if c:GetAttribute("Dead") == true then return false end
        local hp = c:GetAttribute("Health")
        if type(hp) == "number" and hp <= 0 then return false end
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
        local h = p.Character:FindFirstChild("Head")
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
            if _G.Z.Hitbox then
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

    local aimHeld = false
    UIS.InputBegan:Connect(function(i, gpe)
        if gpe then return end
        if i.KeyCode == _G.Z.AimKey then aimHeld = true end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.KeyCode == _G.Z.AimKey then aimHeld = false end
    end)

    local function GetClosestHead()
        local best, bd = nil, math.huge
        local center = Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y/2)
        for _, p in ipairs(Players:GetPlayers()) do
            if Valid(p) then
                local h = p.Character:FindFirstChild("Head")
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
        if _G.Z.Aim then
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
        if _G.Z.UseKey and not aimHeld then return end
        if not LP.Character then return end

        local head = GetClosestHead()
        if not head then return end

        local tp = head.Position
        local mp = Cam.CFrame.Position

        if _G.Z.Silent then
            local origCF = Cam.CFrame
            Cam.CFrame = CFrame.new(origCF.Position, tp)
            task.spawn(function()
                task.wait()
                if Cam then Cam.CFrame = origCF end
            end)
        elseif _G.Z.Legit then
            local cd = Cam.CFrame.LookVector
            local td = (tp - mp).Unit
            local s = math.max(0.01, 1 / _G.Z.Smooth)
            local nd = cd:Lerp(td, s)
            Cam.CFrame = CFrame.new(mp, mp + nd)
        else
            Cam.CFrame = CFrame.new(mp, tp)
        end
    end)

    print("[ZorikHub v15] Loaded! Lang: " .. (selectedLang or "?") .. " | Telegram: @ZorikHub ⭐")
end

print("[ZorikHub v15] Выбор языка...")

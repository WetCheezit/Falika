local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- Double Load
if (getgenv().falika_loaded) then
    return warn("FALIKA Already loaded!")
end

-- Variables
local GamesList, GameFound = HttpService:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/WetCheezit/Falika/main/Main/Info/Games.json")), nil
local FalikaVersion = game:HttpGet("https://raw.githubusercontent.com/WetCheezit/Falika/main/Main/Info/Version.txt")

-- Instances
local FalikaLoader = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local MainCorner = Instance.new("UICorner")
local Load = Instance.new("TextButton")
local LoadCorner = Instance.new("UICorner")
local MainPadding = Instance.new("UIPadding")
local Title = Instance.new("TextLabel")
local Version = Instance.new("TextLabel")
local Game = Instance.new("TextLabel")

-- Protection
local HiddenGui = syn and syn.protect_gui

if (HiddenGui) then
    HiddenGui(FalikaLoader)
end

-- Properties
FalikaLoader.Name = "Falika Loader"
FalikaLoader.Parent = CoreGui
FalikaLoader.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Main.Name = "Main"
Main.Parent = FalikaLoader
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.35602954, 0, 0.432432443, 0)
Main.Size = UDim2.new(0, 350, 0, 150)

MainCorner.CornerRadius = UDim.new(0, 4)
MainCorner.Name = "MainCorner"
MainCorner.Parent = Main

Load.Name = "Load"
Load.Parent = Main
Load.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Load.Position = UDim2.new(0, 0, 0.844999969, 0)
Load.Size = UDim2.new(0, 320, 0, 25)
Load.Font = Enum.Font.Gotham
Load.Text = "Load"
Load.TextColor3 = Color3.fromRGB(255, 255, 255)
Load.TextSize = 14.000
Load.AutoButtonColor = false

LoadCorner.CornerRadius = UDim.new(0, 4)
LoadCorner.Name = "LoadCorner"
LoadCorner.Parent = Load

MainPadding.Name = "MainPadding"
MainPadding.Parent = Main
MainPadding.PaddingBottom = UDim.new(0, 20)
MainPadding.PaddingLeft = UDim.new(0, 15)
MainPadding.PaddingRight = UDim.new(0, 15)

Title.Name = "Title"
Title.Parent = Main
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1.000
Title.Position = UDim2.new(2.09270511e-05, 0, 0.0950221717, 0)
Title.Size = UDim2.new(0, 186, 0, 20)
Title.Font = Enum.Font.GothamSemibold
Title.Text = "FALIKA"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18.000
Title.TextXAlignment = Enum.TextXAlignment.Left

Version.Name = "Version"
Version.Parent = Main
Version.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Version.BackgroundTransparency = 1.000
Version.Position = UDim2.new(0.00261230394, 0, 0.30, 0)
Version.Size = UDim2.new(0, 100, 0, 15)
Version.Font = Enum.Font.Gotham
Version.Text = FalikaVersion
Version.TextColor3 = Color3.fromRGB(198, 198, 198)
Version.TextSize = 14.000
Version.TextXAlignment = Enum.TextXAlignment.Left

Game.Name = "Game"
Game.Parent = Main
Game.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Game.BackgroundTransparency = 1.000
Game.Position = UDim2.new(0.18571429, 0, 0.373333365, 0)
Game.Size = UDim2.new(0, 200, 0, 50)
Game.Font = Enum.Font.Gotham
Game.Text = ""
Game.TextColor3 = Color3.fromRGB(255, 255, 255)
Game.TextSize = 18.000

-- Main
for i,v in pairs(GamesList) do
    local Id = tostring(game.GameId)

    if (Id == i) then
        GameFound = {Id,v}
    end
end

local Url = "https://raw.githubusercontent.com/WetCheezit/Falika/main/Main/Games/universal.lua"

if (GameFound) then
    Game.Text = GameFound[2]
    Url = "https://raw.githubusercontent.com/WetCheezit/Falika/main/Main/Games/" .. GameFound[1] .. ".lua"
else
    Game.Text = "Universal"
end

Load.MouseEnter:Connect(function()
    TweenService:Create(Load, TweenInfo.new(0.200), {
        BackgroundColor3 = Color3.fromRGB(85, 255, 127)
    }):Play()
end)

Load.MouseLeave:Connect(function()
    TweenService:Create(Load, TweenInfo.new(0.200), {
        BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    }):Play()
end)

Load.MouseButton1Click:Connect(function()
    FalikaLoader:Destroy()
    loadstring(game:HttpGet(Url))()
    getgenv().falika_loaded = true
end)

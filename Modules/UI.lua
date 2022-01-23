local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Mouse = Players.LocalPlayer:GetMouse()

if (getgenv().library) then
    getgenv().library:Unload()
end

local UILibrary = {
    flags = {},
    options = {},
    connections = {},
    dragging = false,
    sliderdragging = false,
    colordragging = false,
    open = true,
}

getgenv().library = UILibrary

function UILibrary:Round(Num, Decimal)
    if (type(Num) == "Vector2") then
        return Vector2.new(self:Round(Num.X, Decimal), self:Round(Num.Y, Decimal))
    elseif (type(Num) == "number") then
        return math.floor(Num * 10 ^ Decimal) * 10 ^ -Decimal
    end
end

function UILibrary:AddConnection(Signal, Name, Function)
    if (type(Name) == "function") then
        local Connection = Signal:connect(Name)
        table.insert(self.connections, Connection)
    elseif (type(Name) == "string") then
        local Connection = Signal:connect(Function)
        self.connections[Name] = Connection
    end
end

function UILibrary:Dragger(Object)
    local Start
    local ObjectPosition

    self:AddConnection(Object.InputBegan, function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.dragging = true
            Start = Input.Position
            ObjectPosition = Object.Position
            self:AddConnection(Input.Changed, function()
                if Input.UserInputState == Enum.UserInputState.End then
                    self.dragging = false
                end
            end)
        end
    end)

    self:AddConnection(UserInputService.InputChanged, function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement and self.dragging and not self.sliderdragging and not self.colordragging then
            TweenService:Create(Object, TweenInfo.new(0.150), {
                Position = UDim2.new(ObjectPosition.X.Scale, ObjectPosition.X.Offset + (Input.Position - Start).X, ObjectPosition.Y.Scale, ObjectPosition.Y.Offset + (Input.Position - Start).Y)
            }):Play()
        end
    end)
end

function UILibrary:LoadConfig(Path)
    if (isfile(Path)) then
        local Config = HttpService:JSONDecode(readfile(Path))

        if (Config) then
            for i,v in pairs(Config) do
                local Option = self.options[i]
                if (type(v) == "boolean") then
                    Option:SetState(v)
                elseif (type(v) == "string" or type(v) == "number") then
                    if (Option.SetText) then
                        Option:SetText(v)
                    elseif (Option.SetValue) then
                        Option:SetValue(v)
                    end
                elseif (typeof(v) == "Color3") then
                    Option:SetColor(v)
                end
            end
        end
    end
end

function UILibrary:SaveConfig(Path)
    writefile(Path, HttpService:JSONEncode(self.flags))
end

function UILibrary:Unload()
    if (self.maingui) then
        self.maingui:Destroy()
    end

    for i,v in pairs(self.connections) do
        v:Disconnect()
    end
end

function UILibrary:CreateWindow(Name, Color)
    -- Variables
    Name = Name or "Universal"
    Color = Color or Color3.fromRGB(85, 255, 127)

    local WinTypes = {}

    -- Instances
    local Falika = Instance.new("ScreenGui")
    local Main = Instance.new("Frame")
    local Sidebar = Instance.new("Frame")
    local GradientLine = Instance.new("Frame")
    local MainGradient = Instance.new("UIGradient")
    local Title = Instance.new("TextLabel")
    local GameName = Instance.new("TextLabel")
    local Tabs = Instance.new("ScrollingFrame")
    local TabPadding = Instance.new("UIPadding")
    local TabList = Instance.new("UIListLayout")
    local MainContainer = Instance.new("Frame")

    -- Protection
    local HiddenGui = syn and syn.protect_gui

    if (HiddenGui) then
        HiddenGui(Falika)
    end

    -- Properties
    Falika.Name = "Falika"
    Falika.Parent = CoreGui
    Falika.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    Main.Name = "Main"
    Main.Parent = Falika
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.259515584, 0, 0.240540534, 0)
    Main.Size = UDim2.new(0, 556, 0, 383)

    Sidebar.Name = "Sidebar"
    Sidebar.Parent = Main
    Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Sidebar.BorderSizePixel = 0
    Sidebar.Size = UDim2.new(0, 173, 0, 383)

    GradientLine.Name = "GradientLine"
    GradientLine.Parent = Sidebar
    GradientLine.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    GradientLine.BorderSizePixel = 0
    GradientLine.Position = UDim2.new(1, 0, 0, 0)
    GradientLine.Size = UDim2.new(0, 12, 0, 383)

    MainGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 0, 0)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))}
    MainGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.60), NumberSequenceKeypoint.new(1.00, 0.60)}
    MainGradient.Name = "MainGradient"
    MainGradient.Parent = GradientLine

    Title.Name = "Title"
    Title.Parent = Sidebar
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1.000
    Title.BorderSizePixel = 0
    Title.Position = UDim2.new(0.0635838136, 0, 0.0287206266, 0)
    Title.Size = UDim2.new(0, 151, 0, 20)
    Title.Font = Enum.Font.GothamSemibold
    Title.Text = "FALIKA"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20.000
    Title.TextXAlignment = Enum.TextXAlignment.Left

    GameName.Name = "GameName"
    GameName.Parent = Sidebar
    GameName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    GameName.BackgroundTransparency = 1.000
    GameName.Position = UDim2.new(0.0635838136, 0, 0.0809399486, 0)
    GameName.Size = UDim2.new(0, 151, 0, 20)
    GameName.Font = Enum.Font.Gotham
    GameName.Text = Name
    GameName.TextColor3 = Color3.fromRGB(88, 88, 88)
    GameName.TextSize = 14.000
    GameName.TextXAlignment = Enum.TextXAlignment.Left

    Tabs.Name = "Tabs"
    Tabs.Parent = Sidebar
    Tabs.Active = true
    Tabs.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Tabs.BackgroundTransparency = 1.000
    Tabs.BorderSizePixel = 0
    Tabs.Position = UDim2.new(0, 0, 0.156657964, 0)
    Tabs.Size = UDim2.new(0, 173, 0, 323)
    Tabs.BottomImage = ""
    Tabs.CanvasSize = UDim2.new(0, 0, 0, 0)
    Tabs.ScrollBarThickness = 0
    Tabs.TopImage = ""

    TabPadding.Name = "TabPadding"
    TabPadding.Parent = Tabs
    TabPadding.PaddingLeft = UDim.new(0, 12)

    TabList.Name = "TabList"
    TabList.Parent = Tabs
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 5)

    MainContainer.Name = "MainContainer"
    MainContainer.Parent = Main
    MainContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    MainContainer.BackgroundTransparency = 1.000
    MainContainer.Position = UDim2.new(0.311151087, 0, 0, 0)
    MainContainer.Size = UDim2.new(0, 383, 0, 383)

    -- Code
    self.maingui = Falika
    self:Dragger(Main)

    self:AddConnection(UserInputService.InputBegan, function(Input, GameProcessed)
        if (not GameProcessed and Input.KeyCode == Enum.KeyCode.RightControl or Input.KeyCode == Enum.KeyCode.RightShift) then
            Falika.Enabled = not Falika.Enabled
            self.open = Falika.Enabled
        end
    end)

    -- Returns
    function WinTypes:CreateTab(Name)
        -- Variables
        Name = Name or "Tab"

        local TabTypes = {}

        -- Instances
        local Tab = Instance.new("TextButton")
        local TabCorner = Instance.new("UICorner")
        local Container = Instance.new("ScrollingFrame")
        local ContainerList = Instance.new("UIListLayout")
        local ContainerPadding = Instance.new("UIPadding")

        -- Properties
        Tab.Name = "Tab"
        Tab.Parent = Tabs
        Tab.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        Tab.BorderSizePixel = 0
        Tab.Position = UDim2.new(0.0693641603, 0, 0, 0)
        Tab.Size = UDim2.new(0, 149, 0, 30)
        Tab.Font = Enum.Font.Gotham
        Tab.Text = "  " .. Name
        Tab.TextColor3 = Color3.fromRGB(255, 255, 255)
        Tab.TextSize = 15.000
        Tab.TextXAlignment = Enum.TextXAlignment.Left
        Tab.AutoButtonColor = false

        TabCorner.CornerRadius = UDim.new(0, 4)
        TabCorner.Name = "TabCorner"
        TabCorner.Parent = Tab

        Container.Name = "Container"
        Container.Parent = MainContainer
        Container.Active = true
        Container.Visible = false
        Container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Container.BackgroundTransparency = 1.000
        Container.BorderSizePixel = 0
        Container.Size = UDim2.new(0, 383, 0, 383)
        Container.ScrollBarThickness = 0

        ContainerList.Name = "ContainerList"
        ContainerList.Parent = Container
        ContainerList.SortOrder = Enum.SortOrder.LayoutOrder
        ContainerList.Padding = UDim.new(0, 5)

        ContainerPadding.Name = "ContainerPadding"
        ContainerPadding.Parent = Container
        ContainerPadding.PaddingLeft = UDim.new(0, 15)
        ContainerPadding.PaddingTop = UDim.new(0, 15)

        -- Code
        UILibrary:AddConnection(Tab.MouseEnter, function()
            TweenService:Create(Tab, TweenInfo.new(0.200), {
                TextColor3 = Color
            }):Play()
        end)

        UILibrary:AddConnection(Tab.MouseLeave, function()
            TweenService:Create(Tab, TweenInfo.new(0.200), {
                TextColor3 = Color3.new(1, 1, 1)
            }):Play()
        end)

        UILibrary:AddConnection(Tab.MouseButton1Click, function()
            TweenService:Create(Tab, TweenInfo.new(0.200), {
                TextSize = 12
            }):Play()
            task.wait(0.05)
            TweenService:Create(Tab, TweenInfo.new(0.200), {
                TextSize = 15
            }):Play()

            for i,v in pairs(MainContainer:GetChildren()) do
                if (v.Name == "Container") then
                    v.Visible = (v == Container)
                end
            end
        end)

        UILibrary:AddConnection(ContainerList:GetPropertyChangedSignal("AbsoluteContentSize"), function()
            Container.CanvasSize = UDim2.new(1, 0, 0, ContainerList.AbsoluteContentSize.Y + 25)
        end)

        -- Returns
        function TabTypes:CreateToggle(Options)
            -- Variables
            Options = Options or {}
            Options.text = Options.text or "Toggle"
            Options.state = Options.state or false
            Options.callback = Options.callback or function() end
            Options.flag = Options.flag or Options.text

            local ToggleTypes = {}

            -- Instances
            local Toggle = Instance.new("Frame")
            local ToggleCorner = Instance.new("UICorner")
            local ToggleCheck = Instance.new("ImageLabel")
            local ToggleMain = Instance.new("TextButton")
            local ToggleText = Instance.new("TextLabel")

            -- Properties
            Toggle.Name = "Toggle"
            Toggle.Parent = Container
            Toggle.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            Toggle.Position = UDim2.new(0.039164491, 0, 0.039164491, 0)
            Toggle.Size = UDim2.new(0, 353, 0, 30)

            ToggleCorner.CornerRadius = UDim.new(0, 4)
            ToggleCorner.Name = "ToggleCorner"
            ToggleCorner.Parent = Toggle

            ToggleCheck.Name = "ToggleCheck"
            ToggleCheck.Parent = Toggle
            ToggleCheck.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleCheck.BackgroundTransparency = 1.000
            ToggleCheck.Position = UDim2.new(0.915014148, 0, 0, 0)
            ToggleCheck.Size = UDim2.new(0, 30, 0, 30)
            ToggleCheck.Image = Options.state and "rbxassetid://1202200114" or "rbxassetid://3926305904"
            ToggleCheck.ImageColor3 = Options.state and Color or Color3.fromRGB(243, 97, 109)
            ToggleCheck.ImageRectOffset = Options.state and Vector2.new() or Vector2.new(924, 724)
            ToggleCheck.ImageRectSize = Options.state and Vector2.new() or Vector2.new(36, 36)

            ToggleMain.Name = "ToggleMain"
            ToggleMain.Parent = Toggle
            ToggleMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleMain.BackgroundTransparency = 1
            ToggleMain.Size = UDim2.new(0, 353, 0, 30)
            ToggleMain.Font = Enum.Font.SourceSans
            ToggleMain.Text = ""
            ToggleMain.TextColor3 = Color3.fromRGB(0, 0, 0)
            ToggleMain.TextSize = 14.000

            ToggleText.Name = "ToggleText"
            ToggleText.Parent = Toggle
            ToggleText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleText.BackgroundTransparency = 1.000
            ToggleText.Position = UDim2.new(0, 0, 0.0333333351, 0)
            ToggleText.Size = UDim2.new(0, 323, 0, 29)
            ToggleText.Font = Enum.Font.Gotham
            ToggleText.Text = "  " .. Options.text
            ToggleText.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleText.TextSize = 14.000
            ToggleText.TextXAlignment = Enum.TextXAlignment.Left

            -- Code
            UILibrary:AddConnection(ToggleMain.MouseButton1Click, function()
                Options.state = not Options.state
                UILibrary.flags[Options.flag] = Options.state
                Options.callback(Options.state)

                TweenService:Create(ToggleCheck, TweenInfo.new(0.200), {
                    ImageColor3 = Options.state and Color or Color3.fromRGB(243, 97, 109)
                }):Play()

                ToggleCheck.Image = Options.state and "rbxassetid://1202200114" or "rbxassetid://3926305904"
                ToggleCheck.ImageRectOffset = Options.state and Vector2.new() or Vector2.new(924, 724)
                ToggleCheck.ImageRectSize = Options.state and Vector2.new() or Vector2.new(36, 36)
            end)

            -- Returns
            function ToggleTypes:SetState(State)
                if (State ~= nil and type(State) == "boolean") then
                    Options.state = State
                    UILibrary.flags[Options.flag] = Options.state
                    Options.callback(Options.state)

                    TweenService:Create(ToggleCheck, TweenInfo.new(0.200), {
                        ImageColor3 = Options.state and Color or Color3.fromRGB(243, 97, 109)
                    }):Play()

                    ToggleCheck.Image = Options.state and "rbxassetid://1202200114" or "rbxassetid://3926305904"
                    ToggleCheck.ImageRectOffset = Options.state and Vector2.new() or Vector2.new(924, 724)
                    ToggleCheck.ImageRectSize = Options.state and Vector2.new() or Vector2.new(36, 36)
                end
            end

            function ToggleTypes:GetState()
                return Options.state
            end

            ToggleTypes:SetState(Options.state)

            UILibrary.options[Options.flag] = ToggleTypes

            return ToggleTypes
        end

        function TabTypes:CreateButton(Options)
            -- Variables
            Options = Options or {}
            Options.text = Options.text or "Button"
            Options.callback = Options.callback or function() end

            -- Instances
            local Button = Instance.new("TextButton")
            local ButtonCorner = Instance.new("UICorner")

            -- Properties
            Button.Name = "Button"
            Button.Parent = Container
            Button.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            Button.Position = UDim2.new(0.039164491, 0, 0.156657964, 0)
            Button.Size = UDim2.new(0, 353, 0, 30)
            Button.Font = Enum.Font.Gotham
            Button.Text = Options.text
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 14.000
            Button.TextXAlignment = Enum.TextXAlignment.Center
            Button.AutoButtonColor = false

            ButtonCorner.CornerRadius = UDim.new(0, 4)
            ButtonCorner.Name = "ButtonCorner"
            ButtonCorner.Parent = Button

            -- Code
            UILibrary:AddConnection(Button.MouseEnter, function()
                TweenService:Create(Button, TweenInfo.new(0.200), {
                    TextColor3 = Color
                }):Play()
            end)

            UILibrary:AddConnection(Button.MouseLeave, function()
                TweenService:Create(Button, TweenInfo.new(0.200), {
                    TextColor3 = Color3.new(1, 1, 1)
                }):Play()
            end)

            UILibrary:AddConnection(Button.MouseButton1Click, function()
                TweenService:Create(Button, TweenInfo.new(0.200), {
                    TextSize = 12
                }):Play()
                task.wait(0.05)
                TweenService:Create(Button, TweenInfo.new(0.200), {
                    TextSize = 15
                }):Play()

                Options.callback()
            end)
        end

        function TabTypes:CreateSlider(Options)
            -- Variables
            Options = Options or {}
            Options.text = Options.text or "Slider"
            Options.min = Options.min or 0
            Options.max = Options.max or 100
            Options.default = Options.default or 50
            Options.decimal = Options.decimal or 1
            Options.suffix = Options.suffix or ""
            Options.callback = Options.callback or function() end
            Options.flag = Options.flag or Options.text

            local SliderTypes = {}
            local DefaultValue = UILibrary:Round(Options.default, Options.decimal)

            -- Instances
            local Slider = Instance.new("Frame")
            local SliderCorner = Instance.new("UICorner")
            local SliderText = Instance.new("TextLabel")
            local SliderBar = Instance.new("Frame")
            local SliderCornerBar = Instance.new("UICorner")
            local SliderMain = Instance.new("Frame")
            local SliderCornerMain = Instance.new("UICorner")
            local SliderBox = Instance.new("TextBox")
            local SliderCornerBox = Instance.new("UICorner")

            -- Properties
            Slider.Name = "Slider"
            Slider.Parent = Container
            Slider.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            Slider.Position = UDim2.new(0.039164491, 0, 0.274151444, 0)
            Slider.Size = UDim2.new(0, 353, 0, 50)

            SliderCorner.CornerRadius = UDim.new(0, 4)
            SliderCorner.Name = "SliderCorner"
            SliderCorner.Parent = Slider

            SliderText.Name = "SliderText"
            SliderText.Parent = Slider
            SliderText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderText.BackgroundTransparency = 1.000
            SliderText.Position = UDim2.new(0.0226628892, 0, 0.159999996, 0)
            SliderText.Size = UDim2.new(0, 280, 0, 15)
            SliderText.Font = Enum.Font.Gotham
            SliderText.Text = Options.text
            SliderText.TextColor3 = Color3.fromRGB(255, 255, 255)
            SliderText.TextSize = 14.000
            SliderText.TextXAlignment = Enum.TextXAlignment.Left

            SliderBar.Name = "SliderBar"
            SliderBar.Parent = Slider
            SliderBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
            SliderBar.Position = UDim2.new(0.0226628892, 0, 0.600000024, 0)
            SliderBar.Size = UDim2.new(0, 337, 0, 10)

            SliderCornerBar.CornerRadius = UDim.new(0, 4)
            SliderCornerBar.Name = "SliderCornerBar"
            SliderCornerBar.Parent = SliderBar

            SliderMain.Name = "SliderMain"
            SliderMain.Parent = SliderBar
            SliderMain.BackgroundColor3 = Color3.fromRGB(85, 255, 127)
            SliderMain.Size = UDim2.new(0, 100, 0, 10)
            SliderMain.BorderSizePixel = 0

            SliderCornerMain.CornerRadius = UDim.new(0, 4)
            SliderCornerMain.Name = "SliderCornerMain"
            SliderCornerMain.Parent = SliderMain

            SliderBox.Name = "SliderBox"
            SliderBox.Parent = Slider
            SliderBox.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
            SliderBox.Position = UDim2.new(0.835694075, 0, 0.159999996, 0)
            SliderBox.Size = UDim2.new(0, 50, 0, 15)
            SliderBox.Font = Enum.Font.Gotham
            SliderBox.Text = DefaultValue .. Options.suffix
            SliderBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            SliderBox.TextSize = 14.000
            SliderBox.TextWrapped = true

            SliderCornerBox.CornerRadius = UDim.new(0, 4)
            SliderCornerBox.Name = "SliderCornerBox"
            SliderCornerBox.Parent = SliderBox

            -- Code
            Options.text = SliderBox.Text
            Options.dragging = false
            Options.value = DefaultValue

            UILibrary:AddConnection(SliderBar.InputBegan, function(Input)
                if (Input.UserInputType == Enum.UserInputType.MouseButton1) then
                    SliderTypes:SetMouseValue()
                    Options.dragging = true
                    UILibrary.sliderdragging = true
                end
            end)

            UILibrary:AddConnection(SliderBar.InputEnded, function(Input)
                if (Input.UserInputType == Enum.UserInputType.MouseButton1) then
                    Options.dragging = false
                    UILibrary.sliderdragging = false
                end
            end)

            UILibrary:AddConnection(UserInputService.InputChanged, function(Input)
                if (Options.dragging and Input.UserInputType == Enum.UserInputType.MouseMovement) then
                    SliderTypes:SetMouseValue()
                end
            end)

            UILibrary:AddConnection(SliderBox.FocusLost, function(EnterPressed)
                if (EnterPressed) then
                    if (SliderBox.Text ~= "" and tonumber(SliderBox.Text) ~= nil) then
                        local Value = UILibrary:Round(tonumber(SliderBox.Text), Options.decimal)

                        SliderBox.Text = Value .. Options.suffix
                        Options.text = SliderBox.Text
                        SliderTypes:SetValue(Value)
                    else
                        SliderBox.Text = Options.text
                    end
                else
                    SliderBox.Text = Options.text
                end
            end)

            -- Returns
            function SliderTypes:SetMouseValue()
                local MouseLocation = UserInputService:GetMouseLocation()
                local Scale = math.clamp(((MouseLocation.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X), 0, 1)
                local Value = UILibrary:Round(((Scale * (Options.max)) / (Options.max)) * ((Options.max) - Options.min) + Options.min, Options.decimal)

                SliderTypes:SetValue(Value)
            end

            function SliderTypes:SetValue(Value)
                local NewValue = math.clamp(Value, Options.min, Options.max)
                local Size = UDim2.new(math.clamp(Value / Options.max, 0, 1), 0, 1, 0)

                Value = UILibrary:Round(NewValue, Options.decimal)

                TweenService:Create(SliderMain, TweenInfo.new(0.150), {
                    Size = Size
                }):Play()
                SliderBox.Text = Value .. Options.suffix

                Options.value = Value
                UILibrary.flags[Options.flag] = Value
                Options.callback(Value)
            end

            function SliderTypes:GetValue()
                return Options.value
            end

            SliderTypes:SetValue(DefaultValue)

            UILibrary.options[Options.flag] = SliderTypes

            return SliderTypes
        end

        function TabTypes:CreateDropdown(Options)
            -- Variables
            Options = Options or {}
            Options.text = Options.text or "Dropdown"
            Options.values = Options.values or {}
            Options.value = Options.value or ""
            Options.callback = Options.callback or function() end
            Options.flag = Options.flag or Options.text
            Options.multiselect = Options.multiselect or false

            local DropdownTypes = {}

            -- Instances
            local Dropdown = Instance.new("Frame")
            local DropdownCorner = Instance.new("UICorner")
            local DropdownMain = Instance.new("TextButton")
            local DropdownText = Instance.new("TextLabel")
            local DropdownContainer = Instance.new("Frame")
            local DropdownCornerMain = Instance.new("UICorner")
            local DropdownContainerList = Instance.new("UIListLayout")

            -- Properties
            Dropdown.Name = "Dropdown"
            Dropdown.Parent = Container
            Dropdown.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            Dropdown.Position = UDim2.new(0.039164491, 0, 0.039164491, 0)
            Dropdown.Size = UDim2.new(0, 353, 0, 30)
            Dropdown.ZIndex = 1

            DropdownCorner.CornerRadius = UDim.new(0, 4)
            DropdownCorner.Name = "DropdownCorner"
            DropdownCorner.Parent = Dropdown

            DropdownMain.Name = "DropdownMain"
            DropdownMain.Parent = Dropdown
            DropdownMain.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            DropdownMain.BackgroundTransparency = 1.000
            DropdownMain.BorderSizePixel = 0
            DropdownMain.Position = UDim2.new(0.915014148, 0, 0, 0)
            DropdownMain.Rotation = 0
            DropdownMain.Size = UDim2.new(0, 30, 0, 30)
            DropdownMain.Font = Enum.Font.Gotham
            DropdownMain.Text = "<"
            DropdownMain.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropdownMain.TextSize = 18.000

            DropdownText.Name = "DropdownText"
            DropdownText.Parent = Dropdown
            DropdownText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            DropdownText.BackgroundTransparency = 1.000
            DropdownText.Position = UDim2.new(0, 0, 0.0333333351, 0)
            DropdownText.Size = UDim2.new(0, 323, 0, 29)
            DropdownText.Font = Enum.Font.Gotham
            DropdownText.Text = "  " .. Options.text
            DropdownText.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropdownText.TextSize = 14.000
            DropdownText.TextXAlignment = Enum.TextXAlignment.Left

            DropdownContainer.Name = "DropdownContainer"
            DropdownContainer.Parent = Dropdown
            DropdownContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            DropdownContainer.Position = UDim2.new(0, 0, 1, 0)
            DropdownContainer.Size = UDim2.new(0, 353, 0, 25)
            DropdownContainer.Visible = false

            DropdownCornerMain.CornerRadius = UDim.new(0, 4)
            DropdownCornerMain.Name = "DropdownCornerMain"
            DropdownCornerMain.Parent = DropdownContainer

            DropdownContainerList.Name = "DropdownContainerList"
            DropdownContainerList.Parent = DropdownContainer
            DropdownContainerList.SortOrder = Enum.SortOrder.LayoutOrder

            -- Code
            Options.selected = {}
            Options.buttons = {}

            UILibrary:AddConnection(DropdownContainerList:GetPropertyChangedSignal("AbsoluteContentSize"), function()
                DropdownContainer.Size = UDim2.new(0, 353, 0, DropdownContainerList.AbsoluteContentSize.Y)
            end)

            for _, Item in pairs(Options.values) do
                local DropdownItem = Instance.new("TextButton")

                DropdownItem.Name = "DropdownItem"
                DropdownItem.Parent = DropdownContainer
                DropdownItem.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                DropdownItem.BackgroundTransparency = 1.000
                DropdownItem.BorderSizePixel = 0
                DropdownItem.Size = UDim2.new(0, 353, 0, 25)
                DropdownItem.Font = Enum.Font.Gotham
                DropdownItem.Text = Item
                DropdownItem.TextColor3 = Color3.fromRGB(255, 255, 255)
                DropdownItem.TextSize = 14.000

                Options.buttons[Item] = DropdownItem

                UILibrary:AddConnection(DropdownItem.MouseButton1Click, function()
                    if (Options.multiselect) then
                        if (table.find(Options.selected, Item)) then
                            for i,v in pairs(Options.selected) do
                                if (v == Item) then
                                    table.remove(Options.selected)
                                end
                            end

                            TweenService:Create(DropdownItem, TweenInfo.new(0.200), {
                                TextColor3 = Color3.new(1, 1, 1)
                            }):Play()
                        else
                            table.insert(Options.selected, Item)
                            TweenService:Create(DropdownItem, TweenInfo.new(0.200), {
                                TextColor3 = Color
                            }):Play()
                        end

                        UILibrary.flags[Options.flag] = Options.selected
                        Options.callback(Options.selected)
                    else
                        TweenService:Create(DropdownItem, TweenInfo.new(0.200), {
                            TextColor3 = Color
                        }):Play()

                        Options.value = Item
                        UILibrary.flags[Options.flag] = Item
                        Options.callback(Item)

                        for i,v in pairs(DropdownContainer:GetChildren()) do
                            if (v.Name == "DropdownItem" and v ~= DropdownItem) then
                                v.TextColor3 = Color3.new(1, 1, 1)
                            end
                        end
                    end
                end)
            end

            UILibrary:AddConnection(DropdownMain.MouseButton1Click, function()
                for i,v in pairs(Container:GetChildren()) do
                    if (v.Name == "Dropdown" and v ~= Dropdown) then
                        v.DropdownContainer.Visible = false
                        v.ZIndex = 1

                        TweenService:Create(v.DropdownMain, TweenInfo.new(0.200), {
                            Rotation = 0
                        }):Play()
                    end
                end

                DropdownContainer.Visible = not DropdownContainer.Visible
                Dropdown.ZIndex = DropdownContainer.Visible and 4 or 1

                for i,v in pairs(DropdownContainer:GetChildren()) do
                    if (v.Name == "DropdownItem") then
                        v.Visible = DropdownContainer.Visible
                    end
                end

                TweenService:Create(DropdownContainer, TweenInfo.new(0.400), {
                    Size = UDim2.new(1, 0, 0, DropdownContainer.Visible and DropdownContainerList.AbsoluteContentSize.Y or 0)
                }):Play()

                TweenService:Create(DropdownMain, TweenInfo.new(0.200), {
                    Rotation = DropdownContainer.Visible and -90 or 0
                }):Play()
            end)

            -- Returns
            function DropdownTypes:SetValue(Item)
                local DropdownItem = Options.buttons[Item]

                if (DropdownItem) then
                    if (Options.multiselect) then
                        table.insert(Options.selected, Item)

                        TweenService:Create(DropdownItem, TweenInfo.new(0.200), {
                            TextColor3 = Color
                        }):Play()

                        UILibrary.flags[Options.flag] = Options.selected
                        Options.callback(Options.selected)
                    else
                        TweenService:Create(DropdownItem, TweenInfo.new(0.200), {
                            TextColor3 = Color
                        }):Play()

                        Options.value = Item
                        UILibrary.flags[Options.flag] = Item
                        Options.callback(Item)

                        for i,v in pairs(DropdownContainer:GetChildren()) do
                            if (v.Name == "DropdownItem" and v ~= DropdownItem) then
                                v.TextColor3 = Color3.new(1, 1, 1)
                            end
                        end
                    end
                end
            end

            function DropdownTypes:RemoveValue(Item)
                local DropdownItem = Options.buttons[Item]

                if (DropdownItem) then
                    if (Options.multiselect and table.find(Options.selected, Item)) then
                        table.remove(Options.selected, Item)
                    end

                    DropdownItem:Destroy()

                    TweenService:Create(DropdownContainer, TweenInfo.new(0.400), {
                        Size = UDim2.new(1, 0, 0, DropdownContainerList.AbsoluteContentSize.Y)
                    }):Play()
                end
            end

            DropdownTypes:SetValue(Options.value)

            UILibrary.options[Options.flag] = DropdownTypes

            return DropdownTypes
        end

        function TabTypes:CreateColorpicker(Options)
            -- Variables
            Options = Options or {}
            Options.text = Options.text or ""
            Options.color = Options.color or Color3.new(1, 1, 1)
            Options.flag = Options.flag or Options.text
            Options.callback = Options.callback or function() end

            local ColorpickerTypes = {}

            -- Instances
            local Colorpicker = Instance.new("Frame")
            local ColorpickerCorner = Instance.new("UICorner")
            local ColorpickerText = Instance.new("TextLabel")
            local ColorpickerColorFrame = Instance.new("Frame")
            local ColorpickerColorCorner = Instance.new("UICorner")
            local ColorpickerColorMain = Instance.new("TextButton")
            local ColorpickerBox = Instance.new("Frame")
            local ColorCorner = Instance.new("UICorner")
            local Colorbox = Instance.new("Frame")
            local ColorboxGradient = Instance.new("ImageLabel")
            local ColorboxSelection = Instance.new("ImageLabel")
            local ColorboxGradientCorner = Instance.new("UICorner")
            local ColorboxCorner = Instance.new("UICorner")
            local ColorGradient = Instance.new("UIGradient")
            local ColorPadding = Instance.new("UIPadding")
            local ColorSlider = Instance.new("Frame")
            local RainbowGradient = Instance.new("UIGradient")
            local ColorSliderCorner = Instance.new("UICorner")
            local ColorSliderBar = Instance.new("Frame")
            local ColorTitle = Instance.new("TextLabel")
            local RedColorTextbox = Instance.new("TextBox")
            local RedColorCorner = Instance.new("UICorner")
            local GreenColorTextbox = Instance.new("TextBox")
            local GreenColorCorner = Instance.new("UICorner")
            local BlueColorTextbox = Instance.new("TextBox")
            local BlueColorCorner = Instance.new("UICorner")

            -- Properties
            Colorpicker.Name = "Colorpicker"
            Colorpicker.Parent = Container
            Colorpicker.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            Colorpicker.Position = UDim2.new(0.039164491, 0, 0.039164491, 0)
            Colorpicker.Size = UDim2.new(0, 353, 0, 30)

            ColorpickerCorner.CornerRadius = UDim.new(0, 4)
            ColorpickerCorner.Name = "ColorpickerCorner"
            ColorpickerCorner.Parent = Colorpicker

            ColorpickerText.Name = "ColorpickerText"
            ColorpickerText.Parent = Colorpicker
            ColorpickerText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ColorpickerText.BackgroundTransparency = 1.000
            ColorpickerText.Position = UDim2.new(0, 0, 0.0333333351, 0)
            ColorpickerText.Size = UDim2.new(0, 323, 0, 29)
            ColorpickerText.Font = Enum.Font.Gotham
            ColorpickerText.Text = " " .. Options.text
            ColorpickerText.TextColor3 = Color3.fromRGB(255, 255, 255)
            ColorpickerText.TextSize = 14.000
            ColorpickerText.TextXAlignment = Enum.TextXAlignment.Left

            ColorpickerColorFrame.Name = "ColorpickerColorFrame"
            ColorpickerColorFrame.Parent = Colorpicker
            ColorpickerColorFrame.BackgroundColor3 = Options.color
            ColorpickerColorFrame.Position = UDim2.new(0.929178476, 0, 0.166666672, 0)
            ColorpickerColorFrame.Size = UDim2.new(0, 20, 0, 20)

            ColorpickerColorCorner.CornerRadius = UDim.new(0, 4)
            ColorpickerColorCorner.Name = "ColorpickerColorCorner"
            ColorpickerColorCorner.Parent = ColorpickerColorFrame

            ColorpickerColorMain.Name = "ColorpickerColorMain"
            ColorpickerColorMain.Parent = ColorpickerColorFrame
            ColorpickerColorMain.BackgroundColor3 = Color3.new(1, 1, 1)
            ColorpickerColorMain.BackgroundTransparency = 1.000
            ColorpickerColorMain.BorderSizePixel = 0
            ColorpickerColorMain.Size = UDim2.new(0, 20, 0, 20)
            ColorpickerColorMain.Font = Enum.Font.SourceSans
            ColorpickerColorMain.Text = ""
            ColorpickerColorMain.TextColor3 = Color3.fromRGB(0, 0, 0)
            ColorpickerColorMain.TextSize = 14.000

            ColorpickerBox.Name = "ColorpickerBox"
            ColorpickerBox.Visible = false
            ColorpickerBox.Parent = MainContainer
            ColorpickerBox.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
            ColorpickerBox.Position = UDim2.new(1.03394258, 0, 0, 0)
            ColorpickerBox.Size = UDim2.new(0, 184, 0, 250)

            ColorCorner.CornerRadius = UDim.new(0, 4)
            ColorCorner.Name = "ColorCorner"
            ColorCorner.Parent = ColorpickerBox

            Colorbox.Name = "Colorbox"
            Colorbox.Parent = ColorpickerBox
            Colorbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Colorbox.Position = UDim2.new(0, 0, 0, 15)
            Colorbox.Size = UDim2.new(0, 154, 0, 155)

            ColorboxGradient.Name = "ColorboxGradient"
            ColorboxGradient.Parent = Colorbox
            ColorboxGradient.BackgroundColor3 = Options.color
            ColorboxGradient.BorderSizePixel = 0
            ColorboxGradient.Position = UDim2.new()
            ColorboxGradient.Size = UDim2.new(1, 0, 1, 0)
            ColorboxGradient.ZIndex = 10
            ColorboxGradient.Image = "rbxassetid://4155801252"

            ColorboxSelection.Name = "ColorboxSelection"
            ColorboxSelection.Parent = Colorbox
            ColorboxSelection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ColorboxSelection.BackgroundTransparency = 1.000
            ColorboxSelection.ZIndex = 25
            ColorboxSelection.AnchorPoint = Vector2.new(0.5, 0.5)
            ColorboxSelection.Position = UDim2.new()
            ColorboxSelection.Size = UDim2.new(0, 18, 0, 18)
            ColorboxSelection.Image = "rbxassetid://4953646208"
            ColorboxSelection.ScaleType = Enum.ScaleType.Fit

            ColorboxGradientCorner.CornerRadius = UDim.new(0, 4)
            ColorboxGradientCorner.Name = "ColorboxGradientCorner"
            ColorboxGradientCorner.Parent = ColorboxGradient

            ColorboxCorner.CornerRadius = UDim.new(0, 4)
            ColorboxCorner.Name = "ColorboxCorner"
            ColorboxCorner.Parent = Colorbox

            ColorGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0))}
            ColorGradient.Rotation = 90
            ColorGradient.Name = "ColorGradient"
            ColorGradient.Parent = Colorbox

            ColorPadding.Name = "ColorPadding"
            ColorPadding.Parent = ColorpickerBox
            ColorPadding.PaddingLeft = UDim.new(0, 15)
            ColorPadding.PaddingTop = UDim.new(0, 15)

            ColorSlider.Name = "ColorSlider"
            ColorSlider.Parent = ColorpickerBox
            ColorSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ColorSlider.Position = UDim2.new(0, 0, 0.765258253, 0)
            ColorSlider.Size = UDim2.new(0, 154, 0, 15)

            RainbowGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(0.20, Color3.fromRGB(255, 0, 251)),
                ColorSequenceKeypoint.new(0.40, Color3.fromRGB(0, 17, 255)),
                ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 255, 255)),
                ColorSequenceKeypoint.new(0.80, Color3.fromRGB(21, 255, 0)),
                ColorSequenceKeypoint.new(0.90, Color3.fromRGB(234, 255, 0)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))
            }
            RainbowGradient.Name = "RainbowGradient"
            RainbowGradient.Parent = ColorSlider

            ColorSliderCorner.CornerRadius = UDim.new(0, 4)
            ColorSliderCorner.Name = "ColorSliderCorner"
            ColorSliderCorner.Parent = ColorSlider

            ColorSliderBar.Name = "ColorSliderBar"
            ColorSliderBar.Parent = ColorSlider
            ColorSliderBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ColorSliderBar.BorderSizePixel = 0
            ColorSliderBar.Size = UDim2.new(0, 1, 1, 0)

            ColorTitle.Name = "ColorTitle"
            ColorTitle.Parent = ColorpickerBox
            ColorTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ColorTitle.BackgroundTransparency = 1.000
            ColorTitle.Position = UDim2.new(0, 0, -0.0638297871, 0)
            ColorTitle.Size = UDim2.new(0, 154, 0, 30)
            ColorTitle.Font = Enum.Font.Gotham
            ColorTitle.Text = Options.text
            ColorTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            ColorTitle.TextSize = 14.000
            ColorTitle.TextXAlignment = Enum.TextXAlignment.Left

            RedColorTextbox.Name = "RedColorTextbox"
            RedColorTextbox.Parent = ColorpickerBox
            RedColorTextbox.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
            RedColorTextbox.Position = UDim2.new(0, 0, 0.872340441, 0)
            RedColorTextbox.Size = UDim2.new(0, 48, 0, 20)
            RedColorTextbox.Font = Enum.Font.Gotham
            RedColorTextbox.Text = "R: 255"
            RedColorTextbox.TextColor3 = Color3.fromRGB(255, 255, 255)
            RedColorTextbox.TextSize = 14.000

            RedColorCorner.CornerRadius = UDim.new(0, 4)
            RedColorCorner.Name = "RedColorCorner"
            RedColorCorner.Parent = RedColorTextbox

            GreenColorTextbox.Name = "GreenColorTextbox"
            GreenColorTextbox.Parent = ColorpickerBox
            GreenColorTextbox.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
            GreenColorTextbox.Position = UDim2.new(0.309337258, 0, 0.871999979, 0)
            GreenColorTextbox.Size = UDim2.new(0, 48, 0, 20)
            GreenColorTextbox.Font = Enum.Font.Gotham
            GreenColorTextbox.Text = "G: 255"
            GreenColorTextbox.TextColor3 = Color3.fromRGB(255, 255, 255)
            GreenColorTextbox.TextSize = 14.000

            GreenColorCorner.CornerRadius = UDim.new(0, 4)
            GreenColorCorner.Name = "GreenColorCorner"
            GreenColorCorner.Parent = GreenColorTextbox

            BlueColorTextbox.Name = "BlueColorTextbox"
            BlueColorTextbox.Parent = ColorpickerBox
            BlueColorTextbox.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
            BlueColorTextbox.Position = UDim2.new(0.621591747, 0, 0.871999979, 0)
            BlueColorTextbox.Size = UDim2.new(0, 48, 0, 20)
            BlueColorTextbox.Font = Enum.Font.Gotham
            BlueColorTextbox.Text = "B: 255"
            BlueColorTextbox.TextColor3 = Color3.fromRGB(255, 255, 255)
            BlueColorTextbox.TextSize = 14.000

            BlueColorCorner.CornerRadius = UDim.new(0, 4)
            BlueColorCorner.Name = "BlueColorCorner"
            BlueColorCorner.Parent = BlueColorTextbox

            -- Code
            Options.dragging = false
            Options.colordragging = false
            Options.colorinput = nil
            Options.hueinput = nil
            Options.h = 5
            Options.s = 1
            Options.v = 1
            Options.draginput = nil
            Options.dragstart = nil
            Options.startpos = nil

            local function UpdateColor()
                Colorbox.BackgroundColor3 = Color3.fromHSV(Options.h, Options.s, Options.v)
                ColorboxGradient.BackgroundColor3 = Color3.fromHSV(Options.h, 1, 1)
                ColorpickerColorFrame.BackgroundColor3 = Colorbox.BackgroundColor3

                Options.color = Colorbox.BackgroundColor3

                RedColorTextbox.Text = "R: " .. math.floor(math.clamp(Options.color.R * 255, 0, 255))
                GreenColorTextbox.Text = "G: " .. math.floor(math.clamp(Options.color.G * 255, 0, 255))
                BlueColorTextbox.Text = "B: " .. math.floor(math.clamp(Options.color.B * 255, 0, 255))

                UILibrary.flags[Options.flag] = Options.color
                Options.callback(Options.color)
            end

            local function SetupTextbox(Textbox, Index)
                local LastText = Textbox.Text

                UILibrary:AddConnection(Textbox.FocusLost, function(EnterPressed)
                    if (EnterPressed) then
                        if (Textbox.Text ~= "" or tonumber(Textbox.Text) ~= nil) then
                            local Value = tonumber(Textbox.Text)
                            local H, S, V = Color3.fromRGB(Index == 1 and Value or 0, Index == 2 and Value or 0, Index == 3 and Value or 0):ToHSV()

                            if (Index == 1) then
                                Options.h = H
                            elseif (Index == 2) then
                                Options.s = S
                            elseif (Index == 3) then
                                Options.v = V
                            end

                            UpdateColor()
                        else
                            Textbox.Text = LastText
                        end
                    else
                        Textbox.Text = LastText
                    end
                end)
            end

            UILibrary:AddConnection(ColorpickerBox.InputBegan, function(Input)
                if (Input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:GetFocusedTextBox() == nil) then
                    Options.dragstart = Input.Position
                    Options.startpos = ColorpickerBox.Position
                    Options.colordragging = true
                    UILibrary.colordragging = true
                    UILibrary:AddConnection(Input.Changed, function()
                        if (Input.UserInputState == Enum.UserInputState.End) then
                            Options.colordragging = false
                            UILibrary.colordragging = false
                        end
                    end)
                end
            end)

            UILibrary:AddConnection(ColorpickerBox.InputChanged, function(Input)
                if (Input.UserInputType == Enum.UserInputType.MouseMovement) then
                    Options.draginput = Input
                end
            end)

            UILibrary:AddConnection(UserInputService.InputChanged, function(Input)
                if (Input == Options.draginput and Options.colordragging and not UILibrary.sliderdragging and not Options.dragging) then
                    local Delta = Input.Position - Options.dragstart
                    local Position = UDim2.new(Options.startpos.X.Scale, Options.startpos.X.Offset + Delta.X, Options.startpos.Y.Scale, Options.startpos.Y.Offset + Delta.Y)

                    TweenService:Create(ColorpickerBox, TweenInfo.new(0.150), {
                        Position = Position
                    }):Play()
                end
            end)

            UILibrary:AddConnection(ColorpickerColorMain.MouseButton1Click, function()
                ColorpickerBox.Visible = not ColorpickerBox.Visible
            end)

            UILibrary:AddConnection(ColorboxGradient.InputBegan, function(Input)
                if (Input.UserInputType == Enum.UserInputType.MouseButton1) then
                    if (Options.colorinput) then
                        Options.colorinput:Disconnect()
                    end

                    Options.colorinput = RunService.RenderStepped:Connect(function()
                        local ColorX = math.clamp(Mouse.X - ColorSlider.AbsolutePosition.X, 0, ColorSlider.AbsoluteSize.X) / ColorSlider.AbsoluteSize.X
                        local ColorY = math.clamp(Mouse.Y - ColorboxGradient.AbsolutePosition.Y, 0, ColorboxGradient.AbsoluteSize.Y) / ColorboxGradient.AbsoluteSize.Y

                        Options.s = ColorX
                        Options.v = 1 - ColorY

                        ColorboxSelection.Position = UDim2.new(ColorX, 0, ColorY, 0)
                        UpdateColor()
                    end)

                    Options.dragging = true
                end
            end)

            UILibrary:AddConnection(ColorboxGradient.InputEnded, function(Input)
                if (Input.UserInputType == Enum.UserInputType.MouseButton1) then
                    if (Options.colorinput) then
                        Options.colorinput:Disconnect()
                    end

                    Options.dragging = false
                end
            end)

            UILibrary:AddConnection(ColorSlider.InputBegan, function(Input)
                if (Input.UserInputType == Enum.UserInputType.MouseButton1) then
                    if (Options.hueinput) then
                        Options.hueinput:Disconnect()
                    end

                    Options.hueinput = RunService.RenderStepped:Connect(function()
                        local HueY = math.clamp(Mouse.X - ColorSlider.AbsolutePosition.X, 0, ColorSlider.AbsoluteSize.X) / ColorSlider.AbsoluteSize.X

                        Options.h = 1 - HueY

                        ColorSliderBar.Position = UDim2.new(HueY, 0, 0, 0)
                        UpdateColor()
                    end)

                    Options.dragging = true
                end
            end)

            UILibrary:AddConnection(ColorSlider.InputEnded, function(Input)
                if (Input.UserInputType == Enum.UserInputType.MouseButton1) then
                    if (Options.hueinput) then
                        Options.hueinput:Disconnect()
                    end

                    Options.dragging = false
                end
            end)

            SetupTextbox(RedColorTextbox, 1)
            SetupTextbox(GreenColorTextbox, 2)
            SetupTextbox(BlueColorTextbox, 3)

            -- Returns
            function ColorpickerTypes:SetColor(Color)
                Color = Color or Color3.new(1, 1, 1)
                Options.h, Options.s, Options.v = Color:ToHSV()
                UpdateColor()
            end

            function ColorpickerTypes:GetColor()
                return Options.color
            end

            ColorpickerTypes:SetColor(Options.color)

            UILibrary.options[Options.flag] = ColorpickerTypes

            return ColorpickerTypes
        end

        function TabTypes:CreateKeybind(Options)
            -- Variables
            Options = Options or {}
            Options.text = Options.text or "Keybind"
            Options.bind = Options.bind or "None"
            Options.mode = Options.mode or "toggled"
            Options.nomouse = Options.nomouse or false
            Options.flag = Options.flag or Options.text
            Options.callback = Options.callback or function() end

            local KeybindTypes = {}

            -- Instances
            local Keybind = Instance.new("Frame")
            local KeybindMain = Instance.new("TextButton")
            local KeybindCorner = Instance.new("UICorner")
            local KeybindText = Instance.new("TextLabel")
            local KeybindBind = Instance.new("TextBox")

            -- Properties
            Keybind.Name = "Keybind"
            Keybind.Parent = Container
            Keybind.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            Keybind.Size = UDim2.new(0, 353, 0, 30)

            KeybindMain.Name = "KeybindMain"
            KeybindMain.Parent = Keybind
            KeybindMain.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            KeybindMain.BackgroundTransparency = 1.000
            KeybindMain.Text = ""
            KeybindMain.Size = UDim2.new(1, 0, 1, 0)

            KeybindCorner.CornerRadius = UDim.new(0, 4)
            KeybindCorner.Name = "KeybindCorner"
            KeybindCorner.Parent = Keybind

            KeybindText.Name = "KeybindText"
            KeybindText.Parent = Keybind
            KeybindText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            KeybindText.BackgroundTransparency = 1.000
            KeybindText.BorderSizePixel = 0
            KeybindText.Size = UDim2.new(0, 295, 0, 29)
            KeybindText.Font = Enum.Font.Gotham
            KeybindText.Text = "  " .. Options.text
            KeybindText.TextColor3 = Color3.fromRGB(255, 255, 255)
            KeybindText.TextSize = 14.000
            KeybindText.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
            KeybindText.TextXAlignment = Enum.TextXAlignment.Left

            KeybindBind.Name = "KeybindBind"
            KeybindBind.Parent = Keybind
            KeybindBind.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
            KeybindBind.BorderSizePixel = 0
            KeybindBind.Position = UDim2.new(0.836000025, 0, 0.209999993, 0)
            KeybindBind.Size = UDim2.new(0, 50, 0, 19)
            KeybindBind.Font = Enum.Font.Gotham
            KeybindBind.Text = "None"
            KeybindBind.ClearTextOnFocus = false
            KeybindBind.TextEditable = false
            KeybindBind.TextColor3 = Color3.fromRGB(255, 255, 255)
            KeybindBind.TextSize = 14.000

            -- Code
            Options.clicked = false
            Options.binding = false
            Options.blacklisted = { "W", "A", "S", "D", "Slash", "Tab", "Backspace", "Escape", "Space", "Delete", "Unknown" }

            UILibrary:AddConnection(KeybindMain.MouseButton1Click, function()
                Options.clicked = true
                KeybindBind.Text = "..."
            end)

            UILibrary:AddConnection(RunService.Heartbeat, function()
                if (not Options.binding) then
                    if (Options.clicked) then
                        Options.binding = true
                        Options.clicked = false
                    elseif (Options.mode == "hold") then
                        Options.toggled = UserInputService:IsKeyDown(Options.bind)

                        if (Options.toggled) then
                            UILibrary.flags[Options.flag] = Options.toggled
                            Options.callback(Options.toggled, Options.bind)
                        end
                    end
                end
            end)

            UILibrary:AddConnection(UserInputService.InputBegan, function(Input)
                if (Input.UserInputType == Enum.UserInputType.Keyboard) then
                    if (Options.binding) then
                        local Key = tostring(Input.KeyCode):gsub("Enum.KeyCode.", "")

                        if (not table.find(Options.blacklisted, Key)) then
                            KeybindBind.Text = Key
                            Options.bind = Key
                        else
                            KeybindBind.Text = "None"
                        end

                        Options.binding = false
                    else
                        local Key = tostring(Input.KeyCode):gsub("Enum.KeyCode.", "")

                        if (Key == Options.bind) then
                            if (Options.mode == "toggled") then
                                Options.toggled = not Options.toggled
                            end

                            UILibrary.flags[Options.flag] = Options.toggled
                            Options.callback(Options.toggled, Key)
                        end
                    end
                end
            end)

            -- Returns
            function KeybindTypes:SetBind(Bind)
                if (not table.find(Options.blacklisted, Bind)) then
                    Options.bind = Bind
                    KeybindBind.Text = Bind
                end
            end

            UILibrary.options[Options.flag] = KeybindTypes

            return KeybindTypes
        end

        function TabTypes:CreateTextbox(Options)
            -- Variables
            Options = Options or {}
            Options.text = Options.text or "Textbox"
            Options.value = Options.value or ""
            Options.flag = Options.flag or Options.text
            Options.callback = Options.callback or function() end

            local TextboxTypes = {}

            -- Instances
            local Textbox = Instance.new("Frame")
            local TextboxCorner = Instance.new("UICorner")
            local TextboxText = Instance.new("TextLabel")
            local TextboxBox = Instance.new("TextBox")

            -- Properties
            Textbox.Name = "Textbox"
            Textbox.Parent = Container
            Textbox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            Textbox.Size = UDim2.new(0, 353, 0, 30)

            TextboxCorner.CornerRadius = UDim.new(0, 4)
            TextboxCorner.Name = "TextboxCorner"
            TextboxCorner.Parent = Textbox

            TextboxText.Name = "TextboxText"
            TextboxText.Parent = Textbox
            TextboxText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextboxText.BackgroundTransparency = 1.000
            TextboxText.BorderSizePixel = 0
            TextboxText.Size = UDim2.new(0, 195, 0, 29)
            TextboxText.Font = Enum.Font.Gotham
            TextboxText.Text = "  " .. Options.text
            TextboxText.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextboxText.TextSize = 14.000
            TextboxText.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
            TextboxText.TextXAlignment = Enum.TextXAlignment.Left

            TextboxBox.Name = "TextboxBox"
            TextboxBox.Parent = Textbox
            TextboxBox.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
            TextboxBox.BorderSizePixel = 0
            TextboxBox.Position = UDim2.new(0.55240792, 0, 0.209999591, 0)
            TextboxBox.Size = UDim2.new(0, 150, 0, 19)
            TextboxBox.Font = Enum.Font.Gotham
            TextboxBox.PlaceholderText = "Type here"
            TextboxBox.Text = Options.value
            TextboxBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextboxBox.TextSize = 14.000
            TextboxBox.TextWrapped = true

            -- Code
            Options.text = TextboxBox.Text

            UILibrary:AddConnection(TextboxBox.FocusLost, function(EnterPressed)
                TextboxTypes:SetText(TextboxBox.Text, Options.text)
                Options.text = TextboxText.Text
            end)

            -- Returns
            function TextboxTypes:SetText(Text, LastText)
                Options.value = Text
                TextboxBox.Text = Text
                UILibrary.flags[Options.flag] = Options.value
                Options.callback(Options.value, LastText)
            end

            function TextboxTypes:GetText()
                return Options.value
            end

            TextboxTypes:SetText(Options.value, TextboxText.Text)

            UILibrary.options[Options.flag] = TextboxTypes

            return TextboxTypes
        end

        function TabTypes:CreateLabel(Options)
            -- Variables
            Options = Options or {}
            Options.text = Options.text or "Label"

            local LabelTypes = {}

            -- Instances
            local Label = Instance.new("Frame")
            local LabelCorner = Instance.new("UICorner")
            local LabelText = Instance.new("TextLabel")

            -- Properties
            Label.Name = "Label"
            Label.Parent = Container
            Label.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            Label.Size = UDim2.new(0, 353, 0, 30)

            LabelCorner.CornerRadius = UDim.new(0, 4)
            LabelCorner.Name = "LabelCorner"
            LabelCorner.Parent = Label

            LabelText.Name = "LabelText"
            LabelText.Parent = Label
            LabelText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            LabelText.BackgroundTransparency = 1.000
            LabelText.BorderSizePixel = 0
            LabelText.Size = UDim2.new(0, 353, 0, 29)
            LabelText.Font = Enum.Font.Gotham
            LabelText.Text = "  " .. Options.text
            LabelText.TextColor3 = Color3.fromRGB(255, 255, 255)
            LabelText.TextSize = 14.000
            LabelText.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
            LabelText.TextXAlignment = Enum.TextXAlignment.Left

            -- Returns
            function LabelTypes:SetText(Text)
                LabelText.Text = Text
            end

            function LabelTypes:GetText()
                return LabelText.Text
            end

            return LabelTypes
        end

        function TabTypes:CreateSubLabel(Options)
            -- Variables
            Options = Options or {}
            Options.text = Options.text or "Sub Label"

            local SubLabelTypes = {}

            -- Instances
            local SubLabel = Instance.new("Frame")
            local SubLabelCorner = Instance.new("UICorner")
            local SubLabelText = Instance.new("TextLabel")

            -- Properties
            SubLabel.Name = "SubLabel"
            SubLabel.Parent = Container
            SubLabel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            SubLabel.BackgroundTransparency = 1.000
            SubLabel.Position = UDim2.new(0, 0, 0.625, 0)
            SubLabel.Size = UDim2.new(0, 353, 0, 20)

            SubLabelCorner.CornerRadius = UDim.new(0, 4)
            SubLabelCorner.Name = "SubLabelCorner"
            SubLabelCorner.Parent = SubLabel

            SubLabelText.Name = "SubLabelText"
            SubLabelText.Parent = SubLabel
            SubLabelText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SubLabelText.BackgroundTransparency = 1.000
            SubLabelText.BorderSizePixel = 0
            SubLabelText.Size = UDim2.new(1, 0, 1, 0)
            SubLabelText.Font = Enum.Font.Gotham
            SubLabelText.Text = Options.text
            SubLabelText.TextColor3 = Color3.fromRGB(158, 158, 158)
            SubLabelText.TextSize = 14.000
            SubLabelText.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
            SubLabelText.TextXAlignment = Enum.TextXAlignment.Left

            -- Returns
            function SubLabelTypes:SetText(Text)
                SubLabelText.Text = Text
            end

            function SubLabelTypes:GetText()
                return SubLabelText.Text
            end

            return SubLabelTypes
        end

        return TabTypes
    end

    return WinTypes, Falika
end

local Window = UILibrary:CreateWindow("Arsenal")
local Tab = Window:CreateTab("Settings")

Tab:CreateToggle({text = "E", flag = "wowie"})
Tab:CreateSlider({text = "W", flag = "wow"})
Tab:CreateDropdown({text = "H", values = {"A","B"}, flag = "gu"})

writefile("wow.txt", "")

Tab:CreateButton({text = "Load Config", callback = function()
    UILibrary:LoadConfig("wow.txt")
end})

Tab:CreateButton({text = "Save Config", callback = function()
    UILibrary:SaveConfig("wow.txt")
end})

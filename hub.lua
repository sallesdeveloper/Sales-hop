-- Salles Hop — Interface + Botão Vegeta + ESP God/Secret + Server Hop Inteligente

local Players       = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService   = game:GetService("HttpService")
local player        = Players.LocalPlayer

-- Brainrots Lists
local gods = {
    "Tripi Tropi", "El Grandote", "Zé Grandão", "Gabriela God", "True Transcendence",
    "Madness God", "Saturn God", "Mr Tralalero", "King Brainrot", "Cefadrina Rex"
}
local secrets = {
    "La Vacca Saturno Saturnita", "Los Tralaleritos", "Las Tralaleritas",
    "Las Vaquitas Saturnitas", "Chicleteira Bicicleteira", "Graipuss Medussi",
    "La Grande Combinasion", "Nuclearo Dinossauro", "Tortuginni Dragonfruitini",
    "Pot Hotspot", "Garama and Madundung", "Sammyni Spyderini", "Chimpanzini Spiderini"
}

-- Função para criar ESP acima da cabeça
local function createESP(npc, text, color)
    local root = npc:FindFirstChild("Head") or npc:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if root:FindFirstChild("SallesESP") then return end

    local gui = Instance.new("BillboardGui", root)
    gui.Name = "SallesESP"
    gui.Size = UDim2.new(0, 120, 0, 40)
    gui.Adornee = root
    gui.StudsOffset = Vector3.new(0, 2.5, 0)
    gui.AlwaysOnTop = true

    local label = Instance.new("TextLabel", gui)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = text
    label.TextColor3 = color
    label.BackgroundTransparency = 1
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
end

-- Setup da interface
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "SallesHop"
gui.ResetOnSpawn = false

-- Toggle button (bolinha Vegeta)
local toggleBtn = Instance.new("ImageButton", gui)
toggleBtn.Size = UDim2.new(0, 60, 0, 60)
toggleBtn.Position = UDim2.new(0, 10, 1, -80)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Image = "rbxassetid://15406218239" -- Troque se tiver outro asset ID disponível

-- Janela principal
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 340, 0, 330)
main.Position = UDim2.new(0.5, -170, 0.5, -165)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
main.BorderSizePixel = 0
main.Visible = false
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

-- Título
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 45)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(0, 110, 220)
title.Text = "SALLES HOP"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold

-- Subtítulo
local subtitle = Instance.new("TextLabel", main)
subtitle.Size = UDim2.new(1, 0, 0, 25)
subtitle.Position = UDim2.new(0, 0, 0, 45)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Sistema Avançado de Detecção"
subtitle.TextColor3 = Color3.fromRGB(200,200,200)
subtitle.TextScaled = true
subtitle.Font = Enum.Font.Gotham

-- Status display
local statusLabel = Instance.new("TextLabel", main)
statusLabel.Size = UDim2.new(1, -20, 0, 40)
statusLabel.Position = UDim2.new(0, 10, 0, 80)
statusLabel.BackgroundColor3 = Color3.fromRGB(20,20,25)
statusLabel.Text = "Buscando próximo servidor..."
statusLabel.TextColor3 = Color3.fromRGB(180,180,255)
statusLabel.TextScaled = true
Instance.new("UICorner", statusLabel).CornerRadius = UDim.new(0,4)

-- Contadores
local count = Instance.new("TextLabel", main)
count.Size = UDim2.new(1, -20, 0, 30)
count.Position = UDim2.new(0, 10, 0, 130)
count.BackgroundTransparency = 1
count.Text = "Verificados: 0   Encontrados: 0"
count.TextColor3 = Color3.new(1,1,1)
count.TextScaled = true
count.Font = Enum.Font.Gotham

-- Iniciar Hop
local iniciarBtn = Instance.new("TextButton", main)
iniciarBtn.Size = UDim2.new(0.9, 0, 0, 45)
iniciarBtn.Position = UDim2.new(0.05, 0, 0, 175)
iniciarBtn.BackgroundColor3 = Color3.fromRGB(0,160,0)
iniciarBtn.Text = "Iniciar Hop"
iniciarBtn.TextColor3 = Color3.new(1,1,1)
iniciarBtn.TextScaled = true
iniciarBtn.Font = Enum.Font.GothamBold

-- Parar
local pararBtn = Instance.new("TextButton", main)
pararBtn.Size = UDim2.new(0.9, 0, 0, 45)
pararBtn.Position = UDim2.new(0.05, 0, 0, 225)
pararBtn.BackgroundColor3 = Color3.fromRGB(220,40,40)
pararBtn.Text = "PARAR"
pararBtn.TextColor3 = Color3.new(1,1,1)
pararBtn.TextScaled = true
pararBtn.Font = Enum.Font.GothamBold
pararBtn.Visible = false

-- Botões ESP
local espGodBtn = Instance.new("TextButton", main)
espGodBtn.Size = UDim2.new(0.45,0,0,45)
espGodBtn.Position = UDim2.new(0.05,0,1,-55)
espGodBtn.BackgroundColor3 = Color3.fromRGB(255,95,180)
espGodBtn.Text = "ESP God"
espGodBtn.TextColor3 = Color3.new(1,1,1)
espGodBtn.TextScaled = true
espGodBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", espGodBtn).CornerRadius = UDim.new(0,4)

local espSecretBtn = Instance.new("TextButton", main)
espSecretBtn.Size = UDim2.new(0.45,0,0,45)
espSecretBtn.Position = UDim2.new(0.5,10,1,-55)
espSecretBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
espSecretBtn.Text = "ESP Secret"
espSecretBtn.TextColor3 = Color3.new(1,1,1)
espSecretBtn.TextScaled = true
espSecretBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", espSecretBtn).CornerRadius = UDim.new(0,4)

-- Evento toggle interface
toggleBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

-- ESP God
espGodBtn.MouseButton1Click:Connect(function()
    for _, npc in pairs(workspace:GetDescendants()) do
        if npc:IsA("Model") and npc:FindFirstChild("Head") and npc:FindFirstChildOfClass("Humanoid") then
            for _, name in ipairs(gods) do
                if npc.Name:lower():find(name:lower()) then
                    createESP(npc, "god", Color3.fromRGB(255, 0, 255))
                end
            end
        end
    end
end)

-- ESP Secret
espSecretBtn.MouseButton1Click:Connect(function()
    for _, npc in pairs(workspace:GetDescendants()) do
        if npc:IsA("Model") and npc:FindFirstChild("Head") and npc:FindFirstChildOfClass("Humanoid") then
            for _, name in ipairs(secrets) do
                if npc.Name:lower():find(name:lower()) then
                    createESP(npc, "secret", Color3.new(0, 0, 0))
                end
            end
        end
    end
end)

-- Server Hop
local rodando = false
local visitados = {}
local verificados = 0
local encontrados = 0

local function buscarServidor()
    local placeId = game.PlaceId
    local cursor = ""

    while rodando do
        local url = "https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100"
        if cursor ~= "" then
            url = url.."&cursor="..cursor
        end

        local ok, res = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(url))
        end)

        if ok and res and res.data then
            for _, serv in ipairs(res.data) do
                if serv.playing > 0 and not table.find(visitados, serv.id) then
                    table.insert(visitados, serv.id)
                    verificados += 1
                    statusLabel.Text = "Verificando servidor: "..verificados
                    count.Text = "Verificados: "..verificados.."   Encontrados: "..encontrados

                    -- Se tiver secreto no servidor atual, teleporta
                    local thisHasSecret = false
                    for _, npc in ipairs(workspace:GetDescendants()) do
                        if npc:IsA("Model") then
                            for _, name in ipairs(secrets) do
                                if npc.Name:lower():find(name:lower()) then
                                    thisHasSecret = true
                                end
                            end
                        end
                    end

                    if thisHasSecret then
                        encontrados += 1
                        statusLabel.Text = "Brainrot secreto achado!"
                        count.Text = "Verificados: "..verificados.."   Encontrados: "..encontrados
                        TeleportService:TeleportToPlaceInstance(placeId, serv.id, player)
                        return
                    end
                end
            end

            cursor = res.nextPageCursor or ""
            task.wait(1)
        else
            statusLabel.Text = "Erro ao buscar servidores"
            break
        end
    end
end

-- Clique Iniciar Hop
iniciarBtn.MouseButton1Click:Connect(function()
    if not rodando then
        rodando = true
        verificados = 0
        encontrados = 0
        visitados = {}
        statusLabel.Text = "Buscando próximo servidor..."
        pararBtn.Visible = true
        task.spawn(buscarServidor)
    end
end)

-- Clique Parar
pararBtn.MouseButton1Click:Connect(function()
    rodando = false
    pararBtn.Visible = false
    statusLabel.Text = "Buscado parada pelo jogador"
end)

-- SALLES HOP - COMPLETO E FUNCIONAL
-- Imagem do botão: Vegeta (rbxassetid://15406218239)

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "SallesHop"

-- Botão flutuante com imagem
local toggleButton = Instance.new("ImageButton", gui)
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0.5, -25)
toggleButton.BackgroundTransparency = 1
toggleButton.Image = "rbxassetid://15406218239"

-- Interface principal
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.4, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
mainFrame.Visible = false

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
title.Text = "SALLES HOP"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true

local subtitle = Instance.new("TextLabel", mainFrame)
subtitle.Size = UDim2.new(1, 0, 0, 25)
subtitle.Position = UDim2.new(0, 0, 0, 30)
subtitle.Text = "Sistema Avançado de Detecção"
subtitle.BackgroundTransparency = 1
subtitle.TextColor3 = Color3.new(0,0,0)
subtitle.TextScaled = true

local statusLabel = Instance.new("TextLabel", mainFrame)
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 60)
statusLabel.Text = "Buscando próximo servidor..."
statusLabel.TextScaled = true
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.new(0,0,0)

-- Botão parar
local pararBtn = Instance.new("TextButton", mainFrame)
pararBtn.Size = UDim2.new(0.45, 0, 0, 40)
pararBtn.Position = UDim2.new(0.05, 0, 0.7, 0)
pararBtn.Text = "PARAR"
pararBtn.Visible = false
pararBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
pararBtn.TextColor3 = Color3.new(1, 1, 1)
pararBtn.TextScaled = true

-- Botão ESP God
local espGodBtn = Instance.new("TextButton", mainFrame)
espGodBtn.Size = UDim2.new(0.45, 0, 0, 40)
espGodBtn.Position = UDim2.new(0.5, 0, 0.7, 0)
espGodBtn.Text = "ESP God"
espGodBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 200)
espGodBtn.TextColor3 = Color3.new(1,1,1)
espGodBtn.TextScaled = true

-- Botão ESP Secret
local espSecretBtn = Instance.new("TextButton", mainFrame)
espSecretBtn.Size = UDim2.new(0.9, 0, 0, 40)
espSecretBtn.Position = UDim2.new(0.05, 0, 0.5, 0)
espSecretBtn.Text = "ESP Secret"
espSecretBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
espSecretBtn.TextColor3 = Color3.new(1,1,1)
espSecretBtn.TextScaled = true

-- Toggle interface
toggleButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

-- Listas
local gods = {
	"Tripi Tropi", "El Grandote", "Zé Grandão", "Gabriela God", "True Transcendence",
	"Madness God", "Saturn God", "Mr Tralalero", "King Brainrot", "Cefadrina Rex"
}

local secrets = {
	"La Vacca Saturno Saturnita", "Los Tralaleritos", "Las Tralaleritas", "Las Vaquitas Saturnitas",
	"Chicleteira Bicicleteira", "Graipuss Medussi", "La Grande Combinasion",
	"Nuclearo Dinossauro", "Tortuginni Dragonfruitini", "Pot Hotspot",
	"Garama and Madundung", "Sammyni Spyderini", "Chimpanzini Spiderini"
}

-- ESP functions
local function createESP(target, text, color)
	local BillboardGui = Instance.new("BillboardGui", target:FindFirstChild("Head") or target)
	BillboardGui.Size = UDim2.new(0, 100, 0, 30)
	BillboardGui.Adornee = target:FindFirstChild("Head") or target
	BillboardGui.AlwaysOnTop = true

	local label = Instance.new("TextLabel", BillboardGui)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.Text = text
	label.BackgroundTransparency = 1
	label.TextColor3 = color
	label.TextScaled = true
end

espGodBtn.MouseButton1Click:Connect(function()
	for _, npc in ipairs(workspace:GetDescendants()) do
		if npc:IsA("Model") and npc:FindFirstChild("Head") and npc:FindFirstChildOfClass("Humanoid") then
			for _, name in ipairs(gods) do
				if string.lower(npc.Name) == string.lower(name) then
					createESP(npc, "god", Color3.fromRGB(255, 0, 255))
				end
			end
		end
	end
end)

espSecretBtn.MouseButton1Click:Connect(function()
	for _, npc in ipairs(workspace:GetDescendants()) do
		if npc:IsA("Model") and npc:FindFirstChild("Head") and npc:FindFirstChildOfClass("Humanoid") then
			for _, name in ipairs(secrets) do
				if string.lower(npc.Name) == string.lower(name) then
					createESP(npc, "secret", Color3.new(0, 0, 0))
				end
			end
		end
	end
end)

-- Server Hop
local rodando = false
local visitados = {}

local function buscarServidor()
	local cursor = ""
	local placeId = game.PlaceId

	while rodando do
		local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"
		if cursor ~= "" then
			url = url .. "&cursor=" .. cursor
		end

		local success, result = pcall(function()
			return HttpService:JSONDecode(game:HttpGet(url))
		end)

		if success and result and result.data then
			for _, server in pairs(result.data) do
				if server.playing > 5 and not table.find(visitados, server.id) then
					table.insert(visitados, server.id)
					statusLabel.Text = "Verificando: " .. tostring(#visitados) .. " servidores"

					local foundSecret = false
					for _, npc in ipairs(workspace:GetDescendants()) do
						if npc:IsA("Model") then
							for _, name in ipairs(secrets) do
								if string.lower(npc.Name) == string.lower(name) then
									foundSecret = true
								end
							end
						end
					end

					if foundSecret then
						statusLabel.Text = "Encontrado servidor com brainrot secreto!"
						TeleportService:TeleportToPlaceInstance(placeId, server.id, player)
						return
					end
				end
			end

			cursor = result.nextPageCursor or ""
			task.wait(2)
		else
			statusLabel.Text = "Erro ao buscar servidores."
			break
		end
	end
end

-- Iniciar e Parar
pararBtn.MouseButton1Click:Connect(function()
	rodando = false
	pararBtn.Visible = false
	statusLabel.Text = "Parado"
end)

subtitle.MouseButton1Click:Connect(function()
	if not rodando then
		rodando = true
		pararBtn.Visible = true
		statusLabel.Text = "Buscando próximo servidor..."
		task.spawn(buscarServidor)
	end
end)

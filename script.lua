-- (Creator = Thanh Phuc)
-- 💟 Thanh Phuc - Boombox Cầu Vồng Ảo + Nút Mở Di Chuyển Được 💟
-- [VERSION: Loa Kép Mi 10s - Bass Siêu Mạnh - Nhấp Nháy Theo Nhịp Nhạc]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")

-- HỆ THỐNG LOA KÉP GIẢ LẬP MI 10S + BASS TĂNG CƯỜNG
local LocalSound = Instance.new("Sound")
LocalSound.Name = "ThanhPhucLocalSound"
LocalSound.Parent = LocalPlayer:WaitForChild("PlayerWorkspace", 5) or workspace
LocalSound.Volume = 3 -- Tăng âm lượng tổng thể cho loa kép
LocalSound.Looped = true

-- Thêm bộ lọc Equalizer để kích Bass mạnh chuẩn Harman Kardon
local Equalizer = Instance.new("EqualizerSoundEffect")
Equalizer.LowGain = 12  -- Đẩy Bass (âm trầm) lên cực mạnh
Equalizer.MidGain = 2   -- Giữ âm trung trong trẻo
Equalizer.HighGain = 4  -- Treble nhẹ tạo độ chi tiết cao
Equalizer.Parent = LocalSound

local FakeBoombox = nil

-- HÀM TẠO BOOMBOX CẦU VỒNG CHỚP THEO NHẠC (XỬ LÝ NGAY LẬP TỨC)
local function CreateFakeBoombox()
    if FakeBoombox and FakeBoombox.Parent then FakeBoombox:Destroy() end
    
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local torso = character:WaitForChild("UpperTorso", 2) or character:WaitForChild("Torso", 2)
    if not torso then return end
    
    -- Tạo Part chứa Boombox
    local part = Instance.new("Part")
    part.Name = "ThanhPhucBoombox"
    part.Size = Vector3.new(2, 2, 2)
    part.CanCollide = false
    part.Massless = true
    
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshId = "rbxassetid://114134812"
    mesh.TextureId = "rbxassetid://114134769"
    mesh.Parent = part
    
    FakeBoombox = part
    part.Parent = character
    
    -- Gắn chặt vào lưng lập tức
    local weld = Instance.new("Weld")
    weld.Part0 = torso
    weld.Part1 = part
    weld.C0 = CFrame.new(0, 0, 0.7) * CFrame.Angles(0, math.rad(180), 0)
    weld.Parent = part
    
    -- VÒNG LẶP ĐỔI MÀU CẦU VỒNG + CHỚP THEO NHỊP BASS (AUDIO VISUALIZER)
    coroutine.wrap(function()
        local hue = 0
        while part and part.Parent and FakeBoombox == part do
            hue = (hue + 1.5) % 360
            
            -- Lấy độ lớn âm thanh đang phát (Tỷ lệ nhịp nhạc)
            local loudness = LocalSound.PlaybackLoudness
            local intensity = math.clamp(loudness / 300, 0.4, 2.5) -- Biến thiên theo nhịp Bass
            
            -- Tính toán màu cầu vồng dựa theo nhịp điệu
            local color = Color3.fromHSV(hue/360, 1, 1)
            part.Color = color
            
            -- Hiệu ứng chớp nháy cường độ mạnh theo Bass của Mi 10s
            mesh.VertexColor = Vector3.new(color.R * intensity, color.G * intensity, color.B * intensity)
            
            RunService.RenderStepped:Wait()
        end
    end)()
end

-- TỰ ĐỘNG ĐEO LẠI LOA NGAY KHI HỒI SINH (KHÔNG TRỄ)
LocalPlayer.CharacterAdded:Connect(function(char)
    -- Đợi Torso xuất hiện là gắn ngay lập tức
    char:WaitForChild("HumanoidRootPart")
    if LocalSound.IsPlaying then
        CreateFakeBoombox()
    end
end)

-- TẠO GIAO DIỆN GUI
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 250, 0, 220)
MainFrame.Position = UDim2.new(0.5, -125, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Draggable = true
MainFrame.Active = true
MainFrame.Visible = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Nút ẨN MENU
local HideBtn = Instance.new("TextButton", MainFrame)
HideBtn.Size = UDim2.new(0, 30, 0, 30)
HideBtn.Position = UDim2.new(0.85, 0, 0.05, 0)
HideBtn.Text = "-"
HideBtn.TextColor3 = Color3.new(1, 1, 1)
HideBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
Instance.new("UICorner", HideBtn)
HideBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false 
end)

-- NÚT MỞ MENU (DRAGGABLE)
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 10, 0.5, 0)
OpenBtn.Text = "TP 🎵"
OpenBtn.TextColor3 = Color3.new(1, 1, 1)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
OpenBtn.Draggable = true
OpenBtn.Active = true
Instance.new("UICorner", OpenBtn)
OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true 
end)

-- Tiêu đề Menu
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(0.8, 0, 0, 30)
Title.Position = UDim2.new(0.05, 0, 0.05, 0)
Title.Text = "🎵 THANH PHÚC MUSIC (MI 10S)"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Ô nhập ID Nhạc
local InputBox = Instance.new("TextBox", MainFrame)
InputBox.Size = UDim2.new(0.9, 0, 0, 40)
InputBox.Position = UDim2.new(0.05, 0, 0.25, 0)
InputBox.PlaceholderText = "Nhập ID nhạc..."
InputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
InputBox.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", InputBox)

-- Nút PHÁT NHẠC
local PlayBtn = Instance.new("TextButton", MainFrame)
PlayBtn.Size = UDim2.new(0.9, 0, 0, 40)
PlayBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
PlayBtn.Text = "PHÁT NHẠC"
PlayBtn.TextColor3 = Color3.new(1, 1, 1)
PlayBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
Instance.new("UICorner", PlayBtn)

-- Xử lý khi nhấn Phát Nhạc
PlayBtn.MouseButton1Click:Connect(function()
    local cleanID = InputBox.Text:match("%d+")
    if cleanID then
        -- Kích hoạt âm thanh ngay lập tức
        LocalSound.SoundId = "rbxassetid://" .. cleanID
        LocalSound:Play()
        
        -- Gọi Boombox cầu vồng xuất hiện ngay lập tức không trễ giây nào
        CreateFakeBoombox()
        print("Thanh Phuc đang phát nhạc Loa Kép Bass Mi 10s + Chớp Cầu Vồng!")
    else
        InputBox.Text = ""
        InputBox.PlaceholderText = "ID không hợp lệ!"
    end
end)


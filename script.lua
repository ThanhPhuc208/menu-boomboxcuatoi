-- (Creator = Thanh Phuc)
-- 💟 Thanh Phuc - Boombox Cầu Vồng Ảo + Nút Mở Di Chuyển Được 💟
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")

-- BỘ PHÁT ÂM THANH CHUẨN - CÂN BẰNG BASS CHỐNG RÈ
local LocalSound = Instance.new("Sound")
LocalSound.Name = "ThanhPhucLocalSound"
LocalSound.Parent = LocalPlayer:WaitForChild("PlayerWorkspace", 5) or workspace
LocalSound.Volume = 2.5 -- Âm lượng vừa vặn, to rõ ràng
LocalSound.Looped = true

-- Bộ cân bằng tần số Equalizer: Kích bass ấm, sâu vừa đủ tầm
local Equalizer = Instance.new("EqualizerSoundEffect")
Equalizer.LowGain = 5    -- Đẩy Bass trầm sâu mà không bị vỡ tiếng
Equalizer.MidGain = 1    -- Giữ giọng ca sĩ rõ nét
Equalizer.HighGain = 2   -- Âm cao trong trẻo
Equalizer.Parent = LocalSound

-- Bộ nén âm thanh Compressor: Ngăn chặn tuyệt đối hiện tượng rè/max dải âm
local Compressor = Instance.new("CompressorSoundEffect")
Compressor.Threshold = -10
Compressor.Attack = 0.01
Compressor.Release = 0.1
Compressor.Ratio = 3
Compressor.Parent = LocalSound

-- GIỮ NGUYÊN BOOMBOX GỐC ĐẦU TIÊN (ĐEO THẲNG SAU LƯNG)
local FakeBoombox = nil
local function CreateFakeBoombox()
    if FakeBoombox then FakeBoombox:Destroy() end
    
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local torso = character:WaitForChild("UpperTorso", 2) or character:WaitForChild("Torso", 2)
    if not torso then return end
    
    -- Tạo khối Mesh cho Boombox chuẩn Roblox ban đầu
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshId = "rbxassetid://114134812" -- Mesh ID gốc của Boombox Roblox
    mesh.TextureId = "rbxassetid://114134769" -- Texture gốc để chạy hiệu ứng màu
    
    local part = Instance.new("Part")
    part.Name = "ThanhPhucBoombox"
    part.Size = Vector3.new(2, 2, 2)
    part.CanCollide = false
    part.Massless = true
    mesh.Parent = part
    part.Parent = character
    FakeBoombox = part
    
    -- Gắn chặt Boombox vào sau lưng nhân vật (Thẳng lưng, không lệch xéo)
    local weld = Instance.new("Weld")
    weld.Part0 = torso
    weld.Part1 = part
    weld.C0 = CFrame.new(0, 0, 0.7) * CFrame.Angles(0, math.rad(180), 0)
    weld.Parent = part
    
    -- Hiệu ứng đổi màu cầu vồng và nháy nhịp nhẹ nhàng từ độ lớn âm thanh
    coroutine.wrap(function()
        local hue = 0
        while part and part.Parent and FakeBoombox == part do
            hue = (hue + 1) % 360
            local color = Color3.fromHSV(hue/360, 1, 1)
            part.Color = color
            
            -- Lấy nhịp âm thanh để chớp màu nhẹ, tránh bị đập quá dị dạng part
            local loudness = LocalSound.PlaybackLoudness
            local intensity = math.clamp(loudness / 280, 0.5, 2.2)
            
            mesh.VertexColor = Vector3.new(color.R * intensity, color.G * intensity, color.B * intensity)
            RunService.RenderStepped:Wait()
        end
    end)()
end

-- TỰ ĐỘNG ĐEO LẠI LOA NGAY LẬP TỨC KHI HỒI SINH
LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart", 5)
    if LocalSound.IsPlaying then
        CreateFakeBoombox()
    end
end)

-- TẠO GIAO DIỆN GUI (Giữ nguyên cấu trúc ban đầu)
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
Title.Text = "🎵 THANH PHÚC MUSIC"
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

-- Xử lý khi nhấn Phát Nhạc (Hiện Boombox ngay lập tức)
PlayBtn.MouseButton1Click:Connect(function()
    local cleanID = InputBox.Text:match("%d+")
    if cleanID then
        LocalSound.SoundId = "rbxassetid://" .. cleanID
        LocalSound:Play()
        
        -- Gọi Boombox xuất hiện ngay lập tức không trễ giây nào
        CreateFakeBoombox()
        print("Thanh Phuc đang phát nhạc + Đeo Boombox Cầu Vồng gốc!")
    else
        InputBox.Text = ""
        InputBox.PlaceholderText = "ID không hợp lệ!"
    end
end)

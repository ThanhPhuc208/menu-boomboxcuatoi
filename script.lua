-- (Creator = Thanh Phuc)
-- 💟 Thanh Phuc - Boombox Cầu Vồng Siêu Sáng (Cam Kết Hiện 100% - Không Rè) 💟
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")

-- ÂM THANH THUẦN TÚY - KHÔNG DÙNG BỘ LỌC GÂY RÈ
local LocalSound = Instance.new("Sound")
LocalSound.Name = "ThanhPhucLocalSound"
LocalSound.Parent = LocalPlayer:WaitForChild("PlayerWorkspace", 5) or workspace
LocalSound.Volume = 1.0 -- Giữ mức âm lượng chuẩn nguyên bản, âm trầm đập êm và sạch
LocalSound.Looped = true

local FakeBoombox = nil

-- HÀM TẠO LOA CHẮC CHẮN HIỆN 100% KHÔNG BỊ TRỄ, KHÔNG BỊ CHẶN MESH
local function CreateFakeBoombox()
    if FakeBoombox then FakeBoombox:Destroy() end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    -- Gắn vào HumanoidRootPart để chắc chắn 100% nhân vật nào cũng có
    local rootPart = character:WaitForChild("HumanoidRootPart", 5)
    if not rootPart then return end
    
    -- TẠO KHỐI LOA CƠ BẢN (Không dùng ID mạng để tránh bị Roblox chặn vô hình)
    local part = Instance.new("Part")
    part.Name = "ThanhPhucBoombox"
    part.Size = Vector3.new(1.8, 1.0, 0.5) -- Kích thước hộp loa chuẩn sau lưng
    part.Material = Enum.Material.Neon    -- Chất liệu Neon phát sáng cực đẹp
    part.CanCollide = false
    part.Massless = true
    
    -- Thêm một khối cầu ở giữa làm màng loa chớp nháy
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.Sphere
    mesh.Scale = Vector3.new(0.9, 0.9, 1.1) -- Tạo hình màng loa hơi lồi ra
    mesh.Parent = part
    
    FakeBoombox = part
    part.Parent = character
    
    -- Gắn chặt ra sau lưng lập tức
    local weld = Instance.new("Weld")
    weld.Part0 = rootPart
    weld.Part1 = part
    weld.C0 = CFrame.new(0, 0.4, 0.7) * CFrame.Angles(0, math.rad(180), 0)
    weld.Parent = part
    
    -- HIỆU ỨNG CẦU VỒNG CHỚP NHẸ THEO NHỊP BASS
    coroutine.wrap(function()
        local hue = 0
        while part and part.Parent and FakeBoombox == part do
            hue = (hue + 1) % 360
            local color = Color3.fromHSV(hue/360, 1, 1)
            
            -- Chớp nháy nhẹ độ sáng theo nhịp nhạc thực tế
            local loudness = LocalSound.PlaybackLoudness
            local intensity = math.clamp(loudness / 300, 0.5, 1)
            
            part.Color = Color3.new(color.R * intensity, color.G * intensity, color.B * intensity)
            RunService.RenderStepped:Wait()
        end
    end)()
end

-- TỰ ĐỘNG ĐEO LẠI LOA NGAY KHI HỒI SINH (BẤT TỬ LOA)
LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart", 5)
    if LocalSound.IsPlaying then
        CreateFakeBoombox()
    end
end)

-- GIAO DIỆN GUI GIỮ NGUYÊN
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

-- NÚT MỞ MENU
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

-- Nhấn phát nhạc là xuất hiện loa ngay lập tức không trễ một giây
PlayBtn.MouseButton1Click:Connect(function()
    local cleanID = InputBox.Text:match("%d+")
    if cleanID then
        LocalSound.SoundId = "rbxassetid://" .. cleanID
        LocalSound:Play()
        
        -- Tạo loa ngay lập tức
        CreateFakeBoombox()
        print("Thanh Phuc Music: Đã hiện loa 100% thành công!")
    else
        InputBox.Text = ""
        InputBox.PlaceholderText = "ID không hợp lệ!"
    end
end)

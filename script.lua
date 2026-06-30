-- (Creator = Thanh Phuc)
-- 💟 Thanh Phuc - Thùng Loa Cầu Vồng Neon (Hiện 100% - Bass Ấm Không Rè) 💟
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")

-- CẤU HÌNH CHẤT ÂM GỐC - BASS ĐẦM KHÔNG RÈ
local LocalSound = Instance.new("Sound")
LocalSound.Name = "ThanhPhucLocalSound"
LocalSound.Parent = LocalPlayer:WaitForChild("PlayerWorkspace", 5) or workspace
LocalSound.Volume = 1.5 -- Âm lượng to, rõ, vừa vặn dải tần chống vỡ tiếng
LocalSound.Looped = true

-- Thêm bộ nén Compressor để bo tròn dải bass, triệt tiêu tiếng rè hoàn toàn
local SoundCompressor = Instance.new("CompressorSoundEffect")
SoundCompressor.Threshold = -8
SoundCompressor.Attack = 0.01
SoundCompressor.Release = 0.1
SoundCompressor.Ratio = 3
SoundCompressor.Parent = LocalSound

local FakeBoombox = nil

-- HÀM TẠO THÙNG LOA HÌNH HỘP CHỮ NHẬT HIỆN 100%
local function CreateFakeBoombox()
    if FakeBoombox then FakeBoombox:Destroy() end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    -- Gắn vào HumanoidRootPart để chắc chắn không bao giờ lỗi vị trí
    local rootPart = character:WaitForChild("HumanoidRootPart", 5)
    if not rootPart then return end
    
    -- TẠO THÙNG LOA HÌNH HỘP CHỮ NHẬT ĐEO SAU LƯNG (Không dùng ID Mesh ngoài để tránh lỗi)
    local part = Instance.new("Part")
    part.Name = "ThanhPhucBoombox"
    part.Shape = Enum.PartType.Block       -- Ép buộc 100% ra hình thùng loa chữ nhật
    part.Size = Vector3.new(2.2, 1.2, 0.6) -- Kích thước thùng loa chuẩn cân đối sau lưng
    part.Material = Enum.Material.Neon    -- Chất liệu phát sáng rực rỡ
    part.CanCollide = false
    part.Massless = true
    
    FakeBoombox = part
    part.Parent = character
    
    -- Gắn chặt thùng loa ra sau lưng ngay lập tức
    local weld = Instance.new("Weld")
    weld.Part0 = rootPart
    weld.Part1 = part
    weld.C0 = CFrame.new(0, 0.4, 0.75) * CFrame.Angles(0, math.rad(180), 0) -- Căn giữa thẳng lưng
    weld.Parent = part
    
    -- HIỆU ỨNG CẦU VỒNG CHỚP NHẸ THEO NHỊP BASS
    coroutine.wrap(function()
        local hue = 0
        while part and part.Parent and FakeBoombox == part do
            hue = (hue + 1) % 360
            local color = Color3.fromHSV(hue/360, 1, 1)
            
            -- Thùng loa tự động chớp nháy độ sáng theo nhịp nhạc
            local loudness = LocalSound.PlaybackLoudness
            local intensity = math.clamp(loudness / 280, 0.6, 1.5)
            
            part.Color = Color3.new(color.R * intensity, color.G * intensity, color.B * intensity)
            RunService.RenderStepped:Wait()
        end
    end)()
end

-- TỰ ĐỘNG ĐEO LẠI LOA NGAY KHI VỪA HỒI SINH (BẤT TỬ LOA)
LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart", 5)
    if LocalSound.IsPlaying then
        CreateFakeBoombox()
    end
end)

-- GIAO DIỆN GUI NGUYÊN BẢN
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

-- Kích hoạt phát nhạc và gọi Thùng Loa xuất hiện ngay lập tức
PlayBtn.MouseButton1Click:Connect(function()
    local cleanID = InputBox.Text:match("%d+")
    if cleanID then
        LocalSound.SoundId = "rbxassetid://" .. cleanID
        LocalSound:Play()
        
        -- Tạo loa chữ nhật ngay lập tức không trễ một giây
        CreateFakeBoombox()
        print("Thanh Phuc Music: Đã hiện thùng loa chữ nhật chuẩn 100% sau lưng!")
    else
        InputBox.Text = ""
        InputBox.PlaceholderText = "ID không hợp lệ!"
    end
end)

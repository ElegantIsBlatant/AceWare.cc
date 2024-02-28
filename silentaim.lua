getgenv().Memelouse3150 = { 
    Silent = {
        Enabled     = true,
        Part        = "Head", "LowerTorso", "HumanoidRootPart", "RightUpperArm", "LeftUpperArm", "RightLowerLeg", "LeftLowerLeg",
        ClosestPart = true,
        
		PredictMovement    = true,
        PredictionVelocity = 0.102421,
        
        AntiGroundShots = true,
        
        WallCheck   = true,
        CheckIf_KO  = false,
	},
    SilentFOV = {
        Visible = false,
        Radius  = 160,
    },
    Tracer = {
        Key =   "C",
        Enabled = true,
        Part    = "HumanoidRootPart",
        ClosestPart = true,
        
		DisableTargetDeath = true,
		DisableLocalDeath  = true,
        
        UseCircleRadius      = false,
        DisableOutSideCircle = false,
        
		UseShake   = true,
		ShakeValue = 5,

		PredictMovement    = true,
        PredictionVelocity = 0.146,
        
        WallCheck  = true,
        CheckIf_KO = false,

        Smoothness = 0.1,
    },
    TracerFOV = {
        Visible = false,
        Radius  = 55,
    },
    GunFOV =  {
        Enabled = false,-- // Gun Fov / fov is automatically changed to specific gun equipped
        ["Double-Barrel SG"] = {["FOV"] = 15}, -- DB
        ["Revolver"] = {["FOV"] = 10}, -- rev
        ["SMG"] = {["FOV"] = 23}, -- smg
        ["Shotgun"] = { ["FOV"] = 20}, -- shotgun
        ["Rifle"] = { ["FOV"] = 20}, -- Rifle
        ["TacticalShotgun"] = {["FOV"] = 24}, -- rev
        ["Silencer"] = {["FOV"] = 17}, -- smg
        ["AK47"] = { ["FOV"] = 10}, -- shotgun
        ["AR"] = { ["FOV"] = 10}, -- Rifle
        -- // You Can Add Custom :p
	},
	
	Both = {
		DetectDesync    = true,
		DesyncDetection = 80,
		
        UnderGroundResolver    = false,
	
	},
}

local Prey = nil
local Plr  = nil

local Players, Client, Mouse, RS, Camera =
    game:GetService("Players"),
    game:GetService("Players").LocalPlayer,
    game:GetService("Players").LocalPlayer:GetMouse(),
    game:GetService("RunService"),
    game:GetService("Workspace").CurrentCamera

local Circle       = Drawing.new("Circle")
local TracerCircle = Drawing.new("Circle")

Circle.Color           = Color3.new(1,1,1)
Circle.Thickness       = 1
TracerCircle.Color     = Color3.new(1,1,1)
TracerCircle.Thickness = 1

local UpdateFOV = function ()
    if (not Circle and not TracerCircle) then
        return Circle and TracerCircle
    end
    TracerCircle.Visible  = getgenv().Memelouse3150.TracerFOV.Visible
    TracerCircle.Radius   = getgenv().Memelouse3150.TracerFOV.Radius * 3
    TracerCircle.Position = Vector2.new(Mouse.X, Mouse.Y + (game:GetService("GuiService"):GetGuiInset().Y))
    
    Circle.Visible  = getgenv().Memelouse3150.SilentFOV.Visible
    Circle.Radius   = getgenv().Memelouse3150.SilentFOV.Radius * 3
    Circle.Position = Vector2.new(Mouse.X, Mouse.Y + (game:GetService("GuiService"):GetGuiInset().Y))
    return Circle and TracerCircle
end

RS.Heartbeat:Connect(UpdateFOV)

local WallCheck = function(destination, ignore)
    local Origin    = Camera.CFrame.p
    local CheckRay  = Ray.new(Origin, destination - Origin)
    local Hit       = game.workspace:FindPartOnRayWithIgnoreList(CheckRay, ignore)
    return Hit      == nil
end

local WTS = function (Object)
    local ObjectVector = Camera:WorldToScreenPoint(Object.Position)
    return Vector2.new(ObjectVector.X, ObjectVector.Y)
end

local IsOnScreen = function (Object)
    local IsOnScreen = Camera:WorldToScreenPoint(Object.Position)
    return IsOnScreen
end

local FilterObjs = function (Object)
    if string.find(Object.Name, "Gun") then
        return
    end
    if table.find({"Part", "MeshPart", "BasePart"}, Object.ClassName) then
        return true
    end
end

local ClosestPlrFromMouse = function()
    local Target, Closest = nil, 1/0
    
    for _ ,v in pairs(Players:GetPlayers()) do
    	if getgenv().Memelouse3150.Silent.WallCheck then
    		if (v.Character and v ~= Client and v.Character:FindFirstChild("HumanoidRootPart")) then
    			local Position, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
    			local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
    
    			if (Circle.Radius > Distance and Distance < Closest and OnScreen) and WallCheck(v.Character.HumanoidRootPart.Position, {Client, v.Character}) then
    				Closest = Distance
    				Target = v
    			end
    		end
    	else
    		if (v.Character and v ~= Client and v.Character:FindFirstChild("HumanoidRootPart")) then
    			local Position, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
    			local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
    
    			if (Circle.Radius > Distance and Distance < Closest and OnScreen) then
    				Closest = Distance
    				Target = v
    			end
    		end
    	end
    end
    return Target
end

local ClosestPlrFromMouse2 = function()
    local Target, Closest = nil, 1/0
    
    for _ ,v in pairs(Players:GetPlayers()) do
    	if (v.Character and v ~= Client and v.Character:FindFirstChild("HumanoidRootPart")) then
        	if getgenv().Memelouse3150.Tracer.WallCheck then
        		local Position, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
        		local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
        
        		if (Distance < Closest and OnScreen) and WallCheck(v.Character.HumanoidRootPart.Position, {Client, v.Character}) then
        			Closest = Distance
        			Target = v
        		end
                elseif getgenv().Memelouse3150.Tracer.UseCircleRadius then
            		local Position, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
            		local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if (TracerCircle.Radius > Distance and Distance < Closest and OnScreen) and WallCheck(v.Character.HumanoidRootPart.Position, {Client, v.Character}) then
            			Closest = Distance
            			Target = v
                    end
        	    else
        			local Position, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
        			local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
        
        			if (Distance < Closest and OnScreen) then
        				Closest = Distance
        				Target = v
        			end
        		end
            end
        end
    return Target
end

local GetClosestBodyPart = function (character)
    local ClosestDistance = 1/0
    local BodyPart = nil
    
    if (character and character:GetChildren()) then
        for _,  x in next, character:GetChildren() do
            if FilterObjs(x) and IsOnScreen(x) then
                local Distance = (WTS(x) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if (Circle.Radius > Distance and Distance < ClosestDistance) then
                    ClosestDistance = Distance
                    BodyPart = x
                end
            end
        end
    end
    return BodyPart
end

local GetClosestBodyPartV2 = function (character)
    local ClosestDistance = 1/0
    local BodyPart = nil
    
    if (character and character:GetChildren()) then
        for _,  x in next, character:GetChildren() do
            if FilterObjs(x) and IsOnScreen(x) then
                local Distance = (WTS(x) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if (Distance < ClosestDistance) then
                    ClosestDistance = Distance
                    BodyPart = x
                end
            end
        end
    end
    return BodyPart
end

Mouse.KeyDown:Connect(function(Key)
    local Keybind = getgenv().Memelouse3150.Tracer.Key:lower()
    if (Key == Keybind) then
        if getgenv().Memelouse3150.Tracer.Enabled == true then
            IsTargetting = not IsTargetting
            if IsTargetting then
                Plr = ClosestPlrFromMouse2()
            else
                if Plr ~= nil then
                    Plr = nil
                    IsTargetting = false
                end
            end
        end
    end
end)

local grmt = getrawmetatable(game)
local backupindex = grmt.__index
setreadonly(grmt, false)

grmt.__index = newcclosure(function(self, v)
    if (getgenv().Memelouse3150.Silent.Enabled and Mouse and tostring(v) == "Hit") then
        if Prey and Prey.Character then
    		if getgenv().Memelouse3150.Silent.PredictMovement then
    			local endpoint = game.Players[tostring(Prey)].Character[getgenv().Memelouse3150.Silent.Part].CFrame + (
    				game.Players[tostring(Prey)].Character[getgenv().Memelouse3150.Silent.Part].Velocity * getgenv().Memelouse3150.Silent.PredictionVelocity
    			)
    			return (tostring(v) == "Hit" and endpoint)
    		else
    			local endpoint = game.Players[tostring(Prey)].Character[getgenv().Memelouse3150.Silent.Part].CFrame
    			return (tostring(v) == "Hit" and endpoint)
    		end
        end
    end
    return backupindex(self, v)
end)

RS.Heartbeat:Connect(function()
	if getgenv().Memelouse3150.Silent.Enabled then
	    if Prey and Prey.Character and Prey.Character:WaitForChild(getgenv().Memelouse3150.Silent.Part) then
            if getgenv().Memelouse3150.Both.DetectDesync == true and Prey.Character:WaitForChild("HumanoidRootPart").Velocity.magnitude > getgenv().Memelouse3150.Both.DesyncDetection then            
                pcall(function()
                    local TargetVel = Prey.Character[getgenv().Memelouse3150.Silent.Part]
                    TargetVel.Velocity = Vector3.new(0, 0, 0)
                    TargetVel.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                end)
            end
            if getgenv().Memelouse3150.Silent.AntiGroundShots == true and Prey.Character:FindFirstChild("Humanoid") == Enum.HumanoidStateType.Freefall then
                pcall(function()
                    local TargetVelv5 = Prey.Character[getgenv().Memelouse3150.Silent.Part]
                    TargetVelv5.Velocity = Vector3.new(TargetVelv5.Velocity.X, (TargetVelv5.Velocity.Y * 0.5), TargetVelv5.Velocity.Z)
                    TargetVelv5.AssemblyLinearVelocity = Vector3.new(TargetVelv5.Velocity.X, (TargetVelv5.Velocity.Y * 0.5), TargetVelv5.Velocity.Z)
                end)
            end
            if getgenv().Memelouse3150.Both.UnderGroundResolver == true then            
                pcall(function()
                    local TargetVelv2 = Prey.Character[getgenv().Memelouse3150.Silent.Part]
                    TargetVelv2.Velocity = Vector3.new(TargetVelv2.Velocity.X, 0, TargetVelv2.Velocity.Z)
                    TargetVelv2.AssemblyLinearVelocity = Vector3.new(TargetVelv2.Velocity.X, 0, TargetVelv2.Velocity.Z)
                end)
            end
	    end
	end
    if getgenv().Memelouse3150.Tracer.Enabled == true then
        if getgenv().Memelouse3150.Both.DetectDesync == true and Plr and Plr.Character and Plr.Character:WaitForChild(getgenv().Memelouse3150.Tracer.Part) and Plr.Character:WaitForChild("HumanoidRootPart").Velocity.magnitude > getgenv().Memelouse3150.Both.DesyncDetection then
            pcall(function()
                local TargetVelv3 = Plr.Character[getgenv().Memelouse3150.Tracer.Part]
                TargetVelv3.Velocity = Vector3.new(0, 0, 0)
                TargetVelv3.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end)
        end
        if getgenv().Memelouse3150.Both.UnderGroundResolver == true and Plr and Plr.Character and Plr.Character:WaitForChild(getgenv().Memelouse3150.Tracer.Part)then
            pcall(function()
                local TargetVelv4 = Plr.Character[getgenv().Memelouse3150.Tracer.Part]
                TargetVelv4.Velocity = Vector3.new(TargetVelv4.Velocity.X, 0, TargetVelv4.Velocity.Z)
                TargetVelv4.AssemblyLinearVelocity = Vector3.new(TargetVelv4.Velocity.X, 0, TargetVelv4.Velocity.Z)
            end)
        end
    end
end)

RS.RenderStepped:Connect(function()
	if getgenv().Memelouse3150.Silent.Enabled then
        if getgenv().Memelouse3150.Silent.CheckIf_KO == true and Prey and Prey.Character then 
            local KOd = Prey.Character:WaitForChild("BodyEffects")["K.O"].Value
            local Grabbed = Prey.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
            if KOd or Grabbed then
                Prey = nil
            end
        end
	end
    if getgenv().Memelouse3150.Tracer.Enabled == true then
        if getgenv().Memelouse3150.Tracer.CheckIf_KO == true and Plr and Plr.Character then 
            local KOd = Plr.Character:WaitForChild("BodyEffects")["K.O"].Value
            local Grabbed = Plr.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
            if KOd or Grabbed then
                Plr = nil
                IsTargetting = false
            end
        end
		if getgenv().Memelouse3150.Tracer.DisableTargetDeath == true and Plr and Plr.Character:FindFirstChild("Humanoid") then
			if Plr.Character.Humanoid.health < 4 then
				Plr = nil
				IsTargetting = false
			end
		end
		if getgenv().Memelouse3150.Tracer.DisableLocalDeath == true and Plr and Plr.Character:FindFirstChild("Humanoid") then
			if Client.Character.Humanoid.health < 4 then
				Plr = nil
				IsTargetting = false
			end
		end
        if getgenv().Memelouse3150.Tracer.DisableOutSideCircle == true and Plr and Plr.Character and Plr.Character:WaitForChild("HumanoidRootPart") then
            if
            TracerCircle.Radius <
                (Vector2.new(
                    Camera:WorldToScreenPoint(Plr.Character.HumanoidRootPart.Position).X,
                    Camera:WorldToScreenPoint(Plr.Character.HumanoidRootPart.Position).Y
                ) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
             then
                Plr = nil
                IsTargetting = false
            end
        end
		if getgenv().Memelouse3150.Tracer.PredictMovement and Plr and Plr.Character and Plr.Character:FindFirstChild(getgenv().Memelouse3150.Tracer.Part) then
			if getgenv().Memelouse3150.Tracer.UseShake then
				local Main = CFrame.new(Camera.CFrame.p,Plr.Character[getgenv().Memelouse3150.Tracer.Part].Position + Plr.Character[getgenv().Memelouse3150.Tracer.Part].Velocity * getgenv().Memelouse3150.Tracer.PredictionVelocity +
				Vector3.new(
					math.random(-getgenv().Memelouse3150.Tracer.ShakeValue, getgenv().Memelouse3150.Tracer.ShakeValue),
					math.random(-getgenv().Memelouse3150.Tracer.ShakeValue, getgenv().Memelouse3150.Tracer.ShakeValue),
					math.random(-getgenv().Memelouse3150.Tracer.ShakeValue, getgenv().Memelouse3150.Tracer.ShakeValue)
				) * 0.1)
				Camera.CFrame = Camera.CFrame:Lerp(Main, getgenv().Memelouse3150.Tracer.Smoothness, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
			else
    			local Main = CFrame.new(Camera.CFrame.p,Plr.Character[getgenv().Memelouse3150.Tracer.Part].Position + Plr.Character[getgenv().Memelouse3150.Tracer.Part].Velocity * getgenv().Memelouse3150.Tracer.PredictionVelocity)
    			Camera.CFrame = Camera.CFrame:Lerp(Main, getgenv().Memelouse3150.Tracer.Smoothness, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
			end
		elseif getgenv().Memelouse3150.Tracer.PredictMovement == false and Plr and Plr.Character and Plr.Character:FindFirstChild(getgenv().Memelouse3150.Tracer.Part) then
			if getgenv().Memelouse3150.Tracer.UseShake then
				local Main = CFrame.new(Camera.CFrame.p,Plr.Character[getgenv().Memelouse3150.Tracer.Part].Position +
				Vector3.new(
					math.random(-getgenv().Memelouse3150.Tracer.ShakeValue, getgenv().Memelouse3150.Tracer.ShakeValue),
					math.random(-getgenv().Memelouse3150.Tracer.ShakeValue, getgenv().Memelouse3150.Tracer.ShakeValue),
					math.random(-getgenv().Memelouse3150.Tracer.ShakeValue, getgenv().Memelouse3150.Tracer.ShakeValue)
				) * 0.1)
				Camera.CFrame = Camera.CFrame:Lerp(Main, getgenv().Memelouse3150.Tracer.Smoothness, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
		    else
    			local Main = CFrame.new(Camera.CFrame.p,Plr.Character[getgenv().Memelouse3150.Tracer.Part].Position)
    			Camera.CFrame = Camera.CFrame:Lerp(Main, getgenv().Memelouse3150.Tracer.Smoothness, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
		    end
		end
	end
end)

task.spawn(function ()
    while task.wait() do
    	if getgenv().Memelouse3150.Silent.Enabled then
            Prey = ClosestPlrFromMouse()
    	end
        if Plr then
            if getgenv().Memelouse3150.Tracer.Enabled and (Plr.Character) and getgenv().Memelouse3150.Tracer.ClosestPart then
                getgenv().Memelouse3150.Tracer.Part = tostring(GetClosestBodyPartV2(Plr.Character))
            end
        end
        if Prey then
            if getgenv().Memelouse3150.Silent.Enabled and (Prey.Character) and getgenv().Memelouse3150.Silent.ClosestPart then
                getgenv().Memelouse3150.Silent.Part = tostring(GetClosestBodyPart(Prey.Character))
            end
        end
    end
end)

local Script = {Functions = {}}
    Script.Functions.getToolName = function(name)
        local split = string.split(string.split(name, "[")[2], "]")[1]
        return split
    end
    Script.Functions.getEquippedWeaponName = function()
        if (Client.Character) and Client.Character:FindFirstChildWhichIsA("Tool") then
           local Tool =  Client.Character:FindFirstChildWhichIsA("Tool")
           if string.find(Tool.Name, "%[") and string.find(Tool.Name, "%]") and not string.find(Tool.Name, "Wallet") and not string.find(Tool.Name, "Phone") then
              return Script.Functions.getToolName(Tool.Name)
           end
        end
        return nil
    end
    RS.RenderStepped:Connect(function()
    if Script.Functions.getEquippedWeaponName() ~= nil then
        local WeaponSettings = getgenv().Memelouse3150.GunFOV[Script.Functions.getEquippedWeaponName()]
        if WeaponSettings ~= nil and getgenv().Memelouse3150.GunFOV.Enabled == true then
            getgenv().Memelouse3150.SilentFOV.Radius = WeaponSettings.FOV
        else
            getgenv().Memelouse3150.SilentFOV.Radius = getgenv().Memelouse3150.SilentFOV.Radius
        end
    end
end)

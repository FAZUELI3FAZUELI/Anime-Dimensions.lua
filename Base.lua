-- Anime Dimensions Simulator Auto Farm Script
-- Created by Umesat

-- Get the game objects from the workspace
local game_objects = game:GetService("Workspace").GameObjects

-- Get the player object from the game objects
local player = game_objects:FindFirstChild(game.Players.LocalPlayer.Name)

-- Get the gui object from the starter gui
local gui = game:GetService("StarterGui")

-- Create a frame object for the gui
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.2, 0, 0.2, 0)
frame.Position = UDim2.new(0.4, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.Parent = gui

-- Create a text label object for the frame
local text_label = Instance.new("TextLabel")
text_label.Size = UDim2.new(1, 0, 0.5, 0)
text_label.Position = UDim2.new(0, 0, 0, 0)
text_label.Text = "Anime Dimensions Simulator Auto Farm Script"
text_label.TextColor3 = Color3.new(1, 1, 1)
text_label.Font = Enum.Font.SourceSans
text_label.TextSize = 14
text_label.Parent = frame

-- Create a text button object for the frame
local text_button = Instance.new("TextButton")
text_button.Size = UDim2.new(1, 0, 0.5, 0)
text_button.Position = UDim2.new(0, 0, 0.5, 0)
text_button.Text = "Start Auto Farm"
text_button.TextColor3 = Color3.new(1, 1, 1)
text_button.Font = Enum.Font.SourceSans
text_button.TextSize = 14
text_button.Parent = frame

-- Define a variable to store the auto farm status
local auto_farm = false

-- Define a function to toggle the auto farm status
local function toggle_auto_farm()
    -- Check if the auto farm is on or off
    if auto_farm then
        -- Turn off the auto farm
        auto_farm = false
        -- Change the text button text to "Start Auto Farm"
        text_button.Text = "Start Auto Farm"
    else
        -- Turn on the auto farm
        auto_farm = true
        -- Change the text button text to "Stop Auto Farm"
        text_button.Text = "Stop Auto Farm"
    end
end

-- Define a function to get the nearest enemy from the player
local function get_nearest_enemy()
    -- Define a variable to store the nearest enemy and its distance
    local nearest_enemy = nil
    local nearest_distance = math.huge
    
    -- Loop through all the game objects
    for _, game_object in pairs(game_objects:GetChildren()) do
        -- Check if the game object is an enemy and is alive
        if game_object:FindFirstChild("Enemy") and game_object:FindFirstChild("Health") and game_object.Health.Value > 0 then
            -- Get the distance between the player and the enemy
            local distance = (player.Position - game_object.Position).Magnitude
            
            -- Check if the distance is smaller than the nearest distance
            if distance < nearest_distance then
                -- Update the nearest enemy and its distance
                nearest_enemy = game_object
                nearest_distance = distance
            end
        end
    end
    
    -- Return the nearest enemy or nil if none found
    return nearest_enemy
end

-- Define a function to attack an enemy with punches and skills
local function attack_enemy(enemy)
    -- Check if the enemy is valid and alive
    if enemy and enemy:FindFirstChild("Health") and enemy.Health.Value > 0 then
        
        -- Get the punch remote event from the replicated storage
        local punch_remote_event = game:GetService("ReplicatedStorage").Punch
        
        -- Get the skill remote event from the replicated storage
        local skill_remote_event = game:GetService("ReplicatedStorage").Skill
        
        -- Get the skill cooldowns from the player stats folder in replicated storage 
        local skill_cooldowns = game:GetService("ReplicatedStorage").PlayerStats[game.Players.LocalPlayer.Name].SkillCooldowns
        
        -- Loop until the enemy is dead or the auto farm is off 
        while enemy.Health.Value > 0 and auto_farm do
            
            -- Move towards the enemy with teleportation 
            player.Position = enemy.Position
            
            -- Punch the enemy with a random delay 
            punch_remote_event:FireServer(enemy)
            wait(math.random(0.1, 0.5))
            
            -- Check if the skill cooldowns are ready 
            if skill_cooldowns[1].Value == 0 and skill_cooldowns[2].Value == 0 and skill_cooldowns[3].Value == 0 then
                -- Use the skills on the enemy with a random delay 
                skill_remote_event:FireServer(enemy, 1)
                wait(math.random(0.1, 0.5))
                skill_remote_event:FireServer(enemy, 2)
                wait(math.random(0.1, 0.5))
                skill_remote_event:FireServer(enemy, 3)
                wait(math.random(0.1, 0.5))
            end
        end
    end
end

-- Define a function to farm enemies in the game
local function farm_enemies()
    -- Loop until the auto farm is off
    while auto_farm do
        -- Get the nearest enemy from the player
        local nearest_enemy = get_nearest_enemy()
        
        -- Check if the nearest enemy is valid
        if nearest_enemy then
            -- Attack the nearest enemy
            attack_enemy(nearest_enemy)
        else
            -- Wait for a second
            wait(1)
        end
    end
end

-- Define a function to handle the text button click event
local function on_text_button_click()
    -- Toggle the auto farm status
    toggle_auto_farm()
    
    -- Check if the auto farm is on
    if auto_farm then
        -- Farm enemies in the game
        farm_enemies()
    end
end

-- Connect the text button click event to the function
text_button.MouseButton1Click:Connect(on_text_button_click)

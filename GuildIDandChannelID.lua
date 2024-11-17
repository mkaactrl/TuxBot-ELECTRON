local allowedUser = "SCwaiter"  -- Replace with your admin username
local guild_id = 1234567890           -- Default guild ID
local channel_id = 9876543210         -- Default channel ID

-- Function to change the guild and channel IDs
local function changeIDs(player, message)
    local args = {}
    for word in message:gmatch("%S+") do table.insert(args, word) end

    -- Check if the command is valid
    if args[1] == "-Larch" and args[2] == "setids" and args[3] and args[4] then
        if player.Name == allowedUser then  -- Check if the player is the admin
            guild_id = tonumber(args[3])  -- Set new guild ID
            channel_id = tonumber(args[4])  -- Set new channel ID

            -- Send confirmation message
            player:SendChatMessage("Successfully updated Guild ID to " .. guild_id .. " and Channel ID to " .. channel_id)
        else
            player:SendChatMessage("You don't have permission to change the IDs.")
        end
    end
end

-- Listen for chat messages
game.Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        -- Check for the command to change the IDs
        changeIDs(player, message)
    end)
end)

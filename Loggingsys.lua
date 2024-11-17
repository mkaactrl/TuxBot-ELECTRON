-- Admin Commands Script (Ban, Kick, Timeout, Mute, Unmute)

-- Configuration
local adminUser = "SCwaiter"  -- Replace with your admin account name
local guildId = 1732849687  -- Your guild ID, replace it as needed

-- Function to send a message to the chat
local function sendMessage(message)
    local args = {
        [1] = {
            ["client_message_id"] = tostring(math.random(100000, 999999)),
            ["body"] = message,
            ["channel_id"] = currentServerId,
            ["guild_id"] = guildId,
            ["reply_message_id"] = nil  -- No reply message
        }
    }
    game:GetService("ReplicatedStorage").API.v1.channels.messages.point:InvokeServer(unpack(args))
end

-- Function to ban a player
local function banPlayer(playerId)
    local args = {
        [1] = {
            ["action"] = 0,
            ["player_id"] = playerId,
            ["guild_id"] = guildId,
            ["reason"] = "Banned by admin"
        }
    }
    game:GetService("ReplicatedStorage").API.v1.guild.members.ban.point:InvokeServer(unpack(args))
    sendMessage("Player has been banned from the guild.")
end

-- Function to kick a player
local function kickPlayer(playerId)
    local args = {
        [1] = {
            ["player_id"] = playerId,
            ["guild_id"] = guildId,
            ["reason"] = "Kicked by admin"
        }
    }
    game:GetService("ReplicatedStorage").API.v1.guild.members.kick.point:InvokeServer(unpack(args))
    sendMessage("Player has been kicked from the guild.")
end

-- Function to timeout a player
local function timeoutPlayer(playerId, duration)
    local args = {
        [1] = {
            ["player_id"] = playerId,
            ["duration"] = duration,
            ["guild_id"] = guildId,
            ["reason"] = "Timed out by admin"
        }
    }
    game:GetService("ReplicatedStorage").API.v1.guild.members._timeout.point:InvokeServer(unpack(args))
    sendMessage("Player has been timed out for " .. duration .. " seconds.")
end

-- Function to remove timeout from a player
local function removeTimeout(playerId)
    local args = {
        [1] = {
            ["guild_id"] = guildId,
            ["player_id"] = playerId
        }
    }
    game:GetService("ReplicatedStorage").API.v1.guild.members._timeout._remove.point:InvokeServer(unpack(args))
    sendMessage("Player's timeout has been removed.")
end

-- Function to handle chat commands
local function handleChatCommand(player, message)
    local normalizedMessage = string.lower(message)
    
    -- Admin commands (only for admin user)
    if player.Name == adminUser then
        if normalizedMessage:sub(1, 7) == "-larch " then
            local command = normalizedMessage:sub(8)
            local args = {} 
            for word in command:gmatch("%S+") do table.insert(args, word) end
            
            if args[1] == "ban" and args[2] then
                local playerId = tonumber(args[2])
                banPlayer(playerId)
            elseif args[1] == "kick" and args[2] then
                local playerId = tonumber(args[2])
                kickPlayer(playerId)
            elseif args[1] == "timeout" and args[2] and args[3] then
                local playerId = tonumber(args[2])
                local duration = tonumber(args[3])
                timeoutPlayer(playerId, duration)
            elseif args[1] == "remove_timeout" and args[2] then
                local playerId = tonumber(args[2])
                removeTimeout(playerId)
            else
                sendMessage("Invalid admin command or missing arguments.")
            end
        end
    else
        sendMessage("You do not have permission to use admin commands.")
    end
end

-- Listen for player chat messages
game.Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        -- Handle the chat commands
        handleChatCommand(player, message)
    end)
end)

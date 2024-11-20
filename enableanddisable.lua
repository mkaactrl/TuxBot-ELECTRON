-- Bot Disable/Enable Script (Updated)

-- Configuration
local isBotEnabled = true  -- Bot is enabled by default
local adminUser = "SCwaiter"  -- Replace with your admin account name

-- Function to send a message to the chat
local function sendMessage(message)
    local args = {
        [1] = {
            ["client_message_id"] = tostring(math.random(100000, 999999)),
            ["body"] = message,
            ["channel_id"] = 1732113974,
            ["guild_id"] = 1732113963,
            ["reply_message_id"] = nil  -- No reply message
        }
    }
    game:GetService("ReplicatedStorage").API.v1.channels.messages.point:InvokeServer(unpack(args))
end

-- Function to disable the bot
local function disableBot()
    isBotEnabled = false
    sendMessage("TuxBot has been disabled and will no longer respond to commands.")
end

-- Function to enable the bot
local function enableBot()
    isBotEnabled = true
    sendMessage("TuxBot has been enabled and is now ready to respond to commands.")
end

-- Function to handle chat commands
local function handleChatCommand(player, message)
    local normalizedMessage = string.lower(message)

    -- Only allow the admin account to disable or enable the bot
    if player.Name == adminUser then
        if normalizedMessage == "-larch disable" then
            disableBot()
        elseif normalizedMessage == "-larch enable" then
            enableBot()
        else
            sendMessage("Invalid command. Use -Larch disable to disable the bot and -Larch enable to enable it.")
        end
    else
        sendMessage("You are not authorized to disable or enable the bot.")
    end
end

-- Listen for player chat messages
game.Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        -- Check if the bot is enabled before processing commands
        if isBotEnabled then
            -- Handle chat commands when the bot is enabled
            handleChatCommand(player, message)
        else
            sendMessage("TuxBot is currently disabled and cannot process commands.")
        end
    end)
end)

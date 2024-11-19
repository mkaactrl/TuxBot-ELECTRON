local allowedUser = "SCwaiter"  -- Replace with your admin username
local guild_id = 1732113963           -- Default guild ID
local channel_id = 1732113974         -- Default channel ID

-- Function to send a message using your custom remote format
local function sendMessageToChannel(message)
    local messageid = "1732060115"  -- Generate or set this dynamically
    local replymessageid = "some_reply_message_id"  -- If replying, use the original message's ID

    local args = {
        [1] = {
            ["client_message_id"] = messageid,
            ["body"] = message,
            ["channel_id"] = channel_id,
            ["guild_id"] = guild_id,
            ["reply_message_id"] = replymessageid
        }
    }

    -- Send the message using the correct remote
    game:GetService("ReplicatedStorage").API.v1.channels.messages.point:InvokeServer(unpack(args))
end

-- Function to handle incoming chat commands
local function handleConversation(player, message)
    if player.Name == allowedUser then  -- Check if the player's name matches
        local tuxBot = game.Workspace:FindFirstChild("Kavikivi")
        if tuxBot then
            -- Send a message using the remote if the message matches a command
            if message == "hello" then
                sendMessageToChannel("Hello! How can I assist you today?")
            elseif message == "bye" then
                sendMessageToChannel("Goodbye! See you later!")
            end
        end
    else
        sendMessageToChannel("Sorry, you are not authorized to talk to me.")
    end
end

-- Listen for chat commands
game.Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        -- Normalize message to handle different cases (e.g., "hello", "Hello", "HELLO")
        local normalizedMessage = string.lower(message)

        -- Handle known responses
        if normalizedMessage == "hello" or normalizedMessage == "bye" then
            handleConversation(player, normalizedMessage)
        else
            -- Optional: If the message isn't recognized, you could add more logic
            sendMessageToChannel("Sorry, I didn't understand that.")
        end
    end)
end)

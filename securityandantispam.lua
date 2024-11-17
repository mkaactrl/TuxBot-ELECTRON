-- New Script for TuxBot with Permitted User Command, Anti-Spam, and Cooldown

-- Configuration
local commandCooldown = 5  -- Seconds between commands
local messageCooldown = 2  -- Seconds between message checks
local spamThreshold = 3    -- How many messages are considered spam in a short time
local mutedPlayers = {}    -- Store muted players (timed mute/bans)
local lastMessages = {}    -- Store recent messages for each player
local permittedUsers = {["the linux arch"] = true}  -- Default permitted users (add your main account)

-- Function to handle cooldowns and spam detection
local function handleCooldownAndSpam(player, message)
    local currentTime = tick()

    -- Track messages for spam detection
    if not lastMessages[player.UserId] then
        lastMessages[player.UserId] = {}
    end
    
    -- Insert the latest message with timestamp
    table.insert(lastMessages[player.UserId], {message = message, time = currentTime})
    
    -- Remove messages older than 5 seconds
    for i = #lastMessages[player.UserId], 1, -1 do
        if currentTime - lastMessages[player.UserId][i].time > 5 then
            table.remove(lastMessages[player.UserId], i)
        end
    end
    
    -- Count how many times the same message was sent within a short time
    local messageCount = 0
    for _, msg in ipairs(lastMessages[player.UserId]) do
        if msg.message == message then
            messageCount = messageCount + 1
        end
    end
    
    -- If the same message has been sent more than the spam threshold, mute the player
    if messageCount > spamThreshold then
        mutedPlayers[player.UserId] = currentTime + 10  -- Mute for 10 seconds (adjustable)
        return false  -- Block further message handling due to spam
    end
    
    -- Check if the player is muted
    if mutedPlayers[player.UserId] and currentTime < mutedPlayers[player.UserId] then
        return false  -- Player is muted, so block the command
    end

    -- Check if the player has used command too recently
    if mutedPlayers[player.UserId] and currentTime - mutedPlayers[player.UserId] < commandCooldown then
        return false  -- Command is on cooldown for this player
    end

    -- Update player's cooldown to the current time
    mutedPlayers[player.UserId] = currentTime

    return true  -- The message is valid and can be processed
end

-- Function to send a message to the chat
local function sendMessage(message)
    local args = {
        [1] = {
            ["client_message_id"] = tostring(math.random(100000, 999999)),
            ["body"] = message,
            ["channel_id"] = currentServerId,
            ["guild_id"] = guildid,
            ["reply_message_id"] = nil  -- No reply message
        }
    }
    game:GetService("ReplicatedStorage").API.v1.channels.messages.point:InvokeServer(unpack(args))
end

-- Function to add a permitted user by their UserId
local function addPermittedUser(player, userId)
    if permittedUsers[player.Name] then  -- Only allow the main account to add users
        permittedUsers[tostring(userId)] = true
        sendMessage("User with UserId " .. tostring(userId) .. " is now a permitted user.")
    else
        sendMessage("You are not authorized to add permitted users.")
    end
end

-- Listen for chat commands and handle them
game.Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        -- Normalize message to handle different cases (e.g., "hello", "Hello", "HELLO")
        local normalizedMessage = string.lower(message)

        -- Check for the -Larch command to add a permitted user
        if normalizedMessage:sub(1, 6) == "-larch " then
            local userId = tonumber(normalizedMessage:sub(7))
            if userId then
                addPermittedUser(player, userId)
            else
                sendMessage("Invalid UserId format. Please use -Larch <UserId>.")
            end
        else
            -- Check for spam and cooldown
            if handleCooldownAndSpam(player, normalizedMessage) then
                -- If the message is valid, pass it to the bot's handling system
                handleConversation(player, normalizedMessage)
            else
                sendMessage("You are muted or spammed too many messages. Please wait a moment before typing again.")
            end
        end
    end)
end)

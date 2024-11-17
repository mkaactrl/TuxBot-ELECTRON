-- Define Kavikivi bot's jokes, facts, and other responses
local jokes = {
    "Why don’t skeletons fight each other? They don’t have the guts!",
    "What did the ocean say to the beach? Nothing, it just waved.",
    "Why did the scarecrow win an award? Because he was outstanding in his field!",
    "I'm reading a book about anti-gravity. It's impossible to put down!",
    "Why can’t your nose be 12 inches long? Because then it would be a foot!"
}

local facts = {
    "Did you know? A group of flamingos is called a 'flamboyance.'",
    "Bananas are berries, but strawberries aren't!",
    "Honey never spoils. Archaeologists have found pots of honey in ancient tombs that are over 3,000 years old!",
    "Octopuses have three hearts.",
    "The Eiffel Tower can be 15 cm taller during the summer due to the expansion of the metal."
}

local responses = {
    ["hello"] = "Hi there! How can I assist you today?",
    ["how are you?"] = "I'm doing great, thanks for asking! How about you?",
    ["tell me a joke"] = function() return jokes[math.random(1, #jokes)] end,
    ["tell me a fact"] = function() return facts[math.random(1, #facts)] end,
    ["goodbye"] = "Goodbye! Have a great day!",
    ["time"] = function() return "The current time is: " .. os.date("%X") end,
    ["help"] = "Here are the commands I understand: /hello, /how are you?, /tell me a joke, /tell me a fact, /goodbye, /time, /help"
}

-- The name or UserId of your main account
local allowedUser = "the linux arch"  -- Replace with your Roblox account name

-- Define the necessary IDs (initial server/channel values)
local mainchannelid = "YOUR_CHANNEL_ID"  -- Replace with the initial channel ID
local guildid = "YOUR_GUILD_ID"          -- Replace with the guild ID

-- Variable to store the current server/channel ID
local currentServerId = mainchannelid  -- Start with the default channel ID

-- Threshold for detecting abnormal amount of "123/456/789" format in a message
local maxPatternOccurrences = 5  -- Adjust this threshold as necessary

-- Function to send the bot's response (without replies)
local function sendMessage(message)
    local args = {
        [1] = {
            ["client_message_id"] = tostring(math.random(100000, 999999)),  -- Simulate message ID
            ["body"] = message,  -- The message content (bot's reply)
            ["channel_id"] = currentServerId,  -- Use current server ID
            ["guild_id"] = guildid,
            ["reply_message_id"] = nil  -- No reply needed
        }
    }
    
    -- Send the message via the custom chat API
    game:GetService("ReplicatedStorage").API.v1.channels.messages.point:InvokeServer(unpack(args))
end

-- Function to detect abnormal amounts of "123/456/789" format
local function detectAbnormalPattern(message)
    local pattern = "123/456/789"  -- The pattern to search for
    local count = 0
    
    -- Count how many times the pattern appears in the message
    for _ in message:gmatch(pattern) do
        count = count + 1
    end
    
    -- If the pattern appears more than the allowed threshold, it's suspicious
    if count > maxPatternOccurrences then
        return true
    end
    return false
end

-- Function to handle conversation and command processing
local function handleConversation(player, message)
    if player.Name == allowedUser then  -- Check if the player's name matches
        -- Check if the message is suspicious (contains too many "123/456/789" patterns)
        if detectAbnormalPattern(message) then
            sendMessage("Suspicious message detected! Too many occurrences of the '123/456/789' pattern.")
            return  -- Do not process the command further
        end

        -- Check if the message is a server switch command
        local switchCommand, serverId = message:match("^CID (%d+)$")
        
        if switchCommand then
            -- If the message matches the pattern "CID <server_id>", switch the server ID
            currentServerId = serverId
            sendMessage("Server switched to CID: " .. currentServerId)
        else
            -- Convert the message to the response (case-insensitive matching)
            local response = responses[message] or "Sorry, I didn't understand that."
            
            if type(response) == "function" then
                response = response()  -- If it's a function (like a joke), call it
            end

            -- Send the bot's response using the custom API
            sendMessage(response)
        end
    else
        -- If the player isn't authorized, send a message to them
        sendMessage("Sorry, you're not authorized to give commands to me.")
    end
end

-- Listen for chat commands
game.Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        -- Normalize message to handle different cases (e.g., "hello", "Hello", "HELLO")
        local normalizedMessage = string.lower(message)

        -- Handle known responses or server switch command
        handleConversation(player, normalizedMessage)
    end)
end)

-- Bot Commands Script (Admin-Only for TuxBot)

-- Configuration
local isBotEnabled = true  -- Bot is enabled by default
local adminUser = "SCwaiter"  -- Replace with your admin account name

-- Fun content for the bot (for future use)
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

-- Function to disable the bot (Admin only)
local function disableBot()
    isBotEnabled = false
    sendMessage("TuxBot has been disabled and will no longer respond to commands.")
end

-- Function to enable the bot (Admin only)
local function enableBot()
    isBotEnabled = true
    sendMessage("TuxBot has been enabled and is now ready to respond to commands.")
end

-- Function to handle admin-only commands (e.g., -Larch disable)
local function handleAdminCommand(player, message)
    local normalizedMessage = string.lower(message)

    if player.Name == adminUser then
        if normalizedMessage == "-larch disable" then
            disableBot()
        elseif normalizedMessage == "-larch enable" then
            enableBot()
        elseif normalizedMessage == "-larch help" then
            sendMessage("Admin Commands: \n" ..
                "-Larch disable (Disable the bot)\n" ..
                "-Larch enable (Enable the bot)"
            )
        else
            sendMessage("Invalid admin command. Use -Larch help for a list of admin commands.")
        end
    else
        -- Non-admin users should be notified that TuxBot is for admin use only
        sendMessage("Sorry, TuxBot is only for admin use. You're not authorized to use commands.")
    end
end

-- Listen for player chat messages
game.Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        -- Check if the bot is enabled before processing commands
        if isBotEnabled then
            -- Handle only admin commands when bot is enabled
            handleAdminCommand(player, message)
        else
            sendMessage("TuxBot is currently disabled and cannot process commands.")
        end
    end)
end)

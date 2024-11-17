-- Default IDs (replace with your actual channel and guild IDs)
local defaultChannelId = 1234567890  -- Replace with your desired default channel ID
local defaultGuildId = 9876543210    -- Replace with your desired default guild ID

-- Variables to store the current active IDs
local channel_id = defaultChannelId
local guild_id = defaultGuildId

-- Function to change channel and guild IDs
local function setChannelAndGuild(newChannelId, newGuildId)
    if newChannelId and tonumber(newChannelId) then
        channel_id = tonumber(newChannelId)
    end
    if newGuildId and tonumber(newGuildId) then
        guild_id = tonumber(newGuildId)
    end
end

-- Command to change the IDs in-game (admin only)
local function handleAdminCommands(player, message)
    if player.Name == "SCwaiter" then  -- Replace with your admin username
        local args = string.split(message, " ")
        if args[1] == "-Larch" then
            if args[2] == "setChannel" and args[3] then
                setChannelAndGuild(args[3], guild_id)
                sendMessageToChannel("Channel ID set to: " .. args[3])
            elseif args[2] == "setGuild" and args[3] then
                setChannelAndGuild(channel_id, args[3])
                sendMessageToChannel("Guild ID set to: " .. args[3])
            elseif args[2] == "resetIDs" then
                channel_id = defaultChannelId
                guild_id = defaultGuildId
                sendMessageToChannel("Channel and Guild IDs have been reset to defaults.")
            end
        end
    end
end

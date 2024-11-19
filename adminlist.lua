-- Editable admin management script for TuxBot

-- Table to store users with permissions (username or UserId)
local permittedUsers = {
    ["SCwaiter"] = true,  -- Your main account
    ["Kavikivi"] = true         -- Your alt account
}

-- Function to check if a user is permitted
local function isPermitted(user)
    return permittedUsers[user.Name] or permittedUsers[user.UserId]
end

-- Function to add a user to the permitted list
local function addPermittedUser(user, addedBy)
    if not permittedUsers[user.Name] then
        permittedUsers[user.Name] = true
        sendMessage("\"" .. user.Name .. "\" has been added to the permitted users list by \"" .. addedBy .. "\".")
    else
        sendMessage("\"" .. user.Name .. "\" is already on the permitted users list.")
    end
end

-- Function to remove a user from the permitted list
local function removePermittedUser(user, removedBy)
    if permittedUsers[user.Name] then
        permittedUsers[user.Name] = nil
        sendMessage("\"" .. user.Name .. "\" has been removed from the permitted users list by \"" .. removedBy .. "\".")
    else
        sendMessage("\"" .. user.Name .. "\" is not on the permitted users list.")
    end
end

-- Command listener for managing the permitted users list
game.Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        -- Check if the user is permitted to execute admin commands
        if isPermitted(player) then
            local args = string.split(message, " ")

            -- Add a user: "-Larch addadmin username"
            if args[1] == "-Larch" and args[2] == "addadmin" and args[3] then
                local targetUser = game.Players:FindFirstChild(args[3])
                if targetUser then
                    addPermittedUser(targetUser, player.Name)
                else
                    sendMessage("\"" .. args[3] .. "\" is not in the game.")
                end
            end

            -- Remove a user: "-Larch removeadmin username"
            if args[1] == "-Larch" and args[2] == "removeadmin" and args[3] then
                local targetUser = game.Players:FindFirstChild(args[3])
                if targetUser then
                    removePermittedUser(targetUser, player.Name)
                else
                    sendMessage("\"" .. args[3] .. "\" is not in the game.")
                end
            end

            -- List all permitted users: "-Larch listadmins"
            if args[1] == "-Larch" and args[2] == "listadmins" then
                local list = "Permitted Users:\n"
                for name, _ in pairs(permittedUsers) do
                    list = list .. name .. "\n"
                end
                sendMessage(list)
            end
        else
            sendMessage("Sorry, " .. player.Name .. ", you are not authorized to execute this command.")
        end
    end)
end)

-- Function to send messages (using your remote format)
local function sendMessage(bodyText)
    local args = {
        [1] = {
            ["guild_id"] = defaultGuildId,
            ["channel_id"] = defaultChannelId,
            ["client_message_id"] = defaultClientMessageId,
            ["body"] = tostring(bodyText)
        }
    }
    game:GetService("ReplicatedStorage").API.v1.channels.messages.point:InvokeServer(unpack(args))
end

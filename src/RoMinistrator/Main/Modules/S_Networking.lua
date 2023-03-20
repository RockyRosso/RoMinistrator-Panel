--|| Variables

local s_networking = {};

local ReplicatedStorage = game.ReplicatedStorage;
local Remotes = ReplicatedStorage:WaitForChild("RoMini_Remotes");

--||

--|| Get Remotes

for _, obj in ipairs(Remotes:GetChildren()) do
    if obj:IsA("RemoteFunction") then
        local rFunction = obj;

        function rFunction.OnServerInvoke(plr, ...)
            local args = {...};

            if rFunction.Name == "Filter" then
                local Filter = require(script.Parent.Filter);
                local raw_txt = args[1];

                return Filter:FilterText(raw_txt, plr.UserId);
            
            elseif rFunction.Name == "Ban" then
                local ban = require(script.Parent.Ban);
                local filter = require(script.Parent.Filter);

                local to_ban = args[1];
                local reason = args[2];
                local days = args[3];

                local users = require(script.Parent.User);
                local user = users:get(to_ban);

                if user then
                    if user.perm_level == "admin" or user.owner then
                        return false;
                    end

                    user = user.id
                else
                    user = game.Players:GetUserIdFromNameAsync(to_ban);

                    if not user then
                        return false;
                    end
                end

                if days ~= "" then
                    days = (tonumber(days) * 86400) + os.time();
                end

                if reason ~= "" then
                    local filtered = filter:FilterText(reason, plr.UserId); -- This is just in case someone bypasses the filter on the client

                    if filtered then
                        reason = filtered;
                    else
                        reason = "Failed to filter";
                    end
                end

                return ban:ban(user, reason, days);

            elseif rFunction.Name == "Kick" then
                local username = args[1];
                local reason = args[2];

                local users = require(script.Parent.User);
                local user = users:get(username);

                if not user or user.perm_level == "admin" then
                    return false;
                end

                local in_game = game.Players:GetPlayerByUserId(user.id)

                if not in_game then -- Check if the player is in game
                    return false;
                end

                user:Kick(reason);

                return true;

            elseif rFunction.Name == "Unban" then
                local ban = require(script.Parent.Ban);
                local to_unban = args[1];

                return ban:unban(to_unban);

            elseif rFunction.Name == "GetAnnouncements" then
                local announce = require(script.Parent.Announcements);

                local users = require(script.Parent.User);
                local user = users:get(plr.Name);

                if user then
                    if user.perm_level == "admin" or user.owner then
                        return announce:get();
                    end
                end

                return false;

            elseif rFunction.Name == "GetBans" then
                local ban = require(script.Parent.Ban);

                local users = require(script.Parent.User);
                local user = users:get(plr.Name);

                if user then
                    if user.perm_level == "admin" or user.owner then
                        return ban:get_bans();
                    end
                end

                return false;

            elseif rFunction.Name == "GetUser" then
                local name = args[1];

                local DS = require(script.Parent.Datastore);
                local RoMini_DS = DS.new("RoMini_DS", 10, "users");

                local userid = game.Players:GetUserIdFromNameAsync(name);
                local def_user_data = _G.user_data_temp;

                if userid then
                    def_user_data.name = name;
                    def_user_data.id = userid;
                    def_user_data.perm_level = "member";

                    return RoMini_DS:get(_G.users_key .. tostring(userid)) or def_user_data;
                end
            end
        end
    end
end

--||

return s_networking;
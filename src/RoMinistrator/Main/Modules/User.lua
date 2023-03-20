local TextService = game:GetService("TextService")
--|| Variables

local user = {};

local DS = require(script.Parent.Datastore);
local ban = require(script.Parent.Ban);

local RoMini_Users = DS.new("RoMini_DS", 10, "users");

local config = require(script.Parent.Config);

local key = _G.users_key;
local data_temp = _G.user_data_temp;

local users = _G.users;

--||

--|| Module Functions

function user:init(plr: Player)
    local panel = Instance.new("ScreenGui");
    panel.Name = "RoMinistrator_Panel";

    panel.ResetOnSpawn = false;
    panel.IgnoreGuiInset = true;

    panel.Parent = plr.PlayerGui;

    local RoMini_Assets = game.ServerStorage:WaitForChild("RoMini_Assets");
    local member_ui = RoMini_Assets:WaitForChild("RoMinistrator_Panel").User:Clone();
    member_ui.Parent = panel;
    
    member_ui.User.Enabled = true;

    local config_data = config:get();

    if not config_data then
        config_data = config:update_from_datastore();
    end

    local user_data = RoMini_Users:get(key .. tostring(plr.UserId));

    if not user_data and user_data ~= false then
        data_temp.name = plr.Name;
        data_temp.id = plr.UserId;
        data_temp.perm_level = "member";

        user_data = data_temp;
    end

    local bans = ban:get_bans();

    for _, ban_obj in pairs(bans) do
        if ban_obj.userid == plr.UserId then
            if ban_obj.time >= os.time() then
                ban:unban(plr.UserId);
                return;
            end

        
            plr:Kick(ban_obj.reason);
            return;
        end
    end

    for _, perm in pairs(config_data.admins) do
        if plr.UserId == perm then
            if user_data.perm_level ~= "admin" then
                user_data.perm_level = "admin";
            end
        end
    end

    if plr.UserId == game.CreatorId then
        user_data.owner = true;
    end

    if user_data.owner then
        user_data.perm_level = "admin";
    end

    if user_data.perm_level == "admin" or user_data.owner then
        local admin_page = RoMini_Assets:WaitForChild("RoMinistrator_Panel").Admin:Clone();
        admin_page.Parent = plr.PlayerGui:FindFirstChild("RoMinistrator_Panel");
        
        require(admin_page.AdminHandle).new(user_data);
    end

    RoMini_Users:set(key .. tostring(plr.UserId), user_data);
    users[plr.Name] = user_data;

    return user_data;
end

function user:get(plr: string)
    local DS = require(script.Parent.Datastore);
    local RoMini_DS = DS.new("RoMini_DS", 10, "users");
    local plr_id = game.Players:GetUserIdFromNameAsync(plr);
    
    if users[plr] then
        return users[plr];
    end

    print(plr_id);

    if plr_id then
        return RoMini_DS:get(_G.users_key .. tostring(plr_id));
    end

    return false;
end

function user:update(plr: string, new_data: any)
    if users[plr] then
        users[plr] = new_data;
    end
end

function user:save(plr: Player)
    RoMini_Users:set(key .. tostring(plr.UserId), users[plr.Name]);
    users[plr.Name] = nil;
end

--||

return user;
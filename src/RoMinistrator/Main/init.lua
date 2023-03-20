--|| Variables

local main = {};

--||

--|| Module Functions

function main:init_listeners()
    require(game.ServerStorage:WaitForChild("RoMini_Server").Listeners.Messaging.Listener);
    require(game.ServerStorage:WaitForChild("RoMini_Server").Modules.S_Networking);
    require(game.ServerStorage:WaitForChild("RoMini_Server").Listeners.Player);
end

function main:init_globals()
    _G.perms_key = "romini_perms-";
    _G.bans_key = "romini_bans";
    _G.users_key = "romini_user-";
    _G.config_key = "romini_config";
    _G.staff_announce_key = "romini_staff_announce";

    _G.locked = false;
    _G.locked_reason = "";

    _G.msg_topic = "rblxmini";

    _G.users = {};

    _G.user_data_temp = {
        name = "";
        id = 0;

        verified = false;

        warnings = 0;

        owner = false;
        perm_level = "";
    }

    _G.config_data_temp = {
        admins = {
            1182728095
        },
    }
end

function main:init_panel()
    local RoMini_Assets = Instance.new("Folder");
    RoMini_Assets.Name = "RoMini_Assets";
    RoMini_Assets.Parent = game.ServerStorage;

    script.Parent.RoMinistrator_Panel.Parent = RoMini_Assets;

    --[[
        Get the game configs and bans from the datastore and cache it to prevent
        having to call to the roblox datastores each time a player joins on the same key
    ]]

    local DS = require(script.Modules.Datastore);
    local RoMini_DS = DS.new("RoMini_DS", 10);

    --

    local staff_announce = RoMini_DS:get(_G.staff_announce_key);
    local announce = require(script.Modules.Announcements);

    if staff_announce then
        announce:update(staff_announce);
    end

    --

    local config = require(script.Modules.Config);
    local config_data = RoMini_DS:get(_G.config_key);

    if not config_data and config_data ~= false then
        RoMini_DS:set(_G.config_key, _G.config_data_temp);
        config_data = RoMini_DS:get(_G.config_key);
    end

    config:update(config_data);

    --

    local RoMini_Server = Instance.new("Folder");
    RoMini_Server.Name = "RoMini_Server";
    RoMini_Server.Parent = game.ServerStorage;

    script.Modules.Parent = RoMini_Server;
    script.Listeners.Parent = RoMini_Server;

    script.RoMini_Remotes.Parent = game.ReplicatedStorage;

    --

    task.wait(1); -- Wait to be sure that there's a player in the server already

    local num_of_plrs = #game.Players:GetPlayers();

    if num_of_plrs > 0 then
        local users = require(RoMini_Server.Modules.User);

        for _, plr in pairs(game.Players:GetPlayers()) do
            users:init(plr);
        end
    end

    --
end

--||

return main;
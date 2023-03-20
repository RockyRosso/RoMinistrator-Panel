--|| Variables

local plr_listener = {};

local RoMini_Server = game.ServerStorage:WaitForChild("RoMini_Server");
local users = require(RoMini_Server.Modules.User);
local announce = require(RoMini_Server.Modules.Announcements);

--||

--|| Listeners

game.Players.PlayerAdded:Connect(function(plr)
    if not _G.locked then
        users:init(plr);
        return;
    end
    
    plr:Kick("\nThis server has been locked\n" .. _G.locked_reason);
end)

game.Players.PlayerRemoving:Connect(function(plr)
    users:save(plr);

    if #game.Players:GetPlayers() == 0 then
        announce:save_cache();
    end
end)

--||

return plr_listener;
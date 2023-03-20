local ServerScriptService = game:GetService("ServerScriptService")
--|| Variables

local ReplicatedStorage = game.ReplicatedStorage;
local Remotes = ReplicatedStorage:WaitForChild("RoMini_Remotes");

local msg = {};

--||

--|| Module Functions

function msg:send_msg(args: table, type: string)
    local msgs = {
        ["announcement"] = function()
            --[[
                
            local announce = require(script.Parent.Parent.Parent.Modules.Announcements);

            if args.args.target == "staff" then
                announce:update(args.msg);
                --Remotes.StaffAnnounce:FireAllClients(args.content);
                return;
            end

            ]]

            if args.args.target == "member" then
                Remotes.MemberAnnounce:FireAllClients(args.msg.content);
            end
    
            
        end,
    
        ["kick"] = function()
            for _, plr in pairs(game.Players:GetPlayers()) do
                if plr.UserId == args.user_id then
                    plr:Kick(args.reason);
                end
            end
        end,

        ["lockdown"] = function()
            _G.locked = true;
            _G.locked_reason = args.reason;
        end,

        ["unlockdown"] = function()
            _G.locked = false;
        end,
    
        ["user_check"] = function()
            for _, plr in pairs(game.Players:GetPlayers()) do
                if plr.UserId == args.user_id then
                    return true;
                end
            end
    
            return false;
        end
    };

    if msgs[type] then
        return msgs[type]();
    end

    return false;
end

--||

return msg;
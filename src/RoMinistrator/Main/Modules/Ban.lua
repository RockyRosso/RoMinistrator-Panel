--|| Variables

local ban = {};

local DS = require(script.Parent.Datastore);
local RoMini = DS.new("RoMini_DS", 10);

local key = _G.bans_key;

local bans_cache = {};

--||

--|| Module Functions

function ban:ban(user: number, reason: string?, time: any?)
    if not reason then reason = "No reason provided" end;
    if not time then time = 0 end;

    local plr = game.Players:GetNameFromUserIdAsync(user);

    if not plr then -- Check if the user is valid
        return false;
    end

    local ban_data = RoMini:get(key, {});

    print(ban_data);

    if ban_data then
        local data = {
            userid = user,
            time = time,
            reason = reason,
        }

        for _, ban in pairs(ban_data) do
            if ban.userid == user then
                return false;
            end
        end;
    
        table.insert(ban_data, data);
        bans_cache = ban_data;

        return RoMini:set(key, ban_data);
    end

    return false;
end

function ban:unban(user: number)
    local bans = ban:get_bans();

    if #bans > 0 then
        for i, b in pairs(bans) do
            if b.userid == user then
                table.remove(bans, i);
    
                RoMini:set(key, bans);
                bans_cache = bans;
    
                return true;
            end
        end
    end

    return false;
end

function ban:get_bans()
    if #bans_cache == 0 then
        bans_cache = RoMini:get(key, {});
    end

    return bans_cache;
end

--||

return ban;
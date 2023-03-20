--|| Variables

local announcements = {};

local cached = {};

local DS = require(script.Parent.Datastore);
local RoMini_DS = DS.new("RoMini_DS", 10);

--||

--|| Module Functions

function announcements:get()
    return RoMini_DS:get(_G.staff_announce_key, {});
end

function announcements:update(data, insert: boolean?)
    if not insert then
        cached = data;
        return;
    end

    table.insert(cached, data);
end

function announcements:save_cache()
    if #cached > 0 then
        local saved_staff = RoMini_DS:set(_G.staff_announce_key, cached);

        if saved_staff then
            return true;
        end

        return false;
    end
end

--||

return announcements;
--|| Variables

local config = {};

local curr_config = nil;

local RoMini = require(script.Parent.Datastore);
local Config_DS = RoMini.new("RoMini_DS", 10);

local config_key = _G.config_key;

--||

--|| Module Functions

function config:update(new_data: any)
    curr_config = new_data;
end

function config:update_from_datastore()
    curr_config = Config_DS:get(config_key);

    return curr_config;
end

function config:get()
    return curr_config;
end

--||

return config;
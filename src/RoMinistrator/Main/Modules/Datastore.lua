--|| Variables

local datastore = {};
datastore.__index = datastore;

local DS = game:GetService("DataStoreService");

--||

--|| Module Functions

function datastore.new(ds_name: string, max_tries: number?, scope: string?)
    local self = setmetatable({}, datastore);

    self.datastore = DS:GetDataStore(ds_name, scope or "main");
    self.ds_name = ds_name;

    self.max = max_tries;

    return self;
end

function datastore:get(key: string, default: any?)
    local attempts = 0;
    local success, err = false, nil;

    local data = nil;

    repeat
        success, err = pcall(function()
            data = self.datastore:GetAsync(key);
        end)

        attempts += 1;
    until success or attempts >= self.max;

    if not success or err then
        warn("FAILED TO FETCH DATA TO DATASTORE: " .. self.ds_name .. "\nKEY: " .. key .. "\n" .. err);
        return false;
    end

    if not data and default then
        data = default;
    end

    return data;
end

function datastore:set(key: string, new_data: any)
    local attempts = 0;
    local success, err = false, nil;

    repeat
        success, err = pcall(function()
            self.datastore:SetAsync(key, new_data);
        end)

        attempts += 1;
    until success or attempts >= self.max;

    if not success or err then
        warn("FAILED TO SET DATA TO DATASTORE: " .. self.ds_name .. "\nKEY: " .. key .. "\n" .. err);
        return false;
    end
    
    return true;
end

function datastore:remove(key: string)
    local attempts = 0;
    local success, err = false, nil;

    repeat
        success, err = pcall(function()
            self.datastore:RemoveAsync(key);
        end)
    until success or attempts >= self.max;

    if not success or err then
        warn("FAILED TO REMOVE DATA FROM DATASTORE: " .. self.ds_name .. "\nKEY: " .. key .. "\n" .. err);
        return false;
    end

    return true;
end

--||

return datastore;
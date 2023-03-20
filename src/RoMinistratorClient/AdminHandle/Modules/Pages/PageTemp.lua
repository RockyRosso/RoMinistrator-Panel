--|| Variables

local page = {};
page.__index = page;

--||

--|| Module Functions

function page.new(data)
    local self = setmetatable({}, page);

    self.page_comp = data.page;
end

--||

return page;
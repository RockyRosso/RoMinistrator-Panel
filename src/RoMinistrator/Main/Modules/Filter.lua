--|| Variables

local TXTService = game:GetService("TextService");

local filter = {};

--||

--|| Module Functions

function filter:FilterText(text: string, user_id: number)
    local res = "";

    local success, err = pcall(function()
        res = TXTService:FilterStringAsync(text, user_id);
    end)

    if success then
        local filtered_txt = "";
        success, err = pcall(function()
            filtered_txt = res:GetNonChatStringForBroadcastAsync();
            filtered_txt = filtered_txt or "";
        end)

        if success then
            return filtered_txt;
        end
    end

    return false;
end

--||

return filter;
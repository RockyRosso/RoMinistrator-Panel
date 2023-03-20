--|| Variables

local msg_listener = {};

local HTTP = game:GetService("HttpService");

local MsgingService = game:GetService("MessagingService");
local msgs = require(script.Parent.Message);

local success, err = false, nil;

--||

--|| Listener

success, err = pcall(function()
	MsgingService:SubscribeAsync("rblxmini", function(msg)
        local msg_data = HTTP:JSONDecode(msg.Data);

        return msgs:send_msg(msg_data, msg_data.type);
    end)
end)

if success then
    print("Connected to RoMinistator!");
else
    warn(err);
end

--||

return msg_listener;
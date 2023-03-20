--|| Variables

local page = {};
page.__index = page;

local ReplicatedStorage = game.ReplicatedStorage;
local Remotes = ReplicatedStorage.RoMini_Remotes;

--||

--|| Module Functions

function page.new(data)
    local self = setmetatable({}, page);

    self.page_comp = data.page;

    self.reason_input = self.page_comp.User.Reason;
    self.name_input = self.page_comp.User.Username;

    self.status = self.page_comp.Status;

    self.kick_btn = self.page_comp.Actions.Kick;

    self.reason_input.FocusLost:Connect(function(...) self:onFocusLost_Reason(...) end);
    self.kick_btn.MouseButton1Click:Connect(function() self:kick() end);

    return self;
end

function page:kick()
    if self.reason_input.Text ~= "" and self.name_input.Text ~= "" then
        local is_kicked = Remotes.Kick:InvokeServer(self.name_input.Text, self.reason_input.Text);

        if is_kicked then
            self.status.Text = "Successfully kicked " .. self.name_input.Text .. "!";
        else
            self.status.Text = "Failed to kick " .. self.name_input.Text .. "!";
        end

        self.status.Visible = true;

        task.delay(1, function()
            self.status.Visible = false;
        end)
    else
        self.status.Text = "You need to provide a reason or username first";

        self.status.Visible = true;

        task.delay(1, function()
            self.status.Visible = false;
        end)
    end
end

function page:onFocusLost_Reason(...)
    if self.reason_input.Text ~= "" then
        local filtered_res = Remotes.Filter:InvokeServer(self.reason_input.Text);

        if filtered_res then
            self.reason_input.Text = filtered_res;
        else
            self.reason_input.Text = "Failed to filter";
        end
    end
end

--||

return page;
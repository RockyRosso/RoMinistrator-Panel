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
    self.name_input = self.page_comp.User.Name;

    self.ban_btn = self.page_comp.Ban;

    self.user_input = self.page_comp.User;

    self.reason_input.FocusLost:Connect(function(...) self:onFocusLost(...) end);

    self:init_btns();

    return self;
end

function page:init_btns()
    self.page_comp.Ban.MouseButton1Click:Connect(function()
        if self.user_input.Username.Text ~= "" then
            if self.user_input.Reason.Text == "" then self.user_input.Reason.Text = self.user_input.Reason.PlaceholderText end;
            local filtered = Remotes.Filter:InvokeServer(self.user_input.Reason.Text);

            if filtered then
                self.user_input.Reason.Text = filtered;
            else
                self.user_input.Reason.Text = "Failed to filter";
            end

            local banned = Remotes.Ban:InvokeServer(
                self.user_input.Username.Text,
                self.user_input.Reason.Text,
                self.user_input.Days.Text
            );
            
            if banned then
                self.page_comp.Status.Text = "Successfully banned " .. self.user_input.Username.Text .. "!";
            else
                self.page_comp.Status.Text = "Failed to ban " .. self.user_input.Username.Text .. "!";
            end
        else
            self.page_comp.Status.Text = "You need to enter a valid field!";
        end

        self.page_comp.Status.Visible = true;

        task.delay(1, function()
            self.page_comp.Status.Visible = false;
        end)
    end)
end

function page:onFocusLost(...)
    if self.user_input.Reason.Text ~= "" then
        local filtered_res = Remotes.Filter:InvokeServer(self.page_comp.User.Reason.Text);

        if filtered_res then
            self.user_input.Reason.Text = filtered_res;
        else
            self.user_input.Reason.Text = "Failed to filter";
        end
    end
end

--||

return page;
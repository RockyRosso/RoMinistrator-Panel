--|| Variables

local page = {};
page.__index = page;

local ReplicatedStorage = game.ReplicatedStorage;
local Remotes = ReplicatedStorage:WaitForChild("RoMini_Remotes");

--||

--|| Module Functions

function page.new(data)
    local self = setmetatable({}, page);

    self.page_comp = data.page;

    self.unban_btn = self.page_comp.Unban;
    self.status = self.page_comp.Status;
    self.userid = self.page_comp.User.UserID;

    self.unban_btn.MouseButton1Click:Connect(function() self:unban() end);
end

function page:unban()
    if self.userid.Text ~= "" then
        local unbanned = Remotes.Unban:InvokeServer(tonumber(self.userid.Text));

        if unbanned then
            self.status.Text = "Successfully unbanned user: " .. self.userid.Text .. "!";
        else
            self.status.Text = "Failed to unban user: " .. self.userid.Text .. "!";
        end

        self.status.Visible = true;

        task.delay(1, function()
            self.status.Visible = false;
        end)
    end
end

--||

return page;
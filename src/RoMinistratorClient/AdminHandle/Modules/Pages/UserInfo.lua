--|| Variables

local page = {};
page.__index = page;

local ReplicatedStorage = game.ReplicatedStorage;
local Remotes = ReplicatedStorage:WaitForChild("RoMini_Remotes");

local debounce = false;

--||

--|| Module Functions

function page.new(data)
    local self = setmetatable({}, page);

    self.page_comp = data.page;
    
    self.get_info = self.page_comp.GetInfo;
    self.username = self.page_comp.User.Username;

    self.userinfo_comp = script.Parent.Parent.Parent.Parent.Panel.Main.UserInfo;

    self.get_info.MouseButton1Click:Connect(function() self:MouseButton1Click() end);
end

function page:MouseButton1Click()
    if not debounce then
        if self.username.Text ~= "" then
            debounce = true;

            self.get_info.Text = "Retrieving Info...";

            local user_info = Remotes.GetUser:InvokeServer(self.username.Text);
            local bans = Remotes.GetBans:InvokeServer();
            local is_banned = false;

            for _, plr in pairs(bans) do
                if plr.userid == user_info.id then
                    is_banned = true;
                end
            end
    
            if user_info then
                local user_stats = self.userinfo_comp.User.Info.UserStats;
    
                user_stats.ID.Value.Text = tostring(user_info.id);
                user_stats.Username.Value.Text = user_info.name;
                user_stats.Owner.Value.Text = tostring(user_info.owner);
                user_stats.PermLevel.Value.Text = user_info.perm_level;
                user_stats.Banned.Value.Text = tostring(is_banned);
    
                local user_thumb = game.Players:GetUserThumbnailAsync(
                    user_info.id,
                    Enum.ThumbnailType.AvatarBust,
                    Enum.ThumbnailSize.Size100x100
                );
    
                self.userinfo_comp.User.Info.PFP.Image = user_thumb;
                self.userinfo_comp.User.Info.PFP.Size = UDim2.new(0, 100, 0, 100);
    
                self.userinfo_comp.Visible = true;
    
                self.userinfo_comp.User.Close.MouseButton1Click:Connect(function()
                    self.userinfo_comp.Visible = false;
                end)
            end

            self.get_info.Text = "Get Info";
            debounce = false;
        end
    end
end

--||

return page;
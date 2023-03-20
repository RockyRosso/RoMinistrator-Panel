--|| Variables

local page = {};
page.__index = page;

local ReplicatedStorage = game.ReplicatedStorage;
local Remotes = ReplicatedStorage.RoMini_Remotes;

local debounce = false;

--||

--|| Module Functions

function page.new(data)
    local self = setmetatable({}, page);

    self.page_comp = data.page;

    self.list = self.page_comp.List;
    self.user = self.page_comp.User;
    self.loading = self.page_comp.Loading;

    self:load();

    return self;
end

function page:load()
    self.user.Visible = false;

    if not debounce then
        debounce = true;

        self.loading.Visible = true;

        local bans = Remotes.GetBans:InvokeServer();

        if bans then
            for _, comp in pairs(self.list:GetChildren()) do
                if comp:IsA("TextButton") then
                    comp:Destroy();
                end
            end

            for i, ban in pairs(bans) do
                local comp = self.list.Component["0"]:Clone();
                comp.Name = tostring(i);

                local name = game.Players:GetNameFromUserIdAsync(ban.userid);

                comp:SetAttribute("UserID", ban.userid);
                comp:SetAttribute("Name", name)
                comp:SetAttribute("Reason", ban.reason);

                comp.Text = name;

                comp.Visible = true;

                comp.Parent = self.list;
            end

            self:listen();
        end
    end

    self.loading.Visible = false;
    debounce = false;
end

-- Listen for button input

function page:listen()
    for _, ban_comp in pairs(self.list:GetChildren()) do
        if ban_comp:IsA("TextButton") then
            ban_comp.MouseButton1Click:Connect(function()
                local thumbnail = game.Players:GetUserThumbnailAsync(
                    ban_comp:GetAttribute("UserID"),
                    Enum.ThumbnailType.HeadShot,
                    Enum.ThumbnailSize.Size100x100
                );

                self.user.PFP.Image = thumbnail;
                self.user.PFP.Size = UDim2.new(1, 0, 0, 100);

                self.user.Username.Text = ban_comp:GetAttribute("Name");
                self.user.Reason.Text = ban_comp:GetAttribute("Reason");

                self.user.Visible = true;

                local btn_debounce = false;

                self.user.Options.Unban.MouseButton1Click:Connect(function()
                    if not btn_debounce then
                        btn_debounce = true;

                        self.user.Options.Unban.Text = "Unbanning " .. ban_comp:GetAttribute("Name") .. "...";

                        local unbanned = Remotes.Unban:InvokeServer(ban_comp:GetAttribute("UserID"));

                        if unbanned then
                            self.user.Status.Text = "Successfully unbanned " .. ban_comp:GetAttribute("Name") .. "!";
                        else
                            self.user.Status.Text = "Failed to unban " .. ban_comp:GetAttribute("Name") .. "!";
                        end

                        self.user.Status.Visible = true;

                        task.delay(1, function()
                            self.user.Status.Visible = false;
                            self:load();
                        end)

                        self.user.Options.Unban.Text = "Unban";

                        btn_debounce = false;
                    end
                end)
            end)
        end
    end
end

--||

return page;
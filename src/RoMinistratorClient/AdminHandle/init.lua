--|| Variables

local admin = {};
admin.__index = admin;

--||

--|| Module Functions

function admin.new(user_data: table)
    _G.pages_list = script.Parent.Panel.Main.Pages;
    _G.page = script.Parent.Panel.Main.Page;

    local self = setmetatable({}, admin);

    self.pages = require(script.pages);

    self.user_data = user_data;
    self.user_id = self.user_data.id;
    self.user_name = self.user_data.name;
    self.user_perm = self.user_data.perm_level;

    self.info_page = script.Parent.Panel.Main.Profile.Main;

    self:load();
    script.Handle.Enabled = true;

    script.Parent.Toggle.MouseButton1Click:Connect(function()
        if not script.Parent.Panel.Visible then
            script.Parent.Panel.Visible = true;

            script.Parent.Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            script.Parent.Toggle.TextColor3 = Color3.fromRGB(0, 0, 0);
        else
            script.Parent.Panel.Visible = false;

            script.Parent.Toggle.BackgroundColor3 = Color3.fromRGB(27, 27, 27);
            script.Parent.Toggle.TextColor3 = Color3.fromRGB(255, 255, 255);
        end
    end)

    return self;
end

function admin:load()
    local page_btns = script.Parent.Panel.Main.Pages.Main;

    for i, page in pairs(self.pages) do
        local page_btn = Instance.new("TextButton");

        page_btn.Name = tostring(i);
        page_btn.BackgroundColor3 = Color3.fromRGB(36, 36, 36);
        page_btn.Size = UDim2.new(1, 0, -0.033, 50);
        page_btn.FontFace = Font.fromEnum(Enum.Font.Gotham);
        page_btn.Text = page;
        page_btn.TextColor3 = Color3.fromRGB(255, 255, 255);
        page_btn.TextScaled = true;
        page_btn:SetAttribute("Page", page:gsub(" ", ""));
        
        page_btn.Parent = page_btns;

        local page_btn_radius = Instance.new("UICorner");
        page_btn_radius.CornerRadius = UDim.new(0.1, 0);
        page_btn_radius.Parent = page_btn;
    end

    self:load_info();
end

function admin:load_info()
    local info = self.info_page.Info;

    local thumbnail = game.Players:GetUserThumbnailAsync(
        self.user_id,
        Enum.ThumbnailType.HeadShot,
        Enum.ThumbnailSize.Size150x150
    );

    self.info_page.PFP.Image = thumbnail;
    self.info_page.PFP.Size = UDim2.new(1, 0, 0, 145);

    info.ID.Text = "<b>ID:</b> " .. self.user_id;
    info.Username.Text = "<b>Name:</b> " .. self.user_name;
    info.Perm.Text = "<b>Permission:</b> " .. self.user_perm;
end

--||

return admin;
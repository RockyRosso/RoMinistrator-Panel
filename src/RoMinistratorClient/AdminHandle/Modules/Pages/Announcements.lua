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
    self.announce = self.page_comp.Announce;
    self.loading = self.page_comp.Loading;

    self:load();
end

function page:load()
    if not debounce then
        debounce = true;

        self.loading.Visible = true;

        local announces = Remotes.GetAnnouncements:InvokeServer();

        if announces then
            for _, comp in pairs(self.list:GetChildren()) do
                if comp:IsA("TextButton") then
                    comp:Destroy();
                end
            end

            for i, announce in pairs(announces) do
                local comp = self.list.Component["0"]:Clone();
                comp.Name = tostring(i);

                comp:SetAttribute("Title", announce.title);
                comp:SetAttribute("Content", announce.content);
                
                comp.Text = announce.title;

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
    for _, announce_comp in pairs(self.list:GetChildren()) do
        if announce_comp:IsA("TextButton") then
            announce_comp.MouseButton1Click:Connect(function()
                self.announce.Title.Text = announce_comp:GetAttribute("Title");
                self.announce.Content.Text = announce_comp:GetAttribute("Content");

                self.announce.Visible = true;
            end)
        end
    end
end

--||

return page;
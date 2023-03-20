--|| Variables

local PageLogic = {};

local pages_list = script.Parent.Parent.Parent.Panel.Main.Pages.Main;
local pages = script.Parent.Parent.Parent.Parent.Admin.Panel.Main.Page.Main.Comps;
local page = script.Parent.Parent.Parent.Parent.Admin.Panel.Main.Page.Main;

--||

--|| Functions

local function fade(inst: GuiButton, type: string)
    local TS = game:GetService("TweenService");

    local fade_types = {
        ["out"] = Color3.fromRGB(36, 36, 36),
        ["in"] = Color3.fromRGB(66, 66, 66)
    }

    local tweenInfo = TweenInfo.new(
        0.2,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    );

    local fade_tween = TS:Create(inst, tweenInfo, { BackgroundColor3 = fade_types[type] });
    fade_tween:Play();
end

local function list_listener()
    for _, obj in ipairs(pages_list:GetChildren()) do
        if obj:IsA("TextButton") then
            local btn = obj;

            btn.MouseButton1Click:Connect(function()
                for _, b in pairs(pages_list:GetChildren()) do
                    if b:IsA("TextButton") then
                        fade(b, "out");
                    end
                end

                local curr_page = page:FindFirstChildOfClass("Frame")

                if curr_page ~= nil then
                    curr_page:Destroy();
                end
                
                for _, pgs in ipairs(pages:GetChildren()) do
                    if btn:GetAttribute("Page") == pgs.Name then
                        local sel_page = pgs:Clone();
                        sel_page.Parent = page;
                        sel_page.Visible = true;

                        local pages_mod = require(script.Parent.Pages[pgs.Name]);
                        pages_mod.new({ page = sel_page });

                        fade(btn, "in");
                    end
                end
            end)
        end
    end
end

--||

--|| Module Functions

function PageLogic:init()
    list_listener();
end

--||

return PageLogic;
--|| Variables

local c_netoworking = {};

local ReplicatedStorage = game.ReplicatedStorage;
local Remotes = ReplicatedStorage:WaitForChild("RoMini_Remotes");


--||

--|| Get Remotes

for _, rEvent in pairs(Remotes:GetChildren()) do
    if rEvent:IsA("RemoteEvent") then
        print(rEvent.Name);
        rEvent.OnClientEvent:Connect(function(arg, ...)
            local args = {...};

            if rEvent.Name == "MemberAnnounce" then
                local content = arg;
                local con = nil;
                
                local announce_banner = script.Parent.Parent.Announce

                announce_banner.Content.Text = content;

                announce_banner.Visible = true;
                announce_banner:TweenPosition(
                    UDim2.new(0.5, 0, 0, 0),
                    Enum.EasingDirection.Out,
                    Enum.EasingStyle.Linear,
                    0.2
                );

                task.delay(2, function()
                    if con then
                        announce_banner:TweenPosition(
                            UDim2.new(0.5, 0, -0.5, 0),
                            Enum.EasingDirection.Out,
                            Enum.EasingStyle.Linear,
                            0.2,
                            false,

                            function()
                                announce_banner.Visible = false;
                            end
                        );
                    end
                end)

                con = announce_banner.Dismiss.MouseButton1Click:Connect(function()
                    announce_banner:TweenPosition(
                        UDim2.new(0.5, 0, -0.5, 0),
                        Enum.EasingDirection.Out,
                        Enum.EasingStyle.Linear,
                        0.2,
                        false,

                        function()
                            announce_banner.Visible = false;
                        end
                    );

                    con:Disconnect();
                end)
            end
        end)
    end
end

--||

return c_netoworking;
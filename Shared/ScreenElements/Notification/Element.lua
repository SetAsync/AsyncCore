local Element = {}
local TweenService = game:GetService("TweenService")

local DefaultContent = {
	Title = "Notification..";
	Content = "Everything is working as it should, this is a default notification.";
	Time = 5;
}

function Element.Init(Frame, Payload)
	--> Apply payload to default.
	for i,v in pairs(Payload) do
		DefaultContent[i] = v;
	end
	
	--> Render
	Frame.Title.Text = DefaultContent.Title
	Frame.Content.Text = DefaultContent.Content
	Frame.Position = UDim2.new(0.698, 0, 1, 0)
	Frame.Visible = true
	
	TweenService:Create(Frame, TweenInfo.new(1, Enum.EasingStyle.Back), {
		Position = UDim2.new(0.698, 0,0.815, 0)
	}):Play()
	task.wait(1+DefaultContent.Time)
	Frame:Destroy()
	
end

return Element
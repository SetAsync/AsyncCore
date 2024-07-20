local Element = {}
local TweenService = game:GetService("TweenService")

local DefaultContent = {
	Title = "Statistics..";
	ButtonText = "Close";
	Statistics = {"No Statistics"}
}

function Element.Init(Frame, Payload)
	--> Apply payload to default.
	for i,v in pairs(Payload) do
		DefaultContent[i] = v;
	end
	
	--> Render
	Frame.Title.Text = DefaultContent.Title;
	Frame.Close.Text = DefaultContent.ButtonText;
	Frame.Position = UDim2.new(0.31, 0, 1, 0);
	Frame.Visible = true;
	
	-- > Render Statistics
	local StatsFrame = Frame.Statistics.StatsFrame
	local StatExample = StatsFrame.Stat
	
	local StatSizePerPage = StatExample.AbsoluteSize.Y
	StatExample.Size = UDim2.new(1, 0, 0, StatSizePerPage)
	
	local FramePages = math.ceil(#DefaultContent.Statistics / 10)
	StatsFrame.CanvasSize = UDim2.new(0, 0, FramePages, 0)
	for _,v in ipairs(DefaultContent.Statistics) do
		local NewStat = StatExample:Clone()
		NewStat.Parent = StatsFrame
		if type(v) == "table" then
			for statPropertyName, statPropertyValue in pairs(v) do
				NewStat[statPropertyName] = statPropertyValue;
			end
		else
			NewStat.Text = v
		end

	end
	StatExample:Destroy()
	
	TweenService:Create(Frame, TweenInfo.new(1, Enum.EasingStyle.Back), {
		Position = UDim2.new(0.31, 0,0.088, 0);
	}):Play()
	task.wait(1)
	Frame.Statistics.StatsFrame.ScrollingEnabled = true
	
	local Connection
	Connection = Frame.Close.Activated:Connect(function()
		Frame:Destroy()
	end)
	
end

return Element
local Element = {}
local TweenService = game:GetService("TweenService")

function SecondsMinutesHours(Seconds)
	local Minutes = math.floor(Seconds / 60)
	Seconds = Seconds - (Minutes * 60)
	local Hours = math.floor(Minutes / 60)
	Minutes = Minutes - (Hours * 60)
	
	return Seconds, Minutes, Hours
end

function Element.Init(Frame, UnixTime)
	

	Frame.Visible = true
	
	while true do
		local TimeLeft = UnixTime - os.time()
		if TimeLeft <= 0 then
			Frame.BackgroundColor3 = Color3.new(255, 0, 0)
			Frame.Display.Text = "Countdown Over"
			wait(2)
			Frame:Destroy()
			return
		else
			local Seconds, Minutes, Hours = SecondsMinutesHours(TimeLeft)
			local DISPLAY = ""
			if Hours ~= 0 then
				DISPLAY = Hours.."H "
			end
			if Minutes ~= 0 then
				DISPLAY = DISPLAY..Minutes.."M "
			end

			DISPLAY = DISPLAY..Seconds.."S"
			Frame.Display.Text = DISPLAY
		end
		wait(1)
	end
	
end

return Element
// ThreeD, a 3d text thingamabob for Garry's Mod
// By Sergiusz Baza�ski, a.k.a. q3k.
// This code is released under the do-whatever-you-want-but-don't-be-a-douche license.
// www.q3k.org, 2010

TOOL.Category = "Render"
TOOL.Name = "ThreeD Text"
TOOL.Command = nil
TOOL.ConfigName = ""

TOOL.ClientConVar["text"] = "Some Stupid Text"
TOOL.ClientConVar["size"] = "10"

if CLIENT then
	language.Add("Tool_threed_name", "ThreeD Text Tool")
	language.Add("Tool_threed_desc", "Places a 3D text at the hit position.")
	language.Add("Tool_threed_0", "Primary: Place text. Secondary: Remove text near hit position.")
end

function TOOL:LeftClick(Trace)
	if CLIENT then return end
	
	local Text = self:GetClientInfo("text")
	local Size = self:GetClientNumber("size")
	
	local Position = Trace.HitPos + (Trace.HitNormal * 2)
	local Angles = Trace.HitNormal:Angle()
	
	Angles:RotateAroundAxis(Angles:Forward(), 90);
	Angles:RotateAroundAxis(Angles:Right(), 270);
	
	threed.AddText(Text, Position, Angles, Size)
	
	return true
end

function TOOL:RightClick(Trace)
	if CLIENT then return end
	
	local Position = Trace.HitPos
	
	for Index, Item in pairs(threed.Stored) do
		if Item.Position:Distance(Position) < 200 then
			threed.RemoveText(Index)
			return true
		end
	end
	
	return false
end

function TOOL.BuildCPanel(Panel)
	Panel:AddControl("Header", {Text = "ThreeD Text", Description = "Allows you to place 3D text in-game"})
	
	Panel:AddControl("TextBox", {
		Label = "Text",
		Command = "threed_text",
		MaxLength = "200"
	})
	
	Panel:AddControl("Slider", {
		Label = "Text Size",
		Command = "threed_size",
		Type = "Float",
		Min = 1,
		Max = 50
	})
end
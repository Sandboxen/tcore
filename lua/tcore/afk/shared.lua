do
	local META = FindMetaTable("Player")

	function META:IsAFK()
		return self:GetNWFloat("afk") > 0
	end

	function META:GetAFKTime()
		return CurTime() - self:GetNWFloat("afk")
	end
end

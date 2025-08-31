
--[[ Infinite random bag scripted by Skor. Place any number of various objects into the bag, and you will draw 
        a random one of the objects every time. Each time you take an object out of the bag, it will be cloned and replaced
        so it's possible to draw the same object again. --]]

--[[ If an object is removed from this container, clone the object and put the clone into the container --]]



function onObjectLeaveContainer(container, object)
    if container == self then 
		local clone = object.clone({['position'] = {self.getPosition().x, self.getPosition().y + 2, self.getPosition().z} })
		self.putObject(clone)
--		self._cloneToSetup  = clone
--		self._storedName  = self.getName()
--        startLuaCoroutine(self, "delayedCoroutine")
--        startLuaCoroutine(self, function() return delayedCoroutine(object, self.getName()) end)
		delayedCoroutine(object, self.getName())
    end
end

--[[ Wait three frames to allow the clone time to spawn and enter the container, then shuffle the container.
        If issues arise where you keep drawing the same object (if you have a ridiculously high framerate), try increasing the 3
        in the for loop to a higher number. --]]

function waitCoroutine()
	    
end

function delayedCoroutine(clone, name)
	function getScryfallCommand()
		for i = 1, 5 do
        coroutine.yield(0)
    	end
		
		local r = -1

	    local id = name

		if #id > 1 then
	--[[
	filter for multiple colored decks (example: White & Red)
	this has multicolored cards
	Card types: 
	0. Instant
	1. Creatures
	2. Sorcery
	3. Enchantments
	4. Land
	5. Planeswalker
	6. Artifact 
	7. Mono colors
	8. Multi colors
	]]
		r = math.random(0,8)
		elseif #id == 1 then
	--[[
	filter for single colored decks (example: White)
	this has NO multicolored cards
	Card types: 
	0. Instant
	1. Creatures
	2. Sorcery
	3. Enchantments
	4. Land
	5. Planeswalker
	6. Artifact 
	7. Mono colors
	]]
		r = math.random(0,7)
		end

		local scryfallCommand = "Scryfall random ?q=f:commander+year>=2003-10-02"
		--id:" .. id .. "+year>=2003-10-02+f:commander+"
		local cardType = ""
		local cardAmount = " 5"
        local cardTypeName = ""
		local idType = "+id:" .. id

	    print("Random=" .. r)

		if r == -1 then print("Error du doedel") end

		if r == 0 then -- Filter Instant
			cardType = "+t:instant"
            cardTypeName = " Type: Instant"
			elseif r == 1 then -- Filter Creatures
			cardType = "+t:creature"	
            cardTypeName = " Type: Creature"	
			elseif r == 2 then -- Filter Sorcery
			cardType = "+t:sorcery"		
            cardTypeName = " Type: Sorcery"
			elseif r == 3 then -- Filter Enchantments
			cardType = "+t:enchantment"		
            cardTypeName = " Type: Enchantment"
			elseif r == 4 then -- Filter Land
			cardType = "+t:land"		
            cardTypeName = " Type: Land"
			elseif r == 5 then -- Filter Planeswalker
			cardType = "+t:planeswalker"
            cardTypeName = " Type: Planeswalker"
			cardAmount = " 1"		
			elseif r == 6 then -- Filter Artifact
			cardType = "+t:artifact"
            cardTypeName = " Type: Artifact"
			elseif r == 7 then -- Filter Mono Color
			idType = "+(id:" .. id .. "+-c:m)"		
            cardTypeName = " Type: Monocolor"
			elseif r == 8 then -- Filter Multi Color
			idType = "+(id:" .. id .. "+c:m)"
            cardTypeName = " Type: Multicolor"
		end

		if #cardType == 0 then 
	        scryfallCommand = scryfallCommand .. idType .. cardAmount
		else 
	        scryfallCommand = scryfallCommand .. cardType .. idType .. cardAmount
		end

		print(scryfallCommand)

		clone.setDescription(scryfallCommand)
		clone.setName(name .. cardTypeName)
		
		return 1
	--    self._cloneToSetup.setDescription(scryfallCommand)
	--	self._cloneToSetup.setName(name)
	end
startLuaCoroutine(self, "getScryfallCommand")
end
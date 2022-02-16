
-[Encyclopedia.lua]------------------------
	This is a framework, created by 'foshes'. This is what powers most of my games. Feel free to
	use it, fork it, and do whatever you want with it. This is meant to be a community-driven framework. 
  Utilities will be added frequently, as voted by the community.
  
  Join the discussion: 
    https://discord.gg/STzsSyBRNB
	
How to use:

[SERVER]:

	[INITIALIZE]: -- some Script
		local Encyclopedia = require(script.Encyclopedia)

	[OTHER SCRIPTS]:
		local Encyclopedia = _G.Encyclopedia

[CLIENT]:

	[INITIALIZE]: -- some LocalScript
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local Encyclopedia = require(ReplicatedStorage.Encyclopedia)

	[OTHER SCRIPTS]:
		local Encyclopedia = _G.Encyclopedia 

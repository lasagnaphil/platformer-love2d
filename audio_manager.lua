local AudioManager = class('AudioManager')

function AudioManager:initialize()
	self.sounds = {}
	self.sounds["gun"] = love.audio.newSource("sounds/EFX EXT .38 Plus Power Shots 04 B.wav")
end

function AudioManager:setPosition(soundName, x, y, z)
	self.sounds[soundName]:setPosition(x, y, z)
end

function AudioManager:play(soundName)
	self.sounds[soundName]:play()
end

function AudioManager:pause(soundName)
	self.sounds[soundName]:pause()
end

function AudioManager:stop(soundName)
	self.sounds[soundName]:stop()
end

function AudioManager:resume(soundName)
	self.sounds[soundName]:resume()
end

function AudioManager:rewind(soundName)
	self.sounds[soundName]:rewind()
end

function AudioManager:setVolume(soundName,volume)
	self.sounds[soundName]:setVolume()
end
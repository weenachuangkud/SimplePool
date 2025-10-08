--!strict

--[[
- Auth : Mawin CK
- Date : Saturday, October 4, 2568 BE
- Dependencies: Requires Signal (event handling) ModuleScripts.
]]
-- suck my penis
-- i like sonic feets

--[[
SimplePool: A ModuleScript Library
- A simple, easy-to-use, statically typed, object pool for reusing Roblox Instances, reducing instantiation overhead.
- Features:
  - Statically typed with Luau type annotations for type safety.
  - Simple API: `new`, `GetObject`, `ReturnObject`, `Prewarm`.
  - Signals (`OnGetObject`, `OnReturnObject`) for event-driven programming.
]]

-- Services
local Rep = game:GetService("ReplicatedStorage")

-- Modules
local Modules = Rep:WaitForChild("Modules")
local Libraries = Modules:WaitForChild("Libraries")

-- Requires
local Signal = require(Libraries.Packet.Signal)

-- Types
--type Pool = {Instance} -- who tf put this

-- Def
export type ObjectPool = {
	Type: "SimplePool",
	Pool: {Instance},
	GetObject: (self: ObjectPool) -> Instance?,
	ReturnObject: (self: ObjectPool, obj: Instance) -> (),
	Prewarm: (self: ObjectPool, amount: number) -> (),
	Clear : (self: ObjectPool) -> (),
	template: Instance,
	OnGetObject: Signal.Signal, -- Def: <A... = ()>
	OnReturnObject: Signal.Signal -- Def: <A... = ()>
}

-- SimplePool 
local SimplePool = {}
SimplePool.__index = SimplePool

function SimplePool.new(template: Instance)
	local self = (setmetatable({}, SimplePool) :: any) :: ObjectPool
	self.Type = "SimplePool"
	self.Pool = {}
	self.template = template
	self.OnGetObject = Signal() 
	self.OnReturnObject = Signal()
	return self
end

function SimplePool:GetObject(): Instance?
	local obj
	if #self.Pool > 0 then
		obj = table.remove(self.Pool)
		self.OnGetObject:Fire(obj)
	else
		-- If pool is empty, create a new object from template
		if self.template then
			obj = self.template:Clone()
			self.OnGetObject:Fire(obj)
		else
			warn("No template available to create new object")
		end
	end
	return obj
end

function SimplePool:ReturnObject(obj: Instance)
	if typeof(obj) ~= "Instance" then
		warn("Attempted to return non-Instance object to pool")
		return
	end
	table.insert(self.Pool, obj)
	self.OnReturnObject:Fire(obj)
end

function SimplePool:Prewarm(amount: number)
	if not self.template then
		warn("Cannot prewarm pool: template is nil")
		return
	end
	for i = 1, amount do
		table.insert(self.Pool, self.template:Clone())
	end
end

function SimplePool:Clear()
	for _, v : Instance in self.Pool do
		v:Destroy()
	end
	self.Pool = {}
end

return SimplePool

-- you know what 
--- im tired of this shit

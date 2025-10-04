--!strict

--[[
- Auth : Mawin CK
- Date : Saturday, October 4, 2568 BE
- Dependencies: Requires Mutex (thread-safe mutex) and Signal (event handling) ModuleScripts.
]]

--[[
SimplePool: A ModuleScript Library
- A simple, easy-to-use, statically typed, and thread-safe object pool for reusing Roblox Instances, reducing instantiation overhead.
- Thread safety is ensured using the Mutex library, allowing safe access in multi-coroutine environments.
- Features:
  - Statically typed with Luau type annotations for type safety.
  - Thread-safe operations via Mutex for GetObject and ReturnObject.
  - Simple API: `new`, `GetObject`, `ReturnObject`, `Prewarm`.
  - Signals (`OnGetObject`, `OnReturnObject`) for event-driven programming.
]]

--[[NOTE : YOU CAN COMMENT OUT MUTEX IF YOU DONT LIKE IT
is true that roblox lua are single-thread but not always
Mutex exist in this shitty code bc i dont want a race condition
so i put ts lmao
]]
-- Requires
local Signal = require(PathTo.Packet.Signal)
local Mutex = require(PathTo.Mutex)

-- Types
type Pool = {Instance} -- who tf put this

-- Def
export type ObjectPool = {
	Type: "SimplePool",
	Pool: Pool,
	GetObject: (self: ObjectPool) -> Instance?,
	ReturnObject: (self: ObjectPool, obj: Instance) -> (),
	Prewarm: (self: ObjectPool, amount: number) -> (),
	template: Instance,
	Mutex: Mutex.Mutex, -- i like sonic feets
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
	self.Mutex = Mutex.new() 
	self.OnGetObject = Signal() 
	self.OnReturnObject = Signal()
	return self
end

function SimplePool:GetObject(): Instance?
	self.Mutex:lock()
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
	self.Mutex:unlock()
	return obj
end

function SimplePool:ReturnObject(obj: Instance)
	if not obj:IsA("Instance") then
		warn("Attempted to return non-Instance object to pool")
		return
	end
	self.Mutex:lock()
	table.insert(self.Pool, obj)
	self.OnReturnObject:Fire(obj)
	self.Mutex:unlock()
end

function SimplePool:Prewarm(amount: number)
	if not self.template then
		warn("Cannot prewarm pool: template is nil")
		return
	end
	-- wtf bro
	--self.Mutex:lock()
	for i = 1, amount do
		table.insert(self.Pool, self.template:Clone())
	end
	--self.Mutex:unlock()
end

return SimplePool

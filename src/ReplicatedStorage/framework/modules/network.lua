--!strict

--[[
	@network
	author: dane (dane1up)
	
	network module
	
	methods:
		one-way:
			- sendClient: sends from server-to-client
			- sendServer: sends from client-to-server
			- sendAll: sends from server to ALL clients
			- send: sends from server-to-server OR client-to-client
		
		two way:
			- getFromClient: receives client data on server
			- getFromServer: receives server data on client
			- get: receives client data from client OR server data from server
]]--

-- services
local Run = game:GetService("RunService")

-- settings
local WARNING = "[NETWORK ERROR] no scripts listening to command [%s]"

-- remotes
local remoteEvent = script.RemoteEvent
local remoteFunction = script.RemoteFunction
local bindableEvent = script.BindableEvent
local bindableFunction = script.BindableFunction

-- types
export type Listener = {command: string, callback: (any)->nil, stop: (Listener)->nil}

-- methods
local module = {}
local listeners: {Listener} = {}

module.add = function(commandName: string, func: (any)->nil): Listener
	local listener: Listener = {
		 command = commandName,
		 callback = func,
		 stop = function(self)
			local idx = table.find(listeners, self)
			if idx then
				table.remove(listeners, idx)
			end
		 end,
	}
	
	table.insert(listeners, listener)
	return listener
end

-- SEND methods
module.sendServer = function(command: string, ...)
	remoteEvent:FireServer(command, ...)
end

module.sendClient = function(player: Player, command: string, ...)
	remoteEvent:FireClient(player, command, ...)
end

module.sendAll = function(command: string, ...)
	remoteEvent:FireAllClients(command, ...)
end

module.send = function(command: string, ...)
	bindableEvent:Fire(command, ...)
end

-- GET methods
module.getFromServer = function(command: string, ...)
	return remoteFunction:InvokeServer(command, ...)
end

module.getFromClient = function(player: Player, command: string, ...)
	return remoteFunction:InvokeClient(player, command, ...)
end

module.get = function(command: string, ...)
	return bindableFunction:Invoke(command, ...)
end

-- RECEIVE methods (connections)
module._serverReceive = function(player: Player, command: string, ...)
	for idx: number, listener: Listener in listeners do
		if (listener.command ~= command) then continue end
		return listener.callback(player, ...)
	end
	
	warn(string.format(WARNING, command))
	return nil
end

module._clientReceive = function(command: string, ...)
	for idx: number, listener: Listener in listeners do
		if (listener.command ~= command) then continue end
		return listener.callback(...)
	end

	warn(string.format(WARNING, command))
	return nil
end

module._receive = function(command: string, ...)
	for idx: number, listener: Listener in listeners do
		if (listener.command ~= command) then continue end
		return listener.callback(...)
	end

	warn(string.format(WARNING, command))
	return nil
end

-- init
if Run:IsServer() then
	remoteEvent.OnServerEvent:Connect(module._serverReceive)
	remoteFunction.OnServerInvoke = module._serverReceive
	
	bindableEvent.Event:Connect(module._receive)
	bindableFunction.OnInvoke = module._receive
elseif Run:IsClient() then
	remoteEvent.OnClientEvent:Connect(module._clientReceive)
	remoteFunction.OnClientInvoke = module._clientReceive
	
	bindableEvent.Event:Connect(module._receive)
	bindableFunction.OnInvoke = module._receive
end

return module

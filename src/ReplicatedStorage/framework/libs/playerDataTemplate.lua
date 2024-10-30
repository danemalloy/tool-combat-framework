export type PlayerDataTemplate = {
	["cash"]: number,
	["kills"]: number,
	["aura"]: number,

	["activeMoveset"]: string,

	["ownedMovesets"]: {string},

	["ownedGamepasses"]: {number},
}

return {
	["cash"] = 0,
	["kills"] = 0,
	["aura"] = 0,
	
	["activeMoveset"] = "fists",
	
	["ownedMovesets"] = {
		"fists",
	},
	
	["ownedGamepasses"] = {},
}

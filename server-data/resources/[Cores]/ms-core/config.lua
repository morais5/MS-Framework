MSConfig = {}

MSConfig.MaxPlayers = GetConvarInt('sv_maxclients', 64) -- Gets max players from config file, default 32
MSConfig.IdentifierType = "steam" -- Set the identifier type (can be: steam, license)
MSConfig.DefaultSpawn = {x=-1035.71,y=-2731.87,z=12.86,a=0.0}

MSConfig.Money = {}
MSConfig.Money.MoneyTypes = {['cash'] = 1000, ['bank'] = 200000, ['crypto'] = 0 } -- ['type']=startamount - Add or remove money types for your server (for ex. ['blackmoney']=0), remember once added it will not be removed from the database!
MSConfig.Money.DontAllowMinus = {'cash', 'crypto'} -- Money that is not allowed going in minus

MSConfig.Player = {}
MSConfig.Player.MaxWeight = 120000 -- Max weight a player can carry (currently 120kg, written in grams)
MSConfig.Player.MaxInvSlots = 41 -- Max inventory slots for a player
MSConfig.Player.Bloodtypes = {
    "A+",
    "A-",
    "B+",
    "B-",
    "AB+",
    "AB-",
    "O+",
    "O-",
}

MSConfig.Server = {} -- General server config
MSConfig.Server.closed = false -- Set server closed (no one can join except people with ace permission 'msadmin.join')
MSConfig.Server.closedReason = "Can not get into the server.." -- Reason message to display when people can't join the server
MSConfig.Server.uptime = 0 -- Time the server has been up.
MSConfig.Server.whitelist = false -- Enable or disable whitelist on the server
MSConfig.Server.discord = "https://discord.io/moraisscripts" -- Discord invite link
MSConfig.Server.PermissionList = {} -- permission list

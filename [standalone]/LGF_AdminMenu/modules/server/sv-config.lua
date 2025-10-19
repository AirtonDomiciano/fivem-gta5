SvConfig = {}

-- Identify the players authorized to access the panel by their 'license'
-- The key is the player's unique identifier (license), and the value is 'true' to grant access.
-- You can add the player's license based on the framework you're using (e.g., ESX, QB, etc.).

SvConfig.AllowedPlayers = {
    ["license:09ad6e94d9c6dccfe2bb08bb1efa7d4823969fe6"] = true,
}

-- Switch using License directly

SvConfig.PanelPagesAllowed = {
    ["license:09ad6e94d9c6dccfe2bb08bb1efa7d4823969fe6"] = {
        ["dashboard"] = true,
        ["entitySpawner"] = true,
        ["executor"] = true,
        ["resourceManager"] = true,
        ["inventory"] = true,
        ["rapidAction"] = true,
        ["mapWorld"] = true,
        ["help"] = true,
    }
}



lib.versionCheck('ENT510/LGF_AdminMenu')

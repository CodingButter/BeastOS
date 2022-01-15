--[[
    TODO:
        Make this parse the application folder for applications
]] local Greed = require "src/applications/Greed"
local BulletinBoard = require "src/applications/BulletinBoard"
return {{
    application = BulletinBoard,
    title = "Bulletin"
}, {
    application = Greed,
    title = "Greed"
}}

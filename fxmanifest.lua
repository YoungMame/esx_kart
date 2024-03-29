fx_version 'cerulean'
game 'gta5'

client_scripts {
         ---RageUI----
         "src/RMenu.lua",
         "src/menu/RageUI.lua",
         "src/menu/Menu.lua",
         "src/menu/MenuController.lua",
         "src/components/*.lua",
         "src/menu/elements/*.lua",
         "src/menu/items/*.lua",
         "src/menu/panels/*.lua",
         "src/menu/windows/*.lua",
         
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}

shared_script 'config.lua'
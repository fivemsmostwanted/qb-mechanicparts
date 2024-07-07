fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

----ALL CREDITS TO ORIGINAL CREATOR.
author 'DrB1ackBeard'
description 'qb-mechanicparts for QBCore Created By DrB1ackBeard'
version '1.0.0'
--  LAST EDITED BY ANZDEVELOPMENTS 2/2/21

shared_script 'config.lua'

client_script 'client/main.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}
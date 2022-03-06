fx_version 'cerulean'
game 'gta5' 
lua54 'yes'
author 'Mahan#8183'
description 'JolbakLifeRP Vehicle Remote/Engine System With Metadata'
version '0.5'

shared_scripts{
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua'
} 


client_scripts{
    '@es_extended/locale.lua',
    'locales/*.lua',
    'client/main.lua'
} 

server_scripts{
    '@mysql-async/lib/MySQL.lua',
    '@es_extended/locale.lua',
    'locales/*.lua',
    'server/main.lua'
} 

dependencies {
    'ox_inventory',
    'es_extended'
}

ui_page "html/index.html"

files {
    'html/**'
}

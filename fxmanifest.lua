fx_version "cerulean"
game "gta5"

author "Alpha"
description "Alpha's Crafting Script"
version "1.0.0"

ui_page "ui/html/index.html"

shared_script "config.lua"

client_script "client/main.lua"

server_scripts {

	"@oxmysql/lib/MySQL.lua",
	"server/main.lua"

}

files {

	"ui/html/index.html",
	"ui/css/style.css",
	"ui/js/script.js",
	"assets/img/material/*.png",
	"assets/img/medical/*.png",
	"assets/img/misc/*.png",
	"assets/img/weapon/*.png",
	"assets/img/blueprint/*.png",
	"assets/sfx/*.wav"

}

lua54 "yes"

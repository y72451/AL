display.setStatusBar( display.HiddenStatusBar )

local composer = require ( "composer" )
centerY=display.contentHeight/2
centerX=display.contentWidth/2
-- load first screen
composer.gotoScene( "loadmainmenu" )
print( "main loaded" )
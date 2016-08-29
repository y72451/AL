local composer = require( "composer" )
local scene = composer.newScene()

local widget = require("widget")

function scene:create( event )
	composer.removeScene( "mainmenu" )
	local menuGroup = self.view

end

function gotomaing( event )
	-- body
	composer.gotoScene( "loadgame", "fade", 300 )
end

function gotobox( event )
	-- body
	composer.gotoScene( "loadbox" ,"fade",300 )
end

function scene:show( event )
	local menuGroup = self.view
	local demobtn=display.newText( menuGroup, "Demo", 640, 300,120,90, defaultfont, 30 )
	demobtn:addEventListener( "tap", gotomaing )
	local boxbtn=display.newText( menuGroup, "Box", 640, 500, 120,90, defaultfont, 30 )
	boxbtn:addEventListener( "tap", gotobox )
end


function scene:hide()

	print( "mainmenu: exitScene event" )
end
-- Called prior to the removal of scene's "view" (display group)
function scene:destroy( event )
	print( "((destroying mainmenu's view))" )
end

scene:addEventListener( "create", scene )

-- "show" event is dispatched whenever scene transition has finished
scene:addEventListener( "show", scene )

-- "hide" event is dispatched before next scene's transition begins
scene:addEventListener( "hide", scene )

-- "destroy" event is dispatched before view is unloaded, which can be
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene
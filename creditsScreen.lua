local composer = require( "composer" )
local scene = composer.newScene()
local backgroundImage

-- Called when the scene's view does not exist:
function scene:create( event )
	local screenGroup = self.view
	-- completely remove options
	composer.removeScene( "options" )
	print( "\ncreditsScreen: createScene event" )
end

-- Called immediately after scene has moved onscreen:
function scene:show( event )
	local screenGroup = self.view
	print( "creditsScreen: enterScene event" )
	backgroundImage = display.newImageRect( "creditsScreen.png", 1280, 720 )
	backgroundImage.x = 240; backgroundImage.y = 160
	screenGroup:insert( backgroundImage )

	local changeToOptions = function( event )
		if event.phase == "began" then
			composer.gotoScene( "options", "crossFade", 300 )
		end
	end
	backgroundImage:addEventListener( "touch", changeToOptions)
end
-- Called when scene is about to move offscreen:
function scene:hide()
	print( "creditsScreen: exitScene event" )
end
-- Called prior to the removal of scene's "view" (display group)
function scene:destroy( event )
	print( "((destroying creditsScreen's view))" )
end
-- "createScene" event is dispatched if scene's view does not exist

-- "create" event is dispatched if scene's view does not exist
scene:addEventListener( "create", scene )

-- "show" event is dispatched whenever scene transition has finished
scene:addEventListener( "show", scene )

-- "hide" event is dispatched before next scene's transition begins
scene:addEventListener( "hide", scene )

-- "destroy" event is dispatched before view is unloaded, which can be
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene
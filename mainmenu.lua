local composer = require( "composer" )
local scene = composer.newScene()

local widget = require("widget")

local btnAnim
local btnSound = audio.loadSound( "btnSound.wav" )




function printlocation(event)
	print("X:"..event.x.." Y:"..event.y)
end
-- Called when the scene's view does not exist:
function scene:create( event )
	local screenGroup = self.view
	-- completely remove maingame and options 
	composer.removeScene( "maing" )
	composer.removeScene( "options" )
	print( "\nmainmenu: createScene event" )

	local backgroundImage = display.newImageRect( "mainMenuBG.png", 1280, 720 )
	backgroundImage:addEventListener( "tap", printlocation )
	backgroundImage.x = display.contentWidth/2; backgroundImage.y = display.contentHeight/2
	screenGroup:insert( backgroundImage )
	local playBtn
	local onPlayTouch = function( event )
		if event.phase == "ended" then
			audio.play( btnSound )
			composer.gotoScene( "submenu", "fade", 300 )
		end
	end

	local plbOptions = {
	  defaultFile="playbtn.png",
	  overFile = "playbtn-over.png",
	  --onPress=onPlayTouch,
	  onEvent=onPlayTouch,
	  --width = 100,
	  --height = 100,
	}

	playBtn = widget.newButton(plbOptions)
	screenGroup:insert( playBtn )
	playBtn.x = 1000
	playBtn.y = 600  --off the screen
	
   local optBtn
   local onOptionsTouch = function( event )
		if event.phase == "ended" then
			audio.play( btnSound )
			composer.gotoScene( "options", "crossFade", 300 )
		end
	end

	local obOptions = {
	  defaultFile="optbtn.png",
	  overFile = "optbtn-over.png",
	  --onPress=onPauseTouch,
	  onEvent=onOptionsTouch,
	
	}

	optBtn = widget.newButton(obOptions)
	optBtn.x = 400; 
	optBtn.y = 600 --off the screen
	screenGroup:insert( optBtn )
end
-- Called immediately after scene has moved onscreen:
function scene:show( event )
	local screenGroup = self.view
	print( "mainmenu: enterScene event" )

	btnAnim = transition.to( playBtn, { time=500, y=260, transition=easing.inOutExpo } )

	btnAnim = transition.to( optBtn, { time=500, y=280, transition=easing.inOutExpo } )
end

-- Called when scene is about to move offscreen:
function scene:hide()
	if btnAnim then transition.cancel( btnAnim ); end
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
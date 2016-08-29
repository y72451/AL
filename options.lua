local composer = require( "composer" )
local scene = composer.newScene()

local screenGroup

local widget = require("widget")
local btnAnim
local btnSound = audio.loadSound( "btnSound.wav" )
local creditsBtn 

-- Called when the scene's view does not exist:
function scene:create( event )
	 screenGroup = self.view
	-- completely remove mainmenu and creditsScreen
	composer.removeScene( "mainmenu" )
	composer.removeScene( "creditsScreen" )
	print( "\noptions: createScene event" )

   local backgroundImage = display.newImageRect( "optionsBG.png", 1280, 720 )
   backgroundImage.x = display.contentWidth/2; 
   backgroundImage.y = display.contentHeight/2
   screenGroup:insert( backgroundImage )

	local onCreditsTouch = function( event )
		if event.phase == "ended" then
			audio.play( btnSound )
			composer.gotoScene( "creditsScreen", "crossFade", 300 )
		end
	end



	local onCloseTouch = function( event )
		if event.phase == "ended" then
			audio.play( tapSound )
			
			composer.gotoScene( "mainmenu", {effect="slideLeft", time=500})
		end
	end

	local clbOptions = {
     defaultFile="closebtn.png",
     overFile = "closebtn-over.png",
     onEvent=onCloseTouch,
     width = 270,
	 height = 130,
     
   }
	local closeBtn = widget.newButton(clbOptions)
	closeBtn.x = 650; 
	closeBtn.y = 650;
	screenGroup:insert( closeBtn ) 
	

end

-- Called immediately after scene has moved onscreen:
function scene:show( event )
	screenGroup = self.view
	print( "options: enterScene event" )

	
	btnAnim = transition.to( creditsBtn, { time=500, y=260, transition=easing.inOutExpo } ) 


	
end


-- Called when scene is about to move offscreen:
function scene:hide()
	if btnAnim then transition.cancel( btnAnim ); end
	print( "options: hide event" )
end
-- Called prior to the removal of scene's "view" (display group)
function scene:destroy( event )
	print( "((destroying options's view))" )
end

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

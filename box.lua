local composer = require( "composer" )
local scene = composer.newScene()

local widget = require("widget")

function scene:create( event )
	composer.removeScene( "loadbox" )
	local boxgroup = self.view
--	local demotext=display.newText( boxgroup, "put thing when you get in", 640, 360, defaultfont, 80 )
	local backgroundImage = display.newImageRect( "personalBG.png", 1280, 720 )
	backgroundImage:addEventListener( "tap", printlocation )
	backgroundImage.x = display.contentWidth/2; backgroundImage.y = display.contentHeight/2
	boxgroup:insert( backgroundImage )
	local mapBtn
	local vsBtn

-----前往地圖模式的按鈕

	local onMapTouch = function( event )
		if event.phase == "ended" then
			audio.play( btnSound )
			composer.gotoScene( "maing", "crossFade", 300 )
		end
	end

    local mapmodOptions = {
	  defaultFile="mapbtn.png",
	  --overFile = "optbtn-over.png",
	  --onPress=onPauseTouch,
	  onEvent=onMapTouch,
	}
	mapBtn = widget.newButton(mapmodOptions)
	boxgroup:insert( mapBtn )
	mapBtn.x = 230
	mapBtn.y = 170
	
-----前往對戰模式的按鈕
    local onVsTouch = function( event )
		if event.phase == "ended" then
			audio.play( btnSound )
			composer.gotoScene( "options", "crossFade", 300 )
		end
	end

    local vsmodOptions = {
	  defaultFile="vsbtn.png",
	  --overFile = "optbtn-over.png",
	  --onPress=onPauseTouch,
	  onEvent=onVsTouch,
	}
	vsBtn = widget.newButton(vsmodOptions)
	boxgroup:insert( vsBtn )
	vsBtn.x = 230
	vsBtn.y = 550 



end



function scene:show( event )

	btnAnim = transition.to( mapBtn, { time=500, y=260, transition=easing.inOutExpo } )
	btnAnim = transition.to( vsBtn, { time=500, y=260, transition=easing.inOutExpo } )

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
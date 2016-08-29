local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")



math.randomseed( os.time() )--亂數種子
function RandShuffle(deck)  
    -- 首先確認傳入的參數型態是 table  
    assert(type(deck) == "table");  
  
    -- 將 deck 的所有元素複製至暫用的 clone 中  
    local clone = {};  
    for k, v in pairs(deck) do  
        clone[k] = v;  
    end  
  
    -- 取得元素集合的大小  
    local range = table.maxn(deck);  
  
    -- 巡訪 deck 結構  
    for k, v in pairs(deck) do  
        -- 藉由亂數機制，決定要取出的 clone 索引值  
        local index = math.random(1, range);  
          
        -- 在 clone 中移除該元素，塞回原來的 deck 中  
        deck[k] = table.remove(clone, index);  
   
        -- 將亂數取值的範圍減1  
        range = range - 1;  
    end  
end  


function RandMultiDeck(t)  
    assert(type(t) == "table");--確認傳入的參數類型是table
  
    local pool = t;  
    local counter = table.maxn(t);  --測量table大小
  
    return function(num)  
        num = num or 1; --num=目前的值 或是(第一次的時候因為還沒有值) 1 
          
        if (num == 1) then  
            counter = counter + 1;  
              
            if (counter > table.maxn(pool)) then  
                RandShuffle(pool);  
                counter = 1;  
            end  
      
            return pool[counter];  
        else  
            if (counter + num > table.maxn(pool)) then  
                RandShuffle(pool);  
                counter = 1;  
            end  
      
            local result = {};  
            for index = counter, counter + num - 1 do  
                table.insert(result, pool[index]);  
            end  
  
            counter = counter + num;  
              
            return result;  
        end  
    end  
end  
 
require("CharCard.mon0001" )
require("CharCard.mon0002" )

--變數宣告
local isin=false
local menuScreenGroup
local mmScreen
local HelpscreenGroup
local Helpscreen
local firstgroup

local background
local CharacterBG_left
local CharacterBG_right
local background_bothsides

local okbtn
local timerbar
local gameEvent = "start"
local gamePhase
local phaseInfo
local alertDisplayGroup
local alertBox
local conditionDisplay
handcardmax=5
cpuhandcardmax=5
local turnCounter=0
local messageText
--戰鬥資料
totalatk=0
totaldef=0
totalmp=0

cputotalatk=0
cputotaldef=0
cputotalmp=0
local plynum=0
local cpunum=0
effcheck=0
local playerDmgText
local cpuDmgText
local playerHPText
local playerAtkText
local playerDefText
local playerMpText
local cpuHPText
local cpuAtkText
local cpuDefText
local cpuMpText
--玩家角色資料
player=nil
playerHp=0
local p1={}
local p2={}
local p3={}
local c1={}
local c2={}
local c3={}

    --Hp,Atk,Def,Mp,Effect,Skill,imagePath,code=3

--電腦角色資料
local cpuHP=15
local cpumon
function loading()--將卡片資料全數讀取
    p1=c0001
    table.insert(p1,code)
    p1.code=1
    print(p1.ImgPath)
    c1=c0002
    table.insert( c1,code )
    c1.code=2
    if p1.Hp~=nil then
        plynum=plynum+1
    end
    if p2.Hp~=nil then
        plynum=plynum+1
    end
    if p3.Hp~=nil then
        plynum=plynum+1
    end
    if c1.Hp~=nil then
        cpunum=cpunum+1
    end
    if c2.Hp~=nil then
        cpunum=cpunum+1
    end

    if c3.Hp~=nil then
        cpunum=cpunum+1
    end


    WhoFirst()
end
local FirstCheck
local playerFirst=true
local checkzone--EFF發動區
local effbtn
local SelectZone
local Selectgroup
local fakecard={}
local cpu
p_Deck={}--玩家實體手牌
c_Deck={}--電腦實體手牌
local wincounter=0
local isFincCalled=false
local playerHandCardGroup
local cpuHandCardGroup

local playerEffect=function()
    if effcheck>=13 then
        print("Effect achive")
        playerHp=playerHp+1
        if playerHP>=10 then
            playerHP=10
        end
    end
end
local playerSkill=function()
    local counter=0
    
    for i=1,handcardmax do
        if (p_Deck[i].Csymble=="Cup" and p_Deck[i].isOut==true) then
            counter=counter+1
        end
    end
    if (counter==0) then
        print("Skill Active")
        totalatk=totalatk+10
    end
end

--計時區域
local myTimer
local secNum=0
local timerInfo
local timerText="Time:"..secNum
local phaseTimer=function()--減去時間
    print("-1")
    secNum=secNum-1
    timerText="Time:"..secNum
    timerInfo.text=timerText
    if secNum<=0 then
        changePhase()
    end
end
--計時區結束
local GGSound = audio.loadSound( "GG.mp3" )--各種聲音
local winSound = audio.loadSound( "win.wav" )
local useSound = audio.loadSound( "use.wav" )
local  Arcana={"The Fool","The Magician","The High Priestess","The Empress","The Emperor","The Pope","The Lovers","The Chariot","The Justice","The Hermit","The Wheel of Fortune","Strength","The Hanged Man","Death","Temperance","The Devil","The Tower","The Star","The Moon","The Sun","Judgement","The World"}

p2={}--撲克牌排組
    for i=1,14 do--用巣狀迴圈塞入撲克資料
        for j=1,4 do
            if j==1 then
                table.insert( p2, i*j, {name="cardImage/Sword_"..i..".png",Csymble="Sword",numb=i,type=""} )
            elseif j==2 then
                table.insert( p2, i*j, {name="cardImage/Wands_"..i..".png",Csymble="Wands",numb=i,type=""} )
            elseif j==3 then
                table.insert( p2, i*j, {name="cardImage/Coin_"..i..".png",Csymble="Coin",numb=i,type=""} )
            elseif j==4 then
                table.insert( p2, i*j, {name="cardImage/Cup_"..i..".png",Csymble="Cup",numb=i,type=""} )
            end
            
        end
    end

    p2[1].type,p2[3].type,p2[4].type,p2[5].type,p2[9].type,p2[10].type,p2[12].type,p2[14].type,p2[20].type,p2[21].type,p2[22].type,p2[23].type,p2[32].type,p2[33].type,p2[35].type,p2[36].type,p2[40].type,p2[44].type,p2[45].type,p2[53].type,p2[56].type
    ="atk","atk","atk","atk","atk","atk","atk","atk","atk","atk","atk","atk","atk","atk","atk","atk","atk","atk","atk","atk","atk"
    p2[6].type,p2[7].type,p2[8].type,p2[11].type,p2[16].type,p2[17].type,p2[18].type,p2[19].type,p2[24].type,p2[26].type,p2[28].type,p2[37].type,p2[38].type,p2[41].type,p2[46].type,p2[47].type,p2[49].type,p2[50].type,p2[51].type,p2[52].type,p2[54].type
    ="def","def","def","def","def","def","def","def","def","def","def","def","def","def","def","def","def","def","def","def","def"
    p2[2].type,p2[13].type,p2[15].type,p2[25].type,p2[27].type,p2[29].type,p2[30].type,p2[31].type,p2[34].type,p2[39].type,p2[42].type,p2[43].type,p2[48].type,p2[55].type
    ="mp","mp","mp","mp","mp","mp","mp","mp","mp","mp","mp","mp","mp","mp"




function scene:create( event )
    -- body
        print("add")
    local gameGroup=self.view
    composer.removeScene( "loadgame" )


    --background=display.newImage( "background/background.png",1280,720)
    background = display.newImageRect( "background/background.png",723,720)
    background.x = display.contentWidth/2
    background.y = display.contentHeight/2
    gameGroup:insert(background)

    CharacterBG_left = display.newImageRect("background/CharacterBG_left.png",200,261)
    CharacterBG_left.x = 110
    CharacterBG_left.y = 540
    gameGroup:insert(CharacterBG_left)

    CharacterBG_right = display.newImageRect("background/CharacterBG_right.png",190,250)
    CharacterBG_right.x = 1110
    CharacterBG_right.y = 130
    gameGroup:insert(CharacterBG_right)


    --local gameGroup = self.view
    background_bothsides = display.newImageRect("background/background_bothsides.png",1280,720)
    background_bothsides.x = display.contentWidth/2; 
    background_bothsides.y = display.contentHeight/2
    gameGroup:insert(background_bothsides)
        

end

function scene:show( event)

    local gameGroup = self.view

function addGameScreen( )
    -- body
    --goBtn:removeEventListener("tap", addGameScreen)
    --menuScreenGroup:removeSelf( )
    --HelpscreenGroup:removeSelf( )
    alertScreen("Duel!", "start")
end

function WhoFirst()
    
    function Check( event )
        local isend=false
        local cpudo=math.random( 1,3 )

        local playerChose
        local cpuChose
        function clear()
            playerChose:removeSelf( )
            cpuChose:removeSelf( )
        end
        playerChose=display.newImage( "texture/f"..event.target.value..".png",-500,display.contentHeight/2)
        transition.to( playerChose, {time=1000,x=display.contentWidth/2-50,onComplete =clear} )
        cpuChose=display.newImage( "texture/f"..cpudo..".png",1300,display.contentHeight/2)
        transition.to( cpuChose, {time=1000,x=display.contentWidth/2+50,onComplete =clear} )
        if event.target.value==1 then
            if cpudo==1 then
                print("redone")
            elseif cpudo==2 then
                isend=true
                print("cpuwin")
                playerFirst=false
            elseif cpudo==3 then
                isend=true
                print("playerwin")
                playerFirst=true
            end
        
        elseif event.target.value==2 then
            if cpudo==1 then
                isend=true
                print("playerwin")
                playerFirst=true
            elseif cpudo==2 then
                print("redone")
            elseif cpudo==3 then
                isend=true
                print("cpuwin")
                playerFirst=false
            end
        
        elseif event.target.value==3 then
            if cpudo==1 then
                isend=true
                print("cpuwin")
                playerFirst=false
            elseif cpudo==2 then
                isend=true
                print("playerwin")
                playerFirst=true
            elseif cpudo==3 then
                
                print("redone")
            end
        end
        if isend==true then
            firstgroup:removeSelf( )
            firstgroup=nil
            timer.performWithDelay( 2000, game )
            
        end
    end

    FirstCheck=display.newRect( display.contentWidth/2, display.contentHeight/2, 400, 300 )
    FirstCheck:setFillColor( 10,0,0 )
    local a=display.newText( "Assault", display.contentWidth/2, display.contentHeight/2-50, defaultfont, 40 )
    a.value=1
    a:addEventListener( "tap", Check )
    local b=display.newText( "BLock", display.contentWidth/2, display.contentHeight/2, defaultfont, 40 )
    b.value=2
    b:addEventListener( "tap", Check )
    local c=display.newText( "Counter", display.contentWidth/2, display.contentHeight/2+50, defaultfont, 40 )
    c.value=3
    c:addEventListener( "tap", Check )
    firstgroup=display.newGroup( )
    firstgroup:insert( FirstCheck )
    firstgroup:insert( a )
    firstgroup:insert( b )
    firstgroup:insert( c )
end

function Draw()
    print("Drawing")
    print("PHP:"..playerHp)
    local drawLag=handcardmax*400--抽排時間差
    secNum=drawLag/1000+2
    gd2=RandMultiDeck(p2)--將原牌組洗好牌放進gd2裡面
    mc2=gd2(handcardmax)--把gd2的前3張牌發進mc2裡面
    cpu=gd2(handcardmax)--再發3張給cpu


    for i=1,handcardmax do
        
        table.insert( p_Deck, i, display.newImage( mc2[i].name,-300,display.contentHeight/2))--生成實體圖片卡牌然後放成排堆 
        p_Deck[i].value=mc2[i].numb
        p_Deck[i].xScale,p_Deck[i].yScale=0.2,0.2
        p_Deck[i].type=mc2[i].type
        p_Deck[i].Csymble=mc2[i].Csymble
        playerHandCardGroup:insert( p_Deck[i] )
        
    end

    for i=1,handcardmax do
        transition.to( p_Deck[i], {time=i*200,x=200+i*150,y=500} )--把牌從牌組移到
        p_Deck[i].isInEff=false
        p_Deck[i].isOut=false
        p_Deck[i].num=i
    end

    for i=1,handcardmax do--生成電腦假手牌，這些卡片實際上沒有數值
        fakecard[i]=display.newImage(  "BG.jpg",-300,display.contentHeight/2)
        fakecard[i].xScale,fakecard[i].yScale=0.15,0.1
        transition.to( fakecard[i], {time=i*200,x=200+i*150,y=40})
        cpuHandCardGroup:insert( fakecard[i] )
    end
    
end

function Selected(event )
    print(event.target.code)
        if event.target.code==1 then
            player=display.newImage( p1.ImgPath,-250,550 )
            playerHp=p1.Hp
            player.Atk=p1.Atk
            player.Def=p1.Def
            player.Mp=p1.Mp
            playerSkill=p1.Skill
            playerEffect=p1.Effect
        end
        gameGroup:insert(player)
        totalatk=totalatk+player.Atk
        totaldef=totaldef+player.Def
        totalmp=totalmp+player.Mp
        playerHPText.text=playerHp
        playerAtkText.text=player.Atk
        playerDefText.text=player.Def
        playerMpText.text=player.Mp
        Selectgroup:removeSelf( )
        Selectgroup=nil
        changePhase()
end

function save(pnum)
    print("saved")
    if pnum==1 then
        p1.Hp=playerHp
    end
    if pnum==2 then
        p2.Hp=playerHp
    end
    if pnum==3 then
        p3.Hp=playerHp
    end
end

function Select()
    if turnCounter>1 then
        print("save")
        save(player.code)
    end
    Selectgroup=display.newGroup( )
    SelectZone=display.newRect( display.contentWidth/2, display.contentHeight/2, 600, 200 )
    local m1=display.newImage( p1.ImgPath,display.contentWidth/2, display.contentHeight/2)
    m1.code=p1.code
    Selectgroup:insert(SelectZone)
    Selectgroup:insert(m1)
    m1:addEventListener( "tap", Selected )


end


function MainP( )--主要階段，將卡片放到checkzone來觸發=(主動技能)

    checkzone=display.newImage( "texture/checkzone.png",display.contentWidth/2,display.contentHeight/2+10 )
    --checkzone:toBack( )


    function efbtouch(event)
        changePhase()
    end

    local obOptions = {
      defaultFile="texture/effbtn.png",
      overFile = "texture/effbtn-over.png",
      --onPress=efbtouch,
      onEvent=efbtouch,
    }
    effbtn=widget.newButton(obOptions)
    effbtn.x,effbtn.y=display.contentWidth/2+195,display.contentHeight/2+10
    for i=1,handcardmax do
        p_Deck[i]:addEventListener("touch", outofcard )
    end
    playerHandCardGroup:toFront( )
end

function MainPEnd()
    if playerEffect~=nil then
        playerEffect()
    end
    effbtn:removeSelf( )
    effbtn=nil
    transition.to(checkzone,{time=500,x=-600})
    for i=1,handcardmax do
        if p_Deck[i].isInEff==true then
            p_Deck[i].isVisible=false
            transition.to(p_Deck[i],{time=600,x=-600})
        end
    end
end

function finc( )
    
        if isFincCalled==false then
            isFincCalled=true
            --okbtn:removeEventListener( "tap", changePhase )
            for i=1,handcardmax do
                if  p_Deck[i].isOut==true then--電腦出牌無腦版本
                    fakecard[i].isVisible=false
                    table.insert( c_Deck,i,display.newImage( cpu[i].name,200+i*150,200))
                    c_Deck[i].xScale,c_Deck[i].yScale=0.2,0.2
                    c_Deck[i].value=cpu[i].numb
                    c_Deck[i].type=cpu[i].type
                    if c_Deck[i].type=="atk" then
                        cputotalatk=cputotalatk+c_Deck[i].value
                    elseif c_Deck[i].type=="def" then
                        cputotaldef=cputotaldef+c_Deck[i].value
                    elseif c_Deck[i].type=="mp" then
                        cputotalmp=cputotalmp+c_Deck[i].value
                    end
                    cpuHandCardGroup:insert( c_Deck[i] )
                end
            end

        for i=1,handcardmax do                     
            p_Deck[i]:removeEventListener( "touch", outofcard )
        end
        print("cpu:".."ATK:"..cputotalatk.."   DEF:"..cputotaldef.."  MP:"..cputotalmp)
        if playerSkill~=nil then
            playerSkill()
        end
        local cpudmg=(totalatk-cputotaldef)
        if cpudmg<0 then
            cpudmg=0
        end
        local playerdmg=cputotalatk-totaldef
        if playerdmg<0 then
            playerdmg=0
        end
        cpuDmgText=display.newText( "", 1150,270, defaultfont, 50 )
        playerDmgText=display.newText( "",150,680, defaultfont, 50 )
        if playerFirst==true then
            cpuHP=cpuHP-cpudmg --玩家先攻，所以由玩家先輸出傷害

            print("You make "..cpudmg.." point damage to enemy")
            cpuDmgText.text="-"..cpudmg
            transition.to( cpuDmgText, {time=3000,alpha=0} )
            if cpuHP<1 then
                alertScreen("You Win","Good Job")--如果打死就贏了(
                audio.play( winSound )
                gameEvent="win"
            else
                playerHp=playerHp-playerdmg--如果敵人沒被打死，換敵人輸出傷害
                print("Enemy make "..playerdmg.." point damage to you")
                playerDmgText.text="-"..playerdmg
                transition.to( playerDmgText, {time=3000,alpha=0} )
            end
            if playerHp<1 then--如果被打死，則失敗
                plynum=plynum-1
                alertScreen("You Lose","Try Again")
                gameEvent="lose"
            elseif playerHp>0 and cpuHP>0 then
                alertScreen("No One Win","New Turn")--如果雙方都殘血，繼續下一回合
                gameEvent="Continue"--有別於過去「非輸即贏」的遊戲事件，不過似乎會在重新開始的時候產生錯誤
            end
        else
            playerHp=playerHp-playerdmg--敵人輸出傷害
            print("Enemy make "..playerdmg.." point damage to you")
            playerDmgText.text="-"..playerdmg
            transition.to( playerDmgText, {time=3000,alpha=0} )
            if playerHp<1 then--如果被打死，則失敗
                alertScreen("You Lose","Try Again")
                gameEvent="lose"
            else
                cpuHP=cpuHP-cpudmg --玩家先輸出傷害
                print("You make "..cpudmg.." point damage to enemy")
                cpuDmgText.text="-"..cpudmg
                transition.to( cpuDmgText, {time=3000,alpha=0} )
            end
            if cpuHP<1 then
                alertScreen("You Win","Good Job")--如果打死就贏了(
                audio.play( winSound )
                gameEvent="win"
            elseif playerHp>0 and cpuHP>0 then
                alertScreen("No One Win","New Turn")--如果雙方都殘血，繼續下一回合
                gameEvent="Continue"--有別於過去「非輸即贏」的遊戲事件，不過似乎會在重新開始的時候產生錯誤
            end
        end
    end
end

function EndP()
    --timer.cancel( myTimer )
    local ArcanaIndex=math.random( 1,22 )
    local ArcanaFace=math.random( )
    if ArcanaFace==1 then
        print("Good Side of"..Arcana[ArcanaIndex])
    else
        print("Evil Side of"..Arcana[ArcanaIndex])
    end
end


function game(  )
    --symble(標號) sute(花色)
    turnCounter=turnCounter+1

    if gameEvent=="restart" then
        playerHP=10
        cpuHP=15
    end
    timerbar=display.newRect( 500, 660, 1280*2, 60 )
    timerbar.fill={0,180,0}
    gameGroup:insert(timerbar)
    gamePhase="Start"
    phaseInfo=display.newText( "Phase:"..gamePhase ,  150, 50, defaultFont, 48)
    gameGroup:insert(phaseInfo)
    timerInfo=display.newText( timerText,  -270, 60, defaultFont, 24 )
    playerHandCardGroup=display.newGroup( )
    cpuHandCardGroup=display.newGroup( )
    player=display.newImage(   "chara.png" ,100,500 )
    --player.Hp
    --player.code=1
    

    cpumon=display.newImage( "mons.png", 1100,100 )
    cpumon.xScale,cpumon.yScale=0.1,0.1
    cpumon.atk=12
    cpumon.def=6
    cpumon.mp=0
    cputotalatk=cputotalatk+cpumon.atk
    cputotaldef=cputotaldef+cpumon.def
    cputotalmp=cputotaldef+cpumon.mp
    gameGroup:insert(cpumon)

    playerHPText=display.newText( gameGroup, "", 30, 670 , defaultfont, 30)
    playerAtkText=display.newText( gameGroup, "", 210, 440, defaultfont, 30)
    playerDefText=display.newText( gameGroup, "", 210, 540, defaultfont, 30)
    playerMpText=display.newText( gameGroup, "", 210, 610 , defaultfont, 30)
    cpuHPText=display.newText( gameGroup, "", 1050 , 300, defaultfont, 30 )
    cpuAtkText=display.newText( gameGroup, "", 1200, 40, defaultfont, 30 )
    cpuDefText=display.newText( gameGroup, "", 1200, 130, defaultfont, 30 )
    cpuMpText=display.newText( gameGroup, "", 1200, 220, defaultfont, 30 )
    cpuHPText.text=cpuHP
    cpuAtkText.text=cpumon.atk
    cpuDefText.text=cpumon.def
    cpuMpText.text=cpumon.mp
    local effcardcount=0--計算checkzone張數的計數器    
    
    
    local decktop = display.newImage( "BG.jpg",-300,display.contentHeight/2)--把牌組的卡背遮在牌組頂端
    decktop.xScale,decktop.yScale=0.15,0.1
    gameGroup:insert(decktop)
    function okbtouch(event)
        changePhase()
    end
    local okbOptions={
      defaultFile="texture/okbtn.png",
      overFile = "texture/okbtn-over.png",
      --onPress=okbtouch,
      onEvent=okbtouch,
    }
    okbtn=widget.newButton( okbOptions )
    okbtn.x=1000
    okbtn.y=600
    gameGroup:insert(okbtn)
    myTimer=timer.performWithDelay( 1000,phaseTimer,0 )

    function outofcard (event)--出牌
        --按照階段決定行為
    p_Deck[event.target.num].xScale,p_Deck[event.target.num].yScale=0.4,0.4
    if event.phase== "began" then
    moveX=event.x-p_Deck[event.target.num].x
    moveY=event.y-p_Deck[event.target.num].y
    elseif event.phase== "moved" then
    p_Deck[event.target.num].x=event.x-moveX
    p_Deck[event.target.num].y=event.y-moveY
    end
    
    if event.phase == "ended" then
        p_Deck[event.target.num].xScale,p_Deck[event.target.num].yScale=0.2,0.2
        if gamePhase=="Main" then

            if p_Deck[event.target.num].x>display.contentWidth/2-100 and 
               p_Deck[event.target.num].x<display.contentWidth/2+100 and 
               p_Deck[event.target.num].y<display.contentHeight/2+100 and 
               p_Deck[event.target.num].y>display.contentHeight/2-100 then
               if p_Deck[event.target.num].isInEff==false then
                    effcardcount=effcardcount+1
                    p_Deck[event.target.num].x=display.contentWidth/2+50*effcardcount-100
                    p_Deck[event.target.num].isInEff=true
                    effcheck=effcheck+p_Deck[event.target.num].value
                end
            else
                p_Deck[event.target.num].y=500
                p_Deck[event.target.num].x=150*event.target.num+200
                if p_Deck[event.target.num].isInEff==true then
                    effcardcount=effcardcount-1
                    p_Deck[event.target.num].isInEff=false
                    effcheck=effcheck-p_Deck[event.target.num].value
                end
            end
        end

        if gamePhase=="Battle"then
            if p_Deck[event.target.num].y<400 then
                p_Deck[event.target.num].y=400
                p_Deck[event.target.num].x=150*event.target.num+200
                if p_Deck[event.target.num].isOut==false then
                    p_Deck[event.target.num].isOut=true
                    if p_Deck[event.target.num].type=="atk" then
                        totalatk=totalatk+p_Deck[event.target.num].value
                    elseif p_Deck[event.target.num].type=="def" then
                        totaldef=totaldef+p_Deck[event.target.num].value
                    elseif p_Deck[event.target.num].type=="mp" then
                        totalmp=totalmp+p_Deck[event.target.num].value
                    end
                end
            elseif p_Deck[event.target.num].y>500 then
                p_Deck[event.target.num].y=500
                p_Deck[event.target.num].x=150*event.target.num+200
                if p_Deck[event.target.num].isOut==true then
                    p_Deck[event.target.num].isOut=false
                    if p_Deck[event.target.num].type=="atk" then
                        totalatk=totalatk-p_Deck[event.target.num].value
                    elseif p_Deck[event.target.num].type=="def" then
                        totaldef=totaldef-p_Deck[event.target.num].value
                    elseif p_Deck[event.target.num].type=="mp" then
                        totalmp=totalmp-p_Deck[event.target.num].value
                    end
                end
            end
        end
        print("ATK:"..totalatk.."   DEF:"..totaldef.."  MP:"..totalmp.." Effcheck:"..effcheck)
    end
            
  
    end
 
 
end

function changePhase( )--切換階段，並且處理每階段結束時的效果
    print("Phase dive")
    timerbar.xScale=1
    if gamePhase=="Start" then
        secNum=10
        Select()
        gamePhase="Select"
    elseif gamePhase=="Select" then
        secNum=3
        if player==nil then
            selected(player.code)
        end
        Draw()
        gamePhase="Draw"
    elseif gamePhase=="Draw" then
        MainP()
        secNum=15
        transition.to( timerbar, {time=15*1000,xScale=0.01} )
        gamePhase="Main"
        
    elseif gamePhase=="Main" then
        
        MainPEnd()
        secNum=30
        transition.to( timerbar, {time=30*1000,xScale=0.01} )
        gamePhase="Battle"
    elseif gamePhase=="Battle" then
        secNum=10
        --timer.performWithDelay( 5000, finc )
        finc()
        gamePhase="DamageCount"
    elseif gamePhase=="DamageCount" then
        gamePhase="End"
    elseif gamePhase=="End" then
        EndP()
    end
    phaseInfo.text="Phase:"..gamePhase
    print(gamePhase)
end

function alertScreen(title, message)
    alertBox = display.newImage("alertBox.png")
    alertBox.xScale,alertBox.yScale=2,2
    alertBox.x = display.contentCenterX; alertBox.y = display.contentCenterY
    transition.from(alertBox,{ time = 500, xScale = 0.5, yScale =0.5, transition = easing.outExpo} )
    conditionDisplay = display.newText(title, 0, 0, "Arial", 38)
    conditionDisplay:setTextColor(255,255,255,255)
    conditionDisplay.xScale = 1
    conditionDisplay.yScale = 1
    conditionDisplay.x = display.contentCenterX
    conditionDisplay.y = display.contentCenterY - 15
    messageText = display.newText(message, 0, 0, "Arial", 24)
    messageText:setTextColor(1,1,1,1)
    messageText.xScale = 1
    messageText.yScale = 1
    messageText.x = display.contentCenterX
    messageText.y = display.contentCenterY + 15
    alertDisplayGroup = display.newGroup()
    alertDisplayGroup:insert(alertBox)
    alertDisplayGroup:insert(conditionDisplay)
    alertDisplayGroup:insert(messageText)
    alertBox:addEventListener("tap", restart)
   
end

function cleantable(  )
    timer.cancel( myTimer )
    phaseInfo.text=""
    timerInfo.text=""
    print("PlayerHP="..playerHp.."  CpuHP="..cpuHP)
    alertBox:removeEventListener("tap", restart)
    alertDisplayGroup:removeSelf()
    alertDisplayGroup= nil
    okbtn:removeSelf( )
    okbtn=nil
    totalatk=0
    totaldef=0
    totalmp=0
    cputotalatk=0
    cputotaldef=0
    cputotalmp=0
    effcheck=0
    isFincCalled=false
    timerbar=nil
    if playerFirst==true then
        playerFirst=false
    else
        playerFirst=true
    end
    toto=display.newText("", 950 , 600, defaultFont,defaultFontSize )
    gameGroup:insert(toto)
    playerHandCardGroup:removeSelf( )
    playerHandCardGroup=display.newGroup( )
    cpuHandCardGroup:removeSelf( )
    playerHandCardGroup=display.newGroup( )
    game()
end

    
    function backtomenu( )
        composer.gotoScene( "mainmenu", "fade", 500 )
    end

function restart()
    if gameEvent=="start" then
        print("start")
        alertBox:removeEventListener("tap", restart)
        alertDisplayGroup:removeSelf()
        alertDisplayGroup= nil
        loading()
    elseif gameEvent== "win" and wincounter== 1 then
        wincounter=wincounter+1
        cleantable()
        alertScreen(" Game Over", " Congratulations!")
        gameEvent= "restart"
    elseif gameEvent== "lose" then
        playerHandCardGroup:removeSelf( )
        playerHandCardGroup=nil
        cpuHandCardGroup:removeSelf()
        cpuHandCardGroup=nil
        alertDisplayGroup:removeSelf()
        alertDisplayGroup= nil
        backtomenu()
    elseif gameEvent=="Continue" then
        cleantable()
    end
end


function main()
    --addGameScreen()
    if isin==false then
        isin=true
        loading()
    end
end

main()

end

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
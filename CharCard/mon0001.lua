
c0001=
{
    id=0001
    ,Name="SnowBall"
    ,Hp=10
    ,Atk=5
    ,Def=5
    ,Mp=5
    ,ImgPath="chara.png"
}


function c0001Effect( )
    if effcheck>=13 then
        print("Effect achive")
        playerHp=playerHp+1
        if playerHp>=c0001.Hp then
            playerHp=c0001.Hp
        end
    end	
end

function c0001Skill()
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

function c0001Test()
    print("test Active")
end
if M_CREATURSPELL ~= true then
M_CREATURSPELL = true;

require("magic.base.basics");
module("magic.base.creaturspell")

function DoCreaturSpell(Caster, TargetPos, ltstate)
    if ( ltstate == Action.abort ) then
        Caster:talkLanguage(CCharacter.say, CPlayer.german, "#me stoppt apprupt mit dem Zaubern.");
        Caster:talkLanguage(CCharacter.say, CPlayer.english,"#me abruptly stops casting.");
        return;
    end

    magic.base.basics.loadCorrectDefScript();

    -- Generate the needed
    magic.base.basics.gemBonis( Caster );

    genderMsg = {};
    genderMsg[CPlayer.german], genderMsg[CPlayer.english] = magic.base.basics.GenderMessage( Caster );

    if ( Caster:distanceMetricToPosition(TargetPos) > Settings.Range + GemBonis.Range) then
        base.common.InformNLS( Caster,
        "Du bist zuweit weg um diesen Zauber zu sprechen.",
        "You are too far away to cast this spell." );
        return;
    end

    if not base.common.IsLookingAt( Caster, TargetPos ) then
        base.common.TempInformNLS( Caster,
        "Du drehst dich auf dein Ziel zu um es in dein Blickfeld zu bekommen.",
        "You turn to your target to get it into your field of vision.");
        base.common.TurnTo( Caster, TargetPos );
    end

    if world:isCharacterOnField( TargetPos ) then
        base.common.TempInformNLS( Caster,
        "Du musst auf eine freie Stelle zaubern wenn du Erfolg haben willst.",
        "You have to cast on a free area if you want to success.");
        return;
    end

    if ( ltstate == Action.none ) then
        local message = string.gsub( TimeEffects.msg[CPlayer.german], "{PP}", genderMsg[CPlayer.german] );
        --Caster:talkLanguage( CCharacter.say,  CPlayer.german, message );
        message = string.gsub( TimeEffects.msg[CPlayer.english], "{PP}", genderMsg[CPlayer.english] );
        --Caster:talkLanguage( CCharacter.say, CPlayer.english, message );
        Caster:startAction( base.common.Limit( TimeEffects.delay + GemBonis.Time, 0 ), TimeEffects.gfx.id, TimeEffects.gfx.time, TimeEffects.sfx.id, TimeEffects.sfx.time);
        return;
    end

    magic.base.basics.SayRunes( Caster );

    local CasterVal=magic.base.basics.CasterValue( Caster );

    if not magic.base.basics.CheckAndReduceRequirements( Caster, CasterVal ) then
        return;
    end

    if not CasterVal then
        base.common.TempInformNLS( Caster,
        "Es gelingt dir nicht die n�tige Konzentration aufzubringen um diesen Zauber zur Entfaltung zu bringen.",
        "You fail to concentrate enought to get this spell to its evolvement." );
        return;
    end

    world:createMonster(Monsters[math.random(1,table.getn(Monsters))],TargetPos,10);

    magic.base.basics.performGFX( SpellEffects.gfx, TargetPos );
    magic.base.basics.performSFX( SpellEffects.sfx, TargetPos );

    if (LuaAnd(Caster:getQuestProgress(24),1) ~= 0 ) then
        return;
    end

    Caster:learn( 3, Skill.name, 2, Skill.max );
end

function CastMagic(Caster,counter,param,ltstate)
    DoCreaturSpell(Caster,base.common.GetFrontPosition(Caster),ltstate);
end

function CastMagicOnCharacter(Caster,TargetCharacter,counter,param,ltstate)
    if TargetCharacter then
        DoCreaturSpell(Caster, TargetCharacter.pos, ltstate);
    else
        CastMagic(Caster,counter,param,ltstate);
    end
end

function CastMagicOnField(Caster,Targetpos,counter,param,ltstate)
    DoCreaturSpell(Caster,Targetpos,ltstate);
end

function CastMagicOnItem(Caster,TargetItem,counter,param,ltstate)
    DoCreaturSpell(Caster,TargetItem.pos,ltstate);
end

end;
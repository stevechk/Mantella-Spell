Scriptname MantellaDummyFunctionSpellScript extends activemagiceffect  

Spell property MantellaFunctionDummySpell auto
Faction Property MantellaFunctionSourceFaction Auto
MantellaAction_FunctionCallingScript property FunctionCallingScript auto
Faction Property MantellaFunctionModeFaction Auto
MantellaConversation property conversation auto

Function AddIngameEventToConversation(string eventText)
    If (conversation.IsRunning())
        conversation.AddIngameEvent(eventText)
    EndIf
EndFunction

event OnEffectStart(Actor target, Actor caster)
    int SpellToGet = caster.GetFactionRank(MantellaFunctionModeFaction)
    Spell SpellToUse = FunctionCallingScript.ReturnSpellFromArray(SpellToGet)
    float magickaCost=SpellToUse.GetEffectiveMagickaCost(caster)
    If caster.GetAV("Magicka")>=magickaCost
        string mantellaEventFeedback = caster.GetDisplayName()+" is casting "+SpellToUse.getname()
        debug.notification(mantellaEventFeedback)
        AddIngameEventToConversation(mantellaEventFeedback)
        SpellToUse.Cast(caster, target)
        caster.DamageAV("Magicka",magickaCost)
    Else
        string mantellaEventFeedback = caster.GetDisplayName()+" does not have the mana to cast "+SpellToUse.getname()
        debug.notification(mantellaEventFeedback)
        AddIngameEventToConversation(mantellaEventFeedback)
    endif
    caster.RemoveSpell(MantellaFunctionDummySpell)
    caster.RemoveFromFaction(MantellaFunctionSourceFaction)
    Conversation.CauseReassignmentOfParticipantAlias()
EndEvent
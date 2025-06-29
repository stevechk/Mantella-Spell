Scriptname MantellaAction_FunctionCallingScript extends Quest Hidden

Import SKSE_HTTP

Actor Property PlayerRef Auto
MantellaRepository property repository auto
MantellaConstants property mConsts auto
MantellaConversation property conversation auto
MantellaInterface property EventInterface Auto
Faction Property MantellaFunctionTargetFaction Auto
Faction Property MantellaFunctionSourceFaction Auto
Faction Property MantellaFunctionModeFaction Auto
Faction Property MantellaFunctionWhoIsSourceTargeting Auto
Quest Property MantellaLootQuest Auto 
Quest Property MantellaLootConsumablesQuest Auto 
Quest Property MantellaLootArmorQuest Auto 
Quest Property MantellaLootWeaponsQuest Auto 
Quest Property MantellaLootJunkQuest Auto 
Spell[] Property SpellInUseArray auto
Int Property SpellInUseIterator auto
Spell property MantellaFunctionDummySpell auto

event OnInit()
    RegisterForFunctionCallingEvents()
    SpellInUseArray = new Spell[5]
    SpellInUseIterator = 0
EndEvent

event OnPlayerLoadGame()
    RegisterForFunctionCallingEvents()
    SpellInUseArray = new Spell[5]
    SpellInUseIterator = 0
endEvent


Function RegisterForFunctionCallingEvents()
    RegisterForModEvent(EventInterface.EVENT_ACTIONS_PREFIX + mConsts.ACTION_MULTI_MOVETO_NPC,"OnMultiMoveActionReceived")
    RegisterForModEvent(EventInterface.EVENT_ACTIONS_PREFIX + mConsts.ACTION_NPC_MOVETO_NPC,"OnNPCMoveActionReceived")
    RegisterForModEvent(EventInterface.EVENT_ACTIONS_PREFIX + mConsts.ACTION_MAKE_NPC_WAIT,"OnMakeNPCWaitActionReceived")
    RegisterForModEvent(EventInterface.EVENT_ACTIONS_PREFIX + mConsts.ACTION_MULTI_MAKE_NPC_WAIT,"OnMultiMakeNPCWaitActionReceived")
    RegisterForModEvent(EventInterface.EVENT_ACTIONS_PREFIX + mConsts.ACTION_NPC_ATTACK_OTHER_NPC,"OnNPCAttackOtherNPCReceived")
    RegisterForModEvent(EventInterface.EVENT_ACTIONS_PREFIX + mConsts.ACTION_MULTI_NPC_ATTACK_OTHER_NPC,"OnMultiNPCAttackOtherNPCReceived")
    RegisterForModEvent(EventInterface.EVENT_ACTIONS_PREFIX + mConsts.ACTION_NPC_LOOT_ITEMS,"OnNPCLootItemsReceived")
    RegisterForModEvent(EventInterface.EVENT_ACTIONS_PREFIX + mConsts.ACTION_MULTI_NPC_LOOT_ITEMS,"OnMultiNPCLootItemsReceived")
    RegisterForModEvent(EventInterface.EVENT_ACTIONS_PREFIX + mConsts.ACTION_NPC_USE_SPELL,"OnNPCUseSpellReceived")
    RegisterForModEvent(EventInterface.EVENT_ACTIONS_PREFIX + mConsts.ACTION_MULTI_TELEPORT_NPC,"OnMultiNPCTeleportReceived")
    RegisterForModEvent(EventInterface.EVENT_ACTIONS_PREFIX + mConsts.ACTION_TELEPORT_NPC,"OnNPCTeleportReceived")
    RegisterForModEvent(EventInterface.EVENT_CONVERSATION_ENDED,"OnConversationEnded")
    RegisterForModEvent(mConsts.KEY_SIGNAL_EXTERNAL_CUSTOM_CONTEXT_EVENT,"OnExternalCustomContextEventReceived")

    RegisterForModEvent(EventInterface.EVENT_ACTIONS_PREFIX + mConsts.ACTION_NPC_OFFENDED,"OnNpcOffendedActionReceived")
    RegisterForModEvent(EventInterface.EVENT_ACTIONS_PREFIX + mConsts.ACTION_NPC_FORGIVEN,"OnNpcForgivenActionReceived")
    RegisterForModEvent(EventInterface.EVENT_ACTIONS_PREFIX + mConsts.ACTION_NPC_FOLLOW,"OnNpcFollowActionReceived")
    RegisterForModEvent(EventInterface.EVENT_ACTIONS_PREFIX + mConsts.ACTION_NPC_INVENTORY,"OnNpcInventoryActionReceived")

    

EndFunction

Event OnConversationEnded()
    debug.notification("Conversation Ended")
    MantellaLootQuest.Stop()
    MantellaLootConsumablesQuest.Stop()
    MantellaLootArmorQuest.Stop() 
    MantellaLootWeaponsQuest.Stop() 
    MantellaLootJunkQuest.Stop() 

EndEvent

event OnNpcOffendedActionReceived(Form speaker, int MantellaExeHandle)
    Actor aSpeaker = speaker as Actor
    if (aSpeaker)
        if PlayerRef.isinfaction(repository.giafac_AllowAnger)
            Debug.Notification(aSpeaker.GetDisplayName() + " did not like that.")
            ;target.UnsheatheWeapon()
            ;target.SendTrespassAlarm(caster)
            aSpeaker.StartCombat(PlayerRef)
        else
            Debug.Notification("Aggro action not enabled in the Mantella MCM.")
        Endif
    endif
endEvent

event OnNpcForgivenActionReceived(Form speaker, int MantellaExeHandle)
    Actor aSpeaker = speaker as Actor
    if (aSpeaker)
        if PlayerRef.isinfaction(repository.giafac_AllowAnger)
            Debug.Notification(aSpeaker.GetDisplayName() + " forgave you.")
            aSpeaker.StopCombat()
        endif
    endif
endEvent

event OnNpcFollowActionReceived(Form speaker, int MantellaExeHandle)
    Actor aSpeaker = speaker as Actor
    if (aSpeaker)
        if (aSpeaker.getrelationshiprank(PlayerRef) != "4")
            if PlayerRef.isinfaction(repository.giafac_allowfollower)
                Debug.Notification(aSpeaker.GetDisplayName() + " is following you.");gia
                aSpeaker.SetFactionRank(repository.giafac_following, 1);gia
                repository.gia_FollowerQst.reset();gia
                repository.gia_FollowerQst.stop();gia
                Utility.Wait(0.5);gia
                repository.gia_FollowerQst.start();gia
                aSpeaker.EvaluatePackage();gia
            else
                Debug.Notification("Follow action not enabled in the Mantella MCM.")
            endif
        endif
    endif
endEvent

event OnNpcInventoryActionReceived(Form speaker, int MantellaExeHandle)
    Actor aSpeaker = speaker as Actor
    if (aSpeaker)
        if PlayerRef.isinfaction(repository.fac_AllowInventory)
            aSpeaker.OpenInventory(true)
        else
            Debug.Notification("Inventory action not enabled in the Mantella MCM.")
        endif
    endif
endEvent

event OnNPCMoveActionReceived(Form speakerForm, int MantellaExeHandle)
    Actor speaker = speakerForm as Actor
    ;debug.notification("NPC move to NPC action identifier recognized")
    string[] targetIDs= RetrieveTargetIDFunctionInferenceValues(MantellaExeHandle)
    ;debug.notification("Target IDs array fetched "+targetIDs)
    actor targetNPC = repository.getActorFromArray(targetIDs[0],repository.MantellaFunctionInferenceActorList)
    if targetNPC
        speaker.AddToFaction(MantellaFunctionSourceFaction)
        speaker.SetFactionRank(MantellaFunctionSourceFaction, 1)
        actor CurrentFunctionTargetNPC=targetNPC
        If (CurrentFunctionTargetNPC==playerRef)
            speaker.SetFactionRank(MantellaFunctionSourceFaction, 5)
            speaker.SetPlayerTeammate(true)
            speaker.EvaluatePackage()
            string mantellaEventFeedback = "Target NPC found, "+speaker.GetDisplayName()+" is following "+CurrentFunctionTargetNPC.GetDisplayName()
            debug.notification(mantellaEventFeedback)
            AddIngameEventToConversation(mantellaEventFeedback)
        else
            Form[] speakerArrayOfOne = new Form[1]
            speakerArrayOfOne[0]=speaker as Form
            conversation.UpdateCurrentFunctionTarget(speakerArrayOfOne, CurrentFunctionTargetNPC)
            string mantellaEventFeedback = "Target NPC found, "+speaker.GetDisplayName()+" is moving towards "+CurrentFunctionTargetNPC.GetDisplayName()
            debug.notification(mantellaEventFeedback)
            AddIngameEventToConversation(mantellaEventFeedback)
        EndIf
        conversation.CauseReassignmentOfParticipantAlias()
    endif
endEvent 

event OnMultiMoveActionReceived(Form speaker, int MantellaExeHandle) 
    debug.notification("Multi move to NPC action identifier recognized")
    string[] targetIDs= RetrieveTargetIDFunctionInferenceValues(MantellaExeHandle)
    debug.notification("Target IDs array fetched "+targetIDs)
    actor targetNPC = repository.getActorFromArray(targetIDs[0],repository.MantellaFunctionInferenceActorList)
    if targetNPC
        Form[] ActorsToMoveFormList = conversation.GetParticipantsFormArray()
        string[] sourceIDs = SKSE_HTTP.getStringArray(MantellaExeHandle, mConsts.FUNCTION_DATA_SOURCE_IDS)
        ActorsToMoveFormList = FilterActorFormArrayFromIDs(sourceIDs, ActorsToMoveFormList)
        int i=0
        bool doOnce
        Actor currentActor
        While i < ActorsToMoveFormList.Length

            currentActor = ActorsToMoveFormList[i] as actor
            currentActor.AddToFaction(MantellaFunctionSourceFaction)
            If (targetNPC==playerRef)
                currentActor.SetFactionRank(MantellaFunctionSourceFaction, 5)
                currentActor.SetPlayerTeammate(true)
                currentActor.EvaluatePackage()
                string mantellaEventFeedback = currentActor.GetDisplayName()+" is following "+targetNPC.GetDisplayName()
                debug.notification(mantellaEventFeedback)
                AddIngameEventToConversation(mantellaEventFeedback)
            else
                currentActor.SetFactionRank(MantellaFunctionSourceFaction, 1)
                if !doOnce
                    conversation.UpdateCurrentFunctionTarget(ActorsToMoveFormList, targetNPC)
                    doOnce=true
                endif
                currentActor.EvaluatePackage()
                string mantellaEventFeedback = currentActor.GetDisplayName()+" is moving towards "+targetNPC.GetDisplayName()
                debug.notification(mantellaEventFeedback)
                AddIngameEventToConversation(mantellaEventFeedback)
            EndIf
            i+=1
        EndWhile
        conversation.CauseReassignmentOfParticipantAlias()
    endif
endEvent

event OnMakeNPCWaitActionReceived (Form speaker, int MantellaExeHandle) 
    Actor currentActor = speaker as Actor
    currentActor.AddToFaction(MantellaFunctionSourceFaction)
    currentActor.SetFactionRank(MantellaFunctionSourceFaction, 0)
    currentActor.StopCombat()
    string mantellaEventFeedback = currentActor.GetDisplayName()+" will wait"
    debug.notification(mantellaEventFeedback)
    AddIngameEventToConversation(mantellaEventFeedback)
    conversation.CauseReassignmentOfParticipantAlias()
endEvent



event OnMultiMakeNPCWaitActionReceived (Form speaker, int MantellaExeHandle) 
    Form[] ActorsToWaitFormList = conversation.GetParticipantsFormArray()
    string[] sourceIDs = SKSE_HTTP.getStringArray(MantellaExeHandle, mConsts.FUNCTION_DATA_SOURCE_IDS)
    ActorsToWaitFormList = FilterActorFormArrayFromIDs(sourceIDs, ActorsToWaitFormList)
    Actor currentActor
    int i=0
    While i < ActorsToWaitFormList.Length
        currentActor = ActorsToWaitFormList[i] as Actor
        currentActor.AddToFaction(MantellaFunctionSourceFaction)
        currentActor.SetFactionRank(MantellaFunctionSourceFaction, 0)
        currentActor.stopcombat()
        string mantellaEventFeedback = currentActor.GetDisplayName()+" will wait"
        debug.notification(mantellaEventFeedback)
        AddIngameEventToConversation(mantellaEventFeedback)
        i+=1
    EndWhile
    conversation.CauseReassignmentOfParticipantAlias()
endEvent

event OnNPCAttackOtherNPCReceived(Form speakerForm, int MantellaExeHandle)
    Actor speaker = speakerForm as Actor
    debug.notification("Single attack NPC identifier recognized")
    string[] targetIDs= RetrieveTargetIDFunctionInferenceValues(MantellaExeHandle)
    debug.notification("Target IDs array fetched "+targetIDs)
    actor targetNPC = repository.getActorFromArray(targetIDs[0],repository.MantellaFunctionInferenceActorList)
    if targetNPC
        ;speaker.AddToFaction(MantellaFunctionSourceFaction)
        ;speaker.SetFactionRank(MantellaFunctionSourceFaction, 1)
        actor CurrentFunctionTargetNPC=targetNPC
        Form[] speakerArrayOfOne = new Form[1]
        speakerArrayOfOne[0]=speaker as Form
        conversation.UpdateCurrentFunctionTarget(speakerArrayOfOne, CurrentFunctionTargetNPC)
        string mantellaEventFeedback = speaker.GetDisplayName()+" is attacking "+CurrentFunctionTargetNPC.GetDisplayName()
        debug.notification(mantellaEventFeedback)
        AddIngameEventToConversation(mantellaEventFeedback)
        speaker.StartCombat(targetNPC)
    endif
endEvent 

event OnMultiNPCAttackOtherNPCReceived(Form speaker, int MantellaExeHandle) 
    debug.notification("Multi attack other NPC action identifier recognized")
    string[] targetIDs= RetrieveTargetIDFunctionInferenceValues(MantellaExeHandle)
    debug.notification("Target IDs array fetched "+targetIDs)
    actor targetNPC = repository.getActorFromArray(targetIDs[0],repository.MantellaFunctionInferenceActorList)
    if targetNPC
        Form[] ActorsAttackingFormList = conversation.GetParticipantsFormArray()
        string[] sourceIDs = SKSE_HTTP.getStringArray(MantellaExeHandle, mConsts.FUNCTION_DATA_SOURCE_IDS)
        ActorsAttackingFormList = FilterActorFormArrayFromIDs(sourceIDs, ActorsAttackingFormList)
        int i=0
        bool doOnce
        Actor currentActor
        While i < ActorsAttackingFormList.Length
            currentActor = ActorsAttackingFormList[i] as actor
            ;currentActor.AddToFaction(MantellaFunctionSourceFaction)
            ;currentActor.SetFactionRank(MantellaFunctionSourceFaction, 2)
            if !doOnce
                conversation.UpdateCurrentFunctionTarget(ActorsAttackingFormList, targetNPC)
                doOnce=true
            endif
            currentActor.StartCombat(targetNPC)
            string mantellaEventFeedback = currentActor.GetDisplayName()+" is attacking "+targetNPC.GetDisplayName()
            debug.notification(mantellaEventFeedback)
            AddIngameEventToConversation(mantellaEventFeedback)
            i+=1
        EndWhile
        ;conversation.CauseReassignmentOfParticipantAlias()
    endif
endEvent

Event OnNPCLootItemsReceived(Form speakerForm, int MantellaExeHandle) 

    Actor speaker = speakerForm as Actor

    string[] item_type_to_loot = SKSE_HTTP.getStringArray(MantellaExeHandle, mConsts.FUNCTION_DATA_MODES)
    string lootNotification = "" 
    int NPCAIItemToLootSelector = 0
    Quest QuestToUpdate
    if item_type_to_loot[0] == "weapons"
        NPCAIItemToLootSelector=1
        lootNotification=" will scavenge weapons for you."
        QuestToUpdate = MantellaLootWeaponsQuest
    Elseif item_type_to_loot[0] == "armor"
        NPCAIItemToLootSelector=2
        lootNotification=" will scavenge armor for you."
        QuestToUpdate = MantellaLootArmorQuest
    Elseif item_type_to_loot[0] == "junk"
        NPCAIItemToLootSelector=3
        lootNotification=" will scavenge junk for you."
        QuestToUpdate = MantellaLootJunkQuest
    Elseif item_type_to_loot[0] == "consumables"
        NPCAIItemToLootSelector=4
        lootNotification=" will scavenge consumables for you."
        QuestToUpdate = MantellaLootConsumablesQuest
    Else
        lootNotification=" will scavenge any items for you."
        QuestToUpdate = MantellaLootQuest
    endif  

    if speaker.IsOverEncumbered()
        string mantellaEventFeedback = speaker.GetDisplayName()+" cannot scavenge for you because they are overemcumbered."
        debug.notification(mantellaEventFeedback)
        AddIngameEventToConversation(mantellaEventFeedback)
    Else
        speaker.SetFactionRank(MantellaFunctionModeFaction, NPCAIItemToLootSelector) ;Attributing the mode number to the faction
        string mantellaEventFeedback = speaker.GetDisplayName()+lootNotification
        debug.notification(mantellaEventFeedback)
        AddIngameEventToConversation(mantellaEventFeedback)
        speaker.SetFactionRank(MantellaFunctionSourceFaction, 3) ; MantellaFunctionSourceFaction Rank 3 means looting
        conversation.StoreActorFunctionData(speaker)
        RegisterForSingleUpdate(4)
    endif
    ResetFunctionReferencesAndAIForQuest(QuestToUpdate)
EndEvent

Event OnMultiNPCLootItemsReceived(Form speaker, int MantellaExeHandle) 
    Form[] ActorsLootingFormList = conversation.GetParticipantsFormArray()
    string[] sourceIDs = SKSE_HTTP.getStringArray(MantellaExeHandle, mConsts.FUNCTION_DATA_SOURCE_IDS)
    ActorsLootingFormList = FilterActorFormArrayFromIDs(sourceIDs, ActorsLootingFormList)
    if !ActorsLootingFormList
        return
    endif
    string[] item_type_to_loot = SKSE_HTTP.getStringArray(MantellaExeHandle, mConsts.FUNCTION_DATA_MODES)
    string lootNotification = "" 
    int NPCAIItemToLootSelector = 0
    Quest QuestToUpdate
    if item_type_to_loot[0] == "weapons"
        NPCAIItemToLootSelector=1
        lootNotification=" will scavenge weapons for "+PlayerRef+"."
        QuestToUpdate = MantellaLootWeaponsQuest
    Elseif item_type_to_loot[0] == "armor"
        NPCAIItemToLootSelector=2
        lootNotification=" will scavenge armor for "+PlayerRef+"."
        QuestToUpdate = MantellaLootArmorQuest
    Elseif item_type_to_loot[0] == "junk"
        NPCAIItemToLootSelector=3
        lootNotification=" will scavenge junk for "+PlayerRef+"."
        QuestToUpdate = MantellaLootJunkQuest
    Elseif item_type_to_loot[0] == "consumables"
        NPCAIItemToLootSelector=4
        lootNotification=" will scavenge consumables for "+PlayerRef+"."
        QuestToUpdate = MantellaLootConsumablesQuest
    Else
        lootNotification=" will scavenge any items for "+PlayerRef+"."
        QuestToUpdate = MantellaLootQuest
    endif  
    
    int i = 0
    actor currentActor
    While i < ActorsLootingFormList.Length
        currentActor = ActorsLootingFormList[i] as Actor
        if currentActor.IsOverEncumbered()
            string mantellaEventFeedback = currentActor.GetDisplayName()+" cannot scavenge for "+PlayerRef+" because they are overemcumbered."
            debug.notification(mantellaEventFeedback)
            AddIngameEventToConversation(mantellaEventFeedback)
        Else
            currentActor.SetFactionRank(MantellaFunctionModeFaction, NPCAIItemToLootSelector) ;Attributing the mode number to the faction
            string mantellaEventFeedback = currentActor.GetDisplayName()+lootNotification
            debug.notification(mantellaEventFeedback)
            AddIngameEventToConversation(mantellaEventFeedback)
            currentActor.SetFactionRank(MantellaFunctionSourceFaction, 3) ; MantellaFunctionSourceFaction Rank 3 means looting
            conversation.StoreActorFunctionData(currentActor)
            RegisterForSingleUpdate(4)
        endif
        i+=1
    EndWhile
    ResetFunctionReferencesAndAIForQuest(QuestToUpdate)
EndEvent

Event OnNPCUseSpellReceived (Form speakerForm, int MantellaExeHandle)
    Actor speaker = speakerForm as Actor
    debug.notification("Single NPC use spell identifier recognized")
    string[] targetIDs= RetrieveTargetIDFunctionInferenceValues(MantellaExeHandle)
    debug.notification("Target IDs array fetched "+targetIDs)
    actor targetNPC = repository.getActorFromArray(targetIDs[0],repository.MantellaFunctionInferenceActorList)
    string[] spellname_to_use = SKSE_HTTP.getStringArray(MantellaExeHandle, mConsts.FUNCTION_DATA_MODES)

    Spell SpellToUse = GetSpellFromActor(spellname_to_use[0],speaker)
    if targetNPC
        ;speaker.AddToFaction(MantellaFunctionSourceFaction)
        ;speaker.SetFactionRank(MantellaFunctionSourceFaction, 1)
        if targetNPC==speaker
            SpellToUse.Cast(speaker, targetNPC)
            string mantellaEventFeedback = "Target NPC found, "+speaker.GetDisplayName()+" is using "+SpellToUse.getname()+" on themselves"
            debug.notification(mantellaEventFeedback)
            AddIngameEventToConversation(mantellaEventFeedback)
        else
            actor CurrentFunctionTargetNPC=targetNPC
            Form[] speakerArrayOfOne = new Form[1]
            speakerArrayOfOne[0]=speaker as Form
            conversation.UpdateCurrentFunctionTarget(speakerArrayOfOne, CurrentFunctionTargetNPC)
            speaker.AddSpell(MantellaFunctionDummySpell)
            speaker.SetFactionRank(MantellaFunctionModeFaction, StoreSpellInArrayAndUpdatePosition(SpellToUse)) ;Attributing the mode number to the faction
            speaker.SetFactionRank(MantellaFunctionSourceFaction, 6)
            string mantellaEventFeedback = "Target NPC found, "+speaker.GetDisplayName()+" is using "+SpellToUse.getname()+" on "+CurrentFunctionTargetNPC.GetDisplayName()
            debug.notification(mantellaEventFeedback)
            AddIngameEventToConversation(mantellaEventFeedback)
            ;SpellToUse.cast(speaker,targetNPC)
            conversation.CauseReassignmentOfParticipantAlias()
        endif
    endif
EndEvent

Event OnMultiNPCTeleportReceived (Form speakerForm, int MantellaExeHandle)
    debug.notification("Multi teleport to another NPC action identifier")
    string[] targetIDs= RetrieveTargetIDFunctionInferenceValues(MantellaExeHandle)
    debug.notification("Target IDs array fetched "+targetIDs)
    actor targetNPC = repository.getActorFromArray(targetIDs[0],repository.MantellaFunctionInferenceActorList)
    if targetNPC
        Form[] ActorsToTeleportFormList = conversation.GetParticipantsFormArray()
        string[] sourceIDs = SKSE_HTTP.getStringArray(MantellaExeHandle, mConsts.FUNCTION_DATA_SOURCE_IDS)
        ActorsToTeleportFormList = FilterActorFormArrayFromIDs(sourceIDs, ActorsToTeleportFormList)
        int i=0
        bool doOnce
        Actor currentActor
        While i < ActorsToTeleportFormList.Length
            currentActor = ActorsToTeleportFormList[i] as actor
            currentActor.MoveTo(targetNPC)
            string mantellaEventFeedback = currentActor.GetDisplayName()+" is teleporting towards "+targetNPC.GetDisplayName()
            debug.notification(mantellaEventFeedback)
            AddIngameEventToConversation(mantellaEventFeedback)
            i+=1
        EndWhile
    endif
EndEvent

Event OnNPCTeleportReceived (Form speakerForm, int MantellaExeHandle)
    debug.notification("Single teleport to another NPC action identifier")
    string[] targetIDs= RetrieveTargetIDFunctionInferenceValues(MantellaExeHandle)
    debug.notification("Target IDs array fetched "+targetIDs)
    actor targetNPC = repository.getActorFromArray(targetIDs[0],repository.MantellaFunctionInferenceActorList)
    if targetNPC
        actor currentActor = speakerForm as actor
        currentActor.MoveTo(targetNPC)
        string mantellaEventFeedback = currentActor.GetDisplayName()+" is teleporting towards "+targetNPC.GetDisplayName()
        debug.notification(mantellaEventFeedback)
        AddIngameEventToConversation(mantellaEventFeedback)
    endif
EndEvent  

Event OnExternalCustomContextEventReceived (int customContextHandle)
    
    Form[] participantsFormArray = conversation.GetParticipantsFormArray()

    int iteratorB = 0
    String[] SpellStringArray =  Utility.CreateStringArray(0)
    String outputString = ""
    if participantsFormArray.Length == 2
        while iteratorB < participantsFormArray.Length
            actor CurrentActor = participantsFormArray[iteratorB] as Actor
            actorbase CurrentActorBase = CurrentActor.GetActorBase()
            if CurrentActor !=PlayerRef
                int i = 0
                while i < CurrentActorBase.GetSpellCount() 
                    Spell currentSpell = CurrentActorBase.GetNthSpell(i)

                    ;debug.MessageBox("Now checking spell "+currentSpell.getname()+"of "+CurrentActor.GetDisplayName())
                    ;if currentSpell.getequiptype() == (Game.GetForm(0x00013F44) As EquipSlot) ||currentSpell.getequiptype() == (Game.GetForm(0x00025BEE) As EquipSlot)  ; Checks for either hand or voice equip slots
                        ;debug.messagebox("PlayerRef current spell equiptype for "+currentSpell.GetName()+" is "+currentSpell.getequiptype())
                        ;debug.messagebox("PlayerRef current spell castingtime for "+currentSpell.GetName()+" is "+currentSpell.GetCastTime())
                        if !checkStringArrayForDuplicates(currentSpell.GetName(), SpellStringArray)
                                ;debug.messagebox("Participant "+CurrentActor.GetDisplayName()+"'s current spell cost for "+currentSpell.GetName()+" is "+currentSpell.GetEffectiveMagickaCost(CurrentActor))
                                SpellStringArray =  Utility.ResizeStringArray(SpellStringArray, (SpellStringArray.Length+1))
                                SpellStringArray[SpellStringArray.Length - 1] = currentSpell.GetName()
                        endif
                        ;debug.notification("PlayerRef current spell duration for "+currentSpell.GetName()+" is "+currentSpell.GetNthEffectDuration(currentSpell.GetNumEffects() - 1))
                    ;endif
                    i=i+1
                endwhile
                while i < CurrentActor.GetSpellCount() 
                    Spell currentSpell = CurrentActor.GetNthSpell(i)
                    ;debug.MessageBox("Now checking spell "+currentSpell.getname()+"of "+CurrentActor.GetDisplayName())
                    ;if currentSpell.getequiptype() == (Game.GetForm(0x00013F44) As EquipSlot) ||currentSpell.getequiptype() == (Game.GetForm(0x00025BEE) As EquipSlot)  ; Checks for either hand or voice equip slots
                        if currentSpell.GetEffectiveMagickaCost(CurrentActor) > 0
                        ;debug.messagebox("PlayerRef current spell equiptype for "+currentSpell.GetName()+" is "+currentSpell.getequiptype())
                        ;debug.messagebox("PlayerRef current spell castingtime for "+currentSpell.GetName()+" is "+currentSpell.GetCastTime())
                            if !checkStringArrayForDuplicates(currentSpell.GetName(), SpellStringArray)
                                    ;debug.messagebox("Participant "+CurrentActor.GetDisplayName()+"'s current spell cost for "+currentSpell.GetName()+" is "+currentSpell.GetEffectiveMagickaCost(CurrentActor))
                                    SpellStringArray =  Utility.ResizeStringArray(SpellStringArray, (SpellStringArray.Length+1))
                                    SpellStringArray[SpellStringArray.Length - 1] = currentSpell.GetName()
                            endif
                        ;debug.notification("PlayerRef current spell duration for "+currentSpell.GetName()+" is "+currentSpell.GetNthEffectDuration(currentSpell.GetNumEffects() - 1))
                        endif
                    ;endif
                    i=i+1
                endwhile

                ;/
                while i < CurrentActor.GetNumItems() 
                    Form currentForm = CurrentActor.GetNthForm(i)
                    debug.MessageBox("Now checking Form "+currentForm.getname()+"of "+CurrentActor.GetDisplayName())
                    if currentForm.gettype() == 22 || currentForm.gettype() == 82
                        Spell currentSpell = CurrentActor.GetNthForm (i) as Spell
                        debug.MessageBox("Now checking spell "+currentSpell.getname()+"of "+CurrentActor.GetDisplayName())
                        ;if currentSpell.getequiptype() == (Game.GetForm(0x00013F44) As EquipSlot) ||currentSpell.getequiptype() == (Game.GetForm(0x00025BEE) As EquipSlot)  ; Checks for either hand or voice equip slots
                            ;if currentSpell.GetEffectiveMagickaCost(CurrentActor) > 0
                            ;debug.messagebox("PlayerRef current spell equiptype for "+currentSpell.GetName()+" is "+currentSpell.getequiptype())
                            ;debug.messagebox("PlayerRef current spell castingtime for "+currentSpell.GetName()+" is "+currentSpell.GetCastTime())
                                if !checkStringArrayForDuplicates(currentSpell.GetName(), SpellStringArray)
                                    debug.messagebox("Participant "+CurrentActor.GetDisplayName()+"'s current spell cost for "+currentSpell.GetName()+" is "+currentSpell.GetEffectiveMagickaCost(CurrentActor))
                                    SpellStringArray =  Utility.ResizeStringArray(SpellStringArray, (SpellStringArray.Length+1))
                                    SpellStringArray[SpellStringArray.Length - 1] = currentSpell.GetName()
                                endif
                            ;debug.notification("PlayerRef current spell duration for "+currentSpell.GetName()+" is "+currentSpell.GetNthEffectDuration(currentSpell.GetNumEffects() - 1))
                            ;endif
                        ;endif
                    endif
                    i=i+1
                        
                endwhile
                /;
            endif
            iteratorB=iteratorB+1
        endWhile
    endif

    outputString = currentStringArrayToSingleString(SpellStringArray)
    if outputString != ""
        SKSE_HTTP.setString(customContextHandle, mConsts.KEY_CONTEXT_NPC_SPELL_LIST, outputString)
    endif
    ;while i < PlayerRef.GetNumItems() 
    ;    Form currentForm = PlayerRef.GetNthForm (i)
    ;    debug.notification("Current form is "+currentForm.GetName())
    ;    if currentForm.gettype() == 22 || currentForm.gettype() == 82 
    ;        Spell currentSpell = currentForm as Spell
    ;        debug.notification("PlayerRef current spell name is "+currentSpell.GetName())
    ;        debug.notification("PlayerRef current spell equiptype is "+currentSpell.getequiptype())
    ;        debug.notification("PlayerRef current spell duration is "+currentSpell.GetNthEffectDuration(currentSpell.GetNumEffects() - 1))
    ;    endif
    ;    i=i+1
    ;endwhile

EndEvent

;;;;;;;;;;;;;;;;;;;;
;;;;;;;Utility;;;;;;
;;;;;;;;;;;;;;;;;;;;


string[] Function RetrieveTargetIDFunctionInferenceValues(int handle)
    string[] targetIDs = SKSE_HTTP.getStringArray(handle, mConsts.FUNCTION_DATA_TARGET_IDS)
    return targetIDs
EndFunction

Form[] Function FilterActorFormArrayFromIDs(string[] IDArray, Form[] ActorFormArray)
    actor currentactor
    Form[] filteredArray = Utility.CreateFormArray(0)
    int i = 0
    While i < IDArray.Length
        currentactor = repository.getActorFromArray(IDArray[i], ActorFormArray)
        if currentactor
            filteredArray = Utility.ResizeFormArray(filteredArray, filteredArray.Length + 1)
            filteredArray[filteredArray.Length - 1] = CurrentActor
        endif
        i += 1
    EndWhile
    return filteredArray
EndFunction

Function ResetFunctionReferencesAndAIForQuest(Quest QuestToReset)
    If (QuestToReset.IsRunning())
        ;Debug.Notification("Stopping MantellaConversationParticipantsQuest")
        QuestToReset.Stop()
    EndIf
    ;Debug.Notification("Starting MantellaConversationParticipantsQuest to asign QuestAlias")
    QuestToReset.Start()
EndFunction



Event OnUpdate()
    Form[] currentParticipants = conversation.GetParticipantsFormArray()
    int i = 0
    bool MantellaLootQuestToUpdate=false
    bool MantellaLootConsumablesQuestUpdate=false
    while i < currentParticipants.Length
        Actor CurrentActor = currentParticipants[i] as Actor
        if CurrentActor.GetFactionRank(MantellaFunctionSourceFaction) == 3 ;Check if an actor is still looting
            If CurrentActor.IsOverEncumbered()
                debug.notification(CurrentActor.GetDisplayName()+" cannot scavenge anymore because they are overemcumbered.") 
                CurrentActor.setFactionRank(MantellaFunctionSourceFaction, 0) ;Setting Source Faction rank to 0 which means "wait" 
                conversation.CauseReassignmentOfParticipantAlias() ;Forcing participant to wait
                return
            Else
                bool IsActorInSamePosition = conversation.CompareAndUpdateStoredActorPosition(CurrentActor)  
                if IsActorInSamePosition
                    if currentActor.GetFactionRank(MantellaFunctionModeFaction)==4 
                        MantellaLootConsumablesQuestUpdate=true ;Forcing participant to start looting again of if they haven't moved recently
                    else
                        MantellaLootQuestToUpdate=true
                    endif
                    RegisterForSingleUpdate(4)
                else
                    RegisterForSingleUpdate(4)
                endif
            EndIf
        endif
        i = i+1
    endwhile
    if MantellaLootQuestToUpdate
        ResetFunctionReferencesAndAIForQuest(MantellaLootQuest) 
    endif
    if MantellaLootConsumablesQuestUpdate
        ResetFunctionReferencesAndAIForQuest(MantellaLootConsumablesQuest)
    endif
EndEvent

String Function currentStringArrayToSingleString (String[] currentStringArray)
    string StringOutput
    int i = 0
    While i < currentStringArray.Length
        String currentString = currentStringArray[i]
        StringOutput += "["+currentString+"]"
        if i != (currentStringArray.Length - 1)
            StringOutput += ","
        endif
        i += 1
    EndWhile
    return StringOutput
Endfunction

Bool Function checkStringArrayForDuplicates (string currentString, String[] currentStringArray)
    int i = 0
    While i < currentStringArray.Length
        if currentString == currentStringArray[i]
            return true
        endif
        i += 1
    EndWhile
    return false
Endfunction

Spell Function GetSpellFromActor (string SpellNameToFind, actor currentActor)
    actorbase CurrentActorBase = currentActor.GetActorBase()
    int i = 0
    while i < CurrentActorBase.GetSpellCount() 
        Spell currentSpell = CurrentActorBase.GetNthSpell(i)
        if currentSpell.getName() == SpellNameToFind
            return currentSpell
        endif
        i=i+1
    endwhile
    while i < currentActor.GetSpellCount() 
        Spell currentSpell = currentActor.GetNthSpell(i)
        if currentSpell.getName() == SpellNameToFind
            return currentSpell
        endif
        i=i+1
    endwhile

Endfunction

Spell Function ReturnSpellFromArray (int ArrayPosition)
    return SpellInUseArray[ArrayPosition]
EndFunction

Int Function StoreSpellInArrayAndUpdatePosition (Spell SpellToStore)
    int ArrayPosition = SpellInUseIterator
    SpellInUseArray[ArrayPosition] = SpellToStore
    if SpellInUseIterator < SpellInUseArray.Length
        SpellInUseIterator=SpellInUseIterator + 1
    else
        SpellInUseIterator=0
    endif
    return ArrayPosition
EndFunction

Function AddIngameEventToConversation(string eventText)
    If (conversation.IsRunning())
        conversation.AddIngameEvent(eventText)
    EndIf
EndFunction
Scriptname MantellaRepository extends Quest Conditional

Actor Property PlayerRef Auto

Spell property MantellaSpell auto
Spell property MantellaRemoveNpcSpell auto
Spell Property MantellaEndSpell auto
;Faction Property giafac_Sitters  Auto ;gia
;Faction Property giafac_Sleepers  Auto ;gia
;Faction Property giafac_talktome  Auto ;gia
Faction Property giafac_AllowFollower  Auto ;gia
Faction Property giafac_AllowAnger  Auto ;gia
;Faction Property giafac_AllowForgive  Auto ;gia
Faction Property fac_AllowInventory  Auto
Faction Property giafac_AllowDialogue  Auto ;gia
Faction Property giafac_Following  Auto ;gia
Faction Property giafac_Mantella  Auto ;gia
quest property gia_FollowerQst auto ;gia


bool property microphoneEnabled auto
bool property useHotkeyToStartMic auto
float property MantellaEffectResponseTimer auto
bool property showReminderMessages auto

int property MantellaStartHotkey auto
int property MantellaListenerTextHotkey auto
int property MantellaEndHotkey auto
int property MantellaCustomGameEventHotkey auto
int property MantellaRadiantHotkey auto

bool property showDialogueItems auto Conditional

bool property radiantEnabled auto
float property radiantDistance auto
float property radiantFrequency auto
bool property showRadiantDialogueMessages auto

string property playerCharacterDescription1 auto
string property playerCharacterDescription2 auto
bool property playerCharacterUsePlayerDescription2 auto
bool property playerCharacterVoicePlayerInput auto
string property playerCharacterVoiceModel auto
bool property playerTrackingUsePCName auto


bool property playerTrackingOnItemAdded auto
bool property playerTrackingOnItemRemoved auto
bool property playerTrackingOnSpellCast auto
bool property playerTrackingOnHit auto
bool property playerTrackingOnObjectEquipped auto
bool property playerTrackingOnObjectUnequipped auto
bool property playerTrackingOnPlayerBowShot auto
bool property playerTrackingOnSit auto
bool property playerTrackingOnGetUp auto

bool property playerTrackingOnLocationChange auto
bool property playerTrackingOnTimeChange auto
bool property playerTrackingOnWeatherChange auto


bool property playerEquipmentBody auto
bool property playerEquipmentHead auto
bool property playerEquipmentHands auto
bool property playerEquipmentFeet auto
bool property playerEquipmentAmulet auto
bool property playerEquipmentRightHand auto
bool property playerEquipmentLeftHand auto

int property worldID auto


bool property targetTrackingItemAdded auto 
bool property targetTrackingItemRemoved auto
bool property targetTrackingOnSpellCast auto
bool property targetTrackingOnHit auto
bool property targetTrackingOnCombatStateChanged auto
bool property targetTrackingOnObjectEquipped auto
bool property targetTrackingOnObjectUnequipped auto
bool property targetTrackingOnSit auto
bool property targetTrackingOnGetUp auto
bool property targetTrackingAngerState auto

bool property targetEquipmentBody auto
bool property targetEquipmentHead auto
bool property targetEquipmentHands auto
bool property targetEquipmentFeet auto
bool property targetEquipmentAmulet auto
bool property targetEquipmentRightHand auto
bool property targetEquipmentLeftHand auto


bool property AllowForNPCtoFollow auto ;gia
;bool property followingNPCsit auto ;gia
;bool property followingNPCsleep auto ;gia
;bool property NPCstopandTalk auto ;gia
bool property NPCAnger auto ;gia
bool property NPCInventory auto
bool property NPCPackage auto Conditional
;bool property NPCForgive auto ;gia
bool property NPCDialogue auto ;gia

bool property NPCdebugSelectModeEnabled auto
; bool restartMantellaExe = False
int property HttpPort auto

;function calling
;function calling parameters
bool property allowFunctionCalling auto Conditional
bool property allowEventCompatibilityMode auto
float property maxFunctionCallingTargetCount auto
Quest Property MantellaFunctionNPCCollectionQuest Auto 
Form[] Property MantellaFunctionInferenceActorList  Auto
String Property MantellaFunctionInferenceActorNamesList  Auto
String Property MantellaFunctionInferenceActorDistanceList  Auto
String Property MantellaFunctionInferenceActorIDsList  Auto
bool property allowExternalCustomContextUpdateEventSignaling Auto
float property externalCustomContextEventWaitTime Auto
;bool property isAParticipantInteractingWithGroundItems auto conditional

event OnInit()
    assignDefaultSettings(0, true)
endEvent

; event OnUpdate()
;     If (restartMantellaExe)
;         restartMantellaExe = false
;         MantellaLauncher.LaunchMantellaExe()
;     EndIf
; endEvent

; lastVersion is the previous MCM version number defined in 'MantellaMCM.psc' before the new update is applied.
; Whenever a new repository value OR a new MCM setting is added, up the MCM version number returned by `ManatellaMCM.GetVersion()`
; and add the corresponding default value here in a block corresponding to the version number like the examples below
; Doing it like this will only assign the defaul values to settings that haven't been initialised prior.
function assignDefaultSettings(int lastVersion, bool isFirstInit = false)
    If (lastVersion < 6 || isFirstInit)
        NPCInventory = false
    EndIf
    If (lastVersion < 5 || isFirstInit)
        showReminderMessages = true
    EndIf
    If (lastVersion < 4 || isFirstInit)
        playerTrackingOnTimeChange = true
        playerTrackingOnWeatherChange = true
    EndIf
    If (lastVersion < 3 || isFirstInit)
        worldID = 1
    EndIf
    If (lastVersion < 2 || isFirstInit)
        showRadiantDialogueMessages = true
    EndIf
    If (lastVersion < 1 || isFirstInit)
        microphoneEnabled = true
        useHotkeyToStartMic = false
        MantellaEffectResponseTimer = 180

        MantellaStartHotkey = -1
        MantellaListenerTextHotkey = 35
        BindPromptHotkey(MantellaListenerTextHotkey)
        MantellaEndHotkey = -1
        MantellaCustomGameEventHotkey = -1
        MantellaRadiantHotkey = -1

        showDialogueItems = true

        radiantEnabled = false
        radiantDistance = 20
        radiantFrequency = 10


        playerCharacterDescription1 = ""
        playerCharacterDescription2 = ""
        playerCharacterUsePlayerDescription2 = false
        playerCharacterVoicePlayerInput = false
        playerCharacterVoiceModel = ""
        playerTrackingUsePCName = true

        
        playerTrackingOnItemAdded = true
        playerTrackingOnItemRemoved = true
        playerTrackingOnSpellCast = true
        playerTrackingOnHit = true
        playerTrackingOnLocationChange = true
        playerTrackingOnObjectEquipped = true
        playerTrackingOnObjectUnequipped = true
        playerTrackingOnPlayerBowShot = true
        playerTrackingOnSit = true
        playerTrackingOnGetUp = true

        playerEquipmentBody = true
        playerEquipmentHead = true
        playerEquipmentHands = true
        playerEquipmentFeet = true
        playerEquipmentAmulet = true
        playerEquipmentRightHand = true
        playerEquipmentLeftHand = true


        targetTrackingItemAdded = true
        targetTrackingItemRemoved = true
        targetTrackingOnSpellCast = true
        targetTrackingOnHit = true
        targetTrackingOnCombatStateChanged = true
        targetTrackingOnObjectEquipped = true
        targetTrackingOnObjectUnequipped = true
        targetTrackingOnSit = true
        targetTrackingOnGetUp = true
        targetTrackingAngerState = true

        targetEquipmentBody = true
        targetEquipmentHead = true
        targetEquipmentHands = true
        targetEquipmentFeet = true
        targetEquipmentAmulet = true
        targetEquipmentRightHand = true
        targetEquipmentLeftHand = true
        

	;followingNPCsit = false ;gia
	;followingNPCsleep = false ;gia
	;NPCstopandTalk = false ;gia
	AllowForNPCtoFollow = false ;gia
	NPCAnger = false ;gia
    NPCPackage = true
	;NPCForgive = false ;gia
	NPCDialogue = True ;gia
    
    NPCdebugSelectModeEnabled = false

    ;initializing function calling functions:
    allowFunctionCalling = false
    allowEventCompatibilityMode = false
    maxFunctionCallingTargetCount = 10
    allowExternalCustomContextUpdateEventSignaling = true
    externalCustomContextEventWaitTime = 0.15

        HttpPort = 4999
    EndIf
endFunction

function BindStartAddHotkey(int keyCode)
    ;used by the MCM_GeneralSettings when updating the start hotkey KeyMapChange
    UnregisterForKey(MantellaStartHotkey)
    MantellaStartHotkey=keyCode
    RegisterForKey(keyCode)
endfunction

function BindPromptHotkey(int keyCode)
    ;used by the MCM_GeneralSettings when updating the prompt hotkey KeyMapChange
    UnregisterForKey(MantellaListenerTextHotkey)
    MantellaListenerTextHotkey=keyCode
    RegisterForKey(keyCode)
endfunction

function BindEndHotkey(int keyCode)
    ;used by the MCM_GeneralSettings when updating the end hotkey KeyMapChange
    UnregisterForKey(MantellaEndHotkey)
    MantellaEndHotkey=keyCode
    RegisterForKey(keyCode)
endfunction

function BindCustomGameEventHotkey(int keyCode)
    ;used by the MCM_GeneralSettings when updating the custom game event hotkey KeyMapChange
    UnregisterForKey(MantellaCustomGameEventHotkey)
    MantellaCustomGameEventHotkey=keyCode
    RegisterForKey(keyCode)
endfunction

function BindRadiantHotkey(int keyCode)
    ;used by the MCM_GeneralSettings when updating the prompt hotkey KeyMapChange
    UnregisterForKey(MantellaRadiantHotkey)
    MantellaRadiantHotkey=keyCode
    RegisterForKey(keyCode)
endfunction

bool Function IsVR()
    return Debug.GetVersionNumber() == "1.4.15.0"
EndFunction

bool function restartMantellaExe()
    ; restartMantellaExe = true
    ; RegisterForSingleUpdate(1)
    MantellaLauncher.LaunchMantellaExe() 
    ;Note: If you need to debug this call to the SKSE plugin, you need to call it from the commented out single update above instead
    ;      or the VS debugger will crash (due to being called from the MCM thread?).
    ;      Check the corresponding commented out OnUpdate at the beginning of the script.
EndFunction

Event OnKeyDown(int KeyCode)
    ;this function was previously in MantellaListener Script back in Mantella 0.9.2
	;this ensures the right key is pressed and only activated while not in menu mode
    if !utility.IsInMenuMode()
        if KeyCode == MantellaStartHotkey
            Actor targetRef = (Game.GetCurrentCrosshairRef() as actor)            
            if (targetRef) ;If we have a target under the crosshair, cast sepll on it
                MantellaSpell.cast(PlayerRef, targetRef)
                ;Utility.Wait(0.5)
            endIf        
        elseIf KeyCode == MantellaListenerTextHotkey
            If(!microphoneEnabled) ;Otherwise, try to open player text input if microphone is off
                MantellaConversation conversation = Quest.GetQuest("MantellaConversation") as MantellaConversation
                if(conversation.IsRunning())
                    conversation.GetPlayerTextInput()
                endIf
            elseIf (useHotkeyToStartMic)
                MantellaConversation conversation = Quest.GetQuest("MantellaConversation") as MantellaConversation
                if(conversation.IsRunning())
                    conversation.sendRequestForVoiceTranscribe()
                endIf
            endIf
        elseIf KeyCode == MantellaEndHotkey
            Actor targetRef = (Game.GetCurrentCrosshairRef() as actor)            
            if (targetRef) ;If we have a target under the crosshair, cast sepll on it
                MantellaRemoveNpcSpell.cast(PlayerRef, targetRef)
            else
                MantellaEndSpell.cast(PlayerRef)
            endIf
        elseIf KeyCode == MantellaCustomGameEventHotkey
            MantellaConversation conversation = Quest.GetQuest("MantellaConversation") as MantellaConversation
            if(conversation.IsRunning())
                UIExtensions.InitMenu("UITextEntryMenu")
                UIExtensions.OpenMenu("UITextEntryMenu")
                string gameEventEntry = UIExtensions.GetMenuResultString("UITextEntryMenu")
                if (gameEventEntry && gameEventEntry != "")
                    gameEventEntry = gameEventEntry+"\n"
                    conversation.AddIngameEvent(gameEventEntry)
                endIf
            endIf
        elseIf KeyCode == MantellaRadiantHotkey
            radiantEnabled =! radiantEnabled
            if radiantEnabled == True
                Debug.Notification("Radiant Dialogue enabled.")
            else
                Debug.Notification("Radiant Dialogue disabled.")
            endIf
        endIf
    endIf
endEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   LLM Function Calling Functions   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function resetFunctionInferenceNPCArrays()
    MantellaFunctionInferenceActorNamesList=""
    MantellaFunctionInferenceActorDistanceList=""
    MantellaFunctionInferenceActorIDsList=""
Endfunction

Function UpdateFunctionInferenceNPCArrays(Form[] CurrentArray) 
    Float[] currentDistanceArray = Utility.CreateFloatArray(0)
    String[] currentFormIDArray =  Utility.CreateStringArray(0)
    MantellaFunctionInferenceActorList = Utility.CreateFormArray(0) 
    int icount = CurrentArray.Length
    int iindex = 0
    while (iindex < icount) && (iindex < maxFunctionCallingTargetCount)
        Actor CurrentActor = CurrentArray[iindex] as Actor
        float currentDistance = playerRef.GetDistance(CurrentActor)
        string currentFormID = CurrentActor.GetFormID() as string
        MantellaFunctionInferenceActorList =  Utility.ResizeFormArray(MantellaFunctionInferenceActorList, (MantellaFunctionInferenceActorList.Length+1))
        MantellaFunctionInferenceActorList[MantellaFunctionInferenceActorList.Length - 1] = CurrentArray[iindex] as Form
        currentDistanceArray =  Utility.ResizeFloatArray(currentDistanceArray, (currentDistanceArray.Length+1))
        currentDistanceArray[currentDistanceArray.Length - 1] = currentDistance
        currentFormIDArray =  Utility.ResizeStringArray(currentFormIDArray, (currentFormIDArray.Length+1))
        currentFormIDArray[currentFormIDArray.Length - 1] = currentDistance
        iindex = iindex + 1
    endwhile
    MantellaFunctionInferenceActorNamesList=FormArrayToString(CurrentArray)
    MantellaFunctionInferenceActorDistanceList = currentDistanceArrayToString(currentDistanceArray)
    MantellaFunctionInferenceActorIDsList = ActorsArrayToFormIDString(CurrentArray)
Endfunction
;;;;;;;;;;


Form[] Function ScanAndReturnNearbyActorsAsForm(quest QuestForScan, bool addPlayerToo) 
    Form[] ActorsInCell = Utility.CreateFormArray(0)
    QuestForScan.start()
    Utility.Wait(0.1)
    int icount = QuestForScan.GetNumAliases() 
    int iindex = 0
    if addPlayerToo
        ActorsInCell = Utility.ResizeFormArray(ActorsInCell, ActorsInCell.Length + 1)
        ActorsInCell[ActorsInCell.Length - 1] = game.getplayer() as Actor
    endif
    while (iindex < icount)
        ReferenceAlias CurrentAlias = QuestForScan.GetNthAlias(iindex) as ReferenceAlias
        ObjectReference CurrentActorRef = CurrentAlias.GetReference() 
        Actor currentActor = CurrentActorRef as actor
        ActorsInCell = Utility.ResizeFormArray(ActorsInCell, ActorsInCell.Length + 1)
        ActorsInCell[ActorsInCell.Length - 1] = CurrentActor
        iindex = iindex + 1
        ;debug.notification("Scanned Actor : "+CurrentActor.GetDisplayName())
    endwhile
    
    QuestForScan.stop()
    return ActorsInCell
Endfunction

Form[] Function GetFunctionInferenceActorList()  
    return ScanAndReturnNearbyActorsAsForm(MantellaFunctionNPCCollectionQuest, addPlayerToo=true)
Endfunction 

String Function FormArrayToString (Form[] CurrentArray)
    string StringOutput
    int i = 0
    string currentActorName =""
    While i < CurrentArray.Length
        Actor currentActor = CurrentArray[i] as actor
        currentActorName = currentActor.GetDisplayName()
        StringOutput += "["+currentActorName+"]"
        if i != (CurrentArray.Length - 1)
            StringOutput += ","
        endif
        i += 1
    EndWhile
    return StringOutput
Endfunction

String Function currentDistanceArrayToString (Float[] currentDistanceArray)
    string StringOutput
    int i = 0
    While i < currentDistanceArray.Length
        float currentDistance = currentDistanceArray[i]
        StringOutput += "["+currentDistance+"]"
        if i != (currentDistanceArray.Length - 1)
            StringOutput += ","
        endif
        i += 1
    EndWhile
    return StringOutput
Endfunction

String Function ActorsArrayToFormIDString (Form[] CurrentArray)
    string StringOutput
    int i = 0
    string currentActorFormID =""
    While i < CurrentArray.Length
        Actor currentActor = CurrentArray[i] as actor
        currentActorFormID = currentActor.GetFormID()
        StringOutput += "["+currentActorFormID+"]"
        if i != (CurrentArray.Length - 1)
            StringOutput += ","
        endif
        i += 1
    EndWhile
    return StringOutput
Endfunction

Actor Function getActorFromArray(string targetID, Form[] actorFormArray)
    int i = 0
    int convertedTargetID = targetID as int
    While i < actorFormArray.Length
        Actor currentActor = actorFormArray[i] as actor
        if currentActor.GetFormID() == convertedTargetID
            return currentActor
        endIf
        i += 1
    EndWhile
    return none
Endfunction

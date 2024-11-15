-- -------------------------------------------------------------------------- --

ModuleBuildingButtons = {
    Properties = {
        Name = "ModuleBuildingButtons",
        Version = "3.0.0 (BETA 2.0.0)",
    },

    Global = {
        Data = {},
    },

    Local = {
        Data = {
            Button = {
                SingleStop = nil,
                SingleReserve = nil,
                SingleKnockDown = nil,
            },
            DowngradeCosts = 0,
        },
        BuildingButtons = {
            BindingCounter = 0,
            Bindings = {},
            Configuration = {
                ["BuyAmmunitionCart"] = {
                    TypeExclusion = "^B_.*StoreHouse",
                    OriginalPosition = nil,
                    Bind = nil,
                },
                ["BuyBattallion"] = {
                    TypeExclusion = "^B_[CB]a[sr][tr][la][ec]",
                    OriginalPosition = nil,
                    Bind = nil,
                },
                ["PlaceField"] = {
                    TypeExclusion = "^B_.*[BFH][aei][erv][kme]",
                    OriginalPosition = nil,
                    Bind = nil,
                },
                ["StartFestival"] = {
                    TypeExclusion = "^B_Marketplace",
                    OriginalPosition = nil,
                    Bind = nil,
                },
                ["StartTheatrePlay"] = {
                    TypeExclusion = "^B_Theatre",
                    OriginalPosition = nil,
                    Bind = nil,
                },
                ["UpgradeTurret"] = {
                    TypeExclusion = "^B_WallTurret",
                    OriginalPosition = nil,
                    Bind = nil,
                },
                ["BuyBatteringRamCart"] = {
                    TypeExclusion = "^B_SiegeEngineWorkshop",
                    OriginalPosition = nil,
                    Bind = nil,
                },
                ["BuyCatapultCart"] = {
                    TypeExclusion = "^B_SiegeEngineWorkshop",
                    OriginalPosition = nil,
                    Bind = nil,
                },
                ["BuySiegeTowerCart"] = {
                    TypeExclusion = "^B_SiegeEngineWorkshop",
                    OriginalPosition = nil,
                    Bind = nil,
                },
            },
        },
    },

    Shared = {};
}

-- Global ------------------------------------------------------------------- --

function ModuleBuildingButtons.Global:OnGameStart()
    QSB.ScriptEvents.UpgradeCanceled = API.RegisterScriptEvent("Event_UpgradeCanceled");
    QSB.ScriptEvents.UpgradeStarted = API.RegisterScriptEvent("Event_UpgradeStarted");
    QSB.ScriptEvents.FestivalStarted = API.RegisterScriptEvent("Event_FestivalStarted");
    QSB.ScriptEvents.SermonStarted = API.RegisterScriptEvent("Event_SermonStarted");
    QSB.ScriptEvents.TheatrePlayStarted = API.RegisterScriptEvent("Event_TheatrePlayStarted");

    -- Building upgrade started event
    API.RegisterScriptCommand("Cmd_StartBuildingUpgrade", function(_BuildingID, _PlayerID)
        if Logic.IsBuildingBeingUpgraded(_BuildingID) then
            ModuleBuildingButtons.Global:SendStartBuildingUpgradeEvent(_BuildingID, _PlayerID);
        end
    end);
    -- Building upgrade canceled event
    API.RegisterScriptCommand("Cmd_CancelBuildingUpgrade", function(_BuildingID, _PlayerID)
        if not Logic.IsBuildingBeingUpgraded(_BuildingID) then
            ModuleBuildingButtons.Global:SendCancelBuildingUpgradeEvent(_BuildingID, _PlayerID);
        end
    end);
    -- Theatre play started event
    API.RegisterScriptCommand("Cmd_StartTheatrePlay", function(_BuildingID, _PlayerID)
        if Logic.GetTheatrePlayProgress(_BuildingID) ~= 0 then
            ModuleBuildingButtons.Global:SendTheatrePlayEvent(_BuildingID, _PlayerID);
        end
    end);
    -- Festival started event
    API.RegisterScriptCommand("Cmd_StartRegularFestival", function(_PlayerID)
        if Logic.IsFestivalActive(_PlayerID) == true then
            ModuleBuildingButtons.Global:SendStartRegularFestivalEvent(_PlayerID);
        end
    end);
    -- Sermon started event
    API.RegisterScriptCommand("Cmd_StartSermon", function(_PlayerID)
        if Logic.IsSermonActive(_PlayerID) == true then
            ModuleBuildingButtons.Global:SendStartSermonEvent(_PlayerID);
        end
    end);
end

function ModuleBuildingButtons.Global:OnEvent(_ID, ...)
    if _ID == QSB.ScriptEvents.LoadscreenClosed then
        self.LoadscreenClosed = true;
    end
end

function ModuleBuildingButtons.Global:SendStartBuildingUpgradeEvent(_BuildingID, _PlayerID)
    API.SendScriptEvent(QSB.ScriptEvents.UpgradeStarted, _BuildingID, _PlayerID);
    Logic.ExecuteInLuaLocalState(string.format(
        [[API.SendScriptEvent(QSB.ScriptEvents.UpgradeStarted, %d, %d)]],
        _BuildingID,
        _PlayerID
    ));
end

function ModuleBuildingButtons.Global:SendCancelBuildingUpgradeEvent(_BuildingID, _PlayerID)
    API.SendScriptEvent(QSB.ScriptEvents.UpgradeCanceled, _BuildingID, _PlayerID);
    Logic.ExecuteInLuaLocalState(string.format(
        [[API.SendScriptEvent(QSB.ScriptEvents.UpgradeCanceled, %d, %d)]],
        _BuildingID,
        _PlayerID
    ));
end

function ModuleBuildingButtons.Global:SendTheatrePlayEvent(_BuildingID, _PlayerID)
    API.SendScriptEvent(QSB.ScriptEvents.TheatrePlayStarted, _BuildingID, _PlayerID);
    Logic.ExecuteInLuaLocalState(string.format(
        [[API.SendScriptEvent(QSB.ScriptEvents.TheatrePlayStarted, %d, %d)]],
        _BuildingID,
        _PlayerID
    ));
end

function ModuleBuildingButtons.Global:SendStartRegularFestivalEvent(_PlayerID)
    API.SendScriptEvent(QSB.ScriptEvents.FestivalStarted, _PlayerID);
    Logic.ExecuteInLuaLocalState(string.format(
        [[API.SendScriptEvent(QSB.ScriptEvents.FestivalStarted, %d)]],
        _PlayerID
    ));
end

function ModuleBuildingButtons.Global:SendStartSermonEvent(_PlayerID)
    API.SendScriptEvent(QSB.ScriptEvents.SermonStarted, _PlayerID);
    Logic.ExecuteInLuaLocalState(string.format(
        [[API.SendScriptEvent(QSB.ScriptEvents.SermonStarted, %d)]],
        _PlayerID
    ));
end

-- Local -------------------------------------------------------------------- --

function ModuleBuildingButtons.Local:OnGameStart()
    QSB.ScriptEvents.UpgradeCanceled = API.RegisterScriptEvent("Event_UpgradeCanceled");
    QSB.ScriptEvents.UpgradeStarted = API.RegisterScriptEvent("Event_UpgradeStarted");
    QSB.ScriptEvents.FestivalStarted = API.RegisterScriptEvent("Event_FestivalStarted");
    QSB.ScriptEvents.SermonStarted = API.RegisterScriptEvent("Event_SermonStarted");
    QSB.ScriptEvents.TheatrePlayStarted = API.RegisterScriptEvent("Event_TheatrePlayStarted");

    self:InitBackupPositions();
    self:OverrideOnSelectionChanged();
    self:OverrideBuyAmmunitionCart();
    self:OverrideBuyBattalion();
    self:OverrideBuySiegeEngineCart();
    self:OverridePlaceField();
    self:OverrideStartFestival();
    self:OverrideStartTheatrePlay();
    self:OverrideUpgradeTurret();
    self:OverrideUpgradeBuilding();
    self:OverrideStartSermon();
end

function ModuleBuildingButtons.Local:OnEvent(_ID, ...)
    if _ID == QSB.ScriptEvents.LoadscreenClosed then
        self.LoadscreenClosed = true;
    end
end

-- -------------------------------------------------------------------------- --

function ModuleBuildingButtons.Local:OverrideOnSelectionChanged()
    GameCallback_GUI_SelectionChanged_Orig_Interface = GameCallback_GUI_SelectionChanged;
    GameCallback_GUI_SelectionChanged = function(_Source)
        GameCallback_GUI_SelectionChanged_Orig_Interface(_Source);
        ModuleBuildingButtons.Local:UnbindButtons();
        ModuleBuildingButtons.Local:BindButtons(GUI.GetSelectedEntity());
    end
end

function ModuleBuildingButtons.Local:OverrideBuyAmmunitionCart()
    GUI_BuildingButtons.BuyAmmunitionCartClicked_Orig_Interface = GUI_BuildingButtons.BuyAmmunitionCartClicked;
    GUI_BuildingButtons.BuyAmmunitionCartClicked = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        if not Button then
            return GUI_BuildingButtons.BuyAmmunitionCartClicked_Orig_Interface();
        end
        Button.Action(WidgetID, EntityID);
    end

    GUI_BuildingButtons.BuyAmmunitionCartUpdate_Orig_Interface = GUI_BuildingButtons.BuyAmmunitionCartUpdate;
    GUI_BuildingButtons.BuyAmmunitionCartUpdate = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        if not Button then
            SetIcon(WidgetID, {10, 4});
            XGUIEng.ShowWidget(WidgetID, 1);
            XGUIEng.DisableButton(WidgetID, 0);
            return GUI_BuildingButtons.BuyAmmunitionCartUpdate_Orig_Interface();
        end
        Button.Update(WidgetID, EntityID);
    end
end

function ModuleBuildingButtons.Local:OverrideBuyBattalion()
    GUI_BuildingButtons.BuyBattalionClicked_Orig_Interface = GUI_BuildingButtons.BuyBattalionClicked;
    GUI_BuildingButtons.BuyBattalionClicked = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        if not Button then
            return GUI_BuildingButtons.BuyBattalionClicked_Orig_Interface();
        end
        Button.Action(WidgetID, EntityID);
    end

    GUI_BuildingButtons.BuyBattalionMouseOver_Orig_Interface = GUI_BuildingButtons.BuyBattalionMouseOver;
    GUI_BuildingButtons.BuyBattalionMouseOver = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button;
        if ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName] then
            Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        end
        if not Button then
            return GUI_BuildingButtons.BuyBattalionMouseOver_Orig_Interface();
        end
        Button.Tooltip(WidgetID, EntityID);
    end

    GUI_BuildingButtons.BuyBattalionUpdate_Orig_Interface = GUI_BuildingButtons.BuyBattalionUpdate;
    GUI_BuildingButtons.BuyBattalionUpdate = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        if not Button then
            XGUIEng.ShowWidget(WidgetID, 1);
            XGUIEng.DisableButton(WidgetID, 0);
            return GUI_BuildingButtons.BuyBattalionUpdate_Orig_Interface();
        end
        Button.Update(WidgetID, EntityID);
    end
end

function ModuleBuildingButtons.Local:OverridePlaceField()
    GUI_BuildingButtons.PlaceFieldClicked_Orig_Interface = GUI_BuildingButtons.PlaceFieldClicked;
    GUI_BuildingButtons.PlaceFieldClicked = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        if not Button then
            return GUI_BuildingButtons.PlaceFieldClicked_Orig_Interface();
        end
        Button.Action(WidgetID, EntityID);
    end

    GUI_BuildingButtons.PlaceFieldMouseOver_Orig_Interface = GUI_BuildingButtons.PlaceFieldMouseOver;
    GUI_BuildingButtons.PlaceFieldMouseOver = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        if not Button then
            return GUI_BuildingButtons.PlaceFieldMouseOver_Orig_Interface();
        end
        Button.Tooltip(WidgetID, EntityID);
    end

    GUI_BuildingButtons.PlaceFieldUpdate_Orig_Interface = GUI_BuildingButtons.PlaceFieldUpdate;
    GUI_BuildingButtons.PlaceFieldUpdate = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        if not Button then
            XGUIEng.ShowWidget(WidgetID, 1);
            XGUIEng.DisableButton(WidgetID, 0);
            return GUI_BuildingButtons.PlaceFieldUpdate_Orig_Interface();
        end
        Button.Update(WidgetID, EntityID);
    end
end

function ModuleBuildingButtons.Local:OverrideStartFestival()
    GUI_BuildingButtons.StartFestivalClicked = function(_FestivalIndex)
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        if not Button then
            local PlayerID = GUI.GetPlayerID();
            local Costs = {Logic.GetFestivalCost(PlayerID, _FestivalIndex)};
            local CanBuyBoolean, CanNotBuyString = AreCostsAffordable(Costs);
            if EntityID ~= Logic.GetMarketplace(PlayerID) then
                return;
            end
            if CanBuyBoolean == true then
                Sound.FXPlay2DSound("ui\\menu_click");
                GUI.StartFestival(PlayerID, _FestivalIndex);
                StartEventMusic(MusicSystem.EventFestivalMusic, PlayerID);
                StartKnightVoiceForPermanentSpecialAbility(Entities.U_KnightSong);
                GUI.AddBuff(Buffs.Buff_Festival);
                API.BroadcastScriptCommand(QSB.ScriptCommands.StartRegularFestival, PlayerID);
            else
                Message(CanNotBuyString);
            end
            return;
        end
        Button.Action(WidgetID, EntityID);
    end

    GUI_BuildingButtons.StartFestivalMouseOver_Orig_Interface = GUI_BuildingButtons.StartFestivalMouseOver;
    GUI_BuildingButtons.StartFestivalMouseOver = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        if not Button then
            return GUI_BuildingButtons.StartFestivalMouseOver_Orig_Interface();
        end
        Button.Tooltip(WidgetID, EntityID);
    end

    GUI_BuildingButtons.StartFestivalUpdate_Orig_Interface = GUI_BuildingButtons.StartFestivalUpdate;
    GUI_BuildingButtons.StartFestivalUpdate = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        if not Button then
            SetIcon(WidgetID, {4, 15});
            XGUIEng.ShowWidget(WidgetID, 1);
            XGUIEng.DisableButton(WidgetID, 0);
            return GUI_BuildingButtons.StartFestivalUpdate_Orig_Interface();
        end
        Button.Update(WidgetID, EntityID);
    end
end

function ModuleBuildingButtons.Local:OverrideStartTheatrePlay()
    GUI_BuildingButtons.StartTheatrePlayClicked = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        if not Button then
            local PlayerID = GUI.GetPlayerID();
            local GoodType = Logic.GetGoodTypeOnOutStockByIndex(EntityID, 0);
            local Amount = Logic.GetMaxAmountOnStock(EntityID);
            local Costs = {GoodType, Amount};
            local CanBuyBoolean, CanNotBuyString = AreCostsAffordable(Costs);
            if Logic.CanStartTheatrePlay(EntityID) == true then
                Sound.FXPlay2DSound("ui\\menu_click");
                GUI.StartTheatrePlay(EntityID);
                API.BroadcastScriptCommand(QSB.ScriptCommands.StartTheatrePlay, EntityID, PlayerID);
            elseif CanBuyBoolean == false then
                Message(CanNotBuyString);
            end
            return;
        end
        Button.Action(WidgetID, EntityID);
    end

    GUI_BuildingButtons.StartTheatrePlayMouseOver_Orig_Interface = GUI_BuildingButtons.StartTheatrePlayMouseOver;
    GUI_BuildingButtons.StartTheatrePlayMouseOver = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        if not Button then
            return GUI_BuildingButtons.StartTheatrePlayMouseOver_Orig_Interface();
        end
        Button.Tooltip(WidgetID, EntityID);
    end

    GUI_BuildingButtons.StartTheatrePlayUpdate_Orig_Interface = GUI_BuildingButtons.StartTheatrePlayUpdate;
    GUI_BuildingButtons.StartTheatrePlayUpdate = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        if not Button then
            SetIcon(WidgetID, {16, 2});
            XGUIEng.ShowWidget(WidgetID, 1);
            XGUIEng.DisableButton(WidgetID, 0);
            return GUI_BuildingButtons.StartTheatrePlayUpdate_Orig_Interface();
        end
        Button.Update(WidgetID, EntityID);
    end
end

function ModuleBuildingButtons.Local:OverrideUpgradeTurret()
    GUI_BuildingButtons.UpgradeTurretClicked_Orig_Interface = GUI_BuildingButtons.UpgradeTurretClicked;
    GUI_BuildingButtons.UpgradeTurretClicked = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        if not Button then
            return GUI_BuildingButtons.UpgradeTurretClicked_Orig_Interface();
        end
        Button.Action(WidgetID, EntityID);
    end

    GUI_BuildingButtons.UpgradeTurretMouseOver_Orig_Interface = GUI_BuildingButtons.UpgradeTurretMouseOver;
    GUI_BuildingButtons.UpgradeTurretMouseOver = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        if not Button then
            return GUI_BuildingButtons.UpgradeTurretMouseOver_Orig_Interface();
        end
        Button.Tooltip(WidgetID, EntityID);
    end

    GUI_BuildingButtons.UpgradeTurretUpdate_Orig_Interface = GUI_BuildingButtons.UpgradeTurretUpdate;
    GUI_BuildingButtons.UpgradeTurretUpdate = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        if not Button then
            XGUIEng.ShowWidget(WidgetID, 1);
            XGUIEng.DisableButton(WidgetID, 0);
            return GUI_BuildingButtons.UpgradeTurretUpdate_Orig_Interface();
        end
        Button.Update(WidgetID, EntityID);
    end
end

function ModuleBuildingButtons.Local:OverrideBuySiegeEngineCart()
    GUI_BuildingButtons.BuySiegeEngineCartClicked_Orig_Interface = GUI_BuildingButtons.BuySiegeEngineCartClicked;
    GUI_BuildingButtons.BuySiegeEngineCartClicked = function(_EntityType)
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button;
        if WidgetName == "BuyCatapultCart"
        or WidgetName == "BuySiegeTowerCart"
        or WidgetName == "BuyBatteringRamCart" then
            Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        end
        if not Button then
            return GUI_BuildingButtons.BuySiegeEngineCartClicked_Orig_Interface(_EntityType);
        end
        Button.Action(WidgetID, EntityID);
    end

    GUI_BuildingButtons.BuySiegeEngineCartMouseOver_Orig_Interface = GUI_BuildingButtons.BuySiegeEngineCartMouseOver;
    GUI_BuildingButtons.BuySiegeEngineCartMouseOver = function(_EntityType, _Right)
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button;
        if WidgetName == "BuyCatapultCart"
        or WidgetName == "BuySiegeTowerCart"
        or WidgetName == "BuyBatteringRamCart" then
            Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        end
        if not Button then
            return GUI_BuildingButtons.BuySiegeEngineCartMouseOver_Orig_Interface(_EntityType, _Right);
        end
        Button.Tooltip(WidgetID, EntityID);
    end

    GUI_BuildingButtons.BuySiegeEngineCartUpdate_Orig_Interface = GUI_BuildingButtons.BuySiegeEngineCartUpdate;
    GUI_BuildingButtons.BuySiegeEngineCartUpdate = function(_EntityType)
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local WidgetName = XGUIEng.GetWidgetNameByID(WidgetID);
        local EntityID = GUI.GetSelectedEntity();
        local Button;
        if WidgetName == "BuyCatapultCart"
        or WidgetName == "BuySiegeTowerCart"
        or WidgetName == "BuyBatteringRamCart" then
            Button = ModuleBuildingButtons.Local.BuildingButtons.Configuration[WidgetName].Bind;
        end
        if not Button then
            if WidgetName == "BuyBatteringRamCart" then
                SetIcon(WidgetID, {9, 2});
            elseif WidgetName == "BuySiegeTowerCart" then
                SetIcon(WidgetID, {9, 3});
            elseif WidgetName == "BuyCatapultCart" then
                SetIcon(WidgetID, {9, 1});
            end
            XGUIEng.ShowWidget(WidgetID, 1);
            XGUIEng.DisableButton(WidgetID, 0);
            return GUI_BuildingButtons.BuySiegeEngineCartUpdate_Orig_Interface(_EntityType);
        end
        Button.Update(WidgetID, EntityID);
    end
end

function ModuleBuildingButtons.Local:OverrideUpgradeBuilding()
    GUI_BuildingButtons.UpgradeClicked = function()
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local EntityID = GUI.GetSelectedEntity();
        if Logic.CanCancelUpgradeBuilding(EntityID) then
            Sound.FXPlay2DSound("ui\\menu_click");
            GUI.CancelBuildingUpgrade(EntityID);
            XGUIEng.ShowAllSubWidgets("/InGame/Root/Normal/BuildingButtons", 1);
            API.BroadcastScriptCommand(QSB.ScriptCommands.CancelBuildingUpgrade, EntityID, GUI.GetPlayerID());
            return;
        end
        local Costs = GUI_BuildingButtons.GetUpgradeCosts();
        local CanBuyBoolean, CanNotBuyString = AreCostsAffordable(Costs);
        if CanBuyBoolean == true then
            Sound.FXPlay2DSound("ui\\menu_click");
            GUI.UpgradeBuilding(EntityID, nil);
            StartKnightVoiceForPermanentSpecialAbility(Entities.U_KnightWisdom);
            if WidgetID ~= 0 then
                SaveButtonPressed(WidgetID);
            end
            API.BroadcastScriptCommand(QSB.ScriptCommands.StartBuildingUpgrade, EntityID, GUI.GetPlayerID());
        else
            Message(CanNotBuyString);
        end
    end
end

function ModuleBuildingButtons.Local:OverrideStartSermon()
    function GUI_BuildingButtons.StartSermonClicked()
        local PlayerID = GUI.GetPlayerID();
        if Logic.CanSermonBeActivated(PlayerID) then
            GUI.ActivateSermon(PlayerID);
            StartKnightVoiceForPermanentSpecialAbility(Entities.U_KnightHealing);
            GUI.AddBuff(Buffs.Buff_Sermon);
            local CathedralID = Logic.GetCathedral(PlayerID);
            local x, y = Logic.GetEntityPosition(CathedralID);
            local z = 0;
            Sound.FXPlay3DSound("buildings\\building_start_sermon", x, y, z);
            API.BroadcastScriptCommand(QSB.ScriptCommands.StartSermon, GUI.GetPlayerID());
        end
    end
end

-- -------------------------------------------------------------------------- --

function ModuleBuildingButtons.Local:InitBackupPositions()
    for k, v in pairs(self.BuildingButtons.Configuration) do
        local x, y = XGUIEng.GetWidgetLocalPosition("/InGame/Root/Normal/BuildingButtons/" ..k);
        self.BuildingButtons.Configuration[k].OriginalPosition = {x, y};
    end
end

function ModuleBuildingButtons.Local:GetButtonsForOverwrite(_ID, _Amount)
    local Buttons = {};
    local Type = Logic.GetEntityType(_ID);
    local TypeName = Logic.GetEntityTypeName(Type);
    for k, v in pairs(self.BuildingButtons.Configuration) do
        if #Buttons == _Amount then
            break;
        end
        if not TypeName:find(v.TypeExclusion) then
            table.insert(Buttons, k);
        end
    end
    assert(#Buttons == _Amount);
    table.sort(Buttons);
    return Buttons;
end

function ModuleBuildingButtons.Local:AddButtonBinding(_Type, _X, _Y, _ActionFunction, _TooltipController, _UpdateController)
    if not self.BuildingButtons.Bindings[_Type] then
        self.BuildingButtons.Bindings[_Type] = {};
    end
    if #self.BuildingButtons.Bindings[_Type] < 6 then
        self.BuildingButtons.BindingCounter = self.BuildingButtons.BindingCounter +1;
        table.insert(self.BuildingButtons.Bindings[_Type], {
            ID       = self.BuildingButtons.BindingCounter,
            Position = {_X, _Y},
            Action   = _ActionFunction,
            Tooltip  = _TooltipController,
            Update   = _UpdateController,
        });
        return self.BuildingButtons.BindingCounter;
    end
    return 0;
end

function ModuleBuildingButtons.Local:RemoveButtonBinding(_Type, _ID)
    if not self.BuildingButtons.Bindings[_Type] then
        self.BuildingButtons.Bindings[_Type] = {};
    end
    for i= #self.BuildingButtons.Bindings[_Type], 1, -1 do
        if self.BuildingButtons.Bindings[_Type][i].ID == _ID then
            table.remove(self.BuildingButtons.Bindings[_Type], i);
        end
    end
end

function ModuleBuildingButtons.Local:BindButtons(_ID)
    if _ID == nil or _ID == 0 or (Logic.IsBuilding(_ID) == 0 and not Logic.IsWall(_ID)) then
        return self:UnbindButtons();
    end
    local Name = Logic.GetEntityName(_ID);
    local Type = Logic.GetEntityType(_ID);

    local WidgetsForOverride = self:GetButtonsForOverwrite(_ID, 6);
    local ButtonOverride = {};
    -- Add buttons for named entity
    if self.BuildingButtons.Bindings[Name] and #self.BuildingButtons.Bindings[Name] > 0 then
        for i= 1, #self.BuildingButtons.Bindings[Name] do
            table.insert(ButtonOverride, self.BuildingButtons.Bindings[Name][i]);
        end
    end
    -- Add buttons for named entity
    if self.BuildingButtons.Bindings[Type] and #self.BuildingButtons.Bindings[Type] > 0 then
        for i= 1, #self.BuildingButtons.Bindings[Type] do
            table.insert(ButtonOverride, self.BuildingButtons.Bindings[Type][i]);
        end
    end
    -- Add buttons for named entity
    if self.BuildingButtons.Bindings[0] and #self.BuildingButtons.Bindings[0] > 0 then
        for i= 1, #self.BuildingButtons.Bindings[0] do
            table.insert(ButtonOverride, self.BuildingButtons.Bindings[0][i]);
        end
    end

    -- Place first six buttons (if present)
    for i= 1, #ButtonOverride do
        if i > 6 then
            break;
        end
        local ButtonName = WidgetsForOverride[i];
        self.BuildingButtons.Configuration[ButtonName].Bind = ButtonOverride[i];
        XGUIEng.ShowWidget("/InGame/Root/Normal/BuildingButtons/" ..ButtonName, 1);
        XGUIEng.DisableButton("/InGame/Root/Normal/BuildingButtons/" ..ButtonName, 0);
        local X = ButtonOverride[i].Position[1];
        local Y = ButtonOverride[i].Position[2];
        if not X or not Y then
            local AnchorPosition = {12, 296};
            X = AnchorPosition[1] + (64 * (i-1));
            Y = AnchorPosition[2];
        end
        XGUIEng.SetWidgetLocalPosition("/InGame/Root/Normal/BuildingButtons/" ..ButtonName, X, Y);
    end
end

function ModuleBuildingButtons.Local:UnbindButtons()
    for k, v in pairs(self.BuildingButtons.Configuration) do
        local Position = self.BuildingButtons.Configuration[k].OriginalPosition;
        if Position then
            XGUIEng.SetWidgetLocalPosition("/InGame/Root/Normal/BuildingButtons/" ..k, Position[1], Position[2]);
        end
        self.BuildingButtons.Configuration[k].Bind = nil;
    end
end

function ModuleBuildingButtons.Local:AddSingleStopButton()
    if self.Data.Button.SingleStop then
        return
    end
    self.Data.Button.SingleStop = API.AddBuildingButton(
        function(_WidgetID, _BuildingID)
            local IsStopped = Logic.IsBuildingStopped(_BuildingID)
            GUI.SetStoppedState(_BuildingID, not IsStopped)
        end,
        function(_WidgetID, _BuildingID)
            local Title = {
                de = "Produktion anhalten",
                en = "Stop production",
                fr = "Arrêter la production",
            }
            local Text = {
                de = "- Gebäude produziert keine Waren {cr}- Siedler verbrauchen keine Güter {cr}- Bedürfnisse müssen nicht erfüllt werden",
                en = "- Building does not produce goods {cr}- Settlers do not consume goods {cr}- Needs do not have to be met",
                fr = "- le bâtiment ne produit pas de biens {cr}- les settlers ne consomment pas de biens {cr}- les besoins ne doivent pas être satisfaits",
            }
            if Logic.IsBuildingStopped(_BuildingID) then
                Title = {
                    de = "Produktion fortführen",
                    en = "Continue production",
                    fr = "Poursuivre la production",
                }
                Text = {
                    de = "- Gebäude produziert Waren {cr}- Siedler verbrauchen Güter {cr}- Bedürfnisse müssen erfüllt werden",
                    en = "- Building produces goods {cr}- settlers consume goods {cr}- needs must be met",
                    fr = "- Le bâtiment produit des biens {cr}- Les settlers consomment des biens {cr}- Les besoins doivent être satisfaits",
                }
            end
            API.SetTooltipCosts(Title, Text)
        end,
        function(_WidgetID, _BuildingID)
            if Logic.IsEntityInCategory(_BuildingID, EntityCategories.OuterRimBuilding) == 0
            and Logic.IsEntityInCategory(_BuildingID, EntityCategories.CityBuilding) == 0
            or Logic.IsConstructionComplete(_BuildingID) == 0 then
                XGUIEng.ShowWidget(_WidgetID, 0)
            else
                XGUIEng.ShowWidget(_WidgetID, 1)
            end
            if Logic.IsBuildingBeingUpgraded(_BuildingID)
            or Logic.IsBuildingBeingKnockedDown(_BuildingID)
            or Logic.IsBurning(_BuildingID) then
                XGUIEng.DisableButton(_WidgetID, 1)
            else
                XGUIEng.DisableButton(_WidgetID, 0)
            end
            SetIcon(_WidgetID, {4, 13})
            if Logic.IsBuildingStopped(_BuildingID) then
                SetIcon(_WidgetID, {4, 12})
            end
        end
    )
end

function ModuleBuildingButtons.Local:DropSingleStopButton()
    if self.Data.Button.SingleStop then
        API.DropBuildingButton(self.Data.Button.SingleStop)
        self.Data.Button.SingleStop = nil
    end
end

function ModuleBuildingButtons.Local:AddSingleReserveButton()
    if self.Data.Button.SingleReserve then
        return
    end
    self.Data.Button.SingleReserve = API.AddBuildingButton(
        function(_WidgetID, _BuildingID)

        end,
        function(WidgetID, _BuildingID)
            local Title = {
                de = "Produzierte Güter reservieren",
                en = "Reserve produced goods",
                fr = "Réserver les biens produits",
            }
            local Text = {
                de = "- Siedler fürfen keine Güter dieses Gebäudes konsumieren.{cr}- Güter sind für Verkauf oder Aufträge reserviert.",
                en = "- Settlers may not consume goods from this building.{cr}- Goods are reserved for sale or orders.",
                fr = "- Les Settlers ne peuvent pas consommer les biens de ce bâtiment {cr}- Les biens sont réservés à la vente ou aux commandes.",
            }
            if Logic.IsBuildingStopped(_BuildingID) then -- Change to reserviert
                Title = {
                    de = "Produzierte Güter freigeben",
                    en = "Release produced goods",
                    fr = "Partager les biens produits",
                }
                Text = {
                    de = "- Siedler fürfen Güter dieses Gebäudes konsumieren.",
                    en = "- Settlers may consume goods from this building.",
                    fr = "- Les Settlers peuvent consommer les biens de ce bâtiment.",
                }
            end
            API.SetTooltipCosts(Title, Text)
        end,
        function(_WidgetID, _BuildingID)
            if Logic.IsEntityInCategory(_BuildingID, EntityCategories.OuterRimBuilding) == 0
            and Logic.IsEntityInCategory(_BuildingID, EntityCategories.CityBuilding) == 0
            or Logic.IsConstructionComplete(_BuildingID) == 0 then
                XGUIEng.ShowWidget(_WidgetID, 0)
            else
                XGUIEng.ShowWidget(_WidgetID, 1)
            end
            if Logic.IsBuildingBeingUpgraded(_BuildingID)
            or Logic.IsBuildingBeingKnockedDown(_BuildingID)
            or Logic.IsBurning(_BuildingID) then
                XGUIEng.DisableButton(_WidgetID, 1)
            else
                XGUIEng.DisableButton(_WidgetID, 0)
            end
            SetIcon(_WidgetID, {10, 9})
            if Logic.IsBuildingStopped(_BuildingID) then -- Change to reserviert
                SetIcon(_WidgetID, {15, 6})
            end
        end
    )
end

function ModuleBuildingButtons.Local:DropSingleReserveButton()
    if self.Data.Button.SingleReserve then
        API.DropBuildingButton(self.Data.Button.SingleReserve)
        self.Data.Button.SingleReserve = nil
    end
end

function ModuleBuildingButtons.Local:AddSingleDowngradeButton()
    if self.Data.Button.SingleKnockDown then
        return
    end
    self.Data.Button.SingleKnockDown = API.AddBuildingButton(
        -- TODO: refactor in a way that the Button cannot be clicked when the downgradecosts are too high
        function(_WidgetID, _BuildingID)
            if self.Data.DowngradeCosts > 0 then
                local CastleID = Logic.GetHeadquarters(GUI.GetPlayerID())
                if Logic.GetAmountOnOutStockByGoodType(CastleID, Goods.G_Gold) >= self.Data.DowngradeCosts then
                    GUI.RemoveGoodFromStock(CastleID, Goods.G_Gold, self.Data.DowngradeCosts)
                else
                    API.Message("Nicht genug Gold!")
                    return
                end
            end
            local Health = Logic.GetEntityHealth(_BuildingID)
            local MaxHealth = Logic.GetEntityMaxHealth(_BuildingID)
            GUI.SendScriptCommand("Logic.HurtEntity(".._BuildingID..", ("..Health.." - ("..MaxHealth.."/2)))")
            Sound.FXPlay2DSound("ui\\menu_click")
            GUI.DeselectEntity(_BuildingID)
        end,
        function(_WidgetID, _BuildingID)
            local Text = {
                de = "Rückbau",
                en = "Downgrade",
                fr = "Déconstruction",
            }
            local Title = {
                de = "- Baut das Gebäude um eine Stufe zurück!",
                en = "- Downgrades the building by one level!",
                fr = "- Réduit le niveau du bâtiment d'un niveau !",
            }
            local Error = {
                de = "Momentan nicht möglich",
                en = "Currently not possible",
                fr = "Pas possible pour le moment",
            }
            if self.Data.DowngradeCosts > 0 then
                API.SetTooltipCosts(Text, Title, Error, {Goods.G_Gold, self.Data.DowngradeCosts})
            else
                API.SetTooltipCosts(Text, Title)
            end
        end,
        function(_WidgetID, _BuildingID)
            if Logic.IsEntityInCategory(_BuildingID, EntityCategories.OuterRimBuilding) == 0
            and Logic.IsEntityInCategory(_BuildingID, EntityCategories.CityBuilding) == 0
            or Logic.IsConstructionComplete(_BuildingID) == 0 then
                XGUIEng.ShowWidget(_WidgetID, 0)
            else
                XGUIEng.ShowWidget(_WidgetID, 1)
            end
            if Logic.IsBuildingBeingUpgraded(_BuildingID)
            or Logic.IsBuildingBeingKnockedDown(_BuildingID)
            or Logic.IsBurning(_BuildingID)
            or Logic.CanCancelUpgradeBuilding(_BuildingID)
            or Logic.CanCancelKnockDownBuilding(_BuildingID) then
                XGUIEng.DisableButton(_WidgetID, 1)
            else
                XGUIEng.DisableButton(_WidgetID, 0)
            end
            SetIcon(_WidgetID, {3, 15})
        end
    )
end

function ModuleBuildingButtons.Local:DropSingleDowngradeButton()
    if self.Data.Button.SingleKnockDown then
        API.DropBuildingButton(self.Data.Button.SingleKnockDown)
        self.Data.Button.SingleKnockDown = nil
    end
end


function ModuleBuildingButtons.Local:SetDowngradeCosts(_Amount)
    self.Data.DowngradeCosts = _Amount
end

-- -------------------------------------------------------------------------- --

Swift:RegisterModule(ModuleBuildingButtons);


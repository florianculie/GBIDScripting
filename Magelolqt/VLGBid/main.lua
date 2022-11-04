local acceptUpdate = CreateFrame("FRAME", "acceptUpdate");
local moneyChanged = CreateFrame("FRAME", "moneyChanged");
local itemChanged = CreateFrame("FRAME", "itemChanged");
local addonMessageFrame = CreateFrame("FRAME", "addonMessage");
addonMessageFrame:RegisterEvent("CHAT_MSG_ADDON");
local enteringWorldFrame = CreateFrame("FRAME", "enteringWorldFrame");
enteringWorldFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
local addonPrefix = "VLGBid";
local price = 0;
local item = "";
local player = "";
local bids = "";
local isShowActive = false;
local f;
local scrollFrame;
local editBox;

local function updateBids(newEntry)
  --print("inside updtabids")
  bids = bids .. newEntry;
  C_ChatInfo.SendAddonMessage(addonPrefix, newEntry, "RAID");
  editBox:SetText(bids);
end

local function evAcceptUpdate(self, event, arg1, arg2, ...)
  if(event == "TRADE_ACCEPT_UPDATE") then
    --print("trade event triggered " .. event .. " " .. arg1 .. " " .. arg2);

    player = UnitName("target");
    --print(player)
    if(arg1 == 1 and arg2 == 1) then
      print("Traded " .. item .. " for " .. price);
      updateBids(item .. "," .. player .. "," .. price .. "\r\n");
    end
  end
end

local function evMoneyChanged(self, event, ...)
  if(event == "TRADE_MONEY_CHANGED") then
    price = math.floor(GetTargetTradeMoney() / 10000);
    --print("price:"..price)
  end
end

local function evItemChanged(self, event, ...)
  if(event == "TRADE_PLAYER_ITEM_CHANGED") then
    item = GetTradePlayerItemLink(1);
    --print("item:"..item)
  end
end

local function split(s, sep)
    local fields = {}

    local sep = sep or " "
    local pattern = string.format("([^%s]+)", sep)
    string.gsub(s, pattern, function(c) fields[#fields + 1] = c end)
    return fields
end

local function addonMessageEvents(self, event, prefix, msg, type, sender)
  --print("event ".. event .. " prefix ".. prefix);
  --print(C_ChatInfo.IsAddonMessagePrefixRegistered(addonPrefix))
  local senderName = split(sender, "-")[1]
  if prefix == addonPrefix and senderName ~= UnitName("player") then
    --print("hello");
    --print("event ".. event .. " prefix ".. prefix .." msg ".. msg.." type "..type.." sender "..sender);
    --print(sender .. " vvvv "..UnitName("player"))

    bids = bids .. msg
    editBox:SetText(bids);
  end
end
addonMessageFrame:SetScript("OnEvent", addonMessageEvents);

local function enteringWorldEvent(self, event, ...)
  if event == "PLAYER_ENTERING_WORLD" then
		local isLogin, isReload = ...
		if isLogin or isReload then
			local success = C_ChatInfo.RegisterAddonMessagePrefix(addonPrefix)
		end
	end
end
enteringWorldFrame:SetScript("OnEvent", enteringWorldEvent);

SLASH_VLGSTART1 = "/vlgstart"
SlashCmdList["VLGSTART"] = function(msg)
  print("starting bid session");
  acceptUpdate:RegisterEvent("TRADE_ACCEPT_UPDATE");
  moneyChanged:RegisterEvent("TRADE_MONEY_CHANGED");
  itemChanged:RegisterEvent("TRADE_PLAYER_ITEM_CHANGED");
  acceptUpdate:SetScript("OnEvent", evAcceptUpdate);
  moneyChanged:SetScript("OnEvent", evMoneyChanged);
  itemChanged:SetScript("OnEvent", evItemChanged);
end

SLASH_VLGSTOP1 = "/vlgstop"
SlashCmdList["VLGSTOP"] = function(msg)
  print("stopping bid session");
  print("bids:\r\n".. bids);
  acceptUpdate:UnregisterEvent("TRADE_ACCEPT_UPDATE");
  moneyChanged:UnregisterEvent("TRADE_MONEY_CHANGED");
  itemChanged:UnregisterEvent("TRADE_PLAYER_ITEM_CHANGED");
  isShowActive = false;
  --print("bidsnew:" .. bids);
end

SLASH_VLGSHOW1 = "/vlgshow"
SlashCmdList["VLGSHOW"] = function(msg)
  if(not isShowActive)then
    isShowActive = true;
    print("Showing bids for current session")
    f = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    f:SetPoint("CENTER")
    f:SetSize(280, 400)
    f:SetBackdrop({
      bgFile = "Interface/Tooltips/UI-Tooltip-Background",
      edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
      edgeSize = 16,
      insets = { left = 4, right = 4, top = 4, bottom = 4 },
    })
    f:SetBackdropColor(0.1, 0.1, 0.1, .8)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)

    scrollFrame = CreateFrame("ScrollFrame", "VLGBidScroll", f, "UIPanelScrollFrameTemplate") -- or your actual parent instead
    scrollFrame:SetSize(210,325)
    scrollFrame:SetPoint("CENTER")

    scrollFrame["title"] = scrollFrame:CreateFontString("ARTWORK", nil, "GameFontNormalLarge");
    scrollFrame["title"]:SetPoint("TOPLEFT", 0, 27);
    scrollFrame["title"]:SetText("Current session bids");
    scrollFrame["title"]:Show();

    editBox = CreateFrame("EditBox", "VLGBidEditBox", scrollFrame)
    editBox:SetMultiLine(true)
    editBox:SetFontObject(ChatFontNormal)
    editBox:SetWidth(205)
    scrollFrame:SetScrollChild(editBox)
    editBox:SetText(bids)
    editBox:HighlightText() -- select all (if to be used for copy paste)
    -- optional/just to close that frame
    editBox:SetScript("OnEscapePressed", function()
      f:Hide()
      isShowActive = false;
    end)

    --Top right X close button
    local exitButton = CreateFrame("Button", "VLGExitButton", scrollFrame, "UIPanelCloseButton");
    exitButton:SetPoint("TOPRIGHT", 0, 33);
    exitButton:SetWidth(29);
    exitButton:SetHeight(29);
    exitButton:SetScript("OnClick", function(self, arg)
    	f:Hide();
      isShowActive = false;
    end)
  end
end

SLASH_VLGRESET1 = "/vlgreset"
SlashCmdList["VLGRESET"] = function(msg)
  print("Resetting current bid session")
  price = 0;
  item = "";
  player = "";
  bids = "";
end

SLASH_VLGHELP1 = "/vlghelp"
SlashCmdList["VLGHELP"] = function(msg)
  print("List of available commands:\r\n");
  print(SLASH_VLGSTART1.." -- start registering a bid session");
  print(SLASH_VLGSTOP1.." -- stop registering a bid session");
  print(SLASH_VLGSHOW1.." -- display currently registered bids");
  print(SLASH_VLGRESET1.." -- reset current bid session");
  print(SLASH_VLGREGISTER1.." -- register a custom bid using the format [item] player price")
end

SLASH_VLGREGISTER1 = "/vlgregister"
SlashCmdList["VLGREGISTER"] = function(msg)
  --print(msg);
  local firstsplit = split(msg, "]")
  item = firstsplit[1] .."]"
  player = split(firstsplit[2])[1]
  price = split(firstsplit[2])[2] or " "
  updateBids(item .. "," .. player .. "," .. price .. "\r\n");
end






--message('My first addon!')

local acceptUpdate = CreateFrame("FRAME", "acceptUpdate");
local moneyChanged = CreateFrame("FRAME", "moneyChanged");
local itemChanged = CreateFrame("FRAME", "itemChanged");

local price = 0;
local item = "";
local player = "";
local bids = "";


local function evAcceptUpdate(self, event, arg1, arg2, ...)
  if(event == "TRADE_ACCEPT_UPDATE") then
    --print("trade event triggered " .. event .. " " .. arg1 .. " " .. arg2);
    --print("Traded " .. item .. " for " .. price);
    player = UnitName("target");
    print(player)
    if(arg1 == 1 and arg2 == 1) then
      bids = bids .. item .. "," .. player .. "," .. price .. "\r\n";
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
    print("item:"..item)
  end
end

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
  --print("bidsnew:" .. bids);
end

SLASH_VLGSHOW1 = "/vlgshow"
SlashCmdList["VLGSHOW"] = function(msg)
  print("Showing bids for current session")
  local scrollFrame = CreateFrame("ScrollFrame", nil, UIParent, "UIPanelScrollFrameTemplate") -- or your actual parent instead
  scrollFrame:SetSize(300,200)
  scrollFrame:SetPoint("CENTER")
  local editBox = CreateFrame("EditBox", nil, scrollFrame)
  editBox:SetMultiLine(true)
  editBox:SetFontObject(ChatFontNormal)
  editBox:SetWidth(300)
  scrollFrame:SetScrollChild(editBox)
  editBox:SetText(bids)
  --Top right X close button
  local exitButton = CreateFrame("Button", "exitButton", scrollFrame, "UIPanelCloseButton");
  exitButton:SetPoint("TOPRIGHT", 12, 27);
  exitButton:SetWidth(29);
  exitButton:SetHeight(29);
  exitButton:SetScript("OnClick", function(self, arg)
  	scrollFrame:Hide();
  end)
end

SLASH_VLGRESET1 = "/vlgreset"
SlashCmdList["VLGRESET"] = function(msg)
  print("Resetting current bid session")
  price = 0;
  item = "";
  player = "";
  bids = "";
end

--message('My first addon!')

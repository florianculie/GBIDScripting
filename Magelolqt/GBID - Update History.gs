function updateHistory() {
  const bidSSId = "R25 WOTLK";
  const historySSId = "Historique";
  var bidSS = SpreadsheetApp.getActive().getSheetByName(bidSSId);

  var firstBidRange = bidSS.getRange(5, 4, 45, 3).getValues();
  var secondBidRange = bidSS.getRange(5, 9, 45, 3).getValues();
  var allBids = firstBidRange.concat(secondBidRange);
  allBids = allBids.filter(item => (item[0] != "" || item[1] != "" || item[2] != ""))
  var rangeValues = [];
  for(i = 0; i < allBids.length; i++){
    var itemName = allBids[i][0];
    var buyerName = allBids[i][1]
    var price = allBids[i][2];
    rangeValues[i] = [formatDate(new Date()), itemName, buyerName, price]
  }

  var historySS =  SpreadsheetApp.getActive().getSheetByName(historySSId);
  var historyRange = historySS.getRange(historySS.getLastRow()+1, 1, allBids.length, 4);
  var styledRange = historySS.getRange(historySS.getLastRow()+1, 2, allBids.length, 3);
  var priceRange = historySS.getRange(historySS.getLastRow()+1, 4, allBids.length, 1);
  historyRange.setValues(rangeValues);
  styledRange.setBackground("#434343");
  styledRange.setFontColor("#FFFFFF");
  priceRange.setFontColor("#FBBC04");
  styledRange.setFontFamily("Oswald")

  var endOfRaid = historySS.getRange(historySS.getLastRow()+1, 1, 1, 4);
  var splitter = historySS.getRange(historySS.getLastRow()+1, 1, 1, 1);
  endOfRaid.setBackground("#A4C5E8");
  splitter.setValues([["----------------------------"]]);
  splitter.setFontColor("#A4C5E8");
}

function padTo2Digits(num) {
  return num.toString().padStart(2, '0');
}

function formatDate(date) {
  return [
    padTo2Digits(date.getDate()),
    padTo2Digits(date.getMonth() + 1),
    date.getFullYear(),
  ].join('/');
}
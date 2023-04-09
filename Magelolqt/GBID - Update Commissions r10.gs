function updateCommissions10() {
  const bidSSId = "R10 WOTLK";
  const commissionsSSId = "COM WOTLK";
  var bidSS = SpreadsheetApp.getActive().getSheetByName(bidSSId);
  var commissionsSS = SpreadsheetApp.getActive().getSheetByName(commissionsSSId);

  var cutOrga = bidSS.getRange(5, 8).getValue();
  var cutRaider = Math.floor(bidSS.getRange(6, 8).getValue());
  var raidFormatAndDate = "r10 " + formatDate(new Date());
  var range = {row : 2, col : 1}
  var commissionsRange = commissionsSS.getRange(getLastRowSpecial(commissionsSS, range)+1, 1, 1, 5);
  var commissionsData = [raidFormatAndDate, cutRaider, "", raidFormatAndDate, cutOrga];
  commissionsRange.setValues([commissionsData]);
}

function getLastRowSpecial(ss, range) {
  const lastRow = ss.getRange(range.row, range.col).getNextDataCell(SpreadsheetApp.Direction.DOWN).getRow();
 
  return lastRow;
};

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
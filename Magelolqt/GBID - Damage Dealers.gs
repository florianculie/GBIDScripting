function main() {
  var ss = SpreadsheetApp.getActiveSheet();
  let url = "https://classic.warcraftlogs.com/api/v2/client"
  let report = ss.getRange(1,7).getValue();
  if(report == "")
    throw new Error("Il n'y a pas de lien WCL en G1");
	
  var regExp = new RegExp("reports\/(\\d*\\w*)", "gim");
  var reportCode = regExp.exec(report)[1];

  var bearerToken = "Bearer " + getToken();

  let graphql = JSON.stringify({
    query: 
    'query{reportData{report(code:"'+ reportCode +'"){graph(dataType:DamageDone endTime:99999999999999 killType:Encounters)}}}',
    variables: null
  });
  var response = UrlFetchApp.fetch(url,{
    method: 'POST', 
    payload: graphql,
    headers: { 
      'Content-Type': 'application/json',
      'Authorization': bearerToken
    }, 
     })

  var lists = JSON.parse((response.getContentText()));
  var playerMetrics = lists.data.reportData.report.graph.data.series;

  var rankedPlayerMetrics = playerMetrics.sort(sortPlayers);

  fillCellRange(16, 10, 1, rankedPlayerMetrics);

  //var range = ss.getRange(16,10,nbPlayer,1);
  //range.setValues(rankedPlayer);

  SpreadsheetApp.flush();

}

function fillCellRange(row, column, numColumns, rankedPlayerMetrics){
  var ss = SpreadsheetApp.getActiveSheet();
  var nbPlayer = 18;
  if(rankedPlayerMetrics.length-1 < 18){
    var nbPlayer = rankedPlayerMetrics.length-1;
  }
  var rankedPlayer = [];
  var rankedPlayerClasses = [];
  for (var counter = 1; counter <= nbPlayer; counter = counter +1) {
    rankedPlayer.push([rankedPlayerMetrics[counter].name]);
    rankedPlayerClasses.push(rankedPlayerMetrics[counter].type)
  }

  var range = ss.getRange(16,10,nbPlayer,1);
  range.setValues(rankedPlayer);
  range.setFontColor('yellow');
  var lastrow = range.getLastRow();

  for (counter = nbPlayer-1; counter >= 0; counter = counter - 1){
    var cell = ss.getRange(16+counter, 10, 1);
    cell.setFontColor(getClassColor(rankedPlayerClasses[counter]));
  }
}

function getClassColor(className){
  var result = "";
  switch(className){
    case "DeathKnight":
      result = '#c41f3b';
      break;
    case "Druid":
      result = '#ff7d0a';
      break;
    case "Hunter":
      result = '#abd473';
      break;
    case "Mage":
      result = '#69ccf0';
      break;
    case "Paladin":
      result = '#f58cba';
      break;
    case "Priest":
      result = '#ffffff';
      break;
    case "Rogue":
      result = '#fff569';
      break;
    case "Shaman":
      result = '#2459ff';
      break;
    case "Warlock":
      result = '#9482c9';
      break;
    case "Warrior":
      result = '#c79c6e';
      break;
    default:
      result = 'red';
      break;
  }
  return result;
}

function sortPlayers(a,b){
  if(a.total<b.total)
    return 1;
  else
    return -1;
  return 0;
}

function getToken(){
  var client_id = "";
  var client_secret = "";
  var formData = {
    'client_id': client_id,
    'client_secret': client_secret,
    'grant_type': 'client_credentials'
  }


  var response = UrlFetchApp.fetch("https://www.warcraftlogs.com/oauth/token",{
    method: 'POST', 
    payload: formData 
     });

  var token = JSON.parse((response.getContentText())).access_token;
  return token;
}



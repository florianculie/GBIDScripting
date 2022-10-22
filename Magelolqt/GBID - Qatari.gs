function qatari() {
  var ss = SpreadsheetApp.getActiveSheet();
  //E5 to E85 - F5 to F85
  let buys = ss.getRange(5, 5, 80, 2).getValues();
  let buyersTotal = []; 
  
  for (counter = 0; counter < buys.length-1; counter = counter + 1){
    var name = buys[counter][0].toLowerCase();
    var price = buys[counter][1];
    if(name == "dez"){
    }
    else if(buyersTotal[name] == null){
      buyersTotal[name] = price;
    }else{
      buyersTotal[name] = buyersTotal[name] + price;
    }
  }
  var qatari;
  var maxTotal = 0;
  var playersName = Object.keys(buyersTotal).forEach((key) => {
    if(maxTotal < buyersTotal[key]){
      qatari = key;
      maxTotal = buyersTotal[key];
    }
  })

  let qatariCell = ss.getRange(35,10);
  qatariCell.setValue(qatari);
  qatariCell.setFontColor("#FFFFFF");
}
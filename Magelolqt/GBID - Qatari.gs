function qatari() {
  var ss = SpreadsheetApp.getActiveSheet();
  //E5 to E85 - F5 to F85
  let buys1 = ss.getRange(5, 5, 45, 2).getValues();
  let buys2 = ss.getRange(5, 10, 45, 2).getValues();
  let buyersTotal = []; 
  
  for (counter = 0; counter < buys1.length-1; counter = counter + 1){
    var name = buys1[counter][0].toLowerCase();
    var price = buys1[counter][1];
    if(name == "dez" || name == ""){
    }
    else if(buyersTotal[name] == null){
      buyersTotal[name] = price;
    }else{
      buyersTotal[name] = buyersTotal[name] + price;
    }
  }
  for (counter = 0; counter < buys2.length-1; counter = counter + 1){
    var name = buys2[counter][0].toLowerCase();
    var price = buys2[counter][1];
    if(name == "dez" || name == ""){
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

  let qatariCell = ss.getRange(37,14);
  qatariCell.setValue(qatari);
  qatariCell.setFontColor("#FFFFFF");
}
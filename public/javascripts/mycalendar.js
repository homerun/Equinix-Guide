/*
 * Created by Kelv Cutler
 * 4/3/08
 */
 
var myCalendarDateList = []

var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

function getMonthLen(theYear, theMonth) {
    var oneHour = 1000 * 60 * 60
    var oneDay = oneHour * 24
    var thisMonth = new Date(theYear, theMonth, 1)
    var nextMonth = new Date(theYear, theMonth + 1, 1)
    var len = Math.ceil((nextMonth.getTime() -
        thisMonth.getTime() - oneHour)/oneDay)
    return len
}

function dateToStr(date) {
  return (date.getMonth()+1) + "/" + date.getDate() + "/" + date.getFullYear()
}

function updateCalendar(id, action) {

  currDate = myCalendarDateList[id]
  tempDate = new Date(currDate)
  tempDate.setDate(1)
  offset = tempDate.getDay()
  monthLen = getMonthLen(tempDate.getYear(),tempDate.getMonth())

  if(action.substr(0,3) == "sel") {
  
    if((Number(action.substr(3))<offset) || (Number(action.substr(3)-offset+1)>monthLen))
      return

    for(c=0; c<42; c++) {
      document.getElementById(id+"sel"+c).value = "N"
      document.getElementById(id+"cell"+c).className = "niether"
    }
    document.getElementById(id+"cell"+action.substr(3)).className = "over_and_sel"
    document.getElementById(id+action).value = "Y"
    myCalendarDateList[id].setDate(Number(action.substr(3))-offset+1)
    document.getElementById(id).value = dateToStr(myCalendarDateList[id])
    return
  }
  if(action == "prevYear")
    currDate.setYear(currDate.getFullYear()-1)
  if(action == "nextYear")
    currDate.setYear(currDate.getFullYear()+1)
  if(action == "prevMonth")
    if(currDate.getMonth()==0) {
      currDate.setMonth(11)
      currDate.setYear(currDate.getFullYear()-1)
    }
    else
      currDate.setMonth(currDate.getMonth()-1)
  if(action == "nextMonth")
    if(currDate.getMonth()==11) {
      currDate.setMonth(0)
      currDate.setYear(currDate.getFullYear()+1)
    }
    else
      currDate.setMonth(currDate.getMonth()+1)

  myCalendarDateList[id] = currDate
  tempDate = new Date(currDate)
  tempDate.setDate(1)
  offset = tempDate.getDay()
  monthLen = getMonthLen(tempDate.getYear(),tempDate.getMonth())

  document.getElementById(id+"year").innerHTML = currDate.getFullYear()
  document.getElementById(id+"month").innerHTML = months[currDate.getMonth()]
  for(c=0;c<42; c++) {
    document.getElementById(id+"sel"+c).value = "N"
    document.getElementById(id+"cell"+c).className = "niether"
    document.getElementById(id+"disp"+c).innerHTML = "<center>" + (c<offset ? " " : ((c-offset+1)>monthLen ? " " : ""+(c-offset+1))) + "</center>"
  }
  document.getElementById(id+"sel"+(myCalendarDateList[id].getDate()+offset-1)).value = "Y"
  document.getElementById(id+"cell"+(myCalendarDateList[id].getDate()+offset-1)).className = "sel"
  document.getElementById(id).value = dateToStr(myCalendarDateList[id])
}

function getClassOver(id, number) {

  tempDate = new Date(myCalendarDateList[id])
  tempDate.setDate(1)
  offset = tempDate.getDay()
  monthLen = getMonthLen(tempDate.getYear(),tempDate.getMonth())

  if((number<offset) || ((number-offset+1)>monthLen))
    return "niether"

  if(document.getElementById(""+id+"sel"+number+"").value == "Y")
    return "over_and_sel"
  return "over"
}

function getClassOut(id, number) {

  tempDate = new Date(myCalendarDateList[id])
  tempDate.setDate(1)
  offset = tempDate.getDay()
  monthLen = getMonthLen(tempDate.getYear(),tempDate.getMonth())

  if((number<offset) || ((number-offset+1)>monthLen))
    return "niether"

  if(document.getElementById(""+id+"sel"+number+"").value == "Y")
    return "sel"
  return "niether"
}

function createCalendar(id, dt, hide) {
  if(dt == null)
    dt = new Date()
  if(dt == "hidden") {
    dt = new Date()
    hide = "hidden"
  }
  myCalendarDateList[id] = new Date(dt)
  var str = ""
  str += "<table class='calendar'>"
  str += "<tr><th><a id='"+id+"prevYear' href='javascript:updateCalendar(\""+id+"\",\"prevYear\")'><<</a></th>"
  str += "<th colspan='5'><a id='"+id+"year'>"+dt.getFullYear()+"</a></th><th><a id='"+id+"nextYear'"
  str += " href='javascript:updateCalendar(\""+id+"\",\"nextYear\")'>>></a></th></tr>"
  str += "<tr><th><a id='"+id+"prevMonth' href='javascript:updateCalendar(\""+id+"\",\"prevMonth\")'><<</a></th>"
  str += "<th colspan='5'><a id='"+id+"month'>"+months[dt.getMonth()]+"</a></th><th><a id='"+id+"nextMonth'"
  str += " href='javascript:updateCalendar(\""+id+"\",\"nextMonth\")'>>></a></th></tr>"
  str += "<tr><th>Su</th><th>Mo</th><th>Tu</th><th>We</th><th>Th</th><th>Fr</th><th>Sa</th></tr>"
  for(i=0; i<6; i++) {
    str += "<tr>"
    for(j=0; j<7; j++) {
      str += "<td id='"+id+"cell"+(i*7+j)+"' class='niether' onmouseover='javascript:this.className=getClassOver(\""+id+"\","+(i*7+j)+")'"
      str += "onmouseout='javascript:this.className=getClassOut(\""+id+"\","+(i*7+j)+")'"
      str += "onclick='javascript:updateCalendar(\""+id+"\",\"sel"+(i*7+j)+"\")'><input id='"+id+"sel"+(i*7+j)+"' type='hidden'"
      str += " value=false /><a href='#' onclick='return false;' id='"+id+"disp"+(i*7+j)+"'>"+(i*7+j)+"</a></td>"
    }
    str += "</tr>"
  }
  str += "</table>"
  var anchor = document.getElementById(id+'_a') 
  if(anchor)
  	anchor.innerHTML = str;
  else
  	document.write("<a id='"+id+"_a'>"+str+"</a>")
  if(hide == "hidden") document.getElementById(id).type="hidden"; 
  updateCalendar(id,"init")
}

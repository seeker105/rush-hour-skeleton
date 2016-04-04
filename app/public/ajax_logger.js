$.ajax({
  method: "POST",
  crossDomain: true,
  url: "http://localhost:9292/sources",
  data: { identifier: "blog", rootUrl: location.origin }
})
.done(function( msg ) {
  console.log( "Site Register" + msg );
});
var payload = {
  "url": location.href,
  "requestedAt": js_yyyy_mm_dd_hh_mm_ss (), 
  "respondedIn":37,
  "referredBy": document.referrrer,
  "requestType":"GET",
  "parameters":[],
  "eventName": "AjaxedWithVimAnalytics",
  "userAgent": navigator.userAgent,
  "resolutionWidth": window.screen.width,
  "resolutionHeight": window.screen.height
}
$.get("http://ipinfo.io", function(response) {
    payload.ip=response.ip;
var payloadString = 'payload='+JSON.stringify(payload);
$.ajax({
  method: "POST",
  crossDomain: true,
  url: "http://localhost:9292/sources/jumpstartlab/data",
  data:  payloadString
})
.done(function( msg ) {
  console.log( "Data Saved: " + msg );
});
}, "jsonp");
function js_yyyy_mm_dd_hh_mm_ss () {
  now = new Date();
  year = "" + now.getFullYear();
  month = "" + (now.getMonth() + 1); if (month.length == 1) { month = "0" + month; }
  day = "" + now.getDate(); if (day.length == 1) { day = "0" + day; }
  hour = "" + now.getHours(); if (hour.length == 1) { hour = "0" + hour; }
  minute = "" + now.getMinutes(); if (minute.length == 1) { minute = "0" + minute; }
  second = "" + now.getSeconds(); if (second.length == 1) { second = "0" + second; }
  return year + "-" + month + "-" + day + " " + hour + ":" + minute + ":" + second;
}


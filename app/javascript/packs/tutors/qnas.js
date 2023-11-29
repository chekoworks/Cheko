import "bootstrap-datepicker"
const tempusDominus = require("../../plugin/tempus-dominus")

$(function(){
  window.datetimepicker1 = new tempusDominus.TempusDominus(
    document.getElementById('datetimepicker1'),
    {
      restrictions: {
        //minDate: new Date().toDateString()
        maxDate: new Date().toDateString()
      },
      display: {
        theme: "light",
      }
    }
  );
})
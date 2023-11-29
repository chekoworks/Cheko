import "jquery-validation"
import "bootstrap-datepicker"
// import "../../plugin/tempus-dominus"
import "../../plugin/jQuery-provider"
const tempusDominus = require("../../plugin/tempus-dominus")

function getCookie(name) {
  const value = `; ${document.cookie}`;
  const parts = value.split(`; ${name}=`);
  if (parts.length === 2) return parts.pop().split(';').shift();
}

$(function(){
  var tomorrow = new Date();
  tomorrow.setDate(tomorrow.getDate() + 1)

  window.datetimepicker1 = new tempusDominus.TempusDominus(
    document.getElementById('datetimepicker1'),
    {
      restrictions: {
        minDate: tomorrow.toDateString()
      },
      display: {
        theme: getCookie("theme"),
      }
    }
  );
})
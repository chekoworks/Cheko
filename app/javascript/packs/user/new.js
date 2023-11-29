import "jquery-validation"
import "../../plugin/jquery.filter_input"

$("#new_user").validate({
  rules: {
    "user[email]": {
      remote: {
        url: window.location.origin + "/check-email"
      }
    },
    "user[password]": {
      minlength: 6
    },
    "user[password_confirmation]": {
      equalTo: "#user_password"
    }
  },

  messages: {
    "user[email]": "Email is already been used"
  }
});

$(document).ready(function(){
  $('#user_first_name').filter_input({regex:'[a-zA-Z ]+'});
  $('#user_last_name').filter_input({regex:'[a-zA-Z ]+'});
})
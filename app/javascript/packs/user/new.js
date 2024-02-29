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

  const password = document.querySelector('#user_password');
  const confirm_password = document.querySelector("#user_password_confirmation");
  const eye_icon_password = document.querySelector("#togglePassword");
  const eye_icon_confirm_password = document.querySelector("#toggleConfirmPassword");

  eye_icon_password.addEventListener("click", () => {
    if (eye_icon_password.classList.contains("bi-eye")) {
      password.setAttribute("type", "text");
      eye_icon_password.classList.remove("bi-eye");
      eye_icon_password.classList.add("bi-eye-slash");
    } else {
      password.setAttribute("type", "password");
      eye_icon_password.classList.remove("bi-eye-slash");
      eye_icon_password.classList.add("bi-eye");
    }
  });

  eye_icon_confirm_password.addEventListener("click", () => {
    if (eye_icon_confirm_password.classList.contains("bi-eye")) {
      confirm_password.setAttribute("type", "text");
      eye_icon_confirm_password.classList.remove("bi-eye");
      eye_icon_confirm_password.classList.add("bi-eye-slash");
    } else {
      confirm_password.setAttribute("type", "password");
      eye_icon_confirm_password.classList.remove("bi-eye-slash");
      eye_icon_confirm_password.classList.add("bi-eye");
    }
  });
})
$(document).ready(function(){
    const password = document.querySelector('#user_password');
    const eye_icon_password = document.querySelector("#togglePassword");

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
})
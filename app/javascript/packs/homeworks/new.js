import "../../plugin/jquery.steps.min.js"
import "../../plugin/jquery.filter_input"
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

$(document).ready(function(){
  $('#user_first_name').filter_input({regex:'[a-zA-Z ]+'});
  $('#user_last_name').filter_input({regex:'[a-zA-Z ]+'});
})

$('#saveDraft').on("click", function(){
  //console.log(window.location.origin);
  var homework = $("#new_homework").serialize()
  //console.log(homework);
  var ajaxPayload = {
    type: "POST",
    url: window.location.origin + "/users/homeworks/add_to_draft",
    data: homework,
    success: function(data){

    }
  }
  $.ajax(ajaxPayload);
})

$('#new_homework').steps({
  headerTag: "h3",
  bodyTag: "stuff",
  transitionEffect: "fade",

  // enableKeyNavigation: false,
  onStepChanging: function(event, currentIndex, newIndex){
    if (currentIndex > newIndex) {
      return true;
    }
    $("#new_homework").validate({
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
    }).settings.ignore = ":disabled,:hidden";
    return $("#new_homework").valid();
  },
  onFinishing: function (event, currentIndex){
    
    console.log($("#new_homework") .valid())
    return $("#new_homework") .valid();
  },
  onFinished: function (event, currentIndex) {
    $("#new_homework").submit();
  }
})

$('div .steps').addClass("list-group list-group-horizontal")

var prio = parseFloat(0)
var skill = parseFloat(0)

var sample = parseFloat(0)

var login = parseFloat(0)

var bid = parseFloat(0)

var new_price = 0

var discount = 0

if ($('#homework_words').length){
  var def_price = 0
  $('#homework_words').on('change', function(){
    def_price = parseFloat($('#homework_words').val()) * parseFloat($('input[name="homework[tutor_category]"]:checked').data("bal"));

    console.log(parseFloat($('input[name="homework[tutor_category]"]:checked').data("bal")))

    prio = ( .30 * def_price);
    new_price = (def_price + skill + sample + login + bid);

    if ($('#homework_priority').is(':checked')) {
      new_price = new_price + prio
    }

    if(new_price >=5000 && new_price <= 9999){
      discount = (.10 * new_price)
      new_price = new_price-discount
    }else if(new_price >= 10000){
      discount = .20 * new_price
      new_price = new_price - discount
    }

    $('#testEstimate').html( '₱' + new_price )
  })
} else {
  var def_price = parseFloat(1000);
  new_price = def_price
  prio = ( .30 * def_price);
  $('#testEstimate').html( '₱' + new_price )
}

$('input[name="homework[tutor_category]"]').on('change', function(){
  var new_def_price = (parseFloat(def_price) * parseFloat($(this).data("bal")))
  new_price = (new_def_price + skill + sample + login + bid)
  prio = ( .30 * new_def_price);
  if ($('#homework_priority').is(':checked')) {
    new_price = (new_price + prio)
  }

  if(new_price >= 5000 && new_price <= 9999){
    discount = (.10 * new_price)
    new_price = new_price - discount
  }else if(new_price >= 10000){
    discount = .20 * new_price
    new_price = new_price - discount
  }

  $('#testEstimate').html( '₱' + new_price )
  console.log(new_price);
})


$('#homework_priority').on('change', function(){
  if ($('#homework_priority').is(':checked')) {
    prio = ( .30 * new_price);
    new_price = (new_price + prio)

    $('#testEstimate').html( '₱' + new_price )
    console.log(new_price);

  } else {
    new_price = (new_price - prio)

    $('#testEstimate').html( '₱' + new_price )
    console.log(new_price);
  }
})

$('#homework_login_school').on('change', function(){
  if ($('#homework_login_school').is(':checked')) {
    login = parseFloat(200)
    new_price = (new_price + login)

    $('#testEstimate').html( '₱' + new_price )
  } else {
    login = parseFloat(200)
    
    new_price = (new_price - login)
    login = parseFloat(0)

    $('#testEstimate').html( '₱' + new_price )
  }
})

$('#homework_view_bidders').on('change', function(){
  if ($('#homework_view_bidders').is(':checked')) {
    bid = parseFloat(300)
    new_price = (new_price + bid)

    $('#testEstimate').html( '₱' + new_price )
  } else {
    bid = parseFloat(300)
    new_price = (new_price - bid)
    bid = parseFloat(0)

    $('#testEstimate').html( '₱' + new_price )
  }
})

$('#homework_tutor_samples').on('change', function(){
  if ($('#homework_tutor_samples').is(':checked')) {
    sample = parseFloat(100)
    new_price = (new_price + sample)

    $('#testEstimate').html( '₱' + new_price )
  } else {
    sample = parseFloat(100)
    new_price = (new_price - sample)
    sample = parseFloat(0)

    if(new_price >= 5000){
      discount = (.30 * new_price)
      new_price = (new_price - discount)
    }
    
    $('#testEstimate').html( '₱' + new_price )
  }
})

$('#homework_tutor_skills').on('change', function(){
  if ($('#homework_tutor_skills').is(':checked')) {
    skill = parseFloat(100)
    new_price = (new_price + skill)


    $('#testEstimate').html( '₱' + new_price )
  } else {
    skill = parseFloat(100)
    new_price = (new_price - skill)
    skill = parseFloat(0)


    $('#testEstimate').html( '₱' + new_price )
  }
})
const tempusDominus = require("../../plugin/tempus-dominus")

function getCookie(name) {
  const value = `; ${document.cookie}`;
  const parts = value.split(`; ${name}=`);
  if (parts.length === 2) return parts.pop().split(';').shift();
}


$(function(){
  window.datetimepicker1 = new tempusDominus.TempusDominus(
    document.getElementById('homework_deadline'),
    {
      restrictions: {
        minDate: new Date().toDateString()
      },
      display: {
        theme: getCookie("theme"),
      }
    }    
  );

  window.datetimepicker2 = new tempusDominus.TempusDominus(
    document.getElementById('homework_internal_deadline'),
    {
      restrictions: {
        minDate: new Date().toDateString()
      },
      display: {
        theme: getCookie("theme"),
      }
    }    
  );
})

var prio = parseFloat(0)

if ($('#homework_tutor_skills2').is(':checked')) {
  var skill = parseFloat(100)
  
} else {
  var skill = parseFloat(0)
}

if ($('#homework_tutor_samples2').is(':checked')) {
  var sample = parseFloat(100)
} else {
  var sample = parseFloat(0)
}


if ($('#homework_login_school2').is(':checked')) {
  var login = parseFloat(200)
} else {
  var login = parseFloat(0)
}


if ($('#homework_view_bidders2').is(':checked')) {
  var bid = parseFloat(300)
} else {
  var bid = parseFloat(0)
}

var new_price = 0

if ($('#homework_words').length){
  var def_price = parseFloat($('#homework_words').val() * parseFloat($('input[name="homework[tutor_category]"]:checked').data("bal")))
  prio = ( .30 * def_price);
  new_price = (def_price + skill + sample + login + bid)

  if ($('#homework_priority').is(':checked')) {
    new_price = (new_price + prio)
  }

  if(new_price >=5000 && new_price <= 9999){
    discount = (new_price * .10)
    new_price = new_price - discount
  }else if(new_price >=10000){
    discount = (new_price * .20)
    new_price = new_price - discount
  }

  $('#testEstimate').html( '₱' + new_price )

  $('#homework_words').on('change', function(){
    def_price = parseFloat($('#homework_words').val()) * parseFloat($('input[name="homework[tutor_category]"]:checked').data("bal"));

    console.log(parseFloat($('input[name="homework[tutor_category]"]:checked').data("bal")))
    prio = ( .30 * def_price);
    new_price = (def_price + skill + sample + login + bid)

    if ($('#homework_priority').is(':checked')) {
      new_price = (new_price + prio)
    }

    if(new_price >=5000 && new_price <= 9999){
      discount = (new_price * .10)
      new_price = new_price - discount
    }else if(new_price >=10000){
      discount = (new_price * .20)
      new_price = new_price - discount
    }

    $('#testEstimate').html( '₱' + new_price )
  })
} else {
  var price = $('#homework_price').val();
  var def_price;
  if(price.length > 0){
    def_price = parseFloat(price);
  }
  else{
    def_price = parseFloat(1000);
  }
  
  new_price = def_price
  prio = ( .30 * def_price);
  console.log(new_price)
  $('#testEstimate').html( '₱' + new_price )
}

$('input[name="homework[tutor_category]"]').on('change', function(){
  var new_def_price = parseFloat($('#homework_words').val()) * parseFloat($(this).data("bal"))
  new_price = (new_def_price + skill + sample + login + bid)
  prio = ( .30 * new_def_price);
  if ($('#homework_priority').is(':checked')) {
    new_price = (new_price + prio)
  }
  
  $('#testEstimate').html( '₱' + new_price )
})

console.log(new_price)
console.log($('#homework_priority'))

$('#homework_priority2').on('change', function(){
  console.log(new_price)
  if ($('#homework_priority2').is(':checked')) {
    new_price = (new_price + prio)
    $('#testEstimate').html( '₱' + new_price )
    console.log(new_price)
  } else {
    new_price = (new_price - prio)
    $('#testEstimate').html( '₱' + new_price )
  }
})

$('#homework_login_school2').on('change', function(){
  if ($('#homework_login_school2').is(':checked')) {
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

$('#homework_view_bidders2').on('change', function(){
  if ($('#homework_view_bidders2').is(':checked')) {
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

$('#homework_tutor_samples2').on('change', function(){
  if ($('#homework_tutor_samples2').is(':checked')) {
    sample = parseFloat(100)
    new_price = (new_price + sample)
    $('#testEstimate').html( '₱' + new_price )
  } else {
    sample = parseFloat(100)
    new_price = (new_price - sample)
    sample = parseFloat(0)
    $('#testEstimate').html( '₱' + new_price )
  }
})

$('#homework_tutor_skills2').on('change', function(){
  if ($('#homework_tutor_skills2').is(':checked')) {
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

$('#homework_min_bid').on('click',function(){
  var min_bid = $('#testEstimate').text().split('₱')
  console.log(min_bid[1]);
  $('#homework_min_bid').val(parseFloat(min_bid[1]))
})
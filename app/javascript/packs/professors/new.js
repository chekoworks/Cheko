$("#prof_review_school_id").on("change", function() {
  var x = $('#prof_review_school_id').find(":selected").text()
  //console.log(x)
  if( x == "Others" ) {
    //console.log("empty")
    $("#school_string").removeClass("d-none")
    $('#prof_review_school_name').prop('required',true);
  } else {
    // console.log("not empty")
    $("#school_string").addClass("d-none")
    $('#prof_review_school_name').val("")
    $('#prof_review_school_name').prop('required',false);
  }
})

$("#professor_school_id").on("change", function() {
  var x = $('#professor_school_id').find(":selected").text()
  //console.log(x)
  if( x == "Others") {
    //console.log("empty")
    $("#school_string").removeClass("d-none")
    $('#professor_school_name').prop('required',true);
  } else {
    //console.log("not empty")
    $("#school_string").addClass("d-none")
    $('#professor_school_name').val("")
    $('#professor_school_name').prop('required',false);
  }
})

getAve()

//////////////////
// MAIN METRICS //
//////////////////


function getAve(){
  var eas = parseInt($("#professor_easiness").val());
  var eff = parseInt($("#professor_effectiveness").val());
  var cha = parseInt($("#professor_life_changing").val());
  var wor = parseInt($("#professor_light_workload").val());
  var len = parseInt($("#professor_leniency").val());

  var average = eas + eff + cha + wor + len
  console.log(average)
  var average = average / 5
  console.log(average)

  $("#percent_av").empty()
  $("#percent_av").append(average + "%");

  $("#professor_average").val(average)
}

$("#professor_easiness").on("input", function(){
  getAve()
  $("#percent").empty()
  $("#percent").append($("#professor_easiness").val() + "%")
})

$("#professor_effectiveness").on("input", function(){
  getAve()
  $("#percent_ef").empty()
  $("#percent_ef").append($("#professor_effectiveness").val() + "%")
})

$("#professor_life_changing").on("input", function(){
  getAve()
  $("#percent_lf").empty()
  $("#percent_lf").append($("#professor_life_changing").val() + "%")
})

$("#professor_light_workload").on("input", function(){
  getAve()
  $("#percent_lw").empty()
  $("#percent_lw").append($("#professor_light_workload").val() + "%")
})

$("#professor_leniency").on("input", function(){
  getAve()
  $("#percent_len").empty()
  $("#percent_len").append($("#professor_leniency").val() + "%")
})

////////////////////////
// ADDITIONAL METRICS //
////////////////////////

$("#professor_a_able").on("input", function(){
  $("#percent_aable").empty()
  $("#percent_aable").append($("#professor_a_able").val() + "%")
})

$("#professor_b_pls_able").on("input", function(){
  $("#percent_bbable").empty()
  $("#percent_bbable").append($("#professor_b_pls_able").val() + "%")
})

$("#professor_c_able").on("input", function(){
  $("#percent_cable").empty()
  $("#percent_cable").append($("#professor_c_able").val() + "%")
})

$("#professor_b_able").on("input", function(){
  $("#percent_bable").empty()
  $("#percent_bable").append($("#professor_b_able").val() + "%")
})

//////////////////
// BATCH RANGE //
/////////////////

$("#professor_batch1_able").on("input", function(){
  getAve()
  $("#percent_b1able").empty()
  $("#percent_b1able").append($("#professor_batch1_able").val() + "%")
})

$("#professor_batch2_able").on("input", function(){
  getAve()
  $("#percent_b2able").empty()
  $("#percent_b2able").append($("#professor_batch2_able").val() + "%")
})

$("#professor_batch3_able").on("input", function(){
  getAve()
  $("#percent_b3able").empty()
  $("#percent_b3able").append($("#professor_batch3_able").val() + "%")
})

$("#professor_batch4_able").on("input", function(){
  getAve()
  $("#percent_b4able").empty()
  $("#percent_b4able").append($("#professor_batch4_able").val() + "%")
})

$("#professor_additional_metric_grade").on("input", function(){
  var grade = $("#professor_additional_metric_grade").val()
  console.log(grade)
  let letter_grade
  //console.log(grade)
  switch(parseInt(grade)){
    case 0:
      letter_grade = "D"
      break
    case 30:
      letter_grade = "C"
      break
    // case 50:
    //   letter_grade = "B"
      // break
    case 60:
      letter_grade = "B"
      break
    case 90:
      letter_grade = "A"
  }
  //console.log(letter_grade)
  $('#additional_metric').empty()
  $('#additional_metric').append(letter_grade)
})


$("#prof_review_additional_metric_grade").on("input", function(){
  var grade = $("#prof_review_additional_metric_grade").val()
  let letter_grade
  //console.log(grade)
  switch(parseInt(grade)){
    case 0:
      letter_grade = "D"
      break
    case 30:
      letter_grade = "C"
      break
    // case 50:
    //   letter_grade = "B"
    // break
    case 60:
      letter_grade = "B"
      break
    case 90:
      letter_grade = "A"
  }
  //console.log(letter_grade)
  $('#additional_metric').empty()
  $('#additional_metric').append(letter_grade)
})

$('.fa-eye').on("click", function(){
  $(".individual").removeClass("hidden-rating")
  $(".fa-eye-slash").removeClass("hidden-rating")
  $(".fa-eye").addClass("hidden-rating")
})

$('.fa-eye-slash').on("click", function(){
  $(".individual").addClass("hidden-rating")
  $(".fa-eye-slash").addClass("hidden-rating")
  $(".fa-eye").removeClass("hidden-rating")
})

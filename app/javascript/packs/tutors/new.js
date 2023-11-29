import "../../plugin/jquery.filter_input"

$(document).ready(function(){
  $('#tutor_first_name').filter_input({regex:'[a-zA-Z ]+'});
  $('#tutor_last_name').filter_input({regex:'[a-zA-Z ]+'});
})
import "../../plugin/jquery.filter_input"
$(document).ready(function(){
  $('#manager_first_name').filter_input({regex:'[a-zA-Z ]+'});
  $('#manager_last_name').filter_input({regex:'[a-zA-Z ]+'});
})
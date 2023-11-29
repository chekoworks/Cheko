// $( '#new_message' ).on('submit', function(){
//   // $( '#new_message' )[0].reset()
//   this.reset();
// })
var qnaId = $("#qna_id").val()
var chatId = $("#chat_id").val()
var send = $(".fa-paper-plane")

function updateScroll(){
  var element = document.getElementById("messages");
  element.scrollTop = element.scrollHeight;
}

updateScroll()

send.on("click", function(){
  //console.log("test");
  $( '#new_message' ).submit();
})

$( '#new_message' ).on("submit", function(event){
  event.preventDefault();
  if ( $("#type").val() == "user" ){

    $.ajax({
      type: "POST",
      url: "/qnas/" + qnaId + "/chats/" + chatId + "/messages",
      data: new FormData(document.getElementById("new_message")),
      processData: false,
      contentType: false,
      success: function(data){
        $( '#new_message' ).each(function(){
          this.reset();
        });
      }
    })
  } else if ($("#type").val() == "tutor") {
    $.ajax({
      type: "POST",
      url: "/tutors/qnas/" + qnaId + "/messages?chat_id=" + chatId,  //+ "&" + $( '#new_message' ).serialize(),
      data: new FormData(document.getElementById("new_message")),
      processData: false,
      contentType: false,
      success: function(data){
        $( '#new_message' ).each(function(){
          this.reset();
        });
      }
    })
  } 

  // updateScroll()
})


// else if( $("#type").value() == "tutor" ){

// }

// $.post()
// $( '#new_message' ).each(function(){
//   this.reset();
// });
console.log($( '#new_message' ).serialize())
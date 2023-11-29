$('#document_file').change(function(){
  if ($('#uploadButton').hasClass('disabled')){
    $('#uploadButton').removeClass('disabled')
  } else {
    $('#uploadButton').addClass('disabled')
  }
})
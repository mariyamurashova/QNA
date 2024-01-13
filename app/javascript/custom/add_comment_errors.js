import $ from "jquery";

$(document).ready(function(){
  console.log("add_comment")
  $(".new-comment").on('ajax:error', function (e) { 
      console.log('error') 
      render_errors(e.detail[0]);
    });

  function render_errors(errors) {
    console.log(errors)
    $('.notice').html(" ");
    var errors = errors;

    $.each(errors, function(index, value) {
      $('.notice').append('<p>' + value + '</p>');
    })
  }
});

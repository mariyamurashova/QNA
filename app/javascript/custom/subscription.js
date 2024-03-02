import $ from "jquery";

$(document).ready(function(){
  $('.question_subscriptions').on('ajax:success', function(e) {
    console.log("subscribed")
    console.log(e.detail[0])
    render_message(e.detail[0]);
  })
    .on('ajax:error', function (e) { 
      console.log('error') 
      render_errors(e.detail[0]);
    });

  function render_message(message) {
     $('.notice').html(" ");
    $('.notice').append('<p>' + message['1'] + '</p>');
  }

  function render_errors(errors) {
    console.log(errors)
    $('.notice').html(" ");
    var errors = errors;

    $.each(errors, function(index, value) {
      $('.notice').append('<p>' + value + '</p>');
    })
  }
});

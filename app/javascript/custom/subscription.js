import $ from "jquery";

$(document).ready(function(){
  $('.question_subscribe').on('ajax:success', function(e) {
  $('#subscribe_question').addClass('hidden');
  $('.button').removeClass('hidden');
 $('.question_unsubscribe').removeClass('hidden');

$('#subscribe_question').addClass('hidden');
  console.log(e.detail[0])
  render_message(e.detail[0]['text']);
  })
    .on('ajax:error', function (e) { 
      console.log('error') 
      render_errors(e.detail[0]);
    });

  function render_message(message) {
    $('.notice').html(" ");
    $('.notice').append('<p>' + message + '</p>');
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

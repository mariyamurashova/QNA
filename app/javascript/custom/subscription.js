import $ from "jquery";

$(document).ready(function(){
  $('.question_subscribe').on('ajax:success', function(e) {
  $('#subscribe_question').addClass('hidden');
  $('.button').removeClass('hidden');
 $('.question_unsubscribe').removeClass('hidden');

//document.querySelector('.question_unsubscribe').insertAdjacentHTML("beforeend"'<a data-confirm="Are you sure?" data-remote="true" data-type="json" id="unsubscribe_btn" rel="nofollow" data-method="delete" href="/subscriptions/7">Unsubscribe</a>')
$('#subscribe_question').addClass('hidden');
  console.log(e.detail[0])
  render_message(e.detail[0]);
  })
    .on('ajax:error', function (e) { 
      console.log('error') 
      render_errors(e.detail[0]);
    });

  /*$('.question_unsubscribe').on('ajax:success', function(e) {
  $('#subscribe_question').removeClass('hidden');
  $('.button').addClass('hidden');
  render_message(e.detail[0]);
  })
    .on('ajax:error', function (e) { 
      console.log('error') 
      render_errors(e.detail[0]);
    });*/

  function render_message(message) {
    $('.notice').html(" ");
    $('.notice').append('<p>' + message['0']['1'] + '</p>');
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

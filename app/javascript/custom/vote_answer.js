import $ from "jquery";
$(document).ready(function(){
  $('.vote-up-answer, .vote-down-answer, .answer_delete_vote').on('ajax:success', function(e) {
    console.log('success')
    render_rating(e.detail[0]);
  })
    .on('ajax:error', function (e) { 
      console.log('error') 
      render_errors(e.detail[0]);
    });

  function render_rating(rating) {
    $('.notice').html(" ");
    $('#change_answer_rating').html(" ");
    $('#change_answer_rating').append(rating);
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

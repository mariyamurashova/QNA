import $ from "jquery";
$(document).ready(function(){

  $('.vote-up').on('ajax:success', function(e) {
    render_rating(e.detail[0]);
  })
    .on('ajax:error', function (e) {  
      render_errors(e.detail[0]);
    }) 

  $('.vote-down').on('ajax:success', function(e) {
    render_rating(e.detail[0]);
  })
    .on('ajax:error', function (e) {  
      render_errors(e.detail[0]);
    })

  $('.question_delete_vote').on('ajax:success', function(e) {
    render_rating(e.detail[0]);
  })
    .on('ajax:error', function (e) {  
      render_errors(e.detail[0]);
    }) 

  function render_rating(rating) {
    $('.notice').html(" ");
    $('#change_rating').html(" ");
    $('#change_rating').append(rating);
  }

  function render_errors(errors) {
    $('.notice').html(" ");
    var errors = errors;
    
    $.each(errors, function(index, value) {
      $('.notice').append('<p>' + value + '</p>');
    })
  } 
});

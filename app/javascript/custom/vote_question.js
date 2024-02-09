import $ from "jquery";
$(document).ready(function(){
  
  $('.vote-up, .vote-down, .question_delete_vote').on('ajax:success', function(e) {
     render_rating(e.detail[0]['rating'], e.detail[0]['id'] );
  })
    .on('ajax:error', function (e) {  
      render_errors(e.detail[0]);
    }) 

  function render_rating(rating, id) {
    $('.notice').html(" ");
    $('#change_question'+id+'_rating').html(" ");
    $('#change_question'+id+'_rating').append(rating);
  }

  function render_errors(errors) {
    $('.notice').html(" ");
    var errors = errors;
    
    $.each(errors, function(index, value) {
      $('.notice').append('<p>' + value + '</p>');
    })
  } 
});

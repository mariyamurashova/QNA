import $ from "jquery";
$(document).ready(function(){
  $('.question').on('click', '.edit-question-link', function(e){
    e.preventDefault();
    $(this).hide();
    var questionId = $(this).data('questionId');
    $('form#edit-question-' + questionId).removeClass('hidden');
    $('.delete_file_' + questionId).removeClass('hidden');
    $('.delete_link_' + questionId).removeClass('hidden');
  })

  $('.vote-up').on('ajax:success', function(e) {
    var rating= parseInt($('#change_rating')[0].innerText)
    rating++
    $('#change_rating')[0].innerText = rating;
    })

   .on('ajax:error', function (e) {  
      $('.notice').html(" ");
      var errors = e.detail[0];
      $.each(errors, function(index, value) {
        $('.notice').append('<p>' + value + '</p>');
      })
    }) 

  $('.vote-down').on('ajax:success', function(e) {
    var rating= parseInt($('#change_rating')[0].innerText)
    rating--
    $('#change_rating')[0].innerText = rating;
  })

    .on('ajax:error', function (e) {  
      $('.notice').html(" ");
      var errors = e.detail[0];
      $.each(errors, function(index, value) {
        $('.notice').append('<p>' + value + '</p>');
      })
    }) 
});

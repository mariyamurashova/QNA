import $ from "jquery";
$(document).ready(function(){
  $('.answers').on('click', '.edit-answer-link', function(e){
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('.delete_file_' + answerId).removeClass('hidden');
    $('form#edit-answer-' + answerId).removeClass('hidden');
    $('.delete_link_' + answerId).removeClass('hidden');
  })

  $('.vote-up-answer').on('ajax:success', function(e) {
    var rating= parseInt($('#change_answer_rating')[0].innerText)
    rating++
    $('#change_answer_rating')[0].innerText = rating;
  })

    .on('ajax:error', function (e) {  
      $('.notice').html(" ");
      var errors = e.detail[0];
      $.each(errors, function(index, value) {
        $('.notice').append('<p>' + value + '</p>');
      })
    });

  $('.vote-down-answer').on('ajax:success', function(e) {
    var rating= parseInt($('#change_answer_rating')[0].innerText)
    rating--
    console.log(rating)
    $('#change_answer_rating')[0].innerText = rating;
  })

    .on('ajax:error', function (e) {  
      $('.notice').html(" ");
      var errors = e.detail[0];
      $.each(errors, function(index, value) {
        $('.notice').append('<p>' + value + '</p>');
      })
    }) 
});

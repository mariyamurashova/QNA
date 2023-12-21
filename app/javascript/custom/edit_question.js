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
     console.log(rating)
    $('#change_rating')[0].innerText = rating;
  })

  $('.vote-down').on('ajax:success', function(e) {
    var rating= parseInt($('#change_rating')[0].innerText)
    rating--
     console.log(rating)
    $('#change_rating')[0].innerText = rating;
  })

});

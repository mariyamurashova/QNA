import $ from "jquery";

$(document).ready(function(){
  $('.question').on('click', '.comment-question-link', function(e){
    e.preventDefault();
    $(this).hide();
    var questionId = $(this).data('questionId');
    $('form#comment-Question-' + questionId).removeClass('hidden');
  })
});

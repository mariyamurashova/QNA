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
});



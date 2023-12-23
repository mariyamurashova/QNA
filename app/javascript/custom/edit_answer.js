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

});

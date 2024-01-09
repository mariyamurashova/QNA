import $ from "jquery";
$(document).ready(function(){
  $('.answers').on('click', '.comment-answer-link', function(e){
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#comment-answer-' + answerId).removeClass('hidden');
  })

});

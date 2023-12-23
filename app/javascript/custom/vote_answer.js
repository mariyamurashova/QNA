import $ from "jquery";
$(document).ready(function(){
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

  $('.answer_delete_vote').on('ajax:success', function(e) {
    var rating= parseInt($('#change_answer_rating')[0].innerText)
    if (rating > 0) {
      rating= rating - 1
      } 
    else {
      rating= rating + 1
      }
    
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

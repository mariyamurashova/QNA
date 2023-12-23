import $ from "jquery";
$(document).ready(function(){
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

   $('.question_delete_vote').on('ajax:success', function(e) {
    var rating= parseInt($('#change_rating')[0].innerText)
    if (rating > 0) {
      rating= rating - 1
      } 
    else {
      rating= rating + 1
      }
    
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

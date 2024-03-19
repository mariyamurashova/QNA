import $ from "jquery";

$(document).ready(function(){
  $('#search-form').on('ajax:success', function (e) {
    $('.questions_list').addClass("hidden");
    $('.search_results_title').html(" ");
    $('.search_results').html(" ");
    $('.search_results_title').append('<h1>Search Results: </h1>');
    console.log(e.detail[0])

    if (e.detail[0]['links']) {

      $.each(e.detail[0]['links'], function(index, value) {  
        let aTag = document.createElement('a');
        aTag.innerHTML='<p>'+e.detail[0]['results'][index]['searchable_type'] +':'+'  '+ e.detail[0]['results'][index]['content'] + '<p>';
        aTag.href=value;
        aTag.title="search results";
        $('.search_results').append(aTag);
      })
    }

    else { 
      $('.search_results').html(" ");
      $('.search_results').append(e.detail[0]['text']);  
    }
  })
})

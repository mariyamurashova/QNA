import $ from "jquery";

$(document).ready(function(){
  $('#multisearch').on('ajax:success', function (e) {
    console.log("multisearch")
    hide_index_template_content()
    if (e.detail[0]['links']) 
      render_results(e.detail[0], 'searchable_type', 'content')
    else 
      render_no_results(e.detail[0])   
 })

  $('#scope_search').on('ajax:success', function (e) {
      hide_index_template_content()
    if (e.detail[0]['links']) 
      render_results(e.detail[0], 'title', 'body')
    else 
      render_no_results(e.detail[0])
  })

  function hide_index_template_content(){
    $('.questions_list').addClass("hidden");
    $('.search_results_title').html(" ");
    $('.search_results').html(" ");
    $('.search_results_title').append('<h1>Search Results: </h1>');
  }
  
  function render_results(edetail, field_key1, field_key2) {
     if (edetail['results'][0]['email'])
        render_user_search_results(edetail)
      else
        $.each(edetail['links'], function(index, value) {  
          let aTag = document.createElement('a');

          if (!edetail['results'][index][field_key2]) // rendering for answers, comments without field - 'title'
            aTag.innerHTML='<p>' + edetail['results'][index][field_key1] + '<p>';
          else
            aTag.innerHTML='<p>'+edetail['results'][index][field_key1] +' ' + edetail['results'][index][field_key2] + '<p>';

          aTag.href=value;
          aTag.title="search results";
          $('.search_results').append(aTag);
        })
  }
  
  function render_no_results(edetail){
    $('.search_results').html(" ");
    $('.search_results').append(edetail['text']);  
  }

  function render_user_search_results(edetail){
    if (edetail['links']) {
      $('.search_results_title').html(" ");
      $('.search_results_title').append('<h1>Search Results, by user'+' '+'-'+ edetail['results']['email'] +': </h1>');
      $.each(edetail['links'], function(index, value) { 
        let aTag = document.createElement('a');
        aTag.innerHTML='<p>'+value + '<p>';
        aTag.href=value;
        aTag.title="search results";
        $('.search_results').append(aTag);
      }) 
    }
    else
      render_no_results(e.detail[0])
  }
})





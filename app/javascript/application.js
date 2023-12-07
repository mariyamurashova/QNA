// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import * as ActiveStorage from '@rails/activestorage'
ActiveStorage.start()
console.log("ActiveStorage2")

import Rails from '@rails/ujs';
Rails.start();
console.log("Rails")

import Cocooned from '@notus.sh/cocooned'
Cocooned.start()
console.log("Cocooned")

import jquery from 'jquery'
window.jQuery = jquery
window.$ = jquery

console.log("jquery")

import "@hotwired/turbo-rails"
import "controllers"

console.log("gist")
import { Octokit } from "@octokit/core"
var octokit = new Octokit ()

$(".gist" ).each (function() {
  var gistId = $( this ). data ('gistId');
  var linkId = $( this ).data('linkId');

  octokit.request('GET /gists/' + gistId, {
  gist_id: gistId,
  headers: { 
    'X-GitHub-Api-Version': '2022-11-28'
    }
  }).then (result => addGistContentToPage(result))

function addGistContentToPage(result){
  var file = result.data.files

   for (file in result.data.files) {
      var gistContent =  "<h3>" + file + "</h3>"
      gistContent = gistContent + "<div>" + result.data.files[file].content + "</div>" 
      gistContent = "<div class='gist-file'>" + gistContent + "</div>"
      $('#gist-' + linkId).append(gistContent)
    }
  }
})

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

$(document).ready(function(){
  $('.answers').on('click', '.best-answer-link', function(e){
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#best-answer-' + answerId).removeClass('hidden');
  })
});

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

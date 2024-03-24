// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import * as ActiveStorage from '@rails/activestorage'
ActiveStorage.start()
console.log("ActiveStorage2")

import Rails from '@rails/ujs';
Rails.start();
console.log("Rails")

import Cocooned from '@notus.sh/cocooned'
Cocooned.start()
console.log("Cocooned")

import * as bootstrap from "bootstrap"  

import jquery from 'jquery'
window.jQuery = jquery
window.$ = jquery
console.log("jquery")

import "./custom/best_answer.js"
import "./custom/edit_answer.js"
import "./custom/edit_question.js"
import "./custom/vote_answer.js"
import "./custom/vote_question.js"
import "./custom/add_comment_errors.js"
import "./custom/answer_comment.js"
import "./custom/question_comment.js"
import "./custom/gist.js"
import "./custom/subscription.js"
import "./custom/search.js"
import "channels"


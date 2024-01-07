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

import "./custom/best_answer.js"
import "./custom/edit_answer.js"
import "./custom/edit_question.js"
import "./custom/vote_answer.js"
import "./custom/vote_question.js"
import "./custom/gist.js"
import "./channels/consumer.js"
import "./channels/answers_channel.js"
import "./channels/questions_channel.js"

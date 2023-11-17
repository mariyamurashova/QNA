// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import * as ActiveStorage from '@rails/activestorage'
ActiveStorage.start()
console.log("ActiveStorage2")

import Rails from '@rails/ujs';
Rails.start();
console.log("Rails")

import jquery from 'jquery'
window.jQuery = jquery
window.$ = jquery

console.log("jquery")

import "@hotwired/turbo-rails"
import "controllers"

// import "./answers"
// import "./questions"
// import "./best"




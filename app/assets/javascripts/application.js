

// This is a manifest file that'll se compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks
//= require jquery3
//= require jquery.transit.min
//= require fingerprint.sdk.min
//= require websdk.client.bundle.min
//= require chosen-jquery
//= require moment
//= require popper
//= require bootstrap
//= require bootstrap-datepicker
//= require bootstrap-timepicker
//= require activestorage
//= require select2
//= require_tree .


document.addEventListener('turbolinks:load', ready);
var ready = function () {
    return $(window).trigger('resize');
};
document.addEventListener('turbolinks:load', ready);

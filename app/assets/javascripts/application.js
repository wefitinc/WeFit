// This is a manifest file that'll be compiled into application.js, which will include all the files
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
//= require activestorage
//= require turbolinks
// require_tree .

// Facebook JS Init
window.fbAsyncInit = function()
{
	FB.init({
		appId            : '2383595921758644',
		autoLogAppEvents : true,
		xfbml            : true,
		version          : 'v3.3'
	});
};

function toggle_password()
{
	var field = document.getElementById('user_password');
	field.type = (field.type === 'password') ? "text" : "password";
};

$(document).on('turbolinks:load', function() {});

$('.static.welcome.logged_in').ready(function()
{
	// The date we're hurdling inexorably towards
	var to_date = new Date("Dec 20, 2019").getTime();
	// Update the timer
	function update_timer()
	{
		// Get the delta
		var now = new Date().getTime();
		var delta = to_date - now;
		// Update the counter with magic math
		$("#days").text(Math.floor(delta / (1000*60*60*24)));
		$("#hours").text(Math.floor((delta % (1000*60*60*24)) / (1000*60*60)));
		$("#minutes").text(Math.floor((delta % (1000*60*60)) / (1000*60)));
		$("#seconds").text(Math.floor((delta % (1000*60)) / (1000)));
	};
	// Update every second
	setInterval(update_timer, 1000);
	// Call on load too
	update_timer();
});
$('.static.welcome.logged_out').ready(function()
{
	// Select the first name by default
	$("#user_first_name").select();

	var today = new Date();
	var picker = new Pikaday({
		field: document.getElementById('user_birthdate'),
		format: 'YYYY-MM-DD',
		yearRange: [today.getFullYear()-100, today.getFullYear()]
	});
});

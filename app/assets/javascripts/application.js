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
//= require jquery
//= require popper
//= require bootstrap
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery-readyselector
// require_tree .

function toggle_password()
{
	var field = document.getElementById('user_password');
	field.type = (field.type === 'password') ? "text" : "password";
};

// NOTE: Turbolinks breaks 'ready' events unless wrapped like this
$(document).on('turbolinks:load', function()
{
	// Show the login modal by default if login error
	$('.login_error').ready(function()
	{
		$("#loginModal").modal('show');
	});
	// Logged in welcome page JS
	$('.users.new.logged_in').ready(function()
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
	// Logged out welcome page JS
	$('.users.new.logged_out').ready(function()
	{
		// Select the first name by default
		$("#user_first_name").select();
	});
	$('.professionals.new').ready(function()
	{
		// Create a Stripe client.
		var stripe = Stripe('pk_live_F4uXdKCI6bXQyCu6U88T3hwd00aO6hO8Sp');

		// Create an instance of Elements.
		var elements = stripe.elements();
		var style =
		{
		  base:
		  {
			color: '#495057',
			fontFamily: '"Helvetica Neue", Helvetica, sans-serif',
			fontSmoothing: 'antialiased',
			fontSize: '16px',
			'::placeholder':
			{
			  color: '#6c757d'
			}
		  },
		  invalid:
		  {
			color: '#fa755a',
			iconColor: '#fa755a'
		  }
		};

		// Create an instance of the card Element.
		var card = elements.create('card', {style: style});

		// Add an instance of the card Element into the `card-element` <div>.
		card.mount('#card-element');

		// Handle real-time validation errors from the card Element.
		card.addEventListener('change', function(event)
		{
		  var displayError = document.getElementById('card-errors');
		  if (event.error) {
			displayError.textContent = event.error.message;
		  } else {
			displayError.textContent = '';
		  }
		});

		// Handle form submission.
		var form_id = 'professionals-form';
		var form = document.getElementById(form_id);
		form.addEventListener('submit', function(event)
		{
		  event.preventDefault();

		  stripe.createToken(card).then(function(result)
		  {
			if (result.error) {
			  // Inform the user if there was an error.
			  var errorElement = document.getElementById('card-errors');
			  errorElement.textContent = result.error.message;
			} else {
			  stripeTokenHandler(result.token);
			}
		  });
		});

		// Submit the form with the token ID.
		function stripeTokenHandler(token)
		{
			// Insert the token ID into the form so it gets submitted to the server
			var form = document.getElementById(form_id);
			var hiddenInput = document.createElement('input');
			hiddenInput.setAttribute('type', 'hidden');
			hiddenInput.setAttribute('name', 'stripe_token');
			hiddenInput.setAttribute('value', token.id);
			form.appendChild(hiddenInput);
			// Submit the form
			form.submit();
		}
	});
});

(function () {
  'use strict'

  window.addEventListener('load', function () {
    // Fetch all the forms we want to apply custom Bootstrap validation styles to
    var forms = document.getElementsByClassName('needs-validation')

    // Loop over them and prevent submission
    Array.prototype.filter.call(forms, function (form) {
      form.addEventListener('submit', function (event) {
        if (form.checkValidity() === false) {
          event.preventDefault()
          event.stopPropagation()
        }
        form.classList.add('was-validated')
      }, false)
    })
  }, false)
}())

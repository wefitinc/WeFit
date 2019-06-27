Rails.application.config.middleware.use OmniAuth::Builder do
	# TODO: Move these to an environment variable
	provider :facebook, "2383595921758644", "a1d8ccae87640ca34cb2e541c02d03e8"
	provider :google_oauth2, "997965127714-86jhvdo0b7hvf5maf52b6vm6o1uttunu", "I6vO1UXDWDGHmnrYQLubdWfW"
end

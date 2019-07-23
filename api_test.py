import requests

# Base URL to contact
# url = 'https://wefit.us'
url = 'http://localhost:3000'

# Send a login request with the email and password
def login(email, password):
	# Login path
	path = '/api/v1/auth/login'
	print('Contacting '+url+path+'...', end ="")
	# JSON data to send for login
	json = { 'email': email, 'password': password }
	# Make the request (POST)
	r = requests.post(url+path, json=json)
	# If the request was successful
	if r.status_code == 200:
		# Log and return the data
		print("Logged in")
		return r.json()['token']
	# Failed, dont return data
	print('Failed to login, status code ['+str(r.status_code)+']')
	return None

# Send an authorization test for eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjozLCJleHAiOjE1NjQwMDkxODl9.8bfqYQKbDvHIrQQrSnNI_oLKuGnqAWBP_3dPSYOQaDca token
def auth_test(token):
	# Test path
	path = '/api/v1/auth/test'
	print('Contacting '+url+path+'...', end ="")
	# Make sure the headers contain the authorization token
	headers = { 'Authorization': token }
	# Make the request (GET)
	r = requests.get(url+path, headers=headers)
	# If the request was successful
	if r.status_code == 200:
		print("Authorized")
		return
	# If the request failed
	print('Failed to authorize, status code ['+str(r.status_code)+']')

def get_user(token):
	# User path
	path = '/api/v1/auth/user'
	print('Contacting '+url+path+'...', end ="")
	# Make sure the headers contain the authorization token
	headers = { 'Authorization': token }
	# Make the request (GET)
	r = requests.get(url+path, headers=headers)
	# If the request was successful
	if r.status_code == 200:
		print("Got user data")
		return r.json()
	# If the request failed
	print('Failed to authorize, status code ['+str(r.status_code)+']')
	return None

if __name__ == '__main__':
	# Try and log in as the test user
	email    = 'test@test.com'
	# password = 'SuperSecretTestPassword'
	password = 'test'
	token = login(email, password)
	# If login successful
	if token:
		# Run an authorization test
		auth_test(token)
		data = get_user(token)
		print("Hello "+data['first_name']+" "+data['last_name']+", the API works!")
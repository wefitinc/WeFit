import base64
import requests
import mimetypes

# Production testing
# url      = 'https://wefit.us'
# email    = 'test@test.com'
# password = 'SuperSecretTestPassword'

# Development testing
url      = 'http://localhost:3000'
email    = 'test@wefit.us'
password = 'SuperSecretTestPassword'

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
		print('\t'+str(r.json()))
		return r.json()
	# Failed, dont return data# 
	print('Failed to login, status code ['+str(r.status_code)+']')
	print('\t'+str(r.json()))
	return None

# Send an authorization test for the token
def auth_check(token):
	# Test path
	path = '/api/v1/auth/check'
	print('Contacting '+url+path+'...', end ="")
	# Make sure the headers contain the authorization token
	headers = { 'Authorization': token }
	# Make the request (GET)
	r = requests.get(url+path, headers=headers)
	# If the request was successful
	if r.status_code == 200:
		print("Authorized")
		print('\t'+str(r.json()))
		return
	# If the request failed
	print('Failed to authorize, status code ['+str(r.status_code)+']')
	print('\t'+str(r.json()))

def get_me(token):
	# User path
	path = '/api/v1/auth/me'
	print('Contacting '+url+path+'...', end ="")
	# Make sure the headers contain the authorization token
	headers = { 'Authorization': token }
	# Make the request (GET)
	r = requests.get(url+path, headers=headers)
	# If the request was successful
	if r.status_code == 200:
		print("Got my user data")
		print('\t'+str(r.json()))
		return r.json()
	# If the request failed
	print('Failed to authorize, status code ['+str(r.status_code)+']')
	print('\t'+str(r.json()))

def get_user(user_id):
	# User path
	path = '/api/v1/users/'+str(user_id)
	print('Contacting '+url+path+'...', end ="")
	# Make sure the headers contain the authorization token
	# headers = { 'Authorization': token }
	# Make the request (GET)
	r = requests.get(url+path)
	# If the request was successful
	if r.status_code == 200:
		print("Got user data")
		print('\t'+str(r.json()))
		return r.json()
	# If the request failed
	print('Failed to authorize, status code ['+str(r.status_code)+']')
	print('\t'+str(r.json()))
	return None

def create_post(token, image_filename):
	# Get the mimetype of the file
	mime_type = mimetypes.guess_type(image_filename)[0]
	# Load image data
	with open(image_filename, 'rb') as image_file:
		# Read image
		image = image_file.read()
		# Base64 encode
		image_b64 = base64.b64encode(image)
		# Test post data
		json = {
			'post': {
				# White text
				'color': "#ffffff",
				# Eye-rape background
				'background': "#ff00ff",
				# Basic text
				'text': "Test 🔥🔥🔥🔥🔥🔥",
				'font': 'Consolas',
				'font_size': 8.0,
				# Top left
				'position_x': 0.0, 
				'position_y': 0.0, 
				'rotation': 0.0,
				# Tempe, Az coordinates
				'latitude': '33.4255',
				'longitude': '111.9400',
				# Add a tag list
				'tag_list': [ "fitness", "outdoors" ],
			},
			# Image
			'image': "data:"+mime_type+";base64,"+str(image_b64)
		}

		# Post path
		path = '/api/v1/posts'
		print('Contacting '+url+path+'...', end ="")
		# Make sure the headers contain the authorization token
		headers = { 'Authorization': token }
		# Make the request (GET)
		r = requests.post(url+path, json=json, headers=headers)
		if r.status_code == 200:
			print("Made a post")
			print('\t'+str(r.json()))
			return r.json()
		print('Failed to create a post, status code ['+str(r.status_code)+']')
		print('\t'+str(r.json()))
		return
	print('Failed to load image \"'+image_filename+'\"')

def like_post(token, post_id):
	# Post path
	path = '/api/v1/posts/'+str(post_id)+'/likes'
	print('Contacting '+url+path+'...', end ="")
	# Make sure the headers contain the authorization token
	headers = { 'Authorization': token }
	r = requests.post(url+path, headers=headers)
	if r.status_code == 200:
		print("Liked post")
		print('\t'+str(r.json()))
		return
	print('Failed to like post, status code ['+str(r.status_code)+']')
	print('\t'+str(r.json()))

def comment_on_post(token, post_id):
	json = {
		'body': "Test comment! 🔥🔥🔥"
	}
	# Post path
	path = '/api/v1/posts/'+str(post_id)+'/comments'
	print('Contacting '+url+path+'...', end ="")
	# Make sure the headers contain the authorization token
	headers = { 'Authorization': token }
	r = requests.post(url+path, json=json, headers=headers)
	if r.status_code == 200:
		print("Commented on post")
		print('\t'+str(r.json()))
		return
	print('Failed to comment on post, status code ['+str(r.status_code)+']')
	print('\t'+str(r.json()))

def delete_post(token, post_id):
	# Post path
	path = '/api/v1/posts/'+str(post_id)
	print('Contacting '+url+path+'...', end ="")
	# Make sure the headers contain the authorization token
	headers = { 'Authorization': token }
	r = requests.delete(url+path, headers=headers)
	if r.status_code == 200:
		print("Deleted post")
		print('\t'+str(r.json()))
		return
	print('Failed to delete post, status code ['+str(r.status_code)+']')
	print('\t'+str(r.json()))

def get_posts(tags):
	json = {
		'filters': 
		{
			"match_all": False,
			"tag_list": ["fitness"],
		}
	}
	# Post path
	path = '/api/v1/posts/'
	print('Contacting '+url+path+'...', end ="")
	r = requests.get(url+path, json=json)
	if r.status_code == 200:
		print("Got posts")
		print('\t'+str(r.json()))
		return
	print('Failed to get posts, status code ['+str(r.status_code)+']')
	print('\t'+str(r.json()))

if __name__ == '__main__':
	# Try and log in as the test user
	data = login(email, password)
	# If login successful
	if data:
		# Run an authorization test
		auth_check(data['token'])
		user_data = get_me(data['token'])
		if user_data:
			print("Hello "+user_data['first_name']+" "+user_data['last_name']+", the API works!")
			# Image filename
			image = 'red-suspension-bridge-3493772.jpg'
			post_data = create_post(data['token'], image)
			if post_data:
				like_post(data['token'], post_data['id'])
				like_post(data['token'], post_data['id'])
				comment_on_post(data['token'], post_data['id'])
				delete_post(data['token'], post_data['id'])	
			get_posts('fitness')

import requests

# url = 'https://wefit.us'
url = 'http://localhost:3000'

def login(email, password):
	json = { 'email': email, 'password': password }
	r = requests.post(url+'/api/v1/auth/login', json=json)
	if r.status_code == 200:
		print("Logged in")
		return r.json()
	print('Failed to login, status code ['+str(r.status_code)+']')
	return None

def auth_test(token):
	headers = { 'Authorization': token }
	r = requests.get(url+'/api/v1/auth/test', headers=headers)
	if r.status_code == 200:
		print("Authorized")
		return
	print('Failed to authorize, status code ['+str(r.status_code)+']')

if __name__ == '__main__':
	email    = 'test@test.com'
	password = 'test'
	data = login(email, password)
	if data:
		auth_test(data['token'])
#!/usr/bin/env python

import os
import sys
import zipfile
from time import strftime, sleep
import boto3
from botocore.exceptions import ClientError

# Configuration
APPLICATION_NAME='WeFit'
APPLICATION_ENVIRONMENT= 'Wefit-env-3'
REGION_NAME='us-east-2'
VERSION_LABEL = strftime("%Y-%m-%dT%H:%M:%S")
S3_BUCKET='elasticbeanstalk-us-east-2-314946208894'
ZIP_FILENAME = APPLICATION_NAME+'.zip'
BUCKET_KEY = APPLICATION_NAME + '_' + VERSION_LABEL + '.zip'

# Add all files in a directory
def add_dir(z, path):
	for root, dires, files in os.walk(path):
		for file in files:
			z.write(os.path.join(root, file))

# Add a directory with only a dummy file in it
def add_dummy_dir(z, path):
	z.write(path+'/.keep')

# Create the zip file for deployment
def create_zip():
	z = zipfile.ZipFile(ZIP_FILENAME, 'w', zipfile.ZIP_DEFLATED)
	add_dir(z, 'app/')
	add_dir(z, 'bin/')
	add_dir(z, 'config/')
	add_dir(z, 'db/')
	add_dir(z, 'lib/')
	add_dummy_dir(z, 'log/')
	add_dir(z, 'public/')
	add_dummy_dir(z, 'storage/')
	add_dir(z, 'test/')
	add_dummy_dir(z, 'tmp/')
	add_dir(z, 'vendor/')
	z.write('.gitignore')
	z.write('.ruby-version')
	z.write('config.ru')
	z.write('Gemfile')
	z.write('package.json')
	z.write('Rakefile')
	z.write('README.md')
	z.close()

# Upload the deployment zip to S3
def upload_to_s3():
	try:
		client = boto3.client('s3')
	except ClientError as err:
		print("Failed to create boto3 client.\n" + str(err))
		return False

	try:
		client.put_object(
			Body=open(ZIP_FILENAME, 'rb'),
			Bucket=S3_BUCKET,
			Key=BUCKET_KEY
		)
	except ClientError as err:
		print("Failed to upload artifact to S3.\n" + str(err))
		return False
	except IOError as err:
		print("Failed to access artifact.zip in this directory.\n" + str(err))
		return False
	return True

# Create a new application version on ElasticBeanstalk
def create_new_version():
	try:
		client = boto3.client('elasticbeanstalk', region_name=REGION_NAME)
	except ClientError as err:
		print("Failed to create boto3 client.\n" + str(err))
		return False

	try:
		response = client.create_application_version(
			ApplicationName=APPLICATION_NAME,
			VersionLabel=VERSION_LABEL,
			Description='New build from deploy.py',
			SourceBundle=
			{
				'S3Bucket': S3_BUCKET,
				'S3Key': BUCKET_KEY
			},
			Process=True
		)
	except ClientError as err:
		print("Failed to create application version.\n" + str(err))
		return False

	try:
		if response['ResponseMetadata']['HTTPStatusCode'] is 200:
			return True
		else:
			print(response)
			return False
	except (KeyError, TypeError) as err:
		print(str(err))
		return False

# Deploy the new application version
def deploy_new_version():
	try:
		client = boto3.client('elasticbeanstalk', region_name=REGION_NAME)
	except ClientError as err:
		print("Failed to create boto3 client.\n" + str(err))
		return False

	try:
		response = client.update_environment(
			ApplicationName=APPLICATION_NAME,
			EnvironmentName=APPLICATION_ENVIRONMENT,
			VersionLabel=VERSION_LABEL,
		)
	except ClientError as err:
		print("Failed to update environment.\n" + str(err))
		return False

	print(response)
	return True

# Main method
def main():
	print('Creating zip file...')
	create_zip()
	print('Uploading to S3 bucket...')
	if not upload_to_s3():
		sys.exit(1)
	print('Creating new application version...')
	if not create_new_version():
		sys.exit(1)
	sleep(5)
	print('Deploying new version...')
	if not deploy_new_version():
		sys.exit(-1)
	print('Deployed!')

if __name__ == '__main__':
	main()
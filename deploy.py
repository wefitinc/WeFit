#!/usr/bin/env python

import os
import zipfile

# Add all files in a directory
def add_dir(z, path):
	for root, dires, files in os.walk(path):
		for file in files:
			z.write(os.path.join(root, file))

# Add a directory with only a dummy file in it
def add_dummy_dir(z, path):
	z.write(path+'/.keep')

if __name__ == '__main__':
	z = zipfile.ZipFile('WeFit.zip', 'w', zipfile.ZIP_DEFLATED)
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

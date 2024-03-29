# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Seed the test user
User.create(
  email: 'test@test.com', 
  password: 'SuperSecretTestPassword',
  first_name: 'Test',
  last_name: 'Test',
  birthdate: '1970-01-01',
  gender: 'Other')Admin.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?
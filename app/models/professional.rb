class Professional < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  RATES = ['Standard', 'Plus']
  TYPES = ["Personal Trainer", "Dietitian", "Primary Care Physician", "Psychiatrist", "Naturopath", "Dentist/Orthodontist", "Chiropractor"]

  # Implement BCrypt passwords
  has_secure_password

  # Needs a name
  validates :first_name,  
    presence: true, 
    length: { maximum: 50 }
  validates :last_name,  
    presence: true, 
    length: { maximum: 50 }
  # The user needs a valid email address, unique within the database
  validates :email, 
    presence: true, 
    uniqueness: true,
    length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX }
  # Needs a password
  validates :password,
    presence: true,
    length: { minimum: 6 }
  # Needs a type
  validates :type,
    presence: true,
    inclusion: { in: TYPES }
  # Needs a customer id
  validates :customer_id,
    presence: true
  # Needs a rate to bill at
  validates :rate,
    presence: true,
    inclusion: { in: RATES }
  validates :prices,
    presence: true
   
end

module ActsAsGendered
  GENDERS = ['Male','Female']
  
  def self.included(base)
    base.extend(ActsAsGenderedMethods)
  end

  module ActsAsGenderedMethods
    def acts_as_gendered
      extend ClassMethods
      include InstanceMethods

      validates_inclusion_of :gender, :in => GENDERS
    end
  end

  module ClassMethods
    def is_gendered?
      true
    end
  end

  module InstanceMethods
    def is_male
      gender = 'Male'
    end

    def is_female
      gender = 'Female'
    end

    def is_male?
      gender == 'Male'
    end

    def is_female?
      gender == 'Female'
    end
  end
end
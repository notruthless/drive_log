# == Schema Information
# Schema version: 20110610012744
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean
#

require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation

  has_many :log_entries, :dependent => :destroy
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  Total_time = { :day => 40*60, :night => 10*60, :all => 50*60} # in minutes. constant for now, preferences later?

  
  validates :name,  :presence => true,
                    :length   => { :maximum => 50 }
  validates :email, :presence => true,
                    :format   => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }
  before_save :encrypt_password
  
  scope :admin, where(:admin => true)


  def total_elapsed_time (kind = nil)
       e_time = 0 
      unless log_entries.empty?
				if kind.class == Symbol
					 entries = log_entries.send(kind) #:day or :night
				else
					entries = log_entries
				end
				entries.each do |entry|
			    if entry
					   e_time += entry.elapsed_time
					end
				end
     end
		return e_time
 end
  
  def time_remaining(kind = nil)
	    t = time_required(kind) - total_elapsed_time(kind)
      return t<0? 0 : t
	end

	def time_required (kind = nil)
	# this could be retrieved from user preferences at some later point.
	# kind should be :day or :night
		total = nil
		if kind.class == Symbol
		 total = Total_time[kind]
		end
		
		if !total  # no param or invalid kind
			total = Total_time[:all]
		end
		return total
	end
	

  
 # Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    # Compare encrypted_password with the encrypted version of
    # submitted_password.
    encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
    return nil
  end
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  private

    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end

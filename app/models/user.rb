class User < ApplicationRecord
    
    has_secure_password

    validates :name, presence: true, length: {maximum: 30}
    validates :username, presence: true, uniqueness: true
    validates :password, presence: true, if: -> { new_record? || !password.nil? }

end

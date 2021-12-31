class Chat < ApplicationRecord
    validates :messages, presence: true
    validates :from_user, presence: true
    validates :to_user, presence: true


end

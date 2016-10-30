class User < ApplicationRecord
  has_secure_password
  validates :name,presence: true,uniqueness: true
  after_destroy :ensure_an_admin_remains

  class Error < StandardError

  end
  
  private
    def ensure_an_admin_remains
      if User.count.zero?
        raise Error.new "can't del last user"
      end
    end
end

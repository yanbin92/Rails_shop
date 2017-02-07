class User < ApplicationRecord
  has_secure_password
  validates :name,presence: true,uniqueness: true# uniqueness case_sensitive: 是否区分大小写
  after_destroy :ensure_an_admin_remains
  validates :password,confirmation: true  #confirmation 用于检查两个文本字段的值是否完全相同  
  # 只有xx_confirmation的值不是nil时才 会做这个验证 所以要为属性增加存在性验证 presence  默认错误信息是 doesn't match confirmation
  validates :password_confirmation, presence: true, length: {minimum: 6,maximum: 12}
  #length: is指定长度   in 指定长度范围
  validates :is_access,acceptance: true



  class Error < StandardError

  end
  
  private
    def ensure_an_admin_remains
      if User.count.zero?
        raise Error.new "can't del last user"
      end
    end
end

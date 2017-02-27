class LineItem < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :product, optional: true

  validates :product , presence: true#如果要保证关联对象存在  需要测试关联对象本身是否存在  需要在product中在配置下 

  belongs_to :cart
  
  def total_price
  	price * quantity
  end

  def decrement
    # byebug
  	if(self.quantity > 1)
  		self.quantity -= 1
  	else
  		self.destroy
  	end
  	self
  end
end

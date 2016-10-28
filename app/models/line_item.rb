class LineItem < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :product, optional: true
  belongs_to :cart
  
  def total_price
  	price * quantity
  end

  def decrement
  	if(self.quantity > 1)
  		self.quantity -= 1
  	else
  		self.destroy
  	end
  	self
  end
end

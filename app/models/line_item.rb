class LineItem < ApplicationRecord
  belongs_to :order, optional: true
  #如果LineItem的任何一个属性变了，updated_at 的值会设为当前时间，因此缓存失效。然而，商品对象的 updated_at 属性不变，因此它的缓存不失效，从而导致应用伺服过期的数据。为了解决这个问题，可以使用 touch 方法把模型绑在一起：
  belongs_to :product, optional: true ,touch: true
  #把 touch 设为 true 后，导致游戏的 updated_at 变化的操作，也会修改关联的商品的 updated_at 属性，从而让缓存失效。

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

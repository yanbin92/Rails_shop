class Product < ApplicationRecord
	has_many :line_items
	before_destroy :ensure_not_referenced_by_any_line_ltem
	validates(:title,:description,:image_url,:presence => true)
	validates :price,:numericality=>{:greater_than_or_equal_to=>0.01}
	validates :title,:uniqueness=>true
	validates :image_url,allow_blank: true, :format=>{
		:with => %r{\.(gif|jpg|png|webp)\z}i,
		:message => 'must be a URL for gif,jpg,png,wbp'
	}

    validates :image_url,uniqueness: true
    
	private 
		def ensure_not_referenced_by_any_line_ltem
			unless line_items.empty?
				errors.add(:base,'Line Items present')
				throw :abort
			end
		end
end

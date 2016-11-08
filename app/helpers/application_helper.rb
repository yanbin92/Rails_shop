module ApplicationHelper
	def hidden_div_if(condition,attributes = {},&block)
		#attributes = {}  变量的默认值是空的哈希 
		if condition 
			attributes["style"] = "display: none"
		end
		content_tag("div",attributes,&block)
	end
end

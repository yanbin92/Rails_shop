class UploadController < ApplicationController
  def get #=> save
  	@picture = Picture.new
  end

  def save
  	@picture = Picture.new(picture_params)
  	if @picture.save
  		redirect_to(action: 'show',id: @picture.id)
  	else
  		render(action: :get)
  	end
  end

  def picture  #Paperclip4 attachment_fu5 plugins 
	@picture = Picture.find(params[:id])
	send_data(@picture.data,
	filename: @picture.name,
	type: @picture.content_type,
	disposition: "inline")
  end
  #show
  def show
	@picture = Picture.find(params[:id])
  end

  private 
  	def picture_params
  		params.require(:picture).permit(:comment,:uploaded_picture)
	end
end

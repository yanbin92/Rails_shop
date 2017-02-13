class UploadController < ApplicationController
  def get #=> save
  	@picture = Picture.new
  end

  def save
  	@picture = Picture.new(picture_params)
    upload()
  	if @picture.save
  		redirect_to(action: 'show',id: @picture.id)
  	else
  		render(action: :get)
  	end
  end
  #文件上传完毕后可以做很多操作，例如把文件存储在某个地方（服务器的硬盘，Amazon S3 等）；把文件和模型关联起来；缩放图片，生成缩略图。这些复杂的操作已经超出了本文范畴。有很多代码库可以协助完成这些操作，其中两个广为人知的是 CarrierWave 和 Paperclip。
  def upload
    uploaded_io = params[:picture][:uploaded_picture]
    File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
    end
  end

  #send_data 和 send_file 方法。这两个方法都会以数据流的方式发送数据。send_file 方法很方便，只要提供硬盘中文件的名字，就会用数据流发送文件内容
  def download_img
    @picture = Picture.find(params[:id])
    send_data(@picture.data,
    filename: @picture.name,
    type: @picture.content_type)
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

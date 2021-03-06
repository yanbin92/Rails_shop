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
    #文件上传 如果我们把上传的文件储存在 /var/www/uploads 文件夹中，而用户输入了类似 ../../../etc/passwd 的文件名，在没有对文件名进行过滤的情况下，passwd 这个重要文件就有可能被覆盖
    #注意请确保文件上传时不会覆盖重要文件，同时对于媒体文件应该采用异步上传方式。
    #最佳策略是使用白名单，只允许在文件名中使用白名单中的字符。黑名单的做法是尝试删除禁止使用的字符，白名单的做法恰恰相反。对于无效的文件名，可以直接拒绝（或者把禁止使用的字符都替换掉），但不要尝试删除禁止使用的字符
    #通过同步方式上传文件（attachment_fu 插件也能用于上传图像）的一个明显缺点是，存在受到拒绝服务攻击（denial-of-service，简称 DoS）的风险
    #最佳解决方案是，对于媒体文件采用异步上传方式：保存媒体文件，并通过数据库调度程序处理请求。由另一个进程在后台完成文件上传。
    # threads = []
    # threads << Thread.new { func1 }
    # threads << Thread.new { func2 }
    # threads << Thread.new { func3 }

    # threads.each { |t| t.join }
    uploaded_io = params[:picture][:uploaded_picture]
    File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
    end
  end

  #send_data 和 send_file 方法。这两个方法都会以数据流的方式发送数据。send_file 方法很方便，只要提供硬盘中文件的名字，就会用数据流发送文件内容
  def download_img
    #请确保用户不能随意下载文件。
    #正如在上传文件时必须过滤文件名，在下载文件时也必须进行过滤。send_file() 方法用于把服务器上的文件发送到客户端。如果传递给 send_file() 方法的文件名参数是由用户输入的，却没有进行过滤，用户就能够下载服务器上的任何文件：
    #send_file('/var/www/uploads/' + params[:filename])
    #对此，一个简单的解决方案是，检查所请求的文件是否在规定的文件夹中
    @picture = Picture.find(params[:id])
    send_data(@picture.data,
    filename: @picture.name,
    type: @picture.content_type)
  end
  ####不建议通过 Rails 以数据流的方式发送静态文件，你可以把静态文件放在服务器的公共文件夹中，使用 Apache 或其他服务器下载效率更高，因为不用经由整个 Rails 处理
  # Stream a file that has already been generated and stored on disk.
  def download_pdf
    client = Client.find(params[:id])
    send_file("#{Rails.root}/files/clients/#{client.id}.pdf",
              filename: "#{client.name}.pdf",
              type: "application/pdf")
  end


  def picture  #Paperclip4 attachment_fu5 plugins 
  	@picture = Picture.find(params[:id])
  	send_data(@picture.data,
  	filename: @picture.name,
  	type: @picture.content_type,
  	disposition: "inline")
  end
  #GET /show/1
  #show
  def show
  	@picture = Picture.find(params[:id])
    # 使用 REST 的方式下载文件
    # respond_to do |format|    
    #   format.html
    #   format.pdf {render pdf: }
    # end
    # 在 config/initializers/mime_types.rb 文件中加入下面这行代码即可：

    # Mime::Type.register "application/pdf", :pdf

  end

  private 
  	def picture_params
  		params.require(:picture).permit(:comment,:uploaded_picture)
	 end
   
end

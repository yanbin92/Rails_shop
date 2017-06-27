# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'
#采用 GZip 
use Rack::Deflater
#可能遇到的问题：
#如果服务器返回的不是 JSON 等数据，而是企图下载文件，且客户端依然请求 GZip，
#还是会被压缩（虽然这个压缩可能会越压越大）。
#强制不压缩，就是忽略那个 request header，可以这么做：
=begin
def check_update_data
    send_file(file, :x_sendfile => true)
    headers['Content-Length'] = File.size(file)
    request.env['HTTP_ACCEPT_ENCODING'] = nil
end
=end
run Rails.application


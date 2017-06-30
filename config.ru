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
启用 GZIP 是实现起来最简单并且回报最高的优化之一，遗憾的是，仍有许多人不去实现它。
大多数网络服务器都会代您完成压缩内容的工作，您只需要确认服务器进行了正确配置，
能够对所有可受益于 GZIP 压缩的内容进行压缩。

压缩就是使用更少的位对信息进行编码的过程。
消除不必要的数据总是会产生最好的结果。
有许多种不同的压缩技术和算法。
您需要利用各种技术来实现最佳压缩

阻塞渲染的 CSS
<link href="style.css"    rel="stylesheet">
<link href="style.css"    rel="stylesheet" media="all">
<link href="portrait.css" rel="stylesheet" media="orientation:portrait">
<link href="print.css"    rel="stylesheet" media="print">
第一个声明阻塞渲染，适用于所有情况。
第二个声明同样阻塞渲染：“all”是默认类型，如果您不指定任何类型，则隐式设置为“all”。因此，第一个声明和第二个声明实际上是等效的。
第三个声明具有动态媒体查询，将在网页加载时计算。根据网页加载时设备的方向，portrait.css 可能阻塞渲染，也可能不阻塞渲染。
最后一个声明只在打印网页时应用，因此网页首次在浏览器中加载时，它不会阻塞渲染。
最后，请注意“阻塞渲染”仅是指浏览器是否需要暂停网页的首次渲染，直至该资源准备就绪。无论哪一种情况，浏览器仍会下载 CSS 资产，只不过不阻塞渲染的资源优先级较低罢了。
<script async>  不修改dom和css的script不该被阻塞 
window.onload deng js bu hui bei css 阻塞渲染
阻止（Blocking）: <script src="anExteralScript.js"></script>
内联（Inline）: <script>document.write("this is an inline script")</script>
异步（Async）: <script async src="anExternalScript.js"></script>

14k

请查看指导如何交付可在一秒或一秒内呈现的页面的 PageSpeed 移动分析文档。要详细了解有关 TCP 慢启动的信息，请查看 Ilya 的著作 高性能浏览器联网。

=end
run Rails.application


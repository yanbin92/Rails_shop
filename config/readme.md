#第 23 章 Asset Pipeline

本文介绍 Asset Pipeline。

读完本文后，您将学到：

Asset Pipeline 是什么，有什么用处；

如何合理组织应用的静态资源文件；

使用 Asset Pipeline 的好处；

如何为 Asset Pipeline 添加预处理器；

如何用 gem 打包静态资源文件。

##23.1 Asset Pipeline 是什么
Asset Pipeline 提供了用于连接、简化或压缩 JavaScript 和 CSS 静态资源文件的框架。有了 Asset Pipeline，我们还可以使用其他语言和预处理器，例如 CoffeeScript、Sass 和 ERB，编写这些静态资源文件。应用中的静态资源文件还可以自动与其他 gem 中的静态资源文件合并。例如，与 jquery-rails gem 中包含的 jquery.js 文件合并，从而使 Rails 能够支持 AJAX 特性。

Asset Pipeline 是通过 sprockets-rails gem 实现的，Rails 默认启用了这个 gem。在新建 Rails 应用时，通过 --skip-sprockets 选项可以禁用这个 gem。

$ rails new appname --skip-sprockets
在新建 Rails 应用时，Rails 自动在 Gemfile 中添加了 sass-rails、coffee-rails 和 uglifier gem，Sprockets 通过这些 gem 来压缩静态资源文件：

gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
使用 --skip-sprockets 选项时，Rails 不会在 Gemfile 中添加这些 gem。因此，之后如果想要启用 Asset Pipeline，就需要手动在 Gemfile 中添加这些 gem。此外，使用 --skip-sprockets 选项时生成的 config/application.rb 也略有不同，用于加载 sprockets/railtie 的代码被注释掉了，因此要启用 Asset Pipeline，还需要取消注释：

# require "sprockets/railtie"
在 production.rb 配置文件中，通过 config.assets.css_compressor 和 config.assets.js_compressor 选项可以分别为 CSS 和 JavaScript 静态资源文件设置压缩方式：

config.assets.css_compressor = :yui
config.assets.js_compressor = :uglifier
注意
如果 Gemfile 中包含 sass-rails gem，Rails 就会自动使用这个 gem 压缩 CSS 静态资源文件，而无需设置 config.assets.css_compressor 选项。
###23.1.1 主要特性

Asset Pipeline 的特性之一是连接静态资源文件，目的是减少渲染网页时浏览器发起的请求次数。Web 浏览器能够同时发起的请求次数是有限的，因此更少的请求次数可能意味着更快的应用加载速度。

Sprockets 把所有 JavaScript 文件连接为一个主 .js 文件，把所有 CSS 文件连接为一个主 .css 文件。后文会介绍，我们可以按需定制连接文件的方式。在生产环境中，Rails 会在每个文件名中插入 MD5 指纹，以便 Web 浏览器缓存文件。当我们修改了文件内容，Rails 会自动修改文件名中的指纹，从而让原有缓存失效。

Asset Pipeline 的特性之二是简化或压缩静态资源文件。对于 CSS 文件，会删除空格和注释。对于 JavaScript 文件，可以进行更复杂的处理，我们可以从内置选项中选择处理方式，也可以自定义处理方式。

Asset Pipeline 的特性之三是可以使用更高级的语言编写静态资源文件，再通过预编译转换为实际的静态资源文件。默认支持的高级语言有：用于编写 CSS 的 Sass，用于编写 JavaScript 的 CoffeeScript，以及 ERB。

###23.1.2 指纹识别是什么，为什么要关心指纹？

指纹是一项根据文件内容修改文件名的技术。一旦文件内容发生变化，文件名就会发生变化。对于静态文件或内容很少发生变化的文件，这项技术提供了确定文件的两个版本是否相同的简单方法，特别是在跨服务器和多次部署的情况下。

当一个文件的文件名能够根据文件内容发生变化，并且能够保证不会出现重名时，就可以通过设置 HTTP 首部来建议所有缓存（CDN、ISP、网络设备或 Web 浏览器的缓存）都保存该文件的副本。一旦文件内容更新，文件名中的指纹就会发生变化，从而使远程客户端发起对文件新副本的请求。这项技术称为“缓存清除”（cache busting）。

Sprockets 使用指纹的方式是在文件名中添加文件内容的哈希值，并且通常会添加到文件名末尾。例如，对于 CSS 文件 global.css，添加哈希值后文件名可能变为：

global-908e25f4bf641868d8683022a5b62f54.css
Rails 的 Asset Pipeline 也采取了这种策略。

以前 Rails 采用的策略是，通过内置的辅助方法，为每一个指向静态资源文件的链接添加基于日期生成的查询字符串。在网页源代码中，会生成下面这样的链接：

/stylesheets/global.css?1309495796
使用查询字符串的策略有如下缺点：

1. 如果一个文件的两个版本只是文件名的查询参数不同，这时不是所有缓存都能可靠地更新该文件的缓存。
Steve Souders 建议，“……避免在可缓存的资源上使用查询字符串”。他发现，在使用查询字符串的情况下，有 5—20% 的请求不会被缓存。对于某些 CDN，通过修改查询字符串根本无法使缓存失效。

2. 在多服务器环境中，不同节点上的文件名有可能发生变化。
在 Rails 2.x 中，默认基于文件修改时间生成查询字符串。当静态资源文件被部署到某个节点上时，无法保证文件的时间戳保持不变，这样，对于同一个文件的请求，不同服务器可能返回不同的文件名。

3. 缓存失效的情况过多。
每次部署代码的新版本时，静态资源文件都会被重新部署，这些文件的最后修改时间也会发生变化。这样，不管其内容是否发生变化，客户端都不得不重新获取这些文件。

使用指纹可以避免使用查询字符串的这些缺点，并且能够确保文件内容相同时文件名也相同。

在开发环境和生产环境中，指纹都是默认启用的。通过 config.assets.digest 配置选项，可以启用或禁用指纹。

扩展阅读：

优化缓存

为文件名添加版本号：请不要使用查询字符串

##23.2 如何使用 Asset Pipeline
在 Rails 的早期版本中，所有静态资源文件都放在 public 文件夹的子文件夹中，例如 images、javascripts 和 stylesheets 子文件夹。当 Rails 开始使用 Asset Pipeline 后，就推荐把静态资源文件放在 app/assets 文件夹中，并使用 Sprockets 中间件处理这些文件。

当然，静态资源文件仍然可以放在 public 文件夹及其子文件夹中。只要把 config.public_file_server.enabled 选项设置为 true，Rails 应用或 Web 服务器就会处理 public 文件夹及其子文件夹中的所有静态资源文件。但对于需要预处理的文件，都应该放在 app/assets 文件夹中。

在生产环境中，Rails 默认会对 public/assets 文件夹中的文件进行预处理。经过预处理的静态资源文件将由 Web 服务器直接处理。在生产环境中，app/assets 文件夹中的文件不会直接交由 Web 服务器处理。

###23.2.1 针对控制器的静态资源文件

当我们使用生成器生成脚手架或控制器时，Rails 会同时为控制器生成 JavaScript 文件（如果 Gemfile 中包含了 coffee-rails gem，那么生成的是 CoffeeScript 文件）和 CSS 文件（如果 Gemfile 中包含了 sass-rails gem，那么生成的是 SCSS 文件）。此外，在生成脚手架时，Rails 还会生成 scaffolds.css 文件（如果 Gemfile 中包含了 sass-rails gem，那么生成的是 scaffolds.scss 文件）。

例如，当我们生成 ProjectsController 时，Rails 会新建 app/assets/javascripts/projects.coffee 文件和 app/assets/stylesheets/projects.scss 文件。默认情况下，应用会通过 require_tree 指令引入这两个文件。关于 require_tree 指令的更多介绍，请参阅 23.2.4 节。

针对控制器的 JavaScript 文件和 CSS 文件也可以只在相应的控制器中引入：

<%= javascript_include_tag params[:controller] %> 或 <%= stylesheet_link_tag params[:controller] %>

此时，千万不要使用 require_tree 指令，否则就会重复包含这些静态资源文件。

提醒
在进行静态资源文件预编译时，请确保针对控制器的静态文件是在按页加载时进行预编译的。默认情况下，Rails 不会自动对 .coffee 和 .scss 文件进行预编译。关于预编译工作原理的更多介绍，请参阅 23.4.1 节。
注意
要使用 CoffeeScript，就必须安装支持 ExecJS 的运行时。macOS 和 Windows 已经预装了此类运行时。关于所有可用运行时的更多介绍，请参阅 ExecJS 文档。
通过在 config/application.rb 配置文件中添加下述代码，可以禁止生成针对控制器的静态资源文件：

config.generators do |g|
  g.assets false
end
###23.2.2 静态资源文件的组织方式

应用的 Asset Pipeline 静态资源文件可以储存在三个位置：app/assets、lib/assets 和 vendor/assets。

app/assets 文件夹用于储存应用自有的静态资源文件，例如自定义图像、JavaScript 文件和 CSS 文件。

lib/assets 文件夹用于储存自有代码库的静态资源文件，这些代码库或者不适合放在当前应用中，或者需要在多个应用间共享。

vendor/assets 文件夹用于储存第三方代码库的静态资源文件，例如 JavaScript 插件和 CSS 框架。如果第三方代码库中引用了同样由 Asset Pipeline 处理的静态资源文件（图像、CSS 文件等），就必须使用 asset_path 这样的辅助方法重新编写相关代码。

提醒
从 Rails 3 升级而来的用户需要注意，通过设置应用的清单文件， 我们可以包含 lib/assets 和 vendor/assets 文件夹中的静态资源文件，但是这两个文件夹不再是预编译数组的一部分。更多介绍请参阅 23.4.1 节。
###23.2.2.1 搜索路径
当清单文件或辅助方法引用了静态资源文件时，Sprockets 会在静态资源文件的三个默认存储位置中进行查找。

这三个默认存储位置分别是 app/assets 文件夹的 images、javascripts 和 stylesheets 子文件夹，实际上这三个文件夹并没有什么特别之处，所有的 app/assets/* 文件夹及其子文件夹都会被搜索。

例如，下列文件：

app/assets/javascripts/home.js
lib/assets/javascripts/moovinator.js
vendor/assets/javascripts/slider.js
vendor/assets/somepackage/phonebox.js
在清单文件中可以像下面这样进行引用：

//= require home
//= require moovinator
//= require slider
//= require phonebox
这些文件夹的子文件夹中的静态资源文件：

app/assets/javascripts/sub/something.js
可以像下面这样进行引用：

//= require sub/something
通过在 Rails 控制台中检查 Rails.application.config.assets.paths 变量，我们可以查看搜索路径。

除了标准的 app/assets/* 路径，还可以在 config/application.rb 配置文件中为 Asset Pipeline 添加其他路径。例如：

config.assets.paths << Rails.root.join("lib", "videoplayer", "flash")
Rails 会按照路径在搜索路径中出现的先后顺序，对路径进行遍历。因此，在默认情况下，app/assets 中的文件优先级最高，将会遮盖 lib 和 vendor 文件夹中的同名文件。

千万注意，在清单文件之外引用的静态资源文件必须添加到预编译数组中，否则无法在生产环境中使用。

23.2.2.2 使用索引文件
对于 Sprockets，名为 index（带有相关扩展名）的文件具有特殊用途。

例如，假设应用中使用的 jQuery 库及多个模块储存在 lib/assets/javascripts/library_name 文件夹中，那么 lib/assets/javascripts/library_name/index.js 文件将作为这个库的清单文件。在这个库的清单文件中，应该按顺序列出所有需要加载的文件，或者干脆使用 require_tree 指令。

在应用的清单文件中，可以把这个库作为一个整体加载：

//= require library_name
这样，相关代码总是作为整体在应用中使用，降低了维护成本，并使代码保持简洁。

23.2.3 创建指向静态资源文件的链接

Sprockets 没有为访问静态资源文件添加任何新方法，而是继续使用我们熟悉的 javascript_include_tag 和 stylesheet_link_tag 辅助方法：

<%= stylesheet_link_tag "application", media: "all" %>
<%= javascript_include_tag "application" %>
如果使用了 Rails 默认包含的 turbolinks gem，并使用了 data-turbolinks-track 选项，Turbolinks 就会检查静态资源文件是否有更新，如果有更新就加载到页面中：

<%= stylesheet_link_tag "application", media: "all", "data-turbolinks-track" => "reload" %>
<%= javascript_include_tag "application", "data-turbolinks-track" => "reload" %>
在常规视图中，我们可以像下面这样访问 public/assets/images 文件夹中的图像：

<%= image_tag "rails.png" %>
如果在应用中启用了 Asset Pipeline，并且未在当前环境中禁用 Asset Pipeline，那么这个图像文件将由 Sprockets 处理。如果图像的位置是 public/assets/rails.png，那么将由 Web 服务器处理。

如果文件请求包含哈希值，例如 public/assets/rails-af27b6a414e6da00003503148be9b409.png，处理的方式也是一样的。关于如何生成哈希值的介绍，请参阅 23.4 节。

Sprockets 还会检查 config.assets.paths 中指定的路径，其中包括 Rails 应用的标准路径和 Rails 引擎添加的路径。

也可以把图像放在子文件夹中，访问时只需加上子文件夹的名称即可：

<%= image_tag "icons/rails.png" %>
提醒
如果对静态资源文件进行了预编译（请参阅 23.4 节），那么在页面中链接到并不存在的静态资源文件或空字符串将导致该页面抛出异常。因此，在使用 image_tag 等辅助方法处理用户提供的数据时一定要小心。
23.2.3.1 CSS 和 ERB
Asset Pipeline 会自动计算 ERB 的值。也就是说，只要给 CSS 文件添加 .erb 扩展名（例如 application.css.erb），就可以在 CSS 规则中使用 asset_path 等辅助方法。

.class { background-image: url(<%= asset_path 'image.png' %>) }
上述代码中的 asset_path 辅助方法会返回指向图像真实路径的链接。图像必须位于静态文件加载路径中，例如 app/assets/images/image.png，以便在这里引用。如果在 public/assets 文件夹中已经存在此图像的带指纹的版本，那么将引用这个带指纹的版本。

要想使用 data URI（用于把图像数据直接嵌入 CSS 文件中），可以使用 asset_data_uri 辅助方法：

#logo { background: url(<%= asset_data_uri 'logo.png' %>) }
asset_data_uri 辅助方法会把正确格式化后的 data URI 插入 CSS 源代码中。

注意，关闭标签不能使用 -%> 形式。

23.2.3.2 CSS 和 Sass
在使用 Asset Pipeline 时，静态资源文件的路径都必须重写，为此 sass-rails gem 提供了 -url 和 -path 系列辅助方法（在 Sass 中使用连字符，在 Ruby 中使用下划线），用于处理图像、字体、视频、音频、JavaScript 和 CSS 等类型的静态资源文件。

image-url("rails.png") 会返回 url(/assets/rails.png)

image-path("rails.png") 会返回 "/assets/rails.png"

或使用更通用的形式：

asset-url("rails.png") 返回 url(/assets/rails.png)

asset-path("rails.png") 返回 "/assets/rails.png"

23.2.3.3 JavaScript/CoffeeScript 和 ERB
只要给 JavaScript 文件添加 .erb 扩展名（例如 application.js.erb），就可以在 JavaScript 源代码中使用 asset_path 辅助方法：

$('#logo').attr({ src: "<%= asset_path('logo.png') %>" });
上述代码中的 asset_path 辅助方法会返回指向图像真实路径的链接。

同样，只要给 CoffeeScript 文件添加 .erb 扩展名（例如 application.coffee.erb），就可以在 CoffeeScript 源代码中使用 asset_path 辅助方法：

$('#logo').attr src: "<%= asset_path('logo.png') %>"
23.2.4 清单文件和指令

Sprockets 使用清单文件来确定需要包含和处理哪些静态资源文件。这些清单文件中的指令会告诉 Sprockets，要想创建 CSS 或 JavaScript 文件需要加载哪些文件。通过这些指令，可以让 Sprockets 加载指定文件，对这些文件进行必要的处理，然后把它们连接为单个文件，最后进行压缩（压缩方式取决于 Rails.application.config.assets.js_compressor 选项的值）。这样在页面中只需处理一个文件而非多个文件，减少了浏览器的请求次数，大大缩短了页面的加载时间。通过压缩还能使文件变小，使浏览器可以更快地下载。

例如，在默认情况下，新建 Rails 应用的 app/assets/javascripts/application.js 文件包含下面几行代码：

// ...
//= require jquery
//= require jquery_ujs
//= require_tree .
在 JavaScript 文件中，Sprockets 指令以 //=. 开头。上述代码中使用了 require 和 require_tree 指令。require 指令用于告知 Sprockets 哪些文件需要加载。这里加载的是 Sprockets 搜索路径中的 jquery.js 和 jquery_ujs.js 文件。我们不必显式提供文件的扩展名，因为 Sprockets 假定在 .js 文件中加载的总是 .js 文件。

require_tree 指令告知 Sprockets 以递归方式包含指定文件夹中的所有 JavaScript 文件。在指定文件夹路径时，必须使用相对于清单文件的相对路径。也可以通过 require_directory 指令包含指定文件夹中的所有 JavaScript 文件，此时将不会采取递归方式。

清单文件中的指令是按照从上到下的顺序处理的，但我们无法确定 require_tree 指令包含文件的顺序，因此不应该依赖于这些文件的顺序。如果想要确保连接文件时某些 JavaScript 文件出现在其他 JavaScript 文件之前，可以在清单文件中先行加载这些文件。注意，require 系列指令不会重复加载文件。

在默认情况下，新建 Rails 应用的 app/assets/stylesheets/application.css 文件包含下面几行代码：

/* ...
*= require_self
*= require_tree .
*/
无论新建 Rails 应用时是否使用了 --skip-sprockets 选项，Rails 都会创建 app/assets/javascripts/application.js 和 app/assets/stylesheets/application.css 文件。因此，之后想要使用 Asset Pipeline 非常容易。

我们在 JavaScript 文件中使用的指令同样可以在 CSS 文件中使用，此时加载的是 CSS 文件而不是 JavaScript 文件。在 CSS 清单文件中，require_tree 指令的工作原理和在 JavaScript 清单文件中相同，会加载指定文件夹中的所有 CSS 文件。

上述代码中使用了 require_self 指令，用于把当前文件中的 CSS 代码（如果存在）插入调用这个指令的位置。

注意
要想使用多个 Sass 文件，通常应该使用 Sass @import 规则，而不是 Sprockets 指令。如果使用 Sprockets 指令，这些 Sass 文件将拥有各自的作用域，这样变量和混入只能在定义它们的文件中使用。
和使用 require_tree 指令相比，使用 @import "*" 和 @import "**/*" 的效果完全相同，都能加载指定文件夹中的所有文件。更多介绍和注意事项请参阅 sass-rails 文档。

我们可以根据需要使用多个清单文件。例如，可以用 admin.js 和 admin.css 清单文件分别包含应用管理后台的 JS 和 CSS 文件。

CSS 清单文件中指令的执行顺序类似于前文介绍的 JavaScript 清单文件，尤其是加载的文件都会按照指定顺序依次编译。例如，我们可以像下面这样把 3 个 CSS 文件连接在一起：

/* ...
*= require reset
*= require layout
*= require chrome
*/
23.2.5 预处理

静态资源文件的扩展名决定了预处理的方式。在使用默认的 Rails gemset 生成控制器或脚手架时，会生成 CoffeeScript 和 SCSS 文件，而不是普通的 JavaScript 和 CSS 文件。在前文的例子中，生成 projects 控制器时会生成 app/assets/javascripts/projects.coffee 和 app/assets/stylesheets/projects.scss 文件。

在开发环境中，或 Asset Pipeline 被禁用时，会使用 coffee-script 和 sass gem 提供的处理器分别处理相应的文件请求，并把生成的 JavaScript 和 CSS 文件发给浏览器。当 Asset Pipeline 可用时，会对这些文件进行预处理，然后储存在 public/assets 文件夹中，由 Rails 应用或 Web 服务器处理。

通过添加其他扩展名，可以对文件进行更多预处理。对扩展名的解析顺序是从右到左，相应的预处理顺序也是从右到左。例如，对于 app/assets/stylesheets/projects.scss.erb 文件，会先处理 ERB，再处理 SCSS，最后作为 CSS 文件处理。同样，对于 app/assets/javascripts/projects.coffee.erb 文件，会先处理 ERB，再处理 CoffeeScript，最后作为 JavaScript 文件处理。

记住预处理顺序很重要。例如，如果我们把文件名写为 app/assets/javascripts/projects.erb.coffee，就会先处理 CoffeeScript，这时一旦遇到 ERB 代码就会出错。

23.3 在开发环境中
在开发环境中，Asset Pipeline 会按照清单文件中指定的顺序处理静态资源文件。

对于清单文件 app/assets/javascripts/application.js：

//= require core
//= require projects
//= require tickets
会生成下面的 HTML：

<script src="/assets/core.js?body=1"></script>
<script src="/assets/projects.js?body=1"></script>
<script src="/assets/tickets.js?body=1"></script>
其中 body 参数是使用 Sprockets 时必须使用的参数。

23.3.1 检查运行时错误

在生产环境中，Asset Pipeline 默认会在运行时检查潜在错误。要想禁用此行为，可以设置：

config.assets.raise_runtime_errors = false
当此选项设置为 true 时，Asset Pipeline 会检查应用中加载的所有静态资源文件是否都已包含在 config.assets.precompile 列表中。如果此时 config.assets.digest 也设置为 true，Asset Pipeline 会要求所有对静态资源文件的请求都包含指纹（digest）。

23.3.2 关闭指纹

通过修改 config/environments/development.rb 配置文件，我们可以关闭指纹：

config.assets.digest = false
当此选项设置为 true 时，Rails 会为静态资源文件的 URL 生成指纹。

23.3.3 关闭调试

通过修改 config/environments/development.rb 配置文件，我们可以关闭调式模式：

config.assets.debug = false
当调试模式关闭时，Sprockets 会对所有文件进行必要的预处理，然后把它们连接起来。此时，前文的清单文件会生成下面的 HTML：

<script src="/assets/application.js"></script>
当服务器启动后，静态资源文件将在第一次请求时进行编译和缓存。Sprockets 通过设置 must-revalidate Cache-Control HTTP 首部，来减少后续请求造成的开销，此时对于后续请求浏览器会得到 304（未修改）响应。

如果清单文件中的某个文件在两次请求之间发生了变化，服务器会使用新编译的文件作为响应。

还可以通过 Rails 辅助方法启用调试模式：

<%= stylesheet_link_tag "application", debug: true %>
<%= javascript_include_tag "application", debug: true %>
当然，如果已经启用了调式模式，再使用 :debug 选项就完全是多余的了。

在开发模式中，我们也可以启用压缩功能以检查其工作是否正常，在需要进行调试时再禁用压缩功能。

23.4 在生产环境中
在生产环境中，Sprockets 会使用前文介绍的指纹机制。默认情况下，Rails 假定静态资源文件都经过了预编译，并将由 Web 服务器处理。

在预编译阶段，Sprockets 会根据静态资源文件的内容生成 MD5，并在保存文件时把这个 MD5 添加到文件名中。Rails 辅助方法会用这些包含指纹的文件名代替清单文件中的文件名。

例如，下面的代码：

<%= javascript_include_tag "application" %>
<%= stylesheet_link_tag "application" %>
会生成下面的 HTML：

<script src="/assets/application-908e25f4bf641868d8683022a5b62f54.js"></script>
<link href="/assets/application-4dd5b109ee3439da54f5bdfd78a80473.css" media="screen"
rel="stylesheet" />
注意
Rails 开始使用 Asset Pipeline 后，不再使用 :cache 和 :concat 选项，因此在调用 javascript_include_tag 和 stylesheet_link_tag 辅助方法时需要删除这些选项。
可以通过 config.assets.digest 初始化选项（默认为 true）启用或禁用指纹功能。

注意
在正常情况下，请不要修改默认的 config.assets.digest 选项（默认为 true）。如果文件名中未包含指纹，并且 HTTP 头信息的过期时间设置为很久以后，远程客户端将无法在文件内容发生变化时重新获取文件。
23.4.1 预编译静态资源文件

Rails 提供了一个 Rake 任务，用于编译 Asset Pipeline 清单文件中的静态资源文件和其他相关文件。

经过编译的静态资源文件将储存在 config.assets.prefix 选项指定的路径中，默认为 /assets 文件夹。

部署 Rails 应用时可以在服务器上执行这个 Rake 任务，以便直接在服务器上完成静态资源文件的编译。关于本地编译的介绍，请参阅下一节。

这个 Rake 任务是：

$ RAILS_ENV=production bin/rails assets:precompile
Capistrano（v2.15.1 及更高版本）提供了对这个 Rake 任务的支持。只需把下面这行代码添加到 Capfile 中：

load 'deploy/assets'
就会把 config.assets.prefix 选项指定的文件夹链接到 shared/assets 文件夹。当然，如果 shared/assets 文件夹已经用于其他用途，我们就得自己编写部署任务了。

需要注意的是，shared/assets 文件夹会在多次部署之间共享，这样引用了这些静态资源文件的远程客户端的缓存页面在其生命周期中就能正常工作。

编译文件时的默认匹配器（matcher）包括 application.js、application.css，以及 app/assets 文件夹和 gem 中的所有非 JS/CSS 文件（会自动包含所有图像）：

[ Proc.new { |filename, path| path =~ /app\/assets/ && !%w(.js .css).include?(File.extname(filename)) },
/application.(css|js)$/ ]
注意
这个匹配器（及预编译数组的其他成员；见后文）会匹配编译后的文件名，这意味着无论是 JS/CSS 文件，还是能够编译为 JS/CSS 的文件，都将被排除在外。例如，.coffee 和 .scss 文件能够编译为 JS/CSS，因此被排除在默认的编译范围之外。
要想包含其他清单文件，或单独的 JavaScript 和 CSS 文件，可以把它们添加到 config/initializers/assets.rb 配置文件的 precompile 数组中：

Rails.application.config.assets.precompile += ['admin.js', 'admin.css', 'swfObject.js']
注意
添加到 precompile 数组的文件名应该以 .js 或 .css 结尾，即便实际添加的是 CoffeeScript 或 Sass 文件也是如此。
assets:precompile 这个 Rake 任务还会成生 manifest-md5hash.json 文件，其内容是所有静态资源文件及其指纹的列表。有了这个文件，Rails 辅助方法不需要 Sprockets 就能获得静态资源文件对应的指纹。下面是一个典型的 manifest-md5hash.json 文件的例子：

{"files":{"application-723d1be6cc741a3aabb1cec24276d681.js":
{"logical_path":"application.js","mtime":"2013-07-26T22:55:03-07:00",
"size":302506,"digest":"723d1be6cc741a3aabb1cec24276d681"},
"application-12b3c7dd74d2e9df37e7cbb1efa76a6d.css":
{"logical_path":"application.css","mtime":"2013-07-26T22:54:54-07:00",
"size":1560,"digest":"12b3c7dd74d2e9df37e7cbb1efa76a6d"},
"application-1c5752789588ac18d7e1a50b1f0fd4c2.css":
{"logical_path":"application.css","mtime":"2013-07-26T22:56:17-07:00",
"size":1591,"digest":"1c5752789588ac18d7e1a50b1f0fd4c2"},
"favicon-a9c641bf2b81f0476e876f7c5e375969.ico":{"logical_path":"favicon.ico",
"mtime":"2013-07-26T23:00:10-07:00","size":1406,"digest":
"a9c641bf2b81f0476e876f7c5e375969"},"my_image-231a680f23887d9dd70710ea5efd3c62
.png":{"logical_path":"my_image.png","mtime":"2013-07-26T23:00:27-07:00",
"size":6646,"digest":"231a680f23887d9dd70710ea5efd3c62"}},"assets":
{"application.js":"application-723d1be6cc741a3aabb1cec24276d681.js",
"application.css":"application-1c5752789588ac18d7e1a50b1f0fd4c2.css",
"favicon.ico":"favicona9c641bf2b81f0476e876f7c5e375969.ico","my_image.png":
"my_image-231a680f23887d9dd70710ea5efd3c62.png"}}
manifest-md5hash.json 文件默认位于 config.assets.prefix 选项所指定的位置的根目录（默认为 /assets 文件夹）。

注意
在生产环境中，如果有些预编译后的文件丢失了，Rails 就会抛出 Sprockets::Helpers::RailsHelper::AssetPaths::AssetNotPrecompiledError 异常，提示所丢失文件的文件名。
23.4.1.1 在 HTTP 首部中设置为很久以后才过期
预编译后的静态资源文件储存在文件系统中，并由 Web 服务器直接处理。默认情况下，这些文件的 HTTP 首部并不会在很久以后才过期，为了充分发挥指纹的作用，我们需要修改服务器配置中的请求头过期时间。

对于 Apache：

# 在启用 Apache 模块 `mod_expires` 的情况下，才能使用
# Expires* 系列指令。
<Location /assets/>
  # 在使用 Last-Modified 的情况下，不推荐使用 ETag
  Header unset ETag
  FileETag None
  # RFC 规定缓存时间为 1 年
  ExpiresActive On
  ExpiresDefault "access plus 1 year"
</Location>
对于 Nginx：

location ~ ^/assets/ {
  expires 1y;
  add_header Cache-Control public;

  add_header ETag "";
}
23.4.2 本地预编译

在本地预编译静态资源文件的理由如下：

可能没有生产环境服务器文件系统的写入权限；

可能需要部署到多台服务器，不想重复编译；

部署可能很频繁，但静态资源文件很少变化。

本地编译允许我们把编译后的静态资源文件纳入源代码版本控制，并按常规方式部署。

有三个注意事项：

不要运行用于预编译静态资源文件的 Capistrano 部署任务；

开发环境中必须安装压缩或简化静态资源文件所需的工具；

必须修改下面这个设置：

在 config/environments/development.rb 配置文件中添加下面这行代码：

config.assets.prefix = "/dev-assets"
在开发环境中，通过修改 prefix，可以让 Sprockets 使用不同的 URL 处理静态资源文件，并把所有请求都交给 Sprockets 处理。在生产环境中，prefix 仍然应该设置为 /assets。在开发环境中，如果不修改 prefix，应用就会优先读取 /assets 文件夹中预编译后的静态资源文件，这样对静态资源文件进行修改后，除非重新编译，否则看不到任何效果。

实际上，通过修改 prefix，我们可以在本地预编译静态资源文件，并把这些文件储存在工作目录中，同时可以根据需要随时将其纳入源代码版本控制。开发模式将按我们的预期正常工作。

23.4.3 实时编译

在某些情况下，我们需要使用实时编译。在实时编译模式下，Asset Pipeline 中的所有静态资源文件都由 Sprockets 直接处理。

通过如下设置可以启用实时编译：

config.assets.compile = true
如前文所述，静态资源文件会在首次请求时被编译和缓存，辅助方法会把清单文件中的文件名转换为带 MD5 哈希值的版本。

Sprockets 还会把 Cache-Control HTTP 首部设置为 max-age=31536000，意思是服务器和客户端浏览器的所有缓存的过期时间是 1 年。这样在本地浏览器缓存或中间缓存中找到所需静态资源文件的可能性会大大增加，从而减少从服务器上获取静态资源文件的请求次数。

但是实时编译模式会使用更多内存，性能也比默认设置更差，因此并不推荐使用。

如果部署应用的生产服务器没有预装 JavaScript 运行时，可以在 Gemfile 中添加一个：

group :production do
  gem 'therubyracer'
end
23.4.4 CDN

CDN 的意思是内容分发网络，主要用于缓存全世界的静态资源文件。当 Web 浏览器请求静态资源文件时，CDN 会从地理位置最近的 CDN 服务器上发送缓存的文件副本。如果我们在生产环境中让 Rails 直接处理静态资源文件，那么在应用前端使用 CDN 将是最好的选择。

使用 CDN 的常见模式是把生产环境中的应用设置为“源”服务器，也就是说，当浏览器从 CDN 请求静态资源文件但缓存未命中时，CDN 将立即从“源”服务器中抓取该文件，并对其进行缓存。例如，假设我们在 example.com 上运行 Rails 应用，并在 mycdnsubdomain.fictional-cdn.com 上配置了 CDN，在处理对 mycdnsubdomain.fictional-cdn.com/assets/smile.png 的首次请求时，CDN 会抓取 example.com/assets/smile.png 并进行缓存。之后再请求 mycdnsubdomain.fictional-cdn.com/assets/smile.png 时，CDN 会直接提供缓存中的文件副本。对于任何请求，只要 CDN 能够直接处理，就不会访问 Rails 服务器。由于 CDN 提供的静态资源文件由地理位置最近的 CDN 服务器提供，因此对请求的响应更快，同时 Rails 服务器不再需要花费大量时间处理静态资源文件，因此可以专注于更快地处理应用代码。

23.4.4.1 设置用于处理静态资源文件的 CDN
要设置 CDN，首先必须在公开的互联网 URL 地址上（例如 example.com）以生产环境运行 Rails 应用。下一步，注册云服务提供商的 CDN 服务。然后配置 CDN 的“源”服务器，把它指向我们的网站 example.com，具体配置方法请参考云服务提供商的文档。

CDN 提供商会为我们的应用提供一个自定义子域名，例如 mycdnsubdomain.fictional-cdn.com（注意 fictional-cdn.com 只是撰写本文时杜撰的一个 CDN 提供商）。完成 CDN 服务器配置后，还需要告诉浏览器从 CDN 抓取静态资源文件，而不是直接从 Rails 服务器抓取。为此，需要在 Rails 配置中，用静态资源文件的主机代替相对路径。通过 config/environments/production.rb 配置文件的 config.action_controller.asset_host 选项，我们可以设置静态资源文件的主机：

config.action_controller.asset_host = 'mycdnsubdomain.fictional-cdn.com'
注意
这里只需提供“主机”，即前文提到的子域名，而不需要指定 HTTP 协议，例如 http:// 或 https://。默认情况下，Rails 会使用网页请求的 HTTP 协议作为指向静态资源文件链接的协议。
还可以通过环境变量设置静态资源文件的主机，这样可以方便地在不同的运行环境中使用不同的静态资源文件：

config.action_controller.asset_host = ENV['CDN_HOST']
注意
这里还需要把服务器上的 CDN_HOST 环境变量设置为 mycdnsubdomain.fictional-cdn.com。
服务器和 CDN 配置好后，就可以像下面这样引用静态资源文件：

<%= asset_path('smile.png') %>
这时返回的不再是相对路径 /assets/smile.png（出于可读性考虑省略了文件名中的指纹），而是指向 CDN 的完整路径：

http://mycdnsubdomain.fictional-cdn.com/assets/smile.png
如果 CDN 上有 smile.png 文件的副本，就会直接返回给浏览器，而 Rails 服务器甚至不知道有浏览器请求了 smile.png 文件。如果 CDN 上没有 smile.png 文件的副本，就会先从“源”服务器上抓取 example.com/assets/smile.png 文件，再返回给浏览器，同时保存文件的副本以备将来使用。

如果只想让 CDN 处理部分静态资源文件，可以在调用静态资源文件辅助方法时使用 :host 选项，以覆盖 config.action_controller.asset_host 选项中设置的值：

<%= asset_path 'image.png', host: 'mycdnsubdomain.fictional-cdn.com' %>
23.4.4.2 自定义 CDN 缓存行为
CDN 的作用是为内容提供缓存。如果 CDN 上有过期或不良内容，那么不仅不能对应用有所助益，反而会造成负面影响。本小节将介绍大多数 CDN 的一般缓存行为，而我们使用的 CDN 在特性上可能会略有不同。

23.4.4.2.1 CDN 请求缓存
我们常说 CDN 对于缓存静态资源文件非常有用，但实际上 CDN 缓存的是整个请求。其中既包括了静态资源文件的请求体，也包括了其首部。其中，Cache-Control 首部是最重要的，用于告知 CDN（和 Web 浏览器）如何缓存文件内容。假设用户请求了 /assets/i-dont-exist.png 这个并不存在的静态资源文件，并且 Rails 应用返回的是 404，那么只要设置了合法的 Cache-Control 首部，CDN 就会缓存 404 页面。

23.4.4.2.2 调试 CDN 首部
检查 CDN 是否正确缓存了首部的方法之一是使用 curl。我们可以分别从 Rails 服务器和 CDN 获取首部，然后确认二者是否相同：

$ curl -I http://www.example/assets/application-
d0e099e021c95eb0de3615fd1d8c4d83.css
HTTP/1.1 200 OK
Server: Cowboy
Date: Sun, 24 Aug 2014 20:27:50 GMT
Connection: keep-alive
Last-Modified: Thu, 08 May 2014 01:24:14 GMT
Content-Type: text/css
Cache-Control: public, max-age=2592000
Content-Length: 126560
Via: 1.1 vegur
CDN 中副本的首部：

$ curl -I http://mycdnsubdomain.fictional-cdn.com/application-
d0e099e021c95eb0de3615fd1d8c4d83.css
HTTP/1.1 200 OK Server: Cowboy Last-
Modified: Thu, 08 May 2014 01:24:14 GMT Content-Type: text/css
Cache-Control:
public, max-age=2592000
Via: 1.1 vegur
Content-Length: 126560
Accept-Ranges:
bytes
Date: Sun, 24 Aug 2014 20:28:45 GMT
Via: 1.1 varnish
Age: 885814
Connection: keep-alive
X-Served-By: cache-dfw1828-DFW
X-Cache: HIT
X-Cache-Hits:
68
X-Timer: S1408912125.211638212,VS0,VE0
在 CDN 文档中可以查询 CDN 提供的额外首部，例如 X-Cache。

23.4.4.2.3 CDN 和 Cache-Control 首部
Cache-Control 首部是一个 W3C 规范，用于描述如何缓存请求。当未使用 CDN 时，浏览器会根据 Cache-Control 首部来缓存文件内容。在静态资源文件未修改的情况下，浏览器就不必重新下载 CSS 或 JavaScript 等文件了。通常，Rails 服务器需要告诉 CDN（和浏览器）这些静态资源文件是“公共的”，这样任何缓存都可以保存这些文件的副本。此外，通常还会通过 max-age 字段来设置缓存失效前储存对象的时间。max-age 字段的单位是秒，最大设置为 31536000，即一年。在 Rails 应用中设置 Cache-Control 首部的方法如下：

config.public_file_server.headers = {
  'Cache-Control' => 'public, max-age=31536000'
}
现在，在生产环境中，Rails 应用的静态资源文件在 CDN 上会被缓存长达 1 年之久。由于大多数 CDN 会缓存首部，静态资源文件的 Cache-Control 首部会被传递给请求该静态资源文件的所有浏览器，这样浏览器就会长期缓存该静态资源文件，直到缓存过期后才会重新请求该文件。

23.4.4.2.4 CDN 和基于 URL 地址的缓存失效
大多数 CDN 会根据完整的 URL 地址来缓存静态资源文件的内容。因此，缓存

http://mycdnsubdomain.fictional-cdn.com/assets/smile-123.png
和缓存

http://mycdnsubdomain.fictional-cdn.com/assets/smile.png
被认为是两个完全不同的静态资源文件的缓存。

如果我们把 Cache-Control HTTP 首部的 max-age 值设得很大，那么当静态资源文件的内容发生变化时，应同时使原有缓存失效。例如，当我们把黄色笑脸图像更换为蓝色笑脸图像时，我们希望网站的所有访客看到的都是新的蓝色笑脸图像。如果我们使用了 CDN，并使用了 Rails Asset Pipeline config.assets.digest 选项的默认值 true，一旦静态资源文件的内容发生变化，其文件名就会发生变化。这样，我们就不需要每次手动使某个静态资源文件的缓存失效。通过使用唯一的新文件名，我们就能确保用户访问的总是静态资源文件的最新版本。

23.5 自定义 Asset Pipeline
23.5.1 压缩 CSS

压缩 CSS 的可选方式之一是使用 YUI。通过 YUI CSS 压缩器可以缩小 CSS 文件的大小。

在 Gemfile 中添加 yui-compressor gem 后，通过下面的设置可以启用 YUI 压缩：

config.assets.css_compressor = :yui
如果我们在 Gemfile 中添加了 sass-rails gem，那么也可以使用 Sass 压缩：

config.assets.css_compressor = :sass
23.5.2 压缩 JavaScript

压缩 JavaScript 的可选方式有 :closure、:uglifier 和 :yui，分别要求在 Gemfile 中添加 closure-compiler、uglifier 和 yui-compressor gem。

默认情况下，Gemfile 中包含了 uglifier gem，这个 gem 使用 Ruby 包装 UglifyJS（使用 NodeJS 开发），作用是通过删除空白和注释、缩短局部变量名及其他微小优化（例如在可能的情况下把 if…​else 语句修改为三元运算符）压缩 JavaScript 代码。

使用 uglifier 压缩 JavaScript 需进行如下设置：

config.assets.js_compressor = :uglifier
注意
要使用 uglifier 压缩 JavaScript，就必须安装支持 ExecJS 的运行时。macOS 和 Windows 已经预装了此类运行时。
23.5.3 用 GZip 压缩静态资源文件

默认情况下，Sprockets 会用 GZip 压缩编译后的静态资源文件，同时也会保留未压缩的版本。通过 GZip 压缩可以减少对带宽的占用。设置 GZip 压缩的方式如下：

config.assets.gzip = false # 禁止用 GZip 压缩静态资源文件
23.5.4 自定义压缩工具

在设置 CSS 和 JavaScript 压缩工具时还可以使用对象。这个对象要能响应 compress 方法，这个方法接受一个字符串作为唯一参数，并返回一个字符串。

class Transformer
  def compress(string)
    do_something_returning_a_string(string)
  end
end
要使用这个压缩工具，需在 application.rb 配置文件中做如下设置：

config.assets.css_compressor = Transformer.new
23.5.5 修改静态资源文件的路径

默认情况下，Sprockets 使用 /assets 作为静态资源文件的公开路径。

我们可以修改这个路径：

config.assets.prefix = "/some_other_path"
通过这种方式，在升级未使用 Asset Pipeline 但使用了 /assets 路径的老项目时，我们就可以轻松为新的静态资源文件设置另一个公开路径。

23.5.6 X-Sendfile 首部

X-Sendfile 首部的作用是让 Web 服务器忽略应用对请求的响应，直接返回磁盘中的指定文件。默认情况下 Rails 不会发送这个首部，但在支持这个首部的服务器上可以启用这一特性，以提供更快的响应速度。关于这一特性的更多介绍，请参阅 send_file 方法的文档。

Apache 和 NGINX 支持 X-Sendfile 首部，启用方法是在 config/environments/production.rb 配置文件中进行设置：

# config.action_dispatch.x_sendfile_header = "X-Sendfile" # 用于 Apache
# config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # 用于 NGINX
提醒
要想在升级现有应用时使用上述选项，可以把这两行代码粘贴到 production.rb 配置文件中，或其他类似的生产环境配置文件中。
提示
更多介绍请参阅生产服务器的相关文档：Apache、NGINX。
23.6 静态资源文件缓存的存储方式
在开发环境和生产环境中，Sprockets 默认在 tmp/cache/assets 文件夹中缓存静态资源文件。修改这一设置的方式如下：

config.assets.configure do |env|
  env.cache = ActiveSupport::Cache.lookup_store(:memory_store,
                                                { size: 32.megabytes })
end
禁用静态资源文件缓存的方式如下：

config.assets.configure do |env|
  env.cache = ActiveSupport::Cache.lookup_store(:null_store)
end
23.7 通过 gem 添加静态资源文件
我们还可以通过 gem 添加静态资源文件。

为 Rails 提供标准 JavaScript 库的 jquery-rails gem 就是很好的例子。这个 gem 中包含了继承自 Rails::Engine 类的引擎类，这样 Rails 就知道这个 gem 中可能包含静态资源文件，于是会把其中的 app/assets、lib/assets 和 vendor/assets 文件夹添加到 Sprockets 的搜索路径中。

23.8 使用代码库或 gem 作为预处理器
由于 Sprockets 使用 Tilt 作为不同模板引擎的通用接口，一个 gem 只要实现了 Tilt 的模板引擎协议就可以用作预处理器。通常的做法是，继承 Tilt::Template 类并重新实现 prepare 方法（用于初始化模板）和 evaluate 方法（返回处理后的内容）。原始内容储存在 data 中。更多介绍请参阅 Tilt::Template 类的源码。

module BangBang
  class Template < ::Tilt::Template
    def prepare
      # 在此处进行初始化操作
    end

    # 为源模板添加 "!"
    def evaluate(scope, locals, &block)
      "#{data}!"
    end
  end
end
在添加 Template 类后，就可以把这个类和模板文件的扩展名关联起来：

Sprockets.register_engine '.bang', BangBang::Template
23.9 从旧版本的 Rails 升级
从 Rails 3.0 或 Rails 2.x 升级时有一些问题需要解决。首先，要把 public/ 文件夹中的文件移动到新位置。关于不同类型文件储存位置的介绍，请参阅 23.2.2 节。

其次，要避免出现重复的 JavaScript 文件。从 Rails 3.1 开始，jQuery 成为默认的 JavaScript 库，Rails 会自动加载 jquery.js，不再需要手动把 jquery.js 复制到 app/assets 文件夹中。

再次，要使用正确的默认选项更新各种环境配置文件。

在 application.rb 配置文件中：

# 静态资源文件的版本，通过修改这个选项可以使原有的静态资源文件缓存全部过期
config.assets.version = '1.0'

# 通过 onfig.assets.prefix = "/assets" 修改静态资源文件的路径
在 development.rb 配置文件中：

# 展开用于加载静态资源文件的代码
config.assets.debug = true
在 production.rb 配置文件中：

# 选择（可用的）压缩工具
config.assets.js_compressor = :uglifier
# config.assets.css_compressor = :yui

# 在找不到已编译的静态资源文件的情况下，不退回到 Asset Pipeline
config.assets.compile = false

# 为静态资源文件的 URL 地址生成指纹。新版 Rails 将不推荐使用此选项
config.assets.digest = true

# 预编译附加的静态资源文件（application.js、application.css 和所有
# 已添加的非 JS/CSS 文件）
# config.assets.precompile += %w( search.js )
Rails 4 及更高版本不会再在 test.rb 配置文件中添加 Sprockets 的默认设置，因此需要手动完成。需要添加的默认设置包括 config.assets.compile = true、config.assets.compress = false、config.assets.debug = false 和 config.assets.digest = false。

最后，还要在 Gemfile 中加入下列 gem：

gem 'sass-rails',   "~> 3.2.3"
gem 'coffee-rails', "~> 3.2.1"
gem 'uglifier'



#配置静态资源

config.assets.enabled 是个旗标，控制是否启用 Asset Pipeline。默认值为 true。

config.assets.raise_runtime_errors 设为 true 时启用额外的运行时错误检查。推荐在 config/environments/development.rb 中设定，以免部署到生产环境时遇到意料之外的错误。

config.assets.css_compressor 定义所用的 CSS 压缩程序。默认设为 sass-rails。目前唯一的另一个值是 :yui，使用 yui-compressor gem 压缩。

config.assets.js_compressor 定义所用的 JavaScript 压缩程序。可用的值有 :closure、:uglifier 和 :yui，分别使用 closure-compiler、uglifier 和 yui-compressor gem。

config.assets.gzip 是一个旗标，设定在静态资源的常规版本之外是否创建 gzip 版本。默认为 true。

config.assets.paths 包含查找静态资源的路径。在这个配置选项中追加的路径，会在里面寻找静态资源。

config.assets.precompile 设定运行 rake assets:precompile 任务时要预先编译的其他静态资源（除 application.css 和 application.js 之外）。

config.assets.prefix 定义伺服静态资源的前缀。默认为 /assets。

config.assets.manifest 定义静态资源预编译器使用的清单文件的完整路径。默认为 public 文件夹中 config.assets.prefix 设定的目录中的 manifest-<random>.json。

config.assets.digest 设定是否在静态资源的名称中包含 MD5 指纹。默认为 true。

config.assets.debug 禁止拼接和压缩静态文件。在 development.rb 文件中默认设为 true。

config.assets.compile 是一个旗标，设定在生产环境中是否启用实时 Sprockets 编译。

config.assets.logger 接受一个符合 Log4r 接口的日志记录器，或者默认的 Ruby Logger 类。默认值与 config.logger 相同。如果设为 false，不记录对静态资源的伺服。




配置生成器

Rails 允许通过 config.generators 方法调整生成器的行为。这个方法接受一个块：

config.generators do |g|
  g.orm :active_record
  g.test_framework :test_unit
end
在这个块中可以使用的全部方法如下：

assets 指定在生成脚手架时是否创建静态资源。默认为 true。

force_plural 指定模型名是否允许使用复数。默认为 false。

helper 指定是否生成辅助模块。默认为 true。

integration_tool 指定使用哪个集成工具生成集成测试。默认为 :test_unit。

javascripts 启用生成器中的 JavaScript 文件钩子。在 Rails 中供 scaffold 生成器使用。默认为 true。

javascript_engine 配置生成静态资源时使用的脚本引擎（如 coffee）。默认为 :js。

orm 指定使用哪个 ORM。默认为 false，即使用 Active Record。

resource_controller 指定 rails generate resource 使用哪个生成器生成控制器。默认为 :controller。

resource_route 指定是否生成资源路由。默认为 true。

scaffold_controller 与 resource_controller 不同，它指定 rails generate scaffold 使用哪个生成器生成脚手架中的控制器。默认为 :scaffold_controller。

stylesheets 启用生成器中的样式表钩子。在 Rails 中供 scaffold 生成器使用，不过也可以供其他生成器使用。默认为 true。

stylesheet_engine 配置生成静态资源时使用的样式表引擎（如 sass）。默认为 :css。

scaffold_stylesheet 生成脚手架中的资源时创建 scaffold.css。默认为 true。

test_framework 指定使用哪个测试框架。默认为 false，即使用 Minitest。

template_engine 指定使用哪个模板引擎，例如 ERB 或 Haml。默认为 :erb。


 配置中间件

每个 Rails 应用都自带一系列中间件，在开发环境中按下述顺序使用：

ActionDispatch::SSL 强制使用 HTTPS 伺服每个请求。config.force_ssl 设为 true 时启用。传给这个中间件的选项通过 config.ssl_options 配置。

ActionDispatch::Static 用于伺服静态资源。config.public_file_server.enabled 设为 false 时禁用。如果静态资源目录的索引文件不是 index，使用 config.public_file_server.index_name 指定。例如，请求目录时如果想伺服 main.html，而不是 index.html，把 config.public_file_server.index_name 设为 "main"。

ActionDispatch::Executor 以线程安全的方式重新加载代码。onfig.allow_concurrency 设为 false 时禁用，此时加载 Rack::Lock。Rack::Lock 把应用包装在 mutex 中，因此一次只能被一个线程调用。

ActiveSupport::Cache::Strategy::LocalCache 是基本的内存后端缓存。这个缓存对线程不安全，只应该用作单线程的临时内存缓存。

Rack::Runtime 设定 X-Runtime 首部，包含执行请求的时间（单位为秒）。

Rails::Rack::Logger 通知日志请求开始了。请求完成后，清空相关日志。

ActionDispatch::ShowExceptions 拯救应用抛出的任何异常，在本地或者把 config.consider_all_requests_local 设为 true 时渲染精美的异常页面。如果把 config.action_dispatch.show_exceptions 设为 false，异常总是抛出。

ActionDispatch::RequestId 在响应中添加 X-Request-Id 首部，并且启用 ActionDispatch::Request#uuid 方法。

ActionDispatch::RemoteIp 检查 IP 欺骗攻击，从请求首部中获取有效的 client_ip。可通过 config.action_dispatch.ip_spoofing_check 和 config.action_dispatch.trusted_proxies 配置。

Rack::Sendfile 截获从文件中伺服内容的响应，将其替换成服务器专属的 X-Sendfile 首部。可通过 config.action_dispatch.x_sendfile_header 配置。

ActionDispatch::Callbacks 在伺服请求之前运行准备回调。

ActiveRecord::ConnectionAdapters::ConnectionManagement 在每次请求后清理活跃的连接，除非请求环境的 rack.test 键为 true。

ActiveRecord::QueryCache 缓存请求中生成的所有 SELECT 查询。如果有 INSERT 或 UPDATE 查询，清空所有缓存。

ActionDispatch::Cookies 为请求设定 cookie。

ActionDispatch::Session::CookieStore 负责把会话存储在 cookie 中。可以把 config.action_controller.session_store 改为其他值，换成其他中间件。此外，可以使用 config.action_controller.session_options 配置传给这个中间件的选项。

ActionDispatch::Flash 设定 flash 键。仅当为 config.action_controller.session_store 设定值时可用。

Rack::MethodOverride 在设定了 params[:_method] 时允许覆盖请求方法。这是支持 PATCH、PUT 和 DELETE HTTP 请求的中间件。

Rack::Head 把 HEAD 请求转换成 GET 请求，然后以 GET 请求伺服。

除了这些常规中间件之外，还可以使用 config.middleware.use 方法添加：

config.middleware.use Magical::Unicorns
上述代码把 Magical::Unicorns 中间件添加到栈的末尾。如果想把中间件添加到另一个中间件的前面，可以使用 insert_before：

config.middleware.insert_before Rack::Head, Magical::Unicorns
此外，还有 insert_after。它把中间件添加到另一个中间件的后面：

config.middleware.insert_after Rack::Head, Magical::Unicorns
中间件也可以完全替换掉：

config.middleware.swap ActionController::Failsafe, Lifo::Failsafe
还可以从栈中移除：

config.middleware.delete Rack::MethodOverride



#配置 Active Record

config.active_record 包含众多配置选项：

config.active_record.logger 接受符合 Log4r 接口的日志记录器，或者默认的 Ruby Logger 类，然后传给新的数据库连接。可以在 Active Record 模型类或实例上调用 logger 方法获取日志记录器。设为 nil 时禁用日志。

config.active_record.primary_key_prefix_type 用于调整主键列的名称。默认情况下，Rails 假定主键列名为 id（无需配置）。此外有两个选择：

设为 :table_name 时，Customer 类的主键为 customerid。

设为 :table_name_with_underscore 时，Customer 类的主键为 customer_id。

config.active_record.table_name_prefix 设定一个全局字符串，放在表名前面。如果设为 northwest_，Customer 类对应的表是 northwest_customers。默认为空字符串。

config.active_record.table_name_suffix 设定一个全局字符串，放在表名后面。如果设为 _northwest，Customer 类对应的表是 customers_northwest。默认为空字符串。

config.active_record.schema_migrations_table_name 设定模式迁移表的名称。

config.active_record.pluralize_table_names 指定 Rails 在数据库中寻找单数还是复数表名。如果设为 true（默认），那么 Customer 类使用 customers 表。如果设为 false，Customer 类使用 customer 表。

config.active_record.default_timezone 设定从数据库中检索日期和时间时使用 Time.local（设为 :local 时）还是 Time.utc（设为 :utc 时）。默认为 :utc。

config.active_record.schema_format 控制把数据库模式转储到文件中时使用的格式。可用的值有：:ruby（默认），与所用的数据库无关；:sql，转储 SQL 语句（可能与数据库有关）。

config.active_record.error_on_ignored_order_or_limit 指定批量查询时如果忽略顺序或数量限制是否抛出错误。设为 true 时抛出错误，设为 false 时发出提醒。默认为 false。

config.active_record.timestamped_migrations 控制迁移使用整数还是时间戳编号。默认为 true，使用时间戳。如果有多个开发者共同开发同一个应用，建议这么设置。

config.active_record.lock_optimistically 控制 Active Record 是否使用乐观锁。默认为 true。

config.active_record.cache_timestamp_format 控制缓存键中时间戳的格式。默认为 :nsec。

config.active_record.record_timestamps 是个布尔值选项，控制 create 和 update 操作是否更新时间戳。默认值为 true。

config.active_record.partial_writes 是个布尔值选项，控制是否使用部分写入（partial write，即更新时是否只设定有变化的属性）。注意，使用部分写入时，还应该使用乐观锁（config.active_record.lock_optimistically），因为并发更新可能写入过期的属性。默认值为 true。

config.active_record.maintain_test_schema 是个布尔值选项，控制 Active Record 是否应该在运行测试时让测试数据库的模式与 db/schema.rb（或 db/structure.sql）保持一致。默认为 true。

config.active_record.dump_schema_after_migration 是个旗标，控制运行迁移后是否转储模式（db/schema.rb 或 db/structure.sql）。生成 Rails 应用时，config/environments/production.rb 文件中把它设为 false。如果不设定这个选项，默认为 true。

config.active_record.dump_schemas 控制运行 db:structure:dump 任务时转储哪些数据库模式。可用的值有：:schema_search_path（默认），转储 schema_search_path 列出的全部模式；:all，不考虑 schema_search_path，始终转储全部模式；以逗号分隔的模式字符串。

config.active_record.belongs_to_required_by_default 是个布尔值选项，控制没有 belongs_to 关联时记录的验证是否失败。

config.active_record.warn_on_records_fetched_greater_than 为查询结果的数量设定一个提醒阈值。如果查询返回的记录数量超过这一阈值，在日志中记录一个提醒。可用于标识可能导致内存泛用的查询。

config.active_record.index_nested_attribute_errors 让嵌套的 has_many 关联错误显示索引。默认为 false。

MySQL 适配器添加了一个配置选项：

ActiveRecord::ConnectionAdapters::Mysql2Adapter.emulate_booleans 控制 Active Record 是否把 tinyint(1) 类型的列当做布尔值。默认为 true。

模式转储程序添加了一个配置选项：

ActiveRecord::SchemaDumper.ignore_tables 指定一个表数组，不包含在生成的模式文件中。如果 config.active_record.schema_format 的值不是 :ruby，这个设置会被忽略。

# 配置 Action Controller

config.action_controller 包含众多配置选项：

config.action_controller.asset_host 设定静态资源的主机。不使用应用自身伺服静态资源，而是通过 CDN 伺服时设定。

config.action_controller.perform_caching 配置应用是否使用 Action Controller 组件提供的缓存功能。默认在开发环境中为 false，在生产环境中为 true。

config.action_controller.default_static_extension 配置缓存页面的扩展名。默认为 .html。

config.action_controller.include_all_helpers 配置视图辅助方法在任何地方都可用，还是只在相应的控制器中可用。如果设为 false，UsersHelper 模块中的方法只在 UsersController 的视图中可用。如果设为 true，UsersHelper 模块中的方法在任何地方都可用。默认的行为（不明确设为 true 或 false）是视图辅助方法在每个控制器中都可用。

config.action_controller.logger 接受符合 Log4r 接口的日志记录器，或者默认的 Ruby Logger 类，用于记录 Action Controller 的信息。设为 nil 时禁用日志。

config.action_controller.request_forgery_protection_token 设定请求伪造的令牌参数名称。调用 protect_from_forgery 默认把它设为 :authenticity_token。

config.action_controller.allow_forgery_protection 启用或禁用 CSRF 防护。在测试环境中默认为 false，其他环境默认为 true。

config.action_controller.forgery_protection_origin_check 配置是否检查 HTTP Origin 首部与网站的源一致，作为一道额外的 CSRF 防线。

config.action_controller.per_form_csrf_tokens 控制 CSRF 令牌是否只在生成它的方法（动作）中有效。

config.action_controller.relative_url_root 用于告诉 Rails 你把应用部署到子目录中。默认值为 ENV['RAILS_RELATIVE_URL_ROOT']。

config.action_controller.permit_all_parameters 设定默认允许批量赋值全部参数。默认值为 false。

config.action_controller.action_on_unpermitted_parameters 设定在发现没有允许的参数时记录日志还是抛出异常。设为 :log 或 :raise 时启用。开发和测试环境的默认值是 :log，其他环境的默认值是 false。

config.action_controller.always_permitted_parameters 设定一个参数白名单列表，默认始终允许。默认值是 ['controller', 'action']。

#配置 Action Dispatch

config.action_dispatch.session_store 设定存储会话数据的存储器。默认为 :cookie_store；其他有效的值包括 :active_record_store、:mem_cache_store 或自定义类的名称。

config.action_dispatch.default_headers 的值是一个散列，设定每个响应默认都有的 HTTP 首部。默认定义的首部有：

config.action_dispatch.default_headers = {
  'X-Frame-Options' => 'SAMEORIGIN',
  'X-XSS-Protection' => '1; mode=block',
  'X-Content-Type-Options' => 'nosniff'
}
config.action_dispatch.default_charset 指定渲染时使用的默认字符集。默认为 nil。

config.action_dispatch.tld_length 设定应用的 TLD（top-level domain，顶级域名）长度。默认为 1。

config.action_dispatch.http_auth_salt 设定 HTTP Auth 的盐值。默认为 'http authentication'。

config.action_dispatch.signed_cookie_salt 设定签名 cookie 的盐值。默认为 'signed cookie'。

config.action_dispatch.encrypted_cookie_salt 设定加密 cookie 的盐值。默认为 'encrypted cookie'。

config.action_dispatch.encrypted_signed_cookie_salt 设定签名加密 cookie 的盐值。默认为 'signed encrypted cookie'。

config.action_dispatch.perform_deep_munge 配置是否在参数上调用 deep_munge 方法。详情参见 19.8 节。默认为 true。

config.action_dispatch.rescue_responses 设定异常与 HTTP 状态的对应关系。其值为一个散列，指定异常和状态之间的映射。默认的定义如下：

config.action_dispatch.rescue_responses = {
  'ActionController::RoutingError'              => :not_found,
  'AbstractController::ActionNotFound'          => :not_found,
  'ActionController::MethodNotAllowed'          => :method_not_allowed,
  'ActionController::UnknownHttpMethod'         => :method_not_allowed,
  'ActionController::NotImplemented'            => :not_implemented,
  'ActionController::UnknownFormat'             => :not_acceptable,
  'ActionController::InvalidAuthenticityToken'  => :unprocessable_entity,
  'ActionController::InvalidCrossOriginRequest' => :unprocessable_entity,
  'ActionDispatch::ParamsParser::ParseError'    => :bad_request,
  'ActionController::BadRequest'                => :bad_request,
  'ActionController::ParameterMissing'          => :bad_request,
  'Rack::QueryParser::ParameterTypeError'       => :bad_request,
  'Rack::QueryParser::InvalidParameterError'    => :bad_request,
  'ActiveRecord::RecordNotFound'                => :not_found,
  'ActiveRecord::StaleObjectError'              => :conflict,
  'ActiveRecord::RecordInvalid'                 => :unprocessable_entity,
  'ActiveRecord::RecordNotSaved'                => :unprocessable_entity
}
没有配置的异常映射为 500 Internal Server Error。

ActionDispatch::Callbacks.before 接受一个代码块，在请求之前运行。

ActionDispatch::Callbacks.to_prepare 接受一个块，在 ActionDispatch::Callbacks.before 之后、请求之前运行。在开发环境中每个请求都会运行，但在生产环境或 cache_classes 设为 true 的环境中只运行一次。

ActionDispatch::Callbacks.after 接受一个代码块，在请求之后运行。

配置 Action View

config.action_view 有一些配置选项：

config.action_view.field_error_proc 提供一个 HTML 生成器，用于显示 Active Model 抛出的错误。默认为：

Proc.new do |html_tag, instance|
  %Q(<div class="field_with_errors">#{html_tag}</div>).html_safe
end
config.action_view.default_form_builder 告诉 Rails 默认使用哪个表单构造器。默认为 ActionView::Helpers::FormBuilder。如果想在初始化之后加载表单构造器类，把值设为一个字符串。

config.action_view.logger 接受符合 Log4r 接口的日志记录器，或者默认的 Ruby Logger 类，用于记录 Action View 的信息。设为 nil 时禁用日志。

config.action_view.erb_trim_mode 让 ERB 使用修剪模式。默认为 '-'，使用 <%= -%> 或 <%= =%> 时裁掉尾部的空白和换行符。详情参见 Erubis 的文档。

config.action_view.embed_authenticity_token_in_remote_forms 设定具有 remote: true 选项的表单中 authenticity_token 的默认行为。默认设为 false，即远程表单不包含 authenticity_token，对表单做片段缓存时可以这么设。远程表单从 meta 标签中获取真伪令牌，因此除非要支持没有 JavaScript 的浏览器，否则不应该内嵌在表单中。如果想支持没有 JavaScript 的浏览器，可以在表单选项中设定 authenticity_token: true，或者把这个配置设为 true。

config.action_view.prefix_partial_path_with_controller_namespace 设定渲染嵌套在命名空间中的控制器时是否在子目录中寻找局部视图。例如，Admin::ArticlesController 渲染这个模板：

<%= render @article %>
默认设置是 true，使用局部视图 /admin/articles/_article.erb。设为 false 时，渲染 /articles/_article.erb——这与渲染没有放入命名空间中的控制器一样，例如 ArticlesController。

config.action_view.raise_on_missing_translations 设定缺少翻译时是否抛出错误。

config.action_view.automatically_disable_submit_tag 设定点击提交按钮（submit_tag）时是否自动将其禁用。默认为 true。

config.action_view.debug_missing_translation 设定是否把缺少的翻译键放在 <span> 标签中。默认为 true。


配置 Action Mailer

config.action_mailer 有一些配置选项：

config.action_mailer.logger 接受符合 Log4r 接口的日志记录器，或者默认的 Ruby Logger 类，用于记录 Action Mailer 的信息。设为 nil 时禁用日志。

config.action_mailer.smtp_settings 用于详细配置 :smtp 发送方法。值是一个选项散列，包含下述选项：

:address：设定远程邮件服务器的地址。默认为 localhost。

:port：如果邮件服务器不在 25 端口上（很少发生），可以修改这个选项。

:domain：如果需要指定 HELO 域名，通过这个选项设定。

:user_name：如果邮件服务器需要验证身份，通过这个选项设定用户名。

:password：如果邮件服务器需要验证身份，通过这个选项设定密码。

:authentication：如果邮件服务器需要验证身份，要通过这个选项设定验证类型。这个选项的值是一个符号，可以是 :plain、:login 或 :cram_md5。

config.action_mailer.sendmail_settings 用于详细配置 sendmail 发送方法。值是一个选项散列，包含下述选项：

:location：sendmail 可执行文件的位置。默认为 /usr/sbin/sendmail。

:arguments：命令行参数。默认为 -i。

config.action_mailer.raise_delivery_errors 指定无法发送电子邮件时是否抛出错误。默认为 true。

config.action_mailer.delivery_method 设定发送方法，默认为 :smtp。详情参见 16.6 节。

config.action_mailer.perform_deliveries 指定是否真的发送邮件，默认为 true。测试时建议设为 false。

config.action_mailer.default_options 配置 Action Mailer 的默认值。用于为每封邮件设定 from 或 reply_to 等选项。设定的默认值为：

mime_version:  "1.0",
charset:       "UTF-8",
content_type: "text/plain",
parts_order:  ["text/plain", "text/enriched", "text/html"]
若想设定额外的选项，使用一个散列：

config.action_mailer.default_options = {
  from: "noreply@example.com"
}
config.action_mailer.observers 注册观测器（observer），发送邮件时收到通知。

config.action_mailer.observers = ["MailObserver"]
config.action_mailer.interceptors 注册侦听器（interceptor），在发送邮件前调用。

config.action_mailer.interceptors = ["MailInterceptor"]
config.action_mailer.preview_path 指定邮件程序预览的位置。

config.action_mailer.preview_path = "#{Rails.root}/lib/mailer_previews"
config.action_mailer.show_previews 启用或禁用邮件程序预览。开发环境默认为 true。

config.action_mailer.show_previews = false
config.action_mailer.deliver_later_queue_name 设定邮件程序的队列名称。默认为 mailers。

config.action_mailer.perform_caching 指定是否片段缓存邮件模板。在所有环境中默认为 false。

配置 Active Support

Active Support 有一些配置选项：

config.active_support.bare 指定在启动 Rails 时是否加载 active_support/all。默认为 nil，即加载 active_support/all。

config.active_support.test_order 设定执行测试用例的顺序。可用的值是 :random 和 :sorted。对新生成的应用来说，在 config/environments/test.rb 文件中设为 :random。如果应用没指定测试顺序，在 Rails 5.0 之前默认为 :sorted，之后默认为 :random。

config.active_support.escape_html_entities_in_json 指定在 JSON 序列化中是否转义 HTML 实体。默认为 true。

config.active_support.use_standard_json_time_format 指定是否把日期序列化成 ISO 8601 格式。默认为 true。

config.active_support.time_precision 设定 JSON 编码的时间值的精度。默认为 3。

ActiveSupport.halt_callback_chains_on_return_false 指定是否可以通过在前置回调中返回 false 停止 Active Record 和 Active Model 回调链。设为 false 时，只能通过 throw(:abort) 停止回调链。设为 true 时，可以通过返回 false 停止回调链（Rails 5 之前版本的行为），但是会发出弃用提醒。在弃用期内默认为 true。新的 Rails 5 应用会生成一个名为 callback_terminator.rb 的初始化文件，把值设为 false。执行 rails app:update 命令时不会添加这个文件，因此把旧应用升级到 Rails 5 后依然可以通过返回 false 停止回调链，不过会显示弃用提醒，提示用户升级代码。

ActiveSupport::Logger.silencer 设为 false 时静默块的日志。默认为 true。

ActiveSupport::Cache::Store.logger 指定缓存存储操作使用的日志记录器。

ActiveSupport::Deprecation.behavior 的作用与 config.active_support.deprecation 相同，用于配置 Rails 弃用提醒的行为。

ActiveSupport::Deprecation.silence 接受一个块，块里的所有弃用提醒都静默。

ActiveSupport::Deprecation.silenced 设定是否显示弃用提醒。

配置 Active Job

config.active_job 提供了下述配置选项：

config.active_job.queue_adapter 设定队列后端的适配器。默认的适配器是 :async。最新的内置适配器参见 ActiveJob::QueueAdapters 的 API 文档。

# 要把适配器的 gem 写入 Gemfile
# 请参照适配器的具体安装和部署说明
config.active_job.queue_adapter = :sidekiq
config.active_job.default_queue_name 用于修改默认的队列名称。默认为 "default"。

config.active_job.default_queue_name = :medium_priority
config.active_job.queue_name_prefix 用于为所有作业设定队列名称的前缀（可选）。默认为空，不使用前缀。

做下述配置后，在生产环境中运行时把指定作业放入 production_high_priority 队列中：

config.active_job.queue_name_prefix = Rails.env
class GuestsCleanupJob < ActiveJob::Base
  queue_as :high_priority
  #....
end
config.active_job.queue_name_delimiter 的默认值是 '_'。如果设定了 queue_name_prefix，使用 queue_name_delimiter 连接前缀和队列名。

下述配置把指定作业放入 video_server.low_priority 队列中：

# 设定了前缀才会使用分隔符
config.active_job.queue_name_prefix = 'video_server'
config.active_job.queue_name_delimiter = '.'
class EncoderJob < ActiveJob::Base
  queue_as :low_priority
  #....
end
config.active_job.logger 接受符合 Log4r 接口的日志记录器，或者默认的 Ruby Logger 类，用于记录 Action Job 的信息。在 Active Job 类或实例上调用 logger 方法可以获取日志记录器。设为 nil 时禁用日志。


配置 Action Cable

config.action_cable.url 的值是一个 URL 字符串，指定 Action Cable 服务器的地址。如果 Action Cable 服务器与主应用的服务器不同，可以使用这个选项。

config.action_cable.mount_path 的值是一个字符串，指定把 Action Cable 挂载在哪里，作为主服务器进程的一部分。默认为 /cable。可以设为 nil，不把 Action Cable 挂载为常规 Rails 服务器的一部分。


配置数据库

几乎所有 Rails 应用都要与数据库交互。可以通过环境变量 ENV['DATABASE_URL'] 或 config/database.yml 配置文件中的信息连接数据库。

在 config/database.yml 文件中可以指定访问数据库所需的全部信息：

development:
  adapter: postgresql
  database: blog_development
  pool: 5
此时使用 postgresql 适配器连接名为 blog_development 的数据库。这些信息也可以存储在一个 URL 中，然后通过环境变量提供，如下所示：

> puts ENV['DATABASE_URL']
postgresql://localhost/blog_development?pool=5
config/database.yml 文件分成三部分，分别对应 Rails 默认支持的三个环境：

development 环境在开发（本地）电脑中使用，手动与应用交互。

test 环境用于运行自动化测试。

production 环境在把应用部署到线上时使用。

如果愿意，可以在 config/database.yml 文件中指定连接 URL：

development:
  url: postgresql://localhost/blog_development?pool=5
config/database.yml 文件中可以包含 ERB 标签 <%= %>。这个标签中的内容作为 Ruby 代码执行。可以使用这个标签从环境变量中获取数据，或者执行计算，生成所需的连接信息。

提示
无需自己动手更新数据库配置。如果查看应用生成器的选项，你会发现其中一个名为 --database。通过这个选项可以从最常使用的关系数据库中选择一个。甚至还可以重复运行这个生成器：cd .. && rails new blog --database=mysql。同意重写 config/database.yml 文件后，应用的配置会针对 MySQL 更新。常见的数据库连接示例参见下文。


21.3.15 连接配置的优先级

因为有两种配置连接的方式（使用 config/database.yml 文件或者一个环境变量），所以要明白二者之间的关系。

如果 config/database.yml 文件为空，而 ENV['DATABASE_URL'] 有值，那么 Rails 使用环境变量连接数据库：

$ cat config/database.yml

$ echo $DATABASE_URL
postgresql://localhost/my_database
如果在 config/database.yml 文件中做了配置，而 ENV['DATABASE_URL'] 没有值，那么 Rails 使用这个文件中的信息连接数据库：

$ cat config/database.yml
development:
  adapter: postgresql
  database: my_database
  host: localhost

$ echo $DATABASE_URL
如果 config/database.yml 文件中做了配置，而且 ENV['DATABASE_URL'] 有值，Rails 会把二者合并到一起。为了更好地理解，必须看些示例。

如果连接信息有重复，环境变量中的信息优先级高：

$ cat config/database.yml
development:
  adapter: sqlite3
  database: NOT_my_database
  host: localhost

$ echo $DATABASE_URL
postgresql://localhost/my_database

$ bin/rails runner 'puts ActiveRecord::Base.configurations'
{"development"=>{"adapter"=>"postgresql", "host"=>"localhost", "database"=>"my_database"}}
可以看出，适配器、主机和数据库与 ENV['DATABASE_URL'] 中的信息匹配。

如果信息无重复，都是唯一的，遇到冲突时还是环境变量中的信息优先级高：

$ cat config/database.yml
development:
  adapter: sqlite3
  pool: 5

$ echo $DATABASE_URL
postgresql://localhost/my_database

$ bin/rails runner 'puts ActiveRecord::Base.configurations'
{"development"=>{"adapter"=>"postgresql", "host"=>"localhost", "database"=>"my_database", "pool"=>5}}
ENV['DATABASE_URL'] 没有提供连接池数量，因此从文件中获取。而两处都有 adapter，因此 ENV['DATABASE_URL'] 中的连接信息胜出。

如果不想使用 ENV['DATABASE_URL'] 中的连接信息，唯一的方法是使用 "url" 子键指定一个 URL：

$ cat config/database.yml
development:
  url: sqlite3:NOT_my_database

$ echo $DATABASE_URL
postgresql://localhost/my_database

$ bin/rails runner 'puts ActiveRecord::Base.configurations'
{"development"=>{"adapter"=>"sqlite3", "database"=>"NOT_my_database"}}
这里，ENV['DATABASE_URL'] 中的连接信息被忽略了。注意，适配器和数据库名称不同了。

因为在 config/database.yml 文件中可以内嵌 ERB，所以最好明确表明使用 ENV['DATABASE_URL'] 连接数据库。这在生产环境中特别有用，因为不应该把机密信息（如数据库密码）提交到源码控制系统中（如 Git）。

$ cat config/database.yml
production:
  url: <%= ENV['DATABASE_URL'] %>
现在的行为很明确，只使用 <%= ENV['DATABASE_URL'] %> 中的连接信息。


非侵入式 JavaScript
Rails 使用一种叫做“非侵入式 JavaScript”（Unobtrusive JavaScript）的技术把 JavaScript 依附到 DOM 上。非侵入式 JavaScript 是前端开发社区推荐的做法，但有些教程可能会使用其他方式。

下面是编写 JavaScript 最简单的方式，你可能见过，这叫做“行间 JavaScript”：

<a href="#" onclick="this.style.backgroundColor='#990000'">Paint it red</a>
点击链接后，链接的背景会变成红色。这种用法的问题是，如果点击链接后想执行大量 JavaScript 代码怎么办？

<a href="#" onclick="this.style.backgroundColor='#009900';this.style.color='#FFFFFF';">Paint it green</a>
太别扭了，不是吗？我们可以把处理点击的代码定义成一个函数，用 CoffeeScript 编写如下：

@paintIt = (element, backgroundColor, textColor) ->
  element.style.backgroundColor = backgroundColor
  if textColor?
    element.style.color = textColor
然后在页面中这么写：

<a href="#" onclick="paintIt(this, '#990000')">Paint it red</a>
这种方法好点儿，但是如果很多链接需要同样的效果该怎么办呢？

<a href="#" onclick="paintIt(this, '#990000')">Paint it red</a>
<a href="#" onclick="paintIt(this, '#009900', '#FFFFFF')">Paint it green</a>
<a href="#" onclick="paintIt(this, '#000099', '#FFFFFF')">Paint it blue</a>
这样非常不符合 DRY 原则。为了解决这个问题，我们可以使用“事件”。在链接上添加一个 data-* 属性，然后把处理程序绑定到拥有这个属性的点击事件上：

@paintIt = (element, backgroundColor, textColor) ->
  element.style.backgroundColor = backgroundColor
  if textColor?
    element.style.color = textColor

$ ->
  $("a[data-background-color]").click (e) ->
    e.preventDefault()

    backgroundColor = $(this).data("background-color")
    textColor = $(this).data("text-color")
    paintIt(this, backgroundColor, textColor)
<a href="#" data-background-color="#990000">Paint it red</a>
<a href="#" data-background-color="#009900" data-text-color="#FFFFFF">Paint it green</a>
<a href="#" data-background-color="#000099" data-text-color="#FFFFFF">Paint it blue</a>
我们把这种方法称为“非侵入式 JavaScript”，因为 JavaScript 代码不再和 HTML 混合在一起。这样做正确分离了关注点，易于修改功能。我们可以轻易地把这种效果应用到其他链接上，只要添加相应的 data 属性即可。我们可以简化并拼接全部 JavaScript，然后在各个页面加载一个 JavaScript 文件，这样只在第一次请求时需要加载，后续请求都会直接从缓存中读取。“非侵入式 JavaScript”带来的好处太多了。

Rails 团队极力推荐使用这种方式编写 CoffeeScript（以及 JavaScript），而且你会发现很多代码库都采用了这种方式。

26掌握以下几小节的内容对理解常量自动加载和重新加载有所帮助。
module XML
  class SAXParser
    # (1)
  end
end
类和模块的嵌套由内向外展开。嵌套可以通过 Module.nesting 方法审查。例如，在上述示例中，(1) 处的嵌套是

[XML::SAXParser, XML]


注意，组成嵌套的是类和模块“对象”，而不是访问它们的常量，与它们的名称也没有关系。

例如，对下面的定义来说

class XML::SAXParser
  # (2)
end
虽然作用跟前一个示例类似，但是 (2) 处的嵌套是

[XML::SAXParser]
不含“XML”。

从这个示例可以看出，嵌套中的类或模块的名称与所在的命名空间没有必然联系。

事实上，二者毫无关系。比如说：

module X
  module Y
  end
end

module A
  module B
  end
end

module X::Y
  module A::B
    # (3)
  end
end
(3) 处的嵌套包含两个模块对象：

[A::B, X::Y]
可以看出，嵌套的最后不是“A”，甚至不含“A”，但是包含 X::Y，而且它与 A::B 无关。

嵌套是解释器维护的一个内部堆栈，根据下述规则修改：

执行 class 关键字后面的定义体时，类对象入栈；执行完毕后出栈。

执行 module 关键字后面的定义体时，模块对象入栈；执行完毕后出栈。

执行 class << object 打开的单例类时，类对象入栈；执行完毕后出栈。

调用 instance_eval 时如果传入字符串参数，接收者的单例类入栈求值的代码所在的嵌套层次。调用 class_eval 或 module_eval 时如果传入字符串参数，接收者入栈求值的代码所在的嵌套层次.

顶层代码中由 Kernel#load 解释嵌套是空的，除非调用 load 时把第二个参数设为真值；如果是这样，Ruby 会创建一个匿名模块，将其入栈。

注意，块不会修改嵌套堆栈。尤其要注意的是，传给 Class.new 和 Module.new 的块不会导致定义的类或模块入栈嵌套堆栈。由此可见，以不同的方式定义类和模块，达到的效果是有区别的

定义类和模块是为常量赋值

假设下面的代码片段是定义一个类（而不是打开类）：

class C
end
Ruby 在 Object 中创建一个变量 C，并将一个类对象存储在 C 常量中。这个类实例的名称是“C”，一个字符串，跟常量名一样。

如下的代码：

class Project < ApplicationRecord
end
这段代码执行的操作等效于下述常量赋值：

Project = Class.new(ApplicationRecord)
而且有个副作用——设定类的名称：

Project.name # => "Project"
这得益于常量赋值的一条特殊规则：如果被赋值的对象是匿名类或模块，Ruby 会把对象的名称设为常量的名称。

提示
自此之后常量和实例发生的事情无关紧要。例如，可以把常量删除，类对象可以赋值给其他常量，或者不再存储于常量中，等等。名称一旦设定就不会再变。
类似地，模块使用 module 关键字创建，如下所示：

module Admin
end
这段代码执行的操作等效于下述常量赋值：

Admin = Module.new
而且有个副作用——设定模块的名称：

Admin.name # => "Admin"
提醒
传给 Class.new 或 Module.new 的块与 class 或 module 关键字的定义体不在完全相同的上下文中执行。但是两种方式得到的结果都是为常量赋值。
因此，当人们说“String 类”的时候，真正指的是 Object 常量中存储的一个类对象，它存储着常量“String”中存储的一个类对象。而 String 是一个普通的 Ruby 常量，与常量有关的一切，例如解析算法，在 String 常量上都适用。
同样地，在下述控制器中

class PostsController < ApplicationController
  def index
    @posts = Post.all
  end
end
Post 不是调用类的句法，而是一个常规的 Ruby 常量。如果一切正常，这个常量的求值结果是一个能响应 all 方法的对象。
因此，我们讨论的话题才是“常量”自动加载。Rails 提供了自动加载常量的功能。

我们来看看下述模块定义：

module Colors
  RED = '0xff0000'
end
首先，处理 module 关键字时，解释器会在 Object 常量存储的类对象的常量表中新建一个条目。这个条目把“Colors”与一个新建的模块对象关联起来。而且，解释器把那个新建的模块对象的名称设为字符串“Colors”。

随后，解释模块的定义体时，会在 Colors 常量中存储的模块对象的常量表中新建一个条目。那个条目把“RED”映射到字符串“0xff0000”上。

注意，Colors::RED 与其他类或模块对象中的 RED 常量完全没有关系。如果存在这样一个常量，它在相应的常量表中，是不同的条目。

在前述各段中，尤其要注意类和模块对象、常量名称，以及常量表中与之关联的值对象之间的区别。

解析算法

26.2.4.1 相对常量的解析算法
在代码中的特定位置，假如使用 cref 表示嵌套中的第一个元素，如果没有嵌套，则表示 Object。

简单来说，相对常量（relative constant）引用的解析算法如下：

如果嵌套不为空，在嵌套中按元素顺序查找常量。元素的祖先忽略不计。

如果未找到，算法向上，进入 cref 的祖先链。

如果未找到，而且 cref 是个模块，在 Object 中查找常量。

如果未找到，在 cref 上调用 const_missing 方法。这个方法的默认行为是抛出 NameError 异常，不过可以覆盖。

Rails 的自动加载机制没有仿照这个算法，查找的起点是要自动加载的常量名称，即 cref。详情参见 26.6.1 节。
限定常量的解析算法
限定常量（qualified constant）指下面这种：

Billing::Invoice
Billing::Invoice 由两个常量组成，其中 Billing 是相对常量，使用前一节所属的算法解析。

提示
在开头加上两个冒号可以把第一部分的相对常量变成绝对常量，例如 ::Billing::Invoice。此时，Billing 作为顶层常量查找。

#自动加载可用性
只要环境允许，Rails 始终会自动加载。例如，runner 命令会自动加载：

$ bin/rails runner 'p User.column_names'
["id", "email", "created_at", "updated_at"]
控制台会自动加载，测试组件会自动加载，当然，应用也会自动加载。

默认情况下，在生产环境中，Rails 启动时会及早加载应用文件，因此开发环境中的多数自动加载行为不会发生。但是在及早加载的过程中仍然可能会触发自动加载。

例如：class BeachHouse < House
end
如果及早加载 app/models/beach_house.rb 文件之后，House 尚不可知，Rails 会自动加载它


#autoload_paths
或许你已经知道，使用 require 引入相对文件名时，例如

require 'erb'
Ruby 在 $LOAD_PATH 中列出的目录里寻找文件。即，Ruby 迭代那些目录，检查其中有没有名为“erb.rb”“erb.so”“erb.o”或“erb.dll”的文件。如果在某个目录中找到了，解释器加载那个文件，搜索结束。否则，继续在后面的目录中寻找。如果最后没有找到，抛出 LoadError 异常。

后面会详述常量自动加载机制，不过整体思路是，遇到未知的常量时，如 Post，假如 app/models 目录中存在 post.rb 文件，Rails 会找到它，执行它，从而定义 Post 常量。

好吧，其实 Rails 会在一系列目录中查找 post.rb，有点类似于 $LOAD_PATH。那一系列目录叫做 autoload_paths，默认包含：

应用和启动时存在的引擎的 app 目录中的全部子目录。例如，app/controllers。这些子目录不一定是默认的，可以是任何自定义的目录，如 app/workers。app 目录中的全部子目录都自动纳入 autoload_paths。

应用和引擎中名为 app/*/concerns 的二级目录。

test/mailers/previews 目录。

此外，这些目录可以使用 config.autoload_paths 配置。例如，以前 lib 在这一系列目录中，但是现在不在了。应用可以在 config/application.rb 文件中添加下述配置，将其纳入其中：

config.autoload_paths << "#{Rails.root}/lib"
##在各个环境的配置文件中不能配置 config.autoload_paths。

autoload_paths 的值可以审查。在新创建的应用中，它的值是（经过编辑）：

$ bin/rails r 'puts ActiveSupport::Dependencies.autoload_paths'
.../app/assets
.../app/controllers
.../app/helpers
.../app/mailers
.../app/models
.../app/controllers/concerns
.../app/models/concerns
.../test/mailers/previews
提示
autoload_paths 在初始化过程中计算并缓存。目录结构发生变化时，要重启服务器。


#26自动加载算法
##26.6.1 相对引用

相对常量引用可在多处出现，例如：

class PostsController < ApplicationController
  def index
    @posts = Post.all
  end
end
这里的三个常量都是相对引用。

26.6.1.1 class 和 module 关键字后面的常量
Ruby 程序会查找 class 或 module 关键字后面的常量，因为要知道是定义类或模块，还是再次打开。

如果常量不被认为是缺失的，不会定义常量，也不会触发自动加载。

因此，在上述示例中，解释那个文件时，如果 PostsController 未定义，Rails 不会触发自动加载机制，而是由 Ruby 定义那个控制器。
##26.6.1.2顶层常量
相对地，如果 ApplicationController 是未知的，会被认为是缺失的，Rails 会尝试自动加载。

为了加载 ApplicationController，Rails 会迭代 autoload_paths。首先，检查 app/assets/application_controller.rb 文件是否存在，如果不存在（通常如此），再检查 app/controllers/application_controller.rb 是否存在。

如果那个文件定义了 ApplicationController 常量，那就没事，否则抛出 LoadError 异常：

unable to autoload constant ApplicationController, expected
<full path to application_controller.rb> to define it (LoadError)
提示
Rails 不要求自动加载的常量是类或模块对象。假如在 app/models/max_clients.rb 文件中定义了 MAX_CLIENTS = 100，Rails 也能自动加载 MAX_CLIENTS。


##命名空间
自动加载 ApplicationController 时直接检查 autoload_paths 里的目录，因为它没有嵌套。Post 就不同了，那一行的嵌套是 [PostsController]，此时就会使用涉及命名空间的算法。

对下述代码来说：

module Admin
  class BaseController < ApplicationController
    @@all_roles = Role.all
  end
end
为了自动加载 Role，要分别检查当前或父级命名空间中有没有定义 Role。因此，从概念上讲，要按顺序尝试自动加载下述常量：

Admin::BaseController::Role
Admin::Role
Role
为此，Rails 在 autoload_paths 中分别查找下述文件名：

admin/base_controller/role.rb
admin/role.rb
role.rb
此外还会查找一些其他目录，稍后说明。

提示
不含扩展名的相对文件路径通过 'Constant::Name'.underscore 得到，其中 Constant::Name 是已定义的常量。


## bin/rails r 'puts ActiveSupport::Dependencies.autoload_paths'

#26.7 require_dependency
常量自动加载按需触发，因此使用特定常量的代码可能已经定义了常量，或者触发自动加载。具体情况取决于执行路径，二者之间可能有较大差异。

然而，有时执行到某部分代码时想确保特定常量是已知的。require_dependency 为此提供了一种方式。它使用目前的加载机制加载文件，而且会记录文件中定义的常量，就像是自动加载的一样，而且会按需重新加载。

require_dependency 很少需要使用，不过 26.10.2 节和 26.10.6 节有几个用例。

提醒
与自动加载不同，require_dependency 不期望文件中定义任何特定的常量。但是利用这种行为不好，文件和常量路径应该匹配。
#26.8 常量重新加载
config.cache_classes 设为 false 时，Rails 会重新自动加载常量。

例如，在控制台会话中编辑文件之后，可以使用 reload! 命令重新加载代码：

> reload!
在应用运行的过程中，如果相关的逻辑有变，会重新加载代码。为此，Rails 会监控下述文件：

config/routes.rb

本地化文件

autoload_paths 中的 Ruby 文件

db/schema.rb 和 db/structure.sql

如果这些文件中的内容有变，有个中间件会发现，然后重新加载代码。

自动加载机制会记录自动加载的常量。重新加载机制使用 Module#remove_const 方法把它们从相应的类和模块中删除。这样，运行代码时那些常量就变成未知了，从而按需重新加载文件。

提示
这是一个极端操作，Rails 重新加载的不只是那些有变化的代码，因为类之间的依赖极难处理。相反，Rails 重新加载一切。
#26.9 Module#autoload 不涉其中
Module#autoload 提供的是惰性加载常量方式，深置于 Ruby 的常量查找算法、动态常量 API，等等。这一机制相当简单。

Rails 内部在加载过程中大量采用这种方式，尽量减少工作量。但是，Rails 的常量自动加载机制不是使用 Module#autoload 实现的。

如果基于 Module#autoload 实现，可以遍历应用树，调用 autoload 把文件名和常规的常量名对应起来。

Rails 不采用这种实现方式有几个原因。

例如，Module#autoload 只能使用 require 加载文件，因此无法重新加载。不仅如此，它使用的是 require 关键字，而不是 Kernel#require 方法。

因此，删除文件后，它无法移除声明。如果使用 Module#remove_const 把常量删除了，不会触发 Module#autoload。此外，它不支持限定名称，因此有命名空间的文件要在遍历树时解析，这样才能调用相应的 autoload 方法，但是那些文件中可能有尚未配置的常量引用。

基于 Module#autoload 的实现很棒，但是如你所见，目前还不可能。Rails 的常量自动加载机制使用 Module#const_missing 实现，因此才有本文所述的独特算法。


#26.10 常见问题
26.10.1 嵌套和限定常量

假如有下述代码

module Admin
  class UsersController < ApplicationController
    def index
      @users = User.all
    end
  end
end
和

class Admin::UsersController < ApplicationController
  def index
    @users = User.all
  end
end
为了解析 User，对前者来说，Ruby 会检查 Admin，但是后者不会，因为它不在嵌套中（参见 26.2.1 节和 26.2.4 节）。

可惜，在缺失常量的地方，Rails 自动加载机制不知道嵌套，因此行为与 Ruby 不同。具体而言，在两种情况下，Admin::User 都能自动加载。

尽管严格来说某些情况下 class 和 module 关键字后面的限定常量可以自动加载，但是最好使用相对常量：

module Admin
  class UsersController < ApplicationController
    def index
      @users = User.all
    end
  end
end


#对称加密算法在加密和解密时使用的是同一个秘钥；而非对称加密算法需要两个密钥来进行加密和解密，这两个秘钥是公开密钥（public 
key，简称公钥）和私有密钥（private key，简称私钥）。




#26.10.3 自动加载和 require

通过自动加载机制加载的定义常量的文件一定不能使用 require 引入：

require 'user' # 千万别这么做

class UsersController < ApplicationController
  ...
end
如果这么做，在开发环境中会导致两个问题：

如果在执行 require 之前自动加载了 User，app/models/user.rb 会再次运行，因为 load 不会更新 $LOADED_FEATURES。

如果 require 先执行了，Rails 不会把 User 标记为自动加载的常量，因此 app/models/user.rb 文件中的改动不会重新加载。

我们应该始终遵守规则，使用常量自动加载机制，一定不能混用自动加载和 require。底线是，如果一定要加载特定的文件，使用 require_dependency，这样能正确利用常量自动加载机制。不过，实际上很少需要这么做。

##当然，在自动加载的文件中使用 require 加载第三方库没问题，Rails 会做区分，不把第三方库里的常量标记为自动加载的。

#26.10.4 自动加载和初始化脚本

假设 config/initializers/set_auth_service.rb 文件中有下述赋值语句：

AUTH_SERVICE = if Rails.env.production?
  RealAuthService
else
  MockedAuthService
end
这么做的目的是根据所在环境为 AUTH_SERVICE 赋予不同的值。在开发环境中，运行这个初始化脚本时，自动加载 MockedAuthService。假如我们发送了几个请求，修改了实现，然后再次运行应用，奇怪的是，改动没有生效。这是为什么呢？

从前文得知，Rails 会删除自动加载的常量，但是 AUTH_SERVICE 存储的还是原来那个类对象。原来那个常量不存在了，但是功能完全不受影响。

下述代码概述了这种情况：

class C
  def quack
    'quack!'
  end
end

X = C
Object.instance_eval { remove_const(:C) }
X.new.quack # => quack!
X.name      # => C
C           # => uninitialized constant C (NameError)
##鉴于此，不建议在应用初始化过程中自动加载常量。

对上述示例来说，我们可以实现一个动态接入点：

# app/models/auth_service.rb
class AuthService
  if Rails.env.production?
    def self.instance
      RealAuthService
    end
  else
    def self.instance
      MockedAuthService
    end
  end
end
然后在应用中使用 AuthService.instance。这样，AuthService 会按需加载，而且能顺利自动加载。

##26.10.5 require_dependency 和初始化脚本

前面说过，require_dependency 加载的文件能顺利自动加载。但是，一般来说不应该在初始化脚本中使用。

有人可能觉得在初始化脚本中调用 require_dependency 能确保提前加载特定的常量，例如用于解决 STI 问题。

问题是，在开发环境中，如果文件系统中有相关的改动，自动加载的常量会被抹除。这样就与使用初始化脚本的初衷背道而驰了。

require_dependency 调用应该写在能自动加载的地方。

#26.10.6 常量未缺失

##26.10.6.1 相对引用
以一个飞行模拟器为例。应用中有个默认的飞行模型：

# app/models/flight_model.rb
class FlightModel
end
每架飞机都可以将其覆盖，例如：

# app/models/bell_x1/flight_model.rb
module BellX1
  class FlightModel < FlightModel
  end
end

# app/models/bell_x1/aircraft.rb
module BellX1
  class Aircraft
    def initialize
      @flight_model = FlightModel.new
    end
  end
end
初始化脚本想创建一个 BellX1::FlightModel 对象，而且嵌套中有 BellX1，看起来这没什么问题。但是，如果默认飞行模型加载了，但是 Bell-X1 模型没有，解释器能解析顶层的 FlightModel，因此 BellX1::FlightModel 不会触发自动加载机制。

这种代码取决于执行路径。

这种歧义通常可以通过限定常量解决：

module BellX1
  class Plane
    def flight_model
      @flight_model ||= BellX1::FlightModel.new
    end
  end
end
此外，使用 require_dependency 也能解决：

require_dependency 'bell_x1/flight_model'

module BellX1
  class Plane
    def flight_model
      @flight_model ||= FlightModel.new
    end
  end
end


##26.10.6.2 限定引用
对下述代码来说

# app/models/hotel.rb
class Hotel
end

# app/models/image.rb
class Image
end

# app/models/hotel/image.rb
class Hotel
  class Image < Image
  end
end
Hotel::Image 这个表达式有歧义，因为它取决于执行路径。

从前文得知，Ruby 会在 Hotel 及其祖先中查找常量。如果加载了 app/models/image.rb 文件，但是没有加载 app/models/hotel/image.rb，Ruby 在 Hotel 中找不到 Image，而在 Object 中能找到：

$ bin/rails r 'Image; p Hotel::Image' 2>/dev/null
Image # 不是 Hotel::Image！
若想得到 Hotel::Image，要确保 app/models/hotel/image.rb 文件已经加载——或许是使用 require_dependency 加载的。

不过，在这些情况下，解释器会发出提醒：

warning: toplevel constant Image referenced by Hotel::Image
任何限定的类都能发现这种奇怪的常量解析行为：

2.1.5 :001 > String::Array
(irb):1: warning: toplevel constant Array referenced by String::Array
 => Array
提醒
为了发现这种问题，限定命名空间必须是类。Object 不是模块的祖先。


##26.10.7 单例类中的自动加载

假如有下述类定义：

# app/models/hotel/services.rb
module Hotel
  class Services
  end
end

# app/models/hotel/geo_location.rb
module Hotel
  class GeoLocation
    class << self
      Services
    end
  end
end
如果加载 app/models/hotel/geo_location.rb 文件时 Hotel::Services 是已知的，Services 由 Ruby 解析，因为打开 Hotel::GeoLocation 的单例类时，Hotel 在嵌套中。

但是，如果 Hotel::Services 是未知的，Rails 无法自动加载它，应用会抛出 NameError 异常。

###这是因为单例类（匿名的）会触发自动加载，从前文得知，在这种边缘情况下，Rails 只检查顶层命名空间。

这个问题的简单解决方案是使用限定常量：

module Hotel
  class GeoLocation
    class << self
      Hotel::Services
    end
  end
end


##26.10.8 BasicObject 中的自动加载

BasicObject 的直接子代的祖先中没有 Object，因此无法解析顶层常量：

class C < BasicObject
  String # NameError: uninitialized constant C::String
end
如果涉及自动加载，情况稍微复杂一些。对下述代码来说

class C < BasicObject
  def user
    User # 错误
  end
end
因为 Rails 会检查顶层命名空间，所以第一次调用 user 方法时，User 能自动加载。但是，如果 User 是已知的，尤其是第二次调用 user 方法时，情况就不同了：

c = C.new
c.user # 奇怪的是能正常运行，返回 User
c.user # NameError: uninitialized constant C::User
因为此时发现父级命名空间中已经有那个常量了（参见 26.6.2 节）。

在纯 Ruby 代码中，在 BasicObject 的直接子代的定义体中应该始终使用绝对常量路径：

class C < BasicObject
  ::String # 正确

  def user
    ::User # 正确
  end
end

#第 27 章 Rails 缓存概览

本文简述如何使用缓存提升 Rails 应用的速度。

缓存是指存储请求-响应循环中生成的内容，在类似请求的响应中复用。

通常，缓存是提升应用性能最有效的方式。通过缓存，在单个服务器中使用单个数据库的网站可以承受数千个用户并发访问。

Rails 自带了一些缓存功能。本文说明它们的适用范围和作用。掌握这些技术之后，你的 Rails 应用能承受大量访问，而不必花大量时间生成响应，或者支付高昂的服务器账单。

读完本文后，您将学到：

片段缓存和俄罗斯套娃缓存；

如何管理缓存依赖；

不同的缓存存储器；

对条件 GET 请求的支持
##27.1基本缓存
本节简介三种缓存技术：页面缓存（page caching）、动作缓存（action caching）和片段缓存（fragment caching）。Rails 默认提供了片段缓存。如果想使用页面缓存或动作缓存，要把 actionpack-page_caching 或 actionpack-action_caching 添加到 Gemfile 中。
###27.1.1 页面缓存

页面缓存时 Rails 提供的一种缓存机制，让 Web 服务器（如 Apache 和 NGINX）直接伺服生成的页面，而不经由 Rails 栈处理。虽然这种缓存的速度超快，但是不适用于所有情况（例如需要验证身份的页面）。此外，因为 Web 服务器直接从文件系统中伺服文件，所以你要自行实现缓存失效机制。

提示
Rails 4 删除了页面缓存。参见 actionpack-page_caching gem。
##27.1.2 动作缓存

有前置过滤器的动作不能使用页面缓存，例如需要验证身份的页面。此时，应该使用动作缓存。动作缓存的工作原理与页面缓存类似，不过入站请求会经过 Rails 栈处理，以便运行前置过滤器，然后再伺服缓存。这样，可以做身份验证和其他限制，同时还能从缓存的副本中伺服结果。

提示
Rails 4 删除了动作缓存。参见 actionpack-action_caching gem。最新推荐的做法参见 DHH 写的“How key-based cache expiration works”一文。
https://signalvnoise.com/posts/3113-how-key-based-cache-expiration-works
##片段缓存

动态 Web 应用一般使用不同的组件构建页面，不是所有组件都能使用同一种缓存机制。如果页面的不同部分需要使用不同的缓存机制，在不同的条件下失效，可以使用片段缓存。

片段缓存把视图逻辑的一部分放在 cache 块中，下次请求使用缓存存储器中的副本伺服。

例如，如果想缓存页面中的各个商品，可以使用下述代码：

<% @products.each do |product| %>
  <% cache product do %>
    <%= render product %>
  <% end %>
<% end %>
首次访问这个页面时，Rails 会创建一个具有唯一键的缓存条目。缓存键类似下面这种：

views/products/1-201505056193031061005000/bea67108094918eeba42cd4a6e786901
中间的数字是 product_id 加上商品记录的 updated_at 属性中存储的时间戳。Rails 使用时间戳确保不伺服过期的数据。如果 updated_at 的值变了，Rails 会生成一个新键，然后在那个键上写入一个新缓存，旧键上的旧缓存不再使用。这叫基于键的失效方式。

视图片段有变化时（例如视图的 HTML 有变），缓存的片段也失效。缓存键末尾那个字符串是模板树摘要，是基于缓存的视图片段的内容计算的 MD5 哈希值。如果视图片段有变化，MD5 哈希值就变了，因此现有文件失效。

提示
Memcached 等缓存存储器会自动删除旧的缓存文件。
如果想在特定条件下缓存一个片段，可以使用 cache_if 或 cache_unless：

<% cache_if admin?, product do %>
  <%= render product %>
<% end %>

###27.1.3.1 集合缓存
render 辅助方法还能缓存渲染集合的单个模板。这甚至比使用 each 的前述示例更好，因为是一次性读取所有缓存模板的，而不是一次读取一个。若想缓存集合，渲染集合时传入 cached: true 选项：

<%= render partial: 'products/product', collection: @products, cached: true %>
上述代码中所有的缓存模板一次性获取，速度更快。此外，尚未缓存的模板也会写入缓存，在下次渲染时获取。

###27.1.4 俄罗斯套娃缓存

有时，可能想把缓存的片段嵌套在其他缓存的片段里。这叫俄罗斯套娃缓存（Russian doll caching）。

俄罗斯套娃缓存的优点是，更新单个商品后，重新生成外层片段时，其他内存片段可以复用。

前一节说过，如果缓存的文件对应的记录的 updated_at 属性值变了，缓存的文件失效。但是，内层嵌套的片段不失效。

对下面的视图来说：

<% cache product do %>
  <%= render product.games %>
<% end %>
而它渲染这个视图：

<% cache game do %>
  <%= render game %>
<% end %>
如果游戏的任何一个属性变了，updated_at 的值会设为当前时间，因此缓存失效。然而，商品对象的 updated_at 属性不变，因此它的缓存不失效，从而导致应用伺服过期的数据。为了解决这个问题，可以使用 touch 方法把模型绑在一起：

class Product < ApplicationRecord
  has_many :games
end

class Game < ApplicationRecord
  belongs_to :product, touch: true
end
把 touch 设为 true 后，导致游戏的 updated_at 变化的操作，也会修改关联的商品的 updated_at 属性，从而让缓存失效。

##27.1.5 管理依赖

为了正确地让缓存失效，要正确地定义缓存依赖。Rails 足够智能，能处理常见的情况，无需自己指定。但是有时需要处理自定义的辅助方法（以此为例），因此要自行定义。
###27.1.5.1 隐式依赖
多数模板依赖可以从模板中的 render 调用中推导出来。下面举例说明 ActionView::Digestor 知道如何解码的 render 调用：

render partial: "comments/comment", collection: commentable.comments
render "comments/comments"
render 'comments/comments'
render('comments/comments')

render "header" => render("comments/header")

render(@topic)         => render("topics/topic")
render(topics)         => render("topics/topic")
render(message.topics) => render("topics/topic")
而另一方面，有些调用要做修改方能让缓存正确工作。例如，如果传入自定义的集合，要把下述代码：

render @project.documents.where(published: true)
改为：

render partial: "documents/document", collection: @project.documents.where(published: true)
###27.1.5.2 显式依赖
有时，模板依赖推导不出来。在辅助方法中渲染时经常是这样。下面举个例子：

<%= render_sortable_todolists @project.todolists %>
此时，要使用一种特殊的注释格式：

<%# Template Dependency: todolists/todolist %>
<%= render_sortable_todolists @project.todolists %>
某些情况下，例如设置单表继承，可能要显式定义一堆依赖。此时无需写出每个模板，可以使用通配符匹配一个目录中的全部模板：

<%# Template Dependency: events/* %>
<%= render_categorizable_events @person.events %>
对集合缓存来说，如果局部模板不是以干净的缓存调用开头，依然可以使用集合缓存，不过要在模板中的任意位置添加一种格式特殊的注释，如下所示：

####<%# Template Collection: notification %>
<% my_helper_that_calls_cache(some_arg, notification) do %>
  <%= notification.name %>
<% end %>
###27.1.5.3 外部依赖
如果在缓存的块中使用辅助方法，而后更新了辅助方法，还要更新缓存。具体方法不限，只要能改变模板文件的 MD5 值就行。推荐的方法之一是添加一个注释，如下所示：

<%# Helper Dependency Updated: Jul 28, 2015 at 7pm %>
<%= some_helper_method(person) %>
###27.1.6 低层缓存

有时需要缓存特定的值或查询结果，而不是缓存视图片段。Rails 的缓存机制能存储任何类型的信息。

实现低层缓存最有效的方式是使用 Rails.cache.fetch 方法。这个方法既能读取也能写入缓存。传入单个参数时，获取指定的键，返回缓存中的值。传入块时，在指定键上缓存块的结果，并返回结果。

下面举个例子。应用中有个 Product 模型，它有个实例方法，在竞争网站中查找商品的价格。这个方法返回的数据特别适合使用低层缓存：

class Product < ApplicationRecord
  def competing_price
    Rails.cache.fetch("#{cache_key}/competing_price", expires_in: 12.hours) do
      Competitor::API.find_price(id)
    end
  end
end
注意
注意，这个示例使用了 cache_key 方法，因此得到的缓存键类似这种：products/233-20140225082222765838000/competing_price。cache_key 方法根据模型的 id 和 updated_at 属性生成一个字符串。这是常见的约定，有个好处是，商品更新后缓存自动失效。一般来说，使用低层缓存缓存实例层信息时，需要生成缓存键。
###27.1.7 SQL 缓存

查询缓存是 Rails 提供的一个功能，把各个查询的结果集缓存起来。如果在同一个请求中遇到了相同的查询，Rails 会使用缓存的结果集，而不再次到数据库中运行查询。

例如：

class ProductsController < ApplicationController

  def index
    # 运行查找查询
    @products = Product.all

    ...

    # 再次运行相同的查询
    @products = Product.all
  end

end
再次运行相同的查询时，根本不会发给数据库。首次运行查询得到的结果存储在查询缓存中（内存里），第二次查询从内存中获取。

然而要知道，查询缓存在动作开头创建，到动作末尾销毁，只在动作的存续时间内存在。如果想持久化存储查询结果，使用低层缓存也能实现#
##27.2 缓存存储器
Rails 为存储缓存数据（SQL 缓存和页面缓存除外）提供了不同的存储器。

###27.2.1 配置

config.cache_store 配置选项用于设定应用的默认缓存存储器。可以设定其他参数，传给缓存存储器的构造方法：

config.cache_store = :memory_store, { size: 64.megabytes }
注意
此外，还可以在配置块外部调用 ActionController::Base.cache_store。
缓存存储器通过 Rails.cache 访问。
###27.2.2 ActiveSupport::Cache::Store
这个类是在 Rails 中与缓存交互的基础。这是个抽象类，不能直接使用。你必须根据存储器引擎具体实现这个类。Rails 提供了几个实现，说明如下。
主要调用的方法有 read、write、delete、exist? 和 fetch。fetch 方法接受一个块，返回缓存中现有的值，或者把新值写入缓存。
所有缓存实现有些共用的选项，可以传给构造方法，或者传给与缓存条目交互的各个方法。
:namespace：在缓存存储器中创建命名空间。如果与其他应用共用同一个缓存存储器，这个选项特别有用。

:compress：指定压缩缓存。通过缓慢的网络传输大量缓存时用得着。

:compress_threshold：与 :compress 选项搭配使用，指定一个阈值，未达到时不压缩缓存。默认为 16 千字节。

:expires_in：为缓存条目设定失效时间（秒数），失效后自动从缓存中删除。

:race_condition_ttl：与 :expires_in 选项搭配使用。避免多个进程同时重新生成相同的缓存条目（也叫 dog pile effect），防止让缓存条目过期时出现条件竞争。这个选项设定在重新生成新值时失效的条目还可以继续使用多久（秒数）。如果使用 :expires_in 选项， 最好也设定这个选项。
###27.2.2.1 自定义缓存存储器
缓存存储器可以自己定义，只需扩展 ActiveSupport::Cache::Store 类，实现相应的方法。这样，你可以把任何缓存技术带到你的 Rails 应用中。

若想使用自定义的缓存存储器，只需把 cache_store 设为自定义类的实例：

config.cache_store = MyCacheStore.new
###27.2.3 ActiveSupport::Cache::MemoryStore

这个缓存存储器把缓存条目放在内存中，与 Ruby 进程放在一起。可以把 :size 选项传给构造方法，指定缓存的大小限制（默认为 32Mb）。超过分配的大小后，会清理缓存，把最不常用的条目删除。

config.cache_store = :memory_store, { size: 64.megabytes }
如果运行多个 Ruby on Rails 服务器进程（例如使用 mongrel_cluster 或 Phusion Passenger），各个实例之间无法共享缓存数据。这个缓存存储器不适合大型应用使用。不过，适合只有几个服务器进程的低流量小型应用使用，也适合在开发环境和测试环境中使用。

###27.2.4 ActiveSupport::Cache::FileStore

这个缓存存储器使用文件系统存储缓存条目。初始化这个存储器时，必须指定存储文件的目录：

config.cache_store = :file_store, "/path/to/cache/directory"
使用这个缓存存储器时，在同一台主机中运行的多个服务器进程可以共享缓存。这个缓存存储器适合一到两个主机的中低流量网站使用。运行在不同主机中的多个服务器进程若想共享缓存，可以使用共享的文件系统，但是不建议这么做。

缓存量一直增加，直到填满磁盘，所以建议你定期清理旧缓存条目。

这是默认的缓存存储器。
###27.2.5 ActiveSupport::Cache::MemCacheStore

这个缓存存储器使用 Danga 的 memcached 服务器为应用提供中心化缓存。Rails 默认使用自带的 dalli gem。这是生产环境的网站目前最常使用的缓存存储器。通过它可以实现单个共享的缓存集群，效率很高，有较好的冗余。

初始化这个缓存存储器时，要指定集群中所有 memcached 服务器的地址。如果不指定，假定 memcached 运行在本地的默认端口上，但是对大型网站来说，这样做并不好。

这个缓存存储器的 write 和 fetch 方法接受两个额外的选项，以便利用 memcached 的独有特性。指定 :raw 时，直接把值发给服务器，不做序列化。值必须是字符串或数字。memcached 的直接操作，如 increment 和 decrement，只能用于原始值。还可以指定 :unless_exist 选项，不让 memcached 覆盖现有条目。

config.cache_store = :mem_cache_store, "cache-1.example.com", "cache-2.example.com"
###27.2.6 ActiveSupport::Cache::NullStore

这个缓存存储器只应该在开发或测试环境中使用，它并不存储任何信息。在开发环境中，如果代码直接与 Rails.cache 交互，但是缓存可能对代码的结果有影响，可以使用这个缓存存储器。在这个缓存存储器上调用 fetch 和 read 方法不返回任何值。

config.cache_store = :null_store

##27.3 缓存键
缓存中使用的键可以是能响应 cache_key 或 to_param 方法的任何对象。如果想定制生成键的方式，可以覆盖 cache_key 方法。Active Record 根据类名和记录 ID 生成缓存键。

缓存键的值可以是散列或数组：

# 这是一个有效的缓存键
Rails.cache.read(site: "mysite", owners: [owner_1, owner_2])
Rails.cache 使用的键与存储引擎使用的并不相同，存储引擎使用的键可能含有命名空间，或者根据后端的限制做调整。这意味着，使用 Rails.cache 存储值时使用的键可能无法用于供 dalli gem 获取缓存条目。然而，你也无需担心会超出 memcached 的大小限制，或者违背句法规则。

##27.4 对条件 GET 请求的支持
条件 GET 请求是 HTTP 规范的一个特性，以此告诉 Web 浏览器，GET 请求的响应自上次请求之后没有变化，可以放心从浏览器的缓存中读取。

为此，要传递 HTTP_IF_NONE_MATCH 和 HTTP_IF_MODIFIED_SINCE 首部，其值分别为唯一的内容标识符和上一次改动时的时间戳。浏览器发送的请求，如果内容标识符（etag）或上一次修改的时间戳与服务器中的版本匹配，那么服务器只需返回一个空响应，把状态设为未修改。

服务器（也就是我们自己）要负责查看最后修改时间戳和 HTTP_IF_NONE_MATCH 首部，判断要不要返回完整的响应。既然 Rails 支持条件 GET 请求，那么这个任务就非常简单：

class ProductsController < ApplicationController

  def show
    @product = Product.find(params[:id])

    # 如果根据指定的时间戳和 etag 值判断请求的内容过期了
    # （即需要重新处理）执行这个块
    if stale?(last_modified: @product.updated_at.utc, etag: @product.cache_key)
      respond_to do |wants|
        # ... 正常处理响应
      end
    end

    # 如果请求的内容还新鲜（即未修改），无需做任何事
    # render 默认使用前面 stale? 中的参数做检查，会自动发送 :not_modified 响应
    # 就这样，工作结束
  end
end
除了散列，还可以传入模型。Rails 会使用 updated_at 和 cache_key 方法设定 last_modified 和 etag：

class ProductsController < ApplicationController
  def show
    @product = Product.find(params[:id])

    if stale?(@product)
      respond_to do |wants|
        # ... 正常处理响应
      end
    end
  end
end
如果无需特殊处理响应，而且使用默认的渲染机制（即不使用 respond_to，或者不自己调用 render），可以使用 fresh_when 简化这个过程：

class ProductsController < ApplicationController

  # 如果请求的内容是新鲜的，自动返回 :not_modified
  # 否则渲染默认的模板（product.*）

  def show
    @product = Product.find(params[:id])
    fresh_when last_modified: @product.published_at.utc, etag: @product
  end
end

##27.4.1 强 Etag 与弱 Etag

Rails 默认生成弱 ETag。这种 Etag 允许语义等效但主体不完全匹配的响应具有相同的 Etag。如果响应主体有微小改动，而不想重新渲染页面，可以使用这种 Etag。

为了与强 Etag 区别，弱 Etag 前面有 W/。

W/"618bbc92e2d35ea1945008b42799b0e7" => 弱 ETag
"618bbc92e2d35ea1945008b42799b0e7"   => 强 ETag
与弱 Etag 不同，强 Etag 要求响应完全一样，不能有一个字节的差异。在大型视频或 PDF 文件内部做 Range 查询时用得到。有些 CDN，如 Akamai，只支持强 Etag。如果确实想生成强 Etag，可以这么做：

class ProductsController < ApplicationController
  def show
    @product = Product.find(params[:id])
    fresh_when last_modified: @product.published_at.utc, strong_etag: @product
  end
end
也可以直接在响应上设定强 Etag：

response.strong_etag = response.body
# => "618bbc92e2d35ea1945008b42799b0e7"


#第 30 章 使用 Rails 开发只提供 API 的应用

在本文中您将学到：

Rails 对只提供 API 的应用的支持；

如何配置 Rails，不使用任何针对浏览器的功能；

如何决定使用哪些中间件；

如何决定在控制器中使用哪些模块。

##30.1 什么是 API 应用？
人们说把 Rails 用作“API”，通常指的是在 Web 应用之外提供一份可通过编程方式访问的 API。例如，GitHub 提供了 API，供你在自己的客户端中使用。

随着客户端框架的出现，越来越多的开发者使用 Rails 构建后端，在 Web 应用和其他原生应用之间共享。

例如，Twitter 使用自己的公开 API 构建 Web 应用，而文档网站是一个静态网站，消费 JSON 资源。

很多人不再使用 Rails 生成 HTML，通过表单和链接与服务器通信，而是把 Web 应用当做 API 客户端，分发包含 JavaScript 的 HTML，消费 JSON API。

本文说明如何构建伺服 JSON 资源的 Rails 应用，供 API 客户端（包括客户端框架）使用。

##30.2  为什么使用 Rails 构建 JSON API？
提到使用 Rails 构建 JSON API，多数人想到的第一个问题是：“使用 Rails 生成 JSON 是不是有点大材小用了？使用 Sinatra 这样的框架是不是更好？”

对特别简单的 API 来说，确实如此。然而，对大量使用 HTML 的应用来说，应用的逻辑大都在视图层之外。

多数人使用 Rails 的原因是，Rails 提供了一系列默认值，开发者能快速上手，而不用做些琐碎的决定。

下面是 Rails 提供的一些开箱即用的功能，这些功能在 API 应用中也适用。

在中间件层处理的功能：

重新加载：Rails 应用支持简单明了的重新加载机制。即使应用变大，每次请求都重启服务器变得不切实际，这一机制依然适用。

开发模式：Rails 应用自带智能的开发默认值，使得开发过程很愉快，而且不会破坏生产环境的效率。

测试模式：同开发模式。

日志：Rails 应用会在日志中记录每次请求，而且为不同环境设定了合适的详细等级。在开发环境中，Rails 记录的信息包括请求环境、数据库查询和基本的性能信息。

安全性：Rails 能检测并防范 IP 欺骗攻击，还能处理时序攻击中的加密签名。不知道 IP 欺骗攻击和时序攻击是什么？这就对了。

参数解析：想以 JSON 的形式指定参数，而不是 URL 编码字符串形式？没问题。Rails 会代为解码 JSON，存入 params 中。想使用嵌套的 URL 编码参数？也没问题。

条件 GET 请求：Rails 能处理条件 GET 请求相关的首部（ETag 和 Last-Modified），然后返回正确的响应首部和状态码。你只需在控制器中使用 stale? 做检查，剩下的 HTTP 细节都由 Rails 处理。

HEAD 请求：Rails 会把 HEAD 请求转换成 GET 请求，只返回首部。这样 HEAD 请求在所有 Rails API 中都可靠。

虽然这些功能可以使用 Rack 中间件实现，但是上述列表的目的是说明 Rails 默认提供的中间件栈提供了大量有价值的功能，即便“只是生成 JSON”也用得到。

在 Action Pack 层处理的功能：

资源式路由：如果构建的是 REST 式 JSON API，你会想用 Rails 路由器的。按照约定以简明的方式把 HTTP 映射到控制器上能节省很多时间，不用再从 HTTP 方面思考如何建模 API。

URL 生成：路由的另一面是 URL 生成。基于 HTTP 的优秀 API 包含 URL（比如 GitHub Gist API）。

首部和重定向响应：head :no_content 和 redirect_to user_url(current_user) 用着很方便。当然，你可以自己动手添加相应的响应首部，但是为什么要费这事呢？

缓存：Rails 提供了页面缓存、动作缓存和片段缓存。构建嵌套的 JSON 对象时，片段缓存特别有用。

基本身份验证、摘要身份验证和令牌身份验证：Rails 默认支持三种 HTTP 身份验证。

监测程序：Rails 提供了监测 API，在众多事件发生时触发注册的处理程序，例如处理动作、发送文件或数据、重定向和数据库查询。各个事件的载荷中包含相关的信息（对动作处理事件来说，载荷中包括控制器、动作、参数、请求格式、请求方法和完整的请求路径）。

生成器：通常生成一个资源就能把模型、控制器、测试桩件和路由在一个命令中通通创建出来，然后再做调整。迁移等也有生成器。

插件：有很多第三方库支持 Rails，这样不必或很少需要花时间设置及把库与 Web 框架连接起来。插件可以重写默认的生成器、添加 Rake 任务，而且继续使用 Rails 选择的处理方式（如日志记录器和缓存后端）。

当然，Rails 启动过程还是要把各个注册的组件连接起来。例如，Rails 启动时会使用 config/database.yml 文件配置 Active Record。

简单来说，你可能没有想过去掉视图层之后要把 Rails 的哪些部分保留下来，不过答案是，多数都要保留。

##30.3 基本配置
如果你构建的 Rails 应用主要用作 API，可以从较小的 Rails 子集开始，然后再根据需要添加功能。

###30.3.1 新建应用

生成 Rails API 应用使用下述命令：

$ rails new my_api --api
这个命令主要做三件事：

配置应用，使用有限的中间件（比常规应用少）。具体而言，不含默认主要针对浏览器应用的中间件（如提供 cookie 支持的中间件）。

让 ApplicationController 继承 ActionController::API，而不继承 ActionController::Base。与中间件一样，这样做是为了去除主要针对浏览器应用的 Action Controller 模块。

配置生成器，生成资源时不生成视图、辅助方法和静态资源。

###30.3.2 修改现有应用

如果你想把现有的应用改成 API 应用，请阅读下述步骤。

在 config/application.rb 文件中，把下面这行代码添加到 Application 类定义的顶部：

config.api_only = true
在 config/environments/development.rb 文件中，设定 config.debug_exception_response_format 选项，配置在开发环境中出现错误时响应使用的格式。

如果想使用 HTML 页面渲染调试信息，把值设为 :default：

config.debug_exception_response_format = :default
如果想使用响应所用的格式渲染调试信息，把值设为 :api：

config.debug_exception_response_format = :api
默认情况下，config.api_only 的值为 true 时，config.debug_exception_response_format 的值是 :api。

最后，在 app/controllers/application_controller.rb 文件中，把下述代码

class ApplicationController < ActionController::Base
end
改为

class ApplicationController < ActionController::API
end
##30.4 选择中间件
API 应用默认包含下述中间件：

Rack::Sendfile

ActionDispatch::Static

ActionDispatch::Executor

ActiveSupport::Cache::Strategy::LocalCache::Middleware

Rack::Runtime

ActionDispatch::RequestId

Rails::Rack::Logger

ActionDispatch::ShowExceptions

ActionDispatch::DebugExceptions

ActionDispatch::RemoteIp

ActionDispatch::Reloader

ActionDispatch::Callbacks

Rack::Head

Rack::ConditionalGet

Rack::ETag

各个中间件的作用参见 33.3.3 节。

其他插件，包括 Active Record，可能会添加额外的中间件。一般来说，这些中间件对要构建的应用类型一无所知，可以在只提供 API 的 Rails 应用中使用。

可以通过下述命令列出应用中的所有中间件：

$ rails middleware
##30.4.1 使用缓存中间件

默认情况下，Rails 会根据应用的配置提供一个缓存存储器（默认为 memcache）。因此，内置的 HTTP 缓存依靠这个中间件。

例如，使用 stale? 方法：

def show
  @post = Post.find(params[:id])

  if stale?(last_modified: @post.updated_at)
    render json: @post
  end
end
上述 stale? 调用比较请求中的 If-Modified-Since 首部和 @post.updated_at。如果首部的值比最后修改时间晚，这个动作返回“304 未修改”响应；否则，渲染响应，并且设定 Last-Modified 首部。

通常，这个机制会区分客户端。缓存中间件支持跨客户端共享这种缓存机制。跨客户端缓存可以在调用 stale? 时启用：

def show
  @post = Post.find(params[:id])

  if stale?(last_modified: @post.updated_at, public: true)
    render json: @post
  end
end
这表明，缓存中间件会在 Rails 缓存中存储 URL 的 Last-Modified 值，而且为后续对同一个 URL 的入站请求添加 If-Modified-Since 首部。

可以把这种机制理解为使用 HTTP 语义的页面缓存。

###30.4.2 使用 Rack::Sendfile

在 Rails 控制器中使用 send_file 方法时，它会设定 X-Sendfile 首部。Rack::Sendfile 负责发送文件。

如果前端服务器支持加速发送文件，Rack::Sendfile 会把文件交给前端服务器发送。

此时，可以在环境的配置文件中设定 config.action_dispatch.x_sendfile_header 选项，为前端服务器指定首部的名称。

关于如何在流行的前端服务器中使用 Rack::Sendfile，参见 Rack::Sendfile 的文档。

下面是两个流行的服务器的配置。这样配置之后，就能支持加速文件发送功能了。

# Apache 和 lighttpd
config.action_dispatch.x_sendfile_header = "X-Sendfile"

# Nginx
config.action_dispatch.x_sendfile_header = "X-Accel-Redirect"
请按照 Rack::Sendfile 文档中的说明配置你的服务器。

###30.4.3 使用 ActionDispatch::Request

ActionDispatch::Request#params 获取客户端发来的 JSON 格式参数，将其存入 params，可在控制器中访问。

为此，客户端要发送 JSON 编码的参数，并把 Content-Type 设为 application/json。

下面以 jQuery 为例：

jQuery.ajax({
  type: 'POST',
  url: '/people',
  dataType: 'json',
  contentType: 'application/json',
  data: JSON.stringify({ person: { firstName: "Yehuda", lastName: "Katz" } }),
  success: function(json) { }
});
ActionDispatch::Request 检查 Content-Type 后，把参数转换成：

{ :person => { :firstName => "Yehuda", :lastName => "Katz" } }
##30.4.4 其他中间件

Rails 自带的其他中间件在 API 应用中可能也会用到，尤其是 API 客户端包含浏览器时：

Rack::MethodOverride

ActionDispatch::Cookies

ActionDispatch::Flash

管理会话

ActionDispatch::Session::CacheStore

ActionDispatch::Session::CookieStore

ActionDispatch::Session::MemCacheStore

这些中间件可通过下述方式添加：

config.middleware.use Rack::MethodOverride
###30.4.5 删除中间件

如果默认的 API 中间件中有不需要使用的，可以通过下述方式将其删除：

config.middleware.delete ::Rack::Sendfile
注意，删除中间件后 Action Controller 的特定功能就不可用了。

##30.5 选择控制器模块
API 应用（使用 ActionController::API）默认有下述控制器模块：

ActionController::UrlFor：提供 url_for 等辅助方法。

ActionController::Redirecting：提供 redirect_to。

AbstractController::Rendering 和 ActionController::ApiRendering：提供基本的渲染支持。

ActionController::Renderers::All：提供 render :json 等。

ActionController::ConditionalGet：提供 stale?。

ActionController::BasicImplicitRender：如果没有显式响应，确保返回一个空响应。

ActionController::StrongParameters：结合 Active Model 批量赋值，提供参数白名单过滤功能。

ActionController::ForceSSL：提供 force_ssl。

ActionController::DataStreaming：提供 send_file 和 send_data。

AbstractController::Callbacks：提供 before_action 等方法。

ActionController::Rescue：提供 rescue_from。

ActionController::Instrumentation：提供 Action Controller 定义的监测钩子（详情参见 28.3 节）。

ActionController::ParamsWrapper：把参数散列放到一个嵌套散列中，这样在发送 POST 请求时无需指定根元素。

其他插件可能会添加额外的模块。ActionController::API 引入的模块可以在 Rails 控制台中列出：

$ bin/rails c
>> ActionController::API.ancestors - ActionController::Metal.ancestors
###30.5.1 添加其他模块

所有 Action Controller 模块都知道它们所依赖的模块，因此在控制器中可以放心引入任何模块，所有依赖都会自动引入。

可能想添加的常见模块有：

AbstractController::Translation：提供本地化和翻译方法 l 和 t。

ActionController::HttpAuthentication::Basic（或 Digest 或 Token）：提供基本、摘要或令牌 HTTP 身份验证。

ActionView::Layouts：渲染时支持使用布局。

ActionController::MimeResponds：提供 respond_to。

ActionController::Cookies：提供 cookies，包括签名和加密 cookie。需要 cookies 中间件支持。

模块最好添加到 ApplicationController 中，不过也可以在各个控制器中添加。
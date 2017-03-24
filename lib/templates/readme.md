34.6 通过修改生成器模板定制工作流程
前面我们只想在生成的辅助方法中添加一行代码，而不增加额外的功能。为此有种更为简单的方式：替换现有生成器的模板。这里要替换的是 Rails::Generators::HelperGenerator 的模板。

在 Rails 3.0 及以上版本中，生成器搜索模板时不仅查看源根目录，还会在其他路径中搜索模板。其中一个是 lib/templates。我们要定制的是 Rails::Generators::HelperGenerator，因此可以在 lib/templates/rails/helper 目录中放一个模板副本，名为 helper.rb。创建这个文件，写入下述内容：

module <%= class_name %>Helper
  attr_reader :<%= plural_name %>, :<%= plural_name.singularize %>
end
然后撤销之前对 config/application.rb 文件的修改：

config.generators do |g|
  g.orm             :active_record
  g.template_engine :erb
  g.test_framework  :test_unit, fixture: false
  g.stylesheets     false
  g.javascripts     false
end
再生成一个资源，你将看到，得到的结果完全一样。如果你想定制脚手架模板和（或）布局，只需在 lib/templates/erb/scaffold 目录中创建 edit.html.erb、index.html.erb，等等。

Rails 的脚手架模板经常使用 ERB 标签，这些标签要转义，这样生成的才是有效的 ERB 代码。

例如，在模板中要像下面这样转义 ERB 标签（注意多了个 %）：

<%%= stylesheet_include_tag :application %>
生成的内容如下：

<%= stylesheet_include_tag :application %>
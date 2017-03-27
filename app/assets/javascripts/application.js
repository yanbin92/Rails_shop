// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery-ui/effects/effect-blind
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//在 JavaScript 文件中，Sprockets 指令以 //=. 开头。
//上述代码中使用了 require 和 require_tree 指令。
//require 指令用于告知 Sprockets 哪些文件需要加载。
//这里加载的是 Sprockets 搜索路径中的 jquery.js 和 jquery_ujs.js 文件。
//我们不必显式提供文件的扩展名，因为 Sprockets 假定在 .js 文件中加载的总是 .js 文件。
//require_tree 指令告知 Sprockets 以递归方式包含指定文件夹中的所有 JavaScript 文件。
//在指定文件夹路径时，必须使用相对于清单文件的相对路径。
//也可以通过 require_directory 指令包含指定文件夹中的所有 JavaScript 文件，此时将不会采取递归方式

//清单文件中的指令是按照从上到下的顺序处理的，但我们无法确定 require_tree 指令包含文件的顺序，因此不应该依赖于这些文件的顺序。如果想要确保连接文件时某些 JavaScript 文件出现在其他 JavaScript 文件之前，
//可以在清单文件中先行加载这些文件。注意，require 系列指令不会重复加载文件。


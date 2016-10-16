# README

#What’s with method: :delete?
You may have noticed that the scaffold-generated Destroy link includes the method:
:delete parameter. This determines which method is called in the ProductsController class
and also affects which HTTP method is used.
Browsers use HTTP to talk with servers. HTTP defines a set of verbs that browsers
can employ and defines when each can be used. A regular hyperlink, for example,
uses an HTTP GET request. A GET request is defined by HTTP as a means of retrieving
data and therefore isn’t supposed to have any side effects. Using the method parameter
in this way indicates that an HTTP DELETE method should be used for this hyperlink.
Rails uses this information to determine which action in the controller to route this
request to.
Note that when used within a browser, Rails substitutes the HTTP POST method for
PUT, PATCH, and DELETE methods and in the process tacks on an additional parameter
so that the router can determine the original intent. Either way, the request isn’t
cached or triggered by web crawlers

# ActiveRecordLite

This project is implemented in Ruby to create a Ruby-on-Rails-like framework.

# Features

- Use Rack as middleware to handle HTTP request and response cycles. 
- Implement a ControllerBase super class, from which ApplicationController inherits, with Ruby. 
- Templating engine using ERB and binding. 
- Create a simple Session and cookie interface. 
- Implement URL routing and HTTP request parsing. 
- Implement Exception/Error handling with middleware. 
- Allows middleware to serve static assets, i.e. html, css, javascript files. 
- Implement authenticity token checking to prevent Cross-Site Request Forgery (CSRF).
- Combine with Active Record Lite to provide additional association helper for relational database querying.  

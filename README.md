# Simple Blog developed on Roda Toolkit
This repository uses Roda and Sequel to create a simple blog with login/users capabilities using PostgreSQL.

## How to execute this app

To be able to execute this project you may need:
* Bundle install (this app requires PostgreSQL)
* Create a new DB in your PostgreSQL instance
* Open db/connection.rb and define the credentials and information for your DB
* Run rake db:migrate
* As the app requires a valid user to access the admin site, you may need to create a new user from the app. For that it's possible to add in `./myapp.rb` after the "require './models/user.rb'", the following line `User.new(name: "YOUR_NAME", email: "YOUR_EMAIL", password: "PASSWORD_HERE", password_confirmation: "PASSWORD_HERE").save`.
* Run `rackup` to start the server (Please do not open the browser at this point)
* Stop the server, remove the User creation line from `myapp.rb` and restart the server 
* Open http://localhost:9292 to see your executing site

## Credits
Code base was obtain from [Michael Cook' blog](https://mrcook.uk/simple-roda-blog-tutorial), some changes were applied to ensure that the app works with the latest version of Roda.

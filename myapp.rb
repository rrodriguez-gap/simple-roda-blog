require "roda"
require "sequel"
require "bcrypt"
require "rack/protection"
# File that handles DB connection
require './db/connection'

class Myapp < Roda
  Sequel::Model.plugin :validation_helpers
  Sequel::Model.plugin :timestamps, update_on_create: true

  use Rack::Session::Cookie, secret: "Random_string_O25KNR80MZHO3BTDD0A7YEDHU9BYP6O54OTV31CBIG4A671IV69C2TR8RRYL1E2JD6H65FKJI8F6MLAWJH8FPEYTP13G6M", key: "_myapp_session"
  use Rack::Protection
  plugin :csrf
  # Automatically escape tags (XSS prevention). 
  # This require the usage of == in views with the elements that we do not require to escape
  plugin :render, escape: true

  require './models/user.rb'
  require './models/post.rb'

  route do |r|
    r.root do
      @posts = Post.reverse_order(:created_at)
      view("homepage")
    end

    r.get "login" do
      view("login")
    end
    r.post "login" do
      if user = User.authenticate(r["email"], r["password"])
        session[:user_id] = user.id
        r.redirect "/"
      else
        r.redirect "/login"
      end
    end
    r.post "logout" do
      session.clear
      r.redirect "/"
    end

    r.get /posts\/([0-9]+)/ do |id|
      @post = Post[id]
      @user_name = @post.user.name
      view("posts/show")
    end

    unless session[:user_id]
      r.redirect "/login"
    end

    r.on "posts" do
      r.get "new" do
        @post = Post.new
        view("posts/new")
      end
      r.post do
        @post = Post.new(r["post"])
        @post.user = User[session[:user_id]]

        if @post.valid? && @post.save
          r.redirect "/"
        else
          view("posts/new")
        end
      end
      r.on Integer do |id|
        @post = Post[id]
        r.get "edit" do
          view("posts/edit")
        end
        r.post do
          if @post.update(r["post"])
            r.redirect "/posts/#{@post.id}"
          else
            view("posts/edit")
          end
        end
      end
    end

    r.on "users" do
      r.get "new" do
        @user = User.new
        view("users/new")
      end

      r.get ":id" do |id|
        @user = User[id]
        view("users/show")
      end

      r.is do
        r.get do
          @users = User.order(:id)
          view("users/index")
        end

        r.post do
          @user = User.new(r["user"])
          if @user.valid? && @user.save
            r.redirect "/users"
          else
            puts @user.inspect
            view("users/new")
          end
        end
      end
    end
  end
end

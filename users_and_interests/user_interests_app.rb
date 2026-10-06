require "tilt/erubi"
require "sinatra"
require "sinatra/reloader"
require "yaml"
require "pry"

before do
  @users = YAML.load_file("data/users.yaml")
end

get "/" do
  redirect "/users"
end

get "/users" do
  
  erb :list_users
end

get "/users/:name" do
  @name = params[:name].to_sym
  @email = @users[@name][:email]
  @interests = @users[@name][:interests]
  erb :user
end

helpers do
  def count_interests
    @users.sum { |_, data| data[:interests].size }
  end
end

not_found do
  redirect "/"
end
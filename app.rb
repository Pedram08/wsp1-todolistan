require 'debug'
require "awesome_print"

class App < Sinatra::Base
    register Sinatra::Reloader

    def db
      return @db if @db

      @db = SQLite3::Database.new(DB_PATH)
      @db.results_as_hash = true

      return @db
    end

    get '/' do        
        erb(:'todos/index')
    end

    get '/todos' do
      @todos = db.execute('SELECT * FROM todos')
      ap @todos
      erb(:'todos/index')
    end

    get '/todos/new' do
      erb(:'todos/new')
    end

    get '/todos/:id' do
      id = params[:id]
      @todo = db.execute('SELECT * FROM todos WHERE id = ?', id).first
      erb(:'todos/show')
    end

    post '/todos' do
      name = params[:name]
      description = params[:description]
      db.execute('INSERT INTO todos (name, description) VALUES (?, ?)', [name, description])
      redirect ('/todos')
    end

    post '/todo/:id/delete' do | id |
      db.execute("DELETE FROM todos WHERE id =?", id)
      redirect("/todos")
    end


end

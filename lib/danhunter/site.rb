require 'rubygems'
require 'sinatra/base'
require 'less'
require 'haml'
require 'danhunter/helpers'
require 'open-uri'

module DanHunter
  class Site < Sinatra::Base
    
    #includes
    
    autoload :Article, 'danhunter/site/article'
    
    # config 
    
    configure :development do
      enable :logging, :dump_errors, :raise_errors
      set :show_exceptions, true
    end

    configure :production do
      enable :logging
      
      not_found do
        haml :not_found
      end
      
      error do
        haml :error
      end
    end
    
    configure do
      set :public, 'public'
      set :views,  'views'
    end
    
    set :haml, :format => :html5
    
    # resources
    
    get '/stylesheet.css' do
      content_type 'text/css', :charset => 'utf-8'
      less :stylesheet
    end
    
    mime_type :ttf, 'application/octet-stream'
    mime_type :woff, 'application/octet-stream'
    
    # routes
    
    get '/' do
      redirect Article.latest.path
    end
    
    get '/articles/' do
      redirect Article.latest.path
    end
    
    get '/articles/:id' do
      @article = Article.open_by_id(params[:id])
      
      if @article
        @previous_article = @article.prev
        @next_article = @article.next

        haml :show
      else
        haml :not_found
      end
    end
    
    get '/portfolio' do
      haml :portfolio
    end
    
    get '/resume' do
      content_type 'application/pdf'
      open('https://s3.amazonaws.com/danhunter.co.uk/danhunter-resume.pdf')
    end
  end
end

# Test at <appname>.heroku.com
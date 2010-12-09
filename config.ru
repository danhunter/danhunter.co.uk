## There is no need to set directories here anymore;
## Just run the application

require 'rubygems'
require 'sinatra/base'

$LOAD_PATH << File.dirname(__FILE__) + '/lib'

require 'danhunter'
run DanHunter::Site
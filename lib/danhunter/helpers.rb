module DanHunter
  module Helpers
    
    def h(text)
      Rack::Utils.escape_html(text)
    end
    
    def ordinalize(number)
      
      number = number.to_i
      
      if(11 <= number % 100 && number % 100 <= 13) then
        return "#{number}th"
      else
        case (number % 10) 
          when 1 then "#{number}st"
          when 2 then "#{number}nd"
          when 3 then "#{number}rd"
          else "#{number}th"
        end
      end
    end
    
    def format_date(string)
      
      date = Date.parse(string)
      
      day = ordinalize(date.mday)
      month = Date::MONTHNAMES[date.month]
      
      return "#{day} #{month}"
    end
    
    def link_to(text, link, title = nil)
      title = "Go to #{text}" if title.nil?
      "<a href ='#{link}' title='#{title}'>#{text}</a>"
    end
    
  end
end

module Haml::Helpers
  include DanHunter::Helpers
end
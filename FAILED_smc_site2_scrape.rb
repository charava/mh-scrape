  ### :( it doesnt work!!! won't let us scrape it due to the weird site construction...resorting to just copypasta-ing the raw txt

require 'ferrum'

browser = Ferrum::Browser.new

browser.goto('http://cdn.smchealth.org/directory.html')
puts browser.current_title


for num in (1...22) do 

  titlepath =  '/html/body/div[2]/form/div[4]/div[' + num.to_s + ']/div/h2'
  everythingelsepath = '/html/body/div[2]/form/div[4]/div[' + num.to_s + ']/div'

  title = browser.at_xpath(titlepath).text
  everythingelse = browser.at_xpath(everythingelsepath).text

  puts title


   
end

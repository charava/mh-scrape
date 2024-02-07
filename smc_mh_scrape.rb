require 'ferrum'
require 'daru'

browser = Ferrum::Browser.new

num_of_errors = 0


browser.goto('https://smchealthonline.com/directory/index.php?ID=&site_city=&site_zip=&languages=&site_specialty=&search=y')
puts browser.current_title

columns = ['Title', 'Phone', 'Website', 'Street Address', 'City', 'State', 'Zip', 'County', 'Specialty', 'Hours', 'Accommodations', 'Telehealth Offered', 'Languages/Cultural Capabilities', 'Language Line Interpretation Services Available', 'Accepting New Clients']
df = Daru::DataFrame.new([], order: columns)

for num in (2..274).step(2) do # 274
titlepath = '/html/body/div[4]/div[' + num.to_s + ']/div[1]/b'
phonepath = '/html/body/div[4]/div[' + num.to_s + ']/div[2]/div/div[1]/p/a'
sitepath = '/html/body/div[4]/div[' + num.to_s + ']/div[2]/div/div[1]/a[1]'
addresspath = '/html/body/div[4]/div[' + num.to_s + ']/div[2]/div/div[1]/a[2]'
bigleftboxpath = '/html/body/div[4]/div[' + num.to_s + ']/div[2]/div/div[1]'
bigrightboxpath = '/html/body/div[4]/div[' + num.to_s + ']/div[2]/div/div[2]'

begin # some of the entries gave an error...so after trying to find a way to salvage them/still scrape them, i decided to just ignore them
    leftside = browser.at_xpath(bigleftboxpath).text
    rightside = browser.at_xpath(bigrightboxpath).text

    title = browser.at_xpath(titlepath).text
    cleaned_title = title.strip.gsub(/\s+/, ' ')

    phone = browser.at_xpath(phonepath).text
    website = browser.at_xpath(sitepath).text
    address = browser.at_xpath(addresspath).text

    pattern = /^(.*?)(?:\s{2,}|\s*,\s*)(.*?),\s*([A-Z]{2})\s*(\d{5})$/
    matches = address.match(pattern)
    if matches
    street_address = matches[1].strip
    city = matches[2].strip
    state = matches[3]
    zip_code = matches[4]
    else
    puts "No match found for address."
    street_address = city = state = zip_code = ''
    end

    county = leftside.match(/County:\s*(.+?)(?=\n|\z)/m)&.captures&.first&.strip

    specialty = leftside.match(/Specialty:(.*?)(?=\n|\z)/m)&.captures&.first&.strip
    hours = leftside.match(/Hours:\s*(.+?)(?=\n|\z)/m)&.captures&.first&.strip
    accommodations = rightside.match(/Accommodations:(.*?)(?=Telehealth Offered:)/m)&.captures&.first&.strip
    telehealth_offered = rightside.match(/Telehealth Offered:(.*?)(?=Languages\/Cultural Capabilities:)/m)&.captures&.first&.strip
    language_capabilities = rightside.match(/Languages\/Cultural Capabilities:(.*?)(?=Language Line Interpretation Services Available:)/m)&.captures&.first&.strip

    language_capabilities = rightside.gsub(/\s+/, '')
    language_capabilities = rightside.gsub(/\s+/, '').gsub(/ExcellentorFluent/, 'Fluent')
    pattern = /([A-Za-z]+)Proficiency:(Good|Fluent)/i
    language_proficiencies = language_capabilities.scan(pattern).map { |match| match.join(':') }.join(';')

    interpretation_services = rightside.match(/Language Line Interpretation Services Available:(.*?)(?=Accepting New Clients:)/m)&.captures&.first&.strip
    accepting_new_clients = rightside.match(/Accepting New Clients:(.*?)(?=\n|$)/m)&.captures&.first&.strip

    df.add_row([cleaned_title, phone, website, street_address, city, state, zip_code, county, specialty, hours, accommodations, telehealth_offered, language_proficiencies, interpretation_services, accepting_new_clients])

rescue NoMethodError => e
    puts "An error occurred in the loop: #{e.message}"
    num_of_errors = num_of_errors + 1
    next  # Continue to the next iteration of the loop
end
end

CSV.open('output.csv', 'w', write_headers: true, headers: columns) do |csv|
  df.each_row { |row| csv << row.to_a }
end

puts 'Finished!'
puts num_of_errors
browser.quit

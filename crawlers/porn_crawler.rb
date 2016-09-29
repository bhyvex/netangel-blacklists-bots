require 'uri'
require 'curb'

output_directory = 'crawler_output'
`mkdir #{output_directory}`

##########################
# thepornlist.net        #
##########################

# Configuration
site = 'http://www.thepornlist.net'
filename = 'thepornlist'
locations = ['/', '/discounts', '/premium-paysites', ]

locations.each do |location|
  get_url = "#{site}#{location}"
  puts get_url
  html = Curl.get( get_url )
  puts html.status
  content = html.body_str
  urls = URI.extract( content )
  File.open( "#{output_directory}/#{filename}", 'a' ) do |file|
    urls.each { |url| file.puts( url ) }
  end
end


##########################
# thebestfetishsites.com #
##########################

# Configuration
site = 'http://thebestfetishsites.com'
filename = 'thebestfetishsites'

get_url = site
puts get_url
html = Curl.get( get_url )
puts html.status
content = html.body_str
urls = URI.extract( content )
File.open( "#{output_directory}/#{filename}", 'a' ) do |file|
  urls.each { |url| file.puts( url ) }
end


##########################
# boodigo.com            #
##########################

# Configuration
site = 'https://boodigo.com'
filename = 'boodigo'
starting_page = 1
pages = 1000
search_terms = ['sex', 'nude', 'naked', 'anal', 'oral', 'orgasm', 'erotic', 'breast', 'boob', 'fuck', 'pussy', 'strip', 'penis', 'babe', 'xxx', 'a']

search_terms.each do |term|
  count = starting_page
  pages.times do
    get_url = "#{site}/search?q=#{term}&p=#{count}"
    puts get_url
    html = Curl.get( get_url )
    puts html.status
    content = html.body_str
    urls = URI.extract( content )
    File.open( "#{output_directory}/#{filename}", 'a' ) do |file|
      urls.each { |url| file.puts( url ) }
    end
    count += 1
  end
end


# Post processing
# Combine, sort, and uniquify
# sort file1 file2 | uniq | grep http >> combined_file
# Pull out domains
require 'uri'
domains = []
File.foreach( 'boodigo_smaller_sorted' ) do |line|
  begin
    line = URI.encode( line )
    domains << URI.parse( line ).host
  rescue StandardError => e
    puts e
    puts "DIED on #{line}"
    next
  end
end
domains = domains.compact
File.open( 'boodigo_smaller_sorted_domains', 'w+' ) do |file|
  file.puts( domains )
end
# sort combined_domains_file | uniq >> combined_domains_file_uniq_sort

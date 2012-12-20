require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'uri'
require 'pdf-reader'
require 'docsplit'

class PageTextReceiver
  attr_accessor :content, :page_counter
  def initialize
    @content = []
    @page_counter = 0
  end
  # Called when page parsing starts
  def begin_page(arg = nil)
    @page_counter += 1
    @content << ""
  end
  # record text that is drawn on the page
  def show_text(string, *params)
    @content.last << string
  end
  # there's a few text callbacks, so make sure we process them all
  alias :super_show_text :show_text
  alias :move_to_next_line_and_show_text :show_text
  alias :set_spacing_next_line_show_text :show_text
  # this final text callback takes slightly different arguments
  def show_text_with_positioning(*params)
    params = params.first
    params.each { |str| show_text(str) if str.kind_of?(String)}
  end
end
url = "http://www.co.ramsey.mn.us/sheriff/bookings/index.htm"
base_link = URI.parse(url)
puts base_link
base_url = "#{base_link.scheme}://#{base_link.host}"
data = Nokogiri::HTML(open(url))
pdf_url = Array.new 
data.search('#txtContent li a/@href').each do |url_content|
     if url_content.to_s.include? ".pdf" 
	pdf_url <<  url_content
     end 
end
puts pdf_url
#getting the first pdf link 
final_url = (base_url + pdf_url[0]).to_s
puts final_url
pdf = open(final_url)
receiver = PageTextReceiver.new
pdf_reader = PDF::Reader.new
pdf_reader.parse(pdf,receiver)
pdf_scrap_data = Array.new
receiver.content.each {|r| pdf_scrap_data << r.strip}



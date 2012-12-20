require 'rubygems'
require 'pdftohtmlr'
require 'nokogiri'
 
include PDFToHTMLR
# to convert the pdf  to html
pdf_to_convert = PdfFileUrl.new("http://www.co.ramsey.mn.us/NR/rdonlyres/24C5BA51-55F9-4224-937B-42822A769854/31412/RCSOInmate24HourRpt121720120854.pdf")
html_result = pdf_to_convert.convert
# save the result into a html file
aFile = File.new("sample1.html", "w")
aFile.write(html_result)
aFile.close



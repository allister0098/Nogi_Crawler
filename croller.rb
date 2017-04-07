require 'nokogiri'
require 'open-uri'
require_relative './useragent'

url = 'http://blog.nogizaka46.com/'
css = 'http://blog.nogizaka46.com./shared.css?ver20121007'
# html = open(url, 'User-Agent' => UserAgents.agent).read

open(css, 'User-Agent' => UserAgents.agent) do |uri|
  File.open 'shared.css?ver20121007', 'w' do |html|
    html.puts uri.read
  end
end

# doc = Nokogiri::HTML html
# puts doc.xpath("//div[@class='entry-content']").text

# urls = ['http://blog.livedoor.jp/staff/']
# opts = {
#     depth_limit: false,
#     delay: 1
# }
#
# Anemone.crawl(urls, opts) do |anemone|
#   anemone.focus_crawl do |page|
#     page.links.keep_if {|link|
#       link.to_s.match /blog.livedoor.jp\/staff\/archives\/(\d+)\.html/
#     }
#   end
#
#   anemone.on_every_page do |page|
#     # 処理対象とするURLの表示
#     puts page.url
#   end
# end
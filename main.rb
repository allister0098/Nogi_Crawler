require 'open-uri'
require 'nokogiri'
require_relative './useragent'
require_relative './crawler'



URL = 'http://blog.nogizaka46.com/asuka.saito/?p=0&d=201701'
CSS = 'http://blog.nogizaka46.com./shared.css?ver20121007'
Directory = Dir.home + '/Documents/nogi_blog/html/members/asuka_saito/'
CSSDir = Dir.home + '/Documents/nogi_blog/'

pattern = %r{\d{4}/\d{2}/\d{6}}

# ディレクトリ作成
FileUtils.mkdir_p(Directory) unless FileTest.exist?(Directory)

Crawler.past_entry_url.each { |url|
  open(url, 'User-Agent' => UserAgents.agent) do |uri|
    if pattern === url
      file_name = url.slice(pattern).gsub %r{/}, '_'
    else
      url.slice %r{\d{6}}
    end

    File.open Directory + file_name + '.html', 'w' do |html|
      html.puts uri.read
    end
    puts file_name
  end

  sleep 1
}

open CSS, 'User-Agent' => UserAgents.agent do |uri|
  File.open CSSDir + 'red.css', 'w' do |html|
    html.puts uri.read
  end
end

require 'open-uri'
require 'nokogiri'
require 'date'
require_relative './useragent'

class Crawler

  BaseUrl = 'http://blog.nogizaka46.com/asuka.saito/'
  LastUrl = 'http://blog.nogizaka46.com/asuka.saito/?p=0&d=201111'
  Day = 1

  def self.past_entry_url
    # 本日から2011/11までさかのぼる
    date = Date.today
    req_url = to_url date
    url_arr = Array.new

    loop do
      a_month_article_url_arr(req_url) { |url|
        puts "#{url}"
        url_arr.push url
      }
      # 終端まで行ったら終了
      break if req_url == LastUrl
      # 前月を取得
      date = prev_month date
      # URLに変換
      req_url = to_url date
    end
    # 重複したURLを削除
    url_arr.uniq!
    # 作成したURLを逆順にする
    url_arr.reverse!
    url_arr
  end

  private
  def self.to_url(date)
    month =  date.month.to_i < 10 ? "0#{date.month}" : "#{date.month}"
    BaseUrl + "?p=0&d=#{date.year}#{month}"
  end

  def self.prev_month(current)
    if current.month == 1
      Date.new current.year - 1, 12, Day
    else
      Date.new current.year, current.month - 1, Day
    end
  end

  def self.a_month_article_url_arr(req_url)
    # ページネーションタグからその月のページ全てを取得する
    doc = Nokogiri::HTML(open(req_url, 'User-Agent' => UserAgents.agent))
    # ページネーションタグのaタグを取得
    doc_a = doc.css('div.paginate').css('a')

    doc.css('span.entrytitle').css('a').each do |article_url|
      yield article_url[:href]
    end if doc_a.count == 0

    doc_a.each do |e|
      # 各ページから記事のURLを取得する
      doc2 = Nokogiri::HTML open(BaseUrl + e[:href], 'User-Agent' => UserAgents.agent)
      doc2.css('span.entrytitle').css('a').each do |article_url|
        yield article_url[:href]
      end
    end
  end
end
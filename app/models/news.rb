require 'open-uri'

class News
  ATOM_URL = "http://blog.jilion.com/atom.xml"

  attr_accessor :title, :url, :categories, :date

  def initialize(entry)
    @title      = entry.title
    @url        = entry.links.first.href
    @categories = entry.categories.map(&:label)
    @date       = entry.published.utc
  end

  def self.get_latest_sublimevideo_news(count)
    feed    = Atom::Feed.load_feed(URI.parse(ATOM_URL))
    entries = feed.entries.select { |entry|
      categories = entry.categories.map(&:term)
      categories.include?('sublimevideo') && categories.exclude?('sublimevideo-showcase')
    }
    entries.first(count).map { |entry| News.new(entry) }
  end

end

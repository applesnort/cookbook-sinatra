require 'nokogiri'
require 'open-uri'
require_relative '../../recipe'


class RecipesFromUrl
  def self.call(query)
    url = "https://www.bbcgoodfood.com/search/recipes?query=#{query}"
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)
    output = []
    html_doc.search('.view-content article').each do |element|
      name = element.search('a').text.strip
      description = element.search('div.field-item.even').text.strip
      prep_time = element.search('li.teaser-item__info-item.teaser-item__info-item--total-time').text.strip
      img = element.search('div.teaser-item__image a img').attr('src').to_s
      img = "http:" + img
      output << Recipe.new(Hash.new(
        name: name,
        description: description,
        prep_time: prep_time,
        img: img))
    end
    return output
  end
end

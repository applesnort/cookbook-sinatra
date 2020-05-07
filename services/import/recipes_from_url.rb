require 'nokogiri'
require 'open-uri'
require_relative '../../recipe'


class RecipesFromUrl
  def self.call(query)
    url = "https://www.bbcgoodfood.com/search/recipes?query=#{query}"
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)
    output = []
    # div.view-content article#node-99422.node.node-recipe.node-teaser-item.clearfix h3.teaser-item__title a
    html_doc.search('.view-content article').each do |element|
      name = element.search('a').text.strip
      description = element.search('div.field-item.even').text.strip
      # li.teaser-item__info-item.teaser-item__info-item--total-time span.mins
      prep_time = element.search('li.teaser-item__info-item.teaser-item__info-item--total-time span.mins').text.strip
      # .teaser-item__image a img
      img = element.search('.teaser-item__image a img').attr('src').to_s
      p img
      img = "http:" + img
      output << Recipe.new(
        name: name,
        description: description,
        prep_time: prep_time,
        img: img)
    end
    p output
    return output
  end
end

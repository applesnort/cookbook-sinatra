require 'nokogiri'
require 'open-uri'
require_relative '../../recipe'

class RecipesFromUrl
  def self.call(query)
    url = "https://www.bbcgoodfood.com/search/recipes?query=#{query}"
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)
    output_array = []
    html_doc.search('.view-content article').each do |element|
      output_array << Recipe.new(
        element.search('a').text.strip,
        element.search('div.field-item.even').text.strip,
        element.search('li.teaser-item__info-item.teaser-item__info-item--total-time').text.strip,
        # html.rgba.supports.mediaqueries.no-touchevents.boxsizing.csstransforms3d.csstransitions.datauri.js.overthrow-enabled body.bbcgf-user-collections-nids-processed.search-header-bar-added-processed div#scroll-wrapper.search-page div#scroller div.container-wrapper div#container.container.main-container div.main.row.grid-padding div#search-main div.row div.lg-col.lg-span8 div.row div.search-content.col.span9 div#content div#search-results div.view.view-bbcgf-search.view-id-bbcgf_search.view-display-id-recipes.view-dom-id-2090b3e3eb3303cb10cc44bf791d8d8a div.view-content article#node-95689.node.node-recipe.node-teaser-item.clearfix div.teaser-item__image a img
        element.search('div.teaser-item__image a img')
      )
    end
    return output_array.first(5)
  end
end

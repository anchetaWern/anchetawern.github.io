# Title: Toron Plugin for Jekyll
# Author: Wern Ancheta http://anchetawern.github.com
# Description: Easily output images from a specific directory
#

module Jekyll
  class Toron < Liquid::Tag

    def initialize(tag_name, id, tokens)
      super
      
    end

    def render(context)

      content = "hello world!"  

      return content
      
    end
  end
end

Liquid::Template.register_tag('toron', Jekyll::Toron)


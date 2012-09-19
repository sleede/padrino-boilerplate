class CssCompressor
  def compress(css)
    root_node = ::Sass::SCSS::CssParser.new(css, self.class.to_s).parse
    root_node.options = {:style => :compressed}
    root_node.render.strip
  end
end

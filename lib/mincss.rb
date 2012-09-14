# Compressor de css

class Mincss
  def self.compress(css)
    #define formatting around the characters
    colon = ':'
    semicolon = ';'
    comma = ','
    open_brace = '{'
    close_brace = '}'

    #one block per line 
    css.gsub!(/\n/,' ')

    #no tab
    css.gsub!(/\t/, '')

    #get rid of comments
    css.gsub!(/\/\*.*?\*\//m,'')

    #apply formatting defined above
    css.gsub!(/\s*:\s*/,colon)
    css.gsub!(/\s*;\s*/,semicolon)
    css.gsub!(/\s*,\s*/,comma)
    css.gsub!(/\s*\{\s*/,open_brace)
    css.gsub!(/\s*;\}\s*/,close_brace)
    css.gsub!(/\s* \}\s*/,close_brace)

    #single spacing
    css.gsub!(/\s\s+/,' ')

    return css
  end
end

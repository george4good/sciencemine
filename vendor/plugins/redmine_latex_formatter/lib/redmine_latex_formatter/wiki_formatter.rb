require 'rd/rdfmt'
require 'rd/visitor'
require 'rd/version'
require 'rd/rd2html-lib'
require 'uv'

module RedmineLatexFormatter
  class WikiFormatter
    FILTERS = [
    ].freeze

    class RestrictedHTMLVisitor < RD::RD2HTMLVisitor
      def apply_to_DocumentElement(element, content)
        content.join
      end
    end

    def initialize(text)
      @text = text
    end
    def to_html(&block)
      data =  @text
      data.gsub!(/\\input\{(.*?)\}/,"\\input [[\\1]] ")
      #data.gsub!(/\\input\{(.*?)\}/,"{[{a href='WIKI_HOME\\1'}]}\\0{[{/a}]}")
     #raise @wiki.to_yaml.to_s
      return ("<br/>"+Uv.parse(data, "xhtml", "latex", true, "twilight").gsub("{[{","<").gsub("}]}",">").gsub("[{[","[[").gsub("]}]","]]").gsub("WIKI_HOME","/wiki/ebook/").to_s)
     
    rescue Racc::ParseError => e
      return "<pre>#{e.message}</pre>"
    end
  end
end

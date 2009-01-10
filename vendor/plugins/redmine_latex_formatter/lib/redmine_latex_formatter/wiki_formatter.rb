require 'rd/rdfmt'
require 'rd/visitor'
require 'rd/version'
require 'rd/rd2html-lib'
require 'uv'
require 'terminator'
require 'digest/md5'


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
    def dinamic_preview text
      hash = "latex_render_"+Digest::MD5.hexdigest(text)
      res = CACHE[hash]
      return res unless res.blank?

      path = File.join(RAILS_ROOT,"tmp","latex_html_render",hash)
      in_file_name = File.join(path,"in.html")
      FileUtils.mkdir_p(path);
      File.open(in_file_name,"w"){|in_file|
        in_file.write(text)
        in_file.close }
      

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

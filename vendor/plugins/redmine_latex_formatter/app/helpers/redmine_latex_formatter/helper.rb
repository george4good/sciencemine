module RedmineLatexFormatter
  module Helper
    unloadable

    def wikitoolbar_for(field_id)
      file = Engines::RailsExtensions::AssetHelpers.plugin_asset_path('redmine_latex_formatter', 'help', 'rd_syntax.html')
      help_link = l(:setting_text_formatting) + ': ' +
      link_to(l(:label_help), file,
              :onclick => "window.open(\"#{file}\", \"\", \"resizable=yes, location=no, width=300, height=640, menubar=no, status=no, scrollbars=yes\"); return false;")

      javascript_include_tag('jstoolbar/jstoolbar') +
        javascript_include_tag('rd', :plugin => 'redmine_latex_formatter') +
        javascript_include_tag("lang/rd-#{current_language}", :plugin => 'redmine_latex_formatter') +
        javascript_tag("var toolbar = new jsToolBar($('#{field_id}')); toolbar.setHelpLink('#{help_link}'); toolbar.draw();")
    end

    def initial_page_content(page)
<<LATEX

\\documentclass[12pt]{book}
\\usepackage{mathtext}         
\\usepackage[T2A]{fontenc}     
\\usepackage[koi8-r]{inputenc} 
\\usepackage[russian]{babel}  
\\usepackage[pdftex]{graphicx}
\\DeclareSymbolFont{T2Aletters}{T2A}{cmr}{m}{it}

\\usepackage{amsmath,amsfonts,amssymb, euscript}
\\usepackage{latexsym,euscript}
\\newcommand{\\CM}{{\\mathcal{M}}}
\\newcommand{\\CE}{{\\mathcal{E}}}

\\newcommand{\\CP}{{\\EuScript{P}}}
\\begin{document}
\\title{#{page.wiki.project.name}}
\\author{}
\\maketitle


\\end{document}
LATEX
    end

    def heads_for_wiki_formatter
      stylesheet_link_tag('jstoolbar') +
        stylesheet_link_tag('rd', :plugin => 'redmine_latex_formatter')
    end
  end
end

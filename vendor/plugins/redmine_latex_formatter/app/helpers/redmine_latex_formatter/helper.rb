module RedmineLatexFormatter
  module Helper
    unloadable

    def wikitoolbar_for(field_id)
      tex_actoins = <<LIST
part{
chapter{^}
section{^}
subsection{^}
subsubsection{^}
paragraph{^}
subparagraph{^}
textbf{^}
textit{^}
underline{^}
begin{center}
end{center}
item
frac{^}{}
sqrt{^}
chi
alpha
beta
delta
epsilon
phi
iota
gamma
theta
kappa
lambda
mu
newcommand{\^}{}
LIST
      tex_actoins=tex_actoins.split()
      if @project
        tex_actoins+=(@project.wiki.pages.map do |x|
            x.text.scan(/\\bibitem\{([^\}]*)\}/) do
              tex_actoins<<"cite{#{$1}}"
            end
            x.text.scan(/\\newcommand\{\\([^\}]*)\}/) do
              tex_actoins<<"#{$1}"
            end
            "input{#{x.title}}"
          end
        )

        tex_actoins+=(@project.attachments.map{|x|"includegraphics[width=125^mm]{#{x.filename}}" })

        @project
        tex_actoins+=(@page.attachments.map{|x|"includegraphics[width=125^mm]{#{x.filename}}" }) 
      end


    tex_actoins=tex_actoins.uniq.map{|x|"'#{x.gsub(/\'/,"\\'")}'"}.join(',');
    file = Engines::RailsExtensions::AssetHelpers.plugin_asset_path('redmine_latex_formatter', 'help', 'rd_syntax.html')
    help_link = l(:setting_text_formatting) + ': ' +
      link_to(l(:label_help), file,
      :onclick => "window.open(\"#{file}\", \"\", \"resizable=yes, location=no, width=300, height=640, menubar=no, status=no, scrollbars=yes\"); return false;")
    ta = <<TEXAUTOCOMPLITE

var tex_tags = [#{tex_actoins}];

new Autocompleter.Local('#{field_id}', 'tex_tags_list', tex_tags, {tokens:['\\\\'] ,
afterUpdateElement:function(){$('#{field_id}').focus();},onShow:    function(element, update){
        if(!update.style.position || update.style.position=='absolute') {
          update.style.position = 'absolute';
          update.setOpacity(0.5);

          Position.clone(element.up(), update, {
            setHeight: false,
            offsetLeft: (element.offsetWidth-250),
            setWidth: false
          });
        }
        Effect.Appear(update,{duration:0.15});
      } });
TEXAUTOCOMPLITE
    '<div class="autocomplete" id="tex_tags_list" style="display:none"></div>'+
      javascript_include_tag('jstoolbar/jstoolbar') +
      javascript_include_tag('rd', :plugin => 'redmine_latex_formatter') +
      javascript_include_tag("lang/rd-#{current_language}", :plugin => 'redmine_latex_formatter') +
      javascript_tag("var toolbar = new jsToolBar($('#{field_id}')); toolbar.setHelpLink('#{help_link}'); toolbar.draw();")+
      javascript_tag(ta)

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

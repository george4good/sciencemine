class LatexController < ApplicationController
  def to_html command='latex2html'
    @start_page =Project.find(params[:id]).wiki.find_page(params[:page])
    prepare_files(@start_page)
    path = File.join(RAILS_ROOT,"public","latex",@start_page.wiki.id.to_s,@start_page.title+".tex")
    @results = %x[latex2html #{path}]
    @preview_url = File.join("latex",@start_page.wiki.id.to_s,@start_page.title,@start_page.title+".html")

  end
  def to_pdf
    @start_page =Project.find(params[:id]).wiki.find_page(params[:page])
    prepare_files(@start_page)
    path = File.join(RAILS_ROOT,"public","latex",@start_page.wiki.id.to_s)
    
    Dir.chdir(path)
    @results = %x[pdflatex -halt-on-error  #{@start_page.title+".tex"}]
    @preview_url = File.join("latex",@start_page.wiki.id.to_s,@start_page.title+".pdf")
    render :action=>'to_html'
  end
  private
  def save_page page,seen=[]
    project = Project.find(params[:id])
    return if seen.include?(page)
    seen<<page
    path = File.join(RAILS_ROOT,"public","latex",page.wiki.id.to_s)
    FileUtils.mkdir_p(path);
    text= page.text
    
    text.gsub!(/\\includegraphics([^\{]*)\{(.*?)\}/) do |data|
      saved_file = project.attachments.find(:first,:conditions=>{:filename=>$2})
      new_name=(saved_file.blank?)? '../../images/false.png':saved_file.diskfile
      "\\includegraphics#{$1}{#{new_name}}"
    end
    text = Iconv.iconv("KOI8-R","UTF-8",text).to_s
    File.open(File.join(path,page.title+".tex"), "w") { |f|f.write(text);f.close();  }
    text.scan(/\\input\{(.*?)\}/).each do |data|
      sub_page= project.wiki.find_page(data[0])

      save_page( sub_page,seen) if !sub_page.blank?
    end

  end
  def prepare_files start_page
    save_page start_page

  end

end

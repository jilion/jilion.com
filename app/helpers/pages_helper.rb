module PagesHelper
  
  def hl(content)
    content_tag(:span, content, :class => "highlight")
  end
  
  def tg(content)
    content_tag(:span, content, :class => "tag")
  end
  
end

module LayoutHelper

  def title(text)
    content_for :title do
      raw strip_tags(" - #{text}")
    end
  end

end

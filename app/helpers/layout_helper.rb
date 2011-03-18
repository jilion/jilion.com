module LayoutHelper
  def title(text)
    content_for :title do
      strip_tags(" - #{text}")
    end
  end
end
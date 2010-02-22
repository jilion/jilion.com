h1 = { :size => 18, :style => :bold, :leading => 20 }
h2 = { :size => 16, :style => :bold, :leading => 15 }
h3 = { :size => 11, :style => :bold, :leading => 6 }
p  = { :leading => 12 }
p_indent = 0
pdf.font "Helvetica"
pdf.font_size 11

pdf.text "Jilion Contact - Would you like us to work for you?", h1
pdf.text "Copy of your submission on https://jilion.com/contact on #{I18n.l(@contact.created_at, :format => :long)}", p.merge(:style => :italic)

pdf.pad_top(20) do
  pdf.text "About You", h2
  pdf.text "Contact Person: name and last name", h3
  pdf.indent(p_indent) { pdf.text @contact.name, p }
  pdf.text "Your email address", h3
  pdf.indent(p_indent) { pdf.text @contact.email, p }
  pdf.text "Phone number", h3
  pdf.indent(p_indent) { pdf.text @contact.phone, p }
  pdf.text "Organization or Company name", h3
  pdf.indent(p_indent) { pdf.text @contact.organization, p }
  pdf.text "URL (web address)", h3
  pdf.indent(p_indent) { pdf.text @contact.url, p }
  pdf.text "What is your domain of activity / industry?", h3
  pdf.indent(p_indent) { pdf.text @contact.activity, p }
end

pdf.pad_top(30) do
  pdf.text "About your Project", h2
  pdf.text "What is your budget for this project?", h3
  pdf.indent(p_indent) { pdf.text @contact.budget, p }
  pdf.text "Please describe the project you would like us to work on", h3
  pdf.indent(p_indent) { pdf.text @contact.project_description, p }
  pdf.text "What is the general goal or specific achievements you have for this project?", h3
  pdf.indent(p_indent) { pdf.text @contact.goal, p }
  pdf.text "Do you have metrics for such achievements?", h3
  pdf.indent(p_indent) { pdf.text @contact.metrics, p }
  pdf.text "Is there any particular challenge (technical, business, organizational, etc.) you want to highlight?", h3
  pdf.indent(p_indent) { pdf.text @contact.challenge, p }
  pdf.text "Are there already set deadlines?", h3
  pdf.indent(p_indent) { pdf.text @contact.deadline, p }
  pdf.text "Additional comments", h3
  pdf.indent(p_indent) { pdf.text @contact.comment, p }
end

pdf.number_pages "<page>/<total>", [pdf.bounds.right - 20, 0]

module TableSurgeon
  module ViewHelpers
    
    def table_surgeon(records, path)
      return no_records if records.nil? || records.empty?

      # swiped from actionpack 2.3.5 form_tag_helper.rb
      html = form_tag_html(html_options_for_form(path, :multipart => true, :method => :put))
      html += 
        content_tag(:table, 
          "",
          :class => "stickup")
      html += "</form>".html_safe!
      html
    end
    
    private
      def no_records
        content_tag(:p, "No records have been selected to edit.")
      end
  end
end
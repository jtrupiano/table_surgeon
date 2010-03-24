module TableSurgeon
  module ViewHelpers
    # What is keeping us from rendering multiple table_surgeon's on the same page
    # input name fields using "table_surgeon[]"
    
    # What is still hard-coded?
    #   submit_tag with text "Mass Update Records"
    #   placement of submit button
    #   no class names for table rows -- should allow args to cycle() to be passed in
    def table_surgeon(records, *args)
      return no_records if records.nil? || records.empty?

      options = args.extract_options!
      css_class = options.fetch(:class) { "surgery" }
      
      # swiped from actionpack 2.3.5 form_tag_helper.rb (including the closing </form> tag below)
      html = form_tag_html(html_options_for_form(@_table_surgeon_return_path, :multipart => true, :method => :put))
      html += 
        content_tag(:table, 
          header_row + body_rows(records),
          :class => css_class) +
        submit_tag("Mass Update Records")
      html += "</form>".html_safe!
      html
    end
    
    private
      def no_records
        content_tag(:p, "No records have been selected to edit.")
      end
      
      def header_row
        content_tag(:tr, 
          (@_table_surgeon_display_columns.keys.sort + @_table_surgeon_editable_columns.keys.sort).map {|col|
            content_tag(:td, col)
          }.join
        )
      end
      
      def body_rows(records)
        records.map {|record|
          content_tag(:tr,
            @_table_surgeon_display_columns.keys.sort.map {|col|
              content_tag(:td, render_display_col(record, col, @_table_surgeon_display_columns[col]))
            }.join +
              @_table_surgeon_editable_columns.keys.sort.map {|col|
                content_tag(:td, render_editable_col(record, col, @_table_surgeon_editable_columns[col]))
              }.join
          )
        }.join
      end
      
      def render_display_col(obj, col, coltype)
        case coltype
        when :text : h(obj.send(col))
        when :image : image_tag(obj.send(col)) unless obj.send(col).nil?
        else
          "Can't find coltype #{coltype}"
        end
      end

      def render_editable_col(obj, col, coltype)
        case coltype
        when :file_field : send("#{coltype}_tag", "table_surgeon[#{obj.id}][#{col}]")
        when :text_field : send("#{coltype}_tag", "table_surgeon[#{obj.id}][#{col}]", obj.send(col))
        else
          "Can't find coltype #{coltype}"
        end
      end
      
  end
end
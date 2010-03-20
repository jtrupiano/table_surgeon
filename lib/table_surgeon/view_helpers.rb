module TableSurgeon
  module ViewHelpers
    
    # What is still hard-coded?
    # @_table_surgeon_display_columns
    # @_table_surgeon_editable_columns
    # table class name "stickup"
    # input name fields using "speakers[]" in render_editable_col
    def table_surgeon(records, path)
      return no_records if records.nil? || records.empty?

      # swiped from actionpack 2.3.5 form_tag_helper.rb (including the closing </form> tag below)
      html = form_tag_html(html_options_for_form(path, :multipart => true, :method => :put))
      html += 
        content_tag(:table, 
          header_row + body_rows(records),
          :class => "stickup")
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
        when :file_field : send("#{coltype}_tag", "speakers[#{obj.id}][#{col}]")
        when :text_field : send("#{coltype}_tag", "speakers[#{obj.id}][#{col}]", obj.send(col))
        else
          "Can't find coltype #{coltype}"
        end
      end
      
  end
end
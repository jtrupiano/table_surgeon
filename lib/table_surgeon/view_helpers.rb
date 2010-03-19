module TableSurgeon
  module ViewHelpers
    
    def table_surgeon(records, path)
      return no_records if records.nil? || records.empty?
    end
    
    private
      def no_records
        content_tag(:p, "No records have been selected to edit.")
      end
  end
end
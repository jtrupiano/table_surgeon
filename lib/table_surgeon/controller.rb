module TableSurgeon
  module Controller
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def table_surgeon(action, *args)
        options = args.extract_options!
        define_method(action) do
          @_table_surgeon_display_columns  = options.fetch(:display) {{}}.stringify_keys
          @_table_surgeon_editable_columns = options.fetch(:edit) {{}}.stringify_keys
          @_table_surgeon_return_path      = _table_surgeon_parse_return_path(options)
          if request.put?
            begin
              ActiveRecord::Base.transaction do
                params[:table_surgeon].keys.each do |obj_id|
                  obj = _table_surgeon_find(options[:finder], obj_id)
                  obj.update_attributes!(params[:table_surgeon][obj_id])
                end
                flash[:notice] = "Updated all of your records"
              end
            rescue => er
              flash[:error] = "No updates were made. Something went wrong: #{er.message}"
              logger.error(er.backtrace)
            ensure
              redirect_to @_table_surgeon_return_path
            end
          end
        end
      end
    end
    
    private
      def _table_surgeon_find(finder_as_proc, obj_id)
        instance_eval(&(finder_as_proc)).find(obj_id)
      end
      
      def _table_surgeon_parse_return_path(options)
        path = options.fetch(:path) { "/" }
        return instance_eval(&path) if path.is_a?(Proc)
        return path
      end
  end
end

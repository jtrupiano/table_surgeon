require 'test_helper'
require 'action_controller'
require 'action_view/helpers'
require 'table_surgeon/view_helpers'

class TableSurgeon::ViewHelpersTest < ActionController::TestCase
  include ActionView::Helpers
  include TableSurgeon::ViewHelpers
  
  test "when an empty or nil recordset is provided, table_surgeon returns 'No records' p tag" do
    [[], nil].each do |records|
      html = table_surgeon(records, "/")
      
      doc = HTML::Document.new html
      assert_select doc.root, "p", :text => "No records have been selected to edit.", :count => 1
      assert_select doc.root, "p", :count => 1
      assert_select doc.root, "form", :count => 0
      assert_select doc.root, "table", :count => 0
    end
  end
end
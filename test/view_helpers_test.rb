require 'test_helper'
require 'action_controller'
require 'action_view/helpers'
require 'table_surgeon/view_helpers'
require 'mocks/speaker_mock'

class TableSurgeon::ViewHelpersTest < ActionController::TestCase
  include ActionView::Helpers
  include TableSurgeon::ViewHelpers
  
  # Address rendering of form tag
  def protect_against_forgery?
    false
  end
  
  def setup
    # Set up instance variables expected by table_surgeon()
    @_table_surgeon_display_columns  = {"name" => :text, "image" => :image}
    @_table_surgeon_editable_columns = {"image" => :file_field, "video_url" => :text_field}
    @_table_surgeon_return_path      = "/"
  end
  
  test "when an empty or nil recordset is provided, table_surgeon returns 'No records' p tag" do
    [[], nil].each do |records|      
      html = table_surgeon(records)
      
      doc = HTML::Document.new html
      assert_select doc.root, "p", :text => "No records have been selected to edit.", :count => 1
      assert_select doc.root, "p", :count => 1
      assert_select doc.root, "form", :count => 0
      assert_select doc.root, "table", :count => 0
    end
  end
  
  test "when 4 records are provided, table_surgeon returns a form, a table with a class of 'surgery', a header row, 4 body rows (each containing a file input field and a text field), and a submit button" do
    html = table_surgeon((1..4).map{|i| TableSurgeon::SpeakerMock.new(i)})
    doc = HTML::Document.new html
    assert_select doc.root, "form", :count => 1
    assert_select doc.root, "form table.surgery", :count => 1
    assert_select doc.root, "form table.surgery tr", :count => 5
    assert_select doc.root, "form table.surgery td input[type=file]", :count => 4
    assert_select doc.root, "form table.surgery td input[type=text]", :count => 4
    assert_select doc.root, "form input", :type => 'submit'
  end
  
  test "when passing in a class of 'data_entry', the html output uses this class" do
    html = table_surgeon((1..4).map{|i| TableSurgeon::SpeakerMock.new(i)}, :class => 'data_entry')
    doc = HTML::Document.new html
    assert_select doc.root, "form table.data_entry", :count => 1
  end
  
end
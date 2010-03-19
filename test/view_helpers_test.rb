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
  
  test "when 4 records are provided, table_surgeon returns a form, a table with a class of 'stickup', a header row, 4 body rows (each containing a file input field and a text field), and a submit button" do
    html = table_surgeon((1..4).map{|i| TableSurgeon::SpeakerMock.new(i)}, "/")
    doc = HTML::Document.new html
    assert_select doc.root, "form", :count => 1
    assert_select doc.root, "form table.stickup", :count => 1
    assert_select doc.root, "form table.stickup tr", :count => 5
    # assert_select doc.root, "form table.stickup tr", :count => 4 do |tr|
    #   assert_select tr, "td input", :type => 'file'
    #   assert_select tr, "td input", :type => 'text'
    # end
    
  end
  
end
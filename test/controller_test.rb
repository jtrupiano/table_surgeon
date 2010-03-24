require 'test_helper'
require 'action_controller'
require 'table_surgeon/controller'
require 'mocks/controller_mock'

class TableSurgeon::ControllerTest < ActiveSupport::TestCase
  test "controller should have a :surgery action" do
    assert TableSurgeon::ControllerMock.new.respond_to?(:surgery)
  end
end

class TableSurgeon::ControllerControllerTest < ActionController::TestCase
  def setup
    @controller = TableSurgeon::ControllerMock.new
  end
  
  test "on GET to surgery should set instance variables" do
    get :surgery
    assert assigns(:_table_surgeon_display_columns)
    assert assigns(:_table_surgeon_editable_columns)
    assert assigns(:_table_surgeon_return_path)
  end
end
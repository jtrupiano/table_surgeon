class TableSurgeon::ControllerMock < ActionController::Base
  include TableSurgeon::Controller
  table_surgeon :surgery
end

ActionController::Routing::Routes.draw do |map|
  map.surgery '/controller_mock/surgery', :controller => 'table_surgeon/controller_mock', :action => 'surgery'
end

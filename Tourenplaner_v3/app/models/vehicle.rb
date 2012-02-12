class Vehicle < ActiveRecord::Base
  attr_accessible :VehicleName, :user_id, :Capacity, :Type
  belongs_to :project, :class_name => "Project"
  belongs_to :user
end

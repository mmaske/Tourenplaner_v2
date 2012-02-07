class Vehicle < ActiveRecord::Base
  belongs_to :project, :class_name => "Project"
end

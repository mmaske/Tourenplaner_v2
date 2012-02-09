class Tour < ActiveRecord::Base
  has_many :nodes
  has_many :vehicles
end

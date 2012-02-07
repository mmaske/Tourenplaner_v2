class Project < ActiveRecord::Base
validates :name,  :presence => true,
                  :uniqueness => true,
               #   :password, :confirmation => true
 belongs_to :user, :class_name => "User", :foreign_key => "user_id"
 has_many :nodes, :class_name => "Node", :dependent => :destroy
 has_many :vehicles, :class_name => "Vehicle", :dependent => :destroy
 has_many :links
  attr_accessible :user_id, :name, :created_at
  accepts_nested_attributes_for :nodes

end
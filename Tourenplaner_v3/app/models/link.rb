class Link < ActiveRecord::Base

#acts_as_gmappable :process_geocoding => true, :validation =>true
#  def gmaps4rails_address
#  "#{self.fromlatitude}, #{self.fromlongitude}"
#  end

attr_accessible :polyline
belongs_to :project
has_many :nodes
belongs_to :user
has_one :vehicle


end

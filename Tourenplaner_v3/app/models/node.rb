class Node < ActiveRecord::Base
attr_accessible :id, :name, :longitude, :latitude, :demand, :country,  :street, :city, :depot
acts_as_gmappable :process_geocoding => true, :validation =>true
  def gmaps4rails_address
  "#{self.street}, #{self.city}, #{self.country}"
  end
  def gmaps4rails_infowindow
      " #{name} \n #{gmaps4rails_address}\n Demand:#{demand}"
  end

  belongs_to :project, :class_name => "Project"
  belongs_to :link
  end
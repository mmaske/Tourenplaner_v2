class Node < ActiveRecord::Base
attr_accessible :id, :name, :longitude, :latitude, :demand, :country,  :street, :city, :depot, :earliest, :latest, :user_id, :servicetime, :jobnumber, :vehicle_id
acts_as_gmappable :process_geocoding => true, :validation =>true
  def gmaps4rails_address
  "#{self.street}, #{self.city}, #{self.country}"
  end
  def gmaps4rails_infowindow
      "#####{id}##### \n #{name} \n #{gmaps4rails_address}\n Demand:#{demand}"
  end


def gmaps4rails_marker_picture
    {
            "picture" => "/images/markers/#{tour_id}_#{jobnumber}.png",
            "width" => "20",
            "height" => "34"
      }

end

  belongs_to :project, :class_name => "Project"
  belongs_to :link
  belongs_to :user
  belongs_to :tour
  end
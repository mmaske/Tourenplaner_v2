class Node < ActiveRecord::Base
attr_accessible :id, :name, :longitude, :latitude, :demand, :country,  :street, :city, :depot, :earliest, :latest, :user_id, :servicetime, :jobnumber, :vehicle_id
acts_as_gmappable :process_geocoding => true, :validation =>true
  def gmaps4rails_address
  "#{self.street}, #{self.city}, #{self.country}"
  end
  def gmaps4rails_infowindow
      "#{name} \n #{gmaps4rails_address}\n Demand:#{demand}"
  end



def gmaps4rails_marker_picture
    {
            "picture" => "/images/markers/#{tour_id}_#{jobnumber}.png",
            "width" => "20",
            "height" => "34"
      }

end

def nodechanged?
    if (self.demand.changed? || self.street.changed? || self.city.changed? || self.earliest.changed? || self.latest.changed? || self.depot?.changed?)
      return true
    else
      false
  end
end

#def formattime
#   hour = (self.servicetime/60)
#   minute =
#end

  belongs_to :project
  belongs_to :user
  end
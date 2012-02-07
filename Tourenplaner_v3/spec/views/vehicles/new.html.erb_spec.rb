require 'spec_helper'

describe "vehicles/new.html.erb" do
  before(:each) do
    assign(:vehicle, stub_model(Vehicle,
      :ID => "MyString",
      :Type => "MyString",
      :Capacity => 1.5
    ).as_new_record)
  end

  it "renders new vehicle form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => vehicles_path, :method => "post" do
      assert_select "input#vehicle_ID", :name => "vehicle[ID]"
      assert_select "input#vehicle_Type", :name => "vehicle[Type]"
      assert_select "input#vehicle_Capacity", :name => "vehicle[Capacity]"
    end
  end
end

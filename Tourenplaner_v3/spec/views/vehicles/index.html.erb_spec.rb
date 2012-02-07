require 'spec_helper'

describe "vehicles/index.html.erb" do
  before(:each) do
    assign(:vehicles, [
      stub_model(Vehicle,
        :ID => "Id",
        :Type => "Type",
        :Capacity => 1.5
      ),
      stub_model(Vehicle,
        :ID => "Id",
        :Type => "Type",
        :Capacity => 1.5
      )
    ])
  end

  it "renders a list of vehicles" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Id".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
  end
end

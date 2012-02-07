require 'spec_helper'

describe "vehicles/show.html.erb" do
  before(:each) do
    @vehicle = assign(:vehicle, stub_model(Vehicle,
      :ID => "Id",
      :Type => "Type",
      :Capacity => 1.5
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Id/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Type/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1.5/)
  end
end

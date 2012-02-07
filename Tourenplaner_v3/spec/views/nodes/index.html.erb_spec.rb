require 'spec_helper'

describe "nodes/index.html.erb" do
  before(:each) do
    assign(:nodes, [
      stub_model(Node,
        :latitude => 1.5,
        :longitude => 1.5,
        :gmaps => false,
        :street => "Street",
        :city => "City",
        :country => "Country",
        :demand => 1.5
      ),
      stub_model(Node,
        :latitude => 1.5,
        :longitude => 1.5,
        :gmaps => false,
        :street => "Street",
        :city => "City",
        :country => "Country",
        :demand => 1.5
      )
    ])
  end

  it "renders a list of nodes" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Street".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "City".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Country".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
  end
end

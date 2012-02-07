require 'spec_helper'

describe "nodes/show.html.erb" do
  before(:each) do
    @node = assign(:node, stub_model(Node,
      :latitude => 1.5,
      :longitude => 1.5,
      :gmaps => false,
      :street => "Street",
      :city => "City",
      :country => "Country",
      :demand => 1.5
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1.5/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1.5/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/false/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Street/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/City/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Country/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1.5/)
  end
end

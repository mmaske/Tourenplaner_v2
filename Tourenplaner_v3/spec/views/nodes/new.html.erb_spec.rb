require 'spec_helper'

describe "nodes/new.html.erb" do
  before(:each) do
    assign(:node, stub_model(Node,
      :latitude => 1.5,
      :longitude => 1.5,
      :gmaps => false,
      :street => "MyString",
      :city => "MyString",
      :country => "MyString",
      :demand => 1.5
    ).as_new_record)
  end

  it "renders new node form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => nodes_path, :method => "post" do
      assert_select "input#node_latitude", :name => "node[latitude]"
      assert_select "input#node_longitude", :name => "node[longitude]"
      assert_select "input#node_gmaps", :name => "node[gmaps]"
      assert_select "input#node_street", :name => "node[street]"
      assert_select "input#node_city", :name => "node[city]"
      assert_select "input#node_country", :name => "node[country]"
      assert_select "input#node_demand", :name => "node[demand]"
    end
  end
end

require File.join(File.dirname(__FILE__),'spec_helper')
$:.unshift File.join(__FILE__,'..','lib')
require 'rhodes_translator'

describe "Binding" do

  it_should_behave_like "RhodesTranslatorHelper"

  
  before(:each) do
    @b = RhodesTranslator::Binding.new

  end
  
  it "should handle hashes" do
    textfieldbind = { 'label' => 'Address',
                      'value' => '{{first_name}} {{last_name}}',
                      'name' => 'address1',
                      'type' => 'text',
                      'type_class' => 'show_text' }

    data = {'first_name' => 'Some', 'last_name' => 'Name'}

    (@b.bind(data,textfieldbind))['value'].should == "Some Name"
  end

  it "should handle nested hashes" do
    textfieldbind = { 'label' => 'Address',
                      'value' => '{{user1/first_name}} {{user1/last_name}}',
                      'name' => 'address1',
                      'type' => 'text',
                      'type_class' => 'show_text' }

    data = {
      'baduser' => {'first_name' => 'Not', 'last_name' => 'Me'},
      'user1' => {'first_name' => 'Some', 'last_name' => 'Name'}
    }

    (@b.bind(data,textfieldbind))['value'].should == "Some Name"
  end

  it "should be an error for bad hash key" do
    textfieldbind = { 'label' => 'Address',
                      'value' => '{{bad_key}}',
                      'name' => 'address1',
                      'type' => 'text',
                      'type_class' => 'show_text' }

    data = {'first_name' => 'Some', 'last_name' => 'Name'}

    (@b.bind(data,textfieldbind))['value'].should == "INVALID KEY"

  end

  it "should handle arrays" do
    textfieldbind = { 'label' => 'Address',
                      'value' => '{{1/first_name}} {{1/last_name}}',
                      'name' => 'address1',
                      'type' => 'text',
                      'type_class' => 'show_text' }

    data = [ {'first_name' => 'Not', 'last_name' => 'Me'},
             {'first_name' => 'Some', 'last_name' => 'Name'} ]

    (@b.bind(data,textfieldbind))['value'].should == "Some Name"
  end

  it "should be an error for a non-integer array index" do
    textfieldbind = { 'label' => 'Address',
                      'value' => '{{user1/first_name}}',
                      'name' => 'address1',
                      'type' => 'text',
                      'type_class' => 'show_text' }

    data = [ {'first_name' => 'Not', 'last_name' => 'Me'},
             {'first_name' => 'Some', 'last_name' => 'Name'} ]

    (@b.bind(data,textfieldbind))['value'].should == "INVALID INDEX"
  end

  it "should be an error for invalid index" do
    textfieldbind = { 'label' => 'Address',
                      'value' => '{{9/first_name}}',
                      'name' => 'address1',
                      'type' => 'text',
                      'type_class' => 'show_text' }

    data = [ {'first_name' => 'Not', 'last_name' => 'Me'},
             {'first_name' => 'Some', 'last_name' => 'Name'} ]

    (@b.bind(data,textfieldbind))['value'].should == "INVALID INDEX"
  end

  it "should expand repeatables" do
    row3 = { 'label' => '{{/names/0/first_name}}',
             'value' => '{{first_name}}, {{last_name}}',
             'name' => 'address2',
             'type' => 'labeledrow' }


    table = { 'label' => 'Table',
              'type' => 'table',
              'children' => [ row3 ],
              'repeatable' => '{{names}}' }



    view = { 'title' => 'IUI meta panel',
             'type' => 'iuipanel',
             'children' => [table] }

    data = {'names' => [ {'first_name' => 'Not', 'last_name' => 'Me'},
             {'first_name' => 'Some', 'last_name' => 'Name'} ] }
    @b.bind(data,view)
    
    view['children'][0]['children'][0]['label'].should == "Not"
    view['children'][0]['children'][0]['value'].should == "Not, Me"
    view['children'][0]['children'][1]['label'].should == "Not"
    view['children'][0]['children'][1]['value'].should == "Some, Name"


  end
end

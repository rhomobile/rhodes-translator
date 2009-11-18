require File.join(File.dirname(__FILE__),'spec_helper')
$:.unshift File.join(__FILE__,'..','lib')
require 'rhodes_translator'

describe "FieldTranslator" do
  
  it_should_behave_like "RhodesTranslatorHelper"
  
  before(:each) do
    @vt = RhodesTranslator::ViewTranslator.new
  end
  
  it "should translate show view with nested div" do
    expected = open(get_template('view_show.html')).read
    @vt.translate_view('show',@view1).split.join('').should == expected.split.join('')
  end

  # it "should translate index view with nested ul" do
  #   
  # end
end
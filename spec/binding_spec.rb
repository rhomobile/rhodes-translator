require File.join(File.dirname(__FILE__),'spec_helper')
$:.unshift File.join(__FILE__,'..','lib')
require 'rhodes_translator'

describe "Binding" do

  it_should_behave_like "RhodesTranslatorHelper"

  
  before(:each) do
    @b = RhodesTranslator::Binding.new

    @klass = Class.new do
      def get_name
        "Some Name"
      end
    end 
  end
  
  it "should parse the binding" do
    (@b.bind(@klass.new,@textfieldbind))[:value].should == "Some Name"
  end

end
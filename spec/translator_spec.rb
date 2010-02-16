require File.join(File.dirname(__FILE__),'spec_helper')
$:.unshift File.join(__FILE__,'..','lib')
require 'rhodes_translator'

describe "Translator" do
  
  it_should_behave_like "RhodesTranslatorHelper"
  
  before(:each) do
    @t = RhodesTranslator::Translator.new
  end
  
  it "should raise exception if default translator is used" do
    lambda { @t.translate }.should raise_error(Exception, "Should never get here.")
  end
  
end
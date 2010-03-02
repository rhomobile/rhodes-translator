require File.join(File.dirname(__FILE__),'spec_helper')
$:.unshift File.join(__FILE__,'..','lib')
require 'rhodes_translator'

describe "Translator" do
  
  it_should_behave_like "RhodesTranslatorHelper"
  
  before(:each) do
    @t = RhodesTranslator::Translator.new
  end
  
  it "should translate show view with nested div" do
    expected = open(get_template('view_show.html')).read
    @t.translate(@view1).split.join('').should == expected.split.join('')
  end

  it "should translate textfield show action" do
    expected = open(get_template('text_show.html')).read
    @t.translate(@textfield).should == expected
  end

  it "should handle nested views" do
    expected = open(get_template('nest_show.html')).read
    @t.translate(@view2).should == expected
  end

  it "should handle complex templates" do
    expected = open(get_template('complex_show.html')).read
    @t.translate(@complex).should == expected
    
  end

end
require File.join(File.dirname(__FILE__),'spec_helper')
$:.unshift File.join(__FILE__,'..','lib')

describe "FieldTranslator" do
  
  it_should_behave_like "RhodesTranslatorHelper"
  
  before(:each) do
    @ft = RhodesTranslator::FieldTranslator.new
  end
  
  it "should translate textfield show action" do
    expected = open(get_template('text_show.html')).read
    @ft.translate_field('show',@textfield).should == expected
  end
  
  # it "should translate number input" do
  #   
  # end
  # 
  # it "should translate enumerated list input" do
  #   
  # end
end
require File.join(File.dirname(__FILE__),'spec_helper')
$:.unshift File.join(__FILE__,'..','lib')
require 'rhodes_translator'
include RhodesTranslator::Validation
describe "Validation" do

  it_should_behave_like "RhodesTranslatorHelper"

  before(:each) do
    #@v = RhodesTranslator::Validation.new
    @meta = { 'label' => 'Address',
                 'value' => '123 fake st',
                 'name' => 'address1',
                 'validation' => {
                   }
               }
  
  end
  
  it "should validate using custom regexp" do

    @meta['validation']['regexp'] = '123 fake st'

    data = {'address1' => '123 fake st'}


    validate(@meta,data).should == nil

    data = {'address1' => 'bad data'}

    validate(@meta,data).length.should == 1
  end

  it "should have required validator" do

    data = {'address1' => ''}
    @meta['validation']['validators'] = ['required']

    validate(@meta,data).length.should == 1

    data = {'address1' => 'required'}

    validate(@meta,data).should == nil
  end

  it "should have number validator" do
    @meta['validation']['validators'] = ['number']
    data = {'address1' => '1234'}

    validate(@meta,data).should == nil

    data = {'address1' => 'not a number'}

    validate(@meta,data).length.should == 1

  end

  it "should have currency validator" do
    @meta['validation']['validators'] = ['currency']
    data = {'address1' => '10.00'}

    validate(@meta,data).should == nil

    data = {'address1' => '123'}

    validate(@meta,data).length.should == 1

  end

  it "should have email validator" do
    @meta['validation']['validators'] = ['email']
    data = {'address1' => 'blah@blah.com'}

    validate(@meta,data).should == nil

    data = {'address1' => 'not an email'}

    validate(@meta,data).length.should == 1

  end

  it "should have phone validator" do
    @meta['validation']['validators'] = ['phone']
    data = {'address1' => '408-555-1212'}

    validate(@meta,data).should == nil

    data = {'address1' => 'not an phone'}

    validate(@meta,data).length.should == 1

  end

  it "should have min_len validator" do
    @meta['validation']['min_len'] = 10
    data = {'address1' => '1234567890'}

    validate(@meta,data).should == nil

    data = {'address1' => '12345'}

    validate(@meta,data).length.should == 1

  end

  it "should have max_len validator" do
    @meta['validation']['max_len'] = 10
    data = {'address1' => '12345'}

    validate(@meta,data).should == nil

    data = {'address1' => '12345678901'}

    validate(@meta,data).length.should == 1

  end

  it "should have min_value validator" do
    @meta['validation']['min_value'] = 10
    data = {'address1' => '12'}

    validate(@meta,data).should == nil

    data = {'address1' => '2'}

    validate(@meta,data).length.should == 1

  end

  it "should have max_value validator" do
    @meta['validation']['max_value'] = 10
    data = {'address1' => '9'}

    validate(@meta,data).should == nil

    data = {'address1' => '11'}

    validate(@meta,data).length.should == 1

  end

  it "should handle multiple errors" do
    @address1 = { 'label' => 'Address',
                 'value' => '123 fake st',
                 'name' => 'address1',
                 'validation' => {
                     'validators' => ['required']
                   }
               }

    @address2 = { 'label' => 'Address',
                 'value' => '123 fake st',
                 'name' => 'address2',
                 'validation' => {
                     'max_value' => 15,
                     'min_value' => 10
                   }
               }

    @address3 = { 'label' => 'Address',
                 'value' => '123 fake st',
                 'name' => 'address3',
                 'validation' => {
                     'max_value' => 20,
                     'min_value' => 12
                   }
               }

    @meta = { 'children' => [@address1, @address2, @address3] }

    data = {'address1' => '11', 'address2' => '12', 'address3' =>'17'}
    validate(@meta,data).should == nil

    data = {'address1' => '', 'address2' => '12', 'address3' =>'17'}
    validate(@meta,data).length.should == 1

    data = {'address1' => '', 'address2' => '9', 'address3' =>'17'}
    validate(@meta,data).length.should == 2

    data = {'address1' => '', 'address2' => '9', 'address3' =>'22'}
    validate(@meta,data).length.should == 3

  end

  it "should have an error for nil metadata" do
    data = {'address1' => '12'}

    validate(nil,data)[0].should == "No metadata found"
  end

  it "should have an error for validation with no name" do
    @meta = { 'label' => 'Address',
      'validation' => {
        'validators' => ['required']
      }
    }

    
    data = {'address1' => '12'}

    validate(@meta,data)[0].should == "Metadata element has validation with no name"

  end

  it "should have an error name with no value" do
    data = {'address111' => '12'}

    validate(@meta,data)[0].should == "No value submitted for metadata element with name address1"

  end

end

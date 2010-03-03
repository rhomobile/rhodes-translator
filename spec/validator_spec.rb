require File.join(File.dirname(__FILE__),'spec_helper')
$:.unshift File.join(__FILE__,'..','lib')
require 'rhodes_translator'

describe "Validation" do

  it_should_behave_like "RhodesTranslatorHelper"

  before(:each) do
    @v = RhodesTranslator::Validation.new
    @address = { 'label' => 'Address',
                 'value' => '123 fake st',
                 'name' => 'address1',
                 'validation' => {
                   }
               }
    @meta = {'index' => @address}
    @referrer = 'http://localhost/app/Address/index'

  end
  
  it "should validate using custom regexp" do

    @meta['index']['validation']['regexp'] = '123 fake st'

    data = {'address1' => '123 fake st'}


    @v.validate(@meta,data,@referrer).length.should == 0

    data = {'address1' => 'bad data'}

    @v.validate(@meta,data,@referrer).length.should == 1
  end

  it "should have required validator" do

    data = {'address1' => ''}
    @meta['index']['validation']['validators'] = ['required']

    @v.validate(@meta,data,@referrer).length.should == 1

    data = {'address1' => 'required'}

    @v.validate(@meta,data,@referrer).length.should == 0
  end

  it "should have number validator" do
    @meta['index']['validation']['validators'] = ['number']
    data = {'address1' => '1234'}

    @v.validate(@meta,data,@referrer).length.should == 0

    data = {'address1' => 'not a number'}

    @v.validate(@meta,data,@referrer).length.should == 1

  end

  it "should have currency validator" do
    @meta['index']['validation']['validators'] = ['currency']
    data = {'address1' => '10.00'}

    @v.validate(@meta,data,@referrer).length.should == 0

    data = {'address1' => '123'}

    @v.validate(@meta,data,@referrer).length.should == 1

  end

  it "should have email validator" do
    @meta['index']['validation']['validators'] = ['email']
    data = {'address1' => 'blah@blah.com'}

    @v.validate(@meta,data,@referrer).length.should == 0

    data = {'address1' => 'not an email'}

    @v.validate(@meta,data,@referrer).length.should == 1

  end

  it "should have phone validator" do
    @meta['index']['validation']['validators'] = ['phone']
    data = {'address1' => '408-555-1212'}

    @v.validate(@meta,data,@referrer).length.should == 0

    data = {'address1' => 'not an phone'}

    @v.validate(@meta,data,@referrer).length.should == 1

  end

  it "should have min_len validator" do
    @meta['index']['validation']['min_len'] = 10
    data = {'address1' => '1234567890'}

    @v.validate(@meta,data,@referrer).length.should == 0

    data = {'address1' => '12345'}

    @v.validate(@meta,data,@referrer).length.should == 1

  end

  it "should have max_len validator" do
    @meta['index']['validation']['max_len'] = 10
    data = {'address1' => '12345'}

    @v.validate(@meta,data,@referrer).length.should == 0

    data = {'address1' => '12345678901'}

    @v.validate(@meta,data,@referrer).length.should == 1

  end

  it "should have min_value validator" do
    @meta['index']['validation']['min_value'] = 10
    data = {'address1' => '12'}

    @v.validate(@meta,data,@referrer).length.should == 0

    data = {'address1' => '2'}

    @v.validate(@meta,data,@referrer).length.should == 1

  end

  it "should have max_value validator" do
    @meta['index']['validation']['max_value'] = 10
    data = {'address1' => '9'}

    @v.validate(@meta,data,@referrer).length.should == 0

    data = {'address1' => '11'}

    @v.validate(@meta,data,@referrer).length.should == 1

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

    @view = { 'children' => [@address1, @address2, @address3] }
    @meta = {'index' => @view}

    data = {'address1' => '11', 'address2' => '12', 'address3' =>'17'}
    @v.validate(@meta,data,@referrer).length.should == 0

    data = {'address1' => '', 'address2' => '12', 'address3' =>'17'}
    @v.validate(@meta,data,@referrer).length.should == 1

    data = {'address1' => '', 'address2' => '9', 'address3' =>'17'}
    @v.validate(@meta,data,@referrer).length.should == 2

    data = {'address1' => '', 'address2' => '9', 'address3' =>'22'}
    @v.validate(@meta,data,@referrer).length.should == 3

  end

end

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

  end
  
  it "should validate using custom regexp" do

    @meta['index']['validation']['regexp'] = '123 fake st'

    data = {'address1' => '123 fake st', 'metadata_action' => 'index'}


    @v.validate(@meta,data).length.should == 0

    data = {'address1' => 'bad data', 'metadata_action' => 'index'}

    @v.validate(@meta,data).length.should == 1
  end

  it "should have required validator" do

    data = {'address1' => '', 'metadata_action' => 'index'}
    @meta['index']['validation']['validators'] = ['required']

    @v.validate(@meta,data).length.should == 1

    data = {'address1' => 'required', 'metadata_action' => 'index'}

    @v.validate(@meta,data).length.should == 0
  end

  it "should have number validator" do
    @meta['index']['validation']['validators'] = ['number']
    data = {'address1' => '1234', 'metadata_action' => 'index'}

    @v.validate(@meta,data).length.should == 0

    data = {'address1' => 'not a number', 'metadata_action' => 'index'}

    @v.validate(@meta,data).length.should == 1

  end

  it "should have currency validator" do
    @meta['index']['validation']['validators'] = ['currency']
    data = {'address1' => '10.00', 'metadata_action' => 'index'}

    @v.validate(@meta,data).length.should == 0

    data = {'address1' => '123', 'metadata_action' => 'index'}

    @v.validate(@meta,data).length.should == 1

  end

  it "should have email validator" do
    @meta['index']['validation']['validators'] = ['email']
    data = {'address1' => 'blah@blah.com', 'metadata_action' => 'index'}

    @v.validate(@meta,data).length.should == 0

    data = {'address1' => 'not an email', 'metadata_action' => 'index'}

    @v.validate(@meta,data).length.should == 1

  end

  it "should have phone validator" do
    @meta['index']['validation']['validators'] = ['phone']
    data = {'address1' => '408-555-1212', 'metadata_action' => 'index'}

    @v.validate(@meta,data).length.should == 0

    data = {'address1' => 'not an phone', 'metadata_action' => 'index'}

    @v.validate(@meta,data).length.should == 1

  end

  it "should have min_len validator" do
    @meta['index']['validation']['min_len'] = 10
    data = {'address1' => '1234567890', 'metadata_action' => 'index'}

    @v.validate(@meta,data).length.should == 0

    data = {'address1' => '12345', 'metadata_action' => 'index'}

    @v.validate(@meta,data).length.should == 1

  end

  it "should have max_len validator" do
    @meta['index']['validation']['max_len'] = 10
    data = {'address1' => '12345', 'metadata_action' => 'index'}

    @v.validate(@meta,data).length.should == 0

    data = {'address1' => '12345678901', 'metadata_action' => 'index'}

    @v.validate(@meta,data).length.should == 1

  end

  it "should have min_value validator" do
    @meta['index']['validation']['min_value'] = 10
    data = {'address1' => '12', 'metadata_action' => 'index'}

    @v.validate(@meta,data).length.should == 0

    data = {'address1' => '2', 'metadata_action' => 'index'}

    @v.validate(@meta,data).length.should == 1

  end

  it "should have max_value validator" do
    @meta['index']['validation']['max_value'] = 10
    data = {'address1' => '9', 'metadata_action' => 'index'}

    @v.validate(@meta,data).length.should == 0

    data = {'address1' => '11', 'metadata_action' => 'index'}

    @v.validate(@meta,data).length.should == 1

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

    data = {'address1' => '11', 'address2' => '12', 'address3' =>'17', 'metadata_action' => 'index'}
    @v.validate(@meta,data).length.should == 0

    data = {'address1' => '', 'address2' => '12', 'address3' =>'17', 'metadata_action' => 'index'}
    @v.validate(@meta,data).length.should == 1

    data = {'address1' => '', 'address2' => '9', 'address3' =>'17', 'metadata_action' => 'index'}
    @v.validate(@meta,data).length.should == 2

    data = {'address1' => '', 'address2' => '9', 'address3' =>'22', 'metadata_action' => 'index'}
    @v.validate(@meta,data).length.should == 3

  end

  it "should have an error for nil metadata" do
    data = {'address1' => '12', 'metadata_action' => 'index'}

    @v.validate(nil,data)[0].should == "No metadata found for action index"
  end

  it "should have an error for validation with no name" do
    @address1 = { 'label' => 'Address',
      'validation' => {
        'validators' => ['required']
      }
    }

    @meta = {'index' => @address1}
    data = {'address1' => '12', 'metadata_action' => 'index'}

    @v.validate(@meta,data)[0].should == "Metadata element has validation with no name"

  end

  it "should have an error name with no value" do
    data = {'address111' => '12', 'metadata_action' => 'index'}

    @v.validate(@meta,data)[0].should == "No value submitted for metadata element with name address1"

  end

end

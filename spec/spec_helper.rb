$:.unshift File.join(__FILE__,'..','lib')
require 'rhodes_translator'

describe "RhodesTranslatorHelper", :shared => true do
  before(:each) do
    @textfield = { :label => 'Address',
                   :value => '5th St.',
                   :name => 'address1',
                   :type => 'text',
                   :type_class => 'show_text' }

    @numberfield = { :label => 'Some Number',
                     :value => 12345,
                     :name => 'number1',
                     :type => 'number',
                     :type_class => 'show_number' }
  end
  
  def get_template(name)
    File.join(File.dirname(__FILE__),'expected',"#{name}")
  end
end
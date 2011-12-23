$:.unshift File.join(__FILE__,'..','lib')
require 'rhodes_translator'
require 'stubs'

describe "RhodesTranslatorHelper", :shared => true do
  before(:each) do
    @textfield = { 'label' => 'Address',
                   'value' => '5th St.',
                   'name' => 'address1',
                   'type' => 'text',
                   'type_class' => 'show_text' }


    @numberfield = { 'label' => 'Some Number',
                     'value' => 12345,
                     'name' => 'number1',
                     'type' => 'number',
                     'type_class' => 'show_number' }
                     
    @panel1 = { 'title' => 'Some Panel',
                'type' => 'panel',
                'children' => [@textfield] }
                
    @panel2 = { 'title' => 'Some Panel',
                'type' => 'panel',
                'children' => [@textfield] }
    @panel3 = { 'title' => 'Some Panel',
                'type' => 'panel',
                'children' => [@panel2] }
                     
    @view1 = { 'title' => 'View 1',
               'type' => 'panel',
               'children' => [@panel1,@panel2] }

    @view2 = { 'title' => 'View 2',
               'type' => 'panel',
               'children' => [@view1,@view1] }
    @complex = { 'title' => 'View 2',
                 'type' => 'panel',
                 'children' => [@textfield,@view2,@panel3,@textfield] }
  end
  
  def get_template(name)
    File.join(File.dirname(__FILE__),'expected',"#{name}")
  end
end
require 'erb'
module RhodesTranslator
  class FieldTranslator < Translator
    
    # Return the translated html for a
    # given a view action and field definition
    def translate_field(view_name,field_def)
      @field_def = field_def
      file = File.join(File.dirname(__FILE__),'templates',"#{@field_def[:type]}_#{view_name}.erb")
      ERB.new(open(file).read).result(binding)
    end
  end
end
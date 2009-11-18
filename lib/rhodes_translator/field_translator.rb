module RhodesTranslator
  class FieldTranslator < Translator
    
    # Return the translated html for a
    # given a view action and field definition
    def translate_field(action,field_def)
      load_erb(action,field_def)
    end
  end
end
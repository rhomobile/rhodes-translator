module RhodesTranslator
  class ViewTranslator < FieldTranslator
    
    CONTAINER_TYPES = ['panel','view','list','form']
    
    # Return the translated html for a
    # given a view action and view definition
    def translate_view(action,view_def)
      @content = ''
      view_def[:children].each do |child|
        if is_container?(child[:type])
          @content += self.translate_view(action,child)
        else
          @content += self.translate_field(action,child)
        end
      end
      load_erb(action,view_def)
    end
    
    def is_container?(type)
      CONTAINER_TYPES.include?(type)
    end
  end
end
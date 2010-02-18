module RhodesTranslator
  class Translator
    include RhodesTranslator

    CONTAINER_TYPES = ['panel','view','list','form']

    # Return the translated html for a
    # given a view action and view definition
    def translate(action,view_def)
      @content = ''
      view_def['children'] ||= []
      view_def['children'].each do |child|
        @content += self.translate(action,child)
      end
      load_erb(action,view_def)
    end

    def is_container?(type)
      CONTAINER_TYPES.include?(type)
    end

  end
end
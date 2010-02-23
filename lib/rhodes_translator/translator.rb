module RhodesTranslator
  class Translator
    include RhodesTranslator

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

  end
end
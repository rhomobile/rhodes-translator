module RhodesTranslator
  class Translator
    include RhodesTranslator

    # Return the translated html for a
    # given a view action and view definition
    def translate(view_def, action='')
      @content = ''
      view_def['children'] ||= []
      view_def['children'].each do |child|
        @content += self.translate(child,action) unless child.nil?
      end
      load_erb(view_def,action)
    end

  end
end
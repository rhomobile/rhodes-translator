module RhodesTranslator
  module Translator
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
  # returns compiled erb with specified def
  def load_erb(doc_def,action)
    @action = action
    @doc_def = doc_def

    require 'rho/rhoviewhelpers'


    file = File.join(Rho::RhoFSConnector.get_app_path('app'),
                         'templates',
                         "#{doc_def['type']}_erb.iseq")


    file = File.join(File.dirname(File.join(__rhoGetCurrentDir(), __FILE__)),
                  
                         'templates',
                         "#{doc_def['type']}_erb.iseq") unless File.exist? file

    eval_compiled_file(file, binding )
  end
  
  end
end
require 'rhodes_translator/translator'
require 'rhodes_translator/binding'
require 'rhodes_translator/validation'

module RhodesTranslator
  
  # returns compiled erb with specified def
  def load_erb(doc_def,action)
    @action = action
    @doc_def = doc_def
        file = File.join(File.dirname(File.join(__rhoGetCurrentDir(), __FILE__)),
                         'rhodes_translator',
                         'templates',
                         "#{doc_def['type']}_erb.iseq")

    eval_compiled_file(file, binding )
  end
end
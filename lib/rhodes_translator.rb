require 'rhodes_translator/translator'
require 'rhodes_translator/binding'

module RhodesTranslator
  
  # returns compiled erb with specified def
  def load_erb(action,doc_def)
    @doc_def = doc_def
    file = File.join(File.dirname(File.join(__rhoGetCurrentDir(), __FILE__)),
                     'rhodes_translator',
                     'templates',
                     "#{doc_def[:type]}_#{action}_erb.iseq")
                   
    #if they dont have a template for a specific action, load default one
    if not File.exist? file
        file = File.join(File.dirname(File.join(__rhoGetCurrentDir(), __FILE__)),
                         'rhodes_translator',
                         'templates',
                         "#{doc_def[:type]}_erb.iseq")

    end
    eval_compiled_file(file, binding )
  end
end
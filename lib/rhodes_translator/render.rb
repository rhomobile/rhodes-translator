module RhodesTranslator
  def load_erb(action,doc_def)
    @doc_def = doc_def
    file = File.join(File.dirname(File.join(__rhoGetCurrentDir(), __FILE__)),
                     'templates',
                     "#{doc_def[:type]}_#{action}_erb.iseq")
    eval_compiled_file(file, binding )
  end
end
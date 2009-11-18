module RhodesTranslator
  def load_erb(action,doc_def)
    @doc_def = doc_def
    file = File.join(File.dirname(__FILE__),
                     '..',
                     'lib',
                     'rhodes_translator',
                     'templates',"#{doc_def[:type]}_#{action}.erb")
    ERB.new(open(file).read).result(binding)
  end
end
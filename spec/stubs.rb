require 'erb'

module RhodesTranslator
  def load_erb(doc_def)
    @doc_def = doc_def
    file = File.join(File.dirname(__FILE__),
                     '..',
                     'lib',
                     'rhodes_translator',
                     'templates',"#{doc_def['type']}.erb")
    ERB.new(open(file).read).result(binding)
  end
end
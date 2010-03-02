module RhodesTranslator
  class Validation
    def validate(doc_def, params, referer)


    end

    def get_action(url)
      data = url.split('/app/')[1]
      data = data.split('/') unless data.nil?
      return 'index' if data.nil? or data[1].nil?
      return data[1]
    end
  end
end
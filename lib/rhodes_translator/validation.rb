module RhodesTranslator
  module Validation
    VALIDATORS = {
      'required' => '^.+$',
      'number' => '[0-9]+',
      'currency' => '[0-9]+\.[0-9][0-9]',
      'email' => '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$',
      'phone' => '^[0-9\- ]+$'
    }

    def validate(metadata, params)
      @errors = nil

      #      action = metadata
      #
      #      if action.nil?
      #        @errors = ["Unable to determine action"]
      #        return @errors
      #      end
      #
      #      metadata = metadata[action] unless metadata.nil?
      if metadata.nil?
        @errors = ["No metadata found"]
        return @errors
      end

      @errors = []

      self.validate_data(metadata,params)
      unless @errors.empty?
        return @errors
      end
    end

    def validate_data(metadata,params)
      metadata['children'] ||= []
      metadata['children'].each do |child|
        self.validate_data(child,params)
      end

      unless metadata['validation'].nil?
        if metadata['name'].nil?
          @errors << "Metadata element has validation with no name"
          return
        end

        if params[metadata['name']].nil?
          @errors << "No value submitted for metadata element with name #{metadata['name']}"
          return
        end

        value = params[metadata['name']]

        unless metadata['validation']['regexp'].nil?
          unless value =~ Regexp.new(metadata['validation']['regexp'])
            @errors << "#{metadata['label']} did not pass regexp validation"
          end
        end

        unless metadata['validation']['validators'].nil?
          metadata['validation']['validators'].each do |validator|
            unless value =~ Regexp.new(RhodesTranslator::Validation::VALIDATORS[validator])
              @errors << "#{metadata['label']} did not pass validation #{validator}"
            end
          end
        end

        unless metadata['validation']['min_len'].nil?
          if value.length < metadata['validation']['min_len'].to_i
            @errors << "#{metadata['label']} too short"
          end
        end

        unless metadata['validation']['max_len'].nil?
          if value.length > metadata['validation']['max_len'].to_i
            @errors << "#{metadata['label']} too short"
          end
        end

        unless metadata['validation']['min_value'].nil?
          if value.to_i < metadata['validation']['min_value'].to_i
            @errors << "#{metadata['label']} too small"
          end
        end

        unless metadata['validation']['max_value'].nil?
          if value.to_i > metadata['validation']['max_value'].to_i
            @errors << "#{metadata['label']} too large"
          end
        end

      end
    end

  end
end
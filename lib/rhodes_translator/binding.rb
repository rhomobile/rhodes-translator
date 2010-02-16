module RhodesTranslator
  class Binding
    include RhodesTranslator

    def bind(data,view_def)
      view_def[:children] ||= []
      view_def[:children].each do |child|
        @content += self.bind(data,child)
      end

      view_def.each do |k,v|
        unless k == :children
          if v.is_a? String
            while v =~ /#\{(.*?)\}/
              method = $1.strip
              v.gsub!(/#\{.*?\}/, data.send(method))
            end
            view_def[k] = v
          end
        end
      end
    end

  end
end
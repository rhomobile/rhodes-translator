module RhodesTranslator
  class Binding
    include RhodesTranslator
    def bind(data,view_def,first=true)
      @origdata = data if first

      view_def[:children] ||= []

      if view_def[:type] == 'repeatable'
        #handle repeatable, must have an elements key. children here are different
      else
        view_def[:children].each do |child|
          self.bind(data,child,false)
        end

      end


      view_def.each do |k,v|
        unless k == :children
          if v.is_a? String
            while v =~ /\{\{(.*?)\}\}/
              pathstring = $1.strip
              regexp = Regexp.escape('{{' + $1 + '}}')
              value = decode_path(data,pathstring)
              v.gsub!(Regexp.new(regexp) , value.to_s)
            end
            view_def[k] = v
          end
        end
      end
    end

    def decode_path(data,pathstring)
      data = @origdata if pathstring =~ /^\|/
      elements = pathstring.split('|')
      current = data
      while element = elements.delete_at(0)
        element.strip!
        begin
           if current.is_a? Array
             index = element.to_i
             return "INVALID INDEX" if index == 0 and element[0].chr != '0'
             return "INVALID INDEX" if current[index].nil?
             current = current[index]
           elsif current.is_a? Hash
             key = element.strip
             return "INVALID KEY" if current[key].nil?
             current = current[key]
           end
        rescue
          return "UNDEFINED ELEMENT"
        end #begin
      end #while
      current
    end #decode_path

  end

end
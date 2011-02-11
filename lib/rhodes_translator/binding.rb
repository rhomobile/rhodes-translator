module RhodesTranslator
  module Binding

    class << self
      attr_accessor :metaorigdata
    end
    def bind(data,view_def,first=true)
      Binding.metaorigdata = data if first

      return if view_def.nil?
      
      view_def['children'] ||= []

      if view_def['repeatable'] and view_def['repeatable'] =~ /\{\{(.*?)\}\}/
        pathstring = $1.strip
        value = decode_path(data,pathstring)
        new_children = []
        repeat_def = view_def
        repeat_def['repeatable'] = nil
        if value.is_a? Array or value.is_a? Hash
          value.each do |element|
            new_def = Marshal.load(Marshal.dump(repeat_def))
            new_child = self.bind(element,new_def,false)["children"]
            new_child.each do |child|
              new_children << child
            end
          end 
        end
        view_def['children'] = new_children
      else
        view_def['children'].each do |child|
          self.bind(data,child,false)
        end

      end


      view_def.each do |k,v|
        unless k == 'children'
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
      Binding.metaorigdata = nil if first
      view_def
    end

    def decode_path(data,pathstring)
      data = Binding.metaorigdata if pathstring =~ /^\//
#      puts "PATH: #{pathstring}, DATA: #{data.inspect}"
      elements = pathstring.split('/')
      elements.delete_at(0) if pathstring =~ /^\//
#      puts "ELEMENTS: #{elements.inspect}"
      current = data
      while element = elements.delete_at(0)
        element.strip!
        if element =~ /^#/
          element.gsub!(/^#/,'')
          element.gsub!(/\)$/,'')
          sube = element.split('(')
          method = sube[0]
          params = sube[1]
          if current.respond_to? method.to_sym
            current = current.send method.to_sym,params
          else
            current = data["self"].send method.to_sym,params
          end
        else
           if current.is_a? Array
             index = element.to_i
             return "INVALID INDEX" if index == 0 and element[0].chr != '0'
             return "INVALID INDEX" if current[index].nil?
             current = current[index]
           elsif current.is_a? Hash
             key = element.strip
             return "INVALID KEY" if current[key].nil?
             current = current[key]
           elsif current
             begin
               current = current.send element.strip
             rescue Exception => e
               return "INVALID DATA TYPE"
             end
           end
        end
      end #while
      current
    end #decode_path

  end

end
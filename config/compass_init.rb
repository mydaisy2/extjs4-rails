# based on https://raw.github.com/sakuro/ext_rails_shim/master/config/compass_init.rb @e0c05fade1a16601714cf9fd822e61321ab6dfc2
# based on ext-4.2.1.883/packages/ext-theme-base/sass/utils.rb

require 'sass/script/functions'

module Extjs4Rails
  module SassExtensions
    module Functions
      module Utils
        @maps = Array.new()
        class << self; attr_accessor :maps; end

        def parsebox(list, n)
          assert_type n, :Number
          if !n.int?
            raise ArgumentError.new("List index #{n} must be an integer")
          elsif n.to_i < 1
            raise ArgumentError.new("List index #{n} must be greater than or equal to 1")
          elsif n.to_i > 4
            raise ArgumentError.new("A box string can't contain more then 4")
          end

          new_list = list.clone.to_a
          size = new_list.size

          if n.to_i >= size
            if size == 1
              new_list[1] = new_list[0]
              new_list[2] = new_list[0]
              new_list[3] = new_list[0]
            elsif size == 2
              new_list[2] = new_list[0]
              new_list[3] = new_list[1]
            elsif size == 3
              new_list[3] = new_list[1]
            end
          end

          new_list.to_a[n.to_i - 1]
        end

        def parseint(value)
          Sass::Script::Number.new(value.to_i)
        end

        def ERROR(message)
          raise ArgumentError.new(message)
        end

        def map_create()
          map = Hash.new()
          id = Utils.maps.length;
          Utils.maps.insert(id, map);
          Sass::Script::Number.new(id+1)
        end
        def map_get(mapId, key)
          id = mapId.to_i()-1
          map = Utils.maps[id]
          k = key.to_s()
          v = map[k]
          if !v
            v = Sass::Script::String.new("")
          end
          v
        end
        def map_put(mapId, key, value)
          id = mapId.to_i()-1
          map = Utils.maps[id]
          k = key.to_s()
          map[k] = value
        end

        # Joins 2 file paths using the path separator
        def file_join(path1, path2)
          path1 = path1.value
          path2 = path2.value.gsub(/^images\//, '')
          path = path1.empty? ? path2 : File.join(path1, path2)
          Sass::Script::String.new(path)
        end

        def theme_image_exists(directory, path)
          where_to_look = path.value.gsub(/^images\//, 'vendor/assets/images/extjs4-rails/')
          result = where_to_look && FileTest.exists?("#{where_to_look}")
          return Sass::Script::Bool.new(result)
        end
      end
    end
  end
end

module Sass::Script::Functions
  include Extjs4Rails::SassExtensions::Functions::Utils
end

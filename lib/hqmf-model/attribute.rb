module HQMF
  class Attribute
    include HQMF::Conversion::Utilities
    attr_reader :id,:code,:code_system,:value,:value_type,:value_code,:value_code_system,:value_name,:unit,:name

    # @param [String] id
    # @param [String] code
    # @param [String] code_system
    # @param [String] value
    # @param [String] value_type
    # @param [String] value_code
    # @param [String] value_code_system
    # @param [String] value_name
    # @param [String] unit
    # @param [String] name
    def initialize(id,code,code_system,value,value_type,value_code,value_code_system,value_name,unit,name)
      @id = id
      @code = code
      @code_system = code_system
      @value = value
      @value_type = value_type
      @value_code = value_code
      @value_code_system = value_code_system
      @value_name = value_name
      @unit = unit
      @name = name
    end

    def self.from_json(json)
      id = json["id"] if json["id"]
      code = json["code"] if json["code"]
      code_system = json["code_system"] if json["code_system"]
      code_system = json["text"] if json["text"]
      value = json["value"] if json["value"]
      value = json["value_type"] if json["value_type"]
      value = json["value_code"] if json["value_code"]
      value = json["value_code_sytem"] if json["value_code_system"]
      value = json["value_name"] if json["value_name"]
      unit = json["unit"] if json["unit"]
      name = json["name"] if json["name"]
    
      HQMF::Attribute.new(id,code,code_system,text,value,value_type,value_code,value_code_system,value_name,unit,name)
    end
  
    def to_json
      json = build_hash(self, [:id,:code,:code_system,:value,:value_type,:value_code,:value_code_system,:value_name,:unit,:name])
    end
  
  end
end

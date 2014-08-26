module HealthDataStandards
  module Util
    # General helpers for working with codes and code systems
    class HQMFTemplateHelper

      def self.definition_for_template_id(template_id, version="r1")
        template_id_map(version)[template_id]
      end

      def self.template_id_map(version)
        case version
        when "r1"
          if @id_map.blank?
            template_id_file = File.expand_path('../hqmf_template_oid_map.json', __FILE__)
            @id_map = JSON.parse(File.read(template_id_file))
          end
          @id_map
        when "r2"
          if @id_map.blank?
            template_id_file = File.expand_path('../hqmfr2_template_oid_map.json', __FILE__)
            @id_map = JSON.parse(File.read(template_id_file))
          end
          @id_map
        end
      end

      def self.template_id_by_definition_and_status(definition, status, negation=false, version="r1")
        case version
        when "r1"
          kv_pair = template_id_map(version).find {|k, v| v['definition'] == definition &&
                                                 v['status'] == status &&
                                                 v['negation'] == negation}
          if kv_pair
            kv_pair.first
          else
            nil
          end
        when "r2"
          kv_pair = template_id_map(version).find {|k, v| v['definition'] == definition &&
                                                 v['status'] == status}
          if kv_pair
            kv_pair.first
          else
            nil
          end
        end
      end
    end
  end
end

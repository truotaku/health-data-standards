module HQMF
  class Parser
    
    HQMF_VERSION_1 = "1.0"
    HQMF_VERSION_2 = "2.0"
    
    class V2Parser
      def initialize
      end

      def parse(xml_contents)
        HQMF::Counter.instance.reset()
        HQMF2::Document.new(xml_contents).to_model
      end

      def parse_fileds(xml_contents)
        result = {}
        doc = HQMF2::Document.parse(xml_contents)
        type = doc.at_xpath('/cda:QualityMeasureDocument/cda:code/@code').value
        if type == '57024-2'
          id = doc.at_xpath('cda:QualityMeasureDocument/cda:id/@extension', HQMF2::Document::NAMESPACES).value.upcase
          set_id = doc.at_xpath('cda:QualityMeasureDocument/cda:setId/@extension').value.upcase
          version_number = doc.at_xpath('cda:QualityMeasureDocument/cda:versionNumber/@value').value.to_i
          title = doc.at_xpath('cda:QualityMeasureDocument/cda:title/@value').inner_text
          description = doc.at_xpath('cda:QualityMeasureDocument/cda:text/@value').inner_text
          result=  {'id' => id, 'set_id' => set_id, 'version' => version_number, 'title' => title, 'description' => description}
        end
        result
      end

      def version
        HQMF_VERSION_2
      end

      def self.valid?(xml_contents)
        # <typeId root="2.16.840.1.113883.1.3" extension="POQM_HD000001UV02"/>
         doc = HQMF2::Document.parse(xml_contents)
        !doc.at_xpath("/cda:QualityMeasureDocument/cda:typeId[@root='2.16.840.1.113883.1.3' and @extension='POQM_HD000001UV02']").nil?
      end

    end


    class V1Parser

      def parse(xml_contents)
        HQMF::Counter.instance.reset()
        HQMF::DocumentConverter.convert(HQMF1::Document.new(xml_contents).to_json,nil)
      end

      def version
        HQMF_VERSION_2
      end

      def parse_fields(xml_contents)
         doc = HQMF2::Document.parse(xml_contents)
         type = doc.at_xpath('/cda:QualityMeasureDocument/cda:code/@code').value
        if type == '57024-2'
          id = doc.at_xpath('/cda:QualityMeasureDocument/cda:id/@root', HQMF2::Document::NAMESPACES).value.upcase
          set_id = doc.at_xpath('/cda:QualityMeasureDocument/cda:setId/@root').value.upcase
          version_number = doc.at_xpath('/cda:QualityMeasureDocument/cda:versionNumber/@value').value.to_i
          title = doc.at_xpath('/cda:QualityMeasureDocument/cda:title').inner_text
          description = doc.at_xpath('/cda:QualityMeasureDocument/cda:text').inner_text
          return  {'id' => id, 'set_id' => set_id, 'version' => version_number, 'title' => title, 'description' => description}
        end
      end

      def self.valid?(xml_contents)
        #QualityMeasureDocument.typeId.root = "2.16.840.1.113883.1.3" (which is the OID for HL7 Registered models); QualityMeasureDocument.typeId.extension = "POQM_HD000001"
        doc = HQMF2::Document.parse(xml_contents)
        !doc.at_xpath("/cda:QualityMeasureDocument/cda:typeId[@root='2.16.840.1.113883.1.3' and @extension='POQM_HD000001']").nil?
      end

    end


    def self.parse(hqmf_contents, version, codes = nil)
      
      HQMF::Counter.instance.reset()
      case version
        when HQMF_VERSION_1
          puts("\tCodes not passed in, cannot backfill properties like gender") unless codes
          HQMF::DocumentConverter.convert(HQMF1::Document.new(hqmf_contents).to_json, codes)
        when HQMF_VERSION_2
          HQMF2::Document.new(hqmf_contents).to_model
        else
          raise "Unsupported HQMF version specified: #{version}"
      end
    end
    
    def self.parse_fields(hqmf_contents, version)
      result = {}
      case version
        when HQMF_VERSION_1
          doc = HQMF1::Document.parse(hqmf_contents)
          type = doc.at_xpath('//cda:code/@code').value
          if type == '57024-2'
            id = doc.at_xpath('//cda:id/@root').value.upcase
            set_id = doc.at_xpath('//cda:setId/@root').value.upcase
            version_number = doc.at_xpath('//cda:versionNumber/@value').value.to_i
            title = doc.at_xpath('cda:QualityMeasureDocument/cda:title').inner_text
            description = doc.at_xpath('cda:QualityMeasureDocument/cda:text').inner_text
            result = {'id' => id, 'set_id' => set_id, 'version' => version_number, 'title' => title, 'description' => description}
          end
        when HQMF_VERSION_2
          doc = HQMF2::Document.parse(hqmf_contents)
          type = doc.at_xpath('cda:QualityMeasureDocument/cda:code/@code').value
          if type == '57024-2'
            id = doc.at_xpath('cda:QualityMeasureDocument/cda:id/@extension', HQMF2::Document::NAMESPACES).value.upcase
            set_id = doc.at_xpath('cda:QualityMeasureDocument/cda:setId/@extension').value.upcase
            version_number = doc.at_xpath('cda:QualityMeasureDocument/cda:versionNumber/@value').value.to_i
            title = doc.at_xpath('cda:QualityMeasureDocument/cda:title/@value').inner_text
            description = doc.at_xpath('cda:QualityMeasureDocument/cda:text/@value').inner_text
            result = {'id' => id, 'set_id' => set_id, 'version' => version_number, 'title' => title, 'description' => description}
          end
        else
          raise "Unsupported HQMF version specified: #{version}"
      end
      result
    end

  end
  
end
require 'fileutils'
require_relative '../../../test_helper'

class HQMFV1V2RoundtripTest < Test::Unit::TestCase
  RESULTS_DIR = 'tmp/hqmf_r2.1_roundtrip_diffs'

  # Create a blank folder for the errors
  FileUtils.rm_rf(RESULTS_DIR) if File.directory?(RESULTS_DIR)
  Dir.mkdir RESULTS_DIR

  # Automatically generate one test method per measure file
  measure_files = File.join('test', 'fixtures', '1.0', 'measures', 'e{p,h}_0033.xml')
  Dir.glob(measure_files).each do | measure_filename |
    measure_name = /.*[\/\\]((ep|eh)_.*)\.xml/.match(measure_filename)[1]
    define_method("test_#{measure_name}") do
      do_roundtrip_test(measure_filename, measure_name)
    end
  end

  def do_roundtrip_test(measure_filename, measure_name)
    # open the v1 file and generate a v2.1 xml string
    v1_model = HQMF::Parser.parse(File.open(measure_filename).read, '1.0')

    skip('Continuous Variable measures currently not supported') if v1_model.population_criteria('MSRPOPL')

    hqmf_xml = HQMF2::Generator::ModelProcessor.to_hqmf(v1_model)
    v2_model = HQMF::Parser.parse(hqmf_xml, '2.0')

    v1_json = JSON.parse(v1_model.to_json.to_json)
    v2_json = JSON.parse(v2_model.to_json.to_json)

    # remove measure period width
    v1_json['measure_period']['width'] = nil
    
    # remove embedded whitespace formatting in attribute values
    v1_json['attributes'].each do |attr|
      if attr['value']
        attr['value'].gsub!("\r\n", ' ')
      end
    end

    # drop the CMS ID since it does not go into the HQMF v2
    puts "\t CMS ID ingnored in hqmf v2"
    v1_json['cms_id'] = nil

    diff = v1_json.diff_hash(v2_json, true, true)

    unless diff.empty?
      outfile = File.join("#{RESULTS_DIR}","#{measure_name}_diff.json")
      File.open(outfile, 'w') {|f| f.write(JSON.pretty_generate(JSON.parse(diff.to_json))) }
      outfile = File.join("#{RESULTS_DIR}","#{measure_name}_r1.json")
      File.open(outfile, 'w') {|f| f.write(JSON.pretty_generate(v1_json)) }
      outfile = File.join("#{RESULTS_DIR}","#{measure_name}_r2.json")
      File.open(outfile, 'w') {|f| f.write(JSON.pretty_generate(v2_json)) }
    end

    assert diff.empty?, 'Differences in model after roundtrip to HQMF V2'
  end
end
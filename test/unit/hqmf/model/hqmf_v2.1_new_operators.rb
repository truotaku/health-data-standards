require 'fileutils'
require_relative '../../../test_helper'

class HQMFV1V2RoundtripTest < Test::Unit::TestCase
  RESULTS_DIR = 'tmp/hqmf_r2.1_new_operators'

  # Create a blank folder for the errors
  FileUtils.rm_rf(RESULTS_DIR) if File.directory?(RESULTS_DIR)
  Dir.mkdir RESULTS_DIR

  # Automatically generate one test method per measure file
  measure_files = File.join('test', 'fixtures', '2.1', 'measures', '*.xml')
  Dir.glob(measure_files).each do | measure_file |
    measure_name = /.*[\/\\]((ep|eh)_.*)\.xml/.match(measure_file)[1]
    measure_updated_file = measure_file.gsub(/\/measures\//, '/measures_updated/')
    define_method("test_#{measure_name}") do
      do_model_test(measure_file, measure_updated_file, measure_name)
    end
  end

  def do_model_test(measure_file, measure_updated_file, measure_name)
    puts ">> #{measure_name}"
    
    begin 
      v2_model = HQMF::Parser.parse(File.open(measure_file).read, '2.0')
      v2_updated_model = HQMF::Parser.parse(File.open(measure_updated_file).read, '2.0')
    
      v2_json = JSON.parse(v2_model.to_json.to_json)
      v2_updated_json = JSON.parse(v2_updated_model.to_json.to_json)

      diff = v2_json.diff_hash(v2_updated_json, true, true)

      unless diff.empty?
        outfile = File.join("#{RESULTS_DIR}","#{measure_name}_diff.json")
        File.open(outfile, 'w') {|f| f.write(JSON.pretty_generate(JSON.parse(diff.to_json))) }
        outfile = File.join("#{RESULTS_DIR}","#{measure_name}_r2.json")
        File.open(outfile, 'w') {|f| f.write(JSON.pretty_generate(v2_json)) }
        outfile = File.join("#{RESULTS_DIR}","#{measure_name}_r2_updated.json")
        File.open(outfile, 'w') {|f| f.write(JSON.pretty_generate(v2_updated_json)) }
      end

      assert diff.empty?, 'Differences in model after roundtrip to HQMF V2'
    rescue
      raise $!
    end
  end

end

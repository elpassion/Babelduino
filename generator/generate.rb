#!/usr/bin/env ruby

require 'optparse'
require 'yaml'

ARGV << '-h' if ARGV.empty?

options  = {
  mapping:  File.join(__dir__, 'mapping.yml'),
  keywords: '',
  output:   File.basename(Dir.getwd)
}

optparse = ARGV.options do |opts|
  opts.banner = "Usage: #{opts.program_name} [options]"

  opts.on('-k', '--keywords=keywords.txt', 'Original Arduino keywords.txt file.', 
    'Can be found inside Java/lib Arduino app directory/package.') do |keywords|
    options[:keywords] = keywords
  end

  opts.on('-m', '--mapping=file.yml', 
    'YAML file with a map where keys are original keywords and values are translations.') do |mapping|
    options[:mapping] = mapping
  end

  opts.on('-o', '--output=header', "Name for the output header file (without '.h' suffix).") do |output|
    options[:output] = output
  end

  opts.on_tail('-h', '--help', 'Show this message') do
    puts opts
    exit
  end
end

begin
  optparse.parse!
rescue OptionParser::InvalidOption, OptionParser::MissingArgument => error
  puts error
  puts optparse
  exit 2
end

if File.exist?(File.expand_path(options[:mapping]))
  mapping_file = File.new(File.expand_path(options[:mapping]))
else
  puts 'Mapping file does not exist.'
  exit 2
end

if File.exist?(File.expand_path(options[:keywords]))
  keywords_file = File.new(File.expand_path(options[:keywords]))
else
  puts 'Keywords file does not exist.'
  exit 2
end

def fetch_keywords(keywords_file)
  keywords = {}
  
  File.foreach(keywords_file) do |line|
    keyword, options = line.split(nil, 2)
  
    keywords[keyword.gsub(/^\\#/, '#')] = options unless keyword.nil? || keyword.length == 0 || keyword.start_with?('#')
  end
  
  keywords
end

begin
  original_keywords = fetch_keywords(keywords_file)
  mapping           = YAML.load_file(mapping_file)
  keywords_output   = File.open('keywords.txt', 'w')
  header_output     = File.open("#{options[:output]}.h", 'w')
  
  guard = options[:output].gsub(/\W/, '_').upcase + '_H'
  header_output.puts "#ifndef #{guard}\n#define #{guard}\n\n"
  
  mapping.each do |keyword, translations|
    [translations].flatten.each do |translation|
      next if translation.nil? || translation.length == 0
      
      header_output.puts "#define #{translation} #{keyword}"
      keywords_output.puts "#{translation}\t#{original_keywords[keyword] || 'LITERAL1'}"
    end
  end
  
  header_output.puts "\n#endif /* #{guard} */"
ensure
  keywords_output.close if keywords_output
  header_output.close if header_output
end
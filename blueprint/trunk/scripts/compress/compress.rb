#!/usr/bin/env ruby

# 
# Blueprint CSS Compressor
# Copyright (c) Olav Bjorkoy 2007. 
# See docs/License.txt for more info.
# 
# This script creates up-to-date compressed files from
# the 'blueprint/source' directory. Each source file belongs 
# to a certain compressed file, as defined below. 
# 
# The newly compressed files are placed in the
# 'blueprint' directory.
# 
# Ruby has to be installed for this script to work.
# You can then run the following command: 
# $ ruby compress.rb
# 

# compressed file names and related sources, in order
files = {
  'screen.css'  => ['reset.css', 'typography.css', 'grid.css', 'forms.css'],
  'print.css'   => ['print.css'],
  'ie.css'      => ['ie.css']
}

# WARNING: Experimental feature
# To namespace each Blueprint class, pass an argument to the script.
# Example: $ ruby compress.rb bp- => .container becomes .bp-container
namespace = ARGV[0] ||= ''

# directories
destination = '../../blueprint/'
source = destination + 'src/'

# test files
test_directory = '../../tests/'
test_files = ['index.html', 'parts/elements.html', 'parts/forms.html', 'parts/grid.html', 'parts/sample.html']

# -------------------------------------------------------- #

require 'lib/file.rb'
require 'lib/parsecss.rb'
require 'lib/namespace.rb'

# compressed file header
header = File.new('lib/header.txt').read

puts "** Blueprint CSS Compressor"
puts "** Builds compressed files from the source directory."
puts "** Namespace: #{namespace}" if namespace != ''

# start parsing and compressing
files.each do |name, sources|
  puts "\nAssembling #{name}:"
  css = header
  
  # parse and compress each source file in this group
  sources.each do |file|
    puts "+ src/#{file}"
    css += "/* #{file} */\n" if sources.length > 1
    css += ParseCSS.new(source + file, namespace).to_s
    css += "\n"
  end
  css.rstrip! # remove unnecessary linebreaks
  
  # write compressed css to destination file
  File.string_to_file(destination + name, css)
end

puts "\nUpdating namespace to \"#{namespace}\" in test files:"
for file in test_files
  puts "+ #{file}"
  Namespace.new(test_directory + file, namespace)
end

puts "\n** Done!"
puts "** Your compressed files and test files are now up-to-date."
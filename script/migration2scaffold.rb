#!/usr/bin/env ruby

COLUMN_INFO_REGEXP = /^\s+t\.(\S+) +(\S+) *$/

file_path =  ARGV[0]

contents = File.open(file_path) { |f| f.read }
# puts contents.inspect

table_name = contents.match(/create_table\s+(\S+)/)[1]

model_name = eval(table_name).to_s.classify

column_pairs = contents.scan COLUMN_INFO_REGEXP
# puts column_pairs.inspect
column_pairs_command_line = column_pairs.map do |t, n|
  #   puts n.inspect
  n = eval(n).to_s
#   if m = n.match(/(.+)_id$/)
#     n = m[1]
#     t = "references"
#   end
  "#{n}:#{t}"
end.join(" ")

cmd = "script/generate scaffold --skip-migration #{model_name} #{column_pairs_command_line}"

puts "\n Running command: #{cmd}\n\n"

system cmd

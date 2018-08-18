#!/usr/bin/env ruby
def is_writtable(line)
	if (line.start_with?("#pragma once") || line.start_with?("#include \"")) || line.start_with?("#include\t\"") then
		return false
	end
	return true
end

def handle_header_file(filename, output)
	header_file = File.open(filename)
	
	header_file.each_line do |line|
		if is_writtable(line) then
			output.write(line)
		end
	end
end

# well i think i should use an enum instead, it would be cleaner
arg_type = "INPUT_FILE"
output_filename = "lib.hpp"
headers = []

ARGV.each do|a|
	if a == "-f" || a == "--file" then
		arg_type = "INPUT_FILE_LIST"
	elsif a == "-o" || a == "--output" then
		arg_type = "OUTPUT_FILE"
	elsif arg_type == "INPUT_FILE" then
		headers.push(a)
	elsif arg_type == "INPUT_FILE_LIST" then
		flist = File.open(a)
		flist.each_line do |l|
			l = l.chomp
			if !l.empty? then
				headers.push(l)
			end
		end
		arg_type = "INPUT_FILE"
	elsif arg_type == "OUTPUT_FILE" then
		output_filename = a
		arg_type = "INPUT_FILE"
	end
end

output = File.new(output_filename, File::CREAT | File::RDWR)
output.write("#pragma once")

headers.each do |line|
	line = line.chomp
	if !line.empty? then 
		handle_header_file(line, output)
	end
end
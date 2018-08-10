#!/usr/bin/env ruby

# takes headers, add recursively all the headers included without adding twice the same then add the headers

def is_writtable(line)
	return !(line.start_with?("#pragma once"))
end

def is_local_include(line)
	return line.start_with?("#include \"") ||  line.start_with?("#include\t\"")
end

#corriger ce truc omg
def extract_local_include_name(line)
	i = 0;
	dest = "plop.hpp"

	return dest
end

#corriger ce truc omg
def extract_path(filepath)
	p = "tests_assets/"
	return p
end

#faudra ajouter une sécurité pour pas include 36 fois le même fichier
# en gérant le fait que le débile peut utiliser les defines à la place des pragma
def handle_header_file(filename, output, path)
	header_file = File.open(filename)
	
	header_file.each_line { |line|
		if (is_local_include(line)) then
			handle_header_file(path + extract_local_include_name(line), output, extract_path(line))
		elsif is_writtable(line) then
			output.write(line)
		end
	
	}
end

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
		flist.each_line {|l|
			l = l.chomp
			if !l.empty? then
				headers.push(l)
			end
		}
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
		handle_header_file(line, output, extract_path(line))
	end
end
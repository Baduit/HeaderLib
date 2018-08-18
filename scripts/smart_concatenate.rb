#!/usr/bin/env ruby

# takes headers, add recursively all the headers included without adding twice the same then add the headers

require 'pathname'

def is_writtable(line)
	return !(line.start_with?("#pragma once"))
end

def is_local_include(line)
	return line.start_with?("#include \"") ||  line.start_with?("#include\t\"")
end

def get_path(line)
	isInPath = false
	tmpPath = ""
	line.split("").each do |c|
		if c == "\"" then
			if isInPath == false then
				isInPath = true
			else
				return Pathname.new(tmpPath)
			end
		elsif isInPath then
			tmpPath += c
		end
	end
end

# faudra ajouter une sécurité pour pas include 36 fois le même fichier
def handle_header_file(filename, output, headers_writed)
	header_file = File.open(filename)
	headers_writed.push(Pathname.new(filename).basename)
	
	header_file.each_line do |line|
		if (is_local_include(line)) then
			p = get_path(line)
			if !headers_writed.include?(p.basename) then
				handle_header_file("./" + File::dirname(header_file.path) + "/" + p.to_s, output, headers_writed)
			end
		elsif is_writtable(line) then
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
		headers.push(Pathname.new(a))
	elsif arg_type == "INPUT_FILE_LIST" then
		flist = File.open(a)
		flist.each_line do |l|
			l = l.chomp
			if !l.empty? then
				headers.push(Pathname.new(l))
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

headers_w = []

headers.each do |line|
	handle_header_file(line, output, headers_w)
end
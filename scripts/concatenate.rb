def is_writtable(line)
	if (line.start_with?("#pragma once") || line.start_with?("#include \"")) then
		return false
	end
	return true
end

def handle_header_file(filename, output)
	header_file = File.open(filename)
	
	header_file.each_line { |line|
		if is_writtable(line) then
			output.write(line)
		end
	
	}
end

# à faire: gestion des arguments
# -f ou --file => fichier à charger pour l'input
# -o ou --outout => ficher destination
# le reste, nom des fichiers à charger
output = File.new("./unique_header/ScriptCaller.hpp", File::CREAT | File::RDWR)
output.write("#pragma once")

f = File.open("./file_list.txt")
f.each_line {|line|
	line = line.chomp
	if !line.empty? then 
		handle_header_file(line, output)
	end
}
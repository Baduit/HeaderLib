# HeaderLib
Tools to create and share easily a c/c++ header only library.

There is 2 scripts:
* concatenate.rb: you have to specify every files you want to concatenate.
* smart_concatenate.rb: you just have to specify one header and it will concatenate all the local header dependecies.


## How to use it?
In order to choose the name of the output file use -o or --ouput followed by the name you want to use. If you want to use a text file with the name of all the headers (separated with a new line) you want to concatenate use -f or --file followed by the name of the file. All other arguments are the name of the headers you want to concatenate.

Examples:
* ./scripts/concatenate.rb --file file_list.txt -o lib.hpp
* ./scripts/smart_concatenate.rb -o lib2.hpp yolol.hpp

Be carefull, the order of the headers can be important if there are depedencies. The scripts does not change the order, so if __a.hpp__ need something declared in __b.hpp__ you need to put __b.hpp__ before __a.hpp__ in the arguments. (or you can use smart_concatenate.rb which will include __b.hpp__ automatically if you give it __a.hpp__)

## How does it work?
### concatenate.rb
It just read the headers given in argument, remove the lines with __#pragma once__ and the local includes (example __#include "example.hpp"__).

### smart_concatenate.rb
It just read the headers given in argument, remove the lines with __#pragma once__ but instead of removing the line with the local includes, it reads and add the local includes. There is also a security to not use twice the same header.

## The tests
If you are on unix go to the directory __tests__ and execute the scrit __test.sh__.
Else if you want to run the tests you have to do it manually, use the script to concatenate the headers in __tests_assets__, move the output file into the directory __unique_header__ and then try to compile __test_concatenate.cpp__ and __test_smart_concatenate.cpp__

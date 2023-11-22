#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <string_view>

int main(int argc, char** argv){

    if (argc >= 2) {
        std::string cmd{};

        std::string vcdFilename;
        for (int i{ 1 }; i < argc; i++) {
            cmd += " " + std::string{ argv[i] };

            std::ifstream inFile(argv[i]);
            //read whole file
            std::stringstream buffer{};
            buffer << inFile.rdbuf();
            std::string_view file{ buffer.str() };

            std::size_t pos{ file.find("$dumpfile(\"")};
            if (pos != std::string_view::npos) {
                pos += 11;  //skip $dumpfile("
                file.remove_prefix(pos);

                vcdFilename = file.substr(0,file.find("."));
            }
            
        }
        system(("iverilog -o " + vcdFilename + ".vvp" + cmd).c_str());
        system(("vvp " + vcdFilename + ".vvp").c_str());
        if(vcdFilename != "")
            system(("gtkwave " + vcdFilename + ".vcd").c_str());
    }
    else {
        std::cout << "please drag all needed file into this program.\n";
    }
    system("pause");

    return 0;
}
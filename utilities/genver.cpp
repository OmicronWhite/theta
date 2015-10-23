#include <string>
#include <iostream>
#include <stdio.h>
#include <cstdio>
#include <fstream>
#ifndef _MSC_VER
#include <cstdlib>
#endif
#include <sstream>
#include <vector>

#ifndef __cplusplus
# error "Please use C++ to compile this tool."
#endif

enum
{
	LANG_UNKNOWN = -1,
	LANG_CLIKE,
	LANG_BATCH,
	LANG_BASH,
	LANG_ACS
};

using std::string;
using std::ofstream;
using std::vector;
using std::stringstream;
using std::istringstream;
using std::ifstream;

vector<string> split(const string &s, char delim)
{
	vector<string> elems;
	stringstream ss(s);
	string item;
	while (std::getline(ss, item, delim))
	{
		elems.push_back(item);
	}
	return elems;
}

int main (int argc, char *argv[])
{
    int language = -1;
    string comment = "";
	bool silent = false;

	if (argc == 4 + 1)
	{
		string thirdArg = string(argv[4]);

		silent = (thirdArg == "-s" || thirdArg == "--silent");
	}

	if (!silent) printf("Theta genver tool, by Sean\n");

    if (argc != 3 + 1 && !silent)
    {
        printf("Expected two arguments.\n");
        printf("Syntax: genver <input file> <language: c | batch> <output file> [--silent]\n");
		printf("Got %d arguments instead.\n", argc);
		for (int i = 0; i < argc; i++)
		{
			printf("Argument %d: %s\n", i, argv[i]);
		}
        return 1;
    }

	if (string(argv[2]) == "c")
	{
		language = LANG_CLIKE;
		comment = "//";
	}
	else if (string(argv[2]) == "batch")
	{
		language = LANG_BATCH;
		comment = "::";
	}
	else if (string(argv[2]) == "bash")
	{
		language = LANG_BASH;
		comment = "#";
	}
	else if (string(argv[2]) == "acs")
	{
		language = LANG_ACS;
		comment = "//";
	}
    else
    {
        language = LANG_UNKNOWN;
        printf("Unknown language '%s'.\n", argv[1]);
        printf("Please note that the language parameter is case sensitive.\n");
		return 2;
    }

	string line, major, minor, patch, codename;
	bool done = false;
	ifstream infile;
#if _MSC_VER
	infile.open(string(argv[1]));
#else
	infile.open(argv[1]);
#endif
	if (infile.is_open())
	{
		while (getline(infile, line))
		{
			if (done)
				continue;

			if (line.substr(0, 1) == string("//"))
				continue;

			if (line.find(string("=")) == string::npos)
				continue;

			vector<string> kv = split(line, '=');
			if (kv.size() == 0)
				continue; // This line is useless.

			string key = kv[0];
			string value = kv[1];


			if (key == "version")
			{
				vector<string> spl = split(value, '.');

				if (spl.size() != 3)
					continue;

				major = spl.at(0);
				minor = spl.at(1);
				patch = spl.at(2);
			}

			else if (key == "codename")
			{
				codename = value;
			}

			else
			{
				printf("Unknown key '%s'!\n", key.c_str());
				exit(1);
				break;
			}

		}

		infile.close();
	}

	ofstream fstr;
	if (!silent) printf("Opening file.\n");
#ifdef _MSC_VER
	fstr.open(string(argv[3]));
#else
	fstr.open(argv[3]);
#endif
	if (!silent) printf("Writing disclaimer.\n");
	fstr << comment << " This file was generated by genver.\n";
	fstr << comment << " Please don't modify this file.\n";
	fstr << "\n";

	if (!silent) printf("Writing version information.\n");
	if (language == LANG_CLIKE)
    {
        fstr << "#define VERSION_MAJOR " << major << "\n";
        fstr << "#define VERSION_MINOR " << minor << "\n";
        fstr << "#define VERSION_PATCH " << patch << "\n";
        fstr << "#define VERSION_STRING \"" << major << "." << minor << "." << patch << "\"\n";
        fstr << "#define VERSION_CODENAME \"" << codename << "\"\n";
    }
	else if (language == LANG_BATCH)
    {
        fstr << "SET VERSION_MAJOR=" << major << "\n";
        fstr << "SET VERSION_MINOR=" << minor << "\n";
        fstr << "SET VERSION_PATCH=" << patch << "\n";
        fstr << "SET VERSION_STRING=\"" << major << "." << minor << "." << patch << "\"\n";
        fstr << "SET VERSION_CODENAME=\"" << codename << "\"\n";
    }
	else if (language == LANG_BASH)
    {
        fstr << "export VERSION_MAJOR=" << major << "\n";
        fstr << "export VERSION_MINOR=" << minor << "\n";
        fstr << "export VERSION_PATCH=" << patch << "\n";
        fstr << "export VERSION_STRING=" << major << "." << minor << "." << patch << "\n";
        fstr << "export VERSION_CODENAME=\"" << codename << "\"\n";
    }
	else if (language == LANG_ACS)
	{
        fstr << "#define VERSION_MAJOR " << major << "\n";
        fstr << "#define VERSION_MINOR " << minor << "\n";
        fstr << "#define VERSION_PATCH " << patch << "\n";
        fstr << "str VERSION_STRING = \"" << major << "." << minor << "." << patch << "\";\n";
        fstr << "str VERSION_CODENAME = \"" << codename << "\";\n";
	}

	if (!silent) printf("Closing file.\n");
	fstr.close();
	return 0;
}

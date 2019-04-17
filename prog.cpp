#include <fstream>
#include <iostream>
#include <cstdlib>
#include <string>
using namespace std;

int main()
{
string outfile_name = "mem_bin.txt";
string infile_name;
cout<< "Enter input file name: ";
getline(cin, infile_name);
cout<< "\nEnter output file name: ";
getline(cin,outfile_name);

ofstream outfile(outfile_name);
ifstream infile(infile_name);
if(!outfile)
{
	cout<< outfile_name << " could not be opened for writing.\n";
	exit(1);
}
if(!infile)
{
	cout<<infile_name<<" could not be opened for reading.\n";
	exit(2);
}
int j(0);
int i(0);
while(infile)
{
	
	string inputproc;
	getline(infile, inputproc);
	for(i=0; i<inputproc.size(); i+=8)
	{
		outfile << "mem["<<j<<"]<=8'b"<<inputproc.substr((inputproc.size()-i-8),8)<<";\n";
		j+=1;
	}
}
}

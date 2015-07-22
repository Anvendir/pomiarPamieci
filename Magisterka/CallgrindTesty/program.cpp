#include <iostream>
#include <string>

//#include <callgrind.h>

using std::string;


class Index
{

public:
	Index()
	{
		numer = 0000000000;
		imie = "Brak imienia";
		nazwisko = "Brak nazwiska";
	}

private:
	long long int numer;
	string nazwisko;
	string imie;
//	static  const char opis[] = "Taki tam hujowy opis";
	
};

void funkcja1(void);
void funkcja2(void);
void funkcja3(void);

//CALLGRIND_ZERO_STATS;

int main()
{
	std::cout << "Witam w programie testowym" << std::endl;

	funkcja1();
	
	return 0;
}

void funkcja1(void)
{
	funkcja2();
}

void funkcja2(void)
{
	funkcja3();
}

void funkcja3()
{
	Index tablica[15000];
}
#include <iostream>

using std::cin;
using std::endl;
using std::cout;


int Factorial(int p_liczba);
void funA()
{
	long * tab = new long[600];

	int static a = 0;
	a++;
	
	cout << "wewnatrz funkcji po allokacji" << a << endl;

	delete [] tab;

	//cout << "Rozmiar long: " << sizeof(long) << endl;
}

int main()
{
	cout << "Hello world" << endl;

	int a;	

	long * nowy = new long[500];

	cout << "Rozmiar long: " << sizeof(long) << endl;
	for (int i=0; i<100; i++)
		a+=5;
	

	delete [] nowy;

	for (int i=0; i<100; i++)
                a+=5;

	long * xc = new long[1000];

	for(int i =0; i < 8; i++)	
		funA();
	
	int liczba=5;
//	cout << "Podaj liczbe calkowita" << endl;
//	cin >> liczba;

	cout << "Silnia " << liczba 
		 << " wynosi " << Factorial(liczba)
		 << endl;

	delete [] xc;

	cout << "Koniec programu" << endl;

//	cin >> liczba;

	return 0;
}

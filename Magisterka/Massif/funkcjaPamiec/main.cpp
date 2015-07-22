#include <iostream>

using namespace std;

void fun1();
void fun2();
void fun3();

int main()
{
	cout << "Rozmiar typu long to: " << sizeof(long) << endl;	

	long * first = new long[10];

	for(int i = 0; i < 3; i++)
		fun1();

	delete [] first;

	fun3();

	long * last = new long[15];

	delete [] last;	

	return 0;
}


void fun1()
{
	long * second = new long[5];

	fun2();

	long * x = new long[2];
	delete [] x;
	
	delete [] second;	
}

void fun2()
{
	for(int i = 0; i < 2; i++)
	{
		long * third = new long[2];
		fun3();
		delete [] third;
	}
}

void fun3()
{
	long * fourth = new long[10];
	delete [] fourth;
}

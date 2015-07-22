int Factorial(int p_liczba)
{
	int l_silnia = p_liczba;

        if (p_liczba == 5)
                l_silnia = 0;

	while (p_liczba > 1)
	{
		p_liczba--;
		l_silnia *= p_liczba;
	}
	
	return l_silnia;
}

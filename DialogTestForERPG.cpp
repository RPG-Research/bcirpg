// DialogTestForERPG.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <string>

int main()
{
	int num = 0;

	std::string SentanceFirst{"Welcome to a world ravaged by "};
	std::string SentanceSecond{ "You step out of the " };
	std::string SentanceThird{ ", to a new place unlike any other." };

	std::string firstWords[] = { "A Greedy King", "Heavy Taxation", "A galaxy wide fuel crisis" };
	std::string secondWords[] = { "Horse and Buggy", "Car", "Landspeeder" };

	std::cout << "Hello, Welcome to our game\nWhich setting do you want to play in?\n1: Fantasy\n2: Modern Day\n3: Sci-Fi\n" << std::endl;
	
	std::cin >> num;

	while (num > 3 || num < 0) 
	{
		std::cout << "Please enter a valid number" << std::endl;
	}

	if (num == 1) 
	{
		std::cout << SentanceFirst + firstWords[0] + ".\n" + SentanceSecond + secondWords[0] + SentanceThird;
	}

	if (num == 2)
	{
		std::cout << SentanceFirst + firstWords[1] + ".\n" + SentanceSecond + secondWords[1] + SentanceThird;
	}

	if (num == 3)
	{
		std::cout << SentanceFirst + firstWords[2] + ".\n" + SentanceSecond + secondWords[2] + SentanceThird;
	}

	std::cin >> num;
	
}

// Run program: Ctrl + F5 or Debug > Start Without Debugging menu
// Debug program: F5 or Debug > Start Debugging menu

// Tips for Getting Started: 
//   1. Use the Solution Explorer window to add/manage files
//   2. Use the Team Explorer window to connect to source control
//   3. Use the Output window to see build output and other messages
//   4. Use the Error List window to view errors
//   5. Go to Project > Add New Item to create new code files, or Project > Add Existing Item to add existing code files to the project
//   6. In the future, to open this project again, go to File > Open > Project and select the .sln file

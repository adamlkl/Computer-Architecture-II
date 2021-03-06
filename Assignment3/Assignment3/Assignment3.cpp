// Assignment3.cpp : This file contains the 'main' function. Program execution begins and ends there.
//
#include "pch.h"
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

//rw as register window
int Pcalls, rwdepth, maxdepth, cwp, rwoverflow, rwunderflow, filledRegister;
int registerSet;
int x = 3, y = 6;

void over();
void under();
int ackermann(int x, int y);

int main()
{
	double totaltime = 0.0;
	std::cout << "Enter number of Register Sets: 6, 8, 16\n";
	std::cin >> registerSet;
	std::cout << "Register Sets: " << registerSet << "\n";
	std::cout << "Computing Ackermann with x = " << x << " and y = " << y << "\n";
	for (int i = 0; i < 1000; i++) {
		Pcalls = 0;
		rwdepth = 0;
		maxdepth = 0;
		cwp = 0;
		rwoverflow = 0;
		rwunderflow = 0;
		filledRegister = 2;
		clock_t begin = clock();
		int ack = ackermann(x, y);
		clock_t end = clock();
		totaltime += (double)(end - begin) / CLOCKS_PER_SEC;
	}
	totaltime /= 1000;
	std::cout << "Procedural Calls: " << Pcalls << "\n";
	std::cout << "Max Depth: " << maxdepth << "\n";
	std::cout << "Register Window Overflows: " << rwoverflow << "\n";
	std::cout << "Register Window Underflows: " << rwunderflow << "\n";
	std::cout << "Average Time Taken: " << totaltime << "\n";
}

int ackermann(int x, int y) {
	Pcalls++;
	rwdepth++;
	over();
	int result = 0;
	if (x == 0) {
		rwdepth--;
		under();
		return y + 1;
	}
	else if (y == 0) {
		result = ackermann(x - 1, 1);
		rwdepth--;
		under();
		return result;
	}
	else {
		result = ackermann(x - 1, ackermann(x, y - 1));
		rwdepth--;
		under();
		return result;
	}
}

void over() {
	if (rwdepth > maxdepth) {
		maxdepth = rwdepth;
	}

	if (filledRegister < registerSet) {
		filledRegister++;
	}

	else {
		rwoverflow++;
	}
}

void under() {
	if (filledRegister > 2) {
		filledRegister--;
	}
	else {
		rwunderflow++;
	}
}
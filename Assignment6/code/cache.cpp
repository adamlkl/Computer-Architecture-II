#include <stdio.h>
#include <stdlib.h>
using namespace std;
#include <bits/stdc++.h>

const int s[] = {0x0000, 0x0004, 0x000c, 0x2200, 0x00d0, 0x00e0, 0x1130, 0x0028, 0x113c, 0x2204, 0x0010, 0x0020, 0x0004, 0x0040, 0x2208, 0x0008, 0x00a0, 0x0004, 0x1104, 0x0028, 0x000c, 0x0084, 0x000c, 0x3390, 0x00b0, 0x1100, 0x0028, 0x0064, 0x0070, 0x00d0, 0x0008, 0x3394}; 
int hit=0;
int miss=0;

class Cache{
		int K;
		int N;
		int L = 16;

		// store keys of set numbers of cache with their associated list
    	list<int> tag[8]; 
  
		// store references of key in cache 
		unordered_map<int,unordered_map<int, list<int>::iterator>> cacheMap; 

public:
	Cache(int,int);
	bool refer(int,int);
	int getK();
	int getN();
};

Cache::Cache(int n, int m)
{
	K = n;
	N = m;
}

int Cache:: getK(){
	return K;
}

int Cache:: getN(){
	return N;
}

bool Cache:: refer(int x, int y){
	// not present in cache 
	bool found;
    if  (cacheMap[y].find(x) == cacheMap[y].end()) 
    { 
        // cache is full 
        if (tag[y].size() == K) 
        { 
            //delete least recently used element 
            int last = tag[y].back(); 
            tag[y].pop_back(); 
            cacheMap[y].erase(last); 
        } 
		found = false;
    } 
  
    // present in cache 
    else{
        tag[y].erase(cacheMap[y][x]); 
		found = true;
  	}

    // update reference 
    tag[y].push_front(x); 
    cacheMap[y][x] = tag[y].begin(); 
	return found;
}


int computeSetNumber(int address, int set){
	int setNumber = (address%256)/16;
	if (setNumber >= set)return setNumber%set;
	else return setNumber; 
}

int main(){
    Cache cch(2,4);
	int access;
	int N = cch.getN();
	int size = *(&s + 1) - s; 
	std::cout << "For a cache with L= 16, N= " << cch.getN() << ", K= " << cch.getK() << "\nResult: \n";
    for(int i = 0; i<size; i++){
		access = computeSetNumber(s[i],N);
		std::cout << "0x" << std::hex << s[i];
		if(cch.refer(s[i]/16,access)){
			hit++;
			std::cout << " hit\n";
		}
		else{
			miss++;
			std::cout << " miss\n";
		}
    }	
	std::cout <<"Hit: " << std::dec << hit << "\nMiss: " << miss << "\n";
}

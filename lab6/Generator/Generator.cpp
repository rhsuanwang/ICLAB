#include <iostream>
#include <cstdlib> /* 亂數相關函數 */
#include <ctime> 
#include <fstream>
#include<math.h>
using namespace std;

int main(){
  fstream input;
  fstream process;
  fstream output;
  input.open("input.txt",ios::out);
  process.open("process.txt",ios::out);
  output.open("output.txt",ios::out);
  srand( time(NULL) );

  /* 指定亂數範圍 */
  int min = 0;
  int max = 1;
  int i;
  int j;
  int n;
  int a;
  int b;
  int c;
  int d;
  int e;
  int f;
  int g;
  int h;
  int l;
  int m;
  int u;
  int v;
  int number[512];
  int answer;
  int add1[48][8];
  int add2[16][8];
  int sum11[48]={0};
  int sum22[16]={0};
  int sum1;
  int sum2;
  int bin1[8]={0};
  int bin2[8]={0};
  int r;
  int s;
  
  if(input.fail() || process.fail() || output.fail())
    {
        cout << "檔案I/O失敗" << endl;
        return 1;
    }
  else
  {
  input << 1000 << "\n";
  input << " " << "\n";
  for(j=0;j<1000; j++)
  {
   	process<<j<<endl;
    for(n=0;n<512; n++)
    {
         number[n] = rand() %2;
         printf("%d", number[n]);
         input << number[n];
         process << number[n];
        }
        //input << number<< '\n';
        printf("\n");
		input << endl;
		process << endl;
        //printf("number=%d", number[1]);
  /* 產生 [min , max] 的整數亂數 */
    
   
    //fout.put(answer);
    
    sum1=0;
    b=0;
    for(a=0;a<384; a++) 
    {
        add1[b][a%8] = number[a];
        if(number[a]==1)
        	sum1 = sum1 + pow(2,7-a%8);
        else
        	sum1 = sum1;
        printf("add1[%d][%d]=%d ",b,7-a%8, number[a]);
        process << "add1[" << b <<"]" << "["<<7-a%8<<"]="<<number[a]<<" ";
        if(a%8==7)
        {
          
          	//sum11[b]=sum1;
    		//sum1=0;
    		sum11[b] = sum1 % 256 + sum1 / 256;
    		while(sum11[b]>255)
			{
				sum11[b] = sum11[b] % 256 + sum11[b] / 256;
			}
    		printf("sum1=%d sum11[%d]=%d",sum1,b,sum11[b]);
    		process << "sum1=" << sum1 <<" sum11[" <<b<<"]="<<sum11[b]<<endl;
    		b=b+1;
          	printf ("\n");
          
   		}
    }
    u=0;
    for(int u=0;u<8;u++)
    {
    	bin1[u] = 0;
	}
    e=0;
    while(sum11[47]!=0)
	{
  		r = sum11[47]%2;
  		bin1[e++] = r;
  		sum11[47] /= 2;
	}

	for(int f=e-1;f>=0;f--)
	{
 		printf("bin1[%d]=%d ",f,bin1[f]);
 		process<<"bin1["<<f<<"]="<<bin1[f]<<" ";
  	}
  	printf ("\n");
  	process << endl;
  	
  	for(int l=7;l>=0;l--)
  	{
  		if(bin1[l] == 0)
  		{
  			output << "1";
		  }
		else
  		{
  			output << "0";
		  }
	}
  	
    sum2=0;
    d=0;
    for(c=0;c<128; c++) 
    {
        add2[d][c%8] = number[c+384];
        if(number[c+384]==1)
        	sum2 = sum2 + pow(2,7-c%8);
        else
        	sum2 = sum2;
        printf("add2[%d][%d]=%d ",d,7-c%8, number[c+384]);
        process << "add2["<<d<<"]["<<7-c%8<<"]="<<number[c+384]<<" ";
         
        if(c%8==7)
        {
          
        	//sum22[d]=sum2;
        	//printf("sum22[%d]=%d",d,sum22);
        	//sum2=0;
        	sum22[d] = sum2 % 256 + sum2 / 256;
        	while(sum22[d]>255)
			{
				sum22[d] = sum22[d] % 256 + sum22[d] / 256;
			}
        	printf("sum2=%d sum22[%d]=%d",sum2,d,sum22[d]);
        	process<<"sum2="<<sum2<<" sum22["<<d<<"]="<<sum22[d]<<endl;
        	d=d+1;
        	printf (" \n");
   		}
    }
    v=0;
    for(int v=0;v<8;v++)
    {
    	bin2[v]=0;
	}
    g=0;
    while(sum22[15]!=0)
	{
  		s = sum22[15]%2;
  		bin2[g++] = s;
  		sum22[15] /= 2;
	}

	for(int h=g-1;h>=0;h--)
	{
 		printf("bin2[%d]=%d ",h,bin2[h]);
 		process<<"bin2["<<h<<"]="<<bin2[h]<<" ";
  	}
  	printf ("\n");    
  	process<<endl;
 	
 	for(int m=7;m>=0;m--)
  	{
  		if(bin2[m] == 0)
  		{
  			output << "1";
		  }
		else
  		{
  			output << "0";
		  }
	}
 	output << endl; 
  
  }
  input.close();
  output.close();
}
  return 0;
}

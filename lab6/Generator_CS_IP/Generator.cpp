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
  input.open("input_256_32.txt",ios::out);
  process.open("process_256_32.txt",ios::out);
  output.open("output_256_32.txt",ios::out);
  srand( time(NULL) );

  /* 指定亂數範圍 */
  int WIDTH_DATA = 256;
  int WIDTH_RESULT = 32; 
  int WIDTH_TIMES = WIDTH_DATA / WIDTH_RESULT;
  int length = pow(2,WIDTH_RESULT);
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
  int number[WIDTH_DATA];
  int answer;
  int add1[WIDTH_TIMES][WIDTH_RESULT];
  unsigned long int sum11[WIDTH_TIMES]={0};
  unsigned long int sum11_divide[WIDTH_TIMES]={0};
  unsigned long int sum22[WIDTH_TIMES]={0};
  unsigned long int sum1;
  unsigned long int sum1_divide;
  int bin1[WIDTH_RESULT]={0};
  unsigned long int r;
  
  if(input.fail() || process.fail() || output.fail())
    {
        cout << "檔案I/O失敗" << endl;
        return 1;
    }
  else
  {
  input << 100 << "\n";
  input << " " << "\n";
  for(j=0;j<100; j++)
  {
   	process<<j<<endl;
    for(n=0;n<WIDTH_DATA; n++)
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
    for(a=0;a<WIDTH_DATA; a++) 
    {
        add1[b][a%WIDTH_RESULT] = number[a];
        if(number[a]==1)
        	if(WIDTH_RESULT == 1)
        	{
        		sum1 = sum1 + 1;
			}
        	else
        	{
        		sum1 = sum1 + pow(2,(WIDTH_RESULT-1)-a%WIDTH_RESULT);
			}
        	
        else
        	sum1 = sum1;
    	if(WIDTH_RESULT == 1)
    	{
    		printf("add1[%d][%d]=%d ",b,0, number[a]);
    		process << "add1[" << b <<"]" << "[0]="<<number[a]<<" "<< "sum1=" << sum1 <<" ";
		}
		else
		{
			printf("add1[%d][%d]=%d ",b,(WIDTH_RESULT-1)-a%WIDTH_RESULT, number[a]);
			process << "add1[" << b <<"]" << "["<<(WIDTH_RESULT-1)-a%WIDTH_RESULT<<"]="<<number[a]<<" ";
		}
        
        
        if(a%WIDTH_RESULT==(WIDTH_RESULT-1))
        {
            process << "sum1=" << sum1 <<" ";
          	//sum11[b]=sum1;
    		//sum1=0;
    		sum1_divide = sum1 / length;
    		sum11[b] = sum1 % length;
    		while(sum1_divide > (length-1))
    		{
    			sum11[b] = sum11[b] + sum1_divide % length;
				sum1_divide = sum1_divide/length;
			}
    		sum11[b] = sum11[b] + sum1_divide;
    		process << " sum11[" << b <<"]=";
    		while(sum11[b]>(length-1))
			{
				process << sum11[b] << ", ";
				sum11_divide[b] = sum11[b] / length;
    			sum22[b] = sum11[b] % length;
    			while(sum11_divide[b] > (length-1))
    			{
    				sum22[b] = sum22[b] + sum11_divide[b] % length;
					sum11_divide[b] = sum11_divide[b]/length;
				}
    			sum11[b] = sum22[b] + sum11_divide[b];
			}
    		printf("sum1=%d sum11[%d]=%d",sum1,b,sum11[b]);
    		process <<sum11[b]<<endl;
    		b=b+1;
          	printf ("\n");
          
   		}
    }
    u=0;
    for(int u=0;u<WIDTH_RESULT;u++)
    {
    	bin1[u] = 0;
	}
    e=0;
    while(sum11[WIDTH_TIMES-1]!=0)
	{
  		r = sum11[WIDTH_TIMES-1]%2;
  		bin1[e++] = r;
  		sum11[WIDTH_TIMES-1] /= 2;
	}

	for(int f=e-1;f>=0;f--)
	{
 		printf("bin1[%d]=%d ",f,bin1[f]);
 		process<<"bin1["<<f<<"]="<<bin1[f]<<" ";
  	}
  	printf ("\n");
  	process << endl;
  	
  	for(int l=WIDTH_RESULT-1;l>=0;l--)
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
  	
 	output << endl; 
  
  }
  input.close();
  process.close();
  output.close();
}
  return 0;
}

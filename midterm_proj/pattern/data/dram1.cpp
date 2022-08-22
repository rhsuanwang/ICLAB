#include <iostream>
#include <cstdlib> /* 亂數相關函數 */
#include <ctime> 
#include <fstream>
#include<math.h>
#include <iomanip>
#include <stdio.h>
#include <stdlib.h>
using namespace std;

int main(){
  FILE * input1;
  FILE * input2;
  FILE * input;
  FILE * output;
  FILE * output1;
  FILE * output2; 
  FILE * process;
  input1 = fopen("dram1.txt","w+");
  input2 = fopen("dramread.txt","w+");
  input = fopen("input.txt","w+");
  output = fopen("output.txt","w+");
  output1 = fopen("outputarray.txt","w+");
  output2 = fopen("outputdram1.txt","w+");
  process = fopen("process.txt","w+");
  srand( time(NULL) );

  /* 指定亂數範圍 */
  int ADDRESS1 = 4096;
  int ADDRESS2 = 8192;
  int ADDRESS3 = 4096;
  int dram1[1024][32] = {0};
  int dramread[1024][32] = {0}; 
  int dramins[1024][32]={0};
  int data1[1024][4] = {0};
  int dataread[1024][4] = {0};
  int datains[1024][4] = {0};
  int instr_addr[100][32]= {0};
  int sum1[1024]={0},sum2[1024]={0},sum3[1024]={0},sum4[100]={0};
  int dram1addr[1024]={0},dramreadaddr[1024]={0};
  int sramread[16][16]={0},arrayread[16][16]={0},sramconv[18][18]={0};
  unsigned long long array[16][16]={0};
  int index;
  int op[1024]={0};
  int i;
  int j;
  int k;
  int a;
  int b;
  int c;
  int d;
  int n;
  int m;
  int o;
  int e;
  int f;
  int g;
  int p;
  int q;
  int h;
  int l;
  int r,s;
  int t,z;
  int u,v;
  int w,x,y;
  int count1;
  int count2;
  int count3;
  int count4;
  /*-------------SET UP ----------------*/
	for(i=0;i<1024; i++)
  	{
		fprintf(input2,"@%x \n",ADDRESS3);
   		ADDRESS3=ADDRESS3+4;
   		g = 0;
    	for(b=31;b>=0; b--)
    	{
    		if(b > 27)
    		{
    			dramins[i][31] = 0;
    			dramins[i][30] = 0;
    			dramins[i][29] = 0;
    			dramins[i][28] = 1;
			}
    		else if(b<=15 && b>11)	
    		{
    			dramins[i][15] = 0;
    			dramins[i][14] = 0;
    			dramins[i][13] = 1;
    			dramins[i][12] = 0;
			}
    		else 
    		{
    			dramins[i][b] = rand() %2;
				//fprintf(input1,"%d",dram1[j][a]);
				if(b==0)
        		{
					if(dramins[i][27] == 1 && dramins[i][26] == 1)
					{
						for(h=18;h<26;h++)
						{
							dramins[i][h] = 0;
						}
					}
					if(dramins[i][11] == 1 && dramins[i][10] == 1)
					{
						for(l=2;l<10;l++)
						{
							dramins[i][l] = 0;
						}
					}
					if(dramins[i][1] == 0)
					{
						dramins[i][0] = 0;
						op[i] = 0;
					} 
		
					if(dramins[i][1] == 1)
					{
						dramins[i][0] = 1;
						op[i] = 1;
					}
				}	
			}
				
    	}
    
						
		for(o=0;o<32;o++)
		{
			if(dramins[i][o] == 1)
			{
				datains[i][g] = datains[i][g] + pow(2,o%8);
				sum3[i] = sum3[i] + pow(2,o);
				if(o % 8 == 7)
					g = g + 1;
				else
					g = g;
			}
			else
			{
				datains[i][g] = datains[i][g];
				sum3[i] = sum3[i];
				if(o % 8 == 7)
					g = g + 1;
				else
					g = g;
			}
		
		}
		dram1addr[i] = sum3[i] >> 18;
		dramreadaddr[i] = (sum3[i] << 16) >> 18;
		//printf("instruction[%d] = %.8x, dram1addr[%d] = %.4x = %d, dramreadaddr[%d] = %.4x = %d \n",i,sum3[i],i,dram1addr[i]*4,dram1addr[i],i,dramreadaddr[i]*4,dramreadaddr[i]);
		fprintf(input2,"%.2x %.2x %.2x %.2x // %d \n",datains[i][0],datains[i][1],datains[i][2],datains[i][3],sum3[i]);
    	
	}
  	for(j=0;j<1024; j++)
  	{
		fprintf(input1,"@%x \n",ADDRESS1);
		fprintf(input2,"@%x \n",ADDRESS2);
   		ADDRESS1=ADDRESS1+4;
   		ADDRESS2=ADDRESS2+4;
   		e = 0;
    	for(a=31;a>=0; a--)
    	{
    		if(a > 0)
    		{
    			dram1[j][a] = 0;
    			//fprintf(input1,"%d",dram1[j][a]);
			}
			else
			{
				dram1[j][a] = rand() %2;
				//fprintf(input1,"%d",dram1[j][a]);
			}
    	}
    	/*
    	if(dram1[j][1]==0)
    	{
    		dram1[j][0] = 1;
		}
		*/
    	for(n=0;n<32;n++)
		{
			if(dram1[j][n] == 1)
			{
				data1[j][e] = data1[j][e] + pow(2,n%8);
				sum1[j] = sum1[j] + pow(2,n);
				if(n % 8 == 7)
					e = e + 1;
				else
					e = e;
			}
			else
			{
				data1[j][e] = data1[j][e];
				sum1[j] = sum1[j];
				if(n % 8 == 7)
					e = e + 1;
				else
					e = e;
			}
		}
		fprintf(input1,"%.2x %.2x %.2x %.2x // %d \n",data1[j][0],data1[j][1],data1[j][2],data1[j][3],sum1[j]);
		
    	f=0;
  		for(c=31;c>=0; c--)
    	{
    		if(c > 0)
    		{
    			dramread[j][c] = 0;
    			//fprintf(input2,"%d",dramread[j][c]);
			}
			else
			{
				dramread[j][c] = rand() %2;
				//fprintf(input2,"%d",dramread[j][c]);
			}
    	}
    	/*
    	if(dramread[j][1]==0)
    	{
    		dramread[j][0] = 1;
		}
		*/
    	for(m=0;m<32;m++)
		{
			if(dramread[j][m] == 1)
			{
				dataread[j][f] = dataread[j][f] + pow(2,m%8);
				sum2[j] = sum2[j] + pow(2,m);
				if(m % 8 == 7)
					f = f + 1;
				else
					f = f;
			}
			else
			{
				dataread[j][f] = dataread[j][f];
				sum2[j] = sum2[j];
				if(m % 8 == 7)
					f = f + 1;
				else
					f = f;
			}
						
		}
		fprintf(input2,"%.2x %.2x %.2x %.2x // %d \n",dataread[j][0],dataread[j][1],dataread[j][2],dataread[j][3],sum2[j]);
	}
	fprintf(input,"%d\n",25);
	k = 0;
	/*-----------CALCULATION------------*/
	for(k=0;k<25;k++)
	{
		// set up insruction address
		for(d=31;d>=0;d--)
		{
			if(d>15)
			{
				instr_addr[k][d] = 0;
			}	
			else if(d<=15 && d>=12)
			{
				instr_addr[k][15] = 0;
				instr_addr[k][14] = 0;
				instr_addr[k][13] = 0;
				instr_addr[k][12] = 1;
				if(instr_addr[k][d] == 1)
					sum4[k] = sum4[k] + pow(2,d);
				else
					sum4[k] = sum4[k];
			}
			else if(d<=1)
			{
				instr_addr[k][1] = 0;
				instr_addr[k][0] = 0;
			}
			else
			{
				instr_addr[k][d] = rand() %2;
				if(instr_addr[k][d] == 1)
					sum4[k] = sum4[k] + pow(2,d);
				else
					sum4[k] = sum4[k];
			}
			//fprintf(input,"%d",instr_addr[k][d]);
		}
		fprintf(input,"%.4x\n",sum4[k]);
		
		fprintf(process,"-----------PADDR[%d] = %.8x ",k,sum4[k]);
		sum4[k] = (sum4[k] - 4096) >> 2;
		fprintf(process,"= no. %d  op = %d-----------\n",sum4[k],op[sum4[k]]);
		fprintf(process,"instruction[%d] = %.8x, dram1addr[%d] = %.4x =no. %d, dramreadaddr[%d] = %.4x =no. %d \n",sum4[k],sum3[sum4[k]],sum4[k],dram1addr[sum4[k]]*4,dram1addr[sum4[k]]-1024,sum4[k],dramreadaddr[sum4[k]]*4,dramreadaddr[sum4[k]]-2048);
		/*
		for(z=0;z<1024;z++)
		{
			fprintf(output2,"DRAM1[%d] = %.8x\n%.2x	//%d\n%.2x	//%d\n%.2x	//%d\n%.2x	//%d\n",z*4+4096,sum1[z],(unsigned int)(sum1[z]<<24)>>24,z*4+4096,(unsigned int)(sum1[z]<<16)>>24,z*4+4097,(unsigned int)(sum1[z]<<8)>>24,z*4+4098,(unsigned int)(sum1[z])>>24,z*4+4099);
		}
		fprintf(output2,"\n");
		*/
		//fprintf(output2,"PATTERN %d dram1addr[%d] = %.4x = dram1[%d] \n",k,sum4[k],dram1addr[sum4[k]]*4,dram1addr[sum4[k]]*4);
		// STORE DRAM1 AND DRAMREAD IN ARRAY
		/*
		for(u=0;u<1024;u++)
		{
			printf("sum1[%d]= %d ",u,sum1[u]);
			if(u%8 == 7)
				printf("\n");
		}
		*/
		
		fprintf(process,"sramread %d\n",k);
		count1 = 0;
		count2 = 0;
		count3 = 0;
		count4 = 0;
		for(p=0;p<16;p++)
		{
			for(q=0;q<16;q++)
			{
				count1 = (dram1addr[sum4[k]]-1024)+q+p*16;
				//printf("%d ",count1);
				if(count1 > 1023)
					sramread[p][q] = sum1[count1-1024];
				else
					sramread[p][q] = sum1[count1];
				fprintf(process,"%-10d ",sramread[p][q]);
			}
			fprintf(process,"\n");
		}
		fprintf(process,"sramconv %d\n",k);
		for(p=0;p<18;p++)
		{
			for(q=0;q<18;q++)
			{
				if(p==0 || p ==17 || q==0 || q==17)
				{
					sramconv[p][q] = 0;
				}
			    else
			    {
			    	count1 = (dram1addr[sum4[k]]-1024)+(q-1)+(p-1)*16;
					//printf("%d ",count1);
					sramconv[p][q] = sum1[count1];
				}
				fprintf(process,"%-10d ",sramconv[p][q]);
			}
			fprintf(process,"\n");
		}
		fprintf(process,"arrayread %d\n",k);
		for(r=0;r<16;r++)
		{
			//printf("count2 = ");
			//printf("sum2[0] = %d, ",sum2[0]);
			for(s=0;s<16;s++)
			{
				count2 = (dramreadaddr[sum4[k]]-2048)+s+r*16;
				if(count2 > 1023)
					arrayread[r][s] = sum2[count2-1024];
				else
					arrayread[r][s] = sum2[count2];
				//printf("%d ",count2);
				fprintf(process,"%-10d ",arrayread[r][s]);
			}
			fprintf(process,"\n");
		}
		// CALCULATION
		fprintf(process,"array %d\n",k);
		
		if(op[sum4[k]] == 0)		// MULTIPLICATION
		{
			for(w=0;w<16;w++)    
    		{    
        		for(x=0;x<16;x++)    
        		{      
            		array[w][x] = 0; 
					for(y=0;y<16;y++)    
            		{    
						//printf("sramread[%d][%d] = %d, ",w,y,sramread[w][y]); 
						//printf("arrayread[%d][%d] = %d, ",y,x,arrayread[y][x]);
						//printf("array[%d][%d]=%lld, ",w,x,array[w][x]);
						array[w][x] = array[w][x] + sramread[w][y]*arrayread[y][x]; 
						//printf("sramread[%d][%d]*arrayread[%d][%d] = %u, ",w,y,y,x,sramread[w][y]*arrayread[y][x]);
						//printf("array[%d][%d]=%u\n ",w,x,array[w][x]);
            		}    
            		//printf("%u ",array[w][x]);
            		count3 = (dram1addr[sum4[k]]-1024)+x+w*16;
            		if(count3 > 1023)
            		{
            			sum1[count3-1024] = array[w][x];
            			//printf("sum1[%d] = %d = array[%d][%d] = %d\n",count3-1024,sum1[count3-1024],w,x,array[w][x]);
					}
            		else
            		{
            			sum1[count3] = array[w][x];
            			//printf("sum1[%d] = %d = array[%d][%d] = %d\n",count3,sum1[count3],w,x,array[w][x]);
					}
					fprintf(output1,"%-10d",sum1[count3]);
					fprintf(process,"%-10d",sum1[count3]);
        		}    
        		printf("\n");
        		fprintf(output1,"\n");
        		fprintf(process,"\n");
    		}   
			fprintf(output1,"\n");
		}
		else
		{
			for(w=0;w<16;w++)    
    		{    
        		for(x=0;x<16;x++)    
        		{      
            		array[w][x] = 0;
					for(y=0;y<9;y++)    
            			{    
                			//printf("sramconv[%d][%d] = %d, ",w+y/3,x+y%3,sramconv[w+y/3][x+y%3]); 
							//printf("arrayread[0][%d] = %d, ",y,arrayread[0][y]);
							//printf("array[%d][%d]=%u ",w,x,array[w][x]);
							array[w][x] += sramconv[w+y/3][x+y%3]*arrayread[0][y];  
							//printf("sramread[%d][%d] * arrayread[0][%d] = %d ",w+y/3-1,x+y%3-1,y,sramread[w+y/3-1][x+y%3-1]*arrayread[0][y]);
							//printf("array[%d][%d]=%u\n ",w,x,array[w][x]);
            			}
					//printf("%u ",array[w][x]); 
					count4 = (dram1addr[sum4[k]]-1024)+x+w*16;
            		if(count4 > 1023)
            		{
            			sum1[count4-1024] = array[w][x];
            			//printf("sum[%d] = %d = array[%d][%d] = %d\n",count4-1024,sum1[count4-1024],w,x,array[w][x]);
					}
            		else
            		{
            			sum1[count4] = array[w][x];
            			//printf("sum[%d] = %d = array[%d][%d] = %d\n",count4,sum1[count4],w,x,array[w][x]);
					}   
					fprintf(output1,"%-10d",sum1[count4]);
					fprintf(process,"%-10d",sum1[count4]);
        		}    
        		printf("\n");
        		fprintf(output1,"\n");
        		fprintf(process,"\n");
    		}
    		fprintf(output1,"\n");
		}
		fprintf(output,"%8x\n",sum3[sum4[k]]);
		for(z=0;z<256;z++)
		{
			fprintf(process,"mem[%d] = %-.8x\n",(dram1addr[sum4[k]]+z) % (int)pow(2,8),array[z/16][z%16]);
			fprintf(output,"%x ",array[z/16][z%16]);
			if(z%16 == 15)
				fprintf(output,"\n");
		}
		fprintf(process,"\n");
		
		for(z=0;z<1024;z++)
		{
			fprintf(output2,"DRAM1[%d] = %.8x\n%.2x	//%d\n%.2x	//%d\n%.2x	//%d\n%.2x	//%d\n",z*4+4096,sum1[z],(unsigned int)(sum1[z]<<24)>>24,z*4+4096,(unsigned int)(sum1[z]<<16)>>24,z*4+4097,(unsigned int)(sum1[z]<<8)>>24,z*4+4098,(unsigned int)(sum1[z])>>24,z*4+4099);
			//fprintf(output,"%.2x\n%.2x\n%.2x\n%.2x\n",(unsigned int)(sum1[z]<<24)>>24,(unsigned int)(sum1[z]<<16)>>24,(unsigned int)(sum1[z]<<8)>>24,(unsigned int)(sum1[z])>>24);
			//fprintf(output2,"%.8x\n",sum1[z]);
		}
		fprintf(output,"\n");
	}
	
	
	fclose(input1);
  	fclose(input2);
  	fclose(input);
  	fclose(output);
  	fclose(output1);
  	fclose(output2);
  	fclose(process);
  	return 0;
}


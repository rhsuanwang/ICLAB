#include <stdio.h>
#include <math.h>
#include <time.h>
#include <iostream>
#include <iomanip>
#include <stdlib.h>
#include<fstream>
#include <limits.h>
#include <bitset>
#include <sstream>
using namespace std;

float BtoD(int x[])
{
    float ans;
    int E = 0;
    float D = 0;
    for (int i = 1; i < 32; i++)
    {
        if (i < 9)
        {
            E += (x[i]) << (8 - i);
            //cout << E << endl;
        }
        else
        {
            D += (x[i]) * pow(2 ,(8 - i));
            //cout << D << endl;
        }

    }

    ans = pow(2, E - 127)*(1+D);

    if (x[0] == 1)
        ans = -ans;

    return ans;
}


using namespace std;






int U_Random()   //產生一個1~7之間的隨機數 
{
        int f;       
        f = rand()%2;
        return f;
}

int N_Random()   //產生一個1~7之間的隨機數 
{
        int e;       
        e = rand()%2;;
        return e;
}

int M_Random()   //產生一個1~7之間的隨機數 
{
        int g;       
        g = rand()%2;;
        return g;
}

int V_Random()   //產生一個1~7之間的隨機數 
{
        int h;       
        h = rand()%2;;
        return h;
}




int main()
{
    srand((time(NULL)));
	int w1[12][32] = {0},data[100][4][32]={0},w2[3][32]={0},target[100][32]={0}, out[25][100][32] = {0};
	float	w1_f[12] = {0},data_f[100][4]={0},w2_f[3]={0},target_f[100]={0}, out_f[25][100] = {0};
	float h1[3]={0.00},y[3]={0.00},delta1[3]={0.00},delta2=0.00,relu[3] = {0.00};
	int relu_d;
	int d,e,f,g,h,v,w,a,b;
	int j,k,n,o,p,m,l,q,r,s,t,u;
	fstream afile;
	fstream bfile;
	fstream pfile;
	fstream cfile;
	fstream dfile;
	fstream qfile;
	afile.open("w1_data.txt",ios::out);
	bfile.open("w2_target.txt",ios::out);
	pfile.open("output.txt",ios::out);
	cfile.open("w1_data_f.txt",ios::out);
	dfile.open("w2_target_f.txt",ios::out);
	qfile.open("output_f.txt",ios::out);
	if(afile.fail()||bfile.fail()||pfile.fail()||cfile.fail()||dfile.fail()||qfile.fail())
	{
		cout<<"can not npen file\n";
	}
	else
	{
		afile<<"2500"<<endl<<endl;
		//for (i=0;i<10000;i++)
    	//{
            for(k=0;k<12;k++)
			{
				for(q=0;q<32;q++)
				{
					w1[k][q] = U_Random(); 
				}
				w1_f[k]=BtoD(w1[k]);
			}    	
            for(o=0;o<3;o++)
			{
				for(r=0;r<32;r++)
				{
					w2[o][r] = V_Random(); 
				}
				w2_f[o]=BtoD(w2[o]);
			}    
        	for(l=0;l<100;l++)	//only 100 data with 1 time
        		{
                	for(m=0;m<4;m++)
                	{
                		for(s=0;s<32;s++)
                		{
                			data[l][m][s] = M_Random();
						}
						data_f[l][m]=BtoD(data[l][m]);
					} 
        		}
        	for(p=0;p<100;p++)	//only 100 data with 1 time
        		{
        			for(t=0;t<32;t++)
        			{
        				target[p][t] = N_Random(); 
					}
                	target_f[p]=BtoD(target[p]);
        		}
    	//}
		
		
		
		
		//Send Data TO TXT
			for(k=0;k<12;k++)
			{
				for(q=0;q<32;q++)
				{
					afile << w1[k][q];		//output weight1 in ieee754 at txta
				}
				afile <<" ";
				cfile <<setprecision(10)<< w1_f[k] << " ";	//output weight1 in decimal at txtc
			}    	
			afile << endl;
			cfile << endl;
            for(o=0;o<3;o++)
			{
				for(r=0;r<32;r++)
				{
					bfile << w2[o][r];		//output weight2 in ieee754 at txtb
				}
				dfile <<setprecision(10)<< w2_f[o] << " ";	//output weight2 in decimal at txtd
				bfile << " ";
			}    
			bfile << endl;
			dfile << endl;
        	for(b=0;b<25;b++)		//25 times of 100 data and 100 target
			{
				for(l=0;l<100;l++)	//only 100 data with 1 time
        		{
                	for(m=0;m<4;m++)
                	{
                		for(s=0;s<32;s++)
                		{
                			afile << data[l][m][s];		//output 100 data in ieee754 at txta
						}
						afile<<" ";
						cfile <<setprecision(10)<< data_f[l][m] << " ";	//output 100 data in decimal at txtc
					} 
					afile<<endl;	
					cfile << endl; 
        		}
        		for(p=0;p<100;p++)	//only 100 data with 1 time
        		{
        			for(t=0;t<32;t++)
        			{
        				bfile << target[p][t];			//output 100 target in ieee754 at txtb
					}
                	bfile << endl;
					dfile <<setprecision(10)<< target_f[p] << endl;		//output 100 target in decimal at txtd
        		}
        		
        		//Caculate
				for(a=0;a<100;a++)	//100 DATA ---> 100 OUTPUT & UPDATE 100 TIMES
				{
					/////FORWARD/////
					for (d=0;d<3;d++)	//first layer
					{
						for(e=0;e<4;e++)	//h = sigma(w1*d)
						{
							h1[d] += w1_f[d*4+e]*data_f[a][e];
						}
						if(h1[d]>0)			//RELU
						{
							y[d] = h1[d];
							relu[d] = 1;
						}
						else
						{
							y[d] = 0;
							relu[d] = 0;
						}	
					}
					for(f=0;f<3;f++)	//second layer
					{
						out_f[b][a] += w2_f[f]*y[f];
						qfile << out_f[b][a]<<endl;
					}
					/////BACKWARD/////
					delta2 = out_f[b][a] - target_f[a];	//second layer
					for (g=0;g<3;g++)			//first layer
					{
						delta1[g] = relu[g] * w2_f[g] * delta2;
					}
					/////UPDATE/////
					for(h=0;h<3;h++)			//second layer
					{
						w2_f[h] = w2_f[h]-0.001 * delta2 * y[h];
					}
					for(v=0;v<3;v++)			//first layer
					{
						for(w=0;w<4;w++)
						{
							//w1_f[v*4+w] -= 0.001 * delta1[v] * data_f[w];
						}
			
					}
				}
			}
			
        afile.close();
		bfile.close();
		pfile.close();		
		cfile.close();
		dfile.close();
		qfile.close();
	}
	
	
	return 0;
}

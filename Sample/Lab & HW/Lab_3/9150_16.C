/*
		Name :  kornuma premrit
		ID   :  47-4055-915-0
		SEC  :  CSs-1D
*/

#include "stdio.h"

int menu(void);

int main(void)
{
   int ch,cstd,i=1,total=0,score=0;
   char id[10],sname[20],tmp[80];
   FILE *fp;

   while ((ch=menu())!=3) {
   switch(ch) {
	case 1 :
	    clrscr();
		if ((fp=fopen("0119_16.txt","a"))==NULL)
			printf("Can not open text file!");
		else printf("Open file OK!\n");

		printf("Value Of Students : ");
		scanf("%d",&cstd);
		i=1;
		while (i<=cstd){
			clrscr();
			printf("ID    : "); scanf("%s",&id);
			printf("Name  : "); scanf("%s",&sname);
			printf("Score : "); scanf("%d",&score);
			fprintf(fp,"%s %s %d\n",id,sname,score);
			total+=score;
			i++;
		} // while

		printf("AVERAGE IS %.2f\n\n",(float)total/(float)cstd);
		fprintf(fp,"AVERAGE IS %.2f\n\n",(float)total/(float)cstd);
		fclose(fp);
		getch();
		break;

	case 2 :
	    clrscr();
		if ((fp=fopen("0119_16.txt","r"))==NULL)
			printf("Can not open text file!");
		else printf("Open file OK!\n\n");
			i=1;
			while (fgets(tmp,80,fp)!=NULL) {
				if (i==21) {
					gotoxy(1,24);
					printf("Please Any Key To Continue");
					i=1;
					getch();
					clrscr();
				}
				printf("%s",tmp);
			i++;
			}
			getch();
		break;
   }  // switch
   }  // while
   return 0;
}

int menu(void)
{
 int choice;
   clrscr();
   gotoxy(24,2); printf(" ------------------------------ ");
   gotoxy(24,3); printf("|      1. Add Student          |");
   gotoxy(24,4); printf("|      2. List Score           |");
   gotoxy(24,5); printf("|      3. Exit Program         |");
   gotoxy(24,6); printf("|                              |");
   gotoxy(24,7); printf("|   Please Select Menu :       |");
   gotoxy(24,8); printf(" ------------------------------ ");
   gotoxy(49,7); scanf("%d",&choice);

   return choice;
}

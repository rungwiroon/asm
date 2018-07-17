
//        name:   Kornuma    premrit
//        ID:    47-4055-915-0

#include <stdio.h>
#include <conio.h>

int main(void)
{
   int i = 0;
   int mod,tan;
   int day,k,j,l;
   int count;
   int daymon;
   int m=1,year;
   clrscr();
   printf("input year");
   scanf("%d",&year);
   printf("%d \n",year);
	mod = year % 28;
		printf("year mod 28 : %d \n",mod);
		printf("mod / 4 : %d \n",mod/4);
	printf("year mod 4 : %d \n",i%4);
		mod = mod+(mod/4);
		printf("mod : %d \n",mod);
		printf("mod mod 7 : %d \n",mod%7);
	switch (mod%7) {
		case 6 : printf("Friday ");    day = 5; break;
		case 0 : printf("Saturday ");  day = 6; break;
		case 1 : printf("Sunday ");    day = 0; break;
		case 2 : printf("Monday ");    day = 1; break;
		case 3 : printf("Tuesday ");   day = 2; break;
		case 4 : printf("Wednesday "); day = 3; break;
		case 5 : printf("Thursday ");  day = 4; break;
	}
	getch();
	for (l=1; l<=3; l++) {
	clrscr();
	for (j=0; j<=1; j++)
	for (k=0; k<=1; k++) {
		gotoxy(10+(32*k),5+(10*j));
	printf("Sun Mon Tue Wed Thu Fri Sat");
	count = 1;
	tan = day;

	if ((m==1)||(m==3)||(m==5)||(m==7)||(m==8)||(m==10)||(m==12))
		daymon = 31;
	else if ((m==2)&&(year%4!=3)) daymon = 28;
	else if ((m==2)&&(year%4==3)) daymon = 29;
	else daymon = 30;

	for (i=1; i<=6; i++) {
		gotoxy(10+(day*4)+(32*k),5+i+(10*j));
		for (mod=1; mod<=7-day; mod++) {
			if (count<=daymon) {
				printf("%3d ",count);
				count++;
			}
		}
		day = 0;
	}
	day = (tan+daymon)%7;
	m++;
	}
	getch();
	}

   return 0;
}
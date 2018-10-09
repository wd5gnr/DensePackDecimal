#include <stdio.h>
#include <stdlib.h>

unsigned int encode(int x, int y, int z)
{
   unsigned int dpd=0;
   unsigned typ=(x&8)>>1 | (y&8)>>2 | (z&8)>>3;
   switch (typ)
   {
   case 0:
     dpd=(x<<7)|(y<<4)|z;
     break;
   case 1:
     dpd=x<<7|y<<4|0x8;
     break;
   case 2:
     dpd=x<<7|(z&6)<<4|(y&1)<<4|0xa; //1010;
     break;
   case 3:
     dpd=x<<7|(y&1)<<4|0x4e;  //1001110;
     break;
   case 4:
     dpd=(z&6)<<7|(x&1)<<7|(y)<<4|0xc; //1100;
     break;
   case 5:
     dpd=(y&6)<<7|(x&1)<<7|(y&1)<<4|0x2e; // 0101110;
     break;
   case 6:
       dpd=(z&6)<<7|(x&1)<<7|(y&1)<<4|0xe; // 1110;
     break;
   case 7:
     dpd=(x&1)<<7|(y&1)<<4|0x6e; // 1101110;
     break;
   }
   dpd|=(z&1); // short cut for most cases
   return dpd;
}

unsigned int decode(unsigned int dpd, int *rx, int *ry, int *rz)
{
  int x=0,y=0,z=0;
  if (dpd&8)
  {
    if (((dpd&0xE)==0xE))
     {
	switch (dpd&0x60)
	{
	  case 0:
	    x=8+((dpd&0x80)>>7);
	    y=8+((dpd&0x10)>>4);
	    z=(dpd&0x300)>>7|(dpd&1);
	    break;
	  case 0x20:
	    x=8+((dpd&0x80)>>7);
	    y=(dpd&0x300)>>7|(dpd&0x10)>>4;
	    z=8+(dpd&1);
	    break;
	  case 0x40:
	    x=(dpd&0x380)>>7;
	    y=8+((dpd&0x10)>>4);
	    z=8|(dpd&1);
	    break;
	  case 0x60:
	   x=8+((dpd&0x80)>>7);
	   y=8+((dpd&0x10)>>4);
	   z=8+(dpd&1);
	   break;
	}
     }
     else
     {
        switch (dpd&0xE)
	{
	case 0x8:
	     x=(dpd&0x380)>>7;
	     y=(dpd&0x70)>>4;
	     z=8+(dpd&1);
	     break;
	   case 0xA:
	     x=(dpd&0x380)>>7;
	     y=8+((dpd&0x10)>>4);
	     z=(dpd&0x60)>>4|(dpd&1);
	     break;
	   case 0xC:
	     x=8+((dpd&0x80)>>7);
	     y=(dpd&0x70)>>4;
	     z=(dpd&0x300)>>7|(dpd&1);
	     break;
	}
     }
  }
  else
  {
    x=(dpd&0x380)>>7;
    y=(dpd&0x70)>>4;
    z=(dpd&7);
  }

  if (rx) *rx=x;
  if (ry) *ry=y;
  if (rz) *rz=z;
  return 0;
}

int main(int argc, char *argv[])
{
  unsigned int dpd;
  int x,y,z;
  int a,b,c;  // outputs
  for (x=0;x<=9;x++)
    for (y=0;y<=9;y++)
      for (z=0;z<=9;z++)
      {
        dpd=encode(x,y,z);
	if (decode(dpd,&a,&b,&c)||a!=x||b!=y||c!=z)
	{
	  printf("Error %x %d%d%d/%d%d%d\n",dpd,x,y,z,a,b,c);
	  exit(1);
	} else printf("%x %d%d%d/%d%d%d\n",dpd,x,y,z,a,b,c);
      }
   printf("Success\n");
   return 0;
}  

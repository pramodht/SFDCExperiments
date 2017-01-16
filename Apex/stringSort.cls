// Created by Matheus Goncalves - March 11 2015
// This class is used to sort an array of Strings.
// The main idea is to optimize a sorting algorithm, using bubble sorting as a base. 
// The method below uses less cycles than a brute-force sorting, even in a worst case scenario.


public void stringSort(string[] inarray)
{ integer y = 0, z = inarray.size()-1;
  while(y < z)
  { integer min = y;
    integer max = z;
    for(integer i = y; i <= z; i++)
    { if(inarray[i] < inarray[min])
      { min = i;
      }
      if(inarray[i] > inarray[max])
      { max = i;
      }
    }
    tripleswap(inarray, y, z, min, max);
    y++;
    z--;
  }
}

private void tripleswap(string[] inarray, integer low, integer high, integer min, integer max)
{ string tmp = inarray[high];
  inarray[high] = inarray[max];
  inarray[max] = inarray[low];
  inarray[low] = inarray[min];
  inarray[min] = tmp;
}
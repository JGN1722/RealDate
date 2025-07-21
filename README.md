# RealDate
Because the [Date](https://www.purebasic.com/documentation/date/index.html) library is limited in range, I
wrote this small library to allow adding and substracting dates freely, enabling, for example, calculating
the time elapsed since a starting date. It also has the upside of being free of the [Y2K38 problem](https://en.wikipedia.org/wiki/Year_2038_problem)

## Example  
```
IncludeFile "realdate.pbi"

Define.RealDate sd : GetDate(@sd, 2022, 4, 18, 00, 00, 00)
Define.RealDate cd : GetCurrentDate(@cd)
SubFromDate(@cd, @sd)
MessageRequester("Time elapsed since 4/18/2022", StringOfRealDate(@cd))
```  

## The main date structure  
The main structure is defined as follows:
```
Structure RealDate
  y.l : m.l : d.l
  h.l : i.l : s.l
EndStructure
```  
There are no Getters to retrieve the individual parts of a date. Instead, they can be directly read from
the structure.
+ Year -> ```some_date\y```
+ Month -> ```some_date\m```
+ Day -> ```some_date\d```
+ Hour -> ```some_date\h```
+ Minute -> ```some_date\i``` (```m```was already taken by Months)
+ Second -> ```some_date\s```

## The functions  
+ ```Procedure GetDate(*rd.RealDate,y,m,d,h,i,s)```  
  The main procedure to create a date structure. Because a structure cannot be directly returned by a function,
  an uninitialized structure must be passed as an argument, and will be filled appropriately by the procedure.
  It returns nonzero on success, and zero when the date passed was invalid.
+ ```Procedure GetCurrentDate(*rd.RealDate)```  
  Same as GetDate, but gets the system time. It uses the Date() function from the Date library internally.
+ ```Procedure.s StringOfRealDate(*d.RealDate)```  
  Returns the string representation of a date in the format ```dd/mm/yyyy hh:ii:ss```. It uses an auxilliary function,
  ```Procedure.s Pad(x, n=2)```, that pads a string to the left with ```0```. It can be useful if you want to
  write your own procedure to convert the dates to another format.
+ ```Procedure AddToDate(*d1.RealDate, *d2.RealDate)```  
  Adds two dates, part by part. The first date is modified in-place, while the second is left unchanged.
+ ```Procedure SubFromDate(*d1.RealDate, *d2.RealDate)```  
  Subtracts the second date from the first. The first date is modified in-place, while the second is left unchanged.
+ ```Procedure.b DayExceedsMonth(d, m, y)```  
  Returns true if ```d < 0``` or if ```d``` is higher than the number of days in the given month, and false otherwise.
  Always returns true if the month is invalid (```m < 0 or m > 12```). Specifying the year is necessary to handle leap years.
+ ```Procedure.l DaysInMonth(m, y)```  
  Returns the number of days in the given month. Specifying the year is necessary to handle leap years. Returns 0 if
  the month is invalid (```m < 0 or m > 12```).
+ ```Procedure.b IsLeapYear(y)```  
  Returns true if the year is a leap year, and false otherwise.

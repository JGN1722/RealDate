Structure RealDate
  y.l : m.l : d.l
  h.l : i.l : s.l
EndStructure

Procedure.s Pad(x, n=2)
  If x > 10
    ProcedureReturn Str(x)
  Else
    s$ = Str(x)
    While Len(s$) <> n
      s$ = "0" + s$
    Wend
    ProcedureReturn s$
  EndIf
EndProcedure
Procedure.s StringOfRealDate(*d.RealDate)
  s1$ = Pad(*d\d) + "/" + Pad(*d\m) + "/" + Pad(*d\y, 4)
  s2$ = Pad(*d\h) + ":" + Pad(*d\i) + ":" + Pad(*d\s)
  ProcedureReturn s1$ + " " + s2$
EndProcedure
Procedure.b IsLeapYear(y)
  ProcedureReturn Bool(y % 4 = 0)
EndProcedure
Procedure.l DaysInMonth(m, y)
  If m = 2
    ProcedureReturn 28 + IsLeapYear(y)
  ElseIf m = 4 Or m = 6 Or m = 9 Or m = 11
    ProcedureReturn 30
  Else
    ProcedureReturn 31
  EndIf
EndProcedure
Procedure.b DayExceedsMonth(d, m, y)
  If m = 2
    ProcedureReturn Bool(Not (d < 0 Or (IsLeapYear(y) And d < 29) Or d < 28))
  ElseIf m = 4 Or m = 6 Or m = 9 Or m = 11
    ProcedureReturn Bool(Not (d < 0 Or d < 30))
  Else
    ProcedureReturn Bool(Not (d < 0 Or d < 31))
  EndIf
EndProcedure
Procedure GetDate(*rd.RealDate,y,m,d,h,i,s)
  If m < 0 Or m > 12 : ProcedureReturn 0 : EndIf
  If DayExceedsMonth(d, m, y) : ProcedureReturn 0 : EndIf
  If h < 0 Or h > 23 : ProcedureReturn 0 : EndIf
  If i < 0 Or i > 59 : ProcedureReturn 0 : EndIf
  If s < 0 Or s > 59 : ProcedureReturn 0 : EndIf
  
  *rd\y = y : *rd\m = m : *rd\d = d
  *rd\h = h : *rd\i = i : *rd\s = s
  
  ProcedureReturn -1
EndProcedure
Procedure GetCurrentDate(*rd.RealDate)
  d = Date()
  ProcedureReturn GetDate(*rd,Year(d),Month(d),Day(d),Hour(d),Minute(d),Second(d))
EndProcedure
Procedure AddToDate(*d1.RealDate, *d2.RealDate)
  carry.l = 0
  
  *d1\s + *d2\s
  If *d1\s > 60 : *d1\s - 60 : carry = 1 : EndIf
  
  *d1\i + *d2\i + carry
  If *d1\i > 60 : *d1\i - 60 : carry = 1 : Else : carry = 0 : EndIf
  
  *d1\h + *d2\h + carry
  If *d1\h > 23 : *d1\h - 24 : carry = 1 : Else : carry = 0 : EndIf
  
  ; hybrid approach, I understand myself
  *d1\y + *d2\y
  
  *d1\m + *d2\m
  If *d1\m > 12 : *d1\m - 12 : *d1\y + 1 : EndIf
  
  ; And now get to the day
  *d1\d + *d2\d + carry
  If DayExceedsMonth(*d1\d, *d1\m, *d1\y)
    *d1\d - DaysInMonth(*d1\m, *d1\y)
    *d1\m + 1
    If *d1\m > 12 : *d1\m - 12 : *d1\y + 1 : EndIf
  EndIf
EndProcedure
Procedure SubFromDate(*d1.RealDate, *d2.RealDate) ; d1 = d1 - d2
  *d1\s - *d2\s
  If *d1\s < 0 : *d1\s + 60 : *d1\i - 1 : EndIf
  
  *d1\i - *d2\i
  If *d1\i < 0 : *d1\i + 60 : *d1\h - 1 : EndIf
  
  *d1\h - *d2\h
  If *d1\h < 0 : *d1\h + 24 : *d1\d - 1 : EndIf
  
  *d1\y - *d2\y
  
  *d1\m - *d2\m
  If *d1\m < 0 : *d1\m + 12 : *d1\y - 1 : EndIf
  
  *d1\d - *d2\d
  If *d1\d < 0
    *d1\d + DaysInMonth(*d1\m, *d1\y)
    *d1\m - 1
    If *d1\m < 0 : *d1\m + 12 : *d1\y - 1 : EndIf
  EndIf
EndProcedure

; IDE Options = PureBasic 6.00 LTS (Windows - x86)
; CursorPosition = 84
; FirstLine = 75
; Folding = --
; EnableXP
; DPIAware
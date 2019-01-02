format PE console
entry _start

include 'WIN32A.INC'

section '.data' data readable writable


floatformat db "%f", 0ah, 0
vecformat db "%f %f %f", 0ah, 0

Float equ dq

macro Float.Writeln float
{
  invoke printf, floatformat, dword[float], dword[float + 4]
}

macro Float.Add result,a,b
{
  fld qword [a]
  fld qword [b]
  faddp
  fstp qword [result]
}

macro Float.Multiply result,a,b
{
  fld qword [a]
  fld qword [b]
  fmulp
  fstp qword [result]
}

macro Float.min result,l,r
{
  fld qword [l]
  fld qword [r]
  fcomi st1
  fcmovnb st1
  fstp qword [result]
}

macro Float.rand result
{
  ; Need to realize rand
  fldz
  fstp qword [result]

}

struc Vec x = 0.0,y = 0.0,z = 0.0
{
  .x dq x
  .y dq y
  .z dq z
}

macro Vec.Writeln vec
{
  invoke printf, vecformat, dword[vec#.x],\
  dword[vec#.x + 4], dword[vec#.y],\
  dword[vec#.y + 4], dword[vec#.z], dword[vec#.z + 4]
}


macro Vec.Add result,a,b
{
  Float.Add result#.x, a#.x, b#.x
  Float.Add result#.y, a#.y, b#.y
  Float.Add result#.z, a#.z, b#.z
}

macro Vec.Multiply result,a,b
{
  Float.Multiply result#.x, a#.x, b#.x
  Float.Multiply result#.y, a#.y, b#.y
  Float.Multiply result#.z, a#.z, b#.z
}

macro Vec.Dot result,a,b
{
  fld qword [a#.x]
  fld qword [b#.x]
  fmulp
  fld qword [a#.y]
  fld qword [b#.y]
  fmulp
  fld qword [a#.z]
  fld qword [b#.z]
  fmulp
  faddp
  faddp
  fstp qword [result]
}

macro Vec.Inverse result,a
{
  fld1
  fld qword [a#.x]
  fld qword [a#.x]
  fmulp
  fld qword [a#.y]
  fld qword [a#.y]
  fmulp
  fld qword [a#.z]
  fld qword [a#.z]
  fmulp
  faddp
  faddp
  fsqrt

  fld qword [a#.x]
  fdiv st,st1
  fstp qword [result#.x]

  fld qword [a#.y]
  fdiv st,st1
  fstp qword [result#.y]

  fld qword [a#.z]
  fdiv st,st1
  fstp qword [result#.z]
}



f Float 4.4

f1 Float 1.2
f2 Float 3.2
fmin Float ?

v1 Vec 1.0,2.0,3.0
iv1 Vec
v2 Vec 3.0,4.0,5.0
sum Vec


section '.code' code readable executable



_start:
        Float.Writeln f
        Vec.Writeln v1
        Vec.Writeln v2
        Float.min fmin,f1,f2
        Float.Writeln fmin

        Vec.Inverse iv1,v1
        Vec.Writeln iv1

        invoke getchar
        invoke ExitProcess, 0

section '.imports' import data readable

library kernel, 'kernel32.dll',\
        msvcrt, 'msvcrt.dll'

import kernel, \
       ExitProcess, 'ExitProcess'

import msvcrt, \
       printf, 'printf',\
       getchar, '_fgetchar',\
       rand, 'rand'




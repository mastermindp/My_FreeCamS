//; fPI = 180

   //; Yaw
   fldpi //; Loading PI into x87 FPU = 3.14159265
   fdiv dword ptr [fPI] //; pi divid by 180 =  0.0174532
   fmul dword ptr [r13+10] //; multiply by our Yaw
   fstp dword ptr [YawRadian] //; just for Education Purpose (storing into another Symbol)


   //; Pitch
   fldpi //; same stuff for Pitch
   fdiv dword ptr [fPI]
   fmul dword ptr [r13+C]
   fstp dword ptr [PitchRadian]


   //; X (COS)
   fld dword ptr [YawRadian]
   fcos
   fmul dword ptr [BySpeed]
   fstp dword ptr [DeltaX]
   //; Basiclly = YawRadian(COS) * Speed 
   

   //; Z (SIN)
   fld dword ptr [YawRadian]
   fsin
   fmul dword ptr [BySpeed]
   fstp dword ptr [DeltaZ]
   //; YawRadian(SIN) * Speed 

   //; Y (SIN)
   fld dword ptr [PitchRadian]
   fsin
   fmul dword ptr [BySpeed]
   fstp dword ptr [DeltaY]
   //; PitchRadian(SIN) * Speed 


   //; Camera X
   fld dword ptr [r13]
   fadd dword ptr [DeltaX]
   fstp dword ptr [r13]

   //; Camera Z
   fld dword ptr [r13+4]
   fadd dword ptr [DeltaZ]
   fstp dword ptr [r13+4]

   //; Camera Y
   fld dword ptr [r13+8]
   fadd dword ptr [DeltaY]
   fstp dword ptr [r13+8]
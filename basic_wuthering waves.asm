{ Game   : Wuthering Waves  
  Version: 
  Date   : 2025-03-28
  Author : A d m i n i s t r a t o r
}

define(Camera_address,$process+4380FD0)
define(Camera_bytes,F2 41 0F 10 45 00)

[ENABLE]

assert(Camera_address,Camera_bytes)
alloc(newmem,$1000,Camera_address)

label(code)
label(return)
label(fCamera)
label(YawRadian PitchRadian DeltaX DeltaZ DeltaY SpeedUP)

$process+437B94D:
db 90 90 90 90

$process+437B951:
db 90 90 90

$process+4467953: //; all (xyz (camera & player & etc )shared
db 90 90 90 90 90 90 90 90

$process+43E78ED: //; player Velocity Y ( to not let player die while teleporting )
db 90 90 90 90 90 90 90 90 90

newmem:

push rdx
lea rdx,[r13]
mov [fCamera],rdx
pop rdx


/* for KB
push rcx
mov rcx,0x57
call GetAsyncKeyState
test eax,eax
pop rcx
jz @f
*/


push rbx
mov rbx,CTDebugger
test rbx,rbx
jz code
mov rbx,[rbx]
test rbx,rbx
jz code

cmp [rbx],FF000000 //; if RT
jne @f

   //; Yaw
   fldpi
   fdiv dword ptr [fPI]
   fmul dword ptr [r13+10]
   fstp dword ptr [YawRadian]


   //; Pitch
   fldpi
   fdiv dword ptr [fPI]
   fmul dword ptr [r13+C]
   fstp dword ptr [PitchRadian]


   //; X (COS)
   fld dword ptr [YawRadian]
   fcos
   fmul dword ptr [BySpeed]
   fstp dword ptr [DeltaX]

   //; Z (SIN)
   fld dword ptr [YawRadian]
   fsin
   fmul dword ptr [BySpeed]
   fstp dword ptr [DeltaZ]

   //; Y (SIN)
   fld dword ptr [PitchRadian]
   fsin
   fmul dword ptr [BySpeed]
   fstp dword ptr [DeltaY]


   //; VecX
   fld dword ptr [r13]
   fadd dword ptr [DeltaX]
   fstp dword ptr [r13]

   //; VecZ
   fld dword ptr [r13+4]
   fadd dword ptr [DeltaZ]
   fstp dword ptr [r13+4]

   //; VecY
   fld dword ptr [r13+8]
   fadd dword ptr [DeltaY]
   fstp dword ptr [r13+8]

   //; player Teleport to Camera
   push rax
   mov rax,fplayer
   mov rax,[rax]

   fld dword ptr [r13]
   fstp dword ptr [rax]

   fld dword ptr [r13+4]
   fstp dword ptr [rax+4]

   fld dword ptr [r13+8]
   fstp dword ptr [rax+8]

   pop rax

   @@:
   //cmp byte ptr [SpeedUP],1
   //je SpeedME
   cmp word ptr [rbx+6],0
   ja SpeedME

   mov [BySpeed],(float)10 //; factory Setting

code:
  //movsd xmm0,[r13+00]
  pop rbx
  jmp return

  SpeedME:
  cmp word ptr [rbx+6],#10000
  ja @f
  mov [BySpeed],(float)20
  jmp code

  @@:
  cmp word ptr [rbx+6],#20000
  ja @f
  mov [BySpeed],(float)40
  jmp code

  @@:
  cmp word ptr [rbx+6],#30000
  ja @f
  mov [BySpeed],(float)60
  jmp code

  @@:
  mov [BySpeed],(float)100
  jmp code

  fCamera:
  dq 00

SpeedUP:
db 00

YawRadian:
dq 00

PitchRadian:
dq 00


DeltaX:
dq 00

DeltaZ:
dq 00

DeltaY:
dq 00


fPI:
dd (float)180

BySpeed:
dd (float)10

Camera_address:
  jmp newmem
  nop
return:
registersymbol(Camera_address fCamera YawRadian PitchRadian DeltaX DeltaZ DeltaY SpeedUP)
[DISABLE]

$process+437B94D:
db F2 0F 11 0F

$process+437B951:
db 89 47 08

$process+4467953: //; all shared
db 44 0F 11 9B F0 01 00 00

$process+43E78ED: //; player Velocity Y
db F3 44 0F 11 93 DC 00 00 00

Camera_address:
  db Camera_bytes
  // movsd xmm0,[r13+00]

unregistersymbol(Camera_address fCamera YawRadian PitchRadian DeltaX DeltaZ DeltaY SpeedUP)
dealloc(newmem)
//unregistersymbol(*)
//dealloc(*)

{
// ORIGINAL CODE - INJECTION POINT: Client-Win64-Shipping.exe+4380FD0

Client-Win64-Shipping.exe+4380FA4: 41 8B 45 14        - mov eax,[r13+14]
Client-Win64-Shipping.exe+4380FA8: 49 8D 7D 0C        - lea rdi,[r13+0C]
Client-Win64-Shipping.exe+4380FAC: F2 0F 10 07        - movsd xmm0,[rdi]
Client-Win64-Shipping.exe+4380FB0: 49 8D 5D 18        - lea rbx,[r13+18]
Client-Win64-Shipping.exe+4380FB4: 89 44 24 58        - mov [rsp+58],eax
Client-Win64-Shipping.exe+4380FB8: 4C 8D 4C 24 50     - lea r9,[rsp+50]
Client-Win64-Shipping.exe+4380FBD: 41 8B 45 08        - mov eax,[r13+08]
Client-Win64-Shipping.exe+4380FC1: 4C 8D 44 24 40     - lea r8,[rsp+40]
Client-Win64-Shipping.exe+4380FC6: F2 0F 11 44 24 50  - movsd [rsp+50],xmm0
Client-Win64-Shipping.exe+4380FCC: 41 0F 28 C9        - movaps xmm1,xmm9
// ---------- INJECTING HERE ----------
Client-Win64-Shipping.exe+4380FD0: F2 41 0F 10 45 00  - movsd xmm0,[r13+00]
// ---------- DONE INJECTING  ----------
Client-Win64-Shipping.exe+4380FD6: 49 8B CF           - mov rcx,r15
Client-Win64-Shipping.exe+4380FD9: 48 89 5C 24 38     - mov [rsp+38],rbx
Client-Win64-Shipping.exe+4380FDE: 89 44 24 48        - mov [rsp+48],eax
Client-Win64-Shipping.exe+4380FE2: 49 8B 07           - mov rax,[r15]
Client-Win64-Shipping.exe+4380FE5: F2 0F 11 44 24 40  - movsd [rsp+40],xmm0
Client-Win64-Shipping.exe+4380FEB: F3 0F 10 03        - movss xmm0,[rbx]
Client-Win64-Shipping.exe+4380FEF: 48 89 7C 24 30     - mov [rsp+30],rdi
Client-Win64-Shipping.exe+4380FF4: 4C 89 6C 24 28     - mov [rsp+28],r13
Client-Win64-Shipping.exe+4380FF9: F3 0F 11 44 24 20  - movss [rsp+20],xmm0
Client-Win64-Shipping.exe+4380FFF: FF 90 A8 02 00 00  - call qword ptr [rax+000002A8]
}
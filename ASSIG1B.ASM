 .model small        
 .stack 64h

  input MACRO
 mov ah,07h      ;without echo
 int 21h
  endm


  display1 MACRO msg
 mov ah,09h
 mov dx,OFFSET msg
 int 21h
  endm

  print MACRO
   mov ah,02h   ;print 
   int 21h
  endm


 .data
  array db 10h,20h,10h,10h,10h 
  result1 db 'Addition is : ',13,10,'$'
  x db 0
  y db ?

   .code

 mov ax,@data
 mov ds,ax
      mov al,0h
      mov dl,5h
      mov x,dl

   call SUM1 
         SUM1 proc near
                 mov cl,x
                 DEC cl
                 lea si,array

                 mov bl,[si]
                 xyz:
                    INC si
                    add bl,[si]
                    mov al,bl
                    daa
                    mov bl,al
                    DEC cl

                    JNZ xyz
         SUM1 endp
   call resultF

        resultF proc near
                  display1 result1
                  mov y,bl
                  mov cx,0204h
                 mno:
                     rol y,cl
                     mov dl,y
                     and dl,0Fh
                     cmp dl,09h
                     jbe pqr

                     add dl,07h
                 pqr:
                     add dl,30h
                     print
                     dec ch
                     jnz mno

            resultF endp


 mov ah,4ch
 int 21h

 end

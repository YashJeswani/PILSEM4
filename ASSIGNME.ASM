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
   msg db 'Enter LIMIT OF ARRAY :',13,10,'$'
   array db 10 dup(0) 
   msg1 db 10,'Enter Number :',13,10,'$'
  result db 10,'NUMBERS ARE  : ',13,10,'$'
  result1 db 10,'Addition is : ',13,10,'$'
  x db ?
  y db ?
  sum db ?

   .code

 mov ax,@data
 mov ds,ax

      display1 msg              ;for inputing limit of array
      input
      mov dl,al     ;02h(print) checks is dl
      print

      sub dl,30h
      mov cl,dl
      mov x,cl

      lea si,array

 abc:
    display1 msg1               ;for inputing numbers in array
    input
    mov dl,al     ;02h(print) checks is dl
    print

    sub dl,30h
    mov [si],dl

    INC  si
    DEC  cl
    JNZ abc       ;JNZ checks from Only cl

    mov cl,x
    lea si,array
    
 def:
   display1 result              ;for showing numbers in array
   mov dl,[si]
   add dl,30h
   print
   INC  si
   DEC cl
   JNZ def

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

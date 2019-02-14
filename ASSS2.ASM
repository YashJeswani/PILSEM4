
 .model small
 .stack 64h
 .386

  input MACRO			;inputing number macro
      mov ah,01h     
      int 21h
  endm


  display1 MACRO msg		;fr displaying msg lea or mov offset
      mov ah,09h
      mov dx,OFFSET msg
      int 21h
  endm

  print MACRO
      mov ah,02h   		;print 
      int 21h
  endm


 .data						;data set
  
   msg1 db 'Enter Your Choice :',13,10,'$'
   msg2 db '1)HEX TO BCD :',13,10,'$'
   msg3 db '2)BCD TO HEX :',13,10,'$'
   msg4 db '3)EXIT ! ',13,10,'$'
   msg5 db 10,'MENU :: ',13,10,'$'
   msg6 db 10,'Hex IS :  ',13,10,'$'
   msg7 db 'INVALID NO! ',13,10,'$'
   msg8 db 10,'Enter BCD  Number :',13,10,'$'
   msg9 db 10,'bcd IS :  ',13,10,'$'
   msg10 db 10,'Enter HEX  Number :',13,10,'$'

  array db 10 dup(0)				; taking array 
  temp  dw 10000				;taking temporary var fr division
  x     dw 10
  res   dw 0
  hex   dw ?
  count db 0
   .code

       mov ax,@data
       mov ds,ax

      menu_driven:					;for printing menu driven
       display1 msg5
       display1 msg2
       display1 msg3
       display1 msg4
       display1 msg1

       input

       cmp al,31h
           jz hex_to_bcd			;cmp will return zero if al is 1 so then hex_to_bcd works
       cmp al,32h
           jz bcd_to_hex			;if al is 2 the bcd_to_hex works
       cmp al,33h
           jz exit_loop

           jnz invalid_no
         bcd_to_hex:

                         mov cl,4
                         lea si,array
                         display1 msg8 			 ;for inputing numbers in array
                         valid:
                                 input
                                 sub al,30h
                                 cmp al,06h
                                 mov [si],al
                                 INC  si
                                 ja valid         
                         iploop:                              
                                 input
                                 sub al,30h
                                 mov [si],al

                                 INC  si
                                 DEC  cl
                                 JNZ iploop       		;JNZ checks from Only cl 
                        lea si,array
                        mov cl,5
                        mov temp,10000
                        mov res,00
                       logic:					;logic of conversion
                                 mov al,[si]
                                 mov ah,00h			;taking 4 digit input so bcd no 3456 so 3*1000
				 mov bx,temp 
                                 mul bx				;since mul takes only one arguement 
                                 add res,ax

                                 mov ax,temp
                                 mov x,10
                                 mov dx,00			;remainder stored in dx
                                 div x

                                 mov temp,ax			;ax(temp) as 100 after 3*1000 is added

                                 INC si
                                 DEC cl
                                 JNZ logic

                         display1 msg6
                         mov cx,0404h
                         mov bx,res				;display logic
                         resloop:
                                 rol bx,cl
                                 mov dl,bl
                                 and dl,0Fh
                                 cmp dl,09h
                                 jbe hloop			;if its below equal 9 then add 30 and print it else add 7 too

                                 add dl,07h
                         hloop:
                                 add dl,30h
                                 print
                                 dec ch
                                 jnz resloop

                        jmp menu_driven
         hex_to_bcd:
                   display1  msg10
                   mov cx,0404h
                   mov hex,0000h

               inp1:					;validation logic
                     input
                     cmp al,39h				;below equal 9
                     jbe subt

                     ja cmp2				;if its above 9

                   subt:
                     sub al,30h
                     jmp inp2

                   cmp2:
                     cmp al,46h
                     jbe sube				;if its between a to f ie. 41 to 46

                     ja cmp3

                   sube:
                     sub al,37h
                     jmp inp2

                   cmp3:
                     cmp al,66h				;if its between A to F ie. 61 to 66
                     jbe sub2
                   sub2:
                     sub al,57h
                     jmp inp2
                     ja inp1

                   inp2:
                     mov ah,00h
                     rol hex,04h

                     add hex,ax
                     dec cl
                     jnz inp1

                   mov ax,00  				;quotient
                   mov x,10
                   mov ax,hex   
                   mov count,00

                 l1:
                   mov dx,0000h				;pushing in the stack
                   div x				;remainder stored in dx ie. is push
                   push dx
                   inc count
                   cmp ax,0h
                   jnz l1

                  mov ch,count
                   display1 msg9			;printing out number as by popping
                   poplogic:
                       mov dx,0000h
                       pop dx
                       add dx,30h
                       print
                       dec ch
                       jnz poplogic

                  jmp menu_driven
                   
         invalid_no:					;invalid no.
                  display1 msg7
                  jmp menu_driven
         exit_loop:
                  mov ah,4ch				;for breaking out from loop
                  int 21h

      end

	.global insert_sort
	.type global,@function

	.section .text
insert_sort:
   lea   8(%rsi), %rsi     # rsi <- one after last ptr
   lea   8(%rdi), %rax     # rcx <- current pointer - second element for swapping
 LOOP:
   frst  =  %rdi
   last  =  %rsi
   iter  =  %rax
   cmp   iter,    last     # if last == current
   je    END
   # begin swapping
   lea   -8(iter),%rbx     # swapping ptr
 BACK:
   swap  =  %rbx
   lea   8(swap), %r8
   cmp   %r8,     frst
   je    ADVANCE
   mov   (swap),  %r9
   mov   8(swap), %r10
   cmp   %r10,    %r9
   jle   ADVANCE           # if sorted - advance
   mov   %r10,     (swap)
   mov   %r9,    8(swap)
   lea   -8(%rbx), %rbx    # --swap_iter
   jmp BACK

 ADVANCE:
   lea   8(iter), iter     # iter++
   jmp LOOP

 END:
   ret

   .size insert_sort, .-insert_sort

# vim: ts=8 sw=8 et

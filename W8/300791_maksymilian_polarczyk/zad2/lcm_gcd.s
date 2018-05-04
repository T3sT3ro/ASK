	.global lcm_gcd
	.type global,@function

	.section .text
lcm_gcd:
   mov   %rdi, %rax # rax <- a
   mov   %rsi, %rdx # rdx <- b
L:
   test  %rdx, %rdx # b == 0
   jz    end        # ...
   mov   %rdx, %r9  # r9 <- b
   xor   %rdx, %rdx # rdx = 0
   div   %r9        # rdx <- b = a mod b (rdx:rax / r9)
   mov   %r9,  %rax # a = r9
   jmp L

end:
   # gcd in rax
   mov   %rax, %r9  # r9 = gcd
   mov   %rdi, %rax # rax <- a
   mul   %rsi       # edx:eax <- a*b
   div   %r9        # %rax <- lcm
   mov   %r9,  %rdx # %rdx <- gcd

   ret

   .size lcm_gcd, .-lcm_gcd

# vim: ts=8 sw=8 et

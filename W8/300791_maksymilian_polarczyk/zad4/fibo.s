	.global fibonacci
	.type global,@function

	.section .text
fibonacci:

  cmp   $2,    %rdi
  jge    CALC
  mov   %rdi, %rax
  ret
 CALC:
  sub   $1,    %rdi
  push  %rdi
  call fibonacci
  pop   %rdi
  push  %rax
  sub   $1,   %rdi
  push  %rdi
  call fibonacci
  pop   %rdi
  pop   %r8
  add   %r8,  %rax
  ret

  .size fibonacci, .-fibonacci

# vim: ts=8 sw=8 et

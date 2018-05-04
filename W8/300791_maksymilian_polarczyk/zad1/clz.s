	.global clz
	.type global,@function

	.section .text
clz:
# fills ones after leading zeroes
	mov	%rdi,	%rax
	shr	$1,     %rax
	or 	%rax,	%rdi

	mov	%rdi,	%rax
	shr	$2,     %rax
	or 	%rax,	%rdi

	mov	%rdi,	%rax
	shr	$4,     %rax
	or 	%rax,	%rdi

	mov	%rdi,	%rax
	shr	$8,     %rax
	or 	%rax,	%rdi

	mov	%rdi,	%rax
	shr	$16,    %rax
	or 	%rax,	%rdi

	mov	%rdi,	%rax
	shr	$32,    %rax
	or 	%rax,	%rdi

	# only trailing ones
	not	%rdi
# count ones of inverted number; could have used popcnt but forbidden
	mov %rdi,	%rax
	movabs $0x5555555555555555, %r8
	and %r8,	%rax # 01010101...
	shr $1,		%rdi
	and %r8,	%rdi
	add %rax,	%rdi

	mov %rdi,	%rax
	movabs $0x3333333333333333, %r8
	and %r8,	%rax # 00110011...
	shr $2,		%rdi
	and %r8,	%rdi
	add %rax,	%rdi

	mov %rdi,	%rax
	movabs $0x0f0f0f0f0f0f0f0f, %r8
	and %r8,	%rax
	shr $4,		%rdi
	and %r8,	%rdi
	add %rax,	%rdi

	mov %rdi,	%rax
	movabs $0x00ff00ff00ff00ff, %r8
	and %r8,	%rax
	shr $8,		%rdi
	and %r8,	%rdi
	add %rax,	%rdi

	mov %rdi,	%rax
	movabs $0x0000ffff0000ffff, %r8
	and %r8,	%rax
	shr $16,	%rdi
	and %r8,	%rdi
	add %rax,	%rdi

	mov %rdi,	%rax
	movabs $0x00000000ffffffff, %r8
	and %r8,	%rax
	shr $32,	%rdi
	and %r8,	%rdi
	add %rdi,	%rax
	ret
	.size clz, .-clz

# vim: ts=8 sw=8 et

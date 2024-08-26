#Copyright TheZouave007 (2024)
#All rights reserved, see License.txt for details

.file "phase_sort_asm.S"
.intel_syntax noprefix
.text
.globl phase_sort3
.type phase_sort3, @function
phase_sort3:
	pushq r15
	pushq r14
	pushq r13
	pushq r12
	pushq rbp
	pushq rbx
	mov  ecx, 1
	xor  edx, edx
	call _phase_sort3
	popq  rbx
	popq  rbp
	popq  r12
	popq  r13
	popq  r14
	popq  r15
	ret
.size phase_sort3, .-phase_sort3
.globl _phase_sort3
.type _phase_sort3, @function
_phase_sort3:
#rdi = arr
#rsi = size
#rdx = offset
#rcx = stride
	pushq rdx
	add  rdx, rcx
	cmp  rdx, rsi
	jge  .L1
	sal  rcx, 1
	call _phase_sort3
	mov  rdx, [rsp]
	call _phase_sort3
	sar  rcx, 1
.L1:
#r8 = tail
#r9 = head
	popq  rdx
	mov  r8, rdx
	lea  r9, [rdx + rcx]
.L2:
#r10 = temp
	cmp  r9, rsi
	jge  .L5
	mov  r10d, DWORD PTR [rdi +0+ r9*4]
	cmp  r10d, DWORD PTR [rdi +0+ r8*4]
	jge  .L4
	pushq r9
	neg  rcx
.L3:
#r9 = i
	lea  r11, [r9 + rcx]
	mov  r11d, DWORD PTR [rdi +0+ r11*4]
	mov  DWORD PTR [rdi +0+ r9*4], r11d
	lea  r9, [r9 + rcx]
	cmp  r9, r8
	jl   .L3
	neg  rcx
	popq r9
	mov  DWORD PTR [rdi +0+ r8*4], r10d
	lea  r9, [r9 + rcx*2]
.L4:
	add  r8, rcx
	lea  r10, [r9 + rcx]
	cmp  r8, r9
	cmove r9, r10
	jmp  .L2
.L5:
	ret
.size _phase_sort3, .-_phase_sort3
.globl phase_sort4
.type phase_sort4, @function
phase_sort4:
	push    r15
	push    r14
	push    r13
	push    r12
	push    rbp
	push    rbx
	push    rdi
	lea     edi, [rsi-1]
	call    pow2floor
	pop     rdi
.L6:
#rdi = arr
#esi = size
#eax = stride
#ebx = offset
	cmp     eax, 0
	je      .L13
	xor     ebx, ebx
.L7:
#ecx = tail
#edx = head
	lea     edx, [ebx + eax]
	cmp     edx, esi
	jge     .L12
	mov     ecx, ebx
.L8:
	cmp     edx, esi
	jge     .L11
	mov     r8d, DWORD PTR [rdi + rdx*4]
	cmp     r8d, DWORD PTR [rdi + rcx*4]
	jge     .L10
	lea     r9, [rdi + rdx*4]
.L9:
#r8d = temp
#r9 = &array[i]
	neg     rax
	mov     r10d, DWORD PTR [r9 + rax*4]
	mov     DWORD PTR [r9], r10d
	lea     r9, [r9 + rax*4]
	neg     rax
	lea     r10, [rdi + rcx*4]
	cmp     r9, r10
	jl      .L9
	mov     DWORD PTR [r10], r8d
	lea     edx, [edx + eax*2]
.L10:
	add     ecx, eax
	lea     r8d, [edx + eax]
	cmp     ecx, edx
	cmove   edx, r8d
	jmp     .L8
.L11:
	inc     ebx
	cmp     ebx, eax
	jl      .L7
.L12:
	sar     eax
	jmp     .L6
.L13:
	pop     rbx
	pop     rbp
	pop     r12
	pop     r13
	pop     r14
	pop     r15
	ret
.size phase_sort4, .-phase_sort4

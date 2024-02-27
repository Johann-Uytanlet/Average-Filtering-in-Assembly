global _imgAvgFilter

section .data
margin dd 0x12345678
imageSize dd 0x87654321
mainLoopTemp dd 0x01230123
averageBoxXCounter dd 0x11111111
averageBoxYReset dd 0x22222222
averageBoxOuterLoop dd 0x33333333
rowUnit dd 0x44444444
sampleSizeArea dd 0x55555555
tempSum dd 0x66666666
tempRemainder dd 0x77777777
section .text
    _imgAvgFilter:
    push ebp
    mov ebp, esp
    mov esi, [esp + 8] ;image array
    mov edi, [esp + 12] ;filtered image array
    mov ecx, [esp + 16] ;img x 
    mov ecx, [esp + 20] ;img y
    mov ecx, [esp + 24] ;samping size
    
    mov edx, 0
    mov eax, [esp + 24]
    mov ebx, 2
    idiv ebx
    
    mov dword[margin], eax
    
    ; img x * img y
    mov edx, 0
    mov eax, [esp + 16]
    mov ebx, [esp + 20]
    imul ebx
    
    MOV dword[imageSize], EAX
    
    MOV EAX, [esp + 16]
    MOV EBX, 4
    IMUL EBX
    
    MOV dword[rowUnit], EAX ; rowUnit = x * 4
    
    MOV EAX, [esp + 24]
    MOV EBX, EAX
    IMUL EBX
    
    MOV dword[sampleSizeArea], EAX ; sampleSizeArea = sample size^2
    
    MOV ECX, [imageSize]
    
    ; loop img x * img y times
    L1:
    MOV EAX, [imageSize]    ; eax is currently at the nth part of the array
    SUB EAX, ECX            ; example 25 - 25 = 0, arr[0] 
    MOV EDX, 0
    mov EBX, [ESP + 16]     ; number of cols/img x
    idiv EBX                ; eax row number edx col number from 0,0 to n-1,n-1
    CMP EAX, [margin]       ; check top margin 
    JL skip
    MOV EBX, [ESP + 20]
    SUB EBX, 1
    SUB EBX, [margin]
    CMP EAX, EBX            ; check bot margin
    JG skip 
    CMP EDX, [margin]       ; check left margin
    JL skip
    MOV EBX, [ESP + 16]
    SUB EBX, 1
    SUB EBX, [margin]
    CMP EDX, EBX            ; check right margin
    JG skip
    JMP compute             ; to not run the skip code
    skip:                   ;if margins copy value of orig array
    MOV EDX, 0
    MOV EAX, [imageSize]
    SUB EAX, ECX
    MOV EBX, 4
    IMUL EBX
    ADD ESI, EAX
    MOV EBX, [ESI]          ; get nth element of img array
    SUB ESI, EAX
    MOV [EDI], EBX  
    end:
    ADD EDI, 4              ; move pointer/cursor on filtered image array
    JECXZ FINIS
    LOOP L1
    FINIS: NOP
    
    mov EAX, [esp + 24]
    
    
    pop ebp
    ret
    
    
    
    ; to get original array number based on row and column
    ; ESI + row*rowUnit + col*4
    ; averageBoxXCounter is row*rowUnit
    ;test run
    compute:                ; do the average computation
    MOV dword[averageBoxYReset], EDX
    MOV dword[mainLoopTemp], ECX
    SUB EAX, [margin]
    SUB EAX, 1
    MOV EBX, [rowUnit] ;EAX is current row
    IMUL EBX
    MOV dword[averageBoxXCounter], EAX ; row*rowUnit
    ; if current 5,5 and sample window size is 3
    ; averageBoxXCounter is 4 * rowunit
    
    MOV EAX, [averageBoxYReset]
    SUB EAX, [margin]
    MOV EBX, 4
    IMUL EBX
    
    MOV dword[averageBoxYReset], EAX
    ; if current 5,5 and sample window size is 3
    ; averageBoxYReset is 4 * 4
    MOV EBX, 0                      ; sum
    MOV ECX, [esp + 24]             ;sampling size window
    MOV EAX, [averageBoxXCounter]
    MOV EDX, [averageBoxYReset]
    
    L2:
    ADD EAX, [rowUnit]
    MOV EDX, [averageBoxYReset]
    MOV dword[averageBoxOuterLoop], ECX
    MOV ECX, [esp + 24]
    L3:
    
    ADD ESI, EAX
    ADD ESI, EDX
    ADD EBX, [ESI]
    SUB ESI, EAX
    SUB ESI, EDX
    ADD EDX, 4
    
    JECXZ L3FINIS
    LOOP L3
    L3FINIS:
    MOV ECX, [averageBoxOuterLoop]
    
    
    JECXZ L2FINIS
    LOOP L2
    L2FINIS: 
    
    ;MOV dword[tempSum], EBX 
    
    MOV EDX, 0
    MOV EAX, EBX
    MOV EBX, [sampleSizeArea]
    IDIV EBX ; get average by sum/sample size area
    
    MOV dword[tempRemainder], EDX
    MOV dword[tempSum], EAX
    
    
    
    
    MOV EDX, 0
    MOV EAX, EBX
    MOV EBX, 2
    IDIV EBX
    ;rounding, note sampleSize Area always odd
    MOV ECX, [tempRemainder]
    MOV EBX, [tempSum]
    CMP EAX, ECX
    JGE NOADD
    ADD EBX, 1
    NOADD:
    
    MOV EAX, EDX;[tempRemainder]
    MOV [EDI], EBX
    MOV ECX, [mainLoopTemp]
    JMP end
    
    
    
    
    

    
    
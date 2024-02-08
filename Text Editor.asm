.data
    buffer      db 100*100 dup(?)    
    row_pos     db 0                
    col_pos     db 0              
    line_num    db 0                 
    char_num    db 0                  
.code  
position macro row, col
    mov ah, 02h
    mov dh, row
    mov dl, col
    int 10h
endm
backspace macro
    mov dx, 8
    mov ah, 2
    int 21h
    mov dx, 32
    mov ah, 2
    int 21h
    mov dx, 8
    mov ah, 2
    int 21h
endm
nextline macro
    mov dl, 10
    mov ah, 2
    int 21h   
    mov dl, 13
    mov ah, 2
    int 21h
endm
main proc
    mov ax, @DATA
    mov ds, ax 
    position 0, 0
    mov si, offset buffer
    cycle:                                  
    mov ah, 00h
    int 16h
    cmp ah, 48h
    je up
    cmp ah, 50h
    je down
    cmp ah, 4Bh
    je left
    cmp ah, 4Dh
    je right                             
    cmp ah, 1Ch
    je enter                                    
    cmp ah, 0Eh
    je backspace           
    cmp col_pos, 79
    je enter
    mov dl, al
    mov ah, 2
    int 21h        
    mov [si], al
    inc si
    inc char_num
    inc col_pos
    position row_pos, col_pos
    jmp cycle    
    up:
    cmp row_pos, 2
    je cycle 
    dec line_num
    dec row_pos
    position row_pos, col_pos
    jmp cycle   
    down:
    inc line_num
    inc row_pos
    position row_pos, col_pos 
    jmp cycle     
    left:
    dec col_pos
    position row_pos, col_pos
    jmp cycle
    right:
    inc col_pos
    position row_pos, col_pos
    jmp cycle 
    enter:      
    nextline
    mov [si], 10
    inc si
    inc line_num
    mov char_num, 0
    inc row_pos
    mov col_pos, 0
    position row_pos, col_pos
    jmp cycle
    backspace:
    cmp char_num, 0
    je pre_line
    backspace
    dec char_num
    dec col_pos
    dec si
    mov [si], 00h
    jmp cycle
    pre_line:
    cmp line_num, 2
    je cycle
    dec line_num
    dec row_pos
    mov char_num, 79
    mov col_pos, 79
    position row_pos, col_pos
    jmp cycle  
main endp
end main

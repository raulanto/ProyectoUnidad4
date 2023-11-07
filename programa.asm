print macro cadena  ; Esta macro imprime en pantalla una cadena y como parametro recibe la cadena a imprimir
    mov ah, 09h
    lea dx, cadena
    int 21h
endm      
leerNumero macro var 
    mov ah,01h
    int 21h
    sub al,30h   
    mov var,al
endm
pila segment stack  ; Segmento de pila
    db 32 DUP('stack--')
pila ends
datos segment  ; Segmento de datos
    mensaje_opciones db "1. Suma", 13, 10, "2. Resta", 13, 10, "3. Multiplicación", 13, 10, "4. Division", 13, 10, "5. Mostrar nombres $", 13, 10, "6. Salir $"
    resultado db 10,13,'El resultado es: $' 
    letrero db 10,13,'Ingrese un numero:  $' 
    mostrarNombres db "Rosado Jimenez Sergio Enrique", 13, 10, "Raul antonio de la cruz hernandez", 13, 10, "Bryan absalon Osorio Gallegos", 13, 10, "Miguel Ángel arguello lima", 13, 10, "eldrik gerardo lopez torrano $"
    color_pantalla db 02h  ; Color de pantalla
    color_letra db 0       ; Color de letra (negro por defecto)
    n1 db ?
    n2 db ?
    mensaje_error db 10, 13, 'Opcion no valida. Por favor, elija una opcion valida.', 10, 13, '$'
    error_division db 10,13,'Error: División por cero. Por favor, ingrese otro número.', 10,13,'$' 
    error_multiplicacion db 10,13,'Error no se puede multiplicar por 0', 10,13,'$'   
    residuo db 10,13, 'con residuo: $'
datos ends

codigo segment 'code'  ; Segmento de código
main proc FAR
    assume ss:pila, ds:datos, cs:codigo
    mov ax, datos
    mov ds, ax
    mostrar_menu:
    ; Limpia la pantalla
    call limpiarPantalla
    ; Posiciona el cursor
    mov dx, 1001h  
    call posicionarCursor
    print mensaje_opciones  
    print letrero
    mov ah, 01h  ; Solicita una opción al usuario
    int 21h

    cmp al, 31h  ; Compara las opciones que el usuario ingresa 
    je sub_opcion1
    cmp al, 32h
    je sub_opcion2
    cmp al, 33h
    je sub_opcion3
    cmp al, 34h
    je sub_opcion4
    cmp al, 35h
    je sub_opcion5
    cmp al, 36h
    je sub_opcion6

    ; Si el usuario ingresa un número que no está en las opciones, mostrar un mensaje de error
    print mensaje_error
    mov ah,01h
    int 21h 
    jmp mostrar_menu

  sub_opcion1:
    jmp opcion1
  sub_opcion2:
    jmp opcion2
  sub_opcion3:
    jmp opcion3
  sub_opcion4:
    jmp opcion4
  sub_opcion5:
    jmp opcion5
  sub_opcion6:
    jmp opcion6

opcion1:
    ; Suma
    call limpiarPantalla  
    call posicionarCursor
    print letrero
    
    leerNumero n1
    
    print letrero
    
    leerNumero n2
    
    ; proceso de suma
    
    mov al,n1
    mov bl,n2
    
    add bl,al 
    
    mov ax,0000h
    mov al,bl 
    
    AAA
    mov cx,ax 
    add cx,3030h
    print resultado
    mov ah,02h
    mov dl,ch
    int 21h
    mov ah,02h
    mov dl,cl
    int 21h
    mov ah,01h
    int 21h  
    jmp mostrar_menu
opcion2:
; Resta
    call limpiarPantalla
    call posicionarCursor
    print letrero
    leerNumero n1
    ;------------------
    print letrero
    leerNumero n2
    AAA
    ;------Resta-------
    mov bh, n1
    mov bl, n2

    sub bh, bl

    ; Verifica si el resultado es negativo
    cmp bh, 0
    jl resultado_negativo

    ; Si es positivo, muestra el resultado como lo haces normalmente
    print resultado

    mov ah, 02h
    mov dl, bh
    add dl, 30h
    int 21h
    mov ah,01h
    int 21h 
    jmp mostrar_menu

resultado_negativo:
    ; Si el resultado es negativo, muestra el signo "-" y luego el valor absoluto del resultado
    mov ah, 09h
    lea dx, resultado
    int 21h

    mov ah, 02h
    mov dl, '-'
    int 21h

    neg bh  ; Cambia el signo del resultado a positivo

    mov ah, 02h
    mov dl, bh
    add dl, 30h
    int 21h

    mov ah, 01h
    int 21h

    jmp mostrar_menu


opcion3:
    ; Multiplicacion
    call limpiarPantalla  
    call posicionarCursor
    print letrero
    
    leerNumero n1
    
    print letrero
    
    leerNumero n2
    ; Validar que ninguno de los números sea 0
    cmp n1, 0
    je multiplicacion_por_cero
    cmp n2, 0
    je multiplicacion_por_cero
    ; proceso de multiplicacion
    mov al,n1
    mov cl,n2
    mul cl
    mov cl,al
    mov ax,0000h
    mov al,cl 
    AAM
    mov cx,ax 
    add cx,3030h
    print resultado
    mov ah,02h
    mov dl,ch
    int 21h
    mov ah,02h
    mov dl,cl
    int 21h
    mov ah,01h
    int 21h 
    jmp mostrar_menu  
    multiplicacion_por_cero:
        ; Muestra un mensaje de error si alguno de los números es 0
        print error_multiplicacion
        mov ah,01h
        int 21h 
        jmp mostrar_menu
opcion4:
    ; Division
    call limpiarPantalla  
    call posicionarCursor
    print letrero8

    leerNumero n1

    print letrero8

    leerNumero n2

    ; Verificar si el divisor es 0
    cmp n2, 0
    je division_por_cero

    ; Proceso de división
    mov ax, 0h   ; Limpia el registro AX antes de la división
    mov al, n1   ; Guarda los dígitos en los registros AL y BL
    mov bl, n2   ; Es importante seguir este orden para obtener el resultado correcto
    div bl        ; Realiza la división
    mov cl, al    ; Guarda el resultado en el registro CL
                  ; Recuerda que el resultado de la división se guarda en AL y el residuo en AH

    ; Muestra el resultado
    print letrero9

    ; Mostrar el signo si es negativo
    mov ah, 02h
    mov dl, cl
    int 21h
    mov ah, 02h
    mov dl, residuo
    int 21h

    mov ah, 02h
    mov dl, ch
    int 21h

    ; Finaliza la cadena
    mov ah, 09h
    lea dx, final_cadena
    int 21h

    jmp mostrar_menu

division_por_cero:
    ; Muestra un mensaje de error si el divisor es 0
    print error_division
    jmp mostrar_menu
division_por_cero:
    ; Muestra un mensaje de error si el divisor es 0
    print error_division   
    mov ah,01h
    int 21h 
    jmp mostrar_menu

opcion5: 
    call limpiarPantalla  
    call posicionarCursor
    print mostrarNombres 
    mov ah,01h
    int 21h  
    jmp mostrar_menu

opcion6:
    mov ah, 4ch
    int 21h
ret

main endp
codigo ends
; Procedimiento para limpiar la pantalla
limpiarPantalla proc
    mov ah, 06h
    mov al, 00h
    mov bh, color_pantalla
    mov cx, 0000h
    mov dx, 184Fh
    int 10h
    ret
limpiarPantalla endp
; Procedimiento para posicionar el cursor en pantalla
posicionarCursor proc
    mov ah, 02h
    mov bh, 00h
    mov dx, 0000h  ; Las coordenadas donde irá el cursor deben pasarse como argumento
    int 10h
    ret
posicionarCursor endp      
end main
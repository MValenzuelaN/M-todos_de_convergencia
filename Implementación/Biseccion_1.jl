# ----------------------------------------------------------------
#            MÉTODO DE BISECCIÓN
# ----------------------------------------------------------------
# Propósito: Encontrar la raíz de f(x) = e^{-x} - x en [0,1]
# Tolerancia: 1e-6
# ----------------------------------------------------------------

# Proporciona una forma limpia de imprimir los resultados en una tabla.

# ------ Código para instalar el paquete necesario
# using Pkg
# Pkg.add("Printf")
# ------
using Printf

# --- Implementación del Método
"""
    biseccion(f, a, b, tol)

Encuentra la raíz de la función `f` en el intervalo `[a, b]` utilizando una
versión optimizada del método de bisección.

# Argumentos
- `f`: La función a evaluar.
- `a`: El límite inferior del intervalo.
- `b`: El límite superior del intervalo.
- `tol`: La tolerancia o error admisible para la raíz.

# Documentación
1.  `fa` se calcula una sola vez antes de iniciar el bucle.
2.  Dentro del bucle, la condición `if fa * fc < 0` reutiliza el valor `fa`
    previamente calculado.
3.  `fa` solo se actualiza si el extremo `a` del intervalo cambia, asignándole
    el valor `fc` que ya conocemos. Esto elimina una llamada a `f(x)` en
    cada iteración.
"""
function biseccion(f, a, b, tol)
    # === Paso 1: Verificación Inicial
    fa = f(a) # Calculamos f(a) una sola vez.

    # Verificamos que f(a) y f(b) tengan signos opuestos.
    if fa * f(b) >= 0
        println("Error: No se puede asegurar una raíz en el intervalo dado, f(a) y f(b) deben tener signos opuestos.")
        return nothing
    end

    # --- Inicialización
    iter = 0
    c = a # Inicializamos 'c'

    println("--- Iniciando Método de Bisección ---")
    println("Iteración |Cóta inferior|Cóta superior|  Raíz aprox | error")
    println("--------------------------------------------------------------------")

    # == Paso 2: Bucle Iterativo
    # El criterio de parada es que el tamaño del intervalo (b-a) sea menor que la tolerancia.
    while (b - a) > tol
        iter += 1

        # Calculamos el punto medio y el valor de la función en ese punto.
        c = (a + b) / 2
        fc = f(c)

        # Imprimimos los resultados de la iteración.
        @printf("%9d | %11.7f | %11.7f | %11.7f | %1.4e\n", iter, a, b, c, fc)

        # === Paso 3: Decidir el Subintervalo
        # Si fc es cero, hemos encontrado la raíz exacta.
        if fc == 0
            break # Salimos del bucle.
        end

        # Comparamos signos para reducir el intervalo.
        if fa * fc < 0
            # La raíz está en [a, c]. Actualizamos el extremo 'b'.
            b = c
            # 'fa' no cambia, así que no necesitamos recalcularlo.
        else
            # La raíz está en [c, b]. Actualizamos el extremo 'a' y el valor 'fa'.
            a = c
            fa = fc # Reutilizamos el valor f(c) ya calculado.
        end
    end

    # --- Resultados Finales
    println("--------------------------------------------------------------------")
    println("\nConvergencia alcanzada.")
    @printf("La raíz aproximada es: %.7f\n", c)
    @printf("El valor de f(c) es: %e\n", f(c))
    println("Número total de iteraciones: $iter")

    return c
end

"""
    main()

Función principal que ejecuta el programa.
Esto ayuda a organizar el código y a aprovechar la compilación JIT de Julia.
"""
function main()
    # --- Definición de la Función
    """
        f(x)
    Define la función matemática a la que le buscaremos la raíz.
    En este caso, f(x) = e^(-x) - x.
    """
    f(x) = exp(-x) - x

    # Parámetros del problema
    a = 0.0          # Límite inferior del intervalo
    b = 1.0          # Límite superior del intervalo
    tolerancia = 1e-6 # 10 elevado a la -6

    # Llamamos a la función de bisección con los parámetros definidos.
    raiz_encontrada = biseccion(f, a, b, tolerancia)
end

# Ejecutamos la función principal para iniciar el script.
main()
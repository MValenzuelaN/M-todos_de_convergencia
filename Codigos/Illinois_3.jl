# ----------------------------------------------------------------
#               MÉTODO DE ILLINOIS
# ----------------------------------------------------------------
# Propósito: Encontrar la raíz de f(x) = x^3 - x - 1 en [1,2]
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
    illinois(f, a, b, tol, max_iter)

Encuentra la raíz de la función `f` en el intervalo `[a, b]` utilizando el
método de Illinois, una versión mejorada de Regula Falsi.

# Argumentos
- `f`: La función a evaluar.
- `a`: El límite inferior del intervalo.
- `b`: El límite superior del intervalo.
- `tol`: La tolerancia para el valor de f(c). El bucle termina cuando |f(c)| < tol.
- `max_iter`: Número máximo de iteraciones para evitar bucles infinitos.

# Documentación de la Optimización
La modificación clave de Illinois previene el estancamiento de uno de los extremos
del intervalo. Si un extremo (ej. `a`) se mantiene por segunda vez consecutiva,
su valor de función `fa` se divide por 2 para el siguiente cálculo de `c`.
Esto acelera significativamente la convergencia.
"""
function illinois(f, a, b, tol, max_iter)
    # === Paso 1: Verificación Inicial
    # Calculamos f(a) y f(b) una sola vez antes del bucle.
    fa = f(a)
    fb = f(b)

    # Verificamos que la raíz realmente exista en el intervalo [a, b].
    if fa * fb >= 0
        println("Error: No se puede asegurar una raíz en el intervalo dado, f(a) y f(b) deben tener signos opuestos.")
        return nothing
    end

    # --- Inicialización
    c = a
    fc = fa
    lado_sin_cambio = 0 # Variable para rastrear el lado estancado: 0=ninguno, 1=a, 2=b

    println("--- Iniciando Método de Illinois ---")
    println("Iteración |Cóta inferior|Cóta superior|  Raíz aprox | error")
    println("--------------------------------------------------------------------")

    # === Paso 2: Bucle Iterativo
    for iter = 1:max_iter
        # Evitamos la división por cero si los valores
        # de la función en los puntos b y a son idénticos.
        if (fb - fa) == 0
            println("Error: División por cero. f(b) y f(a) son iguales.")
            return nothing
        end

        # Calculamos la nueva aproximación 'c' y f(c).
        c = (a * fb - b * fa) / (fb - fa)
        fc = f(c)

        # Imprimimos los resultados de la iteración actual.
        @printf("%9d | %11.7f | %11.7f | %11.7f | %1.4e\n", iter, a, b, c, fc)

        # === Paso 3: Criterio de Parada
        if abs(fc) < tol
            println("--------------------------------------------------------------------")
            println("\nConvergencia alcanzada.")
            @printf("La raíz aproximada es: %.7f\n", c)
            @printf("El valor de f(c) es: %e\n", fc)
            println("Número total de iteraciones: $iter")
            return c
        end

        # === Paso 4: Actualizar el Intervalo con la Lógica de Illinois
        if fa * fc < 0
            # La raíz está en [a, c]. El punto 'a' no se movió.
            b = c
            # Si 'a' fue el lado que tampoco se movió la vez pasada,
            # penalizamos su contribución dividiendo su valor de función por 2.
            if lado_sin_cambio == 1
                fa /= 2
            end
            fb = fc
            lado_sin_cambio = 1 # Marcamos que 'a' fue el lado estancado en esta iteración.
        else
            # La raíz está en [c, b]. El punto 'b' no se movió.
            a = c
            # Si 'b' fue el lado estancado la vez pasada, lo penalizamos.
            if lado_sin_cambio == 2
                fb /= 2
            end
            fa = fc
            lado_sin_cambio = 2 # Marcamos que 'b' fue el lado estancado.
        end
    end

    # --- Mensaje de Salida si no hay Convergencia
    println("--------------------------------------------------------------------")
    println("\nSe alcanzó el número máximo de iteraciones ($max_iter) sin converger a la tolerancia deseada.")
    @printf("La aproximación alcanzada de la raíz es: %.7f\n", c)
    return c
end

"""
    main()

Función principal que ejecuta el programa.
"""
function main()
    # --- Definición de la Función ---
    """
        f(x)
    Define la función matemática a la que le buscaremos la raíz.
    En este caso, f(x) = x^3 - x - 1.
    """
    f(x) = x^3 - x - 1

    # Parámetros del problema
    a = 1.0           # Límite inferior del intervalo
    b = 2.0           # Límite superior del intervalo
    tolerancia = 1e-6 # Tolerancia de convergencia
    max_iter = 100    # Límite de iteraciones

    # Llamamos a la función de Illinois.
    raiz_encontrada = illinois(f, a, b, tolerancia, max_iter)
end

# --- Ejecución del Script
main()
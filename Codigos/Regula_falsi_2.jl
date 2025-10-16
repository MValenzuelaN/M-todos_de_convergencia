# ----------------------------------------------------------------
#            MÉTODO DE REGULA FALSI
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
    regula_falsi(f, a, b, tol, max_iter)

Encuentra la raíz de la función `f` en el intervalo `[a, b]` utilizando una
el método de Regula Falsi.

# Argumentos
- `f`: La función a evaluar.
- `a`: El límite inferior del intervalo.
- `b`: El límite superior del intervalo.
- `tol`: La tolerancia para el valor de f(c). El bucle termina cuando |f(c)| < tol.
- `max_iter`: Número máximo de iteraciones para evitar bucles infinitos.

# Documentación de la Optimización
1.  `fa` y `fb` se calculan una sola vez antes de iniciar el bucle.
2.  Dentro del bucle, actualizamos el valor que corresponde al extremo del
    intervalo que se mueve. Por ejemplo, si `b` se reemplaza por `c`, entonces
    `fb` se actualiza con el valor de `fc` ya calculado.
"""
function regula_falsi(f, a, b, tol, max_iter)
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
    c = a # Inicializamos 'c' para tener un valor por defecto.
    fc = fa

    println("--- Iniciando Método de Regula Falsi ---")
    println("Iteración |Cóta inferior|Cóta superior|  Raíz aprox | error")
    println("--------------------------------------------------------------------")

    # === Paso 2: Bucle Iterativo
    for iter = 1:max_iter
        # Calculamos la nueva aproximación 'c' y f(c).
        # Esta es la única llamada a `f(x)` que se necesita por iteración (después del primer paso).
        c = (a * fb - b * fa) / (fb - fa)
        fc = f(c)

        # Imprimimos los resultados de la iteración actual.
        @printf("%9d | %11.7f | %11.7f | %11.7f | %1.4e\n", iter, a, b, c, fc)

        # === Paso 3: Criterio de Parada
        if abs(fc) < tol
            println("--------------------------------------------------------------------")
            println("\nConvergencia alcanzada.")
            @printf("La raíz aproximada es: %.7f\n", c)
            @printf("El valor de f(c) es: %e\n", fc) # Usamos fc, que ya está calculado.
            println("Número total de iteraciones: $iter")
            return c
        end

        # === Paso 4: Actualizar el Intervalo
        # Comparamos los signos para decidir qué extremo del intervalo actualizar.
        if fa * fc < 0
            # La raíz está en [a, c]. Actualizamos b y fb.
            b = c
            fb = fc # No recalculamos f(b), reutilizamos f(c).
        else
            # La raíz está en [c, b]. Actualizamos a y fa.
            a = c
            fa = fc # No recalculamos f(a), reutilizamos f(c).
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
Envolver el código en una función `main` ayuda a organizar el script y permite
que el compilador JIT (Just-In-Time) de Julia prepare el precompilado para
optimizar ejecuciones posteriores.
"""
function main()
    # --- Definición de la Función
    """
        f(x)
    Define la función matemática a la que le buscaremos la raíz.
    En este caso, f(x) = x^3 - x - 1.
    """
    f(x) = x^3 - x - 1

    # Parámetros del problema
    a = 1.0          # Límite inferior del intervalo
    b = 2.0          # Límite superior del intervalo
    tolerancia = 1e-6 # Tolerancia de convergencia
    max_iter = 100   # Límite de iteraciones

    # Llamamos a la función de regula falsi.
    raiz_encontrada = regula_falsi(f, a, b, tolerancia, max_iter)
end

# --- Ejecución del Script
# Al ejecutar el script, esta será la primera línea que se corra.
main()
# ----------------------------------------------------------------
#           MÉTODO DE LA SECANTE
# ----------------------------------------------------------------
# Propósito: Encontrar la raíz de f(x) = x^3 - x - 1
# Puntos Iniciales: x0 = 1, x1 = 2
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
    secante(f, x0, x1, tol, max_iter)

Encuentra la raíz de la función `f` utilizando el método de la secante.

# Argumentos
- `f`: La función a evaluar.
- `x0`: El primer punto de la aproximación inicial.
- `x1`: El segundo punto de la aproximación inicial.
- `tol`: Tolerancia para el criterio de parada. El bucle termina cuando el cambio
         entre aproximaciones sucesivas, |x_nuevo - x_viejo|, es menor que `tol`.
- `max_iter`: Número máximo de iteraciones para evitar bucles infinitos.

# Documentación de la Optimización
Este código ya es eficiente porque minimiza las llamadas a `f(x)`:
1.  `fx0` y `fx1` se calculan solo una vez antes de iniciar el bucle.
2.  Dentro del bucle, los valores se actualizan de forma inteligente. El antiguo `x1`
    se convierte en el nuevo `x0`, y su valor `fx1` se reutiliza como `fx0` sin
    necesidad de recalcularlo. Esto reduce las llamadas a `f(x)` a solo una por iteración.
"""
function secante(f, x0, x1, tol, max_iter)
    # === Paso 1: Inicialización
    # Calculamos los valores de la función para los puntos iniciales.
    fx0 = f(x0)
    fx1 = f(x1)

    println("--- Iniciando Método de la Secante ---")
    println("Iteración |Cóta inferior|Cóta superior|  Raíz aprox | error")
    println("-------------------------------------------------------------------------")

    # Imprimimos el estado inicial para mayor claridad.
    @printf("%9s | %11.7f | %11.7f | %11s | %1.4e\n", "Inicio", x0, x1, "", fx1)

    # === Paso 2: Bucle Iterativo
    for iter = 1:max_iter
        # Evitamos la división por cero si los valores
        # de la función en los puntos x0 y x1 son idénticos.
        if (fx1 - fx0) == 0
            println("Error: División por cero. f(x1) y f(x0) son iguales.")
            return nothing
        end

        # Fórmula de la secante para encontrar la nueva aproximación 'c'.
        c = x1 - fx1 * (x1 - x0) / (fx1 - fx0)

        # === Paso 3: Criterio de Parada
        # Verificamos si la diferencia entre la nueva y la anterior aproximación
        # es menor que la tolerancia. Este es un criterio de parada robusto.
        if abs(c - x1) < tol
            fc = f(c) # Calculamos f(c) final solo para mostrarlo.
            @printf("%9d | %11.7f | %11.7f | %11.7f | %1.4e\n", iter, x0, x1, c, fc)
            println("-------------------------------------------------------------------------")
            println("\nConvergencia alcanzada.")
            @printf("La raíz aproximada es: %.7f\n", c)
            @printf("El valor de f(c) es: %e\n", fc)
            println("Número total de iteraciones: $iter")
            return c
        end

        # Calculamos f(c) para la siguiente iteración.
        fc = f(c)
        @printf("%9d | %11.7f | %11.7f | %11.7f | %1.4e\n", iter, x0, x1, c, fc)

        # === Paso 4: Actualización para la Siguiente Iteración
        # Desplazamos los puntos: x1 pasa a ser x0, y c pasa a ser x1.
        x0 = x1
        fx0 = fx1 # Reutilizamos el valor ya calculado.

        x1 = c
        fx1 = fc  # Reutilizamos el valor ya calculado.
    end

    # --- Mensaje de Salida si no hay Convergencia
    println("-------------------------------------------------------------------------")
    println("\nSe alcanzó el número máximo de iteraciones ($max_iter) sin converger.")
    @printf("La última aproximación de la raíz fue: %.7f\n", c)
    return c
end

"""
    main()

Función principal que ejecuta el programa, encapsulando la lógica principal
para beneficiarse de la compilación JIT (Just-In-Time) de Julia.
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
    x0 = 1.0          # Primer punto inicial
    x1 = 2.0          # Segundo punto inicial
    tolerancia = 1e-6 # Tolerancia de convergencia
    max_iter = 100    # Límite de iteraciones

    # Llamamos a la función de la secante.
    raiz_encontrada = secante(f, x0, x1, tolerancia, max_iter)
end

# --- Ejecución del Script ---
main()
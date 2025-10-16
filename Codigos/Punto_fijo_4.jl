# ----------------------------------------------------------------
#               MÉTODO DE PUNTO FIJO
# ----------------------------------------------------------------
# Problema ejemplo: Encontrar el punto fijo de g(x) = cos(x)
#                   que es la raíz de f(x) = cos(x) - x
# Punto inicial: x0 = 0.5, Tolerancia: 1e-6
# ----------------------------------------------------------------

using Printf

"""
    punto_fijo(g, x0, tol, max_iter; f = x -> g(x) - x)

Encuentra un punto fijo de `g` usando una iteración simple.
La función imprime una tabla con el progreso de las iteraciones.

# Argumentos
- `g`: La función de iteración.
- `x0`: La aproximación inicial.
- `tol`: La tolerancia para el criterio de parada `|x_{k+1} - x_k| < tol`.
- `max_iter`: El número máximo de iteraciones permitidas.

# Keyword
- `f`: Función cuyo cero coincide con el punto fijo (por defecto, `f(x)=g(x)-x`).
         Se usa para calcular el residuo final.

# Retorna
Un `NamedTuple` con los siguientes campos:
- `p`: La aproximación final al punto fijo.
- `residuo`: El valor de `f(p)`.
- `iter`: El número de iteraciones realizadas.
- `convergencia`: `true` si se alcanzó la tolerancia, `false` en caso contrario.
"""
function punto_fijo(g, x0, tol, max_iter; f=x -> g(x) - x)
    # --- Inicialización
    xk = x0
    k = 0
    convergencia = false

    println("--- Iniciando Método de Punto Fijo ---")
    println("Iteración |      x_k       |    x_{k+1}=g(x_k)   |    error")
    println("------------------------------------------------------------------")

    # === Bucle Iterativo
    while k < max_iter
        k += 1
        xkp1 = g(xk)
        err = abs(f(xkp1))

        # Imprimimos los resultados de la iteración actual
        @printf("%9d | %14.7f | %18.7f | %12.4e\n", k, xk, xkp1, err)

        # === Criterio de Parada
        # Comparamos la distancia entre iteraciones sucesivas
        if abs(xkp1 - xk) < tol
            convergencia = true
            xk = xkp1 # Guardamos el último valor calculado
            break    # Salimos del bucle
        end

        # Actualizamos para la siguiente iteración
        xk = xkp1
    end

    println("------------------------------------------------------------------")

    # === Empaquetamos los resultados para retornarlos
    # La función ya no imprime el resumen, solo devuelve los datos.
    return (p=xk, residuo=f(xk), iter=k, convergencia=convergencia)
end

"""
    main()

Función principal que define el problema y ejecuta el método de punto fijo.
Se encarga de mostrar los resultados finales al usuario.
"""
function main()
    # --- Definición del Problema
    # Buscamos la raíz de f(x), que es el punto fijo de g(x)
    f(x) = cos(x) - x
    g(x) = cos(x)

    # --- Parámetros del Método
    x0 = 0.5             # Aproximación inicial
    tolerancia = 1e-8    # Tolerancia más estricta para mayor precisión
    max_iter = 100       # Máximo de iteraciones

    # Llamamos a la función de punto fijo
    resultado = punto_fijo(g, x0, tolerancia, max_iter; f=f)

    # --- Presentación de Resultados
    # La lógica de qué imprimir está ahora en main(), no en punto_fijo()
    println("\n--- Resumen de Resultados ---")
    if resultado.convergencia
        println("Convergencia alcanzada exitosamente.")
    else
        println("Se alcanzó el máximo de iteraciones sin cumplir la tolerancia.")
    end

    @printf("Punto fijo aproximado p ≈ %.12f\n", resultado.p)
    @printf("Residuo (error)      f(p) = %.3e\n", resultado.residuo)
    println("Iteraciones realizadas: ", resultado.iter)
end

# Ejecutamos la función principal para iniciar el script
main()

# ----------------------------------------------------------------
#               MÉTODO DE STEFFENSEN
# ----------------------------------------------------------------
# Propósito: Acelerar la convergencia de g(x) = cos(x) para
#            encontrar la raíz de f(x) = cos(x) - x.
# Punto Inicial: x0 = 0.5
# Tolerancia: 1e-6
# ----------------------------------------------------------------

using Printf

"""
    steffensen(g, f, x0; tol=1e-6, max_iter=100)

Acelera la iteración de punto fijo `x = g(x)` mediante el método de Steffensen
(Aitken Δ²) y reporta en cada fila: iteración, x₀ (valor actual), x₁ (nuevo valor)
y el "error" definido como `f(x₁)`.

Parámetros (keys):
- `tol`: criterio de paro basado en |x₁ - x₀|.
- `max_iter`: límite superior de iteraciones.

Retorna:
- La última aproximación encontrada (raíz aproximada).
"""
function steffensen(g, f, x0; tol, maxiter)
    x = x0

    println("--- Método de Steffensen ---")
    println("Iteración|           x_k            |      x_{k+1}=g(x_k)      |    error")
    println("------------------------------------------------------------------------------")

    for k in 1:maxiter
        x1 = g(x)
        x2 = g(x1)

        denom = x2 - 2x1 + x
        # Evitar división numéricamente inestable
        if isapprox(denom, 0.0; atol=10 * eps(float(x)), rtol=0.0)
            println("\nDenominador ≈ 0 en la iteración $k: no se puede aplicar la aceleración.")
            break
        end

        xnew = x - (x1 - x)^2 / denom
        err = f(xnew)  # "error" pedido: f(raíz aprox)

        @printf("%8d | %24.12f | %24.12f | %13.6e\n", k, x, xnew, err)

        if abs(xnew - x) < tol
            println("-------------------------------------------------------------------------------")
            @printf("Raíz aproximada : %.12f\n", xnew)
            @printf("f(raíz aprox)    : %.6e\n", f(xnew))
            println("Iteraciones      : $k")
            return xnew
        end

        x = xnew
    end

    println("-------------------------------------------------------------------------------------------")
    @printf("Última aproximación: %.12f\n", x)
    @printf("f(última)          : %.6e\n", f(x))
    return x
end

"""
    main()

Ejemplo: g(x) = cos(x), f(x) = cos(x) - x.
"""
function main()
    g(x) = cos(x)
    f(x) = cos(x) - x

    x0 = 0.5
    tolerancia = 1e-6
    max_iter = 100

    _ = steffensen(g, f, x0; tol=tolerancia, maxiter=max_iter)
end

main()

# Tarea: Tic Tac Toe

Juego de Tres en Raya contra la computadora, que tratara de bloquear tu camino. El juego se define en base a sumas de columnas, filas y diagonales diferentes para el jugador 1 y el jugador AI.

Empezamos con estos valores:

const X = 1
const O = 10 # Para la computadora

```
Para verificar el ganador, hacemos sumas de las columnas, filas y diagonales de la siguiente manera: Si una columna suma 3 * X entonces el ganador es el jugador 1, mientras que si suma 3 * O el ganador es la computadora.

AI logic is as follows:
  * Check for a winning move (do any row,col,diag sums == 20 or 2*O)
  * If no winning move, check for a block (prevent the player from winning if they have a score of 2 in a row, column or diagonal.
  * If neither of the above, just select a random square.

La computadora tratará primero de ganar, verificando si puede sumar 2 * O o 3 * O; caso contrario buscará bloquearnos si nosotros tenemos un movimiento que sume 2 * O o 3 * O.
Finalmente, y generalmente al principio, escogerá un espacio vacío al azar.

```

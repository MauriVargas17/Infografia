extends Control

onready var board = [ [$TicTacButton1, $TicTacButton2, $TicTacButton3],
					  [$TicTacButton4, $TicTacButton5, $TicTacButton6],
					  [$TicTacButton7, $TicTacButton8, $TicTacButton9], 
					]

onready var winDialog = $WinDialog

const X = 1
const O = 10

var activePlayer = X
var currentRound = 0
var winner = false

func _ready():

	for row in board:
		for btn in row:
			btn.connect( "custom_pressed", self, "onTicTacBtnPressed" )
	

	var cancelBtn = winDialog.get_cancel()
	cancelBtn.set_text("Salir")
	cancelBtn.connect("pressed", self, "onQuit")
	winDialog.get_ok().set_text("Jugar de Nuevo")

func clearBoard():
	
	currentRound = 0
	winner = false
	activePlayer = X
	
	for row in board:
		for btn in row:
			btn.reset()

func placeMark( row, col, player ):
	
	if player == X:
		board[row][col].setX(X)
		activePlayer = O
	else:
		board[row][col].setO(O)
		activePlayer = X

	currentRound += 1

	checkWin()

	if currentRound == 9:
		showWinDialog("Empate", "El juego termina en empate")
		
	elif activePlayer == O and not winner:
		
		$Tween.interpolate_callback( self, 0.5 + randf(), "aiPicPoint" )
		$Tween.start()

func sumRow( rowNum ):

	var sum = 0
	for btn in board[rowNum]:
		sum += btn.value
	return sum

func sumCol( colNum):

	var sum = 0
	for row in board:
		sum += row[ colNum ].value
	return sum

func sumDiag_1():
	
	var sum = 0
	for idx in range(3):
		sum += board[idx][idx].value
		
	return sum

func sumDiag_2():
	
	var sum = 0 
	for idx in range(3):
		sum += board[idx][2-idx].value
	return sum

func showWinDialog( title, text ):
	
	winner = true
	winDialog.window_title = title
	winDialog.dialog_text = text
	winDialog.show()

func checkWin():
	
	var row = 0
	var col = 0
	var d1 = 0
	var d2 = 0
	
	for idx in range(3):
		row = sumRow(idx)
		# print( "Row %d Sum: %d" % [idx,row] )
		if row == 3:
			showWinDialog( "El jugador 1 gana", "Gana con 3 X en fila " + str(idx+1) )
		elif row == 30:
			showWinDialog( "El jugador 2 gana", "Gana con 3 O en fila " + str(idx+1) )
			
		col = sumCol(idx)
		# print( "Col %d Sum: %d" % [idx, col] )
		if col == 3:
			showWinDialog( "El jugador 1 gana", "Gana con 3 X en columna " + str(idx+1) )
		elif col == 30:
			showWinDialog( "El jugador 2 gana", "Gana con 3 O en columna "  + str(idx+1) )
		
	d1 = sumDiag_1()
	d2 = sumDiag_2()
	
	if d1 == 3 or d2 == 3:
		showWinDialog( "El jugador 1 gana", "Gana con 3 O en la diagonal "  )
	elif d1 == 30 or d2 == 30:
		showWinDialog( "El jugador 2 gana", "Gana con 3 O en la diagonal " )
	
	
func onTicTacBtnPressed( button ):
	
	if activePlayer == X:
		print("Apretando (%d, %d)" % [button.row, button.col] )
		
		if board[button.row][button.col].value != 0:
			print("Espacio ocupado")
		else:
			placeMark( button.row, button.col, activePlayer )
		

func aiFillRow( row ):

	for column in range(3):
		if board[ row ][ column ].value == 0:
			placeMark( row, column, activePlayer )

func aiFillCol( col ):
	
	for row in range(3):
		if board[ row ][ col ].value == 0:
			placeMark( row, col, activePlayer )

func aiFillDiag_1():
	
	for idx in range(3):
		if board[idx][idx].value == 0:
			placeMark( idx, idx, activePlayer )

func aiFillDiag_2():
	
	for idx in range(3):
		if board[idx][2-idx].value == 0:
			placeMark( idx, 2-idx, activePlayer )

func aiPicWinningFill():
	
	for idx in range(3):
		if sumRow( idx ) == 20:
			
			aiFillRow( idx )
			return true
		elif sumCol( idx ) == 20:
			
			aiFillCol( idx )
			return true
	if sumDiag_1() == 20:
		
		aiFillDiag_1()
		return true
	elif sumDiag_2() == 20:
		
		aiFillDiag_2()
		return true
		
	return false

func aiBlock():

	for idx in range(3):
		if sumRow( idx ) == 2:
			
			aiFillRow( idx )
			return true
		elif sumCol( idx ) == 2:
			aiFillCol( idx )
			return true
	if sumDiag_1() == 2:
		aiFillDiag_1()
		return true
	elif sumDiag_2() == 2:
		aiFillDiag_2()
		return true
	
	return false

func aiPicPoint():
	
	if not aiPicWinningFill():
		if not aiBlock():
			var row = randi() % 3
			var col = randi() % 3
			var valid = false
			
			# FIXME: This is a terrible way to do this
			while not valid:
				if board[row][col].value == 0:
					valid = true
				else:
					row = randi() % 3
					col = randi() % 3
				
			placeMark( row, col, activePlayer )

func onPlayAgain():
	clearBoard()

func onQuit():
	get_tree().quit()


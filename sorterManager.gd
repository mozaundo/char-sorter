class_name SorterManager
extends Node

var questionCount = 0

var arraySorter : ArraySorter

var chars : Array[Character] 
var testArr : Array[Character] 
var results : Array[CharArray] 

@export var leftHalf : ChoiceHalf
@export var rightHalf : ChoiceHalf

signal onAnswer

var lastItem : Character
var lastGreater : bool

var answerCalls : Array[Callable]
var sortCall : Callable

var sortActive = false
var currentChar : Character
var currentArr : Array[Character]
var lastLimitIndex : int = -1
var lastRemains : int = 0
var lastAnswer : bool = true

func _ready() -> void:
	leftHalf.choiceMade.connect(choiceMade)
	rightHalf.choiceMade.connect(choiceMade)
	
	chars = SceneManager.charPool.duplicate(true)
	chars.shuffle()
	
	arraySorter = $ArraySorter
	
	nextStep()
	
	"""
	await initArray()
	print(printCharArr(testArr))
	for chara in chars:
		await sortInto(chara, testArr)
		print(printCharArr(testArr))
	print("done")
	"""

func nextStep():
	print("next step")
	if (sortActive):
		if (lastRemains <= 0):
			sortReset()
			nextStep()
			return
		print("sort is active")
		sortInto(currentChar, currentArr, lastLimitIndex, lastRemains, lastAnswer)
	else:
		arraySorter.nextStep()

func printCharArr(arr:Array[Character]) -> String:
	var x = "["
	for chara in arr:
		x += chara.name + ", " 
	x += "]"
	return x
func printResults():
	var x = ""
	for chArr in results:
		x += printCharArr(chArr.arr)
		x += "; "
	print(x)

func sortInto(chara:Character, arr:Array[Character], limitIndex := -1, remains := 0, lastRight := true):
	#add sortCall.call()
	print("started sortinto with limitIndex is " + str(limitIndex))
	sortActive = true
	
	if (arr.size() <= 1):
		printerr("(USER) Array of invalid size")
		return
	
	var item1 = chara
	var item2
	#print (str(remains) + " and " + str(limitIndex))
	#print(lastRight)
	
	if (remains == 0):
		remains = arr.size()
	
	#finding item2
	if (limitIndex == -1):
		item2 = arr[arr.size() / 2 - 1 + arr.size() % 2]
	elif (remains == 1):
		var x
		#print("ONE REMAINS")
		if (!lastRight):
			x = limitIndex + 2
		else:
			x = limitIndex - 2
		#print("item2 index is " + str(x))
		item2 = arr[x]
	else:
		var x
		#print("ELSE HUH")
		if (!lastRight):
			x = limitIndex + 1 + (remains / 2 + remains % 2)
		else:
			x = limitIndex - 1 - (remains / 2) - 1
		item2 = arr[x]
	
	askQuestion(item1, item2)
	var callback = func(answer:bool):
		print("limitIndex callback is " + str(limitIndex))
		if (limitIndex != -1):
			arr.erase(item1)
		
		var index = arr.find(item2)
		if (!answer):
			arr.insert(index + 1, item1)
		else:
			arr.insert(index, item1)
			index += 1
		
		if (remains == 2 and answer):
			print("Picked less of two")
			sortReset()
			return
		elif (remains == 1):
			print("Only one remains")
			sortReset()
			return
		
		var count = countUnchecked(arr, index, !answer, 1)
		
		if (limitIndex != -1):
			var x
			if (!answer):
				x = remains / 2
				count = clamp(count, 0, x)
			else:
				x = max(1, remains / 2 - (1 - remains % 2))
				count = clamp(count, 0, x)
		
		#print("count " + str(count))
		
		currentChar = chara
		currentArr = arr
		lastLimitIndex = index
		lastRemains = count
		lastAnswer = answer
	
	answerCalls.append(callback)

func sortReset():
	lastLimitIndex = -1
	lastRemains = 0
	lastAnswer = true
	sortActive = false
	print("set sortActive " + str(sortActive))
	
	if (!sortCall.is_null()):
		print(sortCall)
		sortCall.call()
	sortCall = Callable()

func countUnchecked(arr:Array, i:int, right:bool, offset := 0) -> int:
	#print("count size " + str(arr.size()) + str(right))
	if (right):
		return (arr.size() - i - 1) - offset
	else:
		return i - offset

#pass to ui
func askQuestion(x:Character, y:Character):
	questionCount += 1
	leftHalf.setupCharacter(x)
	rightHalf.setupCharacter(y)

func choiceMade(x:bool) -> void:
	for callback in answerCalls:
		callback.call(x)
	answerCalls.clear()
	onAnswer.emit()
	printResults()
	nextStep()

func sortEnd():
	SceneManager.ranking = results[0].arr
	SceneManager.loadRanking()

class CharArray:
	var arr : Array[Character]

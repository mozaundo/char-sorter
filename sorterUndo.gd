extends Node

#var undoRedo : UndoRedo = UndoRedo.new()
@export var undoButton : Button

@onready var sorter : SorterManager = $".."
@onready var arraySorter : ArraySorter = $"../ArraySorter"

var undoArray : Array[SorterStep] = []
var firstUndo : bool = false
var undoCount : int = 0

func _ready() -> void:
	undoButton.button_down.connect(undo)
	undoButton.disabled = true

func addUndo() -> void:
	print("undoAdded")
	var step : SorterStep = SorterStep.new()
	
	step.chars = sorter.chars.duplicate()
	copyResults(step.results, sorter.results)
	copyCalls(step.answerCalls, sorter.answerCalls)
	step.sortCall = Callable(sorter.sortCall)
	step.sortActive = sorter.sortActive
	#step.currentChar = sorter.currentChar.duplicate()
	step.currentChar = sorter.currentChar
	step.currentArr = sorter.currentArr.duplicate()
	step.lastLimitIndex = sorter.lastLimitIndex
	step.lastAnswer = sorter.lastAnswer
	step.lastRemains = sorter.lastRemains
	
	step.arr1 = arraySorter.arr1.duplicate()
	step.arr2 = arraySorter.arr2.duplicate()
	step.lastItem = arraySorter.lastItem
	step.clashIndex = arraySorter.clashIndex
	step.phase = arraySorter.phase
	
	undoArray.append(step)
	
	"""undoRedo.create_action("step")
	undoRedo.add_undo_property(sorter, "chars", sorter.chars.duplicate())
	undoRedo.add_undo_property(sorter, "results", sorter.results.duplicate())
	undoRedo.add_undo_property(sorter, "answerCalls", sorter.answerCalls.duplicate(true))
	undoRedo.add_undo_property(sorter, "sortCall", Callable(sorter.sortCall))
	undoRedo.add_undo_property(sorter, "sortActive", sorter.sortActive)
	undoRedo.add_undo_property(sorter, "currentChar", sorter.currentChar.duplicate())
	undoRedo.add_undo_property(sorter, "currentArr", sorter.currentArr.duplicate())
	undoRedo.add_undo_property(sorter, "lastLimitIndex", sorter.lastLimitIndex)
	undoRedo.add_undo_property(sorter, "lastAnswer", sorter.lastAnswer)
	undoRedo.add_undo_property(sorter, "lastRemains", sorter.lastRemains)
	
	undoRedo.add_undo_property(arraySorter, "arr1", arraySorter.arr1.duplicate())
	undoRedo.add_undo_property(arraySorter, "arr2", arraySorter.arr2.duplicate())
	undoRedo.add_undo_property(arraySorter, "lastItem", arraySorter.lastItem.duplicate())
	undoRedo.add_undo_property(arraySorter, "clashIndex", arraySorter.clashIndex)
	undoRedo.add_undo_property(arraySorter, "phase", arraySorter.phase)
	
	undoRedo.commit_action()"""
	
	undoCount += 1
	
	firstUndo = true
	
	checkButton()

func copyResults(source:Array[SorterManager.CharArray], input:Array[SorterManager.CharArray]):
		source.clear()
		for chArr in input:
			var x = SorterManager.CharArray.new()
			x.arr = chArr.arr.duplicate()
			source.append(x)

func copyCalls(source:Array[Callable], input:Array[Callable]):
	source.clear()
	for callback in input:
		source.append(Callable(callback))

func undo():
	undoArray.remove_at(undoArray.size() - 1)
	undoCount -= 1
	await loadStep()
	
	#print(sorter.printCharArr(sorter.chars))
	sorter.printResults()
	
	sorter.nextStep()
	
	firstUndo = false
	checkButton()

func loadStep():
	var step = undoArray[undoArray.size() - 1]
	
	sorter.chars = step.chars.duplicate()
	copyResults(sorter.results, step.results)
	copyCalls(sorter.answerCalls, step.answerCalls)
	sorter.sortCall = Callable(step.sortCall)
	sorter.sortActive = step.sortActive
	#sorter.currentChar = step.currentChar.duplicate()
	sorter.currentChar = step.currentChar
	#sorter.currentArr = step.currentArr.duplicate()
	if (!step.currentArr.is_empty()):
		sorter.currentArr = sorter.results[findCurrentArr(step.currentArr)].arr
	else:
		sorter.currentArr = step.currentArr.duplicate()
	sorter.lastLimitIndex = step.lastLimitIndex
	sorter.lastAnswer = step.lastAnswer
	sorter.lastRemains = step.lastRemains
	
	if (!step.arr1.is_empty()):
		arraySorter.arr1 = sorter.results[findCurrentArr(step.arr1)].arr
		arraySorter.arr2 = sorter.results[findCurrentArr(step.arr2)].arr
		print("found " + str(findCurrentArr(step.arr1)) + str(findCurrentArr(step.arr1)))
	else:
		arraySorter.arr1 = step.arr1.duplicate()
		arraySorter.arr2 = step.arr2.duplicate()
	#arraySorter.arr1 = step.arr1.duplicate()
	#arraySorter.arr2 = step.arr2.duplicate()
	arraySorter.lastItem = step.lastItem
	arraySorter.clashIndex = step.clashIndex
	arraySorter.phase = step.phase
	
	undoArray.remove_at(undoArray.size() - 1)
	undoCount -= 1

func checkButton():
	undoButton.disabled = !(undoCount > 1)

func findCurrentArr(input:Array[Character]) -> int:
		var i = 0
		for chArr in sorter.results:
			if (chArr.arr == input):
				return i
			i += 1
		printerr("array not found")
		return -1

class SorterStep:
	var chars
	var results : Array[SorterManager.CharArray] = []
	var answerCalls : Array[Callable] = []
	var sortCall
	var sortActive
	var currentChar
	var currentArr
	var lastLimitIndex
	var lastAnswer
	var lastRemains
	
	var arr1 : Array[Character] = []
	var arr2 : Array[Character] = []
	var lastItem
	var clashIndex
	var phase

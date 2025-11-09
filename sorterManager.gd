extends Node

var questionCount = 0

var chars : Array[Character] 
var testArr : Array[Character] 
var results : Array[CharArray] 

@export var leftHalf : ChoiceHalf
@export var rightHalf : ChoiceHalf

signal onAnswer
var currentAnswer : bool

var lastItem : Character
var lastGreater : bool

func _ready() -> void:
	leftHalf.choiceMade.connect(choiceMade)
	rightHalf.choiceMade.connect(choiceMade)
	
	chars = SceneManager.charPool.duplicate(true)
	chars.shuffle()
	
	await createArrays()
	
	await arrayClash()
	
	SceneManager.ranking = results[0].arr
	SceneManager.loadRanking()
	"""
	await initArray()
	print(printCharArr(testArr))
	for chara in chars:
		await sortInto(chara, testArr)
		print(printCharArr(testArr))
	print("done")
	"""

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

func initArray():
	var item1 : Character
	var item2 : Character
	
	item1 = chars[0]
	item2 = chars[1]
	
	chars.remove_at(0)
	chars.remove_at(0)
	
	results.append(CharArray.new())
	askQuestion(item1, item2)
	await Signal(self, onAnswer.get_name())
	if (currentAnswer):
		testArr.append(item1)
		testArr.append(item2)
	else:
		testArr.append(item2)
		testArr.append(item1)

func createArrays() -> void:
	var item1 : Character
	var item2 : Character
	
	while (chars.size() != 0):
		if (chars.size() == 1):
			#ask question for last array
			await sortInto(chars[0], results[0].arr)
			break
		item1 = chars[0]
		item2 = chars[1]
		
		chars.remove_at(0)
		chars.remove_at(0)
		
		results.append(CharArray.new())
		var arr : Array[Character] = results[results.size() - 1].arr
		askQuestion(item1, item2)
		await Signal(self, onAnswer.get_name())
		if (currentAnswer):
			arr.append(item1)
			arr.append(item2)
		else:
			arr.append(item2)
			arr.append(item1)
	printResults()

func arrayClash():
	while (true):
		if (results.size() == 1):
			break
		var index = -1
		for chArr in results:
			index += 1
			if (index % 2 != 0):
				continue
			if (index >= results.size() - 1):
				await arrayMerge(chArr.arr, results[1].arr)
				break
			await arrayMerge(chArr.arr, results[index + 1].arr)
		var i = -1
		while (true):
			i += 1
			if (i >= results.size()):
				break
			var chArr = results[i]
			if (chArr.arr.size() == 0):
				results.remove_at(i)
				i -= 1

func arrayMerge(arr1:Array[Character], arr2:Array[Character]):
	var lastItem = null
	while (true):
		if (arr1.size() < 1):
			break
		var item1 = arr1[0]
		if (lastItem != null):
			print("last item isnt null")
			var index = arr2.find(lastItem)
			var size = arr2.size()
			print("checking if " + str(index) + " is equal to " + str(size - 1))
			if (index == size - 1):
				for chara in arr1:
					print(chara.name)
					arr2.append(chara)
					index += 1
				arr1.clear()
				printResults()
				break
			arr2.insert(index + 1, item1)
			var count = countUnchecked(arr2, index, true, 1)
			await sortInto(item1, arr2, index, count, !true)
		else:
			print("last item is null")
			await sortInto(item1, arr2)
		lastItem = item1
		arr1.remove_at(0)
		printResults()

func sortInto(chara:Character, arr:Array[Character], limitIndex := -1, remains := 0, lastRight := true):
	if (arr.size() <= 1):
		printerr("(USER) Array of invalid size")
		return
	
	var item1 = chara
	var item2
	print (str(remains) + " and " + str(limitIndex))
	
	if (remains == 0):
		remains = arr.size()
	
	#finding item2
	if (limitIndex == -1):
		item2 = arr[arr.size() / 2 - 1 + arr.size() % 2]
	elif (remains == 1):
		var x
		print("ONE REMAINS")
		if (!lastRight):
			x = limitIndex + 2
		else:
			x = limitIndex - 2
		item2 = arr[x]
	else:
		var x
		print("ELSE HUH")
		if (!lastRight):
			x = limitIndex + 1 + (remains / 2 + remains % 2)
		else:
			x = limitIndex - 1 - (remains / 2) - 1
		item2 = arr[x]
	
	askQuestion(item1, item2)
	await Signal(self, onAnswer.get_name())
	
	if (limitIndex != -1):
		arr.erase(item1)
	
	var index = arr.find(item2)
	if (!currentAnswer):
		arr.insert(index + 1, item1)
	else:
		arr.insert(index, item1)
		index += 1
	
	if (remains == 2 and currentAnswer):
		print("Picked less of two")
		return
	elif (remains == 1):
		print("Only one remains")
		return
	
	var count = countUnchecked(arr, index, !currentAnswer, 1)
	
	if (limitIndex != -1):
		var x
		if (!currentAnswer):
			x = remains / 2
			count = clamp(count, 0, x)
		else:
			x = max(1, remains / 2 - (1 - remains % 2))
			count = clamp(count, 0, x)
	
	print("count " + str(count))
	printResults()
	
	if (count > 0):
		print("repeat")
		await sortInto(item1, arr, index, count, currentAnswer)

func countUnchecked(arr:Array, i:int, right:bool, offset := 0) -> int:
	print("count size " + str(arr.size()) + str(right))
	if (right):
		return (arr.size() - i - 1) - offset
	else:
		return i - offset

#pass to ui
func askQuestion(x:Character, y:Character) -> bool:
	questionCount += 1
	leftHalf.setupCharacter(x)
	rightHalf.setupCharacter(y)
	return true

func choiceMade(x:bool) -> void:
	currentAnswer = x
	onAnswer.emit()

class CharArray:
	var arr : Array[Character]

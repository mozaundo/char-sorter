class_name ArraySorter
extends Node

var sorter : SorterManager

enum SortPhases {CREATE, CLASH, MERGE}
var phase : SortPhases = SortPhases.CREATE

var clashIndex = -1

var lastItem : Character
var arr1 : Array[Character]
var arr2 : Array[Character]

func _ready() -> void:
	sorter = get_parent()

func nextStep():
	print("array step " + str(phase))
	if (phase == SortPhases.CREATE):
		if (sorter.chars.size() > 0):
			print("create arrays " + str(sorter.chars.size()))
			createArrays()
		else:
			phase = SortPhases.CLASH
	if (phase == SortPhases.CLASH):
		if (clashIndex >= sorter.results.size()):
			clashIndex = -1
			var i = -1
			while (true):
				i += 1
				if (i >= sorter.results.size()):
					break
				var chArr = sorter.results[i]
				if (chArr.arr.size() == 0):
					sorter.results.remove_at(i)
					i -= 1
		if (sorter.results.size() == 1):
			sorter.sortEnd()
			return
		arrayClash()
	elif (phase == SortPhases.MERGE):
		if (arr1.size() < 1):
			lastItem = null
			phase = SortPhases.CLASH
			nextStep()
		else:
			arrayMerge()
	pass

func createArrays() -> void:
	var item1 : Character
	var item2 : Character

	if (sorter.chars.size() == 1):
		#ask question for last array
		sorter.sortInto(sorter.chars[0], sorter.results[0].arr)
		sorter.chars.remove_at(0)
		return
	
	item1 = sorter.chars[0]
	item2 = sorter.chars[1]
	
	sorter.chars.remove_at(0)
	sorter.chars.remove_at(0)
	
	sorter.results.append(sorter.CharArray.new())
	var arr : Array[Character] = sorter.results[sorter.results.size() - 1].arr
	
	sorter.answerCalls.append(func(answer:bool):
		if (answer):
			arr.append(item1)
			arr.append(item2)
		else:
			arr.append(item2)
			arr.append(item1))
	
	sorter.askQuestion(item1, item2)

func arrayMerge():
	var item = arr1[0]
	var callback = func():
		lastItem = item
		arr1.remove_at(0)
	
	if (lastItem != null):
		print("last item isnt null")
		var index = arr2.find(lastItem)
		var size = arr2.size()
		print("checking if " + str(index) + " is equal to " + str(size - 1))
		if (index == size - 1):
			for chara in arr1:
				print(chara.name)
				lastItem = null
				arr2.append(chara)
				index += 1
			arr1.clear()
			phase = SortPhases.CLASH 
			nextStep()
			return
		arr2.insert(index + 1, item)
		var count = sorter.countUnchecked(arr2, index, true, 1)
		sorter.sortCall = callback
		sorter.sortInto(item, arr2, index, count, !true)
	else:
		print("last item is null")
		sorter.sortCall = callback
		sorter.sortInto(item, arr2)

func arrayClash():
	clashIndex += 1
	
	if (clashIndex % 2 != 0):
		clashIndex += 1
	
	if (clashIndex >= sorter.results.size()):
		nextStep()
		return
	
	var chArr = sorter.results[clashIndex]
	
	arr1 = chArr.arr
	if (clashIndex >= sorter.results.size() - 1):
		arr2 = sorter.results[1].arr
	else:
		arr2 = sorter.results[clashIndex + 1].arr
	
	phase = SortPhases.MERGE
	arrayMerge()

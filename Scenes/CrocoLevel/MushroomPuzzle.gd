extends Node3D

class_name MushroomPuzzle

@export var stepOne : Node3D
@export var stepTwo : Node3D
@export var stepThree : Node3D

var firstHeight: float = 1.0
var secondHeight: float = 2.5
var thirdHeight: float = 3.5

var answer = [4,3,1,2]
var attempt = []
var correct_answer: bool = false

func _start():
    pass

func solutionAttempt():
    if checkAnswer() :
        if attempt.size() > 3:
            correct_answer = true
    else:
       incorrectAnswer()

func checkAnswer() -> bool:
    return attempt[attempt.size()-1] == answer[attempt.size()-1]

func incorrectAnswer():
    pass

func _physics_process(delta):
    if correct_answer:
        #raise stairs, raise each to its height
        pass

func _on_interactable_interacted(interactor:Interactor):
    pass # Replace with function body.

extends Node3D

@export var stepOne : Node3D
@export var stepTwo : Node3D
@export var stepThree : Node3D
@export var mushroomPuzzle: MushroomPuzzle

var firstHeight: float = 1.0
var secondHeight: float = 2.5
var thirdHeight: float = 3.5

var answer = [4,3,1,2]
var attempt = []
var correct_answer: bool = false

signal clearInput

func _ready():
    # connect signal to mushroom input
    mushroomPuzzle.mushroomHit.connect(solutionAttempt)

func solutionAttempt():
    if checkAnswer() :
        if attempt.size() > 3:
            correct_answer = true
    else:
        clearInput.emit()

func checkAnswer() -> bool:
    return attempt[attempt.size()-1] == answer[attempt.size()-1]
    

func correctAnswer():
    pass

func incorrectAnswer():
    pass

func _physics_process(delta):
    if correct_answer:
        clearInput.emit()
        #raise stairs 
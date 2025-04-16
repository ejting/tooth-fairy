extends Node

var in_dialogue : bool

#Suspicion: If suspicion is at 100 and the player triggers [scene transition], then the game will end with a cutscene of the police finding them.
var suspicion : int

#Sanity: Starts at 100. If Sanity is reduced to 0 and the player triggers [scene transition], then the game will end with a cutscene of the player being taken to an asylum.
var sanity : int

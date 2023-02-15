extends Node

const body_spritesheet = {
	0: preload("res://Player/CompositeSprites/Body.png")
}

const hair_spritesheet = {
	0: preload("res://Player/CompositeSprites/Hair 1.png"),
	1: preload("res://Player/CompositeSprites/Hair 2.png"),
	2: preload("res://Player/CompositeSprites/Hair 3.png"),
	3: preload("res://Player/CompositeSprites/Hair 4.png"),
	4: preload("res://Player/CompositeSprites/Hair 5.png")
}

const eyes_spritesheet = {
	0: preload("res://Player/CompositeSprites/Eyes 1.png"),
	1: preload("res://Player/CompositeSprites/Eyes 2.png"),
	2: preload("res://Player/CompositeSprites/Eyes 3.png"),
	3: preload("res://Player/CompositeSprites/Eyes 4.png"),
	4: preload("res://Player/CompositeSprites/Eyes 5.png"),
	5: preload("res://Player/CompositeSprites/Eyes 6.png"),
	6: preload("res://Player/CompositeSprites/Eyes 7.png"),
	7: preload("res://Player/CompositeSprites/Eyes 8.png")
}

const shirt_spritesheet = {
	0: preload("res://Player/CompositeSprites/Shirt 4.png"),
	1: preload("res://Player/CompositeSprites/Shirt 1.png"),
	2: preload("res://Player/CompositeSprites/Shirt 2.png"),
	3: preload("res://Player/CompositeSprites/Shirt 3.png")
}

const pants_spritesheet = {
	0: preload("res://Player/CompositeSprites/Pants 3.png"),
	1: preload("res://Player/CompositeSprites/Pants 1.png"),
	2: preload("res://Player/CompositeSprites/Pants 2.png")
}

const shoes_spritesheet = {
	0: preload("res://Player/CompositeSprites/Shoes 4.png"),
	1: preload("res://Player/CompositeSprites/Shoes 1.png"),
	2: preload("res://Player/CompositeSprites/Shoes 2.png"),
	3: preload("res://Player/CompositeSprites/Shoes 3.png")
}

const acc_spritesheet = {
	0: preload("res://Player/CompositeSprites/Accessories 1.png"),
	1: preload("res://Player/CompositeSprites/Accessories 2.png")
}

const facial_hair_spritesheet = {
	0: preload("res://Player/CompositeSprites/Facial Hair 1.png"),
	1: preload("res://Player/CompositeSprites/Facial Hair 2.png") 
}

const skin_colors = {
	#White
	0: String('ffffff'), 
	#Light colors
	1: String('e6d796'),
	2: String('e2cf81'),
	3: String('d5c591'),
	4: String('c9c2ad'),
	#Dark Colors
	5: String('827760'),
	6: String('6b614c'),
	7: String('5c533f'),
	8: String('423b2b'),
	9: String('363022'),
	10: String('2b261c'),
	#Strange colors
	11: String('e16666'),
	12: String('dca149'),
	13: String('f3e357'),
	14: String('acf26b'),
	15: String('2fab52'),
	16: String('6deeed'),
	17: String('4e63f1'),
	18: String('a84ef1'),
	19: String('ae50be'),
}

const hair_colors = {
	0: String('3a2b16'), #Brown
	1: String('201f1d'), #Black
	2: String('5c1111'), #Red
	3: String('27388c'), #Blue
	4: String('247b52'), #Green
	5: String('c4bc29'), #Yellow 
	6: String('7624b8'), #Purple
	7: String('26e1f1'), #Aqua
}




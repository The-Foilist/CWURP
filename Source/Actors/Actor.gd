class_name Actor
extends Node


@export var owning_player: Player

var inspector: String

var behavior: Behavior
var order_queue: Array[Behavior]


func clear_orders() -> void:
	for order in order_queue:
		order.removed_from_queue()
	order_queue.clear()
	behavior = null


func replace_orders(order: Behavior) -> void:
	clear_orders()
	order_queue.append(order)
	switch_behavior(order)


func append_order(order: Behavior) -> void:
	if order_queue.size() == 0:
		order_queue.append(order)
		switch_behavior(order)
		print(order_queue[0])
		return
	
	order.prev = order_queue[-1]
	order_queue[-1].next = order
	order_queue.append(order)


func remove_order(order: Behavior) -> void:
	if order_queue.size() == 0:
		return
	if order_queue[0] == order:
		order.fail()
		return
	order_queue.erase(order)
	order.removed_from_queue()


func next_order() -> void:
	if order_queue.size() == 0:
		return
	order_queue.pop_front()
	if order_queue.size() > 0:
		switch_behavior(order_queue[0])
	else:
		switch_behavior(null)


func switch_behavior(new_behavior: Behavior = null) -> void:
	if behavior:
		behavior.removed_from_queue()
	if !new_behavior:
		behavior = null
		return
	if new_behavior.validate():
		return
	behavior = new_behavior
	behavior.preprocess()


func _physics_process(_delta: float) -> void:
	if Global.game.pause:
		return
	if behavior:
		behavior.process()

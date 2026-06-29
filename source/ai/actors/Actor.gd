class_name Actor
extends UnitComponentEthereal


@export var comms: Comms

var inspector: PackedScene
var allowed_orders: Array[Order]
var order_queue: Array[Dictionary]
var behavior: Behavior


func add_order(order: Order, priority: int, param_dict: Dictionary) -> void:
	match priority:
		order.Priority.OVERRIDE:
			order_queue = [{'order': order, 'params': param_dict}]
			next_order()
		order.Priority.FIRST:
			order_queue.push_front({'order': order, 'params': param_dict})
			next_order()
		order.Priority.LAST:
			order_queue.push_back({'order': order, 'params': param_dict})
			if order_queue.size() == 1:
				next_order()


func next_order() -> void:
	if order_queue.size() == 0:
		return
	var item: Dictionary = order_queue.pop_front()
	var new_order: Order = item['order']
	new_order.execute(self, item['params'])


func process_session_time(delta: float) -> void:
	if behavior:
		behavior.process(delta)

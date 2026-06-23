class_name UnitTree
extends Tree

func build_tree(parent_node: UnitGroup, parent_tree_item: TreeItem) -> void:
	var child = create_item(parent_tree_item)
	child.set_text(0, parent_node.name)
	child.set_metadata(0, parent_node)
	if parent_node.groups.size() > 0:
		for n in parent_node.groups:
			build_tree(n, child)
	else:
		for unit in parent_node.units:
			var child2 = create_item(child)
			child2.set_text(0, unit.display_name)
			child2.set_metadata(0, unit)


func check_tree(item: TreeItem, object: Node) -> void:
	if item.get_metadata(0) == object:
		item.select(0)
	else:
		item.deselect(0)
	for child in item.get_children():
		check_tree(child, object)


func update() -> void:
	clear()
	var root = create_item()
	for group in Global.local_controller.player.unit_groups:
		build_tree(group, root)


func _on_item_mouse_selected(mouse_position, _mouse_button_index) -> void:
	if !get_item_at_position(mouse_position):
		return
	var obj = get_item_at_position(mouse_position).get_metadata(0)
	if obj is Unit:
		Global.local_controller.player.select(obj)


func _on_object_selected(selection: Unit) -> void:
	check_tree(get_root(), selection)

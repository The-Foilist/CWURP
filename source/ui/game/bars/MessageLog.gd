class_name MessageLog
extends RichTextLabel


func wrap_name(object: Node) -> String:
	if !object:
		return ''
	if object is UnitComponentPhysical:
		object = object.unit
	var out_string: String = '[b][url=%s]%s[/url][/b]' % [object.get_instance_id(), object.name]
	if object is Player:
		out_string = '[color=#%s]%s[/color]' % [object.color.to_html(false), out_string]
	if object is Unit:
		out_string = '[color=#%s]%s[/color]' % [object.owning_player.color.to_html(false), out_string]
	return out_string


func parse_objects(content: String) -> String:
	var regex = RegEx.create_from_string('\\[(.*?)\\]')
	for result in regex.search_all(content):
		var obj_id = int(result.get_string().lstrip('[').rstrip(']'))
		content = content.replace(result.get_string(), wrap_name(instance_from_id(obj_id)))
	return content


func _add_message(content: String) -> void:
	if content == '':
		return
	content = parse_objects(content)
	newline()
	append_text(content)


func update() -> void:
	clear()
	for message in Global.local_controller.player.message_log:
		_add_message(message)

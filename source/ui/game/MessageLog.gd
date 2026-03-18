class_name MessageLog
extends RichTextLabel


func _add_message(content: String) -> void:
	if content.contains('[sender]'):
		var sender = instance_from_id(int(content.split('[sender]')[1].split('[url=')[1].split(']')[0])).name
	newline()
	append_text(content)


func update() -> void:
	clear()
	for message in Global.local_controller.player.message_log:
		_add_message(message)

extends ProgressBar


@onready var timer = $Timer
@onready var progress_bar = $ProgressBar

var experiencia = 0 : set = _set_exp

func _set_exp(new_exp:float) -> void:
	var prev_exp = experiencia
	experiencia = min(max_value, new_exp)
	value = experiencia
	
	if experiencia < prev_exp:
		timer.start()
	else:
		progress_bar.value = experiencia


func init_exp(_exp:float, _max_exp:float) -> void:
	experiencia = _exp
	max_value = _max_exp
	value = experiencia
	progress_bar.max_value = _max_exp
	progress_bar.value = experiencia

func _on_timer_timeout() -> void:
	progress_bar.value = exp

extends Spatial
class_name MyEditor


var totalTime = 0


func get_camera() -> Camera:
	return $PivotY.get_camera()


func get_pivot_y() -> Spatial:
	return $PivotY.get_pivot_y()


func get_pivot_x() -> Spatial:
	return $PivotY.get_pivot_x()

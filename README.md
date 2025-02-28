### Fari Hafizh R - 2206083691

## Double Jumping

1. untuk memastikan player hanya dapat melompat sebanyak 2 kali, buat jump counter
```
var jump_count = 0
```

2. Membuat kode untuk melakukan jump-nya
```
if Input.is_action_just_pressed("jump") and jump_count < 2:
    jump_count += 1
    velocity.y = JUMP_VELOCITY
```

## Dash

1. Menentukan kecepatan dan distance dashnya
```
const dash_speed = 800.0
const dash_length = 0.2
```

2. Membuat fungsi dash dengan memanfaatkan timer untuk menentukan lama character melakukan dashnya berdasarkan distance
```
@onready var dash_timer = $Timer

func start_dash(dur):
	dash_timer.wait_time = dur
	dash_timer.start()

func dash():
	return !dash_timer.is_stopped()
```

3. Set speed jalan baru jika melakukan dash
```
SPEED = dash_speed if dash() else normal_speed
```  

## Crouch

1. Buat collision shape baru yang lebih kecil dan masukkan ke dalam kode, buat juga variabel `is_crouch` untuk menentukan state player
```
var is_crouch = false

var standing_cshape = preload("res://resources/stand_cshape.tres")
var crouching_cshape = preload("res://resources/crouch_cshape.tres")

@onready var cshape = $CollisionShape2D
```

2. Buat fungsi crouch dengan me-load collision shape yang baru
```
func crouch():
	if is_crouch:
		return
	is_crouch = true
	cshape.shape = crouching_cshape
	cshape.position.y = 21
```

3. Buat juga fungsi stand dengan me-load collision shape yang lama untuk state player selain crouch
```
func stand():
	if is_crouch == false:
		return
	is_crouch = false
	cshape.shape = standing_cshape
	cshape.position.y = 16
``` 

4. Buat kode yang mengaktifkan crouch jika dipencet suatu key dan mengaktidkan stand jika melepasnya
```
if Input.is_action_just_pressed("crouch"):
	crouch()
elif Input.is_action_just_released("crouch"):
	stand()
```
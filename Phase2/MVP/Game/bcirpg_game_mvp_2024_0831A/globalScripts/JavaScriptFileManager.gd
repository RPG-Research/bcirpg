extends Node

# NOTE: All yield() functions are replaced by await() in Godot 4.x!

var _text_callback
var file_text
signal file_text_received(file_text)

func _ready():
	_text_callback = JavaScript.create_callback(self, "_text_callback_func")

#FUNCTION open file dialog get text
#Params: none
#Returns: String containing opened file text
#Notes: yields to allow asynch javascript file dialog to return read file contents
#	When calling, call with yield(JavaScriptFileManager.open_file_dialog_get_text(), "completed")
#	That allows the function to actually return something before the code continues
func open_file_dialog_get_text():
	_open_file_dialog_get_text_internal()
	return yield(self, "file_text_received")

#FUNCTION text callback function
#Params: Array of arguments passed by the javascript code
#Returns: nothing, emits signal containing the text of the file read by javascript
#Notes: signal tells yield in open_file_dialog_get_text() to continue
func _text_callback_func(args):
	emit_signal("file_text_received", args[0])

#FUNCTION open file dialog get text (internal)
#Params: none
#Returns: nothing, calls _text_callback_func and passes the file text read by javascript to it
#Notes: terrible choice of name
func _open_file_dialog_get_text_internal():
	if OS.has_feature('JavaScript'):
		print("running javascript")
		
		var js_window = JavaScript.get_interface("window")
		js_window.godot_callback = _text_callback
		
		JavaScript.eval("""
		console.log("opening file dialog");
		const input = document.createElement('input');
		input.type = 'file';
		input.accept = '.csv,text/csv';
		
		input.addEventListener("change", on_input_change);
		input.click();
		
		function on_input_change() {
			const file = input.files[0];
			if (!file) {
				window.godot_callback(["No file to read"]);
				return;
			}

			const reader = new FileReader();
			
			reader.onerror = function() {
				window.godot_callback(["Failed to read file"]);
			}
			
			reader.onloadend = function() {
				console.log("reader onloadend start");
				
				window.godot_callback(reader.result);
				
				console.log("reader onloadend end");
			}
						
			reader.readAsText(file);
		};
		""", true)


	var config = {
			initializedId : "",
			wrapper : "tx_trex_container",
			form : 'frm',
			txIconPath : "daumeditor/images/icon/editor/",
			txDecoPath : "daumeditor/images/deco/contents/",
			events : {
				preventUnload : false
			},
			sidebar : {
				attachbox : {
					show : true
				}
			}
		};

	EditorCreator.convert(document.getElementById("content"),
			'daumeditor/pages/template/simple.html', function() {
				EditorJSLoader.ready(function(Editor) {
					new Editor(config);
					Editor.modify({
						content : ''
					});
				});
			});


	function setForm(editor) {
		var i, input;
		var form = editor.getForm();
		var content = editor.getContent();

		var field = document.getElementById("content");
		field.value = content;

		var images = editor.getAttachments('image');
		for (i = 0; i < images.length; i++) {
			input = document.createElement('input');
			input.type = 'hidden';
			input.name = 'attach_image';
			input.value = images[i].data.imageurl;
			form.createField(input);
		}

		var files = editor.getAttachments('file');
		for (i = 0; i < files.length; i++) {
			input = document.createElement('input');
			input.type = 'hidden';
			input.name = 'attach_file';
			input.value = files[i].data.attachurl;
			form.createField(input);
		}
		return true;
	}
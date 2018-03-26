<%-- 
    Document   : uploadDoc
    Created on : 7 Mar, 2018, 6:57:02 PM
    Author     : Nivetha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<!DOCTYPE html>
<!--<html>-->
<!--<head>
	<title></title>
</head>
<body>
	<form enctype="multipart/form-data" action="http://localhost:8080/MeOnCloud/e/drive/upload" method="POST">
     Name of input element determines name in $_FILES array 
    Send this file: <input name="files" type="file" /></br>
    <input type="submit" value="Send File" />
</form>
</body>
</html>-->
<!--<!DOCTYPE html>
<html>
<head>
	<title></title>
</head>
<body>
	<form enctype="multipart/form-data" action="http://localhost:8080/MeOnCloud/e/drive/upload" method="POST" 
	onsubmit="ajaxUpload" id="form">
     Name of input element determines name in $_FILES array 
    Send this file: <input name="files" id="files" type="file" /></br>
    <input type="submit" id="submit" value="Send File" />
</form>

<script type="text/javascript">

	var form = document.getElementById("form");
	
	function ajaxUpload (evt) {

		var fileInputElement = document.getElementById("files")
		var formData = new FormData();

		formData.append("files", fileInputElement.files[0]);


		var request = new XMLHttpRequest();
		request.open("POST", "http://localhost:8080/MeOnCloud/e/drive/upload");
		request.send(formData);

		evt.preventDefault();

		return false;

	}


	form.addEventListener("submit", ajaxUpload, false);

</script>	
	
</body>
</html>-->
<!DOCTYPE html>
<html>
<head>
	<title></title>

	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
	<!-- The jQuery UI widget factory, can be omitted if jQuery UI is already included -->
	<script src="jQuery-File-Upload-9.19.1/js/vendor/jquery.ui.widget.js"></script>
	<!-- The Iframe Transport is required for browsers without support for XHR file uploads -->
	<script src="jQuery-File-Upload-9.19.1/js/jquery.iframe-transport.js"></script>
	<!-- The basic File Upload plugin -->
	<script src="jQuery-File-Upload-9.19.1/js/jquery.fileupload.js"></script>

</head>
<body>
<input id="fileupload" type="file" name="files[]" multiple/>

<div id="files"></div>
<script>
/*jslint unparam: true */
/*global window, $ */
$(function () {
    'use strict';
    // Change this to the location of your server-side upload handler:
    var url =  "http://localhost:8080/MeOnCloud/e/drive/upload";  //url,
    // var url = window.location.hostname === 'blueimp.github.io' ?
                // '//jquery-file-upload.appspot.com/' : 'server/php/';
    $('#fileupload').fileupload({
    	url: url,
        beforeSend: function ( xhr ) {

        	xhr.setRequestHeader('authentication-token', 'Syq21qPiERscQa8M0bGRGf2pLxsGWmj2Sj/Y1OgluHEfXZJCEMLuKFgxM9RtZPcl');

      		// setHeader(xhr);
        //   	$("#check_progress").html('true');
      	},
        // dataType: 'json',
        done: function (e, data) {
        	
            $.each(data.result.files, function (index, file) {
                $('<p/>').text(file.name).appendTo('#files');
            });
        },
        progressall: function (e, data) {
            // var progress = parseInt(data.loaded / data.total * 100, 10);
            // $('#progress .progress-bar').css(
            //     'width',
            //     progress + '%'
            // );
        }
    }).prop('disabled', !$.support.fileInput)
        .parent().addClass($.support.fileInput ? undefined : 'disabled');
});
</script>


</body>
</html>
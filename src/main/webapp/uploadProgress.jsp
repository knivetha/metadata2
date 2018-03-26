<%-- 
    Document   : uploadProgress
    Created on : 9 Mar, 2018, 3:57:11 PM
    Author     : Nivetha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<form id="upload_form" enctype="multipart/form-data" method="post">
  <input type="file" name="file1" id="file1" onchange="uploadFile()"><br>
  <progress id="progressBar" value="0" max="100" style="width:300px;"></progress>
  <h3 id="status"></h3>
  <p id="loaded_n_total"></p>
</form>
<script>
function _(el) {
  return document.getElementById(el);
}

/*global window, $ */
$(function () {
    'use strict';
   
    // Change this to the location of your server-side upload handler:
    var url =  "http://localhost:8080/MeOnCloud/e/drive/upload";
    //url,
    // var url = window.location.hostname === 'blueimp.github.io' ?
                // '//jquery-file-upload.appspot.com/' : 'server/php/';
    $('#fileupload').fileupload({
    	url: url,
        beforeSend: function ( xhr ) {

        	//xhr.setRequestHeader('authentication-token', 'Syq21qPiERscQa8M0bGRGf2pLxsGWmj2Sj/Y1OgluHEfXZJCEMLuKFgxM9RtZPcl');

      		// setHeader(xhr);
        //   	$("#check_progress").html('true');
      	},
        // dataType: 'json',
        done: function (e, data) {
            data.result, function (index, file) {
                $('<p/>').text(file.name).appendTo('#files');
            };
        },
        progressall: function (e, data) {
             var fnProgress = function(file, bytes) {
    var percentage = (bytesLoaded / file.size) * 100;

    // Update DOM
//    $('.progressBar').css({ 'width': percentage + '%' });
//    $('.progressText').html(Math.round(percentage + "%");
     function progressHandler(event) {
    _("loaded_n_total").innerHTML = "Uploaded " + event.loaded + " bytes of " + event.total;
    var percent = (event.loaded / event.total) * 100;
    _("progressBar").value = Math.round(percent);
    _("status").innerHTML = Math.round(percent) + "% uploaded... please wait";
  }
}
      
           
        
    }).prop('disabled', !$.support.fileInput)
        .parent().addClass($.support.fileInput ? undefined : 'disabled');
  

   
});


</script>
</html>

<%-- 
    Document   : home
    Created on : 8 Feb, 2018, 11:59:59 AM
    Author     : Nivetha
--%>
<%--<%@page import = "NetBeansProjects.MeOnCloud.build.classes.com.inswit.meoncloud.authentication.EnterpriseAuthFilter"%> 
<%@page import = "NetBeansProjects.MeOnCloud.build.classes.com.inswit.meoncloud.utils.Utility" %>--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">

        <!-- jQuery library -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

        <!-- Latest compiled JavaScript -->
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <script defer src="https://use.fontawesome.com/releases/v5.0.6/js/all.js"></script>
        <!--java class import-->
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
        <!-- The jQuery UI widget factory, can be omitted if jQuery UI is already included -->
        <script src="jQuery-File-Upload-9.19.1/js/vendor/jquery.ui.widget.js"></script>
        <!-- The Iframe Transport is required for browsers without support for XHR file uploads -->
        <script src="jQuery-File-Upload-9.19.1/js/jquery.iframe-transport.js"></script>
        <!-- The basic File Upload plugin -->
        <script src="jQuery-File-Upload-9.19.1/js/jquery.fileupload.js"></script>
    </head>
    <style>
        body {
            font-family: "Lato", sans-serif;
        }

        .sidenav {
            height: 100%;
            width: 200px;
            position: fixed;
            z-index: 1;
            top: 0;
            left: 0;
            background-color: #f2f2f2;
            overflow-x: hidden;
            padding-top: 120px;
        }
        .sidenavr {
            height: 100%;
            width: 200px;
            position: fixed;
            z-index: 1;
            top: 0;
            right: 0;
            background-color: #FDFEFE;
            overflow-x: hidden;
            padding-top: 120px;
        }

        .sidenav a {
            padding: 6px 6px 6px 32px;
            text-decoration: none;
            font-size: 25px;
            color: #000000 ;
            display: block;
        }
        .sidenavr a {
            padding: 6px 6px 6px 32px;
            text-decoration: none;
            font-size: 25px;
            color: #0099FF ;
            display: block;
        }

        .sidenav a:hover {
            color: #ccccff;
        }
        .sidenavr a:hover {
            color: #ccccff;
        }

        .main {
            margin-left: 200px; /* Same as the width of the sidenav */
        }
        .bottom{
            bottom :0;
            position: fixed;
        }
        .right{
            position: absolute;
            top: 50px;
            right: 200px;                
        }
        .rightr{
            position: absolute;
            top: 50px;
            right: 300px;  
            width:10%;
        }
        table {
            border-collapse: collapse;
            width: 100%;

        }

        th, td {
            text-align: left;
            padding: 8px;
            border-bottom: 1px solid #ddd;
        }  
        th {
            background-color: 

                #1a75ff;
            color: white;


        }               
        .div2 {
            width: 70%;
            height: 100px;    
            /*    padding: 50px;*/

            box-sizing: border-box;
        }         
        #metaDataParams{

        }
        @media screen and (max-height: 450px) {
            .sidenav {padding-top: 15px;}
            .sidenav a {font-size: 18px;}
            .sidenavr {padding-top: 15px;}
            .page-header{padding-top: 15px;};
            .main{padding-top: 15px ;font-size: 13px;}
            .table{padding-top: 15px;font-size: 13px;}
            .table-responsive{padding-top: 15px;}

        }
        .w3-btn {width:150px;}

        input[type=text1]:focus {
            width: 30%;
            -webkit-transition: width 0.4s ease-in-out;
            transition: width 0.4s ease-in-out;
        }


        /*//css for modal*/

        .modal-dialog-wrap {
            display: table;
            table-layout: fixed;
            width: 100%;
            height: 100%;

        }

        .modal-dialog {
            display: table-cell;
            vertical-align: middle;
            text-align: center;
        }

        .modal-content {
            display: inline-block;
            text-align: left;
        }
    </style>
</head>

<body onload="setup()">

    <div class="sidenav">
        <a href="#">My Files</a>


    </div>
    <div class="sidenavr">

        <form action="listMetadata"/>
        <input id='buttonid1' type='button' value='Upload Files' class="w3-button w3-blue w3-round " data-toggle="modal" data-target="#myModal" />

    </form>
    <div id="files"></div>


    <p>
        <small><span class="glyphicon glyphicon-folder-close"> NewFolder</span></small>

    </p>

    <div class="bottom">

        <p> 
            <button class="w3-button w3-blue w3-round">
                <span class="glyphicon glyphicon-log-out" name="logout"  onclick="window.location.href = 'login.jsp'"></span> Signout</button></a>

        </p>

    </div>
</div>
<!--upload pop-up-->
<!-- Modal -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <SCRIPT TYPE="text/javascript">
        var params = null;
        var idSelected = null;
         var paramsJSON = {};
         var paramsStr;
        $(function () {
            'use strict';
            function callAjaxFunctionParams(selectedNameVal) {
                var url = "listParam?name=" + selectedNameVal;
                idSelected = selectedNameVal;
                var xmlHttp;
                if (window.XMLHttpRequest) {

                    var xmlHttp = new XMLHttpRequest();
                } else if (window.ActiveXObject) {

                    var xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
                }

                xmlHttp.open('POST', url, true);
                xmlHttp.onreadystatechange = function () {

                    if (xmlHttp.readyState === 4) {

                        console.log(xmlHttp.responseText);
                        var jsonData = JSON.parse(xmlHttp.responseText);
                        params = jsonData;
                        var appendDiv = document.getElementById("metaDataParams");
                        for (i in jsonData) {
                            var name = jsonData[i].keyname;
                            var ele = document.createElement("input");
                            ele.type = "text";
                            ele.id = name;
                            ele.setAttribute("class","w3-order w3-input w3-round");
                            var br =document.createElement("break");
                            appendDiv.appendChild(ele);
                            appendDiv.appendChild(br);
                        }
//                        var btn = document.createElement("button");
//                      //  btn.href = "javascript:void(0)";
//                        btn.textContent = "click";
//                        btn.id = "fileuploadId";
//                        btn.name="files[]";
//                        appendDiv.appendChild(btn);
                    }

                };
                xmlHttp.send(url);



            }
            // Change this to the location of your server-side upload handler:
            //var urlUpload = "http://localhost:8080/MeOnCloud/e/drive/upload?"+paramsStr;  //url,
            // var url = window.location.hostname === 'blueimp.github.io' 
            // '//jquery-file-upload.appspot.com/' : 'server/php/';
            console.log("Parafg" + params);
           
            function createjson() {
                console.log("please");
                console.log(params);
                
                paramsJSON['id'] = idSelected;
                for (i in params) {
                    var value = document.getElementById(params[i].keyname).value;
                    paramsJSON[params[i].keyname] = value;
                }
                paramsStr = JSON.stringify(paramsJSON);
                console.log("json");
                console.log(strJson);
            }
          var strJson = JSON.stringify(paramsJSON);
           
          
            $('#fileUploadID').fileupload({

                url: "http://localhost:8080/MeOnCloud/e/drive/upload?" +paramsStr;
                beforeSend: function (xhr) {
                    createjson();

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
        function createjson() {
            var json = {};
            for (i in params) {
                var value = document.getElementById(params[i].keyname);
                json[params[i].keyname] = value;
            }
            console.log(json);
        }
        var id;
        function listMetaDataNames() {

            callAjaxAppFunction();
        }
        function listParams() {
            var selectedIndexVal = document.getElementById("selectNameID").selectedIndex;
            var selectedNameVal = document.getElementById("selectNameID").options[selectedIndexVal].value;
            id = selectedNameVal;
            callAjaxFunctionParams(selectedNameVal);
        }


        function callAjaxAppFunction() {
            var url = "listMetadata";
            var xmlHttp;
            if (window.XMLHttpRequest) {

                var xmlHttp = new XMLHttpRequest();
            } else if (window.ActiveXObject) {

                var xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
            }

            xmlHttp.open('POST', url, true);
            xmlHttp.onreadystatechange = function () {

                if (xmlHttp.readyState === 4) {

                    updateApp(xmlHttp.responseText);
                }

            };
            xmlHttp.send(url);
        }

        function callAjaxFunctionParams(selectedNameVal) {
            var url = "listParam?name=" + selectedNameVal;

            var xmlHttp;
            if (window.XMLHttpRequest) {

                var xmlHttp = new XMLHttpRequest();
            } else if (window.ActiveXObject) {

                var xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
            }

            xmlHttp.open('POST', url, true);
            xmlHttp.onreadystatechange = function () {

                if (xmlHttp.readyState === 4) {

                    console.log(xmlHttp.responseText);
                    var jsonData = JSON.parse(xmlHttp.responseText);
                    params = jsonData;
                    var appendDiv = document.getElementById("metaDataParams");
                    for (i in jsonData) {
                        var name = jsonData[i].keyname;
                        var ele = document.createElement("input");
                        ele.type = "text";
                        ele.id = name;
                        appendDiv.appendChild(ele);
                    }
//                        var btn = document.createElement("button");
//                      //  btn.href = "javascript:void(0)";
//                        btn.textContent = "click";
//                        btn.id = "fileuploadId";
//                        btn.name="files[]";
//                        appendDiv.appendChild(btn);
                }

            };
            xmlHttp.send(url);



        }
//            function sendMetaDataValues() {
//                var jsonToSend = {};
//                jsonToSend['id'] = id;
//                console.log(params);
//                for (i in params) {
//                    var value = document.getElementById(params[i].keyname).value;
//
//                    jsonToSend[params[i].keyname] = value;
//                }
//                console.log(jsonToSend);
//                // upload(jsonToSend);

//            }

//            function saveValues(){
//                
//                var obj = document.getElementById("metaDataParams");
//               
//                var key = document.createElement("input");
//                key.value="Enter key";
//                key.setAttribute("class","w3-round w3-input w3-border w3-small");
//                var variable = document.createElement("input");
//                variable.value="Enter variable";
//                variable.setAttribute("class","w3-round w3-input w3-border");
//                var button = document.createElement("button");
//                button.setAttribute("class","w3-blue w3-button w3-round");
//                button. = "Submit";
//                key.type = "text";
//                variable.type = "text";
//                button.type = "button";
//                obj.appendChild(key);
//                obj.appendChild(variable);
//                obj.appendChild(button);
//            }



        function updateApp(response) {
            document.getElementById("metaDataName").innerHTML = response;

        }
        function updateParams(response) {
            document.getElementById("metaDataParams").innerHTML = response;

        }

    </SCRIPT>


    <div class="modal-dialog-wrap">
        <div class="modal-dialog" role="document">
            <div class="modal-content modal-lg">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">Upload files</h4>
                </div>
                <div class="modal-body" >

                    <input id='fileupload'  name="files[]" style="display:none " onclick="listMetaDataNames()"/>
                    <label for="fileUpload">

                        <button type="button" id="buttonid" name ="files[]" class="w3-button w3-blue w3-round">Upload with Metadata</button></label>
                    <!--                        <form action='saveValues' method="POST">-->
                    <div id="metaDataName"></div>
                    <div id="metaDataParams">

                    </div>
                    <input type ="file" name ="files[]" class="w3-round" id="fileUploadID"/>
                    <!--
                                            </form>-->

                </div>
                <div class="modal-footer">
                    <button type="button"  class="w3-button w3-blue w3-round" id="button" modal-dismiss="close">Close</button>
                </div>

            </div>
        </div>
    </div>

</div>
<!--ends here-->
<div class = "main page-header ">
    <h1>
        File Management

    </h1>
    <input type = "text1" class = " w3-input w3-border w3-round rightr" id="myInput1" name="filename"   placeholder = "Enter Filename">
    <div id="files"></div>


    <button class="w3-button w3-blue w3-round right "onclick="onclickEvent()"  type="submit">
        <span class="glyphicon glyphicon-search" name="search"></span> Search </button>  

</div>
<div class="main div2 ">
    <table class="table table-responsive" id="tab">


    </table>

</div>


<!--to upload with button click-->

<script>
    function setup() {
        document.getElementById('buttonid').addEventListener('click', openDialog);
        function openDialog() {
            document.getElementById('fileupload').click();
        }


    }


    $("input[id='fileUploadID']").change(function (e) {
        var $this = $(this);

        $this.next().html($this.val().split('\\').pop());

    });
</script>

<script>


    var aid = '${aid}';
    var authToken = '${authtoken1}';
    var roles = '${roles}';
    // console.log("authToken"+authToken);
    console.log(authToken);

    var funct, filterRes, noOfFiles;
    var requestURL = 'http://localhost:8080/MeOnCloud/e/drive/list';
    var request = new XMLHttpRequest();
    request.open('GET', requestURL);
    request.responseType = 'json';
    request.send();
    //data return for table
    request.onload = function () {
        funct = request.response;

        dispfilter(funct);
        console.log(funct);
    };
    //       


    function onclickEvent()
    {
        filter();
    }

    function filter() {

//        var start = null;
        //start = document.getElementById('start').value;
//        var d = new Date(start);
//        var end = null;
//        end = document.getElementById('end').value;
//        var d1 = new Date(end);
        var parameters = [
            ["fileName", document.getElementById('myInput1').value],
//                  ["contentType", document.getElementById('myInput2').value],
//                ["fromDate",d.toISOString()],
//                ["endDate",d1.toISOString()]
        ];
        var query = parameters.map(function (couple) {
            return couple.join("=");
        }).join("&");
        //           url: "http://localhost:8080/MeOnCloud/e/drive/list?" + query;
        var finalUrl = "http://localhost:8080/MeOnCloud/e/drive/list?" + query;
        console.log(finalUrl);
        // window.location="http://localhost:8080/MeOnCloud/e/drive/list?" + query;

        var requestURL = finalUrl;
        var request = new XMLHttpRequest();
        request.open('GET', requestURL);
        request.responseType = 'json';
        request.send();
        //data return for  t able
        request.onload = function () {
            funct1 = request.response;
            dispfilter(funct1);
            console.log(funct1);
        };
    }
    ;

    function dispfilter(jsonObj) {
        var fileurl = "http://localhost:8080/MeOnCloud/drive/docs/";
        noOfFiles = jsonObj['payload']['drive'] ['noOfFiles'];
//        console.log(noOfFiles);
        var files = jsonObj['payload']['drive']['files'];
        for (var i = 0; i < files.length; i++)
            var aId = files[i].aid.toString();


        if (aid === aId) {

            var table = document.createElement("table");
            table.setAttribute("id", "tab1");
            var tr = table.insertRow(-1);
            var col = [];
            for (var i = 0; i < files.length; i++) {
                for (var key in files[i]) {
                    if (col.indexOf(key) === -1) {
                        col.push(key);
                    }
                }
            }




            tr = table.insertRow(-1);
            //table header
            for (var i = 0; i < col.length; i++) {
                var th = document.createElement("th");
                var th1 = document.createElement("th");
                var th2 = document.createElement("th");
                var th3 = document.createElement("th");
                var th4 = document.createElement("th");
            }
            th.innerHTML = "Name";
            th1.innerHTML = "ContentType";
            th2.innerHTML = "Last Edited";
            th3.innerHTML = "";
            th4.innerHTML = "";

            tr.appendChild(th);
            tr.appendChild(th1);
            tr.appendChild(th2);
            tr.appendChild(th3);
            tr.appendChild(th4);
            //table rows

            for (var i = 0; i < files.length; i++) {

                tr = table.insertRow(-1);
                var tbody = document.createElement("tbody");
                tbody.setAttribute("id", "tbody");
                //for (var j = 0; j < col.length; j++) {
                var tabCell = tr.insertCell(-1);
                var tabcell2 = tr.insertCell(-1);
                var tabcell3 = tr.insertCell(-1);
                var tabcell4 = tr.insertCell(-1);
                var tabcell5 = tr.insertCell(-1);
                var fileid = files[i]['id'];
                var filename = files[i]['name'];
                var locationurl = fileurl + fileid;
                //locationurl = locationurl+name;
                tabCell.innerHTML = '<span class="glyphicon glyphicon-picture" style="font-size:36px;color:#1a75ff"></span> <a href=" ' + locationurl + '"> ' + filename + '</a>';
                tabcell2.innerHTML = files[i]['mimeType'];
                tabcell3.innerHTML = files[i]['lastEdited'];
                tabcell5.innerHTML = '<a href=' + locationurl + '\\' + filename + ' download> <span class="btn btn-info glyphicon glyphicon-download-alt"></span></a>'


                if (roles === 'admin') {
                    tabcell4.innerHTML = '<span class="btn btn-info glyphicon glyphicon-edit "></span>'
                }
            }

            var divContainer = document.getElementById("tab");
            divContainer.innerHTML = " ";
            divContainer.appendChild(table);
        }

    }
    ;
</script>

<script>
    //for popup display
    var modal = document.getElementById('myModal');

// Get the button that opens the modal
    var btn = document.getElementById("buttonid");

// Get the <span> element that closes the modal
    var span = document.getElementsByClassName("close")[0];

// When the user clicks the button, open the modal 
    btn.onclick = function () {
        modal.style.display = "block";
    }

// When the user clicks on <span> (x), close the modal
    span.onclick = function () {
        modal.style.display = "none";
    }

// When the user clicks anywhere outside of the modal, close it
    window.onclick = function (event) {
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }

    //file upload
    //function upload(metaDataName) {
    //  alert("inside upload");
//            var metaData = metaDataName;
//            $(function () {
//                'use strict';
//                // Change this to the location of your server-side upload handler:
//                var url = "http://localhost:8080/MeOnCloud/e/drive/upload";  //url,
//                alert("url called");
//                // var url = window.location.hostname === 'blueimp.github.io' ?
//                // '//jquery-file-upload.appspot.com/' : 'server/php/';
////               $('#fileuploadId').fileupload({
//                    url: url,
//                    
//                    beforeSend: function (xhr) {
////                        alert("before send");
//
//                        xhr.setRequestHeader('authentication-token', 'Syq21qPiERscQa8M0bGRGf2pLxsGWmj2Sj/Y1OgluHEfXZJCEMLuKFgxM9RtZPcl');
//
//                        // setHeader(xhr);
//                        //   	$("#check_progress").html('true');
//                    },
//                    // dataType: 'json',
//                    done: function (e, data) {
//                       //. alert("on done");
//
//                        $.each(data.result.files, function (index, file) {
//                            $('<p/>').text(file.name).appendTo('#files');
//                        });
//                    },
//                    progressall: function (e, data) {
//                        // var progress = parseInt(data.loaded / data.total * 100, 10);
//                        // $('#progress .progress-bar').css(
//                        //     'width',
//                        //     progress + '%'
//                        // );
//                    }
////                }).prop('disabled', !$.support.fileInput)
////                        .parent().addClass($.support.fileInput ? undefined : 'disabled');
//            }
//                    );
//        }
</script>




</body>
</html> 


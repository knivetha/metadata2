<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <title>Start Page</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <!-- <link href="/bootstrap/css/bootstrap.min.css" rel="stylesheet"> -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>   
        
       



        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <!--        <script src="https://code.jquery.com/jquery-2.1.1.min.js"></script>-->
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.17.1/moment.min.js"></script>
        <link rel="stylesheet"
              href="https://rawgit.com/Eonasdan/bootstrap-datetimepicker/master/build/css/bootstrap-datetimepicker.min.css">
        <script src="https://rawgit.com/Eonasdan/bootstrap-datetimepicker/master/build/js/bootstrap-datetimepicker.min.js"></script>
<!--pagination-->
    <link href="//netdna.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <script src="//code.jquery.com/jquery-2.0.3.min.js" type="text/javascript"></script>
    <script src="//netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>
    <script src="../jquery.twbsPagination.js" type="text/javascript"></script>

<!--pagination-->
<script type="text/javascript" charset="utf8" src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.8.2.min.js"></script>

<script type="text/javascript" src="jquery.dataTables.js"></script>


    </head>

    <body>
        <div class = "page-header">



            <h1>
                FIlE MANAGEMENT

            </h1>
        </div>

        <form  class = "form-inline" method="POST" action="">
            <div class = "form-group ">

                <div class="">
                    <input type = "text" class = "form-control" id="myInput1"   placeholder = "Enter Filename">

                </div>
            </div>

            <div class = "form-group ">
                <div class=" form-group has-feedback has-feedback-right" > 
                    <input type = "text" class = "form-control" id="myInput2"  placeholder = "Content Search">

                    <br>
                </div>
            </div>


            <div class='input-group date' id='datetimepicker6'>
                <input type='text' class="form-control" id="start" />
                <span class="input-group-addon">
                    <span class="glyphicon glyphicon-calendar"></span>
                </span>
            </div>            <div class='input-group date' id='datetimepicker7'>
                <input type='text' class="form-control" id="end" />
                <span class="input-group-addon">
                    <span class="glyphicon glyphicon-calendar"></span>
                </span>
            </div>
            <input type="button" class="form-control"  onclick="onclickEvent()" value="Search"/>          
            <div class="container">
            </div>



        </form>



        <br>
        <div class="container">
            <style type="text/css">
                .table1{


                    border - spacing:10px;
                }
            </style>
            <style type="text/css">
                    table{

                        border - collapse: separate;
                        border - spacing: 30px;
                    }
            </style>

            <table class="table1">



            </table>
            <div class="table-responsive text-primary"  id="tab"> 

            </div>
        </div>


    <header>
    </header>

    <section>

    </section>
    <script type="text/javascript">
        $(function () {
        $('#datetimepicker6').datetimepicker({
        //defaultDate: new Date(),
        format: 'DD/MM/YYYY hh:mm A',
                sideBySide: false

        });
        $('#datetimepicker7').datetimepicker({
        //defaultDate: new Date(),
        format: 'DD/MM/YYYY hh:mm A',
                sideBySide: false //Important! See issue #1075


        });
        $("#datetimepicker6").on("dp.change", function (e) {
        $('#datetimepicker7').data("DateTimePicker").minDate(e.date);
        });
        $("#datetimepicker7").on("dp.change", function (e) {
        $('#datetimepicker6').data("DateTimePicker").maxDate(e.date);
        });
        });
    </script>


    <script>

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
        var start = null;
        start = document.getElementById('start').value;
        var d = new Date(start);
        var end = null;
        end = document.getElementById('end').value;
        var d1 = new Date(end);
        var parameters = [
        ["fileName", document.getElementById('myInput1').value],
        ["contentType", document.getElementById('myInput2').value],
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
        request.onload = function ()  {
        funct1 = request.response;
        dispfilter(funct1);
        console.log(funct1);
        };
        };
        //
        //            
        function dispfilter(jsonObj){
                var fileurl = "http://localhost:8080/MeOnCloud/drive/docs/";
        noOfFiles = jsonObj['payload']['drive'] ['noOfFiles'];
        console.log(noOfFiles);
        var files = jsonObj['payload']['drive']['files'];
        var table = document.createElement("table");
        table.setAttribute("id", "tab1");
        var tr = table.insertRow( - 1);
        var col = [];
        for (var i = 0; i < files.length; i++){
        for (var key in files[i]){
        if (col.indexOf(key) == - 1){
        col.push(key);
        }
        }
        }
        



        tr = table.insertRow( - 1);
        //table header
        for (var i = 0; i < col.length; i++) {
        var th = document.createElement("th");
        var th1 = document.createElement("th");
        var th2 = document.createElement("th");
        }
        th.innerHTML = "Name";
        th1.innerHTML = "ContentType";
        th2.innerHTML = "Last Edited";
        tr.appendChild(th);
        tr.appendChild(th1);
        tr.appendChild(th2);
        //table rows


        for (var i = 0; i < files.length; i++) {


        tr = table.insertRow( - 1);
        var tbody = document.createElement("tbody");
        tbody.setAttribute("id", "tbody");
        //for (var j = 0; j < col.length; j++) {
        var tabCell = tr.insertCell( - 1);
        var tabcell2 = tr.insertCell( - 1);
        var tabcell3 = tr.insertCell( - 1);
        var fileid = files[i]['id'];
        var filename = files[i]['name']; var locationurl = fileurl + fileid;
        //locationurl = locationurl+name;
        tabCell.innerHTML = '<span class="fa fa-file-picture-o" style="font-size:36px;color:blue"></span> <a href=" ' + locationurl + '"> ' + filename + '</a>';
        tabcell2.innerHTML = files[i]['mimeType'];
        tabcell3.innerHTML = files[i]['lastEdited'];
        }

        var divContainer = document.getElementById("tab");
        divContainer.innerHTML = " ";
        divContainer.appendChild(table);
       // $(document).ready(function(){
//    $('#tab').after('<div id="container"></div>');
//    var rowsShown = 10;
//   // var rowsTotal = $('#data tbody tr').length;
//    var numPages = noOfFiles/rowsShown;
//            console.log(numPages);
//             //    for(i = 0;i < numPages;i++) {
//                var pageNum = i + 1; 
//                //$('#container').append('<a href="#" rel="'+i+'">'+pageNum+'</a> ');
//    }
//    $('#noOfFiles').hide();
//    $('#noOfFiles').slice(0, rowsShown).show();
//            $('#container a:first').addClass('active');
//    $('#container a').bind('click', function(){
//
//        $('#nav a').removeClass('active');
//        $(this).addClass('active');
//        var currPage = $(this).attr('rel');
//        var startItem = currPage * rowsShown;
//        var endItem = startItem + rowsShown;
//        $('#noOfFiles').css('opacity','0.0').hide().slice(startItem, endItem).
//        css('display','table-row').animate({opacity:1}, 300);
//    });
        }; 







    </script>









</body>

</html>


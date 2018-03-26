<%-- 
    Document   : meta_data
    Created on : 19 Jan, 2018, 1:47:10 PM
    Author     : Nivetha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.0/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
           </head>
    <body>
      <div class="container">
           <form  class = "form-inline" method="POST" action="">
            <div class = "form-group ">

                <div class="">
                    <label for="" class="form-inline" value="">MetaData Name</label>
                    <input type = "text" class = "form-control" id="myInput1"   placeholder = "Enter name">

                </div>
            </div>
               <br>
               <br>
    <div class="row clearfix">
		<div class="col-md-12 column">
			<table class="table table-bordered table-hover" id="tab_logic">
				<thead>
					<tr >
						
						<th class="text-center">
                                                    ID
						</th>
						<th class="text-center">
                                                        KEY
						</th>
						
					</tr>
				</thead>
				<tbody>
					<tr id='addr0'>
						
<!--						<td>
						<input type="text" name='name0'  placeholder='Name' class="form-control"/>
						</td>
						<td>
						<input type="text" name='id0' placeholder='ID' class="form-control"/>
						</td>
						<td>
						<input type="text" name='key0' placeholder='KEY' class="form-control"/>
						</td>-->
					</tr>
                    <tr id='addr1'></tr>
				</tbody>
			</table>
		</div>
	</div>
      </div>
	<a id="add_row" class="btn btn-default pull-left">Add Row</a><a id='delete_row' class="pull-right btn btn-default">Delete Row</a>
    </body>
</html>
<script>
    $(document).ready(function(){
      var i=1;
     $("#add_row").click(function(){
      $('#addr'+i).html("<td><input name='name"+i+"' type='text' placeholder='ID' class='form-control input-md'  /> </td><td><input  name='mail"+i+"' type='text' placeholder='KEY'  class='form-control input-md'></td>");

      $('#tab_logic').append('<tr id="addr'+(i+1)+'"></tr>');
      i++; 
  });
     $("#delete_row").click(function(){
    	 if(i>1){
		 $("#addr"+(i-1)).html('');
		 i--;
		 }
	 });

});
    </script>
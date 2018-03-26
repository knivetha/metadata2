<%-- 
    Document   : login
    Created on : 8 Feb, 2018, 10:37:43 AM
    Author     : Nivetha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html>
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">

        <!-- jQuery library -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

        <!-- Latest compiled JavaScript -->
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <style>
            body {font-family: Arial, Helvetica, sans-serif;}
            form {border: 3px solid #f1f1f1;}

            input[type=text], input[type=password] {
                width: 100%;
                padding: 12px 20px;
                margin: 8px 0;
                display: inline-block;
                border: 1px solid #ccc;
                box-sizing: border-box;
            }

            button {
                background-color: #4CAF50;
                color: white;
                padding: 14px 20px;
                margin: 8px 0;
                border: none;
                cursor: pointer;
                width: 100%;
            }

            button:hover {
                opacity: 0.8;
            }

            .cancelbtn {
                width: auto;
                padding: 10px 18px;
                background-color: #f44336;
            }
            .signupbtn {
                width: auto;
                padding: 10px 18px;
                background-color: #4CAF50;
            }
            .imgcontainer {
                text-align: center;
                margin: 24px 0 12px 0;
            }

            img.avatar {
                width: 40%;
                border-radius: 50%;
            }

            .container {
                padding: 16px;
            }

            span.psw {
                float: right;
                padding-top: 16px;
            }
            .sidenav{               
                height: 100%;
                width: 350px;
                position: static ;
                z-index: 1;
                top: 0;
                left: 0;
                overflow-x: hidden;
                padding-top: 10px;
            }

            /* Change styles for span and cancel button on extra small screens */
            @media screen and (max-width: 300px) {
                span.psw {
                    display: block;
                    float: none;
                }
                .cancelbtn {
                    width: 100%;
                }
            }
        </style>
    </head>
    <body>



        <form action="login" method="POST">
            <div class = "main page-header" align="center">
                <h2>
                    Document Management

                </h2>
            </div>
            <div class="container col-sm-3">
            </div> 

            <div class ="container col-sm-3"><img class="sidenav" src="./images/dropbox.jpg"/></div>
            <div class="container col-sm-3" style="background-color:#ffffff">
                <label for="uname"><b>Email</b></label>
                <input type="text" class="w3-round" placeholder="Enter Email" name="email" required>

                <label for="psw"><b>Password</b></label>
                <input type="password" class="w3-round" placeholder="Enter Password" name="password" required>
                <label for="radio"></label>
                <input type="radio" name="loginType" value="admin" onclick="getAnswer('admin')"><b>Admin</b>&nbsp;&nbsp;&nbsp;
                <input type="radio" name="loginType" value="user" checked="checked" onclick="getAnswer('user')"><b>User</b>

                <button type="submit" class="w3-blue w3-round" name="login">Login</button>
                <label for="button" name="create an account here" style/>Create an account here</label>
                <button type="submit" class="signupbtn w3-blue w3-round w3-right"  onclick="window.location.href = 'signUp.jsp'" name="signUp">Signup</button>

            </div>
            <p style="color :red">
                ${status}
            </p>    

        </form>

    </body>
</html>


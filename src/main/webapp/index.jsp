<%@ page import="java.util.Date, java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html>
<head>
    <title>Calculator App</title>

    <style>
        *{
            margin:0;
            padding:0;
            box-sizing:border-box;
            font-family:Arial, Helvetica, sans-serif;
        }

        body{
            background:linear-gradient(135deg,#4facfe,#00f2fe);
            display:flex;
            justify-content:center;
            align-items:center;
            height:100vh;
        }

        .container{
            width:400px;
            background:#fff;
            padding:30px;
            border-radius:15px;
            box-shadow:0 10px 25px rgba(0,0,0,0.2);
            text-align:center;
        }

        h2{
            color:#333;
            margin-bottom:10px;
        }

        .date{
            color:#555;
            font-size:15px;
            margin-bottom:15px;
        }

        .build{
            background:#e8f5e9;
            color:#2e7d32;
            padding:10px;
            border-radius:8px;
            margin-bottom:20px;
            font-weight:bold;
        }

        .row{
            display:flex;
            justify-content:center;
            align-items:center;
            gap:10px;
            margin-bottom:20px;
        }

        input[type=text]{
            width:90px;
            padding:10px;
            border:1px solid #ccc;
            border-radius:8px;
            font-size:16px;
            text-align:center;
        }

        label{
            font-size:24px;
            font-weight:bold;
        }

        input[type=submit]{
            background:#2196F3;
            color:white;
            border:none;
            padding:12px 25px;
            border-radius:8px;
            font-size:16px;
            cursor:pointer;
            transition:.3s;
        }

        input[type=submit]:hover{
            background:#1565C0;
        }

        .result{
            margin-top:20px;
            padding:12px;
            background:#f1f8e9;
            border-left:5px solid green;
            color:#2e7d32;
            font-size:18px;
            font-weight:bold;
            border-radius:5px;
        }
    </style>
</head>

<body>

<%
    String strResult = (String) request.getAttribute("RESULT");
    String currentDate = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss").format(new Date());
%>

<div class="container">

    <h2>🧮 Calculator App</h2>

    <div class="date">
        <strong>Current Date:</strong> <%= currentDate %>
    </div>

    <div class="build">
        🚀 Website Updated Successfully!<br>
        Build Time: <%= currentDate %>
    </div>

    <form action="CalculatorServlet" method="post">

        <div class="row">
            <input type="text" name="num1" placeholder="Number 1">

            <label>+</label>

            <input type="text" name="num2" placeholder="Number 2">

            <label>=</label>
        </div>

        <input type="submit" value="Calculate">

    </form>

    <% if(strResult != null){ %>

        <div class="result">
            ✅ Result : <%= strResult %>
        </div>

    <% } %>

</div>

</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Application Review</title>
    <style>
        body {
            font-family: Arial;
            background-color: #f5f5f5;
            text-align: center;
        }
        h1 {
            color: #333;
        }
        table {
            margin: 20px auto;
            border-collapse: collapse;
            width: 60%;
            background: white;
        }
        th, td {
            border: 1px solid #ccc;
            padding: 10px;
        }
        th {
            background-color: #007BFF;
            color: white;
        }
        button {
            padding: 6px 12px;
            margin: 2px;
            border: none;
            cursor: pointer;
        }
        .approve {
            background-color: #28a745;
            color: white;
        }
        .reject {
            background-color: #dc3545;
            color: white;
        }
    </style>
</head>

<body>

<h1>Application Review System</h1>

<table>
    <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Status</th>
        <th>Action</th>
    </tr>

    <tr>
        <td>1</td>
        <td>John Doe</td>
        <td>Pending</td>
        <td>
            <button class="approve">Approve</button>
            <button class="reject">Reject</button>
        </td>
    </tr>

    <tr>
        <td>2</td>
        <td>Jane Smith</td>
        <td>Pending</td>
        <td>
            <button class="approve">Approve</button>
            <button class="reject">Reject</button>
        </td>
    </tr>

</table>

</body>
</html>

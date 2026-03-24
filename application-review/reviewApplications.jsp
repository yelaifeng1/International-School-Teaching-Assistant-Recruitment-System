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
            width: 80%;
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
<p>Admin can review applications below</p>

<table>
    <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Job Title</th>
        <th>Reason</th>
        <th>Status</th>
        <th>Action</th>
    </tr>

    <tr>
        <td>1</td>
        <td>John Doe</td>
        <td>Java TA</td>
        <td>I have experience in Java and teamwork.</td>
        <td>Pending</td>
        <td>
            <form action="reviewApplication" method="post">
                <input type="hidden" name="id" value="1">
                <button class="approve" type="submit" name="status" value="Approved">Approve</button>
                <button class="reject" type="submit" name="status" value="Rejected">Reject</button>
            </form>
        </td>
    </tr>

    <tr>
        <td>2</td>
        <td>Jane Smith</td>
        <td>Database TA</td>
        <td>I am good at SQL and data analysis.</td>
        <td>Pending</td>
        <td>
            <form action="reviewApplication" method="post">
                <input type="hidden" name="id" value="2">
                <button class="approve" type="submit" name="status" value="Approved">Approve</button>
                <button class="reject" type="submit" name="status" value="Rejected">Reject</button>
            </form>
        </td>
    </tr>

</table>

</body>
</html>

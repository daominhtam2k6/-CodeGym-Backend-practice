<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<!DOCTYPE html>

<html lang="vi">

<head>

    <meta charset="UTF-8">

    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0"
    >

    <title>
        CodeGym JSP Demo
    </title>

</head>


<body
    style="
        margin: 0;
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        background-color: #f8fafc;
        font-family: Arial, sans-serif;
    "
>

    <main
        style="
            width: min(700px, 90%);
            padding: 40px;
            text-align: center;
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 10px 35px rgba(0, 0, 0, 0.08);
        "
    >

        <p
            style="
                margin-bottom: 10px;
                color: #64748b;
                font-size: 14px;
                font-weight: bold;
                text-transform: uppercase;
            "
        >
            JSP / Servlet Demo
        </p>


        <h1
            style="
                margin-top: 0;
                color: #1b2a7a;
                font-size: 36px;
            "
        >
            Chào mừng tới lớp học Java Web!
        </h1>


        <p
            style="
                color: #475569;
                font-size: 18px;
                line-height: 1.6;
            "
        >
            Đây là trang JSP động được xử lý trực tiếp
            bởi máy chủ Tomcat.
        </p>


        <%
            java.util.Date date = new java.util.Date();
        %>


        <div
            style="
                margin: 30px 0;
                padding: 25px;
                background-color: #eff6ff;
                border-radius: 10px;
            "
        >

            <p
                style="
                    margin-top: 0;
                    color: #64748b;
                "
            >
                Thời gian hệ thống hiện tại:
            </p>


            <strong
                style="
                    color: #f15a24;
                    font-size: 22px;
                "
            >
                <%= date %>
            </strong>

        </div>


        <p
            style="
                color: #64748b;
                line-height: 1.6;
            "
        >
            Giá trị trên được tạo bằng Java ngay trên Server
            mỗi lần trang JSP được xử lý.
        </p>


        <br>


        <a
            href="hello"
            style="
                display: inline-block;
                padding: 12px 22px;
                border-radius: 6px;
                background-color: #1b2a7a;
                color: white;
                text-decoration: none;
                font-weight: bold;
            "
        >
            Đi tới HelloServlet
        </a>

    </main>

</body>

</html>

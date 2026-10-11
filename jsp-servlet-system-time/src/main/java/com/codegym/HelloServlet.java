package com.codegym;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet dau tien cua du an.
 *
 * URL:
 * /hello
 */
@WebServlet(
        name = "HelloServlet",
        urlPatterns = {"/hello"}
)
public class HelloServlet extends HttpServlet {

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        response.setContentType(
                "text/html;charset=UTF-8"
        );

        try (PrintWriter out = response.getWriter()) {

            out.println("<!DOCTYPE html>");

            out.println("<html lang='vi'>");

            out.println("<head>");

            out.println("<meta charset='UTF-8'>");

            out.println(
                    "<meta name='viewport' " +
                    "content='width=device-width, initial-scale=1.0'>"
            );

            out.println(
                    "<title>Hello Servlet</title>"
            );

            out.println("</head>");

            out.println(
                    "<body style='" +
                    "font-family: Arial, sans-serif;" +
                    "text-align: center;" +
                    "margin-top: 100px;" +
                    "background-color: #f8fafc;" +
                    "'>"
            );

            out.println(
                    "<h1 style='" +
                    "color: #1b2a7a;" +
                    "'>" +
                    "Chào mừng bạn đến với Servlet đầu tiên!" +
                    "</h1>"
            );

            out.println(
                    "<p style='" +
                    "color: #f15a24;" +
                    "font-size: 18px;" +
                    "'>" +
                    "Ứng dụng đang chạy trên Jakarta Servlet / Tomcat 10+" +
                    "</p>"
            );

            out.println(
                    "<a href='index.jsp'>" +
                    "Quay lại trang chủ JSP" +
                    "</a>"
            );

            out.println("</body>");

            out.println("</html>");
        }
    }
}

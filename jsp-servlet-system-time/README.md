# Thực hành - Tạo trang web hiển thị thời gian hệ thống

## Mục tiêu

Tạo ứng dụng Java Web đơn giản bằng JSP và Servlet.

Ứng dụng hiển thị thời gian hiện tại của máy chủ.

## Công nghệ

- Java 17
- Maven
- JSP
- Jakarta Servlet 6
- Tomcat 10.1+

## Cấu trúc

Thư mục Java:

src/main/java/com/codegym

Servlet:

HelloServlet.java

Web application:

src/main/webapp

Trang JSP:

index.jsp

Cấu hình:

WEB-INF/web.xml

## Jakarta Servlet

Tomcat 10 trở lên sử dụng:

jakarta.servlet

không sử dụng:

javax.servlet

## Trang JSP

index.jsp tạo đối tượng:

java.util.Date

và hiển thị thời gian hệ thống trên Server.

## Servlet

HelloServlet được định tuyến bằng:

@WebServlet

URL:

/hello

## Maven

Build bằng:

mvn clean package

Sau khi build thành công, file WAR nằm tại:

target/jsp-servlet-demo.war

## URL kiểm tra khi deploy Tomcat

Trang chủ:

http://localhost:8080/jsp-servlet-demo/

Servlet:

http://localhost:8080/jsp-servlet-demo/hello

## File chính

- pom.xml
- src/main/java/com/codegym/HelloServlet.java
- src/main/webapp/index.jsp
- src/main/webapp/WEB-INF/web.xml

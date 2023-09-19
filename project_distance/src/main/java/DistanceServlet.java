

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/DistanceServlet")
public class DistanceServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 웹 페이지에서 전송된 거리 정보 가져오기
        String distance = request.getParameter("distance");

        // Oracle 데이터베이스 연결 설정
        String jdbcUrl = "jdbc:oracle:thin:@localhost:1521:ORCL";
        String dbUser = "jsp";
        String dbPassword = "123456";

        try {
            // Oracle JDBC 드라이버 로드
            Class.forName("oracle.jdbc.driver.OracleDriver");

            // 데이터베이스 연결
            Connection connection = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);

            // SQL 쿼리를 사용하여 거리 정보를 데이터베이스에 저장
            String insertQuery = "INSERT INTO MOVING_COST (DISTANCE_KM) VALUES (?);";
            PreparedStatement preparedStatement = connection.prepareStatement(insertQuery);
            preparedStatement.setString(1, distance);
            preparedStatement.executeUpdate();

            // 데이터베이스 연결 종료
            preparedStatement.close();
            connection.close();

            // 거리 정보를 저장한 후 메시지를 응답으로 보내기
            response.getWriter().write("거리 정보가 성공적으로 저장되었습니다.");
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            response.getWriter().write("거리 정보를 저장하는 동안 오류가 발생했습니다.");
        }
    }
}

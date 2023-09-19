<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import = "java.util.Enumeration"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>상품 목록 및 결제 정보</title>
</head>
<body>
	 <h1>합계</h1>
	 // 이미지가 표시되는 부분
	 <div id="imageContainer">
	</div>
	    <%
	        double totalAmount = 0;
	        Enumeration<String> parameterNames = request.getParameterNames();
	        
	        // 수량, 가격, 소계 한줄씩 계산
	        while (parameterNames.hasMoreElements()) {
	            String paramName = parameterNames.nextElement();
	            if (paramName.startsWith("quantity_")) {
	                String productName = paramName.substring("quantity_".length());
	                int quantity = Integer.parseInt(request.getParameter(paramName));
	                double price = Double.parseDouble(request.getParameter("selectedProducts"));
	                int productPrice = (int) Math.floor(price);
	                double subtotal = quantity * productPrice;
	                int subtotalPrice = (int) Math.floor(subtotal);
	                totalAmount += subtotal;
	    %>
		<!-- 계산하기 누른 이후 <h1>합계</h1>아래 텍스트로 출력하는 부분 -->
	    <p><%= productName %> - <%= quantity %>개, 소계: <%= subtotalPrice %>원</p>
	    <%
	            }
	        }
	    %>
 		<!-- 그 아래 모든 품목의 가격 총합 출력하는 부분 -->
	    <p>총 <%= (int)totalAmount %>원</p>
	    
	    <h1>상품 목록</h1>
	    <form action="" method="post">
	        <% 
	        	// 오라클 DB에서 GOODS 테이블의 모든 요소 SELECT
	            Class.forName("oracle.jdbc.driver.OracleDriver");
	            Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:ORCL", "jsp", "123456");
	            PreparedStatement pstmt = conn.prepareStatement("SELECT NAME, PRICE FROM GOODS");
	            ResultSet rs = pstmt.executeQuery();
	            
	            // 한줄씩 읽어온 뒤, 상품명, 가격 저장
	            while (rs.next()) {
	                String productName = rs.getString("NAME");
	                double price = rs.getDouble("PRICE");
	                // PRICE를 정수로 변환
	                int productPrice = (int) Math.floor(price);
	        %>
	        <!-- 상품목록 아래 while문을 통해 한줄씩 출력 ex) refrigerator- 200000원 [0] -->	     
	        <label>
	            <input type="checkbox" name="selectedProducts" id = "<%= productName %>" value="<%= productPrice %>"> <%= productName %> - <%= productPrice %>원
	            <input type="number" name="quantity_<%= productName %>" value="0" disabled>
	        </label><br>
	        <%
	            }
	            // DB와 연결 종료
	            rs.close();
	            pstmt.close();
	            conn.close();
	        %>
	        <!-- 계산하기 버튼 -->
	        <br>
	        <input type="submit" value="계산하기">
	    </form>
    <script>
    // 체크박스 작동 스크립트
    var checkboxes = document.querySelectorAll('input[type="checkbox"][name="selectedProducts"]');
    checkboxes.forEach(function(checkbox) {
        checkbox.addEventListener('change', function() {
        	// 상품명, 개수, 연동할 이미지를 57~60번째 줄에서 입력한 텍스트에서 추출
            var productName = this.nextSibling.textContent.split('-')[0].trim();
            var quantityInput = document.querySelector('input[type="number"][name="quantity_' + productName + '"]');
            var imageContainer = document.getElementById('imageContainer');
            var image = new Image();
			// 이미지 경로 지정
            var imagePath = 'imgs/' + productName + ".png";
            image.src = imagePath;
            image.alt = productName;
			
            // 이미지가 없을 경우
            if (this.checked) {
                imageContainer.appendChild(image);
            } else {
            	// 이미지가 존재할 경우
                var existingImage = document.querySelector('img[alt="' + productName + '"]');
                if (existingImage) {
                    imageContainer.removeChild(existingImage);
                }
            }
            quantityInput.disabled = !this.checked;
        });
    });
    </script>
</body>
</html>

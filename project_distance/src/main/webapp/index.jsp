<!DOCTYPE html>
<html>
<head>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<title>거리 계산</title>
</head>
<body>
<form action="result.jsp" type="POST">
<input type="text" id="origin_postcode" placeholder="출발지 우편번호">
<input type="button" onclick="execDaumPostcode('origin')" value="출발지 우편번호 찾기"><br>
<input type="text" id="origin_address"  name="origin_address" placeholder="출발지 주소"><br>
<input type="text" id="origin_detailAddress" placeholder="출발지 상세주소">
<input type="text" id="origin_extraAddress" placeholder="출발지 참고항목">
<br>
<input type="text" id="destination_postcode" placeholder="도착지 우편번호">
<input type="button" onclick="execDaumPostcode('destination')" value="도착지 우편번호 찾기"><br>
<input type="text" id="destination_address" name="destination_address" placeholder="도착지 주소"><br>
<input type="text" id="destination_detailAddress" placeholder="도착지 상세주소">
<input type="text" id="destination_extraAddress" placeholder="도착지 참고항목">
<br>
<button type="submit">확정</button>
</form>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>

function execDaumPostcode(type) {
    new daum.Postcode({
        oncomplete: function (data) {
            // 팝업에서 검색결과 항목을 클릭했을 때 실행할 코드를 작성하는 부분.
            // 각 주소의 노출 규칙에 따라 주소를 조합한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var addr = ''; // 주소 변수
            var extraAddr = ''; // 참고항목 변수

            // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
            if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                addr = data.roadAddress;
            } else { // 사용자가 지번 주소를 선택했을 경우(J)
                addr = data.jibunAddress;
            }

            // 사용자가 선택한 주소가 도로명 타입일 때 참고항목을 조합한다.
            if (data.userSelectedType === 'R') {
                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
                    extraAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if (data.buildingName !== '' && data.apartment === 'Y') {
                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if (extraAddr !== '') {
                    extraAddr = ' (' + extraAddr + ')';
                }
                // 조합된 참고항목을 해당 필드에 넣는다.
                document.getElementById(type + "_extraAddress").value = extraAddr;
            } else {
                document.getElementById(type + "_extraAddress").value = '';
            }

            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            document.getElementById(type + '_postcode').value = data.zonecode;
            document.getElementById(type + "_address").value = addr;
            // 커서를 상세주소 필드로 이동한다.
            document.getElementById(type + "_detailAddress").focus();
        }
    }).open();
}

/*function confirmOriginAddress() {
  originsAddress = `${document.getElementById("origin_address").value}`;
  alert("출발지 주소가 확정되었습니다.");
}*/

/*function confirmDestinationAddress() {
  destinationsAddress = `${document.getElementById("destination_address").value}`;
  alert("도착지 주소가 확정되었습니다.");
}*/
</script>
</body>
</html>

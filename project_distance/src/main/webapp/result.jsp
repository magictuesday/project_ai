<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>출발지/도착지 주소</title>
</head>
<body>
<% request.setCharacterEncoding("UTF-8");
String origin_Address = request.getParameter("origin_address");
String destination_Address = request.getParameter("destination_address");%>
<script>
const originsAddress = '<%=origin_Address%>';
const destinationsAddress = '<%=destination_Address%>';
console.log(originsAddress);
console.log(destinationsAddress);

const geocodingApiKey = "AIzaSyAudjpTypPWJYwQeCpwwifiwJPWFpRmML8";
const distanceMatrixApiKey = "AIzaSyAudjpTypPWJYwQeCpwwifiwJPWFpRmML8";
const baseUrl = `https://maps.googleapis.com/maps/api/geocode/json?address=`;
const lastUrl = `&key=`;

async function getGeocode_origin(address) {
	const geocodingUrl_origin = baseUrl + originsAddress + lastUrl + geocodingApiKey;
	  const response = await fetch(geocodingUrl_origin);
	  const data = await response.json();
	  
	  if (data.status === "OK") {
	    const location = data.results[0].geometry.location;
	    return [location.lat, location.lng];
	  } else {
	    return null;
	  }
	}

async function getGeocode_destination(address) {
	const geocodingUrl_destinations = baseUrl + destinationsAddress + lastUrl + geocodingApiKey;
	  const response = await fetch(geocodingUrl_destinations);
	  const data = await response.json();
	  
	  if (data.status === "OK") {
	    const location = data.results[0].geometry.location;
	    return [location.lat, location.lng];
	  } else {
	    return null;
	  }
	}
	
	async function main() {
	  const origins = await getGeocode_origin(originsAddress);
	  const destinations = await getGeocode_destination(destinationsAddress);

	  if (origins && destinations) {
	    const mode = "transit";
	    const base = "https://corsproxy.io/?https://maps.googleapis.com/maps/api/distancematrix/json?";
	    
	    const url = base + 'origins=' + origins[0] +',' + origins[1] +'&destinations='+destinations[0] +',' + destinations[1] + '&mode=transit&key=' + distanceMatrixApiKey
	    
	    const response = await fetch(url);
	    const data = await response.json();
	    
	    if (data.status === "OK") {
	        const distance = data.rows[0].elements[0].distance.text;
	        const duration = data.rows[0].elements[0].duration.text;
	        console.log(`거리 : `+ distance);
	        console.log(`소요 시간: `+ duration);

	        const distanceResult = document.getElementById("distanceResult");
	        distanceResult.innerHTML = `거리 : ` + distance;
	        const durationResult = document.getElementById("durationResult");
	        durationResult.innerHTML = `소요 시간 : ` + duration;
	        
	      } else {
	        console.log("거리 및 시간 정보를 가져오지 못했습니다.");
	      }

	    }
	}

	main();
	
	async function saveDistanceToDatabase(distance) {
	    const url = "/project_distance/DistanceServlet"; // 웹 어플리케이션의 경로에 맞게 수정
	    const params = new URLSearchParams();
	    params.append("distance", distance);

	    try {
	        const response = await fetch(url, {
	            method: "POST",
	            body: params,
	            headers: {
	                "Content-Type": "application/x-www-form-urlencoded",
	            },
	        });

	        if (response.ok) {
	            console.log("거리 정보를 서버에 성공적으로 전송했습니다.");
	        } else {
	            console.error("거리 정보 전송 실패");
	        }
	    } catch (error) {
	        console.error("거리 정보 전송 중 오류 발생: " + error);
	    }
	}
</script>
<h1>출발지/도착지 주소</h1>
<%
out.println(origin_Address);%><br>
<% out.println(destination_Address); %>
<div id="distanceResult"></div>
<div id="durationResult"></div>
</body>
</html> 
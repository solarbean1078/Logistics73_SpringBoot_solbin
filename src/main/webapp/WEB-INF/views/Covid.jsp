<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script type="text/javascript" src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=c627f47379e4f576d3e8ab9a1d854f03"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.js"
            integrity="sha256-H+K7U5CnXl1h5ywQfKtSj8PCmoN9aaq30gDh27Xc0jk="
            crossorigin="anonymous"></script>
    <meta charset="utf-8" />

</head>
<body>
<h1>나와라 제발,,,</h1>
<div id="map" style="width:1200px;height:650px;"></div>

<script>
    var mapContainer = document.getElementById('map'), // 지도를 표시할 div
        mapOption = {
            center: new kakao.maps.LatLng(35.15969318366887,128.10630544997963), // 지도의 중심좌표
            level: 1, // 지도의 확대 레벨
            mapTypeId : kakao.maps.MapTypeId.ROADMAP // 지도종류
        };

    // 지도를 생성한다
   var map = new kakao.maps.Map(mapContainer, mapOption);

    // 지도에 확대 축소 컨트롤을 생성한다
    var zoomControl = new kakao.maps.ZoomControl();

    // 지도의 우측에 확대 축소 컨트롤을 추가한다
    map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

    // 지도에 마커를 생성하고 표시한다
    var marker = new kakao.maps.Marker({
        position: new kakao.maps.LatLng(35.15969318366887,128.10630544997963), // 마커의 좌표
        map: map // 마커를 표시할 지도 객체
    });

</script>
</body>
</html>
<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/offshop/lib/classes/offshopCls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'#######################################################
'	Description : 오프라인페이지
'	History	:  2018.06.18 정태훈 생성
'#######################################################

'매장 정보 가져오기
Dim offshopinfo, shopid, arrMainGallery, offshopMainGallery, ix
shopid = requestCheckVar(request("shopid"),16)
If shopid="" Then shopid="streetshop011"
'Response.write shopid
'Response.end
Set  offshopinfo = New COffShop
offshopinfo.FRectShopID=shopid
offshopinfo.GetOneOffShopContents
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=523d793577f1c5116aacc1452942a0e5&libraries=services"></script>
<script>
$(function(){
	// 최초 지도 표시
	initialize();
});

function initialize(rtaddr,nm) {
	if(!rtaddr) rtaddr="<%=offshopinfo.FOneItem.FShopAddr1%> <%=offshopinfo.FOneItem.FShopAddr2%>";
	if(!nm)		nm="<%=offshopinfo.FOneItem.FShopName%>";
	
	$("#mapViewBig").empty();
	
	setTimeout(function() {
		var mapContainer = document.getElementById('mapViewBig'),
			mapOption = {
				center: new daum.maps.LatLng(37.582708, 127.003605), // 지도의 중심좌표
				level: 3 // 지도의 확대 레벨
			};

		// 지도 생성
		var map = new daum.maps.Map(mapContainer, mapOption); 

		var geocoder = new daum.maps.services.Geocoder();	// 주소-좌표 변환 객체를 생성
		var addr=rtaddr;
		var lat="";
		var lng="";
		// 주소로 좌표를 검색합니다
		geocoder.addressSearch(addr, function(result, status) {
			if (status === daum.maps.services.Status.OK) {
				var coords = new daum.maps.LatLng(result[0].y, result[0].x);
				var marker = new daum.maps.Marker({
					map: map,
					position: coords
				});

				// 인포윈도우로 장소에 대한 설명을 표시
				var infowindow = new daum.maps.InfoWindow({
					content: '<div style="width:150px;text-align:center;padding:6px 0;">'+nm+'</div>'
				});
				infowindow.open(map, marker);

				// 지도의 중심을 결과값으로 받은 위치로 이동
				map.setCenter(coords);
			} 
		});
	}, 200);
}

function geocodenew() {
	var address = "";
	var addrurl = "";
	address = "<%=offshopinfo.FOneItem.FShopAddr1%> <%=offshopinfo.FOneItem.FShopAddr2%>";
	addrurl = "http://map.daum.net/link/search/"+address;
	window.open(addrurl, "_blank");
}
</script>
</head>
<div style="height:100%;">
	<div id="mapViewBig"></div>
</div>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/incfooter.asp" -->
</body>
</html>
<%
Set  offshopinfo = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
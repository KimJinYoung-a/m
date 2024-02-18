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

Set  offshopMainGallery = New COffShopGallery
offshopMainGallery.FShopId=shopid
arrMainGallery = offshopMainGallery.fnGetShopMainGallery

Dim ClsOSBoard
Dim arrNotice

set ClsOSBoard = new COffshopBoard
	ClsOSBoard.FCPage	= 1
	ClsOSBoard.FPSize	= 3
	ClsOSBoard.FShopId = shopid
	arrNotice = ClsOSBoard.fnGetNotice
set ClsOSBoard = nothing
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<script>
$(function(){
	var offshopSwiper = new Swiper("#offshopSwiper .swiper-container", {
		pagination:"#offshopSwiper .pagination",
		paginationClickable:true,
		autoplay:2600,
		loop:true,
		speed:600
	});
});
</script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=523d793577f1c5116aacc1452942a0e5&libraries=services"></script>
<script>
$(function(){
	// 최초 지도 표시
	initialize();
});

function initialize(rtaddr,nm) {
	if(!rtaddr) rtaddr="<%=offshopinfo.FOneItem.FShopAddr1%> <%=offshopinfo.FOneItem.FShopAddr2%>";
	if(!nm)		nm="<%=offshopinfo.FOneItem.FShopName%>";
	
	$("#mapView").empty();
	
	setTimeout(function() {
		var mapContainer = document.getElementById('mapView'),
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
<body class="default-font body-sub">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<!-- contents -->
	<div class="content offshopV18" id="contentArea">
		<div class="offshop-info">
			<h2 class="hidden">오프라인매장 정보</h2>

			<!-- for dev msg 롤링 최대 5개-->
			<div id="offshopSwiper" class="gallery">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<% If isArray(arrMainGallery) Then %>
						<% For ix = 0 To UBound(arrMainGallery,2) %>
						<div class="swiper-slide"><img src="<%=arrMainGallery(0,ix)%>" alt=""></div>
						<% Next %>
						<% Else %>
						<div class="swiper-slide"></div>
						<% End If %>
					</div>
					<div class="pagination"></div>
				</div>
			</div>
			<!--  롤링 -->

			<h3><em><%=offshopinfo.FOneItem.FShopName%></em><span><%=offshopinfo.FOneItem.FEngName%></span></h3>
			<div class="offshop-info">
				<div class="txt">
					<div>
						<em><%=offshopinfo.FOneItem.FMobileWorkHour%></em>
						<p>휴무일은 공지사항을 참고해주세요</p>
					</div>
					<div>
						<em><a href="tel:<%=offshopinfo.FOneItem.FShopPhone%>"><%=offshopinfo.FOneItem.FShopPhone%></a></em>
						<% If offshopinfo.FOneItem.FShopFax<>"" Then %><p>FAX <%=offshopinfo.FOneItem.FShopFax%></p><% End If %>
					</div>

					<a href="/my10x10/qna/myqnaoffshopwrite.asp?offshopqna=<%=offshopinfo.FOneItem.FShopName%>" class="btn btn-small btn-red btn-radius btn-inquiry" target="_blank">문의하기<span>contact us</span></a>
				</div>

				<% If isArray(arrNotice) Then %>
				<ul class="latest-noti">
					<% For ix = 0 To UBound(arrNotice,2) %>
					<li>
						<a href="javascript:fnOpenModal('shopnotice.asp?idx=<%=db2html(arrNotice(0,ix))%>');">
							<span class="tit"><%=db2html(arrNotice(3,ix))%></span>
							<span class="date ftRt"><%=FormatDate(arrNotice(6,ix),"0000.00.00")%></span>
						</a>
					</li>
					<% Next %>
				</ul>
				<% End If %>
				<!--// 매장 공지사항 -->

				<!-- 매장 지도 -->
				<div class="map">
					<div class="address">
						<a href="javascript:geocodenew()">
							<em><i></i><%=offshopinfo.FOneItem.FShopAddr1%> <%=offshopinfo.FOneItem.FShopAddr2 %></em>
							<p><%=offshopinfo.FOneItem.FEngAddress%></p>
						</a>
					</div>
					<div class="google-map" id="mapView"></div>
				</div>
				<!--// 매장 지도 -->
			</div>
		</div>
	</div>
	<!-- //contents -->
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
<div id="modalLayer" style="display:none;"></div>
<div id="modalLayer2" style="display:none;"><div id="modalLayer2Contents"></div><div id="dimed"></div></div>
</body>
</html>
<%
Set  offshopinfo = Nothing
Set  offshopMainGallery = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
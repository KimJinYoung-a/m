<%
    '2019-01-07 클래스 상품 위치정보 내용 설명 tab으로 이동
    '2019-01-14 위치 정보 api 변경 google -> daum
    '티켓상품 - 위치 정보
    If IsTicketItem Then
%>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=523d793577f1c5116aacc1452942a0e5&libraries=services"></script>
    <script>
    $(function(){
        // 최초 지도 표시
        initMap();
    });

    function initMap(rtaddr,nm) {
        if(!rtaddr) rtaddr="<%=oTicket.FOneItem.FtPAddress%>";
        if(!nm)		nm="<%=trim(oTicket.FOneItem.FticketPlaceName)%>";
        
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
    </script>
    <div class="posInfo">
        <dl class="odrNote2V16a">
            <dt>위치 정보</dt>
            <dd class="pdtDetailListV16a  ">
                <p class="ticketPlaceName"><%=oTicket.FOneItem.FticketPlaceName%></p>
                <ul>
                    <li>주소 : <%=oTicket.FOneItem.FtPAddress%></li>
                    <li>전화번호 : <%=oTicket.FOneItem.FtPTel%></li>
                </ul>
                <% If isNull(oTicket.FOneItem.FplaceImgURL) = false AND oTicket.FOneItem.FplaceImgURL <> "" Then %>
                <div><img src=<%=oTicket.FOneItem.FplaceImgURL%> alt='위치 정보' width='100%' /></div>
                <% End IF %>
                <div id="mapViewBig" style="width:100%; height:400px; background-color: #eee; color:#000; font-size:1rem;"></div>
            </dd>
        </dl>
        <% if not (oTicket.FOneItem.FparkingGuide = "" or isnull(oTicket.FOneItem.FparkingGuide)) then %>
        <dl class="odrNote2V16a ">
            <dt>주차 정보</dt>
            <dd><%=nl2br(oTicket.FOneItem.FparkingGuide)%></dd>
        </dl>
        <% end if %>
    </div>
<% end if %>
<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim currentdate
	currentdate = date()
	'currentdate = "2018-11-28"
	'response.write currentdate

	Dim vEventID, vStartNo, appevturl
	vEventID = Request("eventid")
	If vEventID = "110839" Then '// 2021-05-03
		vStartNo = "0"
	ElseIf vEventID = "111316" Then '// 2021-05-17
		vStartNo = "1"
	ElseIf vEventID = "111704" Then '// 2021-06-03
		vStartNo = "2"
	ElseIf vEventID = "112715" Then ' //2021-07-15
		vStartNo = "3"
	ElseIf vEventID = "" Then '
		vStartNo = "4"
	ElseIf vEventID = "" Then '
		vStartNo = "5"
    ElseIf vEventID = "" Then '
		vStartNo = "6"
    ElseIf vEventID = "" Then '
		vStartNo = "7"
    ElseIf vEventID = "" Then '
		vStartNo = "8"
    ElseIf vEventID = "" Then '
		vStartNo = "9"
    ElseIf vEventID = "" Then '
		vStartNo = "10"
    ElseIf vEventID = "" Then '
		vStartNo = "11"
    ElseIf vEventID = "" Then '
		vStartNo = "12"
    ElseIf vEventID = "" Then '
		vStartNo = "13"
    ElseIf vEventID = "" Then '
		vStartNo = "14"
    ElseIf vEventID = "" Then '
		vStartNo = "15"
    ElseIf vEventID = "" Then '
		vStartNo = "16"
    ElseIf vEventID = "" Then '
		vStartNo = "17"
    ElseIf vEventID = "" Then '
		vStartNo = "18"                           
	else
		vStartNo = "0"
	End IF

	If isapp = "0" Then
		appevturl = "/apps/appcom/wish/web2014/event/eventmain.asp?"
	Else
		appevturl = "/event/eventmain.asp?"
	End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.navi-container {position:relative; background:#fff;}
.navi-container .swiper-container {padding:0 10%;}
.navi-container .swiper-slide {width:33.3%; height:5.52rem; line-height:5.52rem; color:#999; font-size:1.5rem; text-align:center;}
.navi-container .swiper-slide span,
.navi-container .swiper-slide a {display:block; text-align:center; width:100%; height:100%; line-height:5.8rem; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.navi-container .btn-arrow {position:absolute; top:0; z-index:100; width:4rem; height:100%; background:#fff url(//webimage.10x10.co.kr/fixevent/event/2020/101555/m/btn_prev.png) no-repeat center; background-size:5.17rem 4.87rem;  font-size:0; color:transparent;}
.navi-container .swiper-slide.current {color:#111;}
.navi-container .swiper-button-prev {left:0;}
.navi-container .swiper-button-next {right:0; transform:scaleX(-1);}
</style>
<script src="/apps/appcom/wish/web2014/lib/js/customapp.js?v=1.10"></script>
<script>
$(function(){
    /* slide */
    var mySwiper = new Swiper(".navi-container .swiper-container", { 
        centeredSlides: false, //활성화된것이 중앙으로
        initialSlide:<%=vStartNo%>, //활성화될 슬라이드 번호 입력
        slidesPerView:3,
        nextButton: '.swiper-button-next',
        prevButton: '.swiper-button-prev'
    });
    $('.navi-container .coming').on('click', function(e){
		e.preventDefault();
		alert("오픈 예정 기획전 입니다 :)");
	});  
});

function goEventLink(evt) {
	<% if isApp then %>
		parent.location.href='/apps/appcom/wish/web2014/event/eventmain.asp?eventid='+evt;
	<% else %>
		parent.location.href='/event/eventmain.asp?eventid='+evt;
	<% end if %>
	return false;
}
</script>
</head>
<body>
<div class="topic">
    <div class="navi-container">
        <div class="slide-area">
            <div class="swiper-container">
                <div class="swiper-wrapper">
                    <!-- 활성화될 슬라이더에 class current 추가 -->
                    <% if currentdate < "2021-05-03" then %>
                    <div class="swiper-slide coming">Vol.1
                    <% Else %>
                    <div class="swiper-slide <%=CHKIIF(vEventID="110839"," current","")%>">
                        <a href="" onclick="goEventLink(110839);return false;">Vol.1</a>
                    <% End If %>
                    </div>

                    <% if currentdate < "2021-05-17" then %>
                    <div class="swiper-slide coming">Vol.2
                    <% Else %>
                    <div class="swiper-slide <%=CHKIIF(vEventID="111316"," current","")%>">
                        <a href="" onclick="goEventLink(111316);return false;">Vol.2</a>
                    <% End If %>
                    </div>

                    <% if currentdate < "2021-06-03" then %>
                    <div class="swiper-slide coming">Vol.3
                    <% Else %>
                    <div class="swiper-slide <%=CHKIIF(vEventID="111704"," current","")%>">
                        <a href="" onclick="goEventLink(111704);return false;">Vol.3</a>
                    <% End If %>
                    </div>

                      <% if currentdate < "2021-07-15" then %>
                    <div class="swiper-slide coming">comming
                    <% Else %>
                    <div class="swiper-slide <%=CHKIIF(vEventID="112715"," current","")%>">
                        <a href="" onclick="goEventLink(112715);return false;">Vol.4</a>
                    <% End If %>
                    </div>
                </div>         
                <div class="swiper-button-prev btn-arrow"></div>
                <div class="swiper-button-next btn-arrow"></div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
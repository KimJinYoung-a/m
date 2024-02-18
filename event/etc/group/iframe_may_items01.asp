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
	If vEventID = "111073" Then '// 2021-05-03
		vStartNo = "0"
	ElseIf vEventID = "111082" Then '// 2021-05-04
		vStartNo = "1"
	ElseIf vEventID = "111104" Then '// 2021-05-06
		vStartNo = "2"
	ElseIf vEventID = "111105" Then '// 2021-05-07
		vStartNo = "3"
	ElseIf vEventID = "111106" Then '// 2021-05-10
		vStartNo = "4"
	ElseIf vEventID = "111107" Then '// 2021-05-11
		vStartNo = "5"
    ElseIf vEventID = "111108" Then '// 2021-05-12
		vStartNo = "6"
    ElseIf vEventID = "111109" Then '// 2021-05-13
		vStartNo = "7"
    ElseIf vEventID = "111110" Then '// 2021-05-14
		vStartNo = "8"
    ElseIf vEventID = "111111" Then '// 2021-05-17
		vStartNo = "9"
    ElseIf vEventID = "111112" Then '// 2021-05-18
		vStartNo = "10"
    ElseIf vEventID = "111114" Then '// 2021-05-20
		vStartNo = "11"
    ElseIf vEventID = "111115" Then '// 2021-05-21
		vStartNo = "12"
    ElseIf vEventID = "111116" Then '// 2021-05-24
		vStartNo = "13"
    ElseIf vEventID = "111117" Then '// 2021-05-25
		vStartNo = "14"
    ElseIf vEventID = "111118" Then '// 2021-05-26
		vStartNo = "15"
    ElseIf vEventID = "111119" Then '// 2021-05-27
		vStartNo = "16"
    ElseIf vEventID = "111120" Then '// 2021-05-28
		vStartNo = "17"
    ElseIf vEventID = "111121" Then '// 2021-05-31
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
<style>
.mEvt111073 {background:#fff;}
.mEvt111073 .topic {padding-top:0.43rem; background:#fff9c5;}
.mEvt111073 .navi-wrap {height:9.43rem; background: #ff8400; border-radius:50px 50px 0 0; overflow:hidden;}
.mEvt111073 .navi-wrap .navi-container {position:relative; padding-top:1.5rem;}
.mEvt111073 .navi-wrap .tit-slide {position:absolute; left:50%; top:20%; transform:translate(-50%,0); width:26.40vw;}
.mEvt111073 .navi-wrap .swiper-button-prev {left:0; top:50%; transform: translate(0,-36%); width:3.91rem; height:100%; background:#ff8400 url(//webimage.10x10.co.kr/fixevent/event/2021/111073/m/icon_arr_left.png?v=2) no-repeat right 32%; background-position-x:2rem; border-radius:30px 0; background-size:2.67vw 5.47vw; opacity:1; z-index:10;}
.mEvt111073 .navi-wrap .swiper-button-next {right:0; top:50%; transform: translate(0,-36%); width:3.91rem; height:100%; background:#ff8400 url(//webimage.10x10.co.kr/fixevent/event/2021/111073/m/icon_arr_right.png?v=2) no-repeat left 32%; background-position-x:1rem; border-radius:0 30px; background-size:2.67vw 5.47vw; opacity:1; z-index:10;}
.mEvt111073 .navi-wrap .swiper-slide {text-align:center;}
.mEvt111073 .navi-wrap .swiper-slide a {display:inline-block; height:100%; line-height:9.43rem; margin:0 1.41rem; font-size:1.73rem; color:#ffd2a1;}
.mEvt111073 .navi-wrap .swiper-slide a.current {position:relative; width:8.40vw; color:#ff8400; text-align:center; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.mEvt111073 .navi-wrap .swiper-slide a.current::before {content:""; position:absolute; left:0; top:50%; transform:translate(0,-55%); z-index:-1; display:inline-block; width:8.40vw; height:8.40vw; border-radius:100%; background:#fff9c5;}
.mEvt111073 .navi-wrap .swiper-container {padding:0 3.5rem;}
.mEvt111073 .navi-wrap .swiper-wrapper {display:flex; align-items:center; justify-content:flex-start; width:100%; height:9.43rem; margin:0 auto;}
</style>
<script src="/apps/appcom/wish/web2014/lib/js/customapp.js?v=1.10"></script>
<script>
$(function(){
    /* slide */
    var mySwiper = new Swiper(".navi-wrap .swiper-container", { 
        centeredSlides: false, //활성화된것이 중앙으로
        initialSlide:<%=vStartNo%>, //활성화될 슬라이드 번호 입력
        slidesPerView:5,
        nextButton: '.swiper-button-next',
        prevButton: '.swiper-button-prev'
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
<div class="mEvt111073">
    <div class="topic">
        <div class="navi-wrap">
            <div class="navi-container">
                <div class="tit-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111073/m/tit_txt.png" alt="매일문구 may"></div>
                <div class="slide-area">
                    <div class="swiper-container">
                        <div class="swiper-wrapper">
                            <!-- 활성화될 슬라이더에 class current 추가 -->
                            <!-- 2021-05-03 -->
                            <% if currentdate >= "2021-05-03" then %>
                                <% if vEventID="111073" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111073);return false;" class="current">03</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111073);return false;">03</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-05-04" then %>
                                <% if vEventID="111082" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111082);return false;" class="current">04</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111082);return false;">04</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-05-06" then %>
                                <% if vEventID="111104" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111104);return false;" class="current">06</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111104);return false;">06</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-05-07" then %>
                                <% if vEventID="111105" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111105);return false;" class="current">07</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111105);return false;">07</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-05-10" then %>
                                <% if vEventID="111106" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111106);return false;" class="current">10</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111106);return false;">10</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-05-11" then %>
                                <% if vEventID="111107" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111107);return false;" class="current">11</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111107);return false;">11</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-05-12" then %>
                                <% if vEventID="111108" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111108);return false;" class="current">12</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111108);return false;">12</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-05-13" then %>
                                <% if vEventID="111109" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111109);return false;" class="current">13</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111109);return false;">13</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-05-14" then %>
                                <% if vEventID="111110" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111110);return false;" class="current">14</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111110);return false;">14</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-05-17" then %>
                                <% if vEventID="111111" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111111);return false;" class="current">17</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111111);return false;">17</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-05-18" then %>
                                <% if vEventID="111112" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111112);return false;" class="current">18</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111112);return false;">18</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-05-20" then %>
                                <% if vEventID="111114" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111114);return false;" class="current">20</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111114);return false;">20</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-05-21" then %>
                                <% if vEventID="111115" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111115);return false;" class="current">21</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111115);return false;">21</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-05-24" then %>
                                <% if vEventID="111116" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111116);return false;" class="current">24</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111116);return false;">24</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-05-25" then %>
                                <% if vEventID="111117" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111117);return false;" class="current">25</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111117);return false;">25</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-05-26" then %>
                                <% if vEventID="111118" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111118);return false;" class="current">26</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111118);return false;">26</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-05-27" then %>
                                <% if vEventID="111119" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111119);return false;" class="current">27</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111119);return false;">27</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-05-28" then %>
                                <% if vEventID="111120" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111120);return false;" class="current">29</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111120);return false;">29</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-05-31" then %>
                                <% if vEventID="111121" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111121);return false;" class="current">31</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111121);return false;">31</a>
                                </div>
                                <% End If %>
                            <% End If %>
                        </div>         
                        <div class="swiper-button-prev"></div>
                        <div class="swiper-button-next"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
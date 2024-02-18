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
	If vEventID = "111122" Then '// 2021-06-01
		vStartNo = "0"
	ElseIf vEventID = "111123" Then '// 2021-06-02
		vStartNo = "1"
	ElseIf vEventID = "111124" Then '// 2021-06-03
		vStartNo = "2"
	ElseIf vEventID = "111125" Then '// 2021-06-04
		vStartNo = "3"
	ElseIf vEventID = "111126" Then '// 2021-06-07
		vStartNo = "4"
	ElseIf vEventID = "111127" Then '// 2021-06-08
		vStartNo = "5"
    ElseIf vEventID = "111128" Then '// 2021-06-09
		vStartNo = "6"
    ElseIf vEventID = "111129" Then '// 2021-06-10
		vStartNo = "7"
    ElseIf vEventID = "111130" Then '// 2021-06-11
		vStartNo = "8"
    ElseIf vEventID = "111131" Then '// 2021-06-14
		vStartNo = "9"
    ElseIf vEventID = "111612" Then '// 2021-06-15
		vStartNo = "10"
    ElseIf vEventID = "111613" Then '// 2021-06-16
		vStartNo = "11"
    ElseIf vEventID = "111614" Then '// 2021-06-17
		vStartNo = "12"
    ElseIf vEventID = "111615" Then '// 2021-06-18
		vStartNo = "13"
    ElseIf vEventID = "111616" Then '// 2021-06-21
		vStartNo = "14"
    ElseIf vEventID = "111617" Then '// 2021-06-22
		vStartNo = "15"
    ElseIf vEventID = "111618" Then '// 2021-06-23
		vStartNo = "16"
    ElseIf vEventID = "111619" Then '// 2021-06-24
		vStartNo = "17"
    ElseIf vEventID = "111620" Then '// 2021-06-25
		vStartNo = "18" 
    ElseIf vEventID = "111621" Then '// 2021-06-28
		vStartNo = "19"
    ElseIf vEventID = "111622" Then '// 2021-06-29
		vStartNo = "20"
    ElseIf vEventID = "111623" Then '// 2021-06-30
		vStartNo = "21"                                
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
.mEvt111073 .topic {padding-top:0.43rem; background:#dbfcdf;}
.mEvt111073 .navi-wrap {height:9.43rem; background:#24cede; border-radius:50px 50px 0 0; overflow:hidden;}
.mEvt111073 .navi-wrap .navi-container {position:relative; padding-top:1.5rem;}
.mEvt111073 .navi-wrap .tit-slide {position:absolute; left:50%; top:20%; transform:translate(-50%,0); width:26.40vw;}
.mEvt111073 .navi-wrap .swiper-button-prev {left:0; top:50%; transform: translate(0,-36%); width:3.91rem; height:100%; background:#24cede url(//webimage.10x10.co.kr/fixevent/event/2021/111073/m/icon_arr_left.png?v=2) no-repeat right 32%; background-position-x:2rem; border-radius:30px 0; background-size:2.67vw 5.47vw; opacity:1; z-index:10;}
.mEvt111073 .navi-wrap .swiper-button-next {right:0; top:50%; transform: translate(0,-36%); width:3.91rem; height:100%; background:#24cede url(//webimage.10x10.co.kr/fixevent/event/2021/111073/m/icon_arr_right.png?v=2) no-repeat left 32%; background-position-x:1rem; border-radius:0 30px; background-size:2.67vw 5.47vw; opacity:1; z-index:10;}
.mEvt111073 .navi-wrap .swiper-slide {text-align:center;}
.mEvt111073 .navi-wrap .swiper-slide a {display:inline-block; height:100%; line-height:9.43rem; margin:0 1.41rem; font-size:1.73rem; color:#dbfcdf;}
.mEvt111073 .navi-wrap .swiper-slide a.current {position:relative; width:8.40vw; color:#249e53; text-align:center; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.mEvt111073 .navi-wrap .swiper-slide a.current::before {content:""; position:absolute; left:0; top:50%; transform:translate(0,-55%); z-index:-1; display:inline-block; width:8.40vw; height:8.40vw; border-radius:100%; background:#dbfcdf;}
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
                <div class="tit-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111073/m/tit_txt02.png" alt="매일문구 june"></div>
                <div class="slide-area">
                    <div class="swiper-container">
                        <div class="swiper-wrapper">
                            <!-- 활성화될 슬라이더에 class current 추가 -->
                            <!-- 2021-05-03 -->
                            <% if currentdate >= "2021-06-01" then %>
                                <% if vEventID="111122" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111122);return false;" class="current">01</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111122);return false;">01</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-06-02" then %>
                                <% if vEventID="111123" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111123);return false;" class="current">02</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111123);return false;">02</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-06-03" then %>
                                <% if vEventID="111124" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111124);return false;" class="current">03</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111124);return false;">03</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-06-04" then %>
                                <% if vEventID="111125" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111125);return false;" class="current">04</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111125);return false;">04</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-06-07" then %>
                                <% if vEventID="111126" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111126);return false;" class="current">07</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111126);return false;">07</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-06-08" then %>
                                <% if vEventID="111127" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111127);return false;" class="current">08</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111127);return false;">08</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-06-09" then %>
                                <% if vEventID="111128" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111128);return false;" class="current">09</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111128);return false;">09</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-06-10" then %>
                                <% if vEventID="111129" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111129);return false;" class="current">10</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111129);return false;">10</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-06-11" then %>
                                <% if vEventID="111130" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111130);return false;" class="current">11</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111130);return false;">11</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-06-14" then %>
                                <% if vEventID="111131" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111131);return false;" class="current">14</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111131);return false;">14</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-06-15" then %>
                                <% if vEventID="111612" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111612);return false;" class="current">15</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111612);return false;">15</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-06-16" then %>
                                <% if vEventID="111613" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111613);return false;" class="current">16</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111613);return false;">16</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-06-17" then %>
                                <% if vEventID="111614" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111614);return false;" class="current">17</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111614);return false;">17</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-06-18" then %>
                                <% if vEventID="111615" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111615);return false;" class="current">18</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111615);return false;">18</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-06-21" then %>
                                <% if vEventID="111616" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111616);return false;" class="current">21</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111616);return false;">21</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-06-22" then %>
                                <% if vEventID="111617" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111617);return false;" class="current">22</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111617);return false;">22</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-06-23" then %>
                                <% if vEventID="111618" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111618);return false;" class="current">23</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111618);return false;">23</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-06-24" then %>
                                <% if vEventID="111619" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111619);return false;" class="current">24</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111619);return false;">24</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-06-25" then %>
                                <% if vEventID="111620" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111620);return false;" class="current">25</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111620);return false;">25</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-06-28" then %>
                                <% if vEventID="111621" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111621);return false;" class="current">28</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111621);return false;">28</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-06-29" then %>
                                <% if vEventID="111622" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111622);return false;" class="current">29</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111622);return false;">29</a>
                                </div>
                                <% End If %>
                            <% End If %>
                            <% if currentdate >= "2021-06-30" then %>
                                <% if vEventID="111623" then %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111623);return false;" class="current">30</a>
                                </div>
                                <% else %>
                                <div class="swiper-slide">
                                    <a href="" onclick="goEventLink(111623);return false;">30</a>
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
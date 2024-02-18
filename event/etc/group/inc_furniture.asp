<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim currentdate
	currentdate = date()
	'currentdate = "2020-03-26"
	'response.write currentdate
%>
<%
'#######################################################################
'	작업자 전달 사항
'
'	* 어드민에 소스 넣을때 뭐뭐뭐.asp 뒤에 ?eventid=코드 꼭 넣으세요!!
'
'#######################################################################
	Dim vEventID, vStartNo
	vEventID = requestCheckVar(Request("eventid"),9)
	If vEventID = "113827" Then '// 9월
		vStartNo = "0"
	ElseIf vEventID = "" Then '// 10월
		vStartNo = "0"
	ElseIf vEventID = "" Then '// 11월
		vStartNo = "1"
	ElseIf vEventID = "" Then '// 12월
		vStartNo = "2"
	ElseIf vEventID = "" Then '// 1월
		vStartNo = "3"
	ElseIf vEventID = "" Then '// 2월
		vStartNo = "4"
	else
		vStartNo = "0"
	End IF
%>
<style type="text/css">
.navigator {position:relative; display:flex; justify-content:space-between; align-items:center; padding:0 1.71rem; background-color:#c79578;}
.navigator h2 {width:8.4rem;}
.navigator .nav-wrapper {position:relative; width:18.77rem;}
.navigator .swiper-wrapper {display:flex;}
.navigator .swiper-container {width:16.21rem;}
.navigator .swiper-slide {height:5.97rem;}
.navigator .swiper-slide span,
.navigator .swiper-slide a {display:flex; justify-content:center; align-items:center; width:100%; height:100%; color:#eec9b4; font-size:1.28rem;}
.navigator .swiper-slide a {font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.navigator .swiper-slide.current a {color:#fbf4ec;}
.navigator button {position:absolute; top:0; z-index:100; width:1.28rem; height:100%; background-color:transparent; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/106058/btn_nav.png?v=1.01); background-size:.6rem auto; background-repeat:no-repeat; background-position:0 50%; font-size:0;}
.navigator .btn-prev {left:0;}
.navigator .btn-next {right:0; transform:scale(-1);}
</style>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper("#navigator .swiper-container",{
		initialSlide:<%=vStartNo%>,
		slidesPerView:3,
		prevButton:"#navigator .btn-prev",
		nextButton:"#navigator .btn-next"
	});
	$('.swiper-slide span').on('click', function(e){
		e.preventDefault();
		alert("오픈 예정 기획전 입니다 :)");
	});
});
</script>
<div id="navigator" class="navigator">
    <h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/106058/m/tit_furniture.png" alt="가구 소식"></h2>
    <div class="nav-wrapper">
        <div class="swiper-container">
            <ul class="swiper-wrapper">
                <% if currentdate < "2021-09-06" then %>
                <li class="swiper-slide"><span>#9월</span>
                <% Else %>
                <li class="swiper-slide <%=CHKIIF(vEventID="113827"," current","")%>"><a href="eventmain.asp?eventid=113827">#9월</a>
                <% End If %>
                </li>

                <% if currentdate < "2021-10-06" then %>
                <li class="swiper-slide"><span>#10월</span>
                <% Else %>
                <li class="swiper-slide <%=CHKIIF(vEventID="000"," current","")%>"><a href="eventmain.asp?eventid=000">#10월</a>
                <% End If %>

                <% if currentdate < "2021-11-06" then %>
                <li class="swiper-slide"><span>#11월</span>
                <% Else %>
                <li class="swiper-slide <%=CHKIIF(vEventID="000"," current","")%>"><a href="eventmain.asp?eventid=000">#11월</a>
                <% End If %>
                </li>

                <% if currentdate < "2021-12-06" then %>
                <li class="swiper-slide"><span>#12월</span>
                <% Else %>
                <li class="swiper-slide <%=CHKIIF(vEventID="000"," current","")%>"><a href="eventmain.asp?eventid=000">#12월</a>
                <% End If %>
                </li>

                <% if currentdate < "2022-01-06" then %>
                <li class="swiper-slide"><span>#1월</span>
                <% Else %>
                <li class="swiper-slide <%=CHKIIF(vEventID="000"," ","")%>"><a href="eventmain.asp?eventid=000">#1월</a>
                <% End If %>
                </li>

                <% if currentdate < "2022-02-06" then %>
                <li class="swiper-slide"><span>#2월</span>
                <% Else %>
                <li class="swiper-slide <%=CHKIIF(vEventID="000"," current","")%>"><a href="eventmain.asp?eventid=000">#2월</a>
                <% End If %>
                </li>
            </ul>
        </div>
    <button type="button" class="btn-prev">이전</button>
    <button type="button" class="btn-next">다음</button>
  </div>
</div>
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
    If vEventID = "105693" Then '// 9월
        vStartNo = "0"
    ElseIf vEventID = "106171" Then '// 10월
        vStartNo = "0"
    ElseIf vEventID = "106956" Then '// 11월
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
.navigator {position:relative; display:flex; justify-content:space-between; align-items:center; background-color:#fff;}
.navigator h2 {width:8.4rem;}
.navigator .nav-wrapper {position:relative; width:100%;}
.navigator .swiper-wrapper {display:flex; width:100%;}
.navigator .swiper-container {width:100%;}
.navigator .swiper-slide {width:calc(100% / 4)!important; height:5.97rem;}
.navigator .swiper-slide span,
.navigator .swiper-slide a {display:flex; justify-content:center; align-items:center; width:100%; height:100%; color:#999999; font-size:1.28rem;}
.navigator .swiper-slide a {font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.navigator .swiper-slide.current a {position:relative; color:#000;}
.navigator .swiper-slide.current a:before {content:""; position:absolute; left:0; bottom:0; width:100%; height:0.42rem; background:#000;} 
</style>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper("#navigator .swiper-container",{
		initialSlide:<%=vStartNo%>,
		slidesPerView:4,
	});
	$('.swiper-slide span').on('click', function(e){
		e.preventDefault();
		alert("오픈 예정 기획전 입니다 :)");
	});
});
</script>
<div id="navigator" class="navigator">
    <div class="nav-wrapper">
        <div class="swiper-container">
            <ul class="swiper-wrapper">
                <% if currentdate < "2020-09-01" then %>
                <li class="swiper-slide"><span>9월</span>
                <% Else %>
                <li class="swiper-slide <%=CHKIIF(vEventID="105693"," current","")%>"><a href="eventmain.asp?eventid=105693">9월</a>
                <% End If %>
                </li>

                <% if currentdate < "2020-10-08" then %>
                <li class="swiper-slide"><span>10월</span>
                <% Else %>
                <li class="swiper-slide <%=CHKIIF(vEventID="106171"," current","")%>"><a href="eventmain.asp?eventid=106171">10월</a>
                <% End If %>

                <% if currentdate < "2020-11-02" then %>
                <li class="swiper-slide"><span>11월</span>
                <% Else %>
                <li class="swiper-slide <%=CHKIIF(vEventID="106956"," current","")%>"><a href="eventmain.asp?eventid=106956">11월</a>
                <% End If %>
                </li>

                <% if currentdate < "2030-10-01" then %>
                <li class="swiper-slide"><span>12월</span>
                <% Else %>
                <li class="swiper-slide <%=CHKIIF(vEventID="000"," current","")%>"><a href="eventmain.asp?eventid=000">12월</a>
                <% End If %>
                </li>

                <% if currentdate < "2030-10-01" then %>
                <li class="swiper-slide"><span>1월</span>
                <% Else %>
                <li class="swiper-slide <%=CHKIIF(vEventID="000"," current","")%>"><a href="eventmain.asp?eventid=000">1월</a>
                <% End If %>
                </li>

                <% if currentdate < "2030-10-01" then %>
                <li class="swiper-slide"><span>2월</span>
                <% Else %>
                <li class="swiper-slide <%=CHKIIF(vEventID="000"," current","")%>"><a href="eventmain.asp?eventid=000">2월</a>
                <% End If %>
                </li>
            </ul>
        </div>
  </div>
</div>
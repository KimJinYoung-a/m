<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim currentdate
	currentdate = date()
	'currentdate = "2018-08-20"
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
	If vEventID = "93409" Then '// vol.01
		vStartNo = "0"
	ElseIf vEventID = "93410" Then '// vol.02
		vStartNo = "0"
	ElseIf vEventID = "93411" Then '// vol.03
		vStartNo = "0"
	ElseIf vEventID = "93412" Then '// vol.04
		vStartNo = "3"
	ElseIf vEventID = "93413" Then '// vol.05
		vStartNo = "3"
	ElseIf vEventID = "93414" Then '// vol.06
		vStartNo = "3"
	ElseIf vEventID = "93415" Then '// vol.07
		vStartNo = "6"
	ElseIf vEventID = "93416" Then '// vol.08
		vStartNo = "6"
	ElseIf vEventID = "93417" Then '// vol.09
		vStartNo = "6"
	else
		vStartNo = "0"
	End IF
%>
<style type="text/css">
.navigator {position:relative; padding:0 8.5% 1rem; background-color:#fff;}
.navigator .swiper-slide {padding:2.2rem 0 1rem; font:1.37rem/1 'RobotoRegular', 'Noto Sans', sans-serif; color:#737373; text-align:center; letter-spacing:-.1rem;}
.navigator .swiper-slide a {display:block; width:auto; height:100%; color:#222;}
.navigator .swiper-slide .current {font-weight:600; color:#ff6674;}
.navigator button {position:absolute; top:50%; transform:translateY(-50%); z-index:100; width:4%; padding:0.2%; background-color:transparent; font-size:0;}
.navigator button img {width:100%; height:100%;}
.navigator .btnPrev {left:3%;}
.navigator .btnNext {right:3%;}
/*.grp:before {display:block; position:absolute; top:2.99rem; left:10%; width:280%; height:1px; background-color:#a9a9a9; content:'';}
.grp:after {display:block; position:absolute; top:2.5rem; left:100%; width:8.96rem; color:#acacac; font-size:1.28rem; line-height:1; text-align:center; background-color:#fff;}
.grp.open:before {background-color:#656565;}
.grp.open:after {color:#656565;}
.grp-01:after {content:'4월1일(월) ~'; }
.grp-02:after {content:'4월4일(목) ~'; }
.grp-03:after {content:'4월8일(월) ~'; }*/
</style>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper("#navigator .swiper-container",{
		initialSlide:<%=vStartNo%>,
		slidesPerView:"3",
        slidesPerGroup:3,
		prevButton:"#navigator .btnPrev",
		nextButton:"#navigator .btnNext"
	});
	$('.swiper-slide.next').on('click', function(e){
		e.preventDefault();
		alert("오픈 예정 기획전 입니다.");
	});
});
</script>
<div id="navigator" class="navigator">
	<div class="swiper-container">
	<ul class="swiper-wrapper">
            <li class="grp grp-01 swiper-slide open"><a href="eventmain.asp?eventid=93409" <%=CHKIIF(vEventID="93409"," class='current'","")%> style="text-indent:-.5rem;">#자취생활</a></li>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=93410" <%=CHKIIF(vEventID="93410"," class='current'","")%>>#데스크테리어</a></li>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=93411" <%=CHKIIF(vEventID="93411"," class='current'","")%>>#좋은냄새</a></li>

			<% if currentdate < "2019-04-04" then %>
			<li class="grp grp-02 swiper-slide next">#정리왕</li>
			<li class="swiper-slide next">#심야식당</li>
			<li class="swiper-slide next">#부기빼는법</li>
			<% Else %>
			<li class="grp grp-02 swiper-slide open"><a href="eventmain.asp?eventid=93412" <%=CHKIIF(vEventID="93412"," class='current'","")%>>#정리왕</a></li>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=93413" <%=CHKIIF(vEventID="93413"," class='current'","")%>>#심야식당</a></li>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=93414" <%=CHKIIF(vEventID="93414"," class='current'","")%>>#부기빼는법</a></li>
			<% End If %>

			<% if currentdate < "2019-04-08" then %>
			<li class="grp grp-03 swiper-slide next">#여백채우기</li>
			<li class="swiper-slide next">#1+1</li>
			<li class="swiper-slide next">#기분좋은하루</li>
			<% Else %>
			<li class="grp grp-03 swiper-slide open"><a href="eventmain.asp?eventid=93415" <%=CHKIIF(vEventID="93415"," class='current'","")%>>#1+1</a></li>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=93416" <%=CHKIIF(vEventID="93416"," class='current'","")%>>#여백채우기</a></li>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=93417" <%=CHKIIF(vEventID="93417"," class='current'","")%>>#기분좋은하루</a></li>
			<% End If %>
		</ul>
	</div>
    <button type="button" class="btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2018/88664/m/btn_prev.png" alt="이전" /></button>
    <button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2018/88664/m/btn_next.png" alt="다음" /></button>
</div>
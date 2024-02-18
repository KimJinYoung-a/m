<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim currentdate
	currentdate = date()
	'currentdate = "2017-09-05"
	'response.write currentdate
%>
<%
'#######################################################################
'	작업자 전달 사항
'
'	* 어드민에 소스 넣을때 뭐뭐뭐.asp 뒤에 ?eventid=코드 꼭 넣으세요!!
'
'#######################################################################
	Dim vEventID, vStartNo, appevturl
	vEventID = requestCheckVar(Request("eventid"),9)
	If vEventID = "91202" Then '//12.12
		vStartNo = "0"
	ElseIf vEventID = "91229" Then '//12.13
		vStartNo = "0"
	ElseIf vEventID = "91264" Then '//12.14
		vStartNo = "0"
	ElseIf vEventID = "91265" Then '//12.15~16
		vStartNo = "1"
	ElseIf vEventID = "91266" Then '//12.17
		vStartNo = "2"
	ElseIf vEventID = "91140" Then '//12.18
		vStartNo = "3"
	ElseIf vEventID = "91258" Then '//12.19
		vStartNo = "4"
	ElseIf vEventID = "91311" Then '//12.20
		vStartNo = "5"
	ElseIf vEventID = "91468" Then '//12.21
		vStartNo = "6"
	ElseIf vEventID = "91402" Then '//12.22~23
		vStartNo = "7"
	ElseIf vEventID = "91440" Then '//12.24~25
		vStartNo = "8"
	ElseIf vEventID = "91314" Then '//12.26
		vStartNo = "9"
	ElseIf vEventID = "91477" Then '//12.27
		vStartNo = "10"
	ElseIf vEventID = "91509" Then '//12.28
		vStartNo = "11"
	ElseIf vEventID = "91582" Then '//12.29~30
		vStartNo = "12"
	ElseIf vEventID = "91545" Then '//12.31~1.1
		vStartNo = "13"
	ElseIf vEventID = "91383" Then '//1.2
		vStartNo = "14"
	End If
%>
<style type="text/css">
.navigator {width:100%;}
.navigator .swiper-container {padding:0 2.09rem 0 2.35rem;}
.navigator a,
.navigator span {display:-webkit-flex; display:flex; justify-content:center; flex-direction:column; width:7.81rem; height:4.14rem; margin-right:0.43rem; border-radius:0.34rem; background-color:#fff; color:#999; font-size:1.28rem; line-height:1.37rem; font-weight:600; text-align:center; vertical-align:middle;}
.navigator .current {background-color:#616161; color:#fff;}
.navigator li.sold a {padding-top:.2rem; background-color:#456a7d; color:#fff;}
.navigator li.sold a:after {padding-top:.2rem; line-height:1; font-size:.95rem; font-weight:600; content:'SOLD OUT';}
.navigator li a {padding-top:.2rem; background-color:#fff; color:#616161;}
.navigator li a:after {padding-top:.2rem; line-height:1; font-size:.95rem; font-weight:600; content:'판매중';}
.navigator li a.current {background-color:#616161; color:#fff;}
.navigator li a.current:after {padding: 0; line-height: auto; content: '';}
.navigator li.coming span {padding-top:.2rem; background-color:#adccdb; color:#fff;}
.navigator li.coming span:after {padding-top:.2rem; line-height:1; font-size:.95rem; font-weight:600; content:'판매예정';}
</style>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper("#navigator .swiper-container",{
		initialSlide:<%=vStartNo%>,
		slidesPerView:"auto",
		freeMode:true,
		freeModeMomentumRatio:0.5
	});
	$('.swiper-slide.coming').on('click', function(e){
		e.preventDefault();
		alert("오픈 예정 기획전 입니다.");
	});
});
</script>
<div id="navigator" class="navigator">
	<div class="swiper-container">
		<ul class="swiper-wrapper">
			<!-- 솔드아웃 됐을경우, sold 클래스 추가 <li class="swiper-slide sold"> ... </li> -->
			<li class="swiper-slide"><a href="eventmain.asp?eventid=91202" <%=CHKIIF(vEventID="91202"," class='current'","")%>>12일(수)</a></li>

			<% if currentdate < "2018-12-13" then %>
			<li class="swiper-slide coming"><span>13일(목)</span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=91229" <%=CHKIIF(vEventID="91229"," class='current'","")%>>13일(목)</a></li>
			<% End If %>

			<% if currentdate < "2018-12-14" then %>
			<li class="swiper-slide coming"><span>14일(금)</span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=91264" <%=CHKIIF(vEventID="91264"," class='current'","")%>>14일(금)</a></li>
			<% End If %>

			<% if currentdate < "2018-12-15" then %>
			<li class="swiper-slide coming"><span>15,16(토,일)</span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=91265" <%=CHKIIF(vEventID="91265"," class='current'","")%>>15,16(토,일)</a></li>
			<% End If %>

			<% if currentdate < "2018-12-17" then %>
			<li class="swiper-slide coming"><span>17일(월)</span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=91266" <%=CHKIIF(vEventID="91266"," class='current'","")%>>17일(월)</a></li>
			<% End If %>

			<% if currentdate < "2018-12-18" then %>
			<li class="swiper-slide coming"><span>18일(화)</span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=91140" <%=CHKIIF(vEventID="91140"," class='current'","")%>>18일(화)</a></li>
			<% End If %>

			<% if currentdate < "2018-12-19" then %>
			<li class="swiper-slide coming"><span>19일(수)</span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=91258" <%=CHKIIF(vEventID="91258"," class='current'","")%>>19일(수)</a></li>
			<% End If %>

			<% if currentdate < "2018-12-20" then %>
			<li class="swiper-slide coming"><span>20일(목)</span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=91311" <%=CHKIIF(vEventID="91311"," class='current'","")%>>20일(목)</a></li>
			<% End If %>

			<% if currentdate < "2018-12-21" then %>
			<li class="swiper-slide coming"><span>21일(금)</span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=91468" <%=CHKIIF(vEventID="91468"," class='current'","")%>>21일(금)</a></li>
			<% End If %>

			<% if currentdate < "2018-12-22" then %>
			<li class="swiper-slide coming"><span>22~23(토,일)</span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=91402" <%=CHKIIF(vEventID="91402"," class='current'","")%>>22~23(토,일)</a></li>
			<% End If %>

			<% if currentdate < "2018-12-24" then %>
			<li class="swiper-slide coming"><span>24~25(월,화)</span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=91440" <%=CHKIIF(vEventID="91440"," class='current'","")%>>24~25(월,화)</a></li>
			<% End If %>

			<% if currentdate < "2018-12-26" then %>
			<li class="swiper-slide coming"><span>26일(수)</span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=91314" <%=CHKIIF(vEventID="91314"," class='current'","")%>>26일(수)</a></li>
			<% End If %>

			<% if currentdate < "2018-12-27" then %>
			<li class="swiper-slide coming"><span>27일(목)</span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=91477" <%=CHKIIF(vEventID="91477"," class='current'","")%>>27일(목)</a></li>
			<% End If %>

			<% if currentdate < "2018-12-28" then %>
			<li class="swiper-slide coming"><span>28일(금)</span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=91509" <%=CHKIIF(vEventID="91509"," class='current'","")%>>28일(금)</a></li>
			<% End If %>

			<% if currentdate < "2018-12-29" then %>
			<li class="swiper-slide coming"><span>29~30(토,일)</span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=91582" <%=CHKIIF(vEventID="91582"," class='current'","")%>>29~30(토,일)</a></li>
			<% End If %>

			<% if currentdate < "2018-12-31" then %>
			<li class="swiper-slide coming"><span>31~1(월,화)</span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=91545" <%=CHKIIF(vEventID="91545"," class='current'","")%>>31~1(월,화)</a></li>
			<% End If %>

			<% if currentdate < "2019-01-02" then %>
			<li class="swiper-slide coming"><span>2일(수)</span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=91383" <%=CHKIIF(vEventID="91383"," class='current'","")%>>2일(수)</a></li>
			<% End If %>
		</ul>
	</div>
</div>
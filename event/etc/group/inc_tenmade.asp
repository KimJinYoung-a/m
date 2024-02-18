<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim currentdate
	currentdate = date()
	'currentdate = "2019-10-01"
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
	If vEventID = "102525" Then '// 01
		vStartNo = "0"
	ElseIf vEventID = "102930" Then '// 02
		vStartNo = "0"
	ElseIf vEventID = "103082" Then '// 03
		vStartNo = "1"
	ElseIf vEventID = "103180" Then '// 04
		vStartNo = "2"
	ElseIf vEventID = "00000" Then '// 05
		vStartNo = "2"
	ElseIf vEventID = "00000" Then '// 06
		vStartNo = "3"
	ElseIf vEventID = "00000" Then '// 07
		vStartNo = "4"
	ElseIf vEventID = "00000" Then '// 08
		vStartNo = "5"
	ElseIf vEventID = "00000" Then '// 09
		vStartNo = "6"
	ElseIf vEventID = "00000" Then '// 10
		vStartNo = "7"
	ElseIf vEventID = "00000" Then '// 11
		vStartNo = "8"
	End If
%>
<style type="text/css">
.navigator {position:relative; padding-top:1.6rem; background:#fff;}
.navigator .swiper-wrapper {align-items:flex-end;}
.navigator .swiper-slide {width:10.6rem; margin-right:0.4rem;}
.navigator .swiper-slide:last-child {margin-right:0;}
.navigator .swiper-slide a {display:block; padding:0.7rem 0; text-align:center; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; font-size:1.1rem; line-height:1.3; color:#a5a5a5; background:#dfdfdf; border-radius:2.7rem 2.7rem 0 0;}
.navigator .swiper-slide .open {font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; font-size:1.2rem; color:#0d0d0d; background:#ffdd4a;}
.navigator .swiper-slide .current {background:#ffb739;}
.navigator .swiper-slide b {display:block; font-size:1.6rem;}
</style>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper("#navigator .swiper-container",{
		initialSlide:<%=vStartNo%>,
		slidesPerView:"auto"
	});
	$('.swiper-slide .coming').on('click', function(e){
		e.preventDefault();
		alert("오픈 예정 기획전 입니다 :)");
	});
});
function goEventLink(evt) {
	<% if isApp then %>
		fnAPPpopupEvent(evt);
	<% else %>
		parent.location.href='/event/eventmain.asp?eventid='+evt;
	<% end if %>
	return false;
}
</script>
<div id="navigator" class="navigator">
	<div class="swiper-container">
		<ul class="swiper-wrapper">
			<li class="swiper-slide">
			<% If currentdate >= "2020-05-18" Then %>
				<a href="" onclick="goEventLink('102525'); return false;" class="open <%=CHKIIF(vEventID="102525"," current","")%>"><b>1st</b>마스킹테이프</a>
			<% Else %>
				<a href="" onclick="return false;" class="coming">coming soon</a>
			<% End If %>
			</li>

			<li class="swiper-slide">
			<% If currentdate >= "2020-05-25" Then %>
				<a href="" onclick="goEventLink('102930'); return false;" class="open <%=CHKIIF(vEventID="102930"," current","")%>"><b>2nd</b>피너츠엽서</a>
			<% Else %>
				<a href="" onclick="return false;" class="coming">coming soon</a>
			<% End If %>
			</li>

			<li class="swiper-slide">
			<% If currentdate >= "2020-06-02" Then %>
				<a href="" onclick="goEventLink('103082'); return false;" class="open <%=CHKIIF(vEventID="103082"," current","")%>"><b>3rd</b>디즈니 스티키노트</a>
			<% Else %>
				<a href="" onclick="return false;" class="coming">coming soon</a>
			<% End If %>
			</li>

			<li class="swiper-slide">
			<% If currentdate >= "2020-06-09" Then %>
				<a href="" onclick="goEventLink('103180'); return false;" class="open <%=CHKIIF(vEventID="103180"," current","")%>"><b>4th</b>코믹스 스티커</a>
			<% Else %>
				<a href="" onclick="return false;" class="coming">coming soon</a>
			<% End If %>
			</li>

			<li class="swiper-slide">
			<% If currentdate >= "2021-06-09" Then %>
				<a href="" onclick="goEventLink('000000'); return false;" class="open <%=CHKIIF(vEventID="000000"," current","")%>"><b></b></a>
			<% Else %>
				<a href="" onclick="return false;" class="coming">coming soon</a>
			<% End If %>
			</li>
		</ul>
	</div>
</div>
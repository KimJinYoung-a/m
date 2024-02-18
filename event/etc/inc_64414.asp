<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	Description : 수능 성적욕망 D-100
'	History	: 2015.07.14 원승현 생성
'#######################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
	Dim eCode, vDday

	IF application("Svr_Info") = "Dev" THEN
		eCode = "64828"
	Else
		eCode = "64414"
	End If


	vDday = DateDiff("d", Left(Now(), 10), "2015-11-12")


	If Len(Trim(vDday)) = 2 Then
		vDday = "0"&vDday
	ElseIf Len(Trim(vDday)) = 1 Then
		vDday = "00"&vDday
	Else
		vDday = vDday
	End If


%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
.colleageTest {position:relative;}
.colleageTest .dDay {overflow:hidden; position:absolute; left:50%; top:13%; width:158px; height:70px; padding-top:13px; margin-left:-79px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/64414/m/bg_dday.jpg) no-repeat 0 0; background-size:100% 100%;}
.colleageTest .dDay .d {float:left; width:50px;}
.colleageTest .dDay .move {position:absolute; right:7px; top:12px; width:99px; z-index:50;}
.colleageTest .dDay .count {overflow:hidden; float:left;}
.colleageTest .dDay .count em {display:inline-block; float:left; width:33px;}
@media all and (min-width:360px){
	.colleageTest .dDay {top:16%;}
}
@media all and (min-width:480px){
	.colleageTest .dDay {width:238px; height:105px; padding-top:20px; margin-left:-119px;}
	.colleageTest .dDay .d {width:75px;}
	.colleageTest .dDay .move {right:11px; top:20px; width:149px;}
	.colleageTest .dDay .count em {width:50px;}
}
</style>
<script type="text/javascript">
	$(function(){
		$(".move").delay(700).hide(10);
	});
</script>
<div class="mEvt64414">
	<div class="colleageTest">
		<div class="dDay">
			<p class="d"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64414/txt_d.png" alt="" /></p>
			<div class="move"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64414/m/txt_day.gif" alt="" /></div>
			<div class="count">
				<!-- 남은 날짜 불러오기(이미지0~9까지) -->
				<em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64414/m/txt_num_<%=Left(vDday, 1)%>.png" alt="" /></em>
				<em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64414/m/txt_num_<%=mid(vDday, 2, 1)%>.png" alt="" /></em>
				<em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64414/m/txt_num_<%=right(vDday, 1)%>.png" alt="" /></em>
				<!--// 남은 날짜 불러오기 -->
			</div>
		</div>
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/64414/m/tit_test_score.gif" alt="텐텐배송 나가신다 길을 비켜라" /></h2>
	</div>
	<p>
		<% If isApp = "1" Then %>
			<a href="" onclick="parent.fnAPPpopupBrowserURL('이벤트','<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=64807','','' );return false;">
		<% Else %>
			<a href="/event/eventmain.asp?eventid=64807" target="_top">
		<% End If %>
			<img src="http://webimage.10x10.co.kr/eventIMG/2015/64414/m/bnr_event01.jpg" alt="시험걱정 NO! 저만 믿어요!" />
		</a>
	</p>
	<p>
		<% If isApp = "1" Then %>
			<a href="" onclick="parent.fnAPPpopupBrowserURL('이벤트','<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=64861','','' );return false;">
		<% Else %>
			<a href="/event/eventmain.asp?eventid=64861" target="_top">
		<% End If %>
			<img src="http://webimage.10x10.co.kr/eventIMG/2015/64414/m/bnr_event02.jpg" alt="수능을 엿먹일 수험생 푸드" />
		</a>
	</p>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
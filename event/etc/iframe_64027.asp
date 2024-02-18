<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	History	: 2015.06.19 유태욱 생성
'	Description : 6월 마일리지를 부탁해
'#######################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
	Dim nowdate, couponcnt
	Dim vUserID, eCode, vQuery, vCheck
	vUserID = GetLoginUserID

	nowdate = now()
'	nowdate = "2015-06-20 10:00:00"

	IF application("Svr_Info") = "Dev" THEN
		eCode = "63796"
	Else
		eCode = "64027"
	End If

	''// 해당 이벤트 토탈 참여갯수
	vQuery = "SELECT count(sub_idx) FROM db_event.dbo.tbl_event_subscript WHERE evt_code='"&eCode&"' And convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"'"
	rsget.Open vQuery, dbget, 1
		If Not(rsget.bof Or rsget.Eof) Then
			couponcnt = rsget(0)
		End IF
	rsget.Close

	''//마일리지 발급여부 확인
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & vUserID & "' And evt_code='"&eCode&"' "
	rsget.Open vQuery,dbget,1
	If rsget(0) > 0 Then
		vCheck = "2"
	End IF
	rsget.close()
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {width:100%; vertical-align:top;}
.couponDownload {position:relative;}
.couponDownload .soldout {position:absolute; left:0; top:0; width:100%; z-index:100;}
.couponDownload .mgDown {display:block; position:absolute; left:20%; bottom:10%; width:60%; height:15%; z-index:80; color:transparent;}
.article {padding:25px 0 5px; border-top:1px solid #beddf3; background:#e9f7ff;}
.article div {padding-bottom:20px;}
.noti {padding:20px 10px 0;}
.noti h2 {color:#dc0610; font-size:14px; color:#222; font-weight:bold; line-height:1; padding-left:10px;}
.noti h2 span {display:inline-block; padding-bottom:1px; border-bottom:2px solid #222;}
.noti ul {margin-top:15px;}
.noti ul li {position:relative; margin-top:2px; padding-left:10px; color:#444; font-size:11px; line-height:1.438em; letter-spacing:-0.013em;}
.noti ul li:after {content:' '; display:block; position:absolute; top:4px; left:0; z-index:5; width:3px; height:3px; border-radius:50%; background-color:#7dd0ff;}
@media all and (min-width:480px) {
	.article {padding:38px 0 7px;}
	.article div {padding-bottom:30px;}
	.noti {padding:30px 15px 0;}
	.noti h2 {font-size:21px; padding-left:15px;}
	.noti h2 span {padding-bottom:2px;}
	.noti ul {margin-top:23px;}
	.noti ul li {margin-top:3px; padding-left:15px; font-size:17px;}
	.noti ul li:after {top:7px; width:5px; height:5px;}
}
</style>
<script type="text/javascript">
	$(function(){
		var chkapp = navigator.userAgent.match('tenapp');
		if ( chkapp ){
			$("#mo").hide();
		}else{
			$("#mo").show();
		}
});

function jsSubmitC(){
	<% If vUserID = "" Then %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End If %>

	<% If vUserID <> "" Then %>
		<% If vCheck = "2" then %>
			alert("이미 마일리지를 받으셨습니다.");
		<% Else %>
			frmGubun2.mode.value = "mileage";
			frmGubun2.action = "/event/etc/doeventsubscript/doEventSubscript64027.asp";
			frmGubun2.submit();
	   <% End If %>
	<% End If %>
}

function jsSoldOut(){
	$(".soldout").show();
}

</script>
	<!-- 마일리지를 부탁해! -->
	<div class="mEvt60777">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/64027/tit_favor_mileage.gif" alt="마일리지를 부탁해!" /></h2>
		<div class="couponDownload">
			<% If left(nowdate,10)<"2015-06-22" then %>
				<% if couponcnt >= 5000 then %>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64027/img_mileage.gif" alt="선착순 5000명 한정 5000마일리지 다운받기" /></p>
					<a href="" class="mgDown">마일리지 다운받기</a>
				<% else %>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64027/img_mileage.gif" alt="선착순 5000명 한정 5000마일리지 다운받기" /></p>
					<a href="" onClick="jsSubmitC(); return false;" class="mgDown">마일리지 다운받기</a>
				<% end if %>
			<% end if %>
			<% if couponcnt >= 5000 then %>
				<% If left(nowdate,10)<"2015-06-21" then %>
					<p class="soldout">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/64027/img_soldout_ver1.png" alt="쿠폰이 모두 소진되었어요! 내일 다시 찾아주세요" />
					</p>
				<% else %>
					<p class="soldout">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/64027/img_soldout_ver2.png" alt="쿠폰이 모두 소진되었어요! 다음기회에 이용해주세요" />
					</p>
				<% end if %>
			<% end if %>
		</div>
		<div class="article">
		<% if isApp=1 then %>

		<% Else %>
			<div id="mo" class="app"><a href="http://bit.ly/1m1OOyE" target="_top" ><img src="http://webimage.10x10.co.kr/eventIMG/2015/60777/btn_app_download.png" alt="텐바이텐 앱 다운받기" /></a></div>
		<% end if %>

		<% If vUserID = "" Then %>
			<% if isApp=1 then %>
				<div class="join"><a href="" onClick="fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60777/btn_join.png" alt="회원가입하고 구매하러 가기" /></a></div>
			<% else %>
				<div class="join"><a href="/member/join.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60777/btn_join.png" alt="회원가입하고 구매하러 가기" /></a></div>
			<% end if %>
		<% end if %>
		</div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64027/txt_tip.gif" alt="마일리지는 결제 시, 현금처럼 사용할 수 있습니다." /></p>
		<div class="noti">
			<h2><span>사용전 꼭꼭 읽어보세요!</span></h2>
			<ul>
				<li>본 이벤트는 로그인 후에 참여할 수 있습니다.</li>
				<li>이벤트는 ID당 1회만 참여할 수 있습니다.</li>
				<li>주문하시는 상품에 따라, 배송비용은 추가로 발생 할 수 있습니다.</li>
				<li>지급된 마일리지는 3만원 이상 구매 시 현금처럼 사용 가능합니다.</li>
				<li>기간 내에 사용하지 않은 마일리지는 사전 통보 없이 자동 소멸합니다.</li>
				<li>이벤트는 조기 마감 될 수 있습니다.</li>
			</ul>
		</div>
	</div>
	<!-- // 마일리지를 부탁해! -->
	<form name="frmGubun2" method="post" action="/event/etc/doeventsubscript/doEventSubscript64027.asp" style="margin:0px;" target="evtFrmProc">
	<input type="hidden" name="mode" value="">
	</form>
	<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
<!-- #include virtual="/lib/db/dbclose.asp" -->
<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 커먼그라운드 오프라인 쿠폰
' History : 2017.04.26 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
Dim eCode, vUserID, irdsite20, winItemChk, usrchkcnt, usrapplyChk
Dim tab1eCode, tab2eCode, tab3eCode
Dim vSQL
vUserID		= GetEncLoginUserID


If application("Svr_Info") = "Dev" Then
	eCode			= "66321"
Else
	eCode			= "77697"
End If

'// 오프라인 쿠폰 전체 응모 현황
vSQL = ""
vSQL = vSQL & " SELECT count(userid) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &" "
rsget.Open vSQL, dbget, adOpenForwardOnly, adLockReadOnly
	usrchkcnt = rsget(0)
rsget.close

'// 현재 들어온 회원이 응모를 하였는지 확인
vSQL = ""
vSQL = vSQL & " SELECT count(userid) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &" and userid = '"&vUserID&"' "
rsget.Open vSQL, dbget, adOpenForwardOnly, adLockReadOnly
	usrapplyChk = rsget(0)
rsget.close

%>
<style type="text/css">
.mEvt77697 {position:relative;}
.coupon .confirmBox {display:none; position:absolute; top:0; left:0; padding:0 9.3%; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2017/77697/m/bg_black.png) repeat; z-index:10;}
.coupon .confirmBox .btnConfirm {position:relative; width:100%; margin: 54% auto 0; background-color:transparent; z-index:100;}
.coupon .confirmBox .lyrClose {position:absolute; right:9.3%; top:12.5%; width:1.75rem; height:1.75rem; background:transparent url(http://webimage.10x10.co.kr/eventIMG/2017/77697/m/btn_close.png) 0 0 no-repeat; background-size:100% 100%; text-indent:-999em; outline:none;}
.evtNoti {padding-top:2.7rem; background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/77697/m/bg_blue.png); background-size:100%;}
.evtNoti h3 {padding:0 17.5rem 0 2.7rem;}
.evtNoti ul {padding:1.2rem 1rem 2.3rem 3rem;}
.evtNoti li {position:relative; padding:0 0 0 0.8rem; font-size:1rem; line-height:1.8rem; color:#fff;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.8rem; width:0.35rem; height:1px; background:#fff;}
</style>
<script type="text/javascript">

$(function(){
	$(".confirm").click(function(){

		if ("<%=IsUserLoginOK%>"=="False") {
			<% If isApp = 1 Then %>
				parent.calllogin();
				return false;
			<% Else %>
				parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eCode)%>');
				return false;
			<% End If %>
			return false;
		}

		$("#confirmBox").show();
		event.preventDefault();
		var val = $('.confirmBox').offset();
		$('html,body').animate({scrollTop:val.top},200);
	});

	$("#confirmBox .lyrClose").click(function(){
		$("#confirmBox").hide();
	});

});

function checkform(){
	<% If vUserID = "" Then %>
		if ("<%=IsUserLoginOK%>"=="False") {
			<% If isApp = 1 Then %>
				parent.calllogin();
				return false;
			<% Else %>
				parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eCode)%>');
				return false;
			<% End If %>
			return false;
		}
	<% End If %>
	<% If vUserID <> "" Then %>
		// 오픈시 바꿔야됨
		<% If left(now(), 10) >= "2017-04-26" And left(now(), 10) < "2017-06-01" Then %>
			$.ajax({
				type:"GET",
				url:"/event/etc/doEventSubscript77697.asp?mode=ins",
				dataType: "text",
				async:false,
				cache:false,
				success : function(Data, textStatus, jqXHR){
					if (jqXHR.readyState == 4) {
						if (jqXHR.status == 200) {
							if(Data!="") {
								var str;
								for(var i in Data){
									 if(Data.hasOwnProperty(i)){
										str += Data[i];
									}
								}
								str = str.replace("undefined","");
								res = str.split("|");
								if (res[0]=="OK"){
									$("#chkConfirmChg").empty().html(res[1]);
									$("#confirmBox").hide();
									window.$('html,body').animate({scrollTop:$(".coupon").offset().top}, 0);
								} else {
									errorMsg = res[1].replace(">?n", "\n");
									alert(errorMsg);
									document.location.reload();
									return false;
								}
							} else {
								alert("잘못된 접근 입니다.");
								document.location.reload();
								return false;
							}
						}
					}
				},
				error:function(jqXHR, textStatus, errorThrown){
					alert("잘못된 접근 입니다.");
					//var str;
					//for(var i in jqXHR)
					//{
					//	 if(jqXHR.hasOwnProperty(i))
					//	{
					//		str += jqXHR[i];
					//	}
					//}
					//alert(str);
					document.location.reload();
					return false;
				}
			});
		<% Else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;				
		<% End If %>
	<% End If %>
}
</script>

<%' 오프라인쿠폰 %>
<div class="mEvt77697">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/77697/m/tit_offline_coupon.png" alt="커먼 그라운드 즉시 할인 지금 건대 커먼그라운드 텐바이텐 매장에서 바로 사용하실 수 있는 할인쿠폰을 드립니다!" /></h2>
	<div class="coupon">
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/77697/m/img_coupon_1.png" alt="1만원 이상 구매시 2,000원 텐바이텐 건대점에서만 사용 가능" /></div>
		<div id="chkConfirmChg">
			<% If usrapplyChk > 0 Then %>
				<p class="completed"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77697/m/btn_coupon_used.png" alt="사용완료" /></p>
			<% Else %>
				<button class="confirm"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77697/m/btn_coupon_check.png" alt="쿠폰확인" /></button>
			<% End If %>
		</div>
		<%' 팝업 레이어 %>
		<div id="confirmBox" class="confirmBox">
			<button type="button" class="btnConfirm" onclick="checkform();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77697/m/txt_confirm.png" alt="쿠폰을 사용하시겠습니까? 본 쿠폰은 1회만 사용 가능합니다. 직원확인" /></button>
			<button type="button" class="lyrClose">닫기</button>
		</div>
		<p>
			<a href="/offshop/shopInfo13.asp" class="mWeb" target="_balnk"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77697/m/txt_location.png" alt="건대 매장 위치 확인하기" /></a>
			<a href="" class="mApp" onClick="fnAPPpopupBrowserURL('매장안내','<%=wwwUrl%>/apps/appcom/wish/web2014/offshop/shopInfo13.asp');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77697/m/txt_location.png" alt="건대 매장 위치 확인하기" /></a>
		</p>
	</div>
	<div class="evtNoti">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/77697/m/txt_noti.png" alt="이벤트 유의사항" /></h3>
		<ul>
			<li>ID당 1회씩만 사용하실 수 있습니다. </li>
			<li>쿠폰은 텐바이텐 건대점에서만 사용 가능합니다.</li>
			<li>타 쿠폰과 중복으로 사용하실 수 없습니다.</li>
			<li>이벤트는 조기 마감될 수 있습니다.</li>
		</ul>
	</div>
	<div>
		<%' for dev msg : 앱다운로드 버튼은 클래스로 웹에서만 노출되게 처리했습니다 %>
		<a href="/event/appdown/" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77697/m/img_app_coupon.png" alt="지금 APP설치하면 3천원 쿠폰 드려요! 텐바이텐 APP 다운받기" /></a>
	</div>
	<%
	if vUserID = "baboytw" or vUserID = "greenteenz" or vUserID = "cogusdk" or vUserID = "helele223" or vUserID = "ksy92630" Or vUserID="thensi7" then
		response.write usrchkcnt&"-오프라인 쿠폰사용수량"
	end  if
	%>
</div>
<%'// 오프라인쿠폰 %>

<!-- #include virtual="/lib/db/dbclose.asp" -->
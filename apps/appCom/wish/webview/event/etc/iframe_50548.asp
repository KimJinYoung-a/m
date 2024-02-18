<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  텐바이텐 위시 APP 런칭이벤트 1차
' History : 2014.03.27 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appcom/wish/webview/event/etc/event50548Cls.asp" -->
<!-- #include virtual="/apps/appCom/wish/webview/lib/classes/Apps_eventCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoritecls.asp" -->

<%
dim eCode, userid, wishsubscriptcount, wishfolder50548count
	eCode=getevt_code
	userid = getloginuserid()

wishsubscriptcount=0
wishfolder50548count=0
wishsubscriptcount = getevent_subscriptexistscount(eCode, userid, "WISH_A", "", "")
wishfolder50548count = getwishfolder50548(userid)

'//이벤트 상세
dim cEvent, emimg, ename, blnitempriceyn
set cEvent = new ClsEvtCont
	cEvent.FECode = eCode
	cEvent.fnGetEvent

	ename		= cEvent.FEName
	emimg		= cEvent.FEMimg
	blnitempriceyn = cEvent.FItempriceYN	
set cEvent = nothing
%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->

<!doctype html>
<html lang="ko">
<head>
<title>생활감성채널, 텐바이텐 > 이벤트 > 텐바이텐 앱 위시 론칭</title>
<style type="text/css">
.mEvt50548 p {max-width:100%;}
.mEvt50548 img {vertical-align:top;}
.wishAppLaunching img {width:100%;}
.wishAppLaunching .wishAppSns ul {overflow:hidden; width:101%;}
.wishAppLaunching .wishAppSns ul li {float:left; width:33.33333%;}
</style>
<script type="text/javascript">

function jsSubmitsms(frm){
	<% If IsUserLoginOK() Then %>
		<% If Now() > #04/14/2014 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% If getnowdate>="2014-04-01" and getnowdate<"2014-04-15" Then %>
				<% if wishsubscriptcount = 0 and wishfolder50548count = 0 then %>
			   		frm.mode.value="addwish";
					frm.action="/apps/appcom/wish/webview/event/etc/doEventSubscript50548.asp";
					frm.target="evtFrmProc";
					frm.submit();
					return;
				<% else %>
					alert("이미 응모하셨습니다.");
					return;
				<% end if %>
			<% else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% end if %>				
		<% End If %>
	<% Else %>
		//alert('로그인을 하셔야 참여가 가능 합니다');
		//return;
		if(confirm("로그인을 하셔야 참여가 가능 합니다. 로그인 하시겠습니까?")){
			calllogin();
			return;
		}
	<% End IF %>
}

</script>
</head>
<body>

<!-- 텐바이텐 앱 위시 론칭 -->
<div class="mEvt50548">
	<div class="wishAppLaunching">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/50548/tit_wish_app_launching.jpg" alt="드디어 우리가 원하던 APP이 나왔습니다! 10X10 WISH" /></h2>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50548/txt_wish_app_launching.jpg" alt="모바일에서 만날 수 있는 텐바이텐 공식 앱이 출시되었어요. 이제 가장 트렌디하고 스타일리시한 텐바이텐 쇼핑을 스마트폰 APP에서 즐겨보세요!" /></p>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/50548/img_wish_app_visual.jpg" alt="10X10 WISH" /></div>

		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/50548/tit_wish_app_launching_take_part.jpg" alt="웬만하면 당첨되는 런칭 기념 이벤트 위시도 담고, 선물도 받고!" /></h3>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50548/txt_wish_app_launching_take_part.jpg" alt="위시를 담기만 해도 선물을 드립니다! 10x10 WISH APP을 다운받고 이벤트에 참여하신 분 중 3,000분께 스타벅스 아메리카노를 선물로 드립니다!" /></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50548/txt_wish_app_launching_way.jpg" alt="이벤트 참여방법 : 1. 이벤트참여 버튼 을 클릭하고 wish 이벤트 폴더 를 만들어주세요. 2. wish 이벤트 폴더 생성을 확인한 후 폴더에 상품을 마구마구 담아주시면 응모완료!" /></p>

		<div class="btnEnter"><a href="" onclick="jsSubmitsms(frmcomm); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50548/btn_enter.jpg" alt="10X10 WISH APP 런칭기념 이벤트 참여" /></a></div>
		<%
			'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
			dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
			snpTitle = Server.URLEncode(ename)
			snpLink = Server.URLEncode("http://10x10.co.kr/event/" & ecode)
			snpPre = Server.URLEncode("텐바이텐 이벤트")
			snpTag = Server.URLEncode("텐바이텐 " & Replace(ename," ",""))
			snpTag2 = Server.URLEncode("#10x10")
			snpImg = Server.URLEncode(emimg)
		%>
		<div class="wishAppSns">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/50548/tit_wish_app_launching_sns.jpg" alt="SNS로 소문내고 당첨확률 높이세요! 지금 자신의 SNS를 통해 10x10 WISH APP을 소문내주시면 당첨확률이 쑥!" /></h3>
			<ul>
				<li><a href="" onclick="popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50548/ico_sns_twitter.jpg" alt="트위터" /></a></li>
				<li><a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','',''); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50548/ico_sns_facebook.jpg" alt="페이스북" /></a></li>
				<li><a href="" onclick="pinit('<%=snpLink%>','<%=snpImg%>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50548/ico_sns_pinterest.jpg" alt="핀터레스트" /></a></li>
			</ul>
		</div>

		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50548/txt_wish_app_launching_note.jpg" alt="이벤트 유의사항 : 반드시 이벤트 페이지에서 [이벤트 참여] 버튼을 눌러 상품을 담아야 이벤트 응모 인정됩니다. 많은 위시를 담을 수록 당첨 확률이 높아집니다! (위시 폴더에 상품이 없을 경우 응모 취소될 수 있습니다.)" /></p>
	</div>
</div>
<!-- //텐바이텐 앱 위시 론칭 -->
<div id="modalCont" style="display:none;"></div>
<form name="frmcomm" action="" onsubmit="return false;" method="post" style="margin:0px;">
	<input type="hidden" name="mode">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->
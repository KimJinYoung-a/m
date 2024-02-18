<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 돌아온 크리스박스
' History : 2015.12.07 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/event67929Cls.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/wishCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/ItemOptionCls.asp" -->

<%
dim eCode, userid, itemid, oItem, earlybirdyn, weekimgfd, systemok
eCode=getevt_code
userid = getencloginuserid()

itemid=""
earlybirdyn=""

itemid = getdateitem(left(currenttime,10))

set oItem = new CatePrdCls

if itemid<>"" then
	oItem.GetItemData itemid
end if

if Hour(currenttime) = 9 then
	if userid<>"" then
		earlybirdyn=earlybird(left(currenttime,10))
	end if
end if

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg

dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle = Server.URLEncode("[텐바이텐] 돌아온 크리스박스!")
snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode)
snpPre = Server.URLEncode("10x10 이벤트")

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐] 돌아온 크리스박스\n\n12월, 놀라운 선물을 갖고\n텐바이텐이 돌아왔습니다.\n\n배송비만 내면 엄청난 선물이\n랜덤으로 찾아갑니다.\n\n주인공은 바로 당신\n지금 도전하세요!\n\n오직 텐바이텐 모바일에서!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2015/67929/01/img_bnr_kakao.png"
Dim kakaoimg_width : kakaoimg_width = "200"
Dim kakaoimg_height : kakaoimg_height = "200"
Dim kakaolink_url 
	If isapp = "1" Then '앱일경우
		kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode
	Else '앱이 아닐경우
		kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode
	end if

''1주차,2주차 이미지 폴더명
if left(currenttime,10)<"2015-12-15" then
	weekimgfd	=	"01"
else
	weekimgfd	=	"02"
end if


''응모 차단시 X로 변경
	'systemok="X"
	systemok="O"

if left(currenttime,10)<"2015-12-16" then
	systemok="X"
end if

%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:21px;}}

img {vertical-align:top;}

.mEvt67929 .hidden {visibility:hidden; width:0; height:0;}
.mEvt67929 button {background-color:transparent; vertical-align:top;}

.topic {position:relative;}
.topic .subcopy {position:absolute; bottom:3.6%; left:0; width:100%;}

.present {position:relative;}
.present .comingsoon {position:absolute; top:0; left:0; z-index:55; width:100%;}
.present .btnMore {position:absolute; top:9%; left:0; z-index:50; width:100%; padding-top:42%; background-color:rgba(0,0,0,0); text-align:right;}
.present .btnMore img {width:14%; margin-right:3.5%;}
.present .btnGet {position:absolute; bottom:17.5%; left:0; width:100%;}

.btnClose {position:absolute; top:9%; right:-2%; z-index:5; width:10%; padding-bottom:7%; color:transparent;}
.btnClose span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:rgba(0,0,0,0);}

.lyPresent {display:none; position:absolute; top:30%; left:50%; z-index:60; width:86%; margin-left:-43%;}
.lyPresent .item {overflow:auto; position:absolute; top:25%; left:50%; width:83%; height:67%; margin-left:-41.5%; padding:0 5%; -webkit-overflow-scrolling:touch;}
.lyPresent p:first-child {padding-top:15%;}
.lyPresent .btnClose {top:8%;}

.lyCrisbox {display:none; position:absolute; top:30%; left:50%; z-index:60; width:86%; margin-left:-43%;}
.lyCrisbox p:first-child {padding-top:15%;}
.lyCrisbox .btnCoupon {position:absolute; bottom:15%; left:50%; z-index:5; width:62%; margin-left:-31%; padding-bottom:12.25%; color:transparent;}
.lyCrisbox .btnCoupon span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:rgba(0,0,0,0);}

.lyBooking {display:none; position:absolute; top:30%; left:50%; z-index:60; width:86%; margin-left:-43%;}
.lyBooking p:first-child {padding-top:15%;}
.lyBooking .btnCheck {position:absolute; bottom:11.5%; left:50%; z-index:5; width:62%; margin-left:-31%; padding-bottom:12.25%; color:transparent;}
.lyBooking .btnCheck span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:rgba(0,0,0,0);}

#mask {display:none; position:absolute; top:0; left:0; z-index:55; width:100%; height:100%; background:rgba(0,0,0,.6);}

.sns {position:relative;}
.sns ul {overflow:hidden; position:absolute; bottom:15%; left:50%; width:70%; margin-left:-35%;}
.sns ul li {float:left; width:33.333%;}
.sns ul li a {overflow:hidden; display:block; position:relative; height:0; margin:0 8%; padding-bottom:80.25%; color:transparent; font-size:11px; line-height:11px; text-align:center;}
.sns ul li span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:black; opacity:0; filter:alpha(opacity=0); cursor:pointer;}

.booking button {width:100%;}

.noti {padding:8% 3.4%; background-color:#ececec;}
.noti h3 {color:#3f3f3f; font-size:1.4rem;}
.noti h3 strong {border-bottom:2px solid #3f3f3f;}
.noti ul {margin-top:2rem;}
.noti ul li {position:relative; margin-top:0.5rem; padding-left:1rem; color:#7a7c7b; font-size:1.1rem; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:0.6rem; left:0; width:4px; height:4px; border-radius:50%; background-color:#7a7c7b;}

@media all and (min-width:480px){
	.noti ul li:after {width:6px; height:6px;}
}

/* flash animation */
@-webkit-keyframes flash {
	0% {opacity:0;}
	100% {opacity:1;}
}
@keyframes flash {
	0% {opacity:0;}
	100% {opacity:1;}
}
.flash {
	-webkit-animation-duration:1s;  -webkit-animation-name:flash; -webkit-animation-iteration-count:3;
	animation-duration:1s; animation-name:flash;  animation-iteration-count:3;
}
</style>
<script type="text/javascript">
	$(function(){
		setTimeout("pagedown()",500);
	});
function pagedown(){
	window.$('html,body').animate({scrollTop:$("#presentstart").offset().top+45}, 0);
}

function goAvengers(){
<% if systemok = "O" then %>
	<% If IsUserLoginOK Then %>
		<% if not( (left(currenttime,10)>="2015-12-09" and left(currenttime,10)<"2015-12-12") or (left(currenttime,10)>="2015-12-16" and left(currenttime,10)<"2015-12-19") ) then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if earlybirdyn <> "" then %>
				<% if Hour(currenttime) < 9 then %>
					alert("오전 9시 크리스박스가 돌아옵니다.");
					return;
				<% else %>
					<% if staffconfirm and  request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW %>
						alert("텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)");
						return;
					<% else %>
						var rstStr = $.ajax({
							type: "POST",
							url: "/event/etc/doeventsubscript/doEventSubscript67929.asp",
							data: "mode=add",
							dataType: "text",
							async: false
						}).responseText;

						if (rstStr == "SUCCESS"){
							$("#lyWin").show();
							$("#mask").show();
							var val = $("#lyWin").offset();
							$("html,body").animate({scrollTop:val.top},200);
							return false;
						}else if (rstStr == "FAIL"){
							$("#lyRechallenge").show();
							$("#mask").show();
							var val = $("#lyRechallenge").offset();
							$("html,body").animate({scrollTop:val.top},200);
							return false;
							return false;
						}else if (rstStr == "USERNOT"){
							alert('로그인을 해주세요.');
							return false;
						}else if (rstStr == "TIMENOT"){
							alert('오전 9시 크리스박스가 돌아옵니다.');
							return false;
						}else if (rstStr == "DATENOT"){
							alert('이벤트 응모 기간이 아닙니다.');
							return false;
						}else if (rstStr == "END"){
							alert('오늘의 응모는 모두 완료! 내일 또 도전해 주세요!');
							return false;
						}else if (rstStr == "KAKAO"){
							alert('친구에게 크리스박스를 알려주면,\n한 번 더! 응모 기회가 생겨요!');
							return false;
						}else if (rstStr == "SOLDOUT"){
							alert('오늘의 크리스박스는 마감 되었습니다.');
							return false;
						}
					<% end if %>
				<% end if %>
			<% else %>
				<% if Hour(currenttime) < 10 then %>
					alert("오전 10시 크리스박스가 돌아옵니다.");
					return;
				<% else %>
					<% if staffconfirm and  request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW %>
						alert("텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)");
						return;
					<% else %>
						var rstStr = $.ajax({
							type: "POST",
							url: "/event/etc/doeventsubscript/doEventSubscript67929.asp",
							data: "mode=add",
							dataType: "text",
							async: false
						}).responseText;
						if (rstStr == "SUCCESS"){
							$("#lyWin").show();
							$("#mask").show();
							var val = $("#lyWin").offset();
							$("html,body").animate({scrollTop:val.top},200);
							return false;
						}else if (rstStr == "FAIL"){
							$("#lyRechallenge").show();
							$("#mask").show();
							var val = $("#lyRechallenge").offset();
							$("html,body").animate({scrollTop:val.top},200);
							return false;
							return false;
						}else if (rstStr == "USERNOT"){
							alert('로그인을 해주세요.');
							return false;
						}else if (rstStr == "TIMENOT"){
							alert('오전 10시 크리스박스가 돌아옵니다.');
							return false;
						}else if (rstStr == "DATENOT"){
							alert('이벤트 응모 기간이 아닙니다.');
							return false;
						}else if (rstStr == "END"){
							alert('오늘의 응모는 모두 완료! 내일 또 도전해 주세요!');
							return false;
						}else if (rstStr == "KAKAO"){
							alert('친구에게 크리스박스를 알려주면,\n한 번 더! 응모 기회가 생겨요!');
							return false;
						}else if (rstStr == "SOLDOUT"){
							alert('오늘의 크리스박스는 마감 되었습니다.');
							return false;
						}
					<% end if %>
				<% end if %>
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
			return false;
		<% end if %>
	<% end if %>
<% else %>
	alert('잠시후 다시 시도해 주세요.');
	return false;
<% end if %>
}

//주문Process
function TnAddShoppingBag67929(bool){
<% if systemok = "O" then %>
	<% If IsUserLoginOK Then %>
		<% if not( (left(currenttime,10)>="2015-12-09" and left(currenttime,10)<"2015-12-12") or (left(currenttime,10)>="2015-12-16" and left(currenttime,10)<"2015-12-19") ) then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if earlybirdyn <> "" then %>
				<% if Hour(currenttime) < 9 then %>
					alert("오전 9시 크리스박스가 돌아옵니다.");
					return;
				<% else %>
					<% if staffconfirm and  request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW %>
						alert("텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)");
						return;
					<% else %>
					    var frm = document.sbagfrm;
					    var optCode = "0000";

					    if (!frm.itemea.value){
							alert('장바구니에 넣을 수량을 입력해주세요.');
							return;
						}

					    frm.itemoption.value = optCode;
					    <% if isapp then %>
							frm.mode.value = "DO3";  //2014 분기
						<% else %>
							frm.mode.value = "DO1";  //2014 분기
						<% end if %>
					    //frm.target = "_self";
					    //frm.target = "evtFrmProc"; //2015 변경
					    <% if isapp then %>
							frm.action="/apps/appcom/wish/web2014/inipay/shoppingbag_process.asp";
						<% else %>
							frm.action="/inipay/shoppingbag_process.asp";
						<% end if %>
						frm.submit();
					//	return;
					<% end if %>
				<% end if %>
			<% else %>
				<% if Hour(currenttime) < 10 then %>
					alert("오전 10시 크리스박스가 돌아옵니다.");
					return;
				<% else %>
					<% if staffconfirm and  request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW %>
						alert("텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)");
						return;
					<% else %>
					    var frm = document.sbagfrm;
					    var optCode = "0000";

					    if (!frm.itemea.value){
							alert('장바구니에 넣을 수량을 입력해주세요.');
							return;
						}

					    frm.itemoption.value = optCode;
					    <% if isapp then %>
							frm.mode.value = "DO3";  //2014 분기
						<% else %>
							frm.mode.value = "DO1";  //2014 분기
						<% end if %>
					    //frm.target = "_self";
					    //frm.target = "evtFrmProc"; //2015 변경
					    <% if isapp then %>
							frm.action="/apps/appcom/wish/web2014/inipay/shoppingbag_process.asp";
						<% else %>
							frm.action="/inipay/shoppingbag_process.asp";
						<% end if %>
						frm.submit();
						return;
					<% end if %>
				<% end if %>
			<% end if %>
		<% end if %>
	<% Else %>
		//쿠키
		var rstStr = $.ajax({
			type: "POST",
			url: "/event/etc/doeventsubscript/doEventSubscript67929.asp",
			data: "mode=notlogin",
			dataType: "text",
			async: false
		}).responseText;

		if (rstStr == "OK"){
			<% if isApp=1 then %>
				parent.calllogin();
				return false;
			<% else %>
				parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
				return false;
			<% end if %>
		}else{
			alert('오류가 발생했습니다.');
			return false;
		}
	<% End If %>
<% else %>
	alert('잠시후 다시 시도해 주세요.');
	return false;
<% end if %>
}

//쿠폰Process
function get_coupon(){
<% if systemok = "O" then %>
	<% If IsUserLoginOK Then %>
		<% if not( (left(currenttime,10)>="2015-12-09" and left(currenttime,10)<"2015-12-12") or (left(currenttime,10)>="2015-12-16" and left(currenttime,10)<"2015-12-19") ) then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if earlybirdyn <> "" then %>
				<% if Hour(currenttime) < 9 then %>
					alert("오전 9시 크리스박스가 돌아옵니다.");
					return;
				<% else %>
					<% if staffconfirm and  request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW %>
						alert("텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)");
						return;
					<% else %>
						var rstStr = $.ajax({
							type: "POST",
							url: "/event/etc/doeventsubscript/doEventSubscript67929.asp",
							data: "mode=coupon",
							dataType: "text",
							async: false
						}).responseText;
						if (rstStr == "SUCCESS"){
							alert('쿠폰이 발급되었습니다.');
							location.reload();
							return false;
						}else if (rstStr == "bonuscouponexistscount"){
							alert('오늘의 응모는 모두 완료! 내일 또 도전해 주세요!');
							return false;
						}else if (rstStr == "TIMENOT"){
							alert('오전 9시 크리스박스가 돌아옵니다.');
							return false;
						}else if (rstStr == "NOT1"){
							alert('크리스박스 응모후 다운로드가 가능합니다.');
							return false;
						}else if (rstStr == "DATENOT"){
							alert('이벤트 응모 기간이 아닙니다.');
							return false;
						}else if (rstStr == "USERNOT"){
							alert('로그인을 해주세요.');
							return false;
						}else{
							alert('관리자에게 문의');
							return false;
						}
					<% end if %>
				<% end if %>
			<% else %>
				<% if Hour(currenttime) < 10 then %>
					alert("오전 10시 크리스박스가 돌아옵니다.");
					return;
				<% else %>
					<% if staffconfirm and  request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW %>
						alert("텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)");
						return;
					<% else %>
						var rstStr = $.ajax({
							type: "POST",
							url: "/event/etc/doeventsubscript/doEventSubscript67929.asp",
							data: "mode=coupon",
							dataType: "text",
							async: false
						}).responseText;
						if (rstStr == "SUCCESS"){
							alert('쿠폰이 발급되었습니다.');
							location.reload();
							return false;
						}else if (rstStr == "bonuscouponexistscount"){
							alert('오늘의 응모는 모두 완료! 내일 또 도전해 주세요!');
							return false;
						}else if (rstStr == "TIMENOT"){
							alert('오전 10시 크리스박스가 돌아옵니다.');
							return false;
						}else if (rstStr == "NOT1"){
							alert('크리스박스 응모후 다운로드가 가능합니다.');
							return false;
						}else if (rstStr == "DATENOT"){
							alert('이벤트 응모 기간이 아닙니다.');
							return false;
						}else if (rstStr == "USERNOT"){
							alert('로그인을 해주세요.');
							return false;
						}else{
							alert('관리자에게 문의');
							return false;
						}
					<% end if %>
				<% end if %>
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
			return false;
		<% end if %>
	<% end if %>
<% else %>
	alert('잠시후 다시 시도해 주세요.');
	return false;
<% end if %>
}

//카카오 친구 초대
function kakaosendcall(snsgubun){
<% if systemok = "O" then %>
	<% If IsUserLoginOK Then %>
		<% if not( (left(currenttime,10)>="2015-12-09" and left(currenttime,10)<"2015-12-12") or (left(currenttime,10)>="2015-12-16" and left(currenttime,10)<"2015-12-19") ) then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if earlybirdyn <> "" then %>
				<% if Hour(currenttime) < 9 then %>
					alert("오전 9시 크리스박스가 돌아옵니다.");
					return;
				<% else %>
					<% if staffconfirm and  request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW %>
						alert("텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)");
						return;
					<% else %>
						var rstStr = $.ajax({
							type: "POST",
							url: "/event/etc/doeventsubscript/doEventSubscript67929.asp",
							data: "mode=kakao&snsgubun="+snsgubun,
							dataType: "text",
							async: false
						}).responseText;
						//alert(rstStr);
						if (rstStr == "SUCCESS"){
							if (snsgubun=="kk"){
								parent.parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>');
								//parent.parent_kakaolink('[텐바이텐] 슈퍼백의기적!\n\n신학기! 첫 출근! 첫 데이트!\n3월! 새로운 시작을 앞둔 당신에게 텐바이텐이 매일 새로운 Bag에 선물을 보내드립니다.!\n\n든든한 당신의 백! 지금 도전해 보세요!\n\n오직! 텐바이텐 APP에서!' , 'http://webimage.10x10.co.kr/eventIMG/2015/59795/kakao-banner.jpg' , '200' , '200' , 'http://m.10x10.co.kr/apps/link/?2920150313' );
								return false;
							}else if(snsgubun=="fb"){
								popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
								return false;
							}else if(snsgubun=="ln"){
								popSNSPost('ln','<%=snpTitle%>','<%=snpLink%>','','');
								return false;
							}
						}else if (rstStr == "USERNOT"){
							alert('로그인을 해주세요.');
							return false;
						}else if (rstStr == "DATENOT"){
							alert('이벤트 응모 기간이 아닙니다.');
							return false;
						}else if (rstStr == "STAFF"){
							alert('텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)');
							return false;
						}else if (rstStr == "TIMENOT"){
							alert('오전 9시 크리스박스가 돌아옵니다.');
							return false;
						}else if (rstStr == "FAIL"){
							alert('카카오톡 실패 관리자에게 문의 하세요');
							return false;
						}else if (rstStr == "END"){
							alert('오늘의 응모는 모두 완료! 내일 또 도전해 주세요!');
							return false;
						}else if (rstStr == "NOT1"){
							alert('크리스박스 응모후 눌러 주세요');
							return false;
						}else if (rstStr == "NOT2"){
							alert('오늘의 크리스박스는 모두 참여 하셨습니다.');
							return false;
						}
					<% end if %>
				<% end if %>
			<% else %>
				<% if Hour(currenttime) < 10 then %>
					alert("오전 10시 크리스박스가 돌아옵니다.");
					return;
				<% else %>
					<% if staffconfirm and  request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW %>
						alert("텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)");
						return;
					<% else %>
						var rstStr = $.ajax({
							type: "POST",
							url: "/event/etc/doeventsubscript/doEventSubscript67929.asp",
							data: "mode=kakao&snsgubun="+snsgubun,
							dataType: "text",
							async: false
						}).responseText;
						//alert(rstStr);
						if (rstStr == "SUCCESS"){
							if (snsgubun=="kk"){
								parent.parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>');
								//parent.parent_kakaolink('[텐바이텐] 슈퍼백의기적!\n\n신학기! 첫 출근! 첫 데이트!\n3월! 새로운 시작을 앞둔 당신에게 텐바이텐이 매일 새로운 Bag에 선물을 보내드립니다.!\n\n든든한 당신의 백! 지금 도전해 보세요!\n\n오직! 텐바이텐 APP에서!' , 'http://webimage.10x10.co.kr/eventIMG/2015/59795/kakao-banner.jpg' , '200' , '200' , 'http://m.10x10.co.kr/apps/link/?2920150313' );
								return false;
							}else if(snsgubun=="fb"){
								popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
								return false;
							}else if(snsgubun=="ln"){
								popSNSPost('ln','<%=snpTitle%>','<%=snpLink%>','','');
								return false;
							}
						}else if (rstStr == "USERNOT"){
							alert('로그인을 해주세요.');
							return false;
						}else if (rstStr == "DATENOT"){
							alert('이벤트 응모 기간이 아닙니다.');
							return false;
						}else if (rstStr == "STAFF"){
							alert('텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)');
							return false;
						}else if (rstStr == "TIMENOT"){
							alert('오전 10시 크리스박스가 돌아옵니다.');
							return false;
						}else if (rstStr == "FAIL"){
							alert('카카오톡 실패 관리자에게 문의 하세요');
							return false;
						}else if (rstStr == "END"){
							alert('오늘의 응모는 모두 완료! 내일 또 도전해 주세요!');
							return false;
						}else if (rstStr == "NOT1"){
							alert('크리스박스 응모후 눌러 주세요');
							return false;
						}else if (rstStr == "NOT2"){
							alert('오늘의 크리스박스는 모두 참여 하셨습니다.');
							return false;
						}
					<% end if %>
				<% end if %>
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
			return false;
		<% end if %>
	<% End If %>
<% else %>
	alert('잠시후 다시 시도해 주세요.');
	return false;
<% end if %>
}

function getearlybird(){
<% if systemok = "O" then %>
	<% If IsUserLoginOK Then %>
		<% if not( (left(currenttime,10)>="2015-12-09"  and left(currenttime,10)<"2015-12-18") ) then %>
			alert("얼리버드예약을 할 수 없는 기간입니다.");
			return;
		<% else %>
			<% if staffconfirm and  request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW %>
				alert("텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)");
				return;
			<% else %>
				var rstStr = $.ajax({
					type: "POST",
					url: "/event/etc/doeventsubscript/doEventSubscript67929.asp",
					data: "mode=al_com",
					dataType: "text",
					async: false
				}).responseText;
				//alert(rstStr);
				if (rstStr == "OK"){
					$("#lyBooking").show();
					$("#mask").show();
					var val = $("#lyBooking").offset();
					$("html,body").animate({scrollTop:val.top},200);
				}else{
					alert('오류가 발생했습니다.');
					return false;
				}
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
			return false;
		<% end if %>
	<% End If %>
<% else %>
	alert('잠시후 다시 시도해 주세요.');
	return false;
<% end if %>
}

function applink10x10(){
	var str = $.ajax({
		type: "GET",
		url: "/event/etc/doeventsubscript/doEventSubscript67929.asp",
		data: "mode=appdncnt",
		dataType: "text",
		async: false
	}).responseText;
	if (str == "OK"){
		var userAgent = navigator.userAgent.toLowerCase();
			parent.top.location.href='http://m.10x10.co.kr/apps/link/?8520151208';
			return false;
	
		$(function(){
			var chkapp = navigator.userAgent.match('tenapp');
			if ( chkapp ){
				$("#mo").hide();
			}else{
				$("#mo").show();
			}
		});
	}else{
		alert('오류가 발생했습니다.');
		return false;
	}
}


</script>

	<% ''//이미지 폴더 /01/ 1차, 이미지폴더 /02/ 2차 %>
	<div class="mEvt67929">
		<article>
			<h2 class="hidden">돌아온 크리스박스</h2>

			<div class="topic">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67929/02/tit_chris_box_return.gif" alt="" /></p>
				<p class="subcopy"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67929/02/txt_subcopy.png" alt="배송비 2천원만 결제하면 크리스박스가 갑니다" /></p>
			</div>
			<!--p id="presentstart" ><img src="http://webimage.10x10.co.kr/eventIMG/2015/67929/<%=weekimgfd%>/tit_chris_box_return.gif" alt="배송비 2천원만 결제하면 크리스박스가 갑니다" /></p-->

			<div class="present">
				<% if left(currenttime,10)>="2015-12-10" and left(currenttime,10)<"2015-12-12" then %>
					<% if earlybirdyn <> "" then %>
						<% if Hour(currenttime) < 9 then %>
							<p class="comingsoon"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67929/<%=weekimgfd%>/txt_coming_soon_01.png" alt="COMING SOON 오늘의 크리스박스가 마감되었습니다. 오전 10시, 다시 찾아옵니다!" /></p>
						<% end if %>
					<% else %>					
						<% if Hour(currenttime) < 10 then %>
							<p class="comingsoon"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67929/<%=weekimgfd%>/txt_coming_soon_01.png" alt="COMING SOON 오늘의 크리스박스가 마감되었습니다. 오전 10시, 다시 찾아옵니다!" /></p>
						<% end if %>
					<% end if %>
				<% else %>
					<% if left(currenttime,10)>="2015-12-12" and left(currenttime,10)<"2015-12-16" then %>
						<p class="comingsoon"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67929/<%=weekimgfd%>/txt_coming_soon_02.png" alt="COMING SOON 크리스박스가 마감되었습니다. 12월 16일 오전 10시, 새로운 크리스박스를기대해주세요!" /></p>
					<% end if %>
				<% end if %>

				<% if left(currenttime,10)>="2015-12-16" and left(currenttime,10)<"2015-12-19" then %>
					<% if earlybirdyn <> "" then %>
						<% if Hour(currenttime) < 9 then %>
							<p class="comingsoon"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67929/<%=weekimgfd%>/txt_coming_soon_01.png" alt="COMING SOON 오늘의 크리스박스가 마감되었습니다. 오전 10시, 다시 찾아옵니다!" /></p>
						<% end if %>
					<% else %>
						<% if Hour(currenttime) < 10 then %>
							<p class="comingsoon"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67929/<%=weekimgfd%>/txt_coming_soon_01.png" alt="COMING SOON 오늘의 크리스박스가 마감되었습니다. 오전 10시, 다시 찾아옵니다!" /></p>
						<% end if %>
					<% end if %>
				<% elseif left(currenttime,10)>"2015-12-18" then %>
					<p class="comingsoon"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67929/<%=weekimgfd%>/txt_coming_soon_01.png" alt="COMING SOON 오늘의 크리스박스가 마감되었습니다. 오전 10시, 다시 찾아옵니다!" /></p>
				<% end if %>

				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67929/<%=weekimgfd%>/img_present.jpg" alt="크리스박스는 배송비만 결제하면 위 상품 중 한가지 상품이 랜덤으로 담겨 발송됩니다." /></p>
				<a href="#lyPresent" id="btnMore" class="btnMore flash"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67929/<%=weekimgfd%>/btn_more.png" alt="상품 더보기" /></a>

				<button type="button" id="btnGet" onclick="goAvengers(); return false;" class="btnGet"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67929/<%=weekimgfd%>/btn_get.png" alt="응모하기" /></button>
	
			</div>

			<div id="lyPresent" class="lyPresent">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67929/<%=weekimgfd%>/txt_layer_present.png" alt="크리스박스 상품" /></p>
				<div class="item">
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/67929/<%=weekimgfd%>/img_present_item_01_v1.png" alt="아이패드 에어2 16기가 와이파이, 애플와치 42mm, 인스탁스 미니 8 패키지, 스티키몬스터 램프, 마이빔 스마트빔 프로젝터, 크리스마스 카드 트리와 스노우 맨, 디즈지 전기방석, 데꼴 2015 크리스마스 피규어, 스마일 스위치" />
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/67929/<%=weekimgfd%>/img_present_item_02_v1.png" alt="한달플래너, 하이하이커 2016 포토 캘린더, 크리스마스의 달빛 야광 달스티커, 미니언즈 USB 메모리 8기가, 센티드 틴 캔들, 슈퍼백의 기적 서커스 보이밴드 데일리라이크, 지브리 이웃집 토토로 KRA백, 월리를 찾아라 기차역 300피스 퍼즐, 아이띵소 핸디북 레드 블랙" />
				</div>
				<button type="button" class="btnClose"><span></span>닫기</button>
			</div>

			<% ''//for dev msg : 당첨 팝업 %>
			<div id="lyWin" class="lyCrisbox" style="display:none">
				<p><a href=""  onclick="TnAddShoppingBag67929(); return false;" title="크리스박스 구매 하러 가기"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67929/<%=weekimgfd%>/txt_layer_win.png" alt="축하해요 크리스박스 당첨!" /></a></p>
			</div>

			<% ''// for dev msg : 비당첨 팝업 %>
			<div id="lyRechallenge" class="lyCrisbox" style="display:none">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67929/<%=weekimgfd%>/txt_layer_rechallenge.png" alt="악! 이런 내일 다시 도전해주세요! 대신 오늘은 텐바이텐이 고객님께 배송비를 선물할게요!" /></p>
				<a href="" onclick="get_coupon(); return false;" class="btnCoupon"><span></span>쿠폰 다운 받기</a>
				<button type="button" class="btnClose"><span></span>닫기</button>
			</div>

			<% ''//for dev msg : sns 공유 %>
			<div class="sns">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67929/<%=weekimgfd%>/txt_sns.png" alt="친구에게 크리스박스를 알려주면, 한 번 더! 응모 기회가 생겨요!" /></p>
				<ul>
					<li><a href="" onclick="kakaosendcall('fb'); return false;"><span></span>페이스북</a></li>
					<li><a href="" onclick="kakaosendcall('kk'); return false;"><span></span>카카오톡</a></li>
					<li><a href="" onclick="kakaosendcall('ln'); return false;"><span></span>라인</a></li>
				</ul>
			</div>

			<div class="booking">
				<% ''// for dev msg : 얼리버드 예약하기 %>
				<% if left(currenttime,10)<"2015-12-11" then %>
					<p><button type="button" id="btnBooking" onclick="getearlybird(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67929/<%=weekimgfd%>/btn_booking.gif" alt="앱 전용 특별혜택 내일 열리는 크리스박스 남들보다 한 시간 먼저 응모하자! 얼리버드 예약하기" /></button></p>
				<% elseif left(currenttime,10)>="2015-12-11" and left(currenttime,10)<"2015-12-16" then %>
					<p><button type="button" id="btnBooking" onclick="getearlybird(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67929/<%=weekimgfd%>/btn_booking_fri.gif" alt="앱 전용 특별혜택 내일 열리는 크리스박스 남들보다 한 시간 먼저 응모하자! 얼리버드 예약하기" /></button></p>
				<% elseif left(currenttime,10)="2015-12-16" or left(currenttime,10)="2015-12-17" then %>
					<p><button type="button" id="btnBooking" onclick="getearlybird(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67929/<%=weekimgfd%>/btn_booking.gif" alt="앱 전용 특별혜택 내일 열리는 크리스박스 남들보다 한 시간 먼저 응모하자! 얼리버드 예약하기" /></button></p>
				<% else %>

				<% end if %>

				<% if isapp = 0 then %>
					<p><a href="" onclick="applink10x10(); return false;" title="텐바이텐 앱 다운로드 받기"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67929/<%=weekimgfd%>/btn_app.gif" alt="텐바이텐 APP 다운 받으면 더 핫한 이벤트와 할인 기회가 듬뿍!" /></a></p>
				<% end if %>
			</div>

			<% ''// for dev msg : 얼리버드 예약 완료 팝업 %>
			<div id="lyBooking" class="lyBooking">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67929/<%=weekimgfd%>/txt_layer_booking.png" alt="얼리버드 예약이 완료되었습니다. 예약알림을 받기 위해선 PUSH 알림 수신동의를 하셔야 합니다. 앱의 알림설정을 확인해주세요 iOS는 설정에 알림에서 10x10, 안드로이드는 앱을 실행 한 후 메뉴에서 설정으로 들어가시면 됩니다." /></p>
				<button type="button" class="btnCheck"><span></span>확인</button>
				<button type="button" class="btnClose"><span></span>닫기</button>
			</div>

			<section class="noti">
				<h3><strong>이벤트 유의사항</strong></h3>
				<ul>
					<li>본 이벤트는 텐바이텐 모바일페이지 및 APP에서만 참여 가능합니다.</li>
					<li>본 이벤트는 ID당 1회만 응모가능하며, 친구 초대 시 한 번 더 응모기회가 주어집니다.</li>
					<li>5만원 이상의 상품을 받으신 분께는 세무신고를 위해 개인정보를 요청할 수 있습니다. 제세공과금은 텐바이텐 부담입니다.</li>
					<li>무료배송쿠폰은 ID당 하루에 최대 2회까지 발행되며, 발급 당일 자정 기준으로 자동 소멸됩니다.<br>(텐바이텐 배송 상품 1만원 이상 구매 시 사용 가능)</li>
					<li>이벤트 내 모든 상품의 컬러는 랜덤으로 발송되며, 선택이 불가능합니다.</li>
					<li>크리스박스는 즉시 결제로만 구매가 가능하며, 배송 후 반품/교환/구매취소가 불가능합니다.</li>
				</ul>
			</section>
			<div class="bnr">
				<a href="eventmain.asp?eventid=68031"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67929/02/img_bnr.jpg" alt="12월 구매금액별 사은품 merry ALICE mas 이벤트 바로가기" /></a>
			</div>
			<div id="mask"></div>
			<form name="sbagfrm" method="post" action="" style="margin:0px;">
			<input type="hidden" name="mode" value="add" />
			<input type="hidden" name="itemid" value="<%= itemid %>" />
			<input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
			<input type="hidden" name="itemoption" value="0000" />
			<input type="hidden" name="userid" value="<%= getencloginuserid() %>" />
			<input type="hidden" name="isPresentItem" value="" />
			<input type="hidden" name="itemea" readonly value="1" />
			</form>	
			<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
		</article>
	</div>

<script type="text/javascript">
$(function(){
	/* layer present */
	$("#btnMore").click(function(){
		$("#lyPresent").show();
		$("#mask").show();
		var val = $("#lyPresent").offset();
		$("html,body").animate({scrollTop:val.top},200);
	});

	/* button close, button check */
	$("#lyPresent .btnClose, #lyRechallenge .btnClose, #lyBooking .btnCheck, #lyBooking .btnClose" ).click(function(){
		$("#lyPresent").hide();
		$("#lyBooking").hide();
		$("#lyRechallenge").hide();
		$("#mask").fadeOut();
	});

	/* mask */
	$("#mask").click(function(){
		$("#lyPresent").hide();
		$("#lyWin").hide();
		$("#lyRechallenge").hide();
		$("#lyBooking").hide();
		$("#mask").hide();
	});

});
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->
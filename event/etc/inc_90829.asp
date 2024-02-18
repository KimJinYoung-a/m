<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 천원의 기적3
' History : 2018-11-30 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_evaluatesearchercls.asp" -->
<%
	Dim currenttime, vEventStartDate, vEventEndDate, eCode, vEndEventAfterViewStartDate, vEndEventAfterViewEndDate, vEventConfirmDate
	'// 현재시간
	currenttime = now()
	'currenttime = "2018-12-06 오전 10:03:35"

	'// 이벤트 진행기간
	vEventStartDate = "2018-12-03"
	vEventEndDate = "2018-12-05"

	'// 이벤트 종료 후 당첨자 발표전까지 일자
	vEndEventAfterViewStartDate = "2018-12-06"
	vEndEventAfterViewEndDate = "2018-12-10"

	'// 당첨자 발표일자
	vEventConfirmDate = "2018-12-11"

	eCode = "90829"

	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = "[천원의 기적]"
	Dim kakaodescription : kakaodescription = "지금 하와이 여행 상품권을 1,000원으로 구매할 수 있는\n이벤트에 도전하세요!"
	Dim kakaooldver : kakaooldver = "지금 하와이 여행 상품권을 1,000원으로 구매할 수 있는\n이벤트에 도전하세요!"
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2018/90829/etcitemban20181130141704.JPEG"
	Dim kakaolink_url 
	If isapp = "1" Then '앱일경우
		kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode
	Else '앱이 아닐경우
		kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode
	End If

	'// 하나의 상품코드로 진행
	Dim miracleProductCode
	miracleProductCode = "2165571"

	Dim userHawaiEventOrderCount
	userHawaiEventOrderCount = 0
	If IsUserLoginOK() Then
		If Trim(miracleProductCode) <> "" Then
			'// 사용자의 해당일자 상품의 결제내역을 확인한다.
			Dim sqlstr
			sqlStr = ""
			sqlStr = sqlStr & " select count(m.userid) from db_order.dbo.tbl_order_master as m " &VBCRLF
			sqlStr = sqlStr & " 	inner join db_order.dbo.tbl_order_detail as d " &VBCRLF
			sqlStr = sqlStr & " 	on m.orderserial=d.orderserial " &VBCRLF
			sqlStr = sqlStr & " 	where m.jumundiv<>'9' and m.ipkumdiv > 3 and m.cancelyn = 'N' " &VBCRLF
			sqlStr = sqlStr & " 	and d.cancelyn<>'Y' and d.itemid<>'0' And m.userid='"&GetEncLoginUserId&"' " &VBCRLF
			sqlStr = sqlStr & " 	and d.itemid='"&miracleProductCode&"' " &VBCRLF
			rsget.Open sqlStr, dbget, 1
			userHawaiEventOrderCount = rsget(0)
			rsget.Close
		End If
	End If
%>
<style type="text/css">
.mEvt90829 {background:#161f47 url(http://webimage.10x10.co.kr/fixevent/event/2018/90829/m/bg_miracle.jpg) 0 0 no-repeat; background-size:100%;}
.mEvt90829 + .mEvt90829 {margin-top:1px;}
.mEvt90829.after {background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/90829/m/bg_miracle_after.jpg);}
.mEvt90829.dday {background-image:url(http://webimage.10x10.co.kr/fixevent/event/2018/90829/m/bg_miracle_dday.jpg);}
.mEvt90829 .info {position:relative;}
.mEvt90829 .info .btn-area {position:absolute; top:0; left:0;}
.mEvt90829 .info .btn-deposit {display:block; position:absolute; top:30%; right:0; width:40%; height:7%; text-indent:-999em;}
.mEvt90829.after .info .btn-deposit {top:inherit; bottom:10%; height:20%;}
.mEvt90829.dday .info .btn-deposit {top:inherit; bottom:3%; height:10%;}
.mEvt90829 .vod {position:relative; background:#000; padding-bottom:100%;}
.mEvt90829 .vod iframe {position:absolute; left:0; top:0; width:100%; height:100%;}
.mEvt90829 .winner {display:none; position:absolute; left:0; bottom:35.6%; width:100%; text-align:center; font-size:1.49rem; color:#fff;}
.mEvt90829.dday .winner {display:block;}
.mEvt90829 .winner span {display:inline-block; margin-right:0.3rem; font-size:2.05rem; color:#ffe5ac;}
.mEvt90829 .winner b {display:inline-block; font-family:'AvenirNext-DemiBold', 'AppleSDGothicNeo-SemiBold'; font-weight:bold; font-size:2.05rem;}
.mEvt90829 .noti {background-color:#161f47; padding:4.47rem 0;}
.mEvt90829 .noti strong {display:block; width:21.33%; margin:0 auto 2.13rem;}
.mEvt90829 .noti ul {padding:0 2.5rem;}
.mEvt90829 .noti li {margin-bottom:.5rem; color:#e0e0e0; font:bold 1.1rem/1.8rem 'AppleSDGothicNeo-SemiBold'; letter-spacing:-.03rem;}
.mEvt90829 .noti li:before {content:'·'; display:inline-block; width:0.85rem; margin-left:-0.85rem;}
.mEvt90829 .noti li a {padding:.1rem .5rem; margin-left:.5rem; background-color:#6a00d6; font-size:1rem;}
.mEvt90829 .bnr-share {border-top:0.43rem solid #f4f4f4;}
</style>
<script>
function TnAddShoppingBag90829(){
	<% If not( left(trim(currenttime),10)>=trim(vEventStartDate) and left(trim(currenttime),10) < trim(DateAdd("d", 1, trim(vEventEndDate))) ) Then %>
		alert("이벤트 응모기간이 아닙니다.");
		return false;
	<% end if %>
	<% If not(IsUserLoginOK) Then %>
		<% If isApp="1" or isApp="2" Then %>
			alert('로그인 후 참여하실 수 있습니다.');
			parent.calllogin();
			return false;
		<% Else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid="&eCode)%>');
			return false;
		<% End If %>
	<% end if %>
	<% If userHawaiEventOrderCount > 0 Then %>
		alert('고객님께서는 이벤트 상품을 이미 주문하셨습니다.\n한 ID당 최대 1개까지 주문 가능');
		return false;
	<% End If %>

	var frm = document.sbagfrm;
	var optCode = "0000";

	if (!frm.itemea.value){
		alert('장바구니에 넣을 수량을 입력해주세요.');
		return;
	}
	frm.itemoption.value = optCode;
	<% If isapp="1" Then %>
		frm.mode.value = "DO3"; //2014 분기
	<% Else %>
		frm.mode.value = "DO1"; //2014 분기
	<% End If %>
	//frm.target = "_self";
	<% If isapp="1" Then %>
		frm.target = "evtFrmProc"; //2014 변경
	<% End if %>
	frm.action="<%= appUrlPath %>/inipay/shoppingbag_process.asp";
	frm.submit();

	//setTimeout("parent.top.location.replace('<% '= appUrlPath %>/event/eventmain.asp?eventid=<%'= eCode %>')",500)
	return false;
}
function snschk() {
	<% if isapp="1" then %>
		fnAPPshareKakao('etc','<%=kakaotitle%>\n<%=kakaodescription%>','<%=kakaolink_url%>','<%=kakaolink_url%>','<%="url="&kakaolink_url%>','<%=kakaoimage%>','','','','');
		return false;
	<% else %>
		event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaolink_url%>' );
	<% end if %>
}
function parent_kakaolink(label , imageurl , width , height , linkurl ){
	//카카오 SNS 공유
	Kakao.init('c967f6e67b0492478080bcf386390fdd');

	Kakao.Link.sendTalkLink({
		label: label,
		image: {
		src: imageurl,
		width: width,
		height: height
		},
		webButton: {
			text: '10x10 바로가기',
			url: linkurl
		}
	});
}

//카카오 SNS 공유 v2.0
function event_sendkakao(label , description , imageurl , linkurl){	
	Kakao.Link.sendDefault({
		objectType: 'feed',
		content: {
			title: label,
			description : description,
			imageUrl: imageurl,
			link: {
			mobileWebUrl: linkurl
			}
		},
		buttons: [
			{
				title: '웹으로 보기',
				link: {
					mobileWebUrl: linkurl
				}
			}
		]
	});
}
</script>
<%' 90829 천원의 기적3 하와이 상품권 %>

<%' 실제 이벤트 진행기간 동안 보여줄 내용 %>
<% If left(trim(currenttime),10) < trim(DateAdd("d", 1, trim(vEventEndDate))) Then %>
	<div class="mEvt90829">
<% End If %>

<%' 이벤트 종료 후 당첨자 발표전까지 보여줄 내용 %>
<% If left(trim(currenttime),10)>=trim(vEndEventAfterViewStartDate) and left(trim(currenttime),10) < trim(DateAdd("d", 1, trim(vEndEventAfterViewEndDate))) Then %>
	<div class="mEvt90829 after">
<% End If %>

<%' 당첨자 발표일날 보여줄 내용 %>
<% If left(trim(currenttime),10)>=trim(vEventConfirmDate) Then %>
	<div class="mEvt90829 dday">
<% End If %>

	<%' 실제 이벤트 진행기간 동안 보여줄 내용 %>
	<% If left(trim(currenttime),10) < trim(DateAdd("d", 1, trim(vEventEndDate))) Then %>
		<p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90829/m/img_miracle.jpg?v=1.0" alt="천원의 기적"></p>
		<div class="info">
			<img src="http://webimage.10x10.co.kr/fixevent/event/2018/90829/m/txt_miracle.jpg?v=1.0" alt="">
			<%' for dev msg : 버튼 영역 %>
			<div class="btn-area">
				<a href="" onclick="TnAddShoppingBag90829();return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90829/m/btn_buy.png" alt="구매하러 가기"></a>
			</div>
			<%' for dev msg : 예치금 팝업 %>
			<% If isApp="1" Then %>
				<a href="" class="btn-deposit mApp" onclick="fnAPPpopupBrowserURL('예치금 안내','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/popDeposit.asp','bottom');return false;">예치금이란?</a>
			<% Else %>
				<a href="<%=wwwUrl%>/my10x10/popDeposit.asp" class="btn-deposit mWeb">예치금이란?</a>
			<% End If %>
		</div>
	<% End If %>
	<%'// 실제 이벤트 진행기간 동안 보여줄 내용 %>

	<%' 이벤트 종료 후 당첨자 발표전까지 보여줄 내용 %>
	<% If left(trim(currenttime),10)>=trim(vEndEventAfterViewStartDate) and left(trim(currenttime),10) < trim(DateAdd("d", 1, trim(vEndEventAfterViewEndDate))) Then %>
		<p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90829/m/img_miracle_after.jpg?v=1.0" alt="천원의 기적"></p>
		<div class="info">
			<img src="http://webimage.10x10.co.kr/fixevent/event/2018/90829/m/txt_miracle_after.jpg?v=1.0" alt="">
			<%' for dev msg : 버튼 영역 %>
			<div class="btn-area">
				<span><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90829/m/btn_buy_after.png" alt="12월 11일을 기다려주세요!"></span>
			</div>
			<%' for dev msg : 예치금 팝업 %>
			<% If isApp="1" Then %>
				<a href="" class="btn-deposit mApp" onclick="fnAPPpopupBrowserURL('예치금 안내','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/popDeposit.asp','bottom');return false;">예치금이란?</a>
			<% Else %>
				<a href="<%=wwwUrl%>/my10x10/popDeposit.asp" class="btn-deposit mWeb">예치금이란?</a>
			<% End If %>
		</div>
	<% End If %>
	<%'// 이벤트 종료 후 당첨자 발표전까지 보여줄 내용 %>

	<%' 당첨자 발표일날 보여줄 내용 %>
	<% If left(trim(currenttime),10)>=trim(vEventConfirmDate) Then %>
		<p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90829/m/img_miracle_dday.jpg" alt="천원의 기적"></p>
		<%' 동영상 %>
		<div class="vod">
			<iframe src="https://player.vimeo.com/video/305410179" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
		</div>
		<div class="info">
			<img src="http://webimage.10x10.co.kr/fixevent/event/2018/90829/m/txt_miracle_dday.jpg?v=1.0" alt="">
			<%' 당첨자 %>
			<div class="winner"><span>Vip gold.</span> <b>ykyeakyu**</b>님</div>
			<%' for dev msg : 예치금 팝업 %>
			<% If isApp="1" Then %>
				<a href="" class="btn-deposit mApp" onclick="fnAPPpopupBrowserURL('예치금 안내','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/popDeposit.asp','bottom');return false;">예치금이란?</a>
			<% Else %>
				<a href="<%=wwwUrl%>/my10x10/popDeposit.asp" class="btn-deposit mWeb">예치금이란?</a>
			<% End If %>
		</div>
	<% End If %>
	<%'// 당첨자 발표일날 보여줄 내용 %>

	<div class="noti">
		<strong><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90829/m/tit_noti.png" alt="유의사항"></strong>
		<ul>
			<li>본 이벤트는 텐바이텐 회원만 참여할 수 있습니다.</li>
			<li>당첨자에게는 상품에 따라 세무신고에 필요한 개인정보를 요청할 수 있습니다. (제세공과금은 텐바이텐이 부담합니다.)</li>
			<li>본 이벤트의 상품은 즉시 결제로만 구매할 수 있으며, 해당 이벤트에 응모 하신 후 당첨자 발표 이후에는 취소나 환불 처리가 되지 않습니다.</li>
			<li>예치금은 현금 반환 요청이 가능하며, 예치금 현금 반환은 직접 신청이 가능합니다. 
				<% If isApp="1" Then %>
					<a href="" onclick="fnAPPpopupBrowserURL('예치금 안내','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/popDeposit.asp','bottom');return false;">예치금이란? &gt;</a>
				<% Else %>
					<a href="<%=wwwUrl%>/my10x10/popDeposit.asp">예치금이란? &gt;</a>
				<% End If %>
			</li>
			<li>본 이벤트는 ID당 1회만 구매(응모) 가능합니다.</li>
			<li>당첨자는 12월 11일(화) 텐바이텐 이벤트 페이지 및 공지사항에 발표될 예정입니다.</li>
			<li>해당 이벤트의 경품은 모두투어의 여행상품권으로 진행합니다.</li>
		</ul>
	</div>
	<% If left(trim(currenttime),10) < trim(DateAdd("d", 1, trim(vEventEndDate))) Then %>
		<div class="bnr-share">
			<a href="" onclick="snschk();return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90829/m/bnr_share.jpg" alt="카카오톡 공유하기"></a>
		</div>
	<% End If %>
</div>
<%' // 90829 천원의 기적3 하와이 상품권 %>
<form name="sbagfrm" method="post" action="" style="margin:0px;">
<input type="hidden" name="mode" value="add" />
<input type="hidden" name="itemid" value="<%=miracleProductCode%>" />
<input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
<input type="hidden" name="itemoption" value="0000" />
<input type="hidden" name="userid" value="<%= getEncloginuserid() %>" />
<input type="hidden" name="isPresentItem" value="" />
<input type="hidden" name="itemea" readonly value="1" />
</form>	
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
<!-- #include virtual="/lib/db/dbclose.asp" -->
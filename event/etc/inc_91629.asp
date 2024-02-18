<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 천원의 기적5
' History : 2018-01-10 원승현 생성
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
	'currenttime = "2019-01-22 오전 10:03:35"

	'// 이벤트 진행기간
	vEventStartDate = "2019-01-14"
	vEventEndDate = "2019-01-16"

	'// 이벤트 종료 후 당첨자 발표전까지 일자
	vEndEventAfterViewStartDate = "2019-01-17"
	vEndEventAfterViewEndDate = "2019-01-21"

	'// 당첨자 발표일자
	vEventConfirmDate = "2019-01-22"

	eCode = "91629"

	'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
	Dim vTitle, vLink, vPre, vImg

	Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
	snpTitle	= Server.URLEncode("[천원의 기적] 이번엔 맥북에어가 천원")
	snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode)
	snpPre		= Server.URLEncode("텐바이텐")
	snpTag		= Server.URLEncode("텐바이텐")
	snpTag2		= Server.URLEncode("#10x10")

	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = "[천원의 기적] 이번엔 맥북에어가 천원"
	Dim kakaodescription : kakaodescription = "지금, 맥북에어를 천원에 살 수 있는 기회에 도전해보세요!"
	Dim kakaooldver : kakaooldver = "지금, 맥북에어를 천원에 살 수 있는 기회에 도전해보세요!"
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2018/91629/etcitemban20190107144619.JPEG"
	Dim kakaolink_url 
	If isapp = "1" Then '앱일경우
		kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode
	Else '앱이 아닐경우
		kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode
	End If

	'// 하나의 상품코드로 진행
	Dim miracleProductCode
	miracleProductCode = "2199320"

	Dim useriPadEventOrderCount
	useriPadEventOrderCount = 0
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
			useriPadEventOrderCount = rsget(0)
			rsget.Close
		End If
	End If
%>
<style type="text/css">
.mEvt91629 {background-color:#161f47;}
.mEvt91629 .item {position:relative;}
.mEvt91629 .item .txt {position:absolute; top:2.56rem; right:9.2%; width:24.8%; -webkit-border-radius:50%; border-radius:50%; -webkit-box-shadow:0.64rem 0.64rem 1.83rem rgba(77,7,195,0.64); box-shadow:0.64rem 0.64rem 1.83rem rgba(77,7,195,0.64); animation:bounce 1.6s linear infinite;}
@keyframes bounce { 0%{transform:translateY(0px);} 50%{transform:translateY(0.8rem);} 100%{transform:translateY(0px);} }
.mEvt91629 .vod {position:relative; background-color:#000; padding-bottom:100%;}
.mEvt91629 .vod iframe {position:absolute; left:0; top:0; width:100%; height:100%;}
.mEvt91629 .winner {position: relative;}
.mEvt91629 .winner ul {position:absolute; left:0; top:73.02%; width:100%; padding-left:16.27%; text-align:left;}
.mEvt91629 .winner ul li {font-size:1.28rem; color:#fff; letter-spacing:0.1rem;}
.mEvt91629 .winner ul li + li {margin-top:0.8rem;}
.mEvt91629 .winner b {display:inline-block; font-family:'AvenirNext-Medium', 'AppleSDGothicNeo-Medium'; font-size:1.54rem;}
.mEvt91629 .winner span {display:inline-block; width: 8rem; margin-right:1rem; font-size:1.54rem; color:#fff600;}
.mEvt91629 .noti {background-color:#161f47; padding:4.47rem 0;}
.mEvt91629 .noti strong {display:block; width:21.33%; margin:0 auto 2.13rem;}
.mEvt91629 .noti ul {padding:0 3.41rem;}
.mEvt91629 .noti li {margin-bottom:.5rem; color:#e0e0e0; font:bold 1.1rem/1.8rem 'AppleSDGothicNeo-SemiBold'; letter-spacing:-.03rem;}
.mEvt91629 .noti li:before {content:'·'; display:inline-block; width:0.85rem; margin-left:-0.85rem;}
.mEvt91629 .noti li a {padding:.1rem .5rem; margin-left:.5rem; background-color:#6a00d6; font-size:1rem;}
.mEvt91629 .bnr-sns {position:relative; border-top:0.43rem solid #fff;}
.mEvt91629 .bnr-sns ul {overflow:hidden; position:absolute; top:0; right:0; width:50%; height:100%;}
.mEvt91629 .bnr-sns ul li {float:left; width:50%; height:100%;}
.mEvt91629 .bnr-sns ul li a {display:inline-block; width:100%; height:100%; text-indent:-999em;}
</style>
<script>
function TnAddShoppingBag91629(){
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
	<% If useriPadEventOrderCount > 0 Then %>
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
<%' 91629 천원의 기적5 맥북에어 %>

<div class="mEvt91629">
    <%' 실제 이벤트 진행기간 동안 보여줄 내용 %>
    <% If left(trim(currenttime),10) < trim(DateAdd("d", 1, trim(vEventEndDate))) Then %>
        <h2><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91629/m/tit_miracle.jpg" alt="천원의 기적"></h2>
        <div class="item">
            <a href="" onclick="TnAddShoppingBag91629();return false;" title="구매하러 가기">
                <img src="http://webimage.10x10.co.kr/fixevent/event/2019/91629/m/img_event_01.jpg" alt="MacBook Air">
                <span class="txt"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91629/m/txt_winner.png" alt="당첨자 3명"></span>
            </a>
        </div>
        <p>
            <% If isApp="1" Then %>
                <a href="" class="mApp" onclick="fnAPPpopupBrowserURL('예치금 안내','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/popDeposit.asp','bottom');return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91629/m/img_event_02.jpg" alt="예치금이란?"></a>
            <% Else %>
                <a href="<%=wwwUrl%>/my10x10/popDeposit.asp" class="mWeb"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91629/m/img_event_02.jpg" alt="예치금이란?"></a>
            <% End If %>
        </p>
        <p><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91629/m/img_event_03.jpg" alt="이벤트 상세"></p>
	<% End If %>
	<%'// 실제 이벤트 진행기간 동안 보여줄 내용 %>

	<%' 이벤트 종료 후 당첨자 발표전까지 보여줄 내용 %>
	<% If left(trim(currenttime),10)>=trim(vEndEventAfterViewStartDate) and left(trim(currenttime),10) < trim(DateAdd("d", 1, trim(vEndEventAfterViewEndDate))) Then %>


        <h2><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91629/m/tit_miracle_after.jpg" alt="천원의 기적"></h2>
        <div class="item">
            <img src="http://webimage.10x10.co.kr/fixevent/event/2019/91629/m/img_after_01.jpg?v=1.0" alt="MacBook Air">
                <span class="txt"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91629/m/txt_winner.png" alt="당첨자 3명"></span>
        </div>
        <p>
            <% If isApp="1" Then %>
                <a href="" class="mApp" onclick="fnAPPpopupBrowserURL('예치금 안내','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/popDeposit.asp','bottom');return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91629/m/img_event_02.jpg" alt="예치금이란?"></a>
            <% Else %>
                <a href="<%=wwwUrl%>/my10x10/popDeposit.asp" class="mWeb"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91629/m/img_event_02.jpg" alt="예치금이란?"></a>
            <% End If %>
        </p>
	<% End If %>
	<%'// 이벤트 종료 후 당첨자 발표전까지 보여줄 내용 %>

	<%' 당첨자 발표일날 보여줄 내용 %>
	<% If left(trim(currenttime),10)>=trim(vEventConfirmDate) Then %>
        <h2><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91629/m/tit_dday.jpg" alt="천원의 기적"></h2>
        <%' 동영상 영역 %>
        <div class="vod"><iframe src="https://player.vimeo.com/video/312053666" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe></div>
        <div class="winner">
            <img src="http://webimage.10x10.co.kr/fixevent/event/2019/91629/m/img_dday_01.jpg" alt="MacBook Air 당첨자">
            <ul class="winner">
                <%' 당첨자 %>
                <li><span>RED</span> <b>llollol***</b>님</li>
				<li><span>VIP</span> <b>kwmzxc1234***</b>님</li>
				<li><span>WHITE</span> <b>ghghc***</b>님</li>
            </ul>
        </div>
        <p>
            <% If isApp="1" Then %>
                <a href="" class="mApp" onclick="fnAPPpopupBrowserURL('예치금 안내','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/popDeposit.asp','bottom');return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91629/m/img_event_02.jpg" alt="예치금이란?"></a>
            <% Else %>
                <a href="<%=wwwUrl%>/my10x10/popDeposit.asp" class="mWeb"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91629/m/img_event_02.jpg" alt="예치금이란?"></a>
            <% End If %>
        </p>
	<% End If %>
	<%'// 당첨자 발표일날 보여줄 내용 %>

    <%' 유의사항 (공통) %>
    <div class="noti">
        <strong><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91629/m/tit_noti.png" alt="유의사항"></strong>
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
            <li>당첨자는 1월 22일(화) 이벤트 페이지 및 공지사항에 발표될 예정입니다.</li>
            <li>당첨 상품 정보 : MacBook Air 13형 (1.6GHz 듀얼 코어 8세대 Intel Core i5 프로세서, 128GB 저장용량, 실버 컬러)</li>
        </ul>
    </div>

	<% If left(trim(currenttime),10) < trim(DateAdd("d", 1, trim(vEventEndDate))) Then %>
        <div class="bnr-sns">
            <img src="http://webimage.10x10.co.kr/fixevent/event/2019/91629/m/bnr_sns.jpg" alt="">
            <ul>
                <li><a href="" onclick="snschk();return false;">카카오톡 공유</a></li>
                <li><a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');return false;">페이스북 페이스북 공유</a></li>
            </ul>
        </div>
	<% End If %>
</div>
<%' // 91629 천원의 기적5 맥북에어 %>
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
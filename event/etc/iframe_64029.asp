<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 주문을 거는 마법의 번호 
' History : 2015-06-22 원승현
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<%
'Dim prveCode
dim eCode, vUserID, userid, myuserLevel, vPageSize, vPage, sqlStr, vTotalCount, vTotalSum, eLinkCode, prvCount, prvTotalcount, tempNum
	vUserID = GetLoginUserID()
	myuserLevel = GetLoginUserLevel
	userid = vUserID

	Dim vQuery, vCount, commentcount

	IF application("Svr_Info") = "Dev" THEN
		eCode = "63797"
	Else
		eCode = "64029"
	End If


	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' AND evt_code = '" & eCode & "' "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		vCount = rsget(0)
	End IF
	rsget.close

dim com_egCode, bidx
	Dim cEComment
	Dim iCTotCnt, arrCList,intCLoop, iSelTotCnt
	Dim iCPageSize, iCCurrpage
	Dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	Dim timeTern, totComCnt, iColorVal, eCC

	'파라미터값 받기 & 기본 변수 값 세팅
	iCCurrpage = requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	com_egCode = requestCheckVar(Request("eGC"),1)	

	IF iCCurrpage = "" THEN iCCurrpage = 1
	IF iCTotCnt = "" THEN iCTotCnt = -1

	iColorVal = 1

	'// 그룹번호 랜덤으로 지정

	iCPageSize = 6		'한 페이지의 보여지는 열의 수
	iCPerCnt = 4		'보여지는 페이지 간격

	'선택범위 리플개수 접수
	set cEComment = new ClsEvtComment

	cEComment.FECode 		= eCode
	cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수

	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iSelTotCnt = cEComment.FTotCnt '리스트 총 갯수
	set cEComment = nothing

	'코멘트 데이터 가져오기
	set cEComment = new ClsEvtComment

	cEComment.FECode 		= eCode
	'cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수

	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
	set cEComment = nothing

	iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
	IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1


%>
<style type="text/css">
img {vertical-align:top;}
.mEvt64029 {position:relative;}
.mEvt64029 input[type="radio"] {position:relative; width:20px; height:20px; border-radius:50%;}
.mEvt64029 input[type="radio"]:checked {background:#fff;}
.mEvt64029 input[type="radio"]:checked:after {content:' '; display:inline-block; position:absolute; left:50%; top:50%; width:10px; height:10px; margin:-5px 0 0 -5px; background:#d00000; border-radius:50%;}
.secretNumber .step1 {padding:0 3% 35px; text-align:center; font-size:12px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/64029/bg_stripe01.gif) repeat-y 0 0; background-size:100% auto;}
.secretNumber .step1 .tit {display:table; width:100%; padding:0 6px; color:#fff; font-weight:600; background:#6f7aea;}
.secretNumber .step1 .tit p{display:table-cell; width:30%; padding:13px 0 11px; vertical-align:middle;}
.secretNumber .step1 .tit p:first-child {width:40%;}
.selectOdr {padding:0 6px; background:#fff;}
.selectOdr li {display:table; width:100%; color:#777; border-bottom:1.5px solid #9adbf6;}
.selectOdr li:last-child {border-bottom:0;}
.selectOdr li p {display:table-cell; width:30%; padding:14px 0 10px;}
.selectOdr li p:first-child {width:40%;}
.selectOdr li p input {margin:-3px 5px 0 0;}
.secretNumber .step2 {padding:0 3%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/64029/bg_stripe02.gif) repeat-y 0 0; background-size:100% auto;}
.secretNumber .step2 ul {overflow:hidden; padding:0 6px; text-align:center;}
.secretNumber .step2 li {position:relative; float:left; width:25%; padding:0 3px 2px;}
.secretNumber .step2 li input {margin-top:6px; border:0; box-shadow:0 0 2px 1px rgba(0,0,0,.1)}
.secretNumber .step2 .writeWish {position:relative; padding:5px 100px 5px 5px; margin-top:14px; background:#d50001;}
.secretNumber .step2 .writeWish textarea {width:100%; height:73px; padding:15px; font-size:12px; border:0; border-radius:0; vertical-align:top; color:#6a6a6a; background:#fff;}
.secretNumber .step2 .writeWish .btnSubmit {position:absolute; right:5px; top:5px; width:96px; height:73px;}
.realTimeList {padding:0 10px 36px 10px; background:#f5f7f6;}
.realTimeList ul {margin-bottom:25px;}
.realTimeList li {height:49px; padding:0 8px 0 52px; margin-bottom:18px; font-size:12px; line-height:51px; color:#000; background-repeat:no-repeat; background-position:0 0; background-size:52px 49px;}
.realTimeList li p.txt {float:left;}
.realTimeList li p.writer {float:right;}
.realTimeList li p.writer span {position:relative; padding:0 8px;}
.realTimeList li p.writer span:first-child:after {content:' ' ; display:inline-block; position:absolute; right:0; top:13%; width:1px; height:70%; background:#000;}
.realTimeList li.wish01 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/64029/ico_wish01.gif); background-color:#cdf3ff;}
.realTimeList li.wish02 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/64029/ico_wish02.gif); background-color:#ffdfef;}
.realTimeList li.wish03 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/64029/ico_wish03.gif); background-color:#c0e1ff;}
.realTimeList li.wish04 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/64029/ico_wish04.gif); background-color:#fff8b3;}
.finishLayer {display:none; position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,.7);}
.finishLayer .finishCont {position:absolute; left:10%; top:28%; width:76%; padding-top:60px;}
.finishLayer .finishCont .btnClose {position:absolute; left:50%; bottom:9%; width:44%; margin-left:-22%;}
.evtNoti {padding:30px 20px 25px; font-size:11px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/64029/bg_notice.gif) repeat-y 0 0; background-size:100% auto;}
.evtNoti h3 {padding-bottom:16px;}
.evtNoti h3 strong {display:inline-block; font-size:13px; padding:6px 13px 4px; background:#fff; border-radius:12px;}
.evtNoti li {position:relative; padding:0 0 3px 12px; line-height:1.3;}
.evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:2.5px; width:3px; height:3px; border:2px solid #d50001; border-radius:50%;}
@media all and (min-width:480px){
	.mEvt64029 input[type="radio"] {width:30px; height:30px;}
	.mEvt64029 input[type="radio"]:checked:after {width:16px; height:16px; margin:-8px 0 0 -8px;}
	.secretNumber .step1 {padding:0 3% 58px; font-size:18px;}
	.secretNumber .step1 .tit {padding:0 9px;}
	.secretNumber .step1 .tit p{padding:20px 0 17px;}
	.selectOdr {padding:0 9px;}
	.selectOdr li {border-bottom:2px solid #9adbf6;}
	.selectOdr li p {padding:21px 0 15px;}
	.selectOdr li p input {margin:-4px 7px 0 0;}
	.secretNumber .step2 ul {padding:0 9px;}
	.secretNumber .step2 li {padding:0 4px 3px;}
	.secretNumber .step2 li input {margin-top:9px;}
	.secretNumber .step2 .writeWish {padding:7px 150px 7px 7px; margin-top:21px;}
	.secretNumber .step2 .writeWish textarea {height:110px; font-size:18px; padding:23px;}
	.secretNumber .step2 .writeWish .btnSubmit {right:7px; top:7px; width:144px; height:110px;}
	.realTimeList {padding:0 15px 54px 15px;}
	.realTimeList ul {margin-bottom:38px;}
	.realTimeList li {height:74px; padding:0 12px 0 78px; margin-bottom:24px; font-size:18px; line-height:76px; background-size:78px 74px;}
	.realTimeList li p.writer span {padding:0 12px;}
	.finishLayer .finishCont {padding-top:90px;}
	.evtNoti {padding:45px 30px 38px; font-size:17px;}
	.evtNoti h3 {padding-bottom:24px;}
	.evtNoti h3 strong {font-size:20px; padding:9px 20px 6px; border-radius:18px;}
	.evtNoti li {padding:0 0 4px 18px;}
	.evtNoti li:after {width:4px; height:4px; top:5px; border:3px solid #d50001;}
}
</style>
<script>
	function jsSubmitComment(){
	var frm = document.frmcom;

	<% If vUserID = "" Then %>
		<% If isapp="1" Then %>
		parent.calllogin();
		return;
		<% else %>
		parent.jsevtlogin();
		return;
		<% End If %>
	<% End If %>

	<% If Now() > #06/30/2015 23:59:59# Then %>
		alert("이벤트가 종료되었습니다.");
		return;
	<% Elseif Now() < #06/23/2015 00:00:00# Then %>
		alert("이벤트 기간이 아닙니다.");
		return;
	<% else %>
		<% If vUserID <> "" Then %>
		

			if (typeof $('input:radio[name="vOrderSerial"]:checked').val()=="undefined")
			{
				alert("주문번호를 선택하셔야 참여하실 수 있습니다.");
				return false;
			}
			
			if (typeof $('input:radio[name="vWishSelect"]:checked').val()=="undefined")
			{
				alert("소원을 선택해주세요.");
				return false;
			}

			if($("#qtext1").val() =="띄어쓰기 없이 여덟 글자 이내로 입력"){
				alert("내용을 입력해주세요.");
				$("#qtext1").val("");
				$("#qtext1").focus();
				return false;
			}

			if($("#qtext1").val() ==""){
				alert("내용을 입력해주세요.");
				$("#qtext1").val("");
				$("#qtext1").focus();
				return false;
			}

			var rstStr = $.ajax({
				type: "POST",
				url: "/event/etc/doEventSubscript64029.asp",
		        data: $("#frmcom").serialize(),
				dataType: "text",
				async: false
			}).responseText;
			if (rstStr==''){
				alert('정상적인 경로가 아닙니다.');
				return;
			}else if (rstStr=='99'){
				alert('정상적인 경로가 아닙니다.');
				return;
			}else if (rstStr=='88'){
				alert('로그인을 해주세요.');
				return;
			}else if (rstStr=='77'){
				alert('이벤트 기간이 아닙니다.');
				return;
			}else if (rstStr=='66'){
				alert('내용에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요.');
				return;
			}else if (rstStr=='33'){
				alert('데이터 처리에 문제가 발생하였습니다.');
				return;
			}else if (rstStr=='01'){
				$('.finishLayer').show();
			}else{
				alert('정상적인 경로가 아닙니다');
				return;
			}
		<% End If %>
	<% End if %>
}

$(function(){
	$('.btnClose').click(function(){
		$('.finishLayer').hide();
		document.location.reload();
	});

	<% if Request("iCC")<>"" or Request("eCC")<>"" then %>
		window.parent.$('html,body').animate({scrollTop:$('.realTimeList').offset().top-50}, 300);
	<% end if %>

});

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsChklogin33(blnLogin)
{
	if (blnLogin == "True"){
		if($("#qtext1").val() =="띄어쓰기 없이 여덟 글자 이내로 입력"){
			$("#qtext1").val("");
		}
		return true;
	} else {
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
	}

	return false;
}

//'글자수 제한
function checkLength(comment) {
	if (comment.value.length > 8 ) {
		comment.blur();
		comment.value = comment.value.substring(0, 8);
		alert('8자 이내로 입력해 주세요.');
		comment.focus();
		return false;
	}
}

</script>
</head>
<body>
<div class="evtCont">
	<!-- 주문을 거는 마법의 번호 -->
	<div class="mEvt64029">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/64029/tit_secret_number.gif" alt="주문을 거는 마법의 번호" /></h2>
		<div class="secretNumber">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/64029/tit_step1.gif" alt="STEP1. 주문번호 선택하기" /></h3>
			<div class="step1">
			<form name="frmcom" id="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
			<input type="hidden" name="mode" value="add">
			<input type="hidden" name="iCC" value="1">
			<input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
			<input type="hidden" name="eventid" value="<%= eCode %>">
			<input type="hidden" name="userid" value="<%= userid %>">
			<input type="hidden" name="linkevt" value="<%= eCode %>">
			<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>">
			<input type="hidden" name="txtcomm">
				<div class="tit">
					<p style="font-weight:bold;">주문번호</p>
					<p>주문일자</p>
					<p>결제금액</p>
				</div>
				<ul class="selectOdr">
					<%
						If userid <> "" Then
						vQuery = " Select top 10 "
						vQuery = vQuery & " m.orderserial, convert(varchar(10), m.regdate, 111) as regdate, m.subtotalprice, s.sub_opt1 "
						vQuery = vQuery & " From db_order.dbo.tbl_order_master m "
						vQuery = vQuery & " left join [db_event].[dbo].[tbl_event_subscript] s on m.userid = s.userid And m.orderserial = s.sub_opt1 "
						vQuery = vQuery & " And s.evt_code="&eCode&" "
						vQuery = vQuery & " Where  "
						vQuery = vQuery & " m.regdate >= '2015-06-01' and m.regdate < '2015-07-01' "
						vQuery = vQuery & " and m.jumundiv<>9 "
						vQuery = vQuery & " and m.ipkumdiv>3 "
						vQuery = vQuery & " and s.evt_code is null "
						vQuery = vQuery & " and m.userid='"&userid&"' "
						vQuery = vQuery & " and m.cancelyn='N' And m.sitename='10x10'  "
						vQuery = vQuery & " And s.sub_opt1 is null "
						vQuery = vQuery & "  order by m.orderserial desc  "
						rsget.Open vQuery,dbget,1
						IF Not rsget.Eof Then
							Do Until rsget.eof
					%>
					<li>
						<p><input type="radio" name="vOrderSerial" value="<%=rsget("orderserial")%>"/> <%=rsget("orderserial")%></p>
						<p><%=rsget("regdate")%></p>
						<p><%=FormatNumber(rsget("subtotalprice"), 0)%>원</p>
					</li>
					<%
							rsget.movenext
							Loop
						Else
					%>
					<li>
						<p>주문 내역이 없습니다.</p>
					</li>
					<%
						End IF
						rsget.close	
					%>
					<% Else %>
					<li>
						<p>주문 내역이 없습니다.</p>
					</li>
					<% End If %>
				</ul>
			</div>
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/64029/tit_step2.gif" alt="STEP2. 소원 입력하기" /></h3>
			<div class="step2">
				<ul>
					<li>
						<p><label for="wish01"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64029/btn_wish01.png" alt="건강" /></label></p>
						<input type="radio" id="wish01" name="vWishSelect" value="health"/>
					</li>
					<li>
						<p><label for="wish02"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64029/btn_wish02.png" alt="애정/결혼" /></label></p>
						<input type="radio" id="wish02" name="vWishSelect" value="love" />
					</li>
					<li>
						<p><label for="wish03"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64029/btn_wish03.png" alt="직장/학업" /></label></p>
						<input type="radio" id="wish03" name="vWishSelect" value="job" />
					</li>
					<li>
						<p><label for="wish04"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64029/btn_wish04.png" alt="재물" /></label></p>
						<input type="radio" id="wish04" name="vWishSelect" value="money" />
					</li>
				</ul>
				<div class="writeWish">
					<textarea name="qtext1" id="qtext1" onClick="jsChklogin33('<%=IsUserLoginOK%>');" onKeyUp="checkLength(this);">띄어쓰기 없이 여덟 글자 이내로 입력</textarea>
					<a href="#finish" class="btnSubmit" onclick="jsSubmitComment();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64029/btn_submit.gif" alt="입력하기" /></a>
				</div>
			</div>


			<%' 응모 완료 레이어 %>
			<div class="finishLayer">
				<div class="finishCont" id="finish">
					<div>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64029/txt_finish.gif" alt="응모완료! 7월1일 당첨자 발표를 기다리세요!" /></p>
						<a href="#" class="btnClose"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64029/btn_confirm.gif" alt="확인" /></a>
					</div>
				</div>
			</div>
			<%'// 응모 완료 레이어 %>
			<div class="secretGift"><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64029/img_gift.gif" alt="소원성취 상품" /></p></div>

			<% IF isArray(arrCList) THEN %>
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/64029/tit_realtime.gif" alt="실시간 소원 확인하기" /></h3>
				<div class="realTimeList">
					<ul>
						<%' for dev msg : 소원 종류에 따라 클래스 wish01~04 붙여주세요 / 리스트는 6개씩 노출됩니다 %>
						<% For intCLoop = 0 To UBound(arrCList,2) %>
						<% 
								Dim opt1 , opt2 , opt3
								If arrCList(1,intCLoop) <> "" then
									opt1 = SplitValue(arrCList(1,intCLoop),"//",0)
									opt2 = SplitValue(arrCList(1,intCLoop),"//",1)
									opt3 = SplitValue(arrCList(1,intCLoop),"//",2)
								End If 

								Select Case Trim(arrCList(7,intCLoop))
									Case "health"
										tempNum = "01"
									Case "love"
										tempNum = "02"
									Case "job"
										tempNum = "03"
									Case "money"
										tempNum = "04"
								End Select
						%>

						<li class="wish<%=tempNum%>">
							<p class="txt"><%=opt1%></p>
							<p class="writer"><span><%=printUserId(arrCList(2,intCLoop),2,"*")%></span><span>NO.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></span></p>
						</li>
					<% Next %>
					</ul>
					<% IF isArray(arrCList) THEN %>
						<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
					<% end if %>
				</div>
			<% End If %>
			</form>
		</div>
		<div class="evtNoti">
			<h3><strong>이벤트 유의사항</strong></h3>
			<ul>
				<li>텐바이텐 우수고객 대상 이벤트 입니다.</li>
				<li>문자 또는 푸쉬메세지를 받으신 고객만 이벤트에 참여 가능합니다.</li>
				<li>주문번호 1개당 한번씩 참여 할 수 있습니다.</li>
				<li>텐바이텐 모바일APP에서만 참여 할 수 있습니다.</li>
				<li>소원성취 상품 당첨자는 7월 1일 발표됩니다.</li>
				<li>당첨자에게는 사은품 배송을 위한 주소지 확인 작업이 진행됩니다.</li>
			</ul>
		</div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64029/img_tip.gif" alt="주문 후 이벤트 페이지에 다시 들어 올 수 있어요! 지나간 푸쉬 메세지 확인하는 방법!" /></p>
	</div>
	<!--// 주문을 거는 마법의 번호 -->
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
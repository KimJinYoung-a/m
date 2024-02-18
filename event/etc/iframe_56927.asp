<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description :  크리스마스 이벤트
' History : 2014.11.26 한용민 생성
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/event/etc/event56927Cls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->

<!-- #include virtual="/lib/inc/head.asp" -->
<%
dim eCode, dispcodeeCode, commentarrone, userid, rndNo, com_egCode, bidx
	eCode   = getevt_code
	dispcodeeCode = getevt_dispcode
	userid = getloginuserid()

com_egCode = 0

dim cEvent, ename, emimg
set cEvent = new ClsEvtCont
	cEvent.FECode = eCode
	cEvent.fnGetEvent

	ename		= cEvent.FEName
	emimg		= cEvent.FEMimg
set cEvent = nothing

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle = Server.URLEncode(ename)
snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=" & dispcodeeCode)
snpPre = Server.URLEncode("텐바이텐 이벤트")
snpTag = Server.URLEncode("텐바이텐 " & Replace(ename," ",""))
snpTag2 = Server.URLEncode("#10x10")
'snpImg = Server.URLEncode(emimg)
	
Dim upin '카카오 이벤트 key값 parameter
	upin = getNumeric(requestCheckVar(Request("upin"),10))

'//sns에서 타고 들어오는 내용 처리
if upin<>"" then
	commentarrone=getcommentarrone("", eCode, upin, "", "", "", "Y")
	
	if not(isarray(commentarrone)) then
		Response.Write "<script type='text/javascript'>alert('삭제 되었거나 존재하지 않는 글입니다.'); top.location.href='/event/eventmain.asp?eventid="& dispcodeeCode &"';</script>"
		dbget.close() : Response.End
	end if
%>
	<style type="text/css">
	.xmasMessage .cardList {padding:10px 12px 24px;}
	.xmasMessage img {vertical-align:top;}
	.xmasMessage .cardList li {margin-bottom:15px; border:4px solid #b38b4c;}
	.xmasMessage .cardList li .sendCont {padding:10px 15px 15px; font-size:11px; line-height:1; color:#be914a;}
	.xmasMessage .cardList li .sInfo {height:22px; line-height:22px;}
	.xmasMessage .cardList li .sInfo:after {content:" "; display:block; clear:both;}
	.xmasMessage .cardList li .sInfo span {display:inline-block;}
	.xmasMessage .cardList li .sInfo .num img {width:7px; vertical-align:middle; margin-top:-5px;}
	.xmasMessage .cardList li .sInfo .date {float:right;}
	.xmasMessage .cardList li .sInfo .del {display:inline-block; padding:4px 10px; margin-left:3px; font-size:10px; line-height:1; color:#b38b4c; border:1px solid #cbcbcb; border-radius:3px; background:#fff;  font-weight:bold;}
	.xmasMessage .cardList li .sText {padding:15px 2px; color:#777; line-height:1.2; border-top:1px solid #eadac7; border-bottom:1px solid #eadac7;}
	.xmasMessage .cardList li .sWriter {text-align:right; padding-top:6px;}
	@media all and (min-width:480px){
		.xmasMessage .cardList {padding:15px 18px 36px;}
		.xmasMessage .cardList li {margin-bottom:23px; border:6px solid #b38b4c;}
		.xmasMessage .cardList li .sendCont {padding:15px 23px 23px; font-size:17px;}
		.xmasMessage .cardList li .sInfo {height:33px; line-height:33px;}
		.xmasMessage .cardList li .sInfo .num img {width:11px; margin-top:-7px;}
		.xmasMessage .cardList li .sInfo .del {padding:6px 15px; margin-left:4px; font-size:15px; border-radius:4px;}
		.xmasMessage .cardList li .sText {padding:23px 3px;}
		.xmasMessage .cardList li .sWriter {padding-top:9px;}
	}
	</style>
	</head>
	<body>
	<div class="xmasMessage">
		<% if isarray(commentarrone) then %>
			<%
			randomize
			rndNo = Int((4 * Rnd) + 1)
			%>
			<div class="cardList">
				<ul>
					<li>
						<% '<!-- for dev msg : img_msg_pic01~04 이미지 랜덤으로 뿌려주세요 --> %>
						<div class="pic"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_msg_pic0<%= rndNo %>.jpg" alt="" /></div>
						<div class="sendCont">
							<div class="sInfo">
								<span class="num">
									<% If commentarrone(11,0) <> "W" Then %>
										<img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/ico_mobile.png" alt="모바일에서 작성" /> 
									<% end if %>
									<!--no.111-->
								</span>
								<span class="date"><%=FormatDate(commentarrone(5,0),"0000.00.00")%></span>
							</div>
							<div class="sText"><%=ReplaceBracket(db2html(commentarrone(3,0)))%></div>
							<p class="sWriter"><strong>from.</strong> <%=printUserId(commentarrone(2,0),2,"*")%></p>
						</div>
						<p><a href="/event/eventmain.asp?eventid=<%= dispcodeeCode %>" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/btn_go_card.gif" alt="크리스마스 카드 보내러가기" /></a></p>
					</li>
				</ul>
			</div>
		<% end if %>
	</div>
	</body>
	</html>

<% 
'//이벤트 메인
else
%>
	<%
	dim iCCurrpage, isMyComm, iCTotCnt, iCPerCnt, iCPageSize, cEComment, arrCList, iCTotalPage
		iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
		isMyComm	= requestCheckVar(request("isMC"),1)
	
		IF iCCurrpage = "" THEN
			iCCurrpage = 1
		END IF
		IF iCTotCnt = "" THEN
			iCTotCnt = -1
		END IF
	
		iCPerCnt = 10		'보여지는 페이지 간격
		iCPageSize = 4
	
		'데이터 가져오기
		set cEComment = new ClsEvtComment
	
		cEComment.FECode 		= eCode
		cEComment.FComGroupCode	= com_egCode
		cEComment.FEBidx    	= bidx
		cEComment.FCPage 		= iCCurrpage	'현재페이지
		cEComment.FPSize 		= iCPageSize	'페이지 사이즈
		if isMyComm="Y" then cEComment.FUserID = GetLoginUserID
		cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수
	
		arrCList = cEComment.fnGetComment		'리스트 가져오기
		iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
		set cEComment = nothing
	
		iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
		IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1
	
	dim commentexistscount, i, kakaotalksubscriptcount
	commentexistscount=0
	kakaotalksubscriptcount=0
	
	if userid<>"" then
		commentexistscount=getcommentexistscount(userid, eCode, "", "", "", "Y")

		'//카카오톡 본인 응모수
		kakaotalksubscriptcount = getevent_subscriptexistscount(eCode, userid, "kakaotalk", "", "")
	end if
	%>
	
	<style type="text/css">
	img {vertical-align:top;}
	.xmasMessage .writeCard {padding-bottom:40px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/bg_table.png) left top no-repeat #a48a6d; background-size:100% auto;}
	.xmasMessage .writeCard textarea {display:block; width:88%; height:100px; padding:10px; margin:0 auto; font-size:12px; color:#b0894a; border:4px solid #f4ead9; border-radius:0;}
	.xmasMessage .writeCard a {display:block; width:60%; margin:15px auto 0;}
	.xmasMessage .cardList {padding:10px 12px 24px;}
	.xmasMessage .cardList li {margin-bottom:15px; border:4px solid #b38b4c;}
	.xmasMessage .cardList li .sendCont {padding:10px 15px 15px; font-size:11px; line-height:1; color:#be914a;}
	.xmasMessage .cardList li .sInfo {height:22px; line-height:22px;}
	.xmasMessage .cardList li .sInfo:after {content:" "; display:block; clear:both;}
	.xmasMessage .cardList li .sInfo span {display:inline-block;}
	.xmasMessage .cardList li .sInfo .num img {width:7px; vertical-align:middle; margin-top:-5px;}
	.xmasMessage .cardList li .sInfo .date {float:right;}
	.xmasMessage .cardList li .sInfo .del {display:inline-block; padding:4px 10px; margin-left:3px; font-size:10px; line-height:1; color:#b38b4c; border:1px solid #cbcbcb; border-radius:3px; background:#fff;  font-weight:bold;}
	.xmasMessage .cardList li .sText {padding:15px 2px; color:#777; line-height:1.2; border-top:1px solid #eadac7; border-bottom:1px solid #eadac7;}
	.xmasMessage .cardList li .sWriter {text-align:right; padding-top:6px;}
	
	#shareXmasCard {display:none; position:absolute; left:0; top:0; width:100%; height:100%; z-index:600;}
	#shareXmasCard .mask {position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,.6); z-index:610;}
	.lyMessage {position:absolute; left:50%; top:2%; width:270px; margin-left:-135px; border:3px solid #b3915c; background:#fff; z-index:620;}
	.lyMessage .myMsg {width:90%; min-height:125px; margin:0 auto; padding:12px 10px; text-align:left; color:#c29c52; font-size:11px; line-height:1.2; background:#f5f3f0;}
	.lyMessage .btnWrap {padding:0 10% 15px;}
	.lyMessage .btnWrap a,
	.lyMessage .btnWrap button {display:inline-block; width:100%; margin-bottom:10px; background:none;}
	.lyMessage .lyrClose {position:absolute; top:0; right:0; width:30px; height:30px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/btn_close.gif) no-repeat 50% 50%; text-indent:-999em; background-size:10px 10px;}
	
	@media all and (min-width:480px){
		.xmasMessage .writeCard {padding-bottom:60px;}
		.xmasMessage .writeCard textarea {height:150px; padding:15px; font-size:18px; border:6px solid #f4ead9;}
		.xmasMessage .writeCard a {margin:23px auto 0;}
		.xmasMessage .cardList {padding:15px 18px 36px;}
		.xmasMessage .cardList li {margin-bottom:23px; border:6px solid #b38b4c;}
		.xmasMessage .cardList li .sendCont {padding:15px 23px 23px; font-size:17px;}
		.xmasMessage .cardList li .sInfo {height:33px; line-height:33px;}
		.xmasMessage .cardList li .sInfo .num img {width:11px; margin-top:-7px;}
		.xmasMessage .cardList li .sInfo .del {padding:6px 15px; margin-left:4px; font-size:15px; border-radius:4px;}
		.xmasMessage .cardList li .sText {padding:23px 3px;}
		.xmasMessage .cardList li .sWriter {padding-top:9px;}
	
		.lyMessage {width:406px; margin-left:-203px; border:4px solid #b3915c;}
		.lyMessage .myMsg {min-height:188px; padding:18px 15px; font-size:17px;}
		.lyMessage .btnWrap {padding:0 10% 23px;}
		.lyMessage .btnWrap a,
		.lyMessage .btnWrap button {margin-bottom:15px;}
		.lyMessage .lyrClose {width:45px; height:45px; background-size:15px 15px;}
	}
	</style>
	<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
	<script type="text/javascript">
	
	$(function(){
		//$('.writeCard .send').click(function(){
			//$('#shareXmasCard').show();
			//$(".mask").show();
			//return false;
		//});
	
		$(".lyMessage .close").click(function(){
			$("#shareXmasCard").hide();
			$(".mask").hide();

			location.reload();
		});
	
		$(".mask").click(function(){
			$('#shareXmasCard').hide();
			$(".mask").hide();
		});
		$('.writeCard .send').click(function(){
			window.parent.$('html,body').animate({scrollTop:145}, 500);
		});
	});
	
	function jsCheckLimit() {
		if ("<%=IsUserLoginOK%>"=="False") {
			<% if isApp=1 then %>
				parent.calllogin();
				return false;
			<% else %>
				parent.jsChklogin('<%=IsUserLoginOK%>');
				return false;
			<% end if %>
		}
	
		if(frmcom.txtcomm.value =="메리크리스마스! 글을 남겨주세요!(200자 이내)"){
			frmcom.txtcomm.value ="";
		}
	}
	
	function jsGoComPage(iP){
		document.frmcom.iCC.value = iP;
		document.frmcom.iCTot.value = "<%=iCTotCnt%>";
		document.frmcom.submit();
	}
	
	function jsSubmitComment(){
		if(frmcom.txtcomm.value =="로그인 후 글을 남길 수 있습니다."){
			<% if isApp=1 then %>
				parent.calllogin();
				return false;
			<% else %>
				parent.jsChklogin('<%=IsUserLoginOK%>');
				return false;
			<% end if %>
		}
		<% if commentexistscount>=5 then %>
			alert('한아이디당 5회 까지만 참여가 가능 합니다.');
			return;
		<% end if %>
	
		if(frmcom.txtcomm.value =="메리크리스마스! 글을 남겨주세요!(200자 이내)"){
			frmcom.txtcomm.value ="";
		}
		if(!frmcom.txtcomm.value){
			alert("코멘트를 입력해주세요");
			frmcom.txtcomm.focus();
			return false;
		}
		
		if (GetByteLength(frmcom.txtcomm.value) > 200){
			alert("코맨트가 제한길이를 초과하였습니다. 200자 까지 작성 가능합니다.");
			frmcom.txtcomm.focus();
			return;
		}
		var txtcomm=frmcom.txtcomm.value
	
		var str = $.ajax({
			type: "GET",
			url: "/event/etc/doEventSubscript56927.asp",
			data: "mode=add&txtcomm="+txtcomm,
			dataType: "text",
			async: false
		}).responseText;
	
		if (str==''){
			alert('정상적인 경로가 아닙니다');
			return;
		}else if (str=='99'){
			alert('로그인을 하셔야 참여가 가능 합니다.');
			return;
		}else if (str=='02'){
			alert('이벤트 응모 기간이 아닙니다.');
			return;
		}else if (str=='03'){
			alert('내용에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요.');
			return;
		}else if (str=='04'){
			alert('한번에 5회 이상 연속 등록 불가능합니다.');
			return;
		}else if (str=='05'){
			alert('데이터 처리에 문제가 발생하였습니다. 관리자에게 문의해 주십시오.');
			return;
		}else if (str=='06'){
			alert('한아이디당 5회 까지만 참여가 가능 합니다.');
			return;
		}else if (str.substring(0,2)=='01'){
			var evtcom_idx = str.substring(3,10);
			$('#evtcom_idx').val(evtcom_idx);
			$('#myMsg').html(txtcomm);
			$('#shareXmasCard').show();
			$(".mask").show();
			return;
		}else{
			alert('정상적인 경로가 아닙니다');
			return;
		}
	}
	
	function jsDelComment(cidx)	{
		<% If IsUserLoginOK() Then %>
			if (cidx==""){
				alert('정상적인 경로가 아닙니다');
				return;
			}

			if(confirm("삭제하시겠습니까?")){
				var str = $.ajax({
					type: "GET",
					url: "/event/etc/doEventSubscript56927.asp",
					data: "mode=del&Cidx="+cidx,
					dataType: "text",
					async: false
				}).responseText;
		
				if (str==''){
					alert('정상적인 경로가 아닙니다');
					return;
				}else if (str=='99'){
					alert('로그인을 하셔야 참여가 가능 합니다.');
					return;
				}else if (str=='02'){
					alert('이벤트 응모 기간이 아닙니다.');
					return;
				}else if (str=='03'){
					alert('데이터 처리에 문제가 발생하였습니다. 관리자에게 문의해 주십시오.');
					return;
				}else if (str=='01'){
					location.reload();
					return;
				}else{
					alert('정상적인 경로가 아닙니다');
					return;
				}
			}
		<% Else %>
			<% if isApp=1 then %>
				parent.calllogin();
				return false;
			<% else %>
				parent.jsChklogin('<%=IsUserLoginOK%>');
				return false;
			<% end if %>
		<% End IF %>
	}
	
	function sendkakaotalk() {
		<% If IsUserLoginOK() Then %>
			<% If getnowdate>="2014-12-01" and getnowdate<"2014-12-24" Then %>
				<% if kakaotalksubscriptcount>=5 then %>
					alert("친구초대는 5회 까지만 가능 합니다.");
					return;
				<% else %>
					var str = $.ajax({
						type: "GET",
						url: "/event/etc/doEventSubscript56927.asp",
						data: "mode=invitereg",
						dataType: "text",
						async: false
					}).responseText;
					//alert( str );
					if (str==''){
						alert('정상적인 경로가 아닙니다');
						return;
					}else if (str=='99'){
						alert('로그인을 하셔야 참여가 가능 합니다.');
						return;
					}else if (str=='02'){
						alert('이벤트 응모 기간이 아닙니다.');
						return;
					}else if (str=='03'){
						alert('친구초대는 5회 까지만 가능 합니다.');
						return;
					}else if (str=='01'){
						var evtcom_idx = $('#evtcom_idx').val();

						Kakao.init('c967f6e67b0492478080bcf386390fdd'); //appcode

						//기존 버전 대체용 2.0 -> 3.5 ver
						Kakao.Link.sendTalkLink({
							  label: '[텐바이텐] 크리스마스 카드가 도착했습니다.',
							  image: {
								//500kb 이하 이미지만 표시됨
								src: 'http://webimage.10x10.co.kr/eventIMG/2014/x-mas/katalk_200.gif',
								width: '200',
								height: '200'
							  },
							  webLink: {
								<% IF application("Svr_Info") = "Dev" THEN %>
									text: 'http://testm.10x10.co.kr/event/eventmain.asp?eventid=<%= dispcodeeCode %>&upin='+evtcom_idx,
									url: 'http://testm.10x10.co.kr/event/eventmain.asp?eventid=<%= dispcodeeCode %>&upin='+evtcom_idx 		// 앱 설정의 웹 플랫폼에 등록한 도메인의 URL이어야 합니다.
								<% else %>
									text: 'http://m.10x10.co.kr/event/eventmain.asp?eventid=<%= dispcodeeCode %>&upin='+evtcom_idx,
									url: 'http://m.10x10.co.kr/event/eventmain.asp?eventid=<%= dispcodeeCode %>&upin='+evtcom_idx 		// 앱 설정의 웹 플랫폼에 등록한 도메인의 URL이어야 합니다.
								<% end if %>
							  }
						});

						<% if isApp=1 then %>
							parent.location.href='/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= dispcodeeCode %>';
							return false;
						<% else %>
							parent.location.href='/event/eventmain.asp?eventid=<%= dispcodeeCode %>';
							return false;
						<% end if %>
					}
	
				<% end if %>
			<% else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% end if %>
		<% Else %>
			<% if isApp=1 then %>
				parent.calllogin();
				return false;
			<% else %>
				parent.jsChklogin('<%=IsUserLoginOK%>');
				return false;
			<% end if %>
		<% End IF %>
	}

	</script>
	</head>
	<body>
	<div class="xmasMessage">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/tit_send_message.gif" alt="SEND YOUR MESSAGE" /></h2>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_message_gift02.jpg" alt="1등-부산 해운대파크 하얏트 호텔 숙박권 / 2등 - 스타벅스 바닐라라떼 기프티콘" /></p>
	
		<form name="frmcom" method="post" style="margin:0px;"  action="#targetComment">
		<input type="hidden" name="eventid" value="<%=eCode%>">
		<input type="hidden" name="com_egC" value="<%=com_egCode%>">
		<input type="hidden" name="bidx" value="<%=bidx%>">
		<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
		<input type="hidden" name="iCTot" value="">
		<input type="hidden" name="mode" value="add">
		<input type="hidden" name="spoint" value="0">
		<input type="hidden" name="isMC" value="<%=isMyComm%>">
		<input type="hidden" name="evtcom_idx" id="evtcom_idx">
		<!-- 카드 작성하기 -->
		<div class="writeCard" id="writeCard">
			<textarea name="txtcomm" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%>><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %>메리크리스마스! 글을 남겨주세요!(200자 이내)<%END IF%></textarea>
			<!--<a href="#writeCard" class="send"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/btn_send.png" alt="크리스마스 카드 보내기" /></a>-->
			<a href="" onclick="jsSubmitComment(); return false;" class="send" id="kakaoa"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/btn_send.png" alt="크리스마스 카드 보내기" /></a>
		</div>
		<!--// 카드 작성하기 -->
		</form>

		<a name="targetComment"></a>
		<!-- 카드 리스트 -->
		<div class="cardList">
			<ul>
				<%
				IF isArray(arrCList) THEN
					For i = 0 To UBound(arrCList,2)
					randomize
					rndNo = Int((4 * Rnd) + 1)
				%>
				<li>
					<% '<!-- for dev msg : img_msg_pic01~04 이미지 랜덤으로 뿌려주세요 --> %>
					<div class="pic"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_msg_pic0<%= rndNo %>.jpg" alt="" /></div>
					<div class="sendCont">
						<div class="sInfo">
							<span class="num">
								<% If arrCList(8,i) <> "W" Then %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/ico_mobile.png" alt="모바일에서 작성" /> 
								<% end if %>
								no.<%=iCTotCnt-i-(iCPageSize*(iCCurrpage-1))%>
							</span>
							<span class="date">
								<%=FormatDate(arrCList(4,i),"0000.00.00")%> 
	
								<% if ((GetLoginUserID = arrCList(2,i)) or (GetLoginUserID = "10x10")) and ( arrCList(2,i)<>"") then %>
									<a href="" onclick="jsDelComment('<% = arrCList(0,i) %>');return false;" class="del">삭제</a>
								<% end if %>
							</span>
						</div>
						<div class="sText"><%=ReplaceBracket(db2html(arrCList(1,i)))%></div>
						<p class="sWriter"><strong>from.</strong> <%=printUserId(arrCList(2,i),2,"*")%></p>
					</div>
				</li>
				<%
					Next
				end if
				%>
			</ul>
	
			<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
		</div>
		<!--// 카드 리스트 -->
	
		<p class="goBenefit">
			<% if isApp=1 then %>
				<a href="" onclick="parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=56928'); return false;">
			<% else %>
				<a href="/event/eventmain.asp?eventid=56928" target="_top">
			<% end if %>

			<img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/btn_go_benefit02.gif" alt="크리스마스 혜택 보고 이벤트 응모하러 가기" /></a>
		</p>
	</div>
	<!-- SNS공유 레이어팝업(카드 보내기 클릭 후) -->
	<div id="shareXmasCard">
		<div class="lyMessage">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/tit_get_gift.gif" alt="크리스마스 카드보내고, 선물 받아요!" /></h3>
			<div class="myMsg" id="myMsg"></div>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/txt_send_kakao.gif" alt="올해 크리스마스 카드는 카카오톡으로 보내주세요. 카카오톡으로 크리스마스카드를 보내주시면 이벤트 당첨에 유리합니다." /></p>
			<div class="btnWrap">
				<button type="button" onclick="sendkakaotalk(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/btn_send_kakao.gif" alt="카톡으로 보내기" /></button>
				<button type="button" class="close"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/btn_no_send.gif" alt="보내지 않기" /></button>
			</div>
			<button type="button" class="lyrClose close">닫기</button>
			<p class="goBenefit">
				<% if isApp=1 then %>
					<a href="" onclick="parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=56928'); return false;">
				<% else %>
					<a href="/event/eventmain.asp?eventid=56928" target="_top">
				<% end if %>

				<img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/btn_go_benefit.gif" alt="다양한 혜택 보고 이벤트 응모하기" /></a>
			</p>
		</div>
		<div class="mask"></div>
	</div>
	<!--// SNS공유 레이어팝업 -->
	</body>
	</html>
<% end if %>

<!-- #include virtual="/lib/db/dbclose.asp" -->
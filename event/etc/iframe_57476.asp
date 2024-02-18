<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description :  스타워즈 이벤트
' History : 2014.12.09 원승현 생성
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/event/etc/event57476Cls.asp" -->
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
	upin = requestCheckVar(Request("upin"),15)

'//sns에서 타고 들어오는 내용 처리
if upin<>"" then
	commentarrone=getcommentarrone("", eCode, upin, "", "", "", "Y")
	
	if not(isarray(commentarrone)) then
		Response.Write "<script type='text/javascript'>alert('삭제 되었거나 존재하지 않는 글입니다.'); top.location.href='/event/eventmain.asp?eventid="& dispcodeeCode &"';</script>"
		dbget.close() : Response.End
	end if
%>
	<style type="text/css">
		.mEvt57476 img {width:100%; vertical-align:top;}
		.mEvt57476 .cardList {padding:15px 10px 40px; background:#fff;}
		.mEvt57476 .cardList li {position:relative; margin-bottom:15px; background-position:left top; background-repeat:no-repeat; background-size:100% 100%;}
		.mEvt57476 .cardList li.card01 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/57476/bg_card01.jpg);}
		.mEvt57476 .cardList li.card02 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/57476/bg_card02.jpg);}
		.mEvt57476 .cardList li.card03 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/57476/bg_card03.jpg);}
		.mEvt57476 .cardList li.card04 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/57476/bg_card04.jpg);}
		.mEvt57476 .cardList li.card05 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/57476/bg_card05.jpg);}
		.mEvt57476 .cardList li.card06 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/57476/bg_card06.jpg);}
		.mEvt57476 .cardList li p {position:absolute; color:#fff; font-size:10px;}
		.mEvt57476 .cardList li p.num {left:5%; top:4%; line-height:22px;}
		.mEvt57476 .cardList li p.date {right:5%; top:4%; line-height:22px;}
		.mEvt57476 .cardList li p.date .button {margin:-3px 0 0 5px;}
		.mEvt57476 .cardList li p.msg {right:5%; top:19%; width:58%; height:62%; padding:10px; line-height:1.2; color:#555; background:#fff;}
		.mEvt57476 .cardList li p.writer {right:5%; bottom:8%;}
		.mEvt57476 .cardList li .mob {width:6px; vertical-align:middle; margin-top:-6px;}
		.mEvt57476 .cardList li .button {font-weight:bold; background:#fff;}

		@media all and (min-width:480px){
			.mEvt57476 .cardList {padding:23px 15px 60px;}
			.mEvt57476 .cardList li {margin-bottom:23px;}
			.mEvt57476 .cardList li p {font-size:17px;}
			.mEvt57476 .cardList li p.num {line-height:33px;}
			.mEvt57476 .cardList li p.date {line-height:33px;}
			.mEvt57476 .cardList li p.date .button {margin:-4px 0 0 7px;}
			.mEvt57476 .cardList li p.msg {padding:15px;}
			.mEvt57476 .cardList li .mob {width:9px; margin-top:-8px;}
		}
	</style>
	</head>
	<body>
	<!-- 스타워즈 모바일카드 보내기(M) -->
	<div class="mEvt57476">
		<% if isarray(commentarrone) then %>
		<div class="cardList">
			<ul>
				<%' for dev msg : 카드선택에 따라 순서대로 클래스 .card01~06 넣어주세요. %>
				<li class="<%=commentarrone(10,0)%>">
					<div class="view">
						<p class="num">
							<% If commentarrone(11,0) <> "W" Then %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2014/57476/ico_mobile.png" alt="" class="mob" /></p>
							<% End If %>
						<p class="date"><%=FormatDate(commentarrone(5,0),"0000.00.00")%></p>
						<p class="msg"><%=ReplaceBracket(db2html(commentarrone(3,0)))%></p>
						<p class="writer"><strong>from.</strong><%=printUserId(commentarrone(2,0),2,"*")%></p>
					</div>
					<div class="bg"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57476/bg_card.png" alt="" /></div>
				</li>
			</ul>
			<p><a href="/event/eventmain.asp?eventid=<%= dispcodeeCode %>" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57476/btn_send_card.gif" alt="스타워즈 모바일 카드 보내러 가기" /></a></p>
		</div>
		<% End If %>
	</div>
	<!--// 스타워즈 모바일카드 보내기(M) -->
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
		.mEvt57476 img {width:100%; vertical-align:top;}
		.mEvt57476 .swMenu {position:relative;}
		.mEvt57476 .swMenu ul {position:absolute; left:0; bottom:0; overflow:hidden; width:100%; height:100%; z-index:30;}
		.mEvt57476 .swMenu li {float:left; width:25%; height:63%; margin-top:11%;}
		.mEvt57476 .swMenu li a {display:block; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55406/blank.png) left top repeat; background-size:100% 100%; text-indent:-9999em;}
		.mEvt57476 .swMenu li.on {height:100%; margin-top:0;}
		.mEvt57476 .selectCard {background:url(http://webimage.10x10.co.kr/eventIMG/2014/57476/bg_select_card.png) left top repeat; background-size:100% 100%;}
		.mEvt57476 .selectCard ul {overflow:hidden; padding:25px 5px 5px;}
		.mEvt57476 .selectCard li {float:left; width:33.33333%; padding:0 0 15px; text-align:center;}
		.mEvt57476 .selectCard li input {margin-top:8px}
		.mEvt57476 .writeCard {padding:24px 0 24px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/57476/bg_write_card.png) left top repeat; background-size:100% 100%;}
		.mEvt57476 .writeCard textarea {display:block; width:90%; margin:0 auto 22px; border:3px solid #474747; color:#555; font-size:12px; border-radius:0; background:#fff;}
		.mEvt57476 .writeCard .send {display:block; width:80%; margin:0 auto;}
		.mEvt57476 .cardList {padding:15px 10px 40px; background:#fff;}
		.mEvt57476 .cardList ul {padding-top:15px; border-top:2px solid #ddd;}
		.mEvt57476 .cardList li {position:relative; margin-bottom:20px; background-position:left top; background-repeat:no-repeat; background-size:100% 100%;}
		.mEvt57476 .cardList li.card01 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/57476/bg_card01.jpg);}
		.mEvt57476 .cardList li.card02 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/57476/bg_card02.jpg);}
		.mEvt57476 .cardList li.card03 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/57476/bg_card03.jpg);}
		.mEvt57476 .cardList li.card04 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/57476/bg_card04.jpg);}
		.mEvt57476 .cardList li.card05 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/57476/bg_card05.jpg);}
		.mEvt57476 .cardList li.card06 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/57476/bg_card06.jpg);}
		.mEvt57476 .cardList li p {position:absolute; color:#fff; font-size:10px;}
		.mEvt57476 .cardList li p.num {left:5%; top:4%; line-height:22px;}
		.mEvt57476 .cardList li p.date {right:5%; top:4%; line-height:22px;}
		.mEvt57476 .cardList li p.date .button {margin:-3px 0 0 5px;}
		.mEvt57476 .cardList li p.msg {right:5%; top:19%; width:58%; height:62%; padding:10px; line-height:1.2; color:#555; background:#fff;}
		.mEvt57476 .cardList li p.writer {right:5%; bottom:8%;}
		.mEvt57476 .cardList li .mob {width:6px; vertical-align:middle; margin-top:-6px;}
		.mEvt57476 .cardList li .button {font-weight:bold; background:#fff;}

		@media all and (min-width:480px){
			.mEvt57476 .selectCard ul {padding:38px 7px 7px;}
			.mEvt57476 .selectCard li {padding:0 0 23px;}
			.mEvt57476 .selectCard li input {margin-top:12px}
			.mEvt57476 .writeCard {padding:36px 0 36px;}
			.mEvt57476 .writeCard textarea {margin:0 auto 33px; border:4px solid #474747; font-size:18px;}
			.mEvt57476 .cardList {padding:23px 15px 60px;}
			.mEvt57476 .cardList ul {padding-top:23px; border-top:3px solid #ddd;}
			.mEvt57476 .cardList li {margin-bottom:30px;}
			.mEvt57476 .cardList li p {font-size:17px;}
			.mEvt57476 .cardList li p.num {line-height:33px;}
			.mEvt57476 .cardList li p.date {line-height:33px;}
			.mEvt57476 .cardList li p.date .button {margin:-4px 0 0 7px;}
			.mEvt57476 .cardList li p.msg {padding:15px;}
			.mEvt57476 .cardList li .mob {width:9px; margin-top:-8px;}
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
	
//		$(".lyMessage .close").click(function(){
//			$("#shareXmasCard").hide();
//			$(".mask").hide();

//			location.reload();
//		});
	
//		$(".mask").click(function(){
//			$('#shareXmasCard').hide();
//			$(".mask").hide();
//		});
//		$('.writeCard .send').click(function(){
//			window.parent.$('html,body').animate({scrollTop:145}, 500);
//		});
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
	
		if(frmcom.txtcomm.value =="크리스마스 메시지를 남겨주세요. (120자 내외)"){
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
	
		if ($("input:[name='SelCrdPic']").is(":checked")==false)
		{
			alert("모바일 카드 이미지를 선택해주세요.");
			return false;
		}

		if(frmcom.txtcomm.value =="크리스마스 메시지를 남겨주세요. (120자 내외)"){
			frmcom.txtcomm.value ="";
		}

		if(!frmcom.txtcomm.value){
			alert("코멘트를 입력해주세요");
			frmcom.txtcomm.focus();
			return false;
		}
		if (GetByteLength(frmcom.txtcomm.value) > 120){
			alert("코맨트가 제한길이를 초과하였습니다. 120자 까지 작성 가능합니다.");
			frmcom.txtcomm.focus();
			return;
		}
		var txtcomm=frmcom.txtcomm.value
		var SelCrdPic=$(':radio[name="SelCrdPic"]:checked').val();

		var str = $.ajax({
			type: "GET",
			url: "/event/etc/doEventSubscript57476.asp",
			data: "mode=add&txtcomm="+txtcomm+"&SelCrdPic="+SelCrdPic,
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
//			$('#myMsg').html(txtcomm);
//			$('#shareXmasCard').show();
//			$(".mask").show();
//			alert(document.frmcom.SelCrdPic.value);
			sendkakaotalk(SelCrdPic);
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
					url: "/event/etc/doEventSubscript57476.asp",
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
	
	function sendkakaotalk(imgstr) {
		<% If IsUserLoginOK() Then %>
			<% If getnowdate>="2014-12-08" and getnowdate<"2014-12-31" Then %>
				<% if kakaotalksubscriptcount>=5 then %>
					alert("친구초대는 5회 까지만 가능 합니다.");
					return;
				<% else %>
					var str = $.ajax({
						type: "GET",
						url: "/event/etc/doEventSubscript57476.asp",
						data: "mode=invitereg&SelCrdPic="+imgstr,
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
							  label: '[텐바이텐] 스타워즈 크리스마스 카드가 도착했습니다.',
							  image: {
								//500kb 이하 이미지만 표시됨
								src: 'http://webimage.10x10.co.kr/eventIMG/2014/57476/img_'+imgstr+'.png',
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
							setTimeout("parent.location.href='/event/eventmain.asp?eventid=<%= dispcodeeCode %>'", 1000);
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

		<!-- 이벤트 배너 등록 영역 -->
		<div class="evtCont">
			<!-- 스타워즈 모바일카드 보내기(M) -->
			<div class="mEvt57476">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/57476/tit_starwars.jpg" alt="스타워즈 크리스마스 에피소드" /></h2>
				<div class="swMenu">
					<ul>
						<li><a href="/event/eventmain.asp?eventid=57473" target="_top">아이템</a></li>
						<li><a href="/event/eventmain.asp?eventid=57474" target="_top">크리스마스 선물</a></li>
						<li><a href="/event/eventmain.asp?eventid=57475" target="_top">에피소드7 미리보기</a></li>
						<li class="on"><a href="/event/eventmain.asp?eventid=57476" target="_top">모바일카드 보내기</a></li>
					</ul>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57473/tab_starwars04.jpg" alt="" /></p>
				</div>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57476/txt_send_card.jpg" alt="소중한 분에게 STAR WARS 크리스마스 카드를 보내세요. 랜덤으로 매일 1분씩을 선정해 요다 알람시계를 선물로 드립니다." /></p>

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

				<!-- 카드 선택, 작성하기 -->
				<div class="selectCard">
					<ul>
						<li>
							<label for="c01"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57476/img_card01.png" alt="" /></label>
							<input type="radio" id="c01" name="SelCrdPic" value="card01"/>
						</li>
						<li>
							<label for="c02"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57476/img_card02.png" alt="" /></label>
							<input type="radio" id="c02" name="SelCrdPic" value="card02" />
						</li>
						<li>
							<label for="c03"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57476/img_card03.png" alt="" /></label>
							<input type="radio" id="c03" name="SelCrdPic" value="card03" />
						</li>
						<li>
							<label for="c04"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57476/img_card04.png" alt="" /></label>
							<input type="radio" id="c04" name="SelCrdPic" value="card04"  />
						</li>
						<li>
							<label for="c05"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57476/img_card05.png" alt="" /></label>
							<input type="radio" id="c05" name="SelCrdPic" value="card05"  />
						</li>
						<li>
							<label for="c06"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57476/img_card06.png" alt="" /></label>
							<input type="radio" id="c06" name="SelCrdPic" value="card06"  />
						</li>
					</ul>
				</div>
				<div class="writeCard">
					<textarea cols="15" rows="5" name="txtcomm" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%>><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %>크리스마스 메시지를 남겨주세요. (120자 내외)<% End If %></textarea>
					<a href="" onclick="jsSubmitComment(); return false;"  class="send" id="kakaoa"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57476/btn_send_card.png" alt="" /></a>
				</div>
				</form>
				<!--// 카드 선택, 작성하기 -->
				<a name="targetComment"></a>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57476/txt_event_noti.jpg" alt="이벤트 유의사항" /></p>
				<!-- 카드 리스트 -->
				<div class="cardList">
					<ul>
						<%
						IF isArray(arrCList) THEN
							For i = 0 To UBound(arrCList,2)
'							randomize
'							rndNo = Int((4 * Rnd) + 1)
						%>
						<%' for dev msg : 카드선택에 따라 순서대로 클래스 .card01~06 넣어주세요. 리스트는 4개씩 노출됩니다 %>
							<li class="<%=arrCList(7,i) %>">
								<div class="view">
									<p class="num">no.<%=iCTotCnt-i-(iCPageSize*(iCCurrpage-1))%> 
										<% If arrCList(8,i) <> "W" Then %>
											<img src="http://webimage.10x10.co.kr/eventIMG/2014/57476/ico_mobile.png" alt="" class="mob" />
										<% End If %>
									</p>
									<p class="date">
										<%=FormatDate(arrCList(4,i),"0000.00.00")%> 
			
										<% if ((GetLoginUserID = arrCList(2,i)) or (GetLoginUserID = "10x10")) and ( arrCList(2,i)<>"") then %>
											<span class="button btS1 btGryBdr cGy1"><a href="" onclick="jsDelComment('<% = arrCList(0,i) %>');return false;" class="del">삭제</a></span>
										<% end if %>								
									<p class="msg"><%=ReplaceBracket(db2html(arrCList(1,i)))%></p>
									<p class="writer"><strong>from.</strong><%=printUserId(arrCList(2,i),2,"*")%></p>
								</div>
								<div class="bg"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57476/bg_card.png" alt="" /></div>
							</li>
						<%
							Next
						end if
						%>
					</ul>
					<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
				</div>
				<!--// 카드 리스트 -->

			</div>
			<!--// 스타워즈 모바일카드 보내기(M) -->
		</div>
		<!--// 이벤트 배너 등록 영역 -->
	</body>
	</html>
<% end if %>

<!-- #include virtual="/lib/db/dbclose.asp" -->
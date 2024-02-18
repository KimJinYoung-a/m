<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
'### 주인을 찾습니다.
'### 2015-04-23 원승현
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
	Dim eCode, vDisp, sqlstr
	Dim nowdate
	Dim LoginUserid, DayName, pdName1, pdName2, pdName3, pdName4, evtItemCode1, evtItemCode2, evtItemCode3, evtItemCode4, evtItemCnt1, evtItemCnt2, evtItemCnt3, evtItemCnt4
	Dim isEvtSoldOut1, isEvtSoldOut2, isEvtSoldOut3, isEvtSoldOut4, result1, result2, result3

	isEvtSoldOut1 = False
	isEvtSoldOut2 = False
	isEvtSoldOut3 = False
	isEvtSoldOut4 = False

	nowdate = now()
'	nowdate = "2015-04-27 10:00:00"

	LoginUserid = getLoginUserid()

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  61762
	Else
		eCode   =  61736
	End If

	Select Case Left(nowdate, 10)
		Case "2015-04-27"
			DayName = "mon"

			pdName1 = "애플 아이패드 미니3 16GB"
			evtItemCode1 = "1182605"
			evtItemCnt1 = "1"

			pdName2 = "단보 보조배터리(랜덤)"
			evtItemCode2 = "1190691"
			evtItemCnt2 = 50

			pdName3 = "울랄라 CANVAS POUCH(랜덤)"
			evtItemCode3 = "1060478"
			evtItemCnt3 = 100

			pdName4 = "스누피시리즈(랜덤)"
			evtItemCode4 = "1137825"
			evtItemCnt4 = 300

		Case "2015-04-28"
			DayName = "tue"

			pdName1 = "애플 아이패드 미니3 16GB"
			evtItemCode1 = "1182605"
			evtItemCnt1 = "1"

			pdName2 = "샤오미 5,000mAh"
			evtItemCode2 = "1234675"
			evtItemCnt2 = 138

			pdName3 = "무민 카드지갑"
			evtItemCode3 = "1239727"
			evtItemCnt3 = 396

			pdName4 = "아이스바 비누(컬러랜덤)"
			evtItemCode4 = "914161"
			evtItemCnt4 = 197

		Case "2015-04-29"
			DayName = "wed"

			pdName1 = "애플 아이패드 미니3 16GB"
			evtItemCode1 = "1182605"
			evtItemCnt1 = "1"

			pdName2 = "엄브렐러 보틀"
			evtItemCode2 = "1171539"
			evtItemCnt2 = 85

			pdName3 = "아이리버 이어마이크(컬러 랜덤)"
			evtItemCode3 = "1234645"
			evtItemCnt3 = 120

			pdName4 = "무민 마스코트 피규어(랜덤)"
			evtItemCode4 = "1229782"
			evtItemCnt4 = 250

		Case "2015-04-30"
			DayName = "thu"

			pdName1 = "애플 아이패드 미니3 16GB"
			evtItemCode1 = "1182605"
			evtItemCnt1 = "1"

			pdName2 = "비밀의 정원"
			evtItemCode2 = "1234646"
			evtItemCnt2 = 29

			pdName3 = "Card case(랜덤)"
			evtItemCode3 = "1146210"
			evtItemCnt3 = 66

			pdName4 = "Monotask 한달 플래너(랜덤)"
			evtItemCode4 = "1193295"
			evtItemCnt4 = 336

		Case "2015-05-01"
			DayName = "fri"

			pdName1 = "애플 아이패드 미니3 16GB"
			evtItemCode1 = "1182605"
			evtItemCnt1 = "1"

			pdName2 = "무민 원형접시(2size)"
			evtItemCode2 = "1181799"
			evtItemCnt2 = 49

			pdName3 = "캡슐 태엽 토이(랜덤)"
			evtItemCode3 = "1202920"
			evtItemCnt3 = 90

			pdName4 = "야광 달빛스티커 GRAY (small)"
			evtItemCode4 = "1234674"
			evtItemCnt4 = 193

	End Select

	'// 일자별 상품 재고파악
	sqlstr = " Select sub_opt2, count(*) as cnt From db_event.dbo.tbl_event_subscript "
	sqlstr = sqlstr & " Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' And sub_opt2 <> 0 "
	sqlstr = sqlstr & " group by sub_opt2 "
	rsget.Open sqlstr, dbget, 1
	If Not(rsget.bof Or rsget.eof) Then
		Do Until rsget.eof
			If Trim(rsget("sub_opt2")) = Trim(evtItemCode1) Then
				If rsget("cnt") > 0 Then
					isEvtSoldOut1 = True '// 아이패드 재고파악
				End If
			ElseIf Trim(rsget("sub_opt2")) = Trim(evtItemCode2) Then
				If rsget("cnt") >= evtItemCnt2 Then
					isEvtSoldOut2 = True '// 일자별 두번재 상품 재고파악
				End If
			ElseIf Trim(rsget("sub_opt2")) = Trim(evtItemCode3) Then
				If rsget("cnt") >= evtItemCnt3 Then
					isEvtSoldOut3 = True '// 일자별 세번재 상품 재고파악
				End If
			ElseIf Trim(rsget("sub_opt2")) = Trim(evtItemCode4) Then
				If rsget("cnt") >= evtItemCnt4 Then
					isEvtSoldOut4 = True '// 일자별 네번재 상품 재고파악
				End If
			End If
		rsget.movenext
		Loop
	End If
	rsget.close

	'// 응모내역 검색
	sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
	rsget.Open sqlstr, dbget, 1
	If Not(rsget.bof Or rsget.Eof) Then
		'// 기존에 응모 했을때 값
		result1 = rsget(0) '//응모회수 1,2
		result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
		result3 = rsget(2) '//카카오2차 응모 확인용 null , kakao
	Else
		'// 최초응모
		result1 = ""
		result2 = ""
		result3 = ""
	End IF
	rsget.close

%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
button {background-color:transparent;}
.mEvt61736 .topic {position:relative;}
.mEvt61736 .topic p {visibility:hidden; width:0; height:0;}
.mEvt61736 .topic .lens {position:absolute; top:46%; right:3.5%; width:14%;}
.todayitem {padding-bottom:4%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/61736/bg_paper.png) repeat-y 50% 0; background-size:100% auto;}
.todayitem ul {overflow:hidden; padding:0 1%;}
.todayitem ul li {float:left;  width:50%; padding:0.7%;}
.todayitem ul li > div {position:relative;}
/*.todayitem ul li button {width:100%; border:0; background-color:transparent; vertical-align:top;}*/
.todayitem ul li .soldout {display:none; position:absolute; top:0; left:0; width:100%;}

.lyKeypad {display:none; position:absolute; top:2.5%; left:50%; z-index:250; width:94%; margin-left:-47%; background-color:#293e56;}
.keypad {position:relative; margin:2%; padding:8% 0 7%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/61736/bg_dart.png) no-repeat 50% 0; background-size:100% auto;}
.keypad {-webkit-box-shadow: 0px 0px 5px 0px rgba(28,43,62,1);
-moz-box-shadow: 0px 0px 5px 0px rgba(28,43,62,1);
box-shadow: 0px 0px 5px 0px rgba(28,43,62,1);}
.field {margin:6% 5%; padding-top:3%; border:3px solid #93aac6; background:#fff url(http://webimage.10x10.co.kr/eventIMG/2015/61736/bg_graph.png) repeat-y 50% 0; background-size:100% auto;}
#nmTyping1,  #nmTyping2, #nmTyping3, #nmTyping4 {display:block; height:60px; margin:5px auto 6%; padding-left:15px; border-bottom:3px solid #9cb2cc; color:#29415d; font-size:48px; text-align:center; letter-spacing:20px;}
.case1 #nmTyping1 {width:205px;}
.case2 #nmTyping2 {width:151px;}
.case3 #nmTyping3 {width:100px;}
.case4 #nmTyping4 {width:100px;}
.star {background:url(http://webimage.10x10.co.kr/eventIMG/2015/61736/bg_star.png) repeat-x 0 0; background-size:50px auto;}
.keypad .key {overflow:hidden; width:273px; margin:0 auto;}
.keypad .key button {float:left; width:85px; height:85px; margin:0 3px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/61736/bg_keypad.png) no-repeat 0 0; background-size:765px auto; text-indent:-999em; outline:none;}
.keypad .key .num1 {background-position:0 0;}
.keypad .key .num1:active {background-position:0 100%;}
.keypad .key .num2 {background-position:-85px 0;}
.keypad .key .num2:active {background-position:-85px 100%;}
.keypad .key .num3 {background-position:-170px 0;}
.keypad .key .num3:active {background-position:-170px 100%;}
.keypad .key .num4 {background-position:-255px 0;}
.keypad .key .num4:active {background-position:-255px 100%;}
.keypad .key .num5 {background-position:-340px 0;}
.keypad .key .num5:active {background-position:-340px 100%;}
.keypad .key .num6 {background-position:-425px 0;}
.keypad .key .num6:active {background-position:-425px 100%;}
.keypad .key .num7 {background-position:-510px 0;}
.keypad .key .num7:active {background-position:-510px 100%;}
.keypad .key .num8 {background-position:-595px 0;}
.keypad .key .num8:active {background-position:-595px 100%;}
.keypad .key .num9 {background-position:100% 0;}
.keypad .key .num9:active {background-position:100% 100%;}
.keypad .btnclose {position:absolute; top:-5%; right:-2.5%; width:44px;}
.keypad .btncheck {display:block; width:220px; margin:7% auto 0;}

.lyWin {display:none; position:absolute; top:2.5%; left:50%; z-index:250; width:94%; margin-left:-47%;}
.lyWin .btnconfirm {position:absolute; bottom:7.5%; left:50%; width:64%; margin-left:-32%;}
.lyLose {display:none; position:absolute; top:2.5%; left:50%; z-index:250; width:90%; margin-left:-45%;}
.lyLose .btnclose {position:absolute; top:5%; right:10%; width:15%;}

.mask {display:none; position:absolute; top:0; left:0; z-index:200; width:100%; height:100%; background:rgba(0,0,0,.7);}

.noti {padding:20px 10px;}
.noti h2 {color:#222; font-size:14px;}
.noti h2 strong {padding-bottom:2px; border-bottom:2px solid #000;}
.noti ul {margin-top:13px;}
.noti ul li {position:relative; padding-left:10px; color:#444; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:8px; left:0; width:4px; height:1px; background-color:#444;}
@media all and (min-width:480px){
	.noti {padding:25px 15px;}
	.noti ul {margin-top:16px;}
	.noti h2 {font-size:17px;}
	.noti ul li {margin-top:2px; font-size:13px;}
	.noti ul li:after {top:8px;}
}
@media all and (min-width:768px){
	.noti h2 {font-size:20px;}
	.noti ul {margin-top:20px;}
	.noti ul li {margin-top:4px; font-size:16px;}
	.noti ul li:after {top:12px;}
}

.animated {
	-webkit-animation-duration:3s;
	animation-duration:3s; 
	-webkit-animation-fill-mode:both;
	animation-fill-mode:both;
	-webkit-animation-iteration-count:3;
	animation-iteration-count:3;
}
/* Pulse Animation */
@-webkit-keyframes pulse {
	0% {-webkit-transform: scale(1);}
	50% {-webkit-transform: scale(1.1);}
	100% {-webkit-transform: scale(1);}
} 
@keyframes pulse {
	0% {transform:scale(1);}
	50% {transform:scale(1.1);}
	100% {transform:scale(1);}
}
.pulse {
	-webkit-animation-name:pulse;
	animation-name:pulse;
}
</style>
<script type="text/javascript">
$(function() {
	/* layer */
	$(".todayitem ul li:nth-child(1) .btnchallenge").click(function(){
		$("#lyKeypad1").show();
		$(".mask").show();
	});

	$(".todayitem ul li:nth-child(2) .btnchallenge").click(function(){
		$("#lyKeypad2").show();
		$(".mask").show();
	});

	$(".todayitem ul li:nth-child(3) .btnchallenge").click(function(){
		$("#lyKeypad3").show();
		$(".mask").show();
	});

	$(".todayitem ul li:nth-child(4) .btnchallenge").click(function(){
		$("#lyKeypad4").show();
		$(".mask").show();
	});
	
	$(".mask, .lyKeypad .btnclose").click(function(){
		$(".lyKeypad").hide();
		$(".mask").hide();
	});

	/* keypad */
	$(".case1 .key button").click(function(){
		$(this).addClass("on");
		$("#nmTyping1 ").removeClass("star");
	});
	$(".case2 .key button").click(function(){
		$(this).addClass("on");
		$("#nmTyping2 ").removeClass("star");
	});
	$(".case3 .key button").click(function(){
		$(this).addClass("on");
		$("#nmTyping3 ").removeClass("star");
	});
	$(".case4 .key button").click(function(){
		$(this).addClass("on");
		$("#nmTyping4 ").removeClass("star");
	});
	
});

function goTypeNm(cs, nm) {

	if  (cs=="case1")
	{
		if ($(".case1 #nmTyping1").text().length> 3) {
			alert("암호 4자리를 다 입력하셨습니다.");
			//$(".key button").removeClass("on");
			//$(".key button").unbind();
			return false;
		}
		$("#nmTyping1").append(nm);
	}

	if (cs=="case2")
	{
		if ($(".case2 #nmTyping2").text().length> 2) {
			alert("암호 3자리를 다 입력하셨습니다.");
			//$(".key button").removeClass("on");
			//$(".key button").unbind();
			return false;
		}
		$("#nmTyping2").append(nm);
	}

	if (cs=="case3")
	{
		if ($(".case3 #nmTyping3").text().length> 1) {
			alert("암호 2자리를 다 입력하셨습니다.");
			//$(".key button").removeClass("on");
			//$(".key button").unbind();
			return false;
		}
		$("#nmTyping3").append(nm);
	}

	if (cs=="case4")
	{
		if ($(".case4 #nmTyping4").text().length> 1) {
			alert("암호 2자리를 다 입력하셨습니다.");
			//$(".key button").removeClass("on");
			//$(".key button").unbind();
			return false;
		}
		$("#nmTyping4").append(nm);
	}

}


function fnClosemask()
{
	$('.lyWin').hide();
	$('.lyLose').hide();
	$('.mask').hide();
	$("#rtp").empty();
	document.location.reload();
}

function goLostFound(did)
{

	if (did=="nmTyping1")
	{
		if ($(".case1 #nmTyping1").text().length< 4) {
			alert("암호 4자리를 입력해주세요.");
			return false;
		}
		else
		{
			$("#euserInputCode").val($("#nmTyping1").text());
			$("#mode").val("CaseFir");
			$("#lyKeypad1").hide();
			$("#nmTyping1").empty();
		}
	}

	if (did=="nmTyping2")
	{
		if ($(".case2 #nmTyping2").text().length< 3) {
			alert("암호 3자리를 입력해주세요.");
			return false;
		}
		else
		{
			$("#euserInputCode").val($("#nmTyping2").text());
			$("#mode").val("CaseSec");
			$("#lyKeypad2").hide();
			$("#nmTyping2").empty();
		}
	}

	if (did=="nmTyping3")
	{
		if ($(".case3 #nmTyping3").text().length< 2) {
			alert("암호 2자리를 입력해주세요.");
			return false;
		}
		else
		{
			$("#euserInputCode").val($("#nmTyping3").text());
			$("#mode").val("CaseThr");
			$("#lyKeypad3").hide();
			$("#nmTyping3").empty();
		}
	}

	if (did=="nmTyping4")
	{
		if ($(".case4 #nmTyping4").text().length< 2) {
			alert("암호 2자리를 입력해주세요.");
			return false;
		}
		else
		{
			$("#euserInputCode").val($("#nmTyping4").text());
			$("#mode").val("Casefou");
			$("#lyKeypad4").hide();
			$("#nmTyping4").empty();
		}
	}

	$.ajax({
		type:"POST",
		url:"doEventSubscript61736.asp",
        data: $("#frmEvt").serialize(),
        dataType: "text",
		async:false,
		cache:true,
		success : function(Data, textStatus, jqXHR){
			if (jqXHR.readyState == 4) {
				if (jqXHR.status == 200) {
					if(Data!="") {
						var str;
						for(var i in Data)
						{
							 if(Data.hasOwnProperty(i))
							{
								str += Data[i];
							}
						}
						str = str.replace("undefined","");
						res = str.split("|");
						if (res[0]=="OK")
						{
							$("#rtp").empty().html(res[1]);
						}
						else
						{
							errorMsg = res[1].replace(">?n", "\n");
							alert(errorMsg );
							$(".mask").hide();
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
			document.location.reload();
			return false;
		}
	});
}


<%'카카오 친구 초대(재도전용)%>
function kakaosendcall(){
	<% If IsUserLoginOK Then %>
		<% If left(nowdate,10)>="2015-04-27" and left(nowdate,10)<"2015-05-02" Then %>
			var rstStr = $.ajax({
				type: "POST",
				url: "doEventSubscript61736.asp",
				data: "mode=kakao",
				dataType: "text",
				async: false
			}).responseText;
			if (rstStr == "SUCCESS"){
				// success
				parent.parent_kakaolink('[텐바이텐] 주인을 찾습니다!\n주인을 잃은 매력적인 분실물들이\n당신을 기다립니다.\n누구보다 빠르게 암호를 맞추면,\n분실물의 주인공이 될 수 있어요!' , 'http://webimage.10x10.co.kr/eventIMG/2015/61736/kakao-banner.jpg' , '200' , '200' , 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= eCode %>' );
				return false;
			}else if (rstStr == "FAIL"){
				// fail
				alert('카카오톡 실패 관리자에게 문의 하세요');
				return false;
			}else if (rstStr == "END"){
				alert('오늘의 도전을 모두 했어요!\n내일 다시 도전해 주세요!');
				return false;
			}else if (rstStr == "NOT1"){
				alert('암호 맞추기를 먼저 하고 친구에게 알려주세요.');
				return false;
			}else if (rstStr == "NOT2"){
				alert('오늘의 도전을 모두 했어요!\n내일 다시 도전해 주세요!');
				return false;
			}else if (rstStr == "complete"){
				alert('이미 도전 성공하셨네요!\n내일 다시 도전해 주세요!');
				return false;
			}else if (rstStr == "Err|잘못된 접속입니다."){
				alert('잘못된 접속입니다.');
				return false;
			}else if (rstStr == "Err|이벤트 응모 기간이 아닙니다."){
				alert('이벤트 응모 기간이 아닙니다.');
				return false;
			}else if (rstStr == "Err|오전 10시부터 응모하실 수 있습니다."){
				alert('오전 10시부터 응모하실 수 있습니다.');
				return false;
			}else if (rstStr == "Err|로그인 후 참여하실 수 있습니다."){
				alert('로그인 후 참여하실 수 있습니다.');
				return false;
			}else if (rstStr == "Err|스태프는 참여하실 수 없습니다."){
				alert('스태프는 참여하실 수 없습니다.');
				return false;
			}
		<% else %>
			alert("이벤트 기간이 아닙니다.");
			return;
		<% end if %>
	<% Else %>
		parent.calllogin();
		return;
	<% End If %>
}

</script>
</head>
<body>
<!-- 이벤트 배너 등록 영역 -->
<div class="evtCont">
	<!-- iframe -->
	<div class="mEvt61736">
		<div class="topic">
			<h1><img src="http://webimage.10x10.co.kr/eventIMG/2015/61736/tit_find.png" alt="본격 리얼 맞춤형 이벤트 주인을 찾습니다" /></h1>
			<p>암호를 맞추고 분실물의 주인공이 되세요! 이벤트 기간은 4월 27일부터 5월 1일까지며 매일 오전 10시에 오픈합니다.</p>
		</div>

		<div class="todayitem">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_today.png" alt="오늘의 분실물 상품의 암호를 먼저 맞추신 분에게 해당 상품을 드립니다!" /></p>
			<ul>
				<li>
					<div>
						<a href="" <%=chkIIF(isApp,"onclick=""parent.fnAPPpopupProduct('"&evtItemCode1&"');return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/61736/img_item_<%=DayName%>2_01.jpg" alt="<%=pdName1%> <%=evtItemCnt1%>대 난이도 별 4개" /></a>

						<% If Not(TimeSerial(Hour(nowdate), minute(nowdate), second(nowdate)) >= TimeSerial(10, 00, 00) And TimeSerial(Hour(nowdate), minute(nowdate), second(nowdate)) < TimeSerial(23, 59, 59)) Then %>
							<a href="" onclick="	alert('오전 10시부터 응모하실 수 있습니다.');return false;" >
						<% ElseIf result1 >= "2" Then %>
							<a href="" onclick="	alert('오늘의 도전을 모두 했어요!\n내일 다시 도전해 주세요!');return false;" >
						<% ElseIf result2 > "0" Then %>
							<a href="" onclick="alert('이미 도전 성공하셨네요!\n내일 다시 도전해 주세요!');return false;"  >
						<% Else %>
							<a href="#lyKeypad1" class="btnchallenge">
						<% End If %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_challenge.png" alt="도전하기" />
						</a>
						<%' for dev msg : 솔드아웃일 경우 보여주세요 style="display:block;" %>
						<% If isEvtSoldOut1 Then %>
							<span class="soldout" style="display:block;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_sold_out.png" alt="솔드아웃" /></span>
						<% End If %>
					</div>
				</li>
				<li>
					<div>
						<% If Left(nowdate, 10)>="2015-05-01" Then %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2015/61736/img_item_<%=DayName%>2_02.jpg" alt="<%=pdName2%> <%=evtItemCnt2%>개 난이도 별 3개" />
						<% Else %>
							<a href="" <%=chkIIF(isApp,"onclick=""parent.fnAPPpopupProduct('"&evtItemCode2&"');return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/61736/img_item_<%=DayName%>2_02.jpg" alt="<%=pdName2%> <%=evtItemCnt2%>개 난이도 별 3개" /></a>
						<% End If %>
						<% If Not(TimeSerial(Hour(nowdate), minute(nowdate), second(nowdate)) >= TimeSerial(10, 00, 00) And TimeSerial(Hour(nowdate), minute(nowdate), second(nowdate)) < TimeSerial(23, 59, 59)) Then %>
							<a href="" onclick="	alert('오전 10시부터 응모하실 수 있습니다.');return false;" >
						<% ElseIf result1 >= "2" Then %>
							<a href="" onclick="	alert('오늘의 도전을 모두 했어요!\n내일 다시 도전해 주세요!');return false;" >
						<% ElseIf result2 > "0" Then %>
							<a href="" onclick="alert('이미 도전 성공하셨네요!\n내일 다시 도전해 주세요!');return false;"  >
						<% Else %>						
							<a href="#lyKeypad2" class="btnchallenge">
						<% End If %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_challenge.png" alt="도전하기" />
						</a>
						<% If isEvtSoldOut2 Then %>
							<span class="soldout" style="display:block;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_sold_out.png" alt="솔드아웃" /></span>
						<% End If %>
					</div>
				</li>
				<li>
					<div>
						<a href="" <%=chkIIF(isApp,"onclick=""parent.fnAPPpopupProduct('"&evtItemCode3&"');return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/61736/img_item_<%=DayName%>2_03.jpg" alt="<%=pdName3%> <%=evtItemCnt3%>개 난이도 별 2개" /></a>
						<% If Not(TimeSerial(Hour(nowdate), minute(nowdate), second(nowdate)) >= TimeSerial(10, 00, 00) And TimeSerial(Hour(nowdate), minute(nowdate), second(nowdate)) < TimeSerial(23, 59, 59)) Then %>
							<a href="" onclick="	alert('오전 10시부터 응모하실 수 있습니다.');return false;" >
						<% ElseIf result1 >= "2" Then %>
							<a href="" onclick="	alert('오늘의 도전을 모두 했어요!\n내일 다시 도전해 주세요!');return false;" >
						<% ElseIf result2 > "0" Then %>
							<a href="" onclick="alert('이미 도전 성공하셨네요!\n내일 다시 도전해 주세요!');return false;"  >
						<% Else %>
							<a href="#lyKeypad3" class="btnchallenge">
						<% End If %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_challenge.png" alt="도전하기" />
						</a>
						<% If isEvtSoldOut3 Then %>
							<span class="soldout" style="display:block;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_sold_out.png" alt="솔드아웃" /></span>
						<% End If %>
					</div>
				</li>
				<li>
					<div>
						<a href="" <%=chkIIF(isApp,"onclick=""parent.fnAPPpopupProduct('"&evtItemCode4&"');return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/61736/img_item_<%=DayName%>2_04.jpg" alt="<%=pdName4%> <%=evtItemCnt4%>개 난이도 별 2개" /></a>
						<% If Not(TimeSerial(Hour(nowdate), minute(nowdate), second(nowdate)) >= TimeSerial(10, 00, 00) And TimeSerial(Hour(nowdate), minute(nowdate), second(nowdate)) < TimeSerial(23, 59, 59)) Then %>
							<a href="" onclick="	alert('오전 10시부터 응모하실 수 있습니다.');return false;" >
						<% ElseIf result1 >= "2" Then %>
							<a href="" onclick="	alert('오늘의 도전을 모두 했어요!\n내일 다시 도전해 주세요!');return false;" >
						<% ElseIf result2 > "0" Then %>
							<a href="" onclick="alert('이미 도전 성공하셨네요!\n내일 다시 도전해 주세요!');return false;"  >
						<% Else %>
							<a href="#lyKeypad4" class="btnchallenge">
						<% End If %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_challenge.png" alt="도전하기" />
						</a>
						<% If isEvtSoldOut4 Then %>
							<span class="soldout" style="display:block;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_sold_out.png" alt="솔드아웃" /></span>
						<% End If %>
					</div>
				</li>
			</ul>
		</div>

		<%' for dev msg : case1 %>
		<div id="lyKeypad1" class="lyKeypad">
			<div class="keypad">
				<div id="case1" class="case1">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_pw.png" alt="분실물 암호 입력 한번 선택한 숫자는 변경하실 수 없습니다." /></p>
					<div class="field">
						<strong id="nmTyping1" class="star"></strong>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_level_03.png" alt="난이도 별4개 암호 4자리를 입력해 주세요!" /></p>
					</div>
					<div class="key">
						<button type="button" class="num1" onclick="goTypeNm('case1',1);">1</button>
						<button type="button" class="num2" onclick="goTypeNm('case1',2);">2</button>
						<button type="button" class="num3" onclick="goTypeNm('case1',3);">3</button>
						<button type="button" class="num4" onclick="goTypeNm('case1',4);">4</button>
						<button type="button" class="num5" onclick="goTypeNm('case1',5);">5</button>
						<button type="button" class="num6" onclick="goTypeNm('case1',6);">6</button>
						<button type="button" class="num7" onclick="goTypeNm('case1',7);">7</button>
						<button type="button" class="num8" onclick="goTypeNm('case1',8);">8</button>
						<button type="button" class="num9" onclick="goTypeNm('case1',9);">9</button>
					</div>
					<button type="button" class="btncheck" onclick="goLostFound('nmTyping1');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_confirm.png" alt="확인" /></button>
					<button type="button" class="btnclose"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_colse_01.png" alt="분실물 입력 레이어 팝업 닫기" /></button>
				</div>
			</div>
		</div>

		<%' for dev msg : case2 %>
		<div id="lyKeypad2" class="lyKeypad">
			<div class="keypad">			
				<div id="case2" class="case2">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_pw.png" alt="분실물 암호 입력 한번 선택한 숫자는 변경하실 수 없습니다." /></p>
					<div class="field">
						<strong id ="nmTyping2" class="star"></strong>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_level_02.png" alt="난이도 별3개 암호 3자리를 입력해 주세요!" /></p>
					</div>
					<div class="key">
						<button type="button" class="num1" onclick="goTypeNm('case2',1);">1</button>
						<button type="button" class="num2" onclick="goTypeNm('case2',2);">2</button>
						<button type="button" class="num3" onclick="goTypeNm('case2',3);">3</button>
						<button type="button" class="num4" onclick="goTypeNm('case2',4);">4</button>
						<button type="button" class="num5" onclick="goTypeNm('case2',5);">5</button>
						<button type="button" class="num6" onclick="goTypeNm('case2',6);">6</button>
					</div>
					<button type="button" class="btncheck" onclick="goLostFound('nmTyping2');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_confirm.png" alt="확인" /></button>
					<button type="button" class="btnclose"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_colse_01.png" alt="분실물 입력 레이어 팝업 닫기" /></button>
				</div>
			</div>
		</div>

		<%' for dev msg : case3 %>
		<div id="lyKeypad3" class="lyKeypad">
			<div class="keypad">			
				<div id="case3" class="case3">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_pw.png" alt="분실물 암호 입력 한번 선택한 숫자는 변경하실 수 없습니다." /></p>
					<div class="field">
						<strong id ="nmTyping3" class="star"></strong>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_level_01.png" alt="난이도 별2개 암호 2자리를 입력해 주세요!" /></p>
					</div>
					<div class="key">
						<button type="button" class="num1" onclick="goTypeNm('case3',1);">1</button>
						<button type="button" class="num2" onclick="goTypeNm('case3',2);">2</button>
						<button type="button" class="num3" onclick="goTypeNm('case3',3);">3</button>
					</div>
					<button type="button" class="btncheck" onclick="goLostFound('nmTyping3');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_confirm.png" alt="확인" /></button>
					<button type="button" class="btnclose"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_colse_01.png" alt="분실물 입력 레이어 팝업 닫기" /></button>
				</div>
			</div>
		</div>

		<%' for dev msg : case4 %>
		<div id="lyKeypad4" class="lyKeypad">
			<div class="keypad">			
				<div id="case4" class="case4">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_pw.png" alt="분실물 암호 입력 한번 선택한 숫자는 변경하실 수 없습니다." /></p>
					<div class="field">
						<strong id ="nmTyping4" class="star"></strong>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_level_01.png" alt="난이도 별2개 암호 2자리를 입력해 주세요!" /></p>
					</div>
					<div class="key">
						<button type="button" class="num1" onclick="goTypeNm('case4',1);">1</button>
						<button type="button" class="num2" onclick="goTypeNm('case4',2);">2</button>
						<button type="button" class="num3" onclick="goTypeNm('case4',3);">3</button>
					</div>
					<button type="button" class="btncheck" onclick="goLostFound('nmTyping4');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_confirm.png" alt="확인" /></button>
					<button type="button" class="btnclose"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_colse_01.png" alt="분실물 입력 레이어 팝업 닫기" /></button>
				</div>
			</div>
		</div>

		<%' for dev msg : 당첨 OR 꽝 팝업 그려지는곳 <div class="mask"></div> 보여주세요 %>
		<div id="rtp"></div>

		<div class="kakao">
			<a href="" onclick="kakaosendcall();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_kakao_talk.png" alt="한번 더 도전하기! 친구에게 이벤트를 알려주면, 도전기회가 한 번 더 생깁니다! 주인을 찾습니다 알려주기" /></a>
		</div>

		<div class="noti">
			<h2><strong>이벤트 주의사항</strong></h2>
			<ul>
				<li>본 이벤트는 텐바이텐 app에서만 참여 가능합니다.</li>
				<li><strong>이벤트의 정답은 아이디마다 다릅니다.</strong></li>
				<li>오늘의 분실물은 매일 다른 상품으로 새롭게 구성 됩니다 </li>
				<li>이벤트는 하루에 ID당 1회 응모만 가능하며, 친구 초대 시, 한 번 더 응모 기회가 주어집니다.</li>
				<li>이벤트의 모든 상품의 컬러는 랜덤으로 발송되며, 선택이 불가능합니다.</li>
				<li>5만원 이상의 상품을 받으신 분께는 세무신고를 위해 개인정보를 요청할 수 있습니다. 제세공과금은 텐바이텐 부담입니다.</li>
				<li>이벤트 당첨 된 상품은 익일 발송됩니다! 당첨자 확인 문자 이후 마이텐바이텐&gt;당첨안내&gt;배송지입력 부탁드립니다.</li>
				<li>5월 1일에 당첨된 상품은 주말 이후에 당첨자 확인 문자를 받아 보실 수 있습니다.</li>
			</ul>
		</div>
		<div class="mask"></div>
	</div>
	<!-- //iframe -->
</div>
<!--// 이벤트 배너 등록 영역 -->
<form method="post" name="frmEvt" id="frmEvt">
	<input type="hidden" name="euserInputCode" id="euserInputCode">
	<input type="hidden" name="mode" id="mode">
</form>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
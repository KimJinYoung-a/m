<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 10초의 기적
' History : 2015-02-05 원승현
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/web2014/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/wishCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/ItemOptionCls.asp" -->
<%

	If isApp < 1 Then
		response.write "<script>alert('정상적인 경로로 접근해 주시기 바랍니다.');return false;</script>"
		response.End
	End If

	Dim eCode '// 이벤트 코드
	Dim dateitemlimitcnt, sqlstr
	Dim vToDay, vMiracleDate, vMiraclePrice, vMiracleGiftItemId, LoginUserid, vMasterIdx
	Dim vNextMiracleDate, vNextMiraclePrice, vNextMiracleGiftItemId, vNextMasterIdx
	Dim vNextDay, vEvtStartdate, vEvtEnddate, vEvt_name, vEvt_regdate
	Dim vRandomVer, vResult1, vResult2, vResult3, lpi, PriceGubun, vMiraclePrice2, vNextMiraclePrice2, vMiraclePrice3, vNextMiraclePrice3, vMiraclePrice4, vNextMiraclePrice4

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  21466
	Else
		eCode   =  59261
	End If


	vToDay = left(Now(), 10) '// 오늘 날짜 값..
	'vToDay = "2015-02-09" '// 요건 테스트용
	vNextDay = DateAdd("d", 1, vToDay) '// NEXT10초박스를 위해.. 다만 2월17일 마지막날엔 NEXT 10초박스가 없으므로 안씀
	LoginUserid = getLoginUserid() '// 회원아이디
	lpi = 1 '// style값 순차번호등에 쓰임..


	Randomize()
	PriceGubun = Int((Rnd * 4) + 1)

	'// 이벤트 정보를 가져온다.
	sqlstr = " Select evt_name, evt_startdate, evt_enddate, evt_regdate From db_event.dbo.tbl_event Where evt_code='"&eCode&"' "
	rsget.Open sqlStr,dbget,1
	If Not(rsget.bof Or rsget.eof) Then
		vEvt_name = rsget("evt_name")
		vEvtStartdate = Left(rsget("evt_startdate"), 10)
		vEvtEnddate = Left(rsget("evt_enddate"), 10)
	Else
		vEvt_name = ""
		vEvtStartdate = ""
		vEvtEnddate = ""
	End If
	rsget.close


	'// 이벤트 참여여부를 가져온다.
	If IsUserLoginOK Then
		sqlstr = " Select sub_opt1, sub_opt2, sub_opt3 From db_event.dbo.tbl_event_subscript Where evt_code='"&eCode&"' And userid='"&LoginUserid&"' And convert(varchar(10), regdate, 120) = '"&vToDay&"' "
		rsget.Open sqlStr,dbget,1
		If Not(rsget.bof Or rsget.eof) Then
			vResult1 = rsget(0) '//응모회수 1,2
			vResult2 = rsget(1) '//당첨여부 0,1 
			vResult3 = rsget(2) '//카카오2차 응모 확인용 null , kakao
		Else
			vResult1 = "0"
			vResult2 = "0"
			vResult3 = ""
		End If
		rsget.close
	End If


	'// 날짜값을 기준으로 메인정보를 가져온다.
	sqlstr = " Select idx, miracledate, miracleprice, miraclegiftitemid, regdate, miracleprice2, miracleprice3, miracleprice4 " &_
				 " From db_temp.dbo.tbl_MiracleOf10sec_Master " &_
				" Where convert(varchar(10), miracledate, 120) = '"&vToDay&"' "
	rsget.Open sqlStr,dbget,1
	If Not(rsget.bof Or rsget.eof) Then
		vMasterIdx = rsget("idx")
		vMiracleDate = Left(rsget("miracledate"), 10)
		vMiraclePrice = CLng(getNumeric(rsget("miracleprice")))
		vMiraclePrice2 = CLng(getNumeric(rsget("miracleprice2")))
		vMiraclePrice3 = CLng(getNumeric(rsget("miracleprice3")))
		vMiraclePrice4 = CLng(getNumeric(rsget("miracleprice4")))		
		vMiracleGiftItemId = CLng(getNumeric(rsget("miraclegiftitemid")))
	Else
		Call Alert_AppClose("이벤트 기간이 아닙니다.")
		response.write "<script>parent.location.href='/apps/appcom/wish/web2014/shoppingtoday/shoppingchance_allevent.asp';</script>"
		response.End		
	End If
	rsget.close

	'// 날짜값을 기준으로 다음날 메인정보를 가져온다.
	sqlstr = " Select idx, miracledate, miracleprice, miraclegiftitemid, regdate, miracleprice2, miracleprice3, miracleprice4 " &_
				 " From db_temp.dbo.tbl_MiracleOf10sec_Master " &_
				" Where convert(varchar(10), miracledate, 120) = '"&vNextDay&"' "
	rsget.Open sqlStr,dbget,1
	If Not(rsget.bof Or rsget.eof) Then
		vNextMasterIdx = rsget("idx")
		vNextMiracleDate = Left(rsget("miracledate"), 10)
		vNextMiraclePrice = CLng(getNumeric(rsget("miracleprice")))
		vNextMiraclePrice2 = CLng(getNumeric(rsget("miracleprice2")))
		vNextMiraclePrice3 = CLng(getNumeric(rsget("miracleprice3")))
		vNextMiraclePrice4 = CLng(getNumeric(rsget("miracleprice4")))
		vNextMiracleGiftItemId = CLng(getNumeric(rsget("miraclegiftitemid")))
	Else
		vNextMasterIdx = ""
		vNextMiracleDate = ""
		vNextMiraclePrice = ""
		vNextMiracleGiftItemId = ""
	End If
	rsget.close

	'// 상품 제한수량 체크
	dateitemlimitcnt=getitemlimitcnt(vMiracleGiftItemId)
	'dateitemlimitcnt=1 '// 테스트용 오픈시 반드시 지워야함


	'// 최종 기적의 가격 확정..
	Select Case Trim(PriceGubun)
		Case "2"
			vMiraclePrice = vMiraclePrice2
		Case "3"
			vMiraclePrice = vMiraclePrice3
		Case "4"
			vMiraclePrice = vMiraclePrice4
		Case Else
			vMiraclePrice = vMiraclePrice
	End Select

%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<style type="text/css">
.mEvt59261 {position:relative; margin-bottom:-50px;}
.mEvt59261 img {vertical-align:top;}
.mEvt59261 .evtNoti {padding:27px 10px;}
.mEvt59261 .evtNoti dt {display:inline-block; padding:6px 10px 4px; font-size:14px; line-height:1; margin-bottom:14px; font-weight:bold; color:#222; border-radius:15px; background:#d4d8d8;}
.mEvt59261 .evtNoti li {position:relative; color:#444; font-size:11px; line-height:1.4; padding-left:9px;}
.mEvt59261 .evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:5px; width:4px; height:1px; background:#444;}
.mEvt59261 .evtNoti li strong {font-weight:normal; color:#dc0610;}

.tenSecondsMiracle .day0209,
.tenSecondsMiracle .day0212,
.tenSecondsMiracle .day0215 {background:url(http://webimage.10x10.co.kr/eventIMG/2015/59261/bg_dot_0209.gif) left top repeat-y;}
.tenSecondsMiracle .day0209 li a,
.tenSecondsMiracle .day0212 li a,
.tenSecondsMiracle .day0215 li a {background:#add2ee;}
.tenSecondsMiracle .day0209 li a span,
.tenSecondsMiracle .day0212 li a span,
.tenSecondsMiracle .day0215 li a span { background:#75adde;}
.tenSecondsMiracle .day0210,
.tenSecondsMiracle .day0213,
.tenSecondsMiracle .day0216 {background:url(http://webimage.10x10.co.kr/eventIMG/2015/59261/bg_dot_0210.gif) left top repeat-y;}
.tenSecondsMiracle .day0210 li a,
.tenSecondsMiracle .day0213 li a,
.tenSecondsMiracle .day0216 li a {background:#f8efba;}
.tenSecondsMiracle .day0210 li a span,
.tenSecondsMiracle .day0213 li a span,
.tenSecondsMiracle .day0216 li a span { background:#f1e088;}
.tenSecondsMiracle .day0211,
.tenSecondsMiracle .day0214,
.tenSecondsMiracle .day0217 {background:url(http://webimage.10x10.co.kr/eventIMG/2015/59261/bg_dot_0211.gif) left top repeat-y;}
.tenSecondsMiracle .day0211 li a,
.tenSecondsMiracle .day0214 li a,
.tenSecondsMiracle .day0217 li a {background:#c8cded;}
.tenSecondsMiracle .day0211 li a span,
.tenSecondsMiracle .day0214 li a span,
.tenSecondsMiracle .day0217 li a span { background:#9da5dc;}
.tenSecondsMiracle .todayBox {position:relative; padding:0 0 25px; background-size:100% auto;}
.tenSecondsMiracle .todayBox ul {overflow:hidden; padding:0 8px 10px;}
.tenSecondsMiracle .todayBox li {float:left; width:50%; text-align:center;}
.tenSecondsMiracle .todayBox li a {display:block; margin:1px; padding:8px 0;}
.tenSecondsMiracle .todayBox li a img {padding:0 10px;}
.tenSecondsMiracle .todayBox li a span {display:inline-block; vertical-align:top; font-size:10px; letter-spacing:-0.05em; margin:7px 2px 0; font-weight:bold; color:#383838; padding:3px 5px 1px; border-radius:8px; white-space:nowrap;}
.tenSecondsMiracle .goBtn {display:block; margin:0 auto;}
.tenSecondsMiracle .goMiracle {width:100%;}
.tenSecondsMiracle .goNext {width:50%; margin-top:20px;}
.finish {position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,.5); z-index:80;}
.finish p {padding-top:60%;}

/******* 레이어 ********/
.mask {display:none; position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,.5); z-index:30;}
.tenSecondsLayer {display:none; position:absolute; left:2%; top:0; width:96%; z-index:90; }
.tenSecondsLayer .layerCont {margin-top:10%;}
.tenSecondsLayer .closeLayer {position:absolute; right:-5px; top:1.5%; width:12.5%; cursor:pointer; z-index:95;}

/* 10초 도전 */
.startChallenge  .layerCont {background:#b9120c;}
.startChallenge .timer {overflow:hidden;}
.startChallenge .timer span {display:block; width:50%; float:left;}
.startChallenge .sum {position:relative;}
.startChallenge .sum input {display:block; position:absolute; bottom:17%; width:25%; height:36%; padding:0; font-size:16px; font-weight:bold; color:#000; text-align:center; z-index:40; border:0;}
.startChallenge .sum input.p01 {left:5.2%;}
.startChallenge .sum input.p02 {left:37.5%;}
.startChallenge .sum input.p03 {right:5.2%;}
.startChallenge .start {position:absolute; width:100%; height:100%; position:absolute; left:0; top:0; background:rgba(0,0,0,.5); z-index:65;}
.startChallenge .start a {display:block; position:absolute; left:29%; top:30%; width:42%;}
.startChallenge .todayPrice {position:relative;}
.startChallenge .todayPrice p {position:absolute; left:0; top:0;}

.startChallenge .selectItem {position:relative; margin:0 10px 14px; box-shadow:3px 2px 3px rgba(0,0,0,.3);}
.startChallenge .selectItem ul {position:relative; overflow:hidden; padding:5px;}
.startChallenge .selectItem .group01 {background:#4ac7cf;}
.startChallenge .selectItem .group02 {background:#4acf8e;}
.startChallenge .selectItem .group03 {background:#4a98cf;}
.startChallenge .selectItem ul.groupMask:before {content:' '; display:block; position:absolute; left:0; top:0; width:100%; height:100%; z-index:60;}
.startChallenge .selectItem .group01.groupMask:before {background:rgba(74,199,207,.6);}
.startChallenge .selectItem .group02.groupMask:before {background:rgba(74,207,142,.6);}
.startChallenge .selectItem .group03.groupMask:before {background:rgba(74,152,207,.6);}
.startChallenge .selectItem li {position:relative; float:left; width:50%; padding:5px;}
.startChallenge .selectItem li p {position:relative; padding:5px; cursor:pointer;}
.startChallenge .selectItem li .on {display:block; position:absolute; left:0; top:0; width:100%; height:100%; z-index:70; background:url(http://webimage.10x10.co.kr/eventIMG/2015/59261/ico_check.png) left top repeat; background-size:100% 100%;}
.startChallenge .selectItem .group01 li p {border:1px solid #159ba8; background:#3abac3;}
.startChallenge .selectItem .group02 li p {border:1px solid #26b16d; background:#3ac37b;}
.startChallenge .selectItem .group03 li p {border:1px solid #2d7bb2; background:#428fc9;}
.startChallenge .selectItem h4 {display:inline-block; position:absolute; left:50%; width:38px; margin-left:-19px; padding:6px 0 5px; color:#fff; text-align:center; font-size:12px; font-weight:bold; border-radius:15px; background:#333333; box-shadow:2px 2px 2px rgba(0,0,0,.3); z-index:55;}
.startChallenge .selectItem h4.select01 {top:15%;}
.startChallenge .selectItem h4.select02 {top:48%;}
.startChallenge .selectItem h4.select03 {top:82%;}

/* 응모결과 */
.viewResult {position:absolute; left:0; top:0; z-index:70;}
.viewResult a {display:block; position:absolute; left:17%; width:66%; height:12%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55406/blank.png) left top repeat; background-size:100% 100%; text-indent:-9999em;}
.viewResult .seccess a {bottom:12.5%; }
.viewResult .fail a {bottom:9%;}
.viewResult .timeover a {bottom:12.5%;}

/* NEXT 10초박스 */
.nextBox {background:url(http://webimage.10x10.co.kr/eventIMG/2015/59261/bg_dot.gif) left top repeat-y; background-size:100% auto;}
.nextBox ul {overflow:hidden; padding:0 8px 10px;}
.nextBox ul li {float:left; width:50%; }
.nextBox ul li p {margin:1px; padding:7px; border:1px solid #f3d585; background:#ffefc4;}
.viewNext {margin-top:60%;}

@media all and (min-width:480px){
	.mEvt59261 .evtNoti {padding:40px 15px;}
	.mEvt59261 .evtNoti dt {font-size:21px; padding:8px 15px 5px; margin-bottom:20px;}
	.mEvt59261 .evtNoti li {font-size:17px; padding-left:13px;}
	.mEvt59261 .evtNoti li:after {top:8px; width:6px; height:2px;}

	.tenSecondsMiracle .todayBox {padding:0 0 38px;}
	.tenSecondsMiracle .todayBox ul {padding:0 12px 15px;}
	.tenSecondsMiracle .todayBox li a {margin:2px; padding:12px 0;}
	.tenSecondsMiracle .todayBox li a img {padding:0 15px;}
	.tenSecondsMiracle .todayBox li a span {font-size:15px; margin:11px 3px 0; padding:4px 7px 2px; border-radius:12px;}
	.tenSecondsMiracle .goNext {margin-top:30px;}

	.finish {height:91.5%; background:rgba(0,0,0,.5);}

	/* 10초 도전 */
	.startChallenge .sum input {font-size:24px;}
	.startChallenge .selectItem { margin:0 15px 21px; box-shadow:4px 3px 4px rgba(0,0,0,.3);}
	.startChallenge .selectItem ul {padding:7px;}
	.startChallenge .selectItem li {padding:7px;}
	.startChallenge .selectItem li p {padding:7px;}
	.startChallenge .selectItem h4 {width:57px; margin-left:-29px; padding:9px 0 7px; font-size:18px; border-radius:23px; box-shadow:3px 3px 3px rgba(0,0,0,.3);}

	/* NEXT 10초박스 */
	.nextBox ul {padding:0 8px 10px;}
	.nextBox ul li p {margin:1px; padding:7px;}
}
</style>
<script type="text/javascript">
	var STimeOut;
	var STimeOut2;
$(function(){
	$(".goNext").click(function(){
		$(".viewNext").show();
		$(".mask").show();
	});
	$(".closeLayer").click(function(){
		$(".tenSecondsLayer").hide();
		$(".mask").hide();
	});
	$(".goMiracle").click(function(){
		go_bannerLog();
		<% If IsUserLoginOK Then %>
			<% If left(now(),10)>="2015-02-09" and left(now(),10)<"2015-02-18" Then %>
				<% if dateitemlimitcnt < 1 then %>
					alert("오늘 10초의 기적 상품은 모두 품절입니다.");
					return false;
				<% end if %>
				$(".startChallenge").show();
				$(".mask").show();
			<% else %>
				alert("이벤트 기간이 아닙니다.");
				return;
			<% end if %>
		<% Else %>
			parent.calllogin();
			return;
		<% End If %>			
	});

	<%' 10초 도전 start %>
	<%' 시작과 동시에 subscript에 값 집어넣는다. 비당첨값으로 %>
	$('.start a').click(function(){

		var rstStr = $.ajax({
			type: "POST",
			url: "/apps/appCom/wish/web2014/event/etc/doEventSubscript59261.asp",
			data: "mode=start&vMiracleGiftItemId=<%=vMiracleGiftItemId%>&vToday=<%=vToday%>",
			dataType: "text",
			async: false
		}).responseText;
		if (rstStr == "SUCCESS"){
			// success
			$(this).parent('.start').hide();
			$('.closeLayer').hide();
			$('.todayPrice p').hide();
			$('.group01').removeClass('groupMask');
			STimeOut = setTimeout('fnMiracleResult("N")','11500');
			$("#timerSec").attr("src","http://webimage.10x10.co.kr/eventIMG/2015/59261/img_timer_second02.gif?v=1.<%=vResult1%>");
			STimeOut2 = setTimeout('$("#timerMsec").attr("src","http://webimage.10x10.co.kr/eventIMG/2015/59261/img_timer_msecond02.gif")', "800");
			return false;
		}else if (rstStr == "END"){
			// end
			alert('오늘의 도전을 모두 했어요!\n내일 다시 도전해 주세요!');
			$(".startChallenge").hide();
			$(".mask").hide();
			return false;
		}else if (rstStr == "complete"){
			alert('이미 도전 성공하셨네요!\n내일 다시 도전해 주세요!');
			$(".startChallenge").hide();
			$(".mask").hide();
			return false;
		}else if (rstStr == "kakao"){
			// kakao
			alert('친구에게 10초의 기적을 알려주면,\n한 번 더! 응모 기회가 생겨요!');
			$(".startChallenge").hide();
			$(".mask").hide();
			return false;
		}else if (rstStr == "soldout"){
			// soldout
			alert('오늘 10초의 기적 상품은 모두 품절입니다.');
			parent.top.location.href='/apps/appcom/wish/web2014/event/eventmain.asp?eventid=<%=eCode%>';
			return false;
		}
	});
	
	<%' 아이템 선택 %>
	$('.selectItem li p').click(function(){
		$('<span class="on"></span>').insertBefore(this);
		$(this).parents('ul').addClass('groupMask');
		$(this).parents('ul').next('ul').removeClass('groupMask');
		if ($(this).attr("tvalue")=="1")
		{
			$("#UsrSelectPrice1").attr("value", $(this).attr("value"));
		}
		if ($(this).attr("tvalue")=="2")
		{
			$("#UsrSelectPrice2").attr("value", $(this).attr("value"));
		}
		if ($(this).attr("tvalue")=="3")
		{
			$("#UsrSelectPrice3").attr("value", $(this).attr("value"));
			fnMiracleResult("Y");
		}
	});

});

//left
function Left(Str, Num){
	if (Num <= 0)
		return "";
	else if (Num > String(Str).length)
		return Str;
	else
		return String(Str).substring(0,Num);
}

//right
function Right(Str, Num){
	if (Num <= 0)
		return "";
	else if (Num > String(Str).length)
		return Str;
	else
		var iLen = String(Str).length;
		return String(Str).substring(iLen, iLen-Num);
}

<%'// 응모 완료 된 후 호출%>
<%'// Y는 사용자가 선택완료하여 종료함수 호출한 경우, N은 시간이 지나서 종료함수 호출된 경우 %>
function fnMiracleResult(v)
{

	clearTimeout(STimeOut);
	clearTimeout(STimeOut2);
	$("#timerSec").attr("src","http://webimage.10x10.co.kr/eventIMG/2015/59261/img_timer_second03.gif");
	$("#timerMsec").attr("src","http://webimage.10x10.co.kr/eventIMG/2015/59261/img_timer_msecond01.gif");

	<%'// 사용자 선택 완료 %>
	if (v=="Y")
	{
		var userSelectTotalPrice;
		userSelectTotalPrice = Number($("#UsrSelectPrice1").attr("value"))+Number($("#UsrSelectPrice2").attr("value"))+Number($("#UsrSelectPrice3").attr("value"));
		if (userSelectTotalPrice==<%=vMiraclePrice%>)
		{
			<%'// 사용자 입력값이 오늘의 가격과 같을경우 %>
			var rstStr = $.ajax({
				type: "POST",
				url: "/apps/appCom/wish/web2014/event/etc/doEventSubscript59261.asp",
				data: "mode=winner&vMiracleGiftItemId=<%=vMiracleGiftItemId%>&vToday=<%=vToday%>&winchk=Y",
				dataType: "text",
				async: false
			}).responseText;
			if (rstStr == "error"){
				alert("죄송합니다. 오류가 발생하였습니다.\n관리자에게 문의해 주세요.");
				$(".startChallenge").hide();
				$(".mask").hide();
				return false;
			}else if (rstStr == "END"){
				// end
				alert('오늘의 도전을 모두 했어요!\n내일 다시 도전해 주세요!');
				$(".startChallenge").hide();
				$(".mask").hide();
				return false;
			}else if (rstStr == "complete"){
				alert('이미 도전 성공하셨네요!\n내일 다시 도전해 주세요!');
				$(".startChallenge").hide();
				$(".mask").hide();
				return false;
			}else if (rstStr == "SUCCESS"){
				$(".viewResult").show();
				$(".seccess").show();
				return false;
			}
		}
		else
		{
			<%'// 사용자 입력값이 오늘의 가격과 다를경우 %>
			$(".viewResult").show();
			$(".fail").show();
			return false;
		}
	}
	else
	{
		<%'// 시간초과일 경우 %>
		$(".viewResult").show();
		$(".timeover").show();
		return false;
	}

	return false;

}


//쿠폰Process
function get_coupon(){
	var rstStr = $.ajax({
		type: "POST",
		url: "/apps/appcom/wish/web2014/event/etc/doEventSubscript59261.asp",
		data: "mode=coupon&vMiracleGiftItemId=<%=vMiracleGiftItemId%>",
		dataType: "text",
		async: false
	}).responseText;
	if (rstStr == "SUCCESS"){
		alert('10초의 기적 <기적의 무료배송권> 쿠폰이 발급되었습니다.');
		parent.top.location.href='/apps/appcom/wish/web2014/event/eventmain.asp?eventid=<%=eCode%>';
		return false;
	}else{
		alert('관리자에게 문의');
		return false;
	}
}


<%'카카오 친구 초대(재도전용)%>
function kakaosendcall(){
	<% If IsUserLoginOK Then %>
		<% If left(now(),10)>="2015-02-09" and left(now(),10)<"2015-02-18" Then %>
			var rstStr = $.ajax({
				type: "POST",
				url: "/apps/appCom/wish/web2014/event/etc/doEventSubscript59261.asp",
				data: "mode=kakao&vMiracleGiftItemId=<%=vMiracleGiftItemId%>",
				dataType: "text",
				async: false
			}).responseText;
			if (rstStr == "SUCCESS"){
				// success
				parent.parent_kakaolink('[텐바이텐] 10초의 기적!\n2015년, 덧셈 얼마나 잘하세요?주어진 시간은 단, 10초!\n상품 3개를 더해 기적의 가격을 맞추면!배송비만 내고 10초박스가 찾아갑니다!\n오직, 텐바이텐 APP에서!' , 'http://webimage.10x10.co.kr/eventIMG/2015/59261/kakao-banner.jpg' , '200' , '200' , 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= eCode %>' );
				return false;
			}else if (rstStr == "FAIL"){
				// fail
				alert('카카오톡 실패 관리자에게 문의 하세요');
				return false;
			}else if (rstStr == "END"){
				alert('오늘의 도전을 모두 했어요!\n내일 다시 도전해 주세요!');
				return false;
			}else if (rstStr == "NOT1"){
				alert('기적에 도전하기를 먼저하고 친구에게 알려주세요.');
				return false;
			}else if (rstStr == "NOT2"){
				alert('오늘의 도전을 모두 했어요!\n내일 다시 도전해 주세요!');
				return false;
			}else if (rstStr == "complete"){
				alert('이미 도전 성공하셨네요!\n내일 다시 도전해 주세요!');
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

<%'카카오 친구 초대(걍초대용)%>
function kakaosendcall2(){
	<% If IsUserLoginOK Then %>
		<% If left(now(),10)>="2015-02-09" and left(now(),10)<"2015-02-18" Then %>
			var rstStr = $.ajax({
				type: "POST",
				url: "/apps/appCom/wish/web2014/event/etc/doEventSubscript59261.asp",
				data: "mode=kakao2&vMiracleGiftItemId=<%=vMiracleGiftItemId%>",
				dataType: "text",
				async: false
			}).responseText;
			if (rstStr == "SUCCESS"){
				// success
				parent.parent_kakaolink('[텐바이텐] 10초의 기적!\n2015년, 덧셈 얼마나 잘하세요?주어진 시간은 단, 10초!\n상품 3개를 더해 기적의 가격을 맞추면!배송비만 내고 10초박스가 찾아갑니다!\n오직, 텐바이텐 APP에서!' , 'http://webimage.10x10.co.kr/eventIMG/2015/59261/kakao-banner.jpg' , '200' , '200' , 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= eCode %>' );
				return false;
			}else if (rstStr == "FAIL"){
				// fail
				alert('카카오톡 실패 관리자에게 문의 하세요');
				return false;
			}else if (rstStr == "END"){
				alert('오늘의 도전을 모두 했어요!\n내일 다시 도전해 주세요!');
				return false;
			}else if (rstStr == "NOT1"){
				alert('기적에 도전하기를 먼저하고 친구에게 알려주세요.');
				return false;
			}else if (rstStr == "NOT2"){
				alert('오늘의 도전을 모두 했어요!\n내일 다시 도전해 주세요!');
				return false;
			}else if (rstStr == "complete"){
				alert('이미 도전 성공하셨네요!\n내일 다시 도전해 주세요!');
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


<%'// 기억에 도전하기 클릭 로그 %>
function go_bannerLog(){
	var rstStr = $.ajax({
		type: "POST",
		url: "/apps/appCom/wish/web2014/event/etc/doEventSubscript59261.asp",
		data: "mode=banner1&vMiracleGiftItemId=<%=vMiracleGiftItemId%>",
		dataType: "text",
		async: false
	}).responseText;
}

	$(".goNext").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top}, 500);
	});

</script>
</head>
<body>
<div class="evtCont">
	<!-- 10초의 기적(APP) -->
	<div class="mEvt59261">
		<!-- 오늘의 상품 -->
		<div class="tenSecondsMiracle">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/59261/img_miracle_<%=Mid(vToDay, 6, 2)&Right(vToday, 2)%>.gif" alt="10초의 기적" /><%' 날짜별로 이미지명 0209~0217 %></h2>
			<div class="todayBox day<%=Mid(vToDay, 6, 2)&Right(vToday, 2)%>"><%' 날짜별로 클래스 day0209~0217 넣어주세요 %>
				<ul>
					<%
						'// masteridx값을 기준으로 해당월에 맞는 상품을 가져온다.
						sqlstr = " Select idx, masteridx, itemid1, itemname1, itemprice1, itemid2, itemname2, itemprice2 " &_
									 " From db_temp.dbo.tbl_miracleof10sec_product " &_
									" Where masteridx='"&vMasterIdx&"' order by orderby "
						rsget.Open sqlStr,dbget,1
						If Not(rsget.bof Or rsget.eof) Then
							Do Until rsget.eof
					%>
							<li>
								<a href="" onclick="parent.fnAPPpopupProduct('<%=rsget("itemid1")%>'); return false;">
									<img src="http://webimage.10x10.co.kr/eventIMG/2015/59261/<%=rsget("itemid1")%>.jpg" alt="<%=rsget("itemname1")%>" />
									<span><%=rsget("itemname1")%></span>
								</a>
							</li>
							<li>
								<a href="" onclick="parent.fnAPPpopupProduct('<%=rsget("itemid2")%>'); return false;">
									<img src="http://webimage.10x10.co.kr/eventIMG/2015/59261/<%=rsget("itemid2")%>.jpg" alt="<%=rsget("itemname2")%>" />
									<span><%=rsget("itemname2")%></span>
								</a>
							</li>
					<%
							rsget.movenext
							Loop
						End If
						rsget.close
					%>
				</ul>

				<% If vResult1>=2 Then %>
					<a href="" onclick="	alert('오늘의 도전을 모두 했어요!\n내일 다시 도전해 주세요!');return false;" >
				<% ElseIf vResult2=1 Then  %>
					<a href="" onclick="alert('이미 도전 성공하셨네요!\n내일 다시 도전해 주세요!');return false;"  >
				<% Else %>
					<a href="#" class="goBtn goMiracle">
				<% End If %>
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/59261/btn_challenge.png" alt="기적에 도전하기" />
				</a>
				<% If Not(vToDay >= vEvtEnddate) Then %>
					<a href="#viewNext" class="goBtn goNext"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59261/btn_view_next02.png" alt="NEXT 10초박스" /></a>
				<% End If %>

				<%' 품절, 솔드아웃 %>
				<% If now() >= CDate(Left(Now(), 10)&" 00:00:00") And now() < CDate(Left(Now(), 10)&" 10:00:00") Then %>
					<%'0시~10시 커밍순%>
					<div class="finish">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59261/txt_comingsoon.png" alt="COMING SOON" /></p>
					</div>
				<% ElseIf (now() >= CDate(Left(Now(), 10)&" 10:00:00") And now() < CDate(Left(Now(), 10)&" 13:59:59") And dateitemlimitcnt< 1) Then %> 
					<%'10시 솔드아웃%>
					<div class="finish">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59261/txt_soldout01.png" alt="SOLD OUT - 오후 2시에 10초의 기적이 돌아옵니다" /></p>
					</div>
				<% ElseIf (now() >= CDate(Left(Now(), 10)&" 14:00:00") And now() < CDate(Left(Now(), 10)&" 17:59:59") And dateitemlimitcnt< 1) Then %>
					<%'2시 솔드아웃%>
					<div class="finish">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59261/txt_soldout02.png" alt="SOLD OUT - 오후 6시에 10초의 기적이 돌아옵니다" /></p>
					</div>
				<% ElseIf (now() >= CDate(Left(Now(), 10)&" 18:00:00") And now() < CDate(Left(Now(), 10)&" 23:59:59") And dateitemlimitcnt< 1) Then %>
					<%'6시 솔드아웃%>
					<div class="finish">
						<!--p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59261/txt_soldout03.png" alt="SOLD OUT - 내일 오전 10시에 10초의 기적이 돌아옵니다" /></p-->
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59261/txt_soldout05.png" alt="SOLD OUT 10초의 기적이 모두 끝났습니다. 매일 알람을 맞춰 놓고, 10초를 함께 해주셔서 감사합니다. 3월 9일, 또 다른 기적을 가지고 컴백하겠습니다. 새해 복 많이 받으세요!" /></p>
					</div>
				<% End If %>
				<%'// 품절, 솔드아웃 %>

			</div>
		</div>
		<!--// 오늘의 상품 -->

		<% If now() >= CDate(Left(Now(), 10)&" 18:00:00") Then %>
		<% Else %>
			<% If dateitemlimitcnt < 1 Then %>
				<p><a href="" onclick="kakaosendcall2();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59261/btn_invite_kakotalk_soldout.gif" alt="상품 가격을 맞추지 못했나요? 친구에게 10초의 기적을 알려주면, 응모 기회가 한번 더 생겨요! - 오늘의 기적을 알려주기" /></a></p>
			<% Else %>
				<p><a href="" onclick="kakaosendcall();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59261/btn_invite_kakotalk.gif" alt="상품 가격을 맞추지 못했나요? 친구에게 10초의 기적을 알려주면, 응모 기회가 한번 더 생겨요! - 오늘의 기적을 알려주기" /></a></p>
			<% End If %>
		<% End If %>

		<!-- 레이어팝업 (10초 도전) -->
		<div id="viewMiracle" class="tenSecondsLayer startChallenge">
			<div class="layerCont">
				<p class="closeLayer"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59261/btn_close.png" alt="닫기" /></p>
				<div class="timer">
					<p>
						<span><img src="http://webimage.10x10.co.kr/eventIMG/2015/59261/img_timer_second01.gif" id="timerSec" /></span>
						<span><img src="http://webimage.10x10.co.kr/eventIMG/2015/59261/img_timer_msecond01.gif" id="timerMsec" /></span>
					</p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59261/txt_select.gif" alt="박스컬러별로 상품 1개씩 총 3개를 선택하여 기적의 가격을 맞춰보세요!" /></p>
				</div>

				<div class="todayPrice">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59261/txt_hidden_price.gif" alt="" /></p>
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/59261/txt_today_price_<%=Mid(vToDay, 6, 2)&Right(vToday, 2)%><% If Trim(PriceGubun)="2" Then %>_2<% ElseIf Trim(PriceGubun)="3" Then %>_3<% ElseIf Trim(PriceGubun)="4" Then %>_4<% End If %>.gif" alt="기적의 가격" /><%' 날짜별로 이미지명 0209~0217 %>
				</div>
				<div class="miracleProduct">
					<div class="selectItem">
						<p class="start"><a href="#viewMiracle"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59261/btn_start.png" alt="START" /></a></p>

						<!-- 오늘의 상품 -->
						<h4 class="select01">선택1</h4>
						<h4 class="select02">선택2</h4>
						<h4 class="select03">선택3</h4>

						<%
							'// masteridx값을 기준으로 해당월에 맞는 상품을 가져온다.
							sqlstr = " Select idx, masteridx, itemid1, itemname1, itemprice1, itemid2, itemname2, itemprice2 " &_
										 " From db_temp.dbo.tbl_miracleof10sec_product " &_
										" Where masteridx='"&vMasterIdx&"' order by newid() "
							rsget.Open sqlStr,dbget,1
							If Not(rsget.bof Or rsget.eof) Then
								Do Until rsget.eof
						%>
									<ul class="groupMask group0<%=lpi%>">
										<li><p value="<%=rsget("itemprice1")%>" tvalue="<%=lpi%>"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59261/<%=rsget("itemid1")%>.jpg" alt="<%=rsget("itemname1")%>" /></p></li>
										<li><p value="<%=rsget("itemprice2")%>" tvalue="<%=lpi%>"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59261/<%=rsget("itemid2")%>.jpg" alt="<%=rsget("itemname2")%>" /></p></li>
									</ul>
						<%
								rsget.movenext
								lpi = lpi + 1
								Loop
							End If
							lpi = 0
							rsget.close

						%>
						<!--// 오늘의 상품 -->

						<!-- 응모 결과 -->
						<div class="viewResult" id="viewResult" style="display:none;">
							<!-- 당첨 -->
							<div class="seccess" style="display:none;">
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59261/img_success.gif" alt="오! 정답! 배송비만 내면, 오늘의 10초 박스 중 1개를 랜덤으로 받을 수 있어요!" /></p>
								<a href="" onclick="fnAPPpopupBaguni();return false;">10초박스 구매하기</a>
							</div>

							<!-- 비당첨 -->
							<div class="fail" style="display:none;">
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59261/img_fail.gif" alt="악! 이런 당첨되지 않았어요" /></p>
								<a href="" onclick="get_coupon();return false;">쿠폰 다운받기</a>
							</div>

							<!-- 타임오버 -->
							<div class="timeover" style="display:none;">
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59261/img_timeover.gif" alt="타임오버! 10초가 모두 지났어요!" /></p>
								<a href="" onclick="parent.top.location.href='/apps/appcom/wish/web2014/event/eventmain.asp?eventid=<%=eCode%>';return false;" class="goBuy">친구 초대하기</a>
							</div>
						</div>
						<!--// 응모 결과 -->

					</div>
					<div class="sum">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59261/txt_your_price.gif" alt="당신이 선택한 기적의 가격!" /></p>
						<input type="text" placeholder="?" class="p01" id="UsrSelectPrice1" readonly />
						<input type="text" placeholder="?" class="p02" id="UsrSelectPrice2" readonly />
						<input type="text" placeholder="?" class="p03" id="UsrSelectPrice3" readonly />
					</div>
				</div>
			</div>
		</div>
		<!--// 레이어팝업 (10초 도전) -->

		<!-- 레이어팝업 (다음 칭찬선물) -->
		<% If Not(vToDay >= vEvtEnddate) Then %>		
			<div id="viewNext" class="tenSecondsLayer viewNext">
				<div class="layerCont">
					<p class="closeLayer"><img src="http://webimage.10x10.co.kr/eventIMG/2015/59261/btn_close.png" alt="닫기" /></p>
					<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/59261/tit_next_box_.gif" alt="NEXT 10초박스" /></h3>
					<div class="nextBox">
						<ul>
							<%
								sqlstr = " Select idx, masteridx, itemid1, itemname1, itemprice1, itemid2, itemname2, itemprice2 " &_
											 " From db_temp.dbo.tbl_MiracleOf10sec_Product " &_
											" Where masteridx='"&vNextMasterIdx&"' order by orderby "
								rsget.Open sqlStr,dbget,1
								If Not(rsget.bof Or rsget.eof) Then
									Do Until rsget.eof
							%>
										<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59261/<%=rsget("itemid1")%>.jpg" alt="<%=rsget("itemname1")%>" /></p></li>
										<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59261/<%=rsget("itemid2")%>.jpg" alt="<%=rsget("itemname2")%>" /></p></li>
							<%
									rsget.movenext
									Loop
								End If
							%>
						</ul>
					</div>
				</div>
			</div>
		<% End If %>
		<!--// 레이어팝업 (다음 칭찬선물) -->

		
		<dl class="evtNoti">
			<dt>이벤트 주의사항</dt>
			<dd>
				<ul>
					<li>본 이벤트는 텐바이텐 app에서만 참여 가능합니다.</li>
					<li>10초의 기적은 <strong>하루에 ID당 1회 도전이 가능하며, 친구 초대 시, 한 번 더 도전할 수 있습니다. 단, 1회에 도전 성공 시, 다시 도전할 수 없습니다.</strong></li>
					<li>기적의 가격은 <strong>상품 3개의 판매가를 더해 만들어야 합니다.</strong>(할인가는 적용 안됨)</li>
					<li>기적의 가격은 매번 달라질 수 있습니다. 기적의 가격을 꼭 확인하세요.</li>
					<li>10초는 도전하기 클릭한 이후부터 카운팅 됩니다. 단, 단말기와 인터넷 상황에 따라 카운팅에 문제가 발생할 수 있습니다. WIFI나 통신이 원활한 곳에서 참여해주세요.</li>
					<li>개인 단말기 상태 혹은 인터넷 상황에 따른 불이익의 발생 시, 텐바이텐이 책임지지 않습니다.</li>
					<li>10초박스는 해당 일자의 상품들 중, 1개가 랜덤으로 담겨서 발송됩니다.</li>
					<li>10초박스는 즉시결제로만 구매가 가능하며, 배송 후 반품/교환/구매취소가 불가능합니다.</li>
					<li>10초박스의 모든 상품 컬러는 랜덤으로 발송되며, 선택이 불가능합니다.</li>
					<li>5만원 이상의 상품을 받으신 분께는 세무신고를 위해 개인정보를 요청할 수 있습니다. 제세공과금은 텐바이텐 부담입니다.</li>
					<li>무료배송 쿠폰은 ID당 하루에 최대 2회까지 발행되며, 발급 당일 자정 기준으로 자동 소멸됩니다(1만원 이상 구매 시, 사용 가능/텐바이텐 배송 상품에만 적용)</li>
					<li>1등 당첨 고객님과 전날 정답 상품은 하단에 있는 공지사항을 통해 확인 가능합니다.</li>
					<li>설 연휴로 인해 2월14일부터 2월 17일까지 구매한 10초 박스는 2월 23일에 순차적으로 발송됩니다.</li>
				</ul>
			</dd>
		</dl>
		
		<div class="mask"></div>
	</div>
	<!--// 10초의 기적(APP) -->
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
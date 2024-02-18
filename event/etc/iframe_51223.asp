<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  [텐바이텐x다노] 내 생에 가장 단호한 일주일
' History : 2014.04.17 유태욱 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/event51223Cls.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->

<%
dim eCode, userid, subscriptcount1day, tabno
dim dayscriptcount, day1scriptcount, day2scriptcount, day3scriptcount, day4scriptcount, day5scriptcount, day6scriptcount, day7scriptcount
dim ix, maxdayscriptcount, sumdayscriptcount
	eCode=getevt_code
	userid = getloginuserid()
	tabno = requestcheckvar(request("tabno"),1)

dayscriptcount=0 : maxdayscriptcount=1 : sumdayscriptcount=0
day1scriptcount=0 : day2scriptcount=0 : day3scriptcount=0 : day4scriptcount=0 : day5scriptcount=0 : day6scriptcount=0 : day7scriptcount=0

If IsUserLoginOK() Then
	dayscriptcount = getevent_subscriptexistscount(eCode, userid, getnowdate, "", "")		'해당날짜 참여 여부

	day1scriptcount = getevent_subscriptexistscount(eCode, userid, "", "1", "")
	day2scriptcount = getevent_subscriptexistscount(eCode, userid, "", "2", "")
	day3scriptcount = getevent_subscriptexistscount(eCode, userid, "", "3", "")
	day4scriptcount = getevent_subscriptexistscount(eCode, userid, "", "4", "")
	day5scriptcount = getevent_subscriptexistscount(eCode, userid, "", "5", "")
	day6scriptcount = getevent_subscriptexistscount(eCode, userid, "", "6", "")
	day7scriptcount = getevent_subscriptexistscount(eCode, userid, "", "7", "")
	
	if day1scriptcount<>0 then maxdayscriptcount=1 : sumdayscriptcount=sumdayscriptcount+1
	if day2scriptcount<>0 then maxdayscriptcount=2 : sumdayscriptcount=sumdayscriptcount+1
	if day3scriptcount<>0 then maxdayscriptcount=3 : sumdayscriptcount=sumdayscriptcount+1
	if day4scriptcount<>0 then maxdayscriptcount=4 : sumdayscriptcount=sumdayscriptcount+1
	if day5scriptcount<>0 then maxdayscriptcount=5 : sumdayscriptcount=sumdayscriptcount+1
	if day6scriptcount<>0 then maxdayscriptcount=6 : sumdayscriptcount=sumdayscriptcount+1
	if day7scriptcount<>0 then maxdayscriptcount=7 : sumdayscriptcount=sumdayscriptcount+1
end if

if tabno="" then
	if sumdayscriptcount >0 and maxdayscriptcount<7 then maxdayscriptcount=maxdayscriptcount+1
	tabno=maxdayscriptcount
end if

dim iCPerCnt, iCPageSize, iCCurrpage, SortMethod, OrderType, vDisp, SellScope, page
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	page	= requestCheckVar(Request("page"),10)	'현재 페이지 번호

IF iCCurrpage = "" THEN iCCurrpage = 1
IF page = "" THEN page = 1
iCPageSize = 6
iCPerCnt = 4		'보여지는 페이지 간격

dim ccomment
set ccomment = new Cevent_etc_common_list
	ccomment.FPageSize        = iCPageSize
	ccomment.FCurrpage        = iCCurrpage
	ccomment.FScrollCount     = iCPerCnt
	ccomment.frectordertype="new"
	ccomment.frectevt_code      	= eCode
	'ccomment.FRectUserID      	= userid
	ccomment.frectsub_opt2 = 1
	
	if getnowdate>="2014-04-21" then
		ccomment.event_subscript_paging
	end if

dim citem
set citem = new Cevent51223_list
	citem.FPageSize        = iCPageSize
	citem.FCurrpage        = page
	citem.FScrollCount     = iCPerCnt
	citem.FRectOrderType  = "subscript"
	citem.FRectDisp		= vDisp
	citem.frectevt_code = eCode
	citem.frectsub_opt2 = "4"

	if getnowdate>="2014-04-21" then
		citem.getitemList
	end if
%>

<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 내 생애 가장 단호한 일주일</title>
<style type="text/css">
.mEvt51224 {}
.mEvt51224 p {max-width:100%;}
.mEvt51224 img {vertical-align:top; width:100%;}
.mEvt51224 legend {visibility:hidden; width:0; height:0; overflow:hidden; position:absolute; top:-1000%; line-height:0;}
.danoWeek input[type="image"] {width:100%;}
.tabDano ul {overflow:hidden;}
.tabDano ul li {float:left; width:33.333%; border-right:1px solid #fff; border-bottom:1px solid #fff; box-sizing:border-box; -moz-box-sizing:border-box;}
.tabDano ul li:nth-child(3) {border-right:0;}
.tabDano ul li:nth-child(6) {border-right:0;}
.tabDano ul li:nth-child(8) {width:66.666%; border-right:0;}
.tabDano ul li a {display:block;background-position:left top; background-repeat:no-repeat; background-size:100% 100%;}
.tabDano ul li .end {display:none;}
.tabDano ul li:nth-child(1) a {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_01_off.png);}
.tabDano ul li:nth-child(1) a.current {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_01_current.png);}
.tabDano ul li:nth-child(1) a.checked {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_01_checked.png);}
.tabDano ul li:nth-child(1) a.current.checked {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_01_current_checked.png);}
.tabDano ul li:nth-child(2) a {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_02_off.png);}
.tabDano ul li:nth-child(2) a.current {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_02_current.png);}
.tabDano ul li:nth-child(2) a.checked {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_02_checked.png);}
.tabDano ul li:nth-child(2) a.current.checked {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_02_current_checked.png);}
.tabDano ul li:nth-child(3) a {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_03_off.png);}
.tabDano ul li:nth-child(3) a.current {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_03_current.png);}
.tabDano ul li:nth-child(3) a.checked {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_03_checked.png);}
.tabDano ul li:nth-child(3) a.current.checked {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_03_current_checked.png);}
.tabDano ul li:nth-child(4) a {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_04_off.png);}
.tabDano ul li:nth-child(4) a.current {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_04_current.png);}
.tabDano ul li:nth-child(4) a.checked {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_04_checked.png);}
.tabDano ul li:nth-child(4) a.current.checked {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_04_current_checked.png);}
.tabDano ul li:nth-child(5) a {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_05_off.png);}
.tabDano ul li:nth-child(5) a.current {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_05_current.png);}
.tabDano ul li:nth-child(5) a.checked {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_05_checked.png);}
.tabDano ul li:nth-child(5) a.current.checked {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_05_current_checked.png);}
.tabDano ul li:nth-child(6) a {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_06_off.png);}
.tabDano ul li:nth-child(6) a.current {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_06_current.png);}
.tabDano ul li:nth-child(6) a.checked {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_06_checked.png);}
.tabDano ul li:nth-child(6) a.current.checked {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_06_current_checked.png);}
.tabDano ul li:nth-child(7) a {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_07_off.png);}
.tabDano ul li:nth-child(7) a.current {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_07_current.png);}
.tabDano ul li:nth-child(7) a.checked {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_07_checked.png);}
.tabDano ul li:nth-child(7) a.current.checked {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_07_current_checked.png);}
.tabDano ul li:nth-child(8) a {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_08_off.png);}
.tabDano ul li:nth-child(8) a.current {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_08_current.png);}
.danoCont .cont {padding-top:5%;}
.danoCont .cont .btnAttendance button {width:100%; margin:0; padding:0; border:0; background:none; background-position:left top; background-repeat:no-repeat; background-size:100% 100%; cursor:pointer;}
.danoCont #cont1 .btnAttendance button.off {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/btn_attendance_01_off.png);}
.danoCont #cont1 .btnAttendance button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/btn_attendance_01_on.png);}
.danoCont #cont2 .btnAttendance button.off {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/btn_attendance_02_off.png);}
.danoCont #cont2 .btnAttendance button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/btn_attendance_02_on.png);}
.danoCont #cont3 .btnAttendance button.off {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/btn_attendance_03_off.png);}
.danoCont #cont3 .btnAttendance button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/btn_attendance_03_new_on.png);}
.danoCont #cont4 .btnAttendance button.off {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/btn_attendance_04_off.png);}
.danoCont #cont4 .btnAttendance button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/btn_attendance_04_on.png);}
.danoCont #cont5 .btnAttendance button.off {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/btn_attendance_05_off.png);}
.danoCont #cont5 .btnAttendance button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/btn_attendance_05_on.png);}
.danoCont #cont6 .btnAttendance button.off {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/btn_attendance_06_off.png);}
.danoCont #cont6 .btnAttendance button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/btn_attendance_06_on.png);}
.danoCont #cont7 .btnAttendance button.off {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/btn_attendance_07_off.png);}
.danoCont #cont7 .btnAttendance button.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/btn_attendance_07_on.png);}
/* 1 DAY */
.dietGoal .goalField {padding-bottom:5%; text-align:center;}
.dietGoal .goalField input {width:31px; height:31px; border:3px solid #f51048; color:#666; font-size:20px; font-family:Dotum; text-align:center;}
.goalCommentWrap {margin-top:8%; padding:7% 0 8%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/bg_pattern_01.gif) left top repeat-y; background-size:100% auto;}
.goalCommentWrap .goalComment {overflow:hidden; width:480px; margin:0 auto; padding-bottom:7%;}
.goalCommentWrap .goalComment .goal {position:relative; float:left; width:220px; height:100px; margin:10px 10px 0; text-align:center;}
.goalCommentWrap .goalComment .goal.bg01 {background:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/bg_comment_01.png) left top no-repeat; background-size:100% 100%;}
.goalCommentWrap .goalComment .goal.bg02 {background:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/bg_comment_02.png) left top no-repeat; background-size:100% 100%;}
.goalCommentWrap .goalComment .goal .number {display:block; padding-top:23px; font-size:12px;}
.goalCommentWrap .goalComment .goal .word {padding-top:7px; color:#fff; font-size:15px;}
.goalCommentWrap .goalComment .goal .id {display:block; padding-top:5px; color:#fff; font-size:12px;}
.goalCommentWrap .goalComment .goal .id img {width:8px; margin-right:3px;}
.goalCommentWrap .goalComment .goal .btnDelete {position:absolute; right:10px; top:10px; width:8px; height:8px; margin:0; padding:0; border:0; background:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/btn_del.png) left top no-repeat; background-size:100% 100%; text-indent:-999em;}
@media all and (max-width:480px){
	.goalCommentWrap .goalComment {width:300px;}
	.goalCommentWrap .goalComment .goal {width:140px; height:75px; margin:10px 5px 0;}
	.goalCommentWrap .goalComment .goal .number {padding-top:13px; font-size:10px;}
	.goalCommentWrap .goalComment .goal .word {padding-top:7px; font-size:12px;}
	.goalCommentWrap .goalComment .goal .id {padding-top:5px; font-size:10px;}
}
/* 4 DAY */
.mySpringLook .codeField span {display:block; position:relative; text-align:center;}
.mySpringLook .codeField span input {position:absolute; left:35%; top:18%; width:40%; height:25px; padding:0 5px; border:0; color:#666; font-size:13px; line-height:25px; font-weight:bold; text-align:center;}
.mySpringLook .springLookWrap {margin-top:8%; padding:8% 0 7%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/bg_pattern_01.gif) left top repeat-y; background-size:100% auto;}
.mySpringLook .springLookWrap .springLook {overflow:hidden; width:410px; margin:0 auto; padding-bottom:7%;}
.mySpringLook .springLookWrap .springLook .look {float:left; position:relative; width:183px; margin:12px 10px 0; background-color:#f6f6f6;}
.mySpringLook .springLookWrap .springLook .bar {display:block; height:4px;}
.mySpringLook .springLookWrap .springLook a {display:block; padding:10px 5px 10px; border:1px solid #eaeaea; border-top:0;}
.mySpringLook .springLookWrap .springLook a img {173px; height:173px;}
.mySpringLook .springLookWrap .springLook .number {display:block; padding-bottom:5px; color:#555; font-size:12px;}
.mySpringLook .springLookWrap .springLook .userId {overflow:hidden; margin-top:3px; padding-top:10px; border-top:1px dashed #c9c9c9; text-align:right;}
.mySpringLook .springLookWrap .springLook .userId .icoMobile {display:inline-block; width:6px; height:9px; margin-right:1px; text-indent:-999em; text-align:left; vertical-align:middle;}
.mySpringLook .springLookWrap .springLook .userId em {font-size:13px; line-height:1.313em;}
.mySpringLook .springLookWrap .springLook .btnDelete {position:absolute; right:10px; top:15px; width:8px; height:8px; margin:0; padding:0; border:0; background:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/btn_del.png) left top no-repeat; background-size:100% 100%; text-indent:-999em;}
.mySpringLook .springLookWrap .springLook .look.styleColor01 .bar {background:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/bg_bar_pink.gif) left top no-repeat; background-size:100% 4px;}
.mySpringLook .springLookWrap .springLook .look.styleColor01 .userId {color:#f51048;}
.mySpringLook .springLookWrap .springLook .look.styleColor01 .userId .icoMobile {background:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/ico_mobile_pink.png) left top no-repeat; background-size:6px 9px}
.mySpringLook .springLookWrap .springLook .look.styleColor02 .bar {background:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/bg_bar_green.gif) left top no-repeat; background-size:100% 4px;}
.mySpringLook .springLookWrap .springLook .look.styleColor02 .userId {color:#6aae19;}
.mySpringLook .springLookWrap .springLook .look.styleColor02 .userId .icoMobile {background:url(http://webimage.10x10.co.kr/eventIMG/2014/51224/ico_mobile_green.png) left top no-repeat; background-size:6px 9px;}
@media all and (max-width:480px){
	.mySpringLook .springLookWrap .springLook {width:290px;}
	.mySpringLook .springLookWrap .springLook .look {width:133px; margin:12px 5px 0;}
	.mySpringLook .springLookWrap .springLook a {padding:10px 5px 10px;}
	.mySpringLook .springLookWrap .springLook a img {width:123px; height:123px;}
	.mySpringLook .springLookWrap .springLook .number {font-size:11px;}
	.mySpringLook .springLookWrap .springLook .userId em {font-size:11px;}
	.mySpringLook .springLookWrap .springLook .userId .icoMobile {width:8px; height:11px;}
}
</style>
<script type="text/javascript">
	$(function(){
		//$(".tabDano li a:first").addClass("current");
		//$(".danoCont").find(".cont").hide();
		//$(".danoCont").find(".cont:first").show();
		
		$(".tabDano li a").click(function(){
			frmcom.tabno.value=$(this).attr("ongubun");
			frmcom.action="";
			frmcom.target=""
			frmcom.submit();
			//$(".tabDano li a").removeClass("current");
			//$(this).addClass("current");
			//var thisCont = $(this).attr("href");
			//$(".danoCont").find(".cont").hide();
			//$(".danoCont").find(thisCont).show();
			//return false;
		});
	});

	function IsDouble(v){
		if (v.length<1) return false;
	
		for (var j=0; j < v.length; j++){
			if ("0123456789.".indexOf(v.charAt(j)) < 0) {
				return false;
			}
		}
		return true;
	}

	function jsSubmitday1(frm){
		<% If IsUserLoginOK() Then %>
			<% If Now() > #04/27/2014 23:59:59# Then %>
				alert("이벤트가 종료되었습니다.");
				return;
			<% Else %>
				<% If getnowdate>="2014-04-21" and getnowdate<"2014-04-28" Then %>
					<% if day1scriptcount = 0 and dayscriptcount = 0 and getnowdate>="2014-04-21" then %>

						if (frm.txtcomm1.value == '' || frm.txtcomm2.value == '' || frm.txtcomm3.value == '' || frm.txtcomm4.value == '' || frm.txtcomm5.value == ''){
							alert("나의 다이어트 목표를 한글자씩 입력해 주세요.");
							return;
						}

						frm.txtcomm.value = frm.txtcomm1.value + "." + frm.txtcomm2.value + "." + frm.txtcomm3.value + "." + frm.txtcomm4.value + "." + frm.txtcomm5.value
						frm.mode.value="day1";
						frm.target="evtFrmProc";
						frm.action = "/event/etc/doEventSubscript51223.asp";
						frm.submit();
					<% else %>
						alert("이미 참여 하셨거나, 하루에 한번만 참여 가능 합니다.");
						return;
					<% end if %>
				<% else %>
					alert("이벤트 응모 기간이 아닙니다.");
					return;
				<% end if %>
			<% End If %>
		<% Else %>
			alert('로그인을 하셔야 참여가 가능 합니다');
			return;
//			if(confirm("로그인을 하셔야 참여가 가능 합니다. 로그인 하시겠습니까?")){
//				var winLogin = window.open('/login/PopLoginPage.asp','popLogin','width=400,height=300');
//				winLogin.focus();
//				return;
//			}
		<% End IF %>
	}

	function jsSubmitday2(frm){
		<% If IsUserLoginOK() Then %>
			<% If Now() > #04/27/2014 23:59:59# Then %>
				alert("이벤트가 종료되었습니다.");
				return;
			<% Else %>
				<% If getnowdate>="2014-04-21" and getnowdate<"2014-04-28" Then %>
					<% if day2scriptcount = 0 and dayscriptcount = 0 and getnowdate>="2014-04-22" then %>
						<% if day1scriptcount =1 then %>
							frm.mode.value="day2";
							frm.target="evtFrmProc";
							frm.action = "/event/etc/doEventSubscript51223.asp";
							frm.submit();
						<% else %>
							alert("이전 날짜부터 출석 체크 해주세요.");
							return;
						<% end if %>
					<% else %>
						alert("이미 참여 하셨거나, 하루에 한번만 참여 가능 합니다.");
						return;
					<% end if %>
				<% else %>
					alert("이벤트 응모 기간이 아닙니다.");
					return;
				<% end if %>
			<% End If %>
		<% Else %>
			alert('로그인을 하셔야 참여가 가능 합니다');
			return;
			//if(confirm("로그인을 하셔야 참여가 가능 합니다. 로그인 하시겠습니까?")){
			//	var winLogin = window.open('/login/PopLoginPage.asp','popLogin','width=400,height=300');
			//	winLogin.focus();
			//	return;
			//}
		<% End IF %>
	}

	function jsSubmitday3(frm){
		<% If IsUserLoginOK() Then %>
			<% If Now() > #04/27/2014 23:59:59# Then %>
				alert("이벤트가 종료되었습니다.");
				return;
			<% Else %>
				<% If getnowdate>="2014-04-21" and getnowdate<"2014-04-28" Then %>
					<% if day3scriptcount = 0 and dayscriptcount = 0 and getnowdate>="2014-04-23" then %>
						<% if day2scriptcount =1 then %>
							frm.mode.value="day3";
							frm.target="evtFrmProc";
							frm.action = "/event/etc/doEventSubscript51223.asp";
							frm.submit();
						<% else %>
							alert("이전 날짜부터 출석 체크 해주세요.");
							return;
						<% end if %>
					<% else %>
						alert("이미 참여 하셨거나, 하루에 한번만 참여 가능 합니다.");
						return;
					<% end if %>
				<% else %>
					alert("이벤트 응모 기간이 아닙니다.");
					return;
				<% end if %>
			<% End If %>
		<% Else %>
			alert('로그인을 하셔야 참여가 가능 합니다');
			return;
//			if(confirm("로그인을 하셔야 참여가 가능 합니다. 로그인 하시겠습니까?")){
//				var winLogin = window.open('/login/PopLoginPage.asp','popLogin','width=400,height=300');
//				winLogin.focus();
//				return;
//			}
		<% End IF %>
	}

	function jsSubmitday4(frm){
		<% If IsUserLoginOK() Then %>
			<% If Now() > #04/27/2014 23:59:59# Then %>
				alert("이벤트가 종료되었습니다.");
				return;
			<% Else %>
				<% If getnowdate>="2014-04-21" and getnowdate<"2014-04-28" Then %>
					<% if day4scriptcount = 0 and dayscriptcount = 0 and getnowdate>="2014-04-24" then %>
						<% if day3scriptcount =1 then %>
							if (frm.itemid.value == ''){
								alert("상품코드를 입력해 주세요.");
								return;
							}
	
							if (!IsDouble(frm.itemid.value)){
								alert('상품번호는 숫자만 가능합니다.');
								frm.itemid.focus();
								return;
							}
							frm.mode.value="day4";
							frm.target="evtFrmProc";
							frm.action = "/event/etc/doEventSubscript51223.asp";
							frm.submit();
						<% else %>
							alert("이전 날짜부터 출석 체크 해주세요.");
							return;
						<% end if %>
					<% else %>
						alert("이미 참여 하셨거나, 하루에 한번만 참여 가능 합니다.");
						return;
					<% end if %>
				<% else %>
					alert("이벤트 응모 기간이 아닙니다.");
					return;
				<% end if %>
			<% End If %>
		<% Else %>
			alert('로그인을 하셔야 참여가 가능 합니다');
			return;
//			if(confirm("로그인을 하셔야 참여가 가능 합니다. 로그인 하시겠습니까?")){
//				var winLogin = window.open('/login/PopLoginPage.asp','popLogin','width=400,height=300');
//				winLogin.focus();
//				return;
//			}
		<% End IF %>
	}

	function jsSubmitday5(frm){
		<% If IsUserLoginOK() Then %>
			<% If Now() > #04/27/2014 23:59:59# Then %>
				alert("이벤트가 종료되었습니다.");
				return;
			<% Else %>
				<% If getnowdate>="2014-04-21" and getnowdate<"2014-04-28" Then %>
					<% if day5scriptcount = 0 and dayscriptcount = 0 and getnowdate>="2014-04-25" then %>
						<% if day4scriptcount =1 then %>
							frm.mode.value="day5";
							frm.target="evtFrmProc";
							frm.action = "/event/etc/doEventSubscript51223.asp";
							frm.submit();
						<% else %>
							alert("이전 날짜부터 출석 체크 해주세요.");
							return;
						<% end if %>
					<% else %>
						alert("이미 참여 하셨거나, 하루에 한번만 참여 가능 합니다.");
						return;
					<% end if %>
				<% else %>
					alert("이벤트 응모 기간이 아닙니다.");
					return;
				<% end if %>
			<% End If %>
		<% Else %>
			alert('로그인을 하셔야 참여가 가능 합니다');
			return;
//			if(confirm("로그인을 하셔야 참여가 가능 합니다. 로그인 하시겠습니까?")){
//				var winLogin = window.open('/login/PopLoginPage.asp','popLogin','width=400,height=300');
//				winLogin.focus();
//				return;
//			}
		<% End IF %>
	}
	
	function jsSubmitday6(frm){
		<% If IsUserLoginOK() Then %>
			<% If Now() > #04/27/2014 23:59:59# Then %>
				alert("이벤트가 종료되었습니다.");
				return;
			<% Else %>
				<% If getnowdate>="2014-04-21" and getnowdate<"2014-04-28" Then %>
					<% if day6scriptcount = 0 and dayscriptcount = 0 and getnowdate>="2014-04-26" then %>
						<% if day5scriptcount =1 then %>
							frm.mode.value="day6";
							frm.target="evtFrmProc";
							frm.action = "/event/etc/doEventSubscript51223.asp";
							frm.submit();
						<% else %>
							alert("이전 날짜부터 출석 체크 해주세요.");
							return;
						<% end if %>
					<% else %>
						alert("이미 참여 하셨거나, 하루에 한번만 참여 가능 합니다.");
						return;
					<% end if %>
				<% else %>
					alert("이벤트 응모 기간이 아닙니다.");
					return;
				<% end if %>
			<% End If %>
		<% Else %>
			alert('로그인을 하셔야 참여가 가능 합니다');
			return;
//			if(confirm("로그인을 하셔야 참여가 가능 합니다. 로그인 하시겠습니까?")){
//				var winLogin = window.open('/login/PopLoginPage.asp','popLogin','width=400,height=300');
//				winLogin.focus();
//				return;
//			}
		<% End IF %>
	}

	function jsSubmitday7(frm){
		<% If IsUserLoginOK() Then %>
			<% If Now() > #04/27/2014 23:59:59# Then %>
				alert("이벤트가 종료되었습니다.");
				return;
			<% Else %>
				<% If getnowdate>="2014-04-21" and getnowdate<"2014-04-28" Then %>
					<% if day7scriptcount = 0 and dayscriptcount = 0 and getnowdate>="2014-04-27" then %>
						<% if day6scriptcount =1 then %>
							frm.mode.value="day7";
							frm.target="evtFrmProc";
							frm.action = "/event/etc/doEventSubscript51223.asp";
							frm.submit();
						<% else %>
							alert("이전 날짜부터 출석 체크 해주세요.");
							return;
						<% end if %>
					<% else %>
						alert("이미 참여 하셨거나, 하루에 한번만 참여 가능 합니다.");
						return;
					<% end if %>
				<% else %>
					alert("이벤트 응모 기간이 아닙니다.");
					return;
				<% end if %>
			<% End If %>
		<% Else %>
			alert('로그인을 하셔야 참여가 가능 합니다');
			return;
//			if(confirm("로그인을 하셔야 참여가 가능 합니다. 로그인 하시겠습니까?")){
//				var winLogin = window.open('/login/PopLoginPage.asp','popLogin','width=400,height=300');
//				winLogin.focus();
//				return;
//			}
		<% End IF %>
	}
	
	function jsCheckLimit() {
		if ("<%=IsUserLoginOK%>"=="False") {
			jsChklogin('<%=IsUserLoginOK%>');
		}
		
		if (frmcom.itemid.value=="상품코드"){
			frmcom.itemid.value="";
		}
	}

	function jsCheckLimits() {
		if ("<%=IsUserLoginOK%>"=="False") {
			jsChklogin('<%=IsUserLoginOK%>');
		}
	}
	
	function jsSubmitday1del(sub_idx){
		<% If getnowdate>="2014-04-21" and getnowdate<"2014-04-28" Then %>
			if(confirm("삭제하시겠습니까?")){
				frmcom.sub_idx.value = sub_idx;
				frmcom.mode.value="day1del";
				frmcom.action="/event/etc/doEventSubscript51223.asp";
				frmcom.target="evtFrmProc";
		   		frmcom.submit();
			}
		<% else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% end if %>
	}

	function jsGoitemPage(page){
		document.frmcom.page.value = page;
		document.frmcom.submit();
	}

	function jsGocommentPage(iCC){
		document.frmcom.iCC.value = iCC;
		document.frmcom.submit();
	}
</script>
</head>
<body>

	<!-- content area -->
	<!-- 내 생애 가장 단호한 일주일 -->
	<div class="mEvt51224">
		<div class="danoWeek">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/tit_dano_week.jpg" alt="내 생애 가장 단호한 일주일 DANO WEEK" /></h2>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/txt_dano_week.jpg" alt="다가오는 여름, 빛나는 몸매를 원한다면? ‘텐바이텐‘과 다이어트앱 ‘다이어트 노트‘가 준비한 다노위크에 함께하세요!" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/txt_check_attendance.gif" alt="다노위크 동안 출석체크를 해주세요! 단호한 일주일을 보내주신 분들에게 추첨을 통해 선물을 드립니다. 이벤트 기간 : 2014. 04.21 ~ 04. 27 | 당첨자 발표 : 04.29 / 본 이벤트는 각 ID당 하루에 한 번만 참여할 수 있습니다 (하루에 1DAY씩 진행됩니다) 이벤트에 당첨되신 고객은 주소 확인 및 간단한 개인정보 취합 후 상품이 발송됩니다. 당첨 당시의 재고 상황에 따라 사은품이 교체될 수 있습니다." /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/txt_gift.jpg" alt="2일 이상 출석 완료시 다이어트 줄넘기, 4일 이상 출석 완료시 스마트 헬스케어 앱세서리, 6일 이상 출석 완료시 ANM BIKE" /></p>

			<!-- 출석체크 -->
			<div class="tabDano">
				<ul>
					<!-- for dev msg : 완료한 날짜에는 a에 클래스 .checked를 붙여주세요. -->
					<li>
						<a href="#cont1" ongubun="1" class="<% if tabno=1 then %>current<% end if %> <% if day1scriptcount<>0 or maxdayscriptcount > 1 then %> checked<% end if %>">
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_01.png" alt="1 DAY" /></a>
					</li>
					<li>
						<a href="#cont2" ongubun="2" class="<% if tabno=2 then %>current<% end if %> <% if day2scriptcount<>0 then %> checked<% end if %>">
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_02.png" alt="2 DAY" /></a>
					</li>
					<li>
						<a href="#cont3" ongubun="3" class="<% if tabno=3 then %>current<% end if %> <% if day3scriptcount<>0 then %> checked<% end if %>">
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_03.png" alt="3 DAY" /></a>
					</li>
					<li>
						<a href="#cont4" ongubun="4" class="<% if tabno=4 then %>current<% end if %> <% if day4scriptcount<>0 or maxdayscriptcount > 4 then %> checked<% end if %>">
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_04.png" alt="4 DAY" /></a>
					</li>
					<li>
						<a href="#cont5" ongubun="5" class="<% if tabno=5 then %>current<% end if %> <% if day5scriptcount<>0 then %> checked<% end if %>">
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_05.png" alt="5 DAY" /></a>
					</li>
					<li>
						<a href="#cont6" ongubun="6" class="<% if tabno=6 then %>current<% end if %> <% if day6scriptcount<>0 then %> checked<% end if %>">
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_06.png" alt="6 DAY" /></a>
					</li>
					<li>
						<a href="#cont7" ongubun="7" class="<% if tabno=7 then %>current<% end if %> <% if day7scriptcount<>0 then %> checked<% end if %>">
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_07.png" alt="7 DAY" /></a>
					</li>
					<li>
						<a href="#cont8" ongubun="8" class="<% if tabno=8 then %>current<% end if %>">
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/tab_08.png" alt="DANO APP" /></a>
					</li>
				</ul>
			</div>
			<!-- //출석체크 -->

			<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
			<input type="hidden" name="mode">
			<input type="hidden" name="tabno" value="<%=tabno%>">
			<input type="hidden" name="sub_idx">
			<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
			<input type="hidden" name="page" value="<%=page%>">
			<input type="hidden" name="txtcomm">
			
			<!-- 컨텐츠 -->
			<div class="danoCont">
			
				<% if tabno="1" then %>
					<!-- 1 DAY -->
					<div id="cont1" class="cont">
						<div class="btnAttendance">
							<% if day1scriptcount=0 then %>
								<button type="button"  onclick="alert('아래의 댓글 이벤트에 응모하시면 자동으로 출석체크가 됩니다!');" class="off"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/btn_attendance.png" alt="다노워크 1일 출석하기" /></button>
							<% else %>
								<button type="button" class="on"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/btn_attendance.png" alt="완료" /></button>
							<% end if %>
						</div>

						<div class="dietGoal">
							<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/tit_diet_goal.gif" alt="내 생에 가장 단호한 일주일의 시작! 나의 다이어트 목표를 다섯 글자로 적어보기 (ex. 컴백홈복근, 예뻐질래요" /></h3>
							<fieldset>
								<legend>나의 다이어트 목표를 다섯 글자 입력하기</legend>
								<div class="goalField">
									<input type="text" name="txtcomm1" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> onClick="jsCheckLimits();" onKeyUp="jsCheckLimits();" title="첫번째 글자" maxlength="1" />
									<input type="text" name="txtcomm2" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> onClick="jsCheckLimits();" onKeyUp="jsCheckLimits();" title="두번째 글자" maxlength="1" />
									<input type="text" name="txtcomm3" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> onClick="jsCheckLimits();" onKeyUp="jsCheckLimits();" title="세번째 글자" maxlength="1" />
									<input type="text" name="txtcomm4" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> onClick="jsCheckLimits();" onKeyUp="jsCheckLimits();" title="네번째 글자" maxlength="1"/>
									<input type="text" name="txtcomm5" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> onClick="jsCheckLimits();" onKeyUp="jsCheckLimits();" title="다섯번째 글자" maxlength="1" />
								</div>
								<div onclick="jsSubmitday1(frmcom);"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/51224/btn_submit.png" alt="등록하기" /></div>
							</fieldset>

							<% IF ccomment.ftotalcount>0 THEN %>
							<!-- Comment -->
							<div class="goalCommentWrap">
								<div class="goalComment">
									<%
									dim rndNo : rndNo = 1

									for ix = 0 to ccomment.fresultcount - 1

									randomize
									rndNo = Int((2 * Rnd) + 1)
									%>
									<div class="goal bg0<%=rndNo%>">
										<span class="number">no.<%=ccomment.FTotalCount-ix-(ccomment.FPageSize*(ccomment.FCurrPage-1))%></span>
										<div class="word"><strong><%=ReplaceBracket(ccomment.FItemList(ix).fsub_opt3)%></strong></div>
										<span class="id">
											<% if ccomment.FItemList(ix).fdevice<>"W" then %>
												<img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/ico_mobile.png" alt="모바일에서 작성" />
											<% end if %>
											<%=printUserId(ccomment.FItemList(ix).fuserid,2,"*")%>님
										</span>
										
										<% if ((userid = ccomment.FItemList(ix).fuserid) or (userid = "10x10")) and ( ccomment.FItemList(ix).fuserid<>"") then %>
											<button type="button" onclick="jsSubmitday1del('<%= ccomment.FItemList(ix).fsub_idx %>');" class="btnDelete">삭제</button>
										<% end if %>
									</div>
									<% next %>
								</div>
									<%=fnDisplayPaging_New(ccomment.FCurrpage,ccomment.FTotalCount,ccomment.FPageSize,ccomment.FScrollCount,"jsGocommentPage")%>
							</div>
							<!-- //Comment -->
							<% end if %>
						</div>
					</div>
					<!-- //1 DAY -->
				<% end if %>
				
				<% if tabno="2" then %>
					<!-- 2 DAY -->
					<div id="cont2" class="cont">
						<div class="btnAttendance">
							<% if day2scriptcount=0 then %>
								<button type="button" onclick="jsSubmitday2(frmcom);" class="off"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/btn_attendance.png" alt="다노워크 2일 출석하기" /></button>
							<% else %>
								<button type="button" class="on"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/btn_attendance.png" alt="완료" /></button>
							<% end if %>
						</div>
						
						<div class="exercise">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/txt_exercise.gif" alt="다이어트에는 역시 운동! 효과적인 코어 운동의 순서 1. 복근에 집중 2. 호흡 3. 준비운동" />
							<div><a href="http://m.youtube.com/watch?v=iGJQgpxNVXU&amp;list=PLpXJ7Rlnuy86fCPGMsMSb1jon0OMB1dXk.&amp;app=desktop" title="새창" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/btn_go_core_exercise.gif" alt="코어운동 배우러 가기" /></a></div>
						</div>
					</div>
					<!-- //2 DAY -->
				<% end if %>

				<% if tabno="3" then %>
					<!-- 3 DAY -->
					<div id="cont3" class="cont">
						<div class="btnAttendance">
							<% if day3scriptcount=0 then %>
								<button type="button" onclick="jsSubmitday3(frmcom);" class="off"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/btn_attendance.png" alt="다노워크 3일 출석하기" /></button>
							<% else %>
								<button type="button" class="on"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/btn_attendance.png" alt="완료" /></button>
							<% end if %>
						</div>

						<div class="seasonFood">
							<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/tit_season_food.gif" alt="따사로운 봄날의 기운과 영양이 가득 담긴 봄 제철음식 추천!" /></h3>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/txt_season_food.gif" alt="Spring Food : 딸기, 취나물, 두릅, 바지락, 키조개, 소라, 쭈꾸미" /></p>
						</div>
					</div>
					<!-- //3 DAY -->
				<% end if %>

				<% if tabno="4" then %>
					<!-- 4 DAY -->
					<div id="cont4" class="cont">
						<div class="btnAttendance">
							<% if day4scriptcount=0 then %>
								<button type="button" onclick="alert('아래의 댓글 이벤트에 응모하시면 자동으로 출석체크가 됩니다!');" class="off"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/btn_attendance.png" alt="다노워크 4일 출석하기" /></button>
							<% else %>
								<button type="button" class="on"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/btn_attendance.png" alt="완료" /></button>
							<% end if %>
						</div>

						<div class="mySpringLook">
							<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/tit_my_spring_look.gif" alt="다이어트에 성공하면 꼭 입을 거에요! 따뜻한 봄 날씨에 옷장 속 옷들도 점점 얇아지고 있어요. 다이어트에 성공하면 가장 입고 싶은 나만의 SPRING LOOK을 찾아주세요!" /></h3>
							<fieldset>
								<legend>상품코드 입력</legend>
								<div class="codeField">
									<span>
										<input type="text" name="itemid" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" title="상품코드 입력" value="상품코드" />
										<img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/bg_input.gif" alt="" />
									</span>
									<div class="btnEnter"><a href="" onclick="jsSubmitday4(frmcom); return false;"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/51224/btn_enter.gif" alt="입력" /></a></div>
								</div>
							</fieldset>

							<% IF citem.FResultCount>0 THEN %>
								<div class="springLookWrap">
									<div class="springLook">
									<% dim rndNom : rndNom = 1 %>

									<% 
									for ix = 0 to citem.FResultCount-1
									
									randomize
									rndNo = Int((2 * Rnd) + 1)
									%>
										<div class="look styleColor0<%=rndNom%>">
											<span class="bar"></span>
											<a href="/category/category_itemPrd.asp?itemid=<%= citem.FItemList(ix).FItemID%>" target="_top">
												<span class="number">no.<%=citem.FTotalCount-ix-(citem.FPageSize*(citem.FCurrPage-1))%></span>
												<img src="<% = citem.FItemList(ix).FImageIcon1 %>" alt="<%= citem.FItemList(ix).FItemName %>" /><!-- for dev msg : Alt값에 상품명 넣어주세요 -->
												<div class="userId">
													<% if citem.FItemList(ix).fdevice<>"W" then %>
														<span class="icoMobile">모바일에서 작성</span>
													<% end if %>
														<em><%=printUserId(citem.FItemList(ix).fuserid,2,"*")%> 님</em>
												</div>
											</a>
											<% if ((userid = citem.FItemList(ix).fuserid) or (userid = "10x10")) and ( citem.FItemList(ix).fuserid<>"") then %>
												<button type="button" onclick="jsSubmitday1del('<%= citem.FItemList(ix).Fidx %>');" class="btnDelete">삭제</button>
											<% end if %>
										</div>
									<% next %>
									</div>
									<%= fnDisplayPaging_New(citem.FCurrpage, citem.FTotalCount, citem.FPageSize, citem.FScrollCount,"jsGoitemPage") %>
								</div>
							<% end if %>
						</div>
					</div>
					<!-- //4 DAY -->
				<% end if %>

				<% if tabno="5" then %>
					<!-- 5 DAY -->
					<div id="cont5" class="cont">
						<div class="btnAttendance">
							<% if day5scriptcount=0 then %>
								<button type="button" onclick="jsSubmitday5(frmcom);" class="off"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/btn_attendance.png" alt="다노워크 5일 출석하기" /></button>
							<% else %>
								<button type="button" class="on"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/btn_attendance.png" alt="완료" /></button>
							<% end if %>
						</div>

						<div class="happyDieter">
							<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/tit_happy_dieter.gif" alt="행복한 다이어터가 되기 위한 행복한 마음가짐" /></h3>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/txt_happy_dieter.gif" alt="1. 과식을 했더라도 스트레스 받지 않고 다음 날부터 식이조절! 2. 체중에는 너무 휘둘리지 말자 3. 간식의 유혹보다는 건강한 식단으로 야무진 결심을! 4. 빠지지 않고 운동하기 5. 실생활에서도 스트레칭하기" /></p>
						</div>
					</div>
					<!-- //5 DAY -->
				<% end if %>

				<% if tabno="6" then %>
					<!-- 6 DAY -->
					<div id="cont6" class="cont">
						<div class="btnAttendance">
							<% if day6scriptcount=0 then %>
								<button type="button" onclick="jsSubmitday6(frmcom);" class="off"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/btn_attendance.png" alt="다노워크 6일 출석하기" /></button>
							<% else %>
								<button type="button" class="on"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/btn_attendance.png" alt="완료" /></button>
							<% end if %>
						</div>

						<div class="greenSmoothie">
							<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/tit_green_smoothie.jpg" alt="평범한 주말에 초록초록 에너지를 더해줄 초간단 그린 스무디" /></h3>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/txt_green_smoothie_enjoy.gif" alt="1. 과일과 잎채소 종류는 각각 1~2가지 정도만 사용하는 것이 각각의 재료들이 가진 본연의 맛도 살리고 영양흡수에도 좋아요. 2. 냉동블루베리, 냉동딸기를 활용하면 저렴하고 오래 두고 먹을 수 있을 뿐 아니라 아이스 스무디같은 식감을 살릴 수 있어요! 3. 스무디만의 장점은 즙만 짜낸 쥬스와는 달리 채소와 과일의 식이섬유가 통째로 들어가 있다는 것이에요. 벌컥벌컥 마시지말고 한 모금씩 천천히 씹으면서 마시는 것이 포만감에도 훨씬 좋고 영양 흡수에도 좋답니다!" /></p>
						</div>
					</div>
					<!-- //6 DAY -->
				<% END if %>
	
				<% if tabno="7" then %>
					<!-- 7 DAY -->
					<div id="cont7" class="cont">
						<div class="btnAttendance">
							<% if day7scriptcount=0 then %>
								<button type="button" onclick="jsSubmitday7(frmcom);" class="off"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/btn_attendance.png" alt="다노워크 7일 출석하기" /></button>
							<% else %>
								<button type="button" class="on"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/btn_attendance.png" alt="완료" /></button>
							<% end if %>
						</div>

						<div class="yogaClass">
							<h4><img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/tit_yoga.jpg" alt="건강한 하루의 시작 요가로 몸도 튼튼 마음도 튼튼" /></h4>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/txt_yoga.gif" alt="비둘기 자세 : 1. 편하게 앉은 상태에서 왼쪽 다리를 앞으로 접어주고 오른쪽 다리는 뒤로 쭉 뻗어주세요. 2. 시선은 접은 다리 쪽으로 두고 상체를 세워주세요. 3. 호흡을 천천히 들이마시면서 뒤로 뻗은 오른쪽 다리를 접어 발끝을 잡아주세요. 이때 고관절이 많이 움직이지 않도록 주의! 4. 천천히 호흡을 내쉬며 접은 오른쪽 다리를 팔꿈치 안쪽으로 감싸준 후 양 손은 깍지를 끼워주세요. 4. 균형을 유지하며 15~30초 정도 유지 후 반대쪽도 해주세요." /></p>
						</div>
					</div>
					<!-- //7 DAY -->
				<% end if %>
				
				<% if tabno="8" then %>
					<!-- DANO APP -->
					<div id="cont8" class="cont">
						<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/tit_dano.gif" alt="NO.1 국내최대 다이어트 커뮤니티 다노를 만나세요! DANO" /></h3>
						<div><a href="http://goo.gl/uwlM16" target="_blank" title="새창"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/btn_download_app.gif" alt="어플 다운로드" /></a></div>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/img_dano_app.jpg" alt="DANO 어플 : 레시피, 비포애프터후기, 파트너, 불끈자극, 운동영상&amp;꿀팁" /></p>
					</div>
					<!-- //DANO APP -->
				<% end if %>
			</div>
			<!-- //컨텐츠 -->

			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/51224/txt_note.gif" alt="이벤트 유의사항 : 본 이벤트는 각 ID당 하루에 한 번만 참여할 수 있습니다. (하루에 1DAY씩 진행됩니다) 당첨되신 고객은 주소 확인 및 간단한 개인정보 취합 후 상품이 발송됩니다. 당첨 당시의 재고 상황에 따라 사은품이 교체될 수 있습니다." /></p>
		</div>
	</div>
	<!--// 내 생애 가장 단호한 일주일 -->

</body>
</html>

<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>

<%
set ccomment=nothing
set citem=nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
' Description : PLAYing 공감되면 투표해주세요!
' History : 2017-02-23 김진영 생성
'####################################################
Dim eCode, sqlStr, LoginUserid, vDIdx, myresultCnt, totalresultCnt
Dim totalex1y, totalex1n, totalex2y, totalex2n, totalex3y, totalex3n, totalex4y, totalex4n, totalex5y, totalex5n, totalex6y, totalex6n, totalex7y, totalex7n
Dim myex1, myex2, myex3, myex4, myex5, myex6, myex7
Dim pagereload

IF application("Svr_Info") = "Dev" THEN
	eCode   =  66283
Else
	eCode   =  76299
End If

vDIdx		= request("didx")
pagereload	= requestCheckVar(request("pagereload"),2)
LoginUserid	= getencLoginUserid()

'1. 로그인을 했다면 tbl_event_subscript에 ID가 있는 지 확인
If IsUserLoginOK() Then
	sqlStr = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' and userid = '" & LoginUserid & "' AND sub_opt1 = 'result' "
	rsget.Open sqlStr,dbget,1
	If not rsget.EOF Then
		myresultCnt = rsget(0)
	End If
	rsget.close
Else
	myresultCnt = 0
End If

'2. 전체 문항 카운트
sqlStr = ""
sqlStr = sqlStr & " SELECT "
sqlStr = sqlStr & " sum(CASE WHEN ex1 = 1 THEN 1 ELSE 0 END) as totalex1y "
sqlStr = sqlStr & " ,sum(CASE WHEN ex1 = 2 THEN 1 ELSE 0 END) as totalex1n "
sqlStr = sqlStr & " ,sum(CASE WHEN ex2 = 1 THEN 1 ELSE 0 END) as totalex2y "
sqlStr = sqlStr & " ,sum(CASE WHEN ex2 = 2 THEN 1 ELSE 0 END) as totalex2n "
sqlStr = sqlStr & " ,sum(CASE WHEN ex3 = 1 THEN 1 ELSE 0 END) as totalex3y "
sqlStr = sqlStr & " ,sum(CASE WHEN ex3 = 2 THEN 1 ELSE 0 END) as totalex3n "
sqlStr = sqlStr & " ,sum(CASE WHEN ex4 = 1 THEN 1 ELSE 0 END) as totalex4y "
sqlStr = sqlStr & " ,sum(CASE WHEN ex4 = 2 THEN 1 ELSE 0 END) as totalex4n "
sqlStr = sqlStr & " ,sum(CASE WHEN ex5 = 1 THEN 1 ELSE 0 END) as totalex5y "
sqlStr = sqlStr & " ,sum(CASE WHEN ex5 = 2 THEN 1 ELSE 0 END) as totalex5n "
sqlStr = sqlStr & " ,sum(CASE WHEN ex6 = 1 THEN 1 ELSE 0 END) as totalex6y "
sqlStr = sqlStr & " ,sum(CASE WHEN ex6 = 2 THEN 1 ELSE 0 END) as totalex6n "
sqlStr = sqlStr & " ,sum(CASE WHEN ex7 = 1 THEN 1 ELSE 0 END) as totalex7y "
sqlStr = sqlStr & " ,sum(CASE WHEN ex7 = 2 THEN 1 ELSE 0 END) as totalex7n "
sqlStr = sqlStr & " FROM db_temp.[dbo].[tbl_event_76299] "
rsget.Open sqlStr,dbget,1
If not rsget.EOF Then
	totalex1y = rsget("totalex1y")
	totalex1n = rsget("totalex1n")
	totalex2y = rsget("totalex2y")
	totalex2n = rsget("totalex2n")
	totalex3y = rsget("totalex3y")
	totalex3n = rsget("totalex3n")
	totalex4y = rsget("totalex4y")
	totalex4n = rsget("totalex4n")
	totalex5y = rsget("totalex5y")
	totalex5n = rsget("totalex5n")
	totalex6y = rsget("totalex6y")
	totalex6n = rsget("totalex6n")
	totalex7y = rsget("totalex7y")
	totalex7n = rsget("totalex7n")
End If
rsget.close

If IsNull(totalex1y) Then totalex1y = 0
If IsNull(totalex1n) Then totalex1n = 0
If IsNull(totalex2y) Then totalex2y = 0
If IsNull(totalex2n) Then totalex2n = 0
If IsNull(totalex3y) Then totalex3y = 0
If IsNull(totalex3n) Then totalex3n = 0
If IsNull(totalex4y) Then totalex4y = 0
If IsNull(totalex4n) Then totalex4n = 0
If IsNull(totalex5y) Then totalex5y = 0
If IsNull(totalex5n) Then totalex5n = 0
If IsNull(totalex6y) Then totalex6y = 0
If IsNull(totalex6n) Then totalex6n = 0
If IsNull(totalex7y) Then totalex7y = 0
If IsNull(totalex7n) Then totalex7n = 0

'3. 전체 참여자 카운트
sqlStr = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' AND sub_opt1 = 'result' "
rsget.Open sqlStr,dbget,1
If not rsget.EOF Then
	totalresultCnt = rsget(0)
End If
rsget.close

'4.내가 참여한 것 카운트
sqlStr = ""
sqlStr = sqlStr & " SELECT TOP 1 ex1, ex2, ex3, ex4, ex5, ex6, ex7 "
sqlStr = sqlStr & " FROM db_temp.[dbo].[tbl_event_76299] "
sqlStr = sqlStr & " where userid = '"&LoginUserid&"' "
rsget.Open sqlStr,dbget,1
If not rsget.EOF Then
	myex1 = rsget("ex1")
	myex2 = rsget("ex2")
	myex3 = rsget("ex3")
	myex4 = rsget("ex4")
	myex5 = rsget("ex5")
	myex6 = rsget("ex6")
	myex7 = rsget("ex7")
End If
rsget.close
%>
<style type="text/css">
.onlyMe {position:relative; background-color:#fff;}
.onlyMe button {background-color:transparent; outline:none;}
.onlyMe .intro .some {position:absolute; left:10.31%; top:4%; width:24%;}
.onlyMe .intro h3 {position:absolute; left:26%; top:10%; width:42.96%; animation:bounce .5s 1s 2;}
.onlyMe .intro h3 span {position:absolute;}
.onlyMe .intro h3 span.q1 {left:84%; top:39.56%; width:39.63%; animation:bounce .8s 2s infinite;}
.onlyMe .intro h3 span.q2 {left:100.8%; top:69%; width:20.36%; animation:bounce 1s 2s infinite;}
.onlyMe .intro .btnStart {position:absolute; left:50%; bottom:5.6%; width:74.5%; margin-left:-37.25%;}
.onlyMe .intro .noti {position:absolute; left:50%; bottom:4%; width:21.25%; margin-left:-10.625%;}
.onlyMe .sympathyTest .btnNav {position:absolute; top:28%; z-index:10; width:12.5%; z-index:10; opacity:1; transition:opacity .5s;}
.onlyMe .sympathyTest .btnPrev {left:0;}
.onlyMe .sympathyTest .btnNext {right:0; animation:bounce3 .8s 2.5s 5;}
.onlyMe .sympathyTest .btnNav.swiper-button-disabled {display:none;}
.onlyMe .sympathyTest .btnGroup {position:absolute; left:0; bottom:7.9%; padding:0 1.56%;}
.onlyMe .sympathyTest .btnGroup:after {content:" "; display:block; clear:both;}
.onlyMe .sympathyTest .btnGroup button {position:relative; float:left; width:50%; padding:0 1.6%;}
.onlyMe .sympathyTest .btnGroup .move.btnY {animation:bounce2 .5s .5s 2;}
.onlyMe .sympathyTest .btnGroup .move.btnN {animation:bounce2 .5s .8s 2;}
.onlyMe .sympathyTest .btnGroup button img {background-position:0 0; background-repeat:no-repeat; background-size:100.1% auto;}
.onlyMe .sympathyTest .btnGroup button.current img {background-position:0 100%;}
.onlyMe .sympathyTest .scene01 .btnGroup .btnY img {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol009/m/btn_yes_01.png);}
.onlyMe .sympathyTest .scene02 .btnGroup .btnY img {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol009/m/btn_yes_02.png);}
.onlyMe .sympathyTest .scene03 .btnGroup .btnY img {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol009/m/btn_yes_03.png);}
.onlyMe .sympathyTest .scene04 .btnGroup .btnY img {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol009/m/btn_yes_04.png);}
.onlyMe .sympathyTest .scene05 .btnGroup .btnY img {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol009/m/btn_yes_05.png);}
.onlyMe .sympathyTest .scene06 .btnGroup .btnY img {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol009/m/btn_yes_06.png);}
.onlyMe .sympathyTest .scene07 .btnGroup .btnY img {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol009/m/btn_yes_07.png);}
.onlyMe .sympathyTest .scene01 .btnGroup .btnN img {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol009/m/btn_no_01.png);}
.onlyMe .sympathyTest .scene02 .btnGroup .btnN img {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol009/m/btn_no_02.png);}
.onlyMe .sympathyTest .scene03 .btnGroup .btnN img {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol009/m/btn_no_03.png);}
.onlyMe .sympathyTest .scene04 .btnGroup .btnN img {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol009/m/btn_no_04.png);}
.onlyMe .sympathyTest .scene05 .btnGroup .btnN img {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol009/m/btn_no_05.png);}
.onlyMe .sympathyTest .scene06 .btnGroup .btnN img {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol009/m/btn_no_06.png);}
.onlyMe .sympathyTest .scene07 .btnGroup .btnN img {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol009/m/btn_no_07.png);}
.onlyMe .sympathyTest .count {overflow:hidden; position:absolute; left:0; bottom:2.5%; width:100%; font-size:2rem; font-weight:bold;}
.onlyMe .sympathyTest .count p {float:left; width:50%; text-align:center;}
.onlyMe .sympathyTest .count p strong {position:relative; display:inline-block; padding-left:1.7rem; font:bold 1.2rem/1.9rem arial; color:#8a8a8a; vertical-align:top;}
.onlyMe .sympathyTest .count p strong:after {content:''; display:inline-block; position:absolute; left:0; top:0; width:1.35rem; height:1.75rem; background-position:0 0; background-repeat:no-repeat; background-size:1.35rem auto;}
.onlyMe .sympathyTest .count p.yes strong:after {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol009/m/ico_yes.png);}
.onlyMe .sympathyTest .count p.no strong:after {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol009/m/ico_no.png);}
.onlyMe .sympathyTest .scene03 .deco {overflow:hidden; position:absolute; left:0; bottom:24.5%; width:100%; height:20%;}
.onlyMe .sympathyTest .scene03 .deco span {position:absolute;}
.onlyMe .sympathyTest .scene03 .deco .foot01 {left:25%; bottom:0; z-index:20; width:50%;}
.onlyMe .sympathyTest .scene03 .deco .foot02 {left:16%; bottom:24%; z-index:10; width:68%; opacity:0;}
.onlyMe .sympathyTest .finish .total {position:absolute; left:50%; top:3.7%; z-index:10; width:10.6rem; height:13.8rem; margin-left:5%; padding-top:1.9rem; text-align:center; line-height:1.4; background:url(http://webimage.10x10.co.kr/playing/thing/vol009/m/bg_balloon.png) no-repeat 0 0; background-size:100%;}
.onlyMe .sympathyTest .finish .total strong {color:#ff85bc; font-size:1.3rem; line-height:1.3rem;}
.onlyMe .sympathyTest .finish .btnApply {position:absolute; left:23%; top:6.3%; width:54%; background-color:#ff71b1; transition:all .5s; animation: swinging 2s ease-in-out forwards infinite;}
.onlyMe .sympathyTest .finish .btnApply:after {content:''; display:inline-block; position:absolute; left:0; top:51%; width:100%; height:18%; background:url(http://webimage.10x10.co.kr/playing/thing/vol009/m/txt_apply.png) no-repeat 0 0; background-size:100%;}
.onlyMe .sympathyTest .finish .btnApply.current {background-color:#00be8b;}
.onlyMe .sympathyTest .finish .btnApply.current:after {background-image:url(http://webimage.10x10.co.kr/playing/thing/vol009/m/txt_finish.png);}
.onlyMe .sympathyTest .finish .addMore {position:absolute; left:0; top:0; z-index:10; width:100%; height:100%; background-color:rgba(0,0,0,.55);}
.onlyMe .sympathyTest .finish .addMore p {width:94.25%; margin:0 auto; padding-top:4rem; cursor:pointer;}
@keyframes bounce{
from to {transform:scale(1); animation-timing-function:ease-out;}
50% {transform:scale(1.1); animation-timing-function:ease-in;}
}
@keyframes bounce2 {
	from,to {top:0;}
	50% {top:-5px;}
}
@keyframes bounce3 {
	from,to {margin-right:0;}
	50% {margin-right:-5px;}
}
@keyframes swinging{
	from,to{transform:rotate(-3deg);}
	50%{transform:rotate(5deg)}
}
</style>
<script type="text/javascript">
$(function(){
	var position = $('.onlyMe').offset(); // 위치값
	$('html,body').animate({ scrollTop : position.top },300); // 이동

	var mySwiper = new Swiper(".sympathyTest .swiper-container",{
		speed:600,
		prevButton:'.sympathyTest .btnPrev',
		nextButton:'.sympathyTest .btnNext',
		onSlideChangeStart: function (mySwiper){
			$(".scene03").find(".foot01").delay(10).animate({"margin-bottom":"0"},900);
			$(".scene03").find(".foot02").delay(10).animate({"margin-bottom":"-20px","opacity":"0"},900);
//			$(".btnGroup button").removeClass("move");
			$(".swiper-slide-active.scene03").find(".foot01").delay(30).animate({"margin-bottom":"-32%"},700);
			$(".swiper-slide-active.scene03").find(".foot02").delay(200).animate({"margin-bottom":"0","opacity":"1"},900);
//			$(".swiper-slide-active").find(".btnGroup button").addClass("move");
		}
	});

	$(".addMore").click(function(e) {
		e.preventDefault();
		mySwiper.slideTo(1,800,false);
	});
	$(".btnStart").click(function() {
		$(".sympathyTest .btnNext").click();
	});
	<% if pagereload<>"" then %>
		mySwiper.slideTo(8,800,false);
	<% end if %>
	// title animation
	titleAnimation()
	$(".intro .some").css({"margin-top":"-10px","opacity":"0"});
	function titleAnimation() {
		$(".intro .some").delay(100).animate({"margin-top":"10px", "opacity":"1"},400).animate({"margin-top":"0"},400);
		$(".intro h3").delay(1000).animate({"margin-left":"0", "opacity":"1"},800);
		$(".intro h3 span").delay(1000).animate({"opacity":"1"},800);
	}
});

function jsplayingthing(num, sel){
<%
If myresultCnt > 0 Then
%>
	alert('이미 응모하였습니다.');
	return false;
<%
Else
%>
	var statYcnt = parseInt($("#ex"+sel+"ycnt").text());
	var statNcnt = parseInt($("#ex"+sel+"ncnt").text());

	if(sel == 1) {if($("#tmpex1").val()== num){num=0;$("#tmpex1").val(0);}else{$("#tmpex1").val(num);}}
	if(sel == 2) {if($("#tmpex2").val()== num){num=0;$("#tmpex2").val(0);}else{$("#tmpex2").val(num);}}
	if(sel == 3) {if($("#tmpex3").val()== num){num=0;$("#tmpex3").val(0);}else{$("#tmpex3").val(num);}}
	if(sel == 4) {if($("#tmpex4").val()== num){num=0;$("#tmpex4").val(0);}else{$("#tmpex4").val(num);}}
	if(sel == 5) {if($("#tmpex5").val()== num){num=0;$("#tmpex5").val(0);}else{$("#tmpex5").val(num);}}
	if(sel == 6) {if($("#tmpex6").val()== num){num=0;$("#tmpex6").val(0);}else{$("#tmpex6").val(num);}}
	if(sel == 7) {if($("#tmpex7").val()== num){num=0;$("#tmpex7").val(0);}else{$("#tmpex7").val(num);}}
<%
	If IsUserLoginOK() Then 
		If date() >="2017-02-24" and date() <= "2017-03-12" Then
%>
	$.ajax({
		type: "GET",
		url: "/playing/sub/doEventSubscript76299.asp",
		data: "mode=add&num="+num+"&sel="+sel,
		cache: false,
		success: function(str) {
			str = str.replace("undefined","");
			res = str.split("|");
			if (res[0]=="OK") {
				if(num==1){
					if ($("#ex"+sel+"n").attr("class") == "btnN current" ){
						$("#ex"+sel+"ncnt").text(statNcnt - 1);
						$("#ex"+sel+"n").removeClass("current");
						$("#ex"+sel+"ycnt").text(statYcnt + 1);
						$("#ex"+sel+"y").addClass("current");
					}else if($("#ex"+sel+"y").attr("class") == "btnY current" ){
						$("#ex"+sel+"ycnt").text(statYcnt - 1);
						$("#ex"+sel+"y").removeClass("current");
					}else{
						$("#ex"+sel+"ycnt").text(statYcnt + 1);
						$("#ex"+sel+"y").addClass("current");
					}
				}else if(num==2){
					if ($("#ex"+sel+"y").attr("class") == "btnY current" ){
						$("#ex"+sel+"ycnt").text(statYcnt - 1);
						$("#ex"+sel+"y").removeClass("current");
						$("#ex"+sel+"ncnt").text(statNcnt + 1);
						$("#ex"+sel+"n").addClass("current");
					}else if($("#ex"+sel+"n").attr("class") == "btnN current" ){
						$("#ex"+sel+"ncnt").text(statNcnt - 1);
						$("#ex"+sel+"n").removeClass("current");
					}else{
						$("#ex"+sel+"ncnt").text(statNcnt + 1);
						$("#ex"+sel+"n").addClass("current");
					}
				}else{
					if ($("#ex"+sel+"y").attr("class") == "btnY current" ){
						$("#ex"+sel+"ycnt").text(statYcnt - 1);
						$("#ex"+sel+"y").removeClass("current");	
					}else{
						$("#ex"+sel+"ncnt").text(statNcnt - 1);
						$("#ex"+sel+"n").removeClass("current");	
					}
				}
			} else {
				errorMsg = res[1].replace(">?n", "\n");
				alert(errorMsg );
				return false;
			}
		}
		,error: function(err) {
			alert(err.responseText);
			console.log(err.responseText);
			alert("통신중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
		}
	});
<%
		Else
%>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;	
<%
		End If 
	Else 
		If isApp=1 Then
%>
		parent.calllogin();
		return false;
<%
		Else
%>
		parent.jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
		return false;
<%
		End If 
	End If
End If
%>
}

function jsplayingthingresult(){
<%
If myresultCnt > 0 Then
%>
	alert('이미 응모하였습니다.');
	return false;
<%
End If 

If IsUserLoginOK() Then 
	If date() >="2017-02-24" and date() <= "2017-03-12" Then
%>
	$.ajax({
		type: "GET",
		url: "/playing/sub/doEventSubscript76299.asp",
		data: "mode=result",
		cache: false,
		success: function(str) {
			str = str.replace("undefined","");
			res = str.split("|");
			if (res[0]=="OK") {
				alert('응모가 완료 되었습니다!');
				document.frmcom.submit();
			}else if (res[0] !="OK" && res[1] == 'addvote') {
				$("#addMore").empty().html(res[2]);
				$("#addMore").show();
			} else {
				errorMsg = res[1].replace(">?n", "\n");
				alert(errorMsg );
				return false;
			}
		}
		,error: function(err) {
			console.log(err.responseText);
			alert("통신중 오류가 발생했습니다. 잠시 후 다시 시도해주세요..");
		}
	});
<%
	Else
%>
		alert("이벤트 응모 기간이 아닙니다.");
		return false;	
<%
	End If
Else
	If isApp=1 Then
%>
		parent.calllogin();
		return false;
<%	Else %>
		parent.jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
		return false;
<%
	End if
End If
%>
}

function lyhide(){
	$("#addMore").hide();
}

function logincheck(){
<%
If NOT IsUserLoginOK() Then 
	If isApp=1 Then
%>
		parent.calllogin();
		return false;
<%	Else %>
		parent.jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
		return false;
<%
	End if
End if
%>
}

</script>
<div class="thingVol009 onlyMe">
	<input type="hidden" name="tmpex1" id="tmpex1" value="<%=myex1%>">
	<input type="hidden" name="tmpex2" id="tmpex2" value="<%=myex2%>">
	<input type="hidden" name="tmpex3" id="tmpex3" value="<%=myex3%>">
	<input type="hidden" name="tmpex4" id="tmpex4" value="<%=myex4%>">
	<input type="hidden" name="tmpex5" id="tmpex5" value="<%=myex5%>">
	<input type="hidden" name="tmpex6" id="tmpex6" value="<%=myex6%>">
	<input type="hidden" name="tmpex7" id="tmpex7" value="<%=myex7%>">
	<div id="sympathyTest" class="sympathyTest">
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide intro">
					<p class="some"><img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/txt_sometimes.png" alt="나만 그래" /></p>
					<h3 >
						<img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/tit_only_me.png" alt="나만 그래" />
						<span class="q1"><img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/txt_question_01.png" alt="?" /></span>
						<span class="q2"><img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/txt_question_02.png" alt="?" /></span>
					</h3>
					<p><img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/txt_purpose.png" alt="가끔 이렇지 않아? 나만 그래?라고 친구들과 공감가는 이야기 하지 않나요? 나와 같은 사람들이 얼마나 있는지 함께 공감하고 투표해주시면 기프트하크 2만원권을 드립니다" /></p>
					<div id="btnStart" class="btnStart"><a onclick="logincheck(); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/btn_start.gif" alt="공감 START" /></a></div>
					<p class="noti"><img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/txt_noti.png" alt="한 아이디당 1회 응모" /></p>
				</div>
				<%' 질문1 %>
				<div class="swiper-slide scene01">
					<p><img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/img_scene_01.gif" alt="01.핸드폰을 들고선 핸드폰을 찾은 적 있다!" /></p>
					<div class="btnGroup">
						<button class="btnY<%= Chkiif(myex1=1, " current", "") %>" id="ex1y" onclick="jsplayingthing('1','1'); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/btn_click.png" alt="YES 맞아! 나도그래" /></button>
						<button class="btnN<%= Chkiif(myex1=2, " current", "") %>" id="ex1n" onclick="jsplayingthing('2','1'); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/btn_click.png" alt="NO 아니..너만그래" /></button>
					</div>
					<div class="count">
						<p class="yes"><strong><span id="ex1ycnt"><%= totalex1y %></span>명</strong></p>
						<p class="no"><strong><span id="ex1ncnt"><%= totalex1n %></span>명</strong></p>
					</div>
				</div>
				<%' 질문2 %>
				<div class="swiper-slide scene02">
					<p><img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/img_scene_02.gif" alt="02.여행 갈 때 꼭 필요하지 않은 많은 짐을 가져간다" /></p>
					<div class="btnGroup">
						<button class="btnY<%= Chkiif(myex2=1, " current", "") %>" id="ex2y" onclick="jsplayingthing('1','2'); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/btn_click.png" alt="YES 맞아! 나도그래" /></button>
						<button class="btnN<%= Chkiif(myex2=2, " current", "") %>" id="ex2n" onclick="jsplayingthing('2','2'); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/btn_click.png" alt="NO 아니..너만그래" /></button>
					</div>
					<div class="count">
						<p class="yes"><strong><span id="ex2ycnt"><%= totalex2y %></span>명</strong></p>
						<p class="no"><strong><span id="ex2ncnt"><%= totalex2n %></span>명</strong></p>
					</div>
				</div>
				<%' 질문3 %>
				<div class="swiper-slide scene03">
					<p><img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/img_scene_03.gif" alt="03.이불 덮을 때 발은 요렇게 이불 속으로 넣는다" /></p>
					<div class="deco">
						<span class="foot01"><img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/img_foot.png" alt="" /></span>
						<span class="foot02"><img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/img_foot_02.png" alt="" /></span>
					</div>
					<div class="btnGroup">
						<button class="btnY<%= Chkiif(myex3=1, " current", "") %>" id="ex3y" onclick="jsplayingthing('1','3'); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/btn_click.png" alt="YES 맞아! 나도그래" /></button>
						<button class="btnN<%= Chkiif(myex3=2, " current", "") %>" id="ex3n" onclick="jsplayingthing('2','3'); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/btn_click.png" alt="NO 아니..너만그래" /></button>
					</div>
					<div class="count">
						<p class="yes"><strong><span id="ex3ycnt"><%= totalex3y %></span>명</strong></p>
						<p class="no"><strong><span id="ex3ncnt"><%= totalex3n %></span>명</strong></p>
					</div>
				</div>
				<%' 질문4 %>
				<div class="swiper-slide scene04">
					<p><img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/img_scene_04.gif" alt="04.보도블럭이나 횡단보도 지나갈때 흰선만 밟는다" /></p>
					<div class="btnGroup">
						<button class="btnY<%= Chkiif(myex4=1, " current", "") %>" id="ex4y" onclick="jsplayingthing('1','4'); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/btn_click.png" alt="YES 맞아! 나도그래" /></button>
						<button class="btnN<%= Chkiif(myex4=2, " current", "") %>" id="ex4n" onclick="jsplayingthing('2','4'); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/btn_click.png" alt="NO 아니..너만그래" /></button>
					</div>
					<div class="count">
						<p class="yes"><strong><span id="ex4ycnt"><%= totalex4y %></span>명</strong></p>
						<p class="no"><strong><span id="ex4ncnt"><%= totalex4n %></span>명</strong></p>
					</div>
				</div>
				<%' 질문5 %>
				<div class="swiper-slide scene05">
					<p><img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/img_scene_05.gif" alt="05." /></p>
					<div class="btnGroup">
						<button class="btnY<%= Chkiif(myex5=1, " current", "") %>" id="ex5y" onclick="jsplayingthing('1','5'); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/btn_click.png" alt="YES 맞아! 나도그래" /></button>
						<button class="btnN<%= Chkiif(myex5=2, " current", "") %>" id="ex5n" onclick="jsplayingthing('2','5'); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/btn_click.png" alt="NO 아니..너만그래" /></button>
					</div>
					<div class="count">
						<p class="yes"><strong><span id="ex5ycnt"><%= totalex5y %></span>명</strong></p>
						<p class="no"><strong><span id="ex5ncnt"><%= totalex5n %></span>명</strong></p>
					</div>
				</div>
				<%' 질문6 %>
				<div class="swiper-slide scene06">
					<p><img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/img_scene_06.gif" alt="06." /></p>
					<div class="btnGroup">
						<button class="btnY<%= Chkiif(myex6=1, " current", "") %>" id="ex6y" onclick="jsplayingthing('1','6'); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/btn_click.png" alt="YES 맞아! 나도그래" /></button>
						<button class="btnN<%= Chkiif(myex6=2, " current", "") %>" id="ex6n" onclick="jsplayingthing('2','6'); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/btn_click.png" alt="NO 아니..너만그래" /></button>
					</div>
					<div class="count">
						<p class="yes"><strong><span id="ex6ycnt"><%= totalex6y %></span>명</strong></p>
						<p class="no"><strong><span id="ex6ncnt"><%= totalex6n %></span>명</strong></p>
					</div>
				</div>
				<%' 질문7 %>
				<div class="swiper-slide scene07">
					<p><img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/img_scene_07.gif" alt="07." /></p>
					<div class="btnGroup">
						<button class="btnY<%= Chkiif(myex7=1, " current", "") %>" id="ex7y" onclick="jsplayingthing('1','7'); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/btn_click.png" alt="YES 맞아! 나도그래" /></button>
						<button class="btnN<%= Chkiif(myex7=2, " current", "") %>" id="ex7n" onclick="jsplayingthing('2','7'); return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/btn_click.png" alt="NO 아니..너만그래" /></button>
					</div>
					<div class="count">
						<p class="yes"><strong><span id="ex7ycnt"><%= totalex7y %></span>명</strong></p>
						<p class="no"><strong><span id="ex7ncnt"><%= totalex7n %></span>명</strong></p>
					</div>
				</div>

				<%' 응모하기(질문 5개이상 참여 시 응모가능) %>
				<div class="swiper-slide finish">
					<div class="total">
						<img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/txt_count_01.png" alt="총" style="width:1rem;" />
						<strong><%= totalresultCnt %></strong><img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/txt_count_02.png" alt="명이" style="width:1.9rem;" /><br />
						<img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/txt_count_03.png" alt="응모했습니다" style="width:6.25rem;" />
					</div>
					<%' for dev msg : 질문 5개이상 참여시 버튼에 클래스 current 추가, 질문 5개 이하 참여시 addMore 영역 노출 %>
					<button class="btnApply<%= Chkiif(myresultCnt > 0, " current", "") %>" onclick="jsplayingthingresult(); return false;" id="bApply"><img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/btn_submit.png" alt="응모하기" /></button>
					<div id="addMore" class="addMore" style="display:none;"></div>
					<p><img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/txt_event.png" alt="공감이야기에 투표를 해주시는 분들중 10분에게 추첨을 통해 기프트카드 2만원권을 드립니다" /></p>
					<!--<p><img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/txt_tip.png" alt="당첨 확률 높이는 TIP" /></p>-->
				</div>
			</div>
		</div>
		<button type="button" class="btnNav btnPrev"><img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/btn_prev.png" alt="이전" /></button>
		<button type="button" class="btnNav btnNext"><img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/btn_next.png" alt="다음" /></button>
	</div>
	<div class="vol009"><img src="http://webimage.10x10.co.kr/playing/thing/vol009/m/txt_vol009.png" alt="THING의 사물에 대한 생각 때로는 말보다 손짓이 강하다" /></div>
	<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
	<input type="hidden" name="pagereload" value="on">
	</form>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
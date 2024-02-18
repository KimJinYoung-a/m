<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'####################################################
' Description : 메달 개수를 맞춰라! ver.2
' History : 2018-03-08 정태훈
'####################################################
Dim eCode, userid, SubIdx

IF application("Svr_Info") = "Dev" THEN
	eCode   =  67514
	SubIdx	=	3819702
Else
	eCode   =  85021
	SubIdx	=	9299856
End If

userid = GetEncLoginUserID()

Dim strSql, MedalInfoArr, KorMedalCnt
strSql ="select top 1 sub_opt2 from [db_event].[dbo].[tbl_event_subscript] where sub_idx='"&SubIdx&"'"
dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"EVTMEDAL2",strSql,60*5)
IF Not (rsMem.EOF OR rsMem.BOF) THEN
	MedalInfoArr = rsMem.GetRows()
	if isArray(MedalInfoArr) Then
		KorMedalCnt=MedalInfoArr(0,0)
	End If
Else
	KorMedalCnt=0
END IF
rsMem.close

Dim sqlStr, MedalCnt
sqlStr = "SELECT sub_opt2 FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' And userid='"&userid&"'"
rsget.CursorLocation = adUseClient
rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
IF Not rsget.Eof Then
	MedalCnt = rsget(0)
Else
	MedalCnt=0
End IF
rsget.close

%>
<style type="text/css">
.headline {position:relative;}
.headline h2 {position:absolute; left:0; top:0; width:100%; animation:fly .8s 1 forwards; -webkit-animation:fly .8s 1 forwards;}
.headline span {position:absolute; left:0; top:22%; width:100%; animation:blink 1.7s 1 .8s;}
.event-view .count-view {position:relative; text-align:center;}
.event-view .counter-area {position:absolute; left:50%; top:60%; width:40%; margin-left:-20%; font-size:3.41rem; line-height:4.05rem; font-weight:bold; vertical-align:top;}
.event-input {position:relative;}
.input-box {position:absolute; left:50%; top:26.5%; width:76%; height:30%; margin-left:-38%; background:url(http://webimage.10x10.co.kr/eventIMG/2018/85021/m/bg_input_v4.png) no-repeat 50% 50%; background-size:100% 100%; font-size:2.8rem; line-height:1.2; color:#000; text-align:left; font-weight:bold; vertical-align:top;}
.input-box p {position:absolute; left:10%; top:50%; margin-top:-1.5rem;}
.input-box input[type=number] {width:4rem; height:3rem; margin:0; padding:0; font-size:2.4rem; line-height:1.2; letter-spacing:-2px; font-family:verdana, sans-serif; color:#000; text-align:right; font-weight:500; cursor:none; vertical-align:top; border:0; border-radius:0;}
.input-box button {position:absolute; right:0; top:0; height:100%; background-color:transparent; outline:none;}
.input-box button img {width:auto; height:100%;}
.noti {padding:4.27rem 2.56rem 4.86rem; background-color:#151a1d;}
.noti h3 {position:relative; color:#fff; font-size:1.62rem; font-weight:bold; text-align:center;}
.noti h3:after {content:' '; display:block; position:absolute; bottom:-0.6rem; left:50%; width:6.78rem; height:2px; margin-left:-3.39rem; background-color:#de8e50;}
.noti ul {margin-top:2.39rem;}
.noti ul li {position:relative; padding-left:1rem; margin:0.65rem 0; color:#eaf7fb; font-size:1.11rem; line-height:1.688em;}
.noti ul li:after {content:'·'; display:block; position:absolute; top:.05rem; left:0; color:#eaf7fb;}
.noti ul li:first-child {margin-top:0;}
.event-view div.real-num  p {position:absolute; left:50%; top:72%; width:40%; margin-left:-20%; padding-top:1rem; border-top:1px solid #c1cacc; color:#7a7a7a; font-size:1.02rem;}
.event-view div.mine-num {color:#fff;}
.event-view div.mine-num .counter-area {top:63%;}
.event-view .count-view .counter, .event-view .count-view .counter2 {display:inline-block; vertical-align:top; font-weight:bold; text-align:right; font-size:4.05rem; font-family:verdana, sans-serif; margin-top:-0.25rem;}

@keyframes fly {
	from {top:2rem; margin-left:-5rem; opacity:0;}
	to {top:0; margin-left:0; opacity:1;}
}
@keyframes  blink {
	0%, 100% {opacity:0;}
	10%, 30%, 50%, 70%, 90% {opacity:1;}
	20%, 40%, 60%, 80% {opacity:0;}
}
</style>
<script type="text/javascript">
<!--
	function fnGoEnter(){
	<% If now() > #03/08/2018 00:00:00# and now() < #03/17/2018 23:59:59# then %>
		var medalcnt=$("#counting").val();
		var str = $.ajax({
			type: "POST",
			url: "/event/etc/doEventSubscript85021.asp",
			data: "mode=add&medalcnt="+medalcnt,
			dataType: "text",
			async: false
		}).responseText;
		var str1 = str.split("|")
		if (str1[0] == "11"){
			alert('응모가 완료되었습니다.');
			$("#mymedal").empty().append('<div class="counter2">' + medalcnt + '</div> 개');
			return false;
		}else if (str1[0] == "12"){
			alert('이벤트 기간이 아닙니다.');
			return false;
		}else if (str1[0] == "13"){
			alert('메달 개수는 하루에 한번 수정 가능합니다.');
			return false;
		}else if (str1[0] == "02"){
			alert('로그인 후 참여 가능합니다.');
			return false;
		}else if (str1[0] == "01"){
			alert('잘못된 접속입니다.');
			return false;
		}else if (str1[0] == "00"){
			alert('정상적인 경로가 아닙니다.');
			return false;
		}else{
			alert('오류가 발생했습니다.');
			return false;
		}
	<% Else %>
		alert("이벤트 기간이 아닙니다.");
		return;
	<% End If %>
	}
	function fnlogin(){
	<% if isApp=1 then %>
		parent.calllogin();
		return false;
	<% else %>
		parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
		return false;
	<% end if %>
	}
//-->
</script>
			<div class="mEvt85021">
				<div class="headline">
					<h2><img src="http://webimage.10x10.co.kr/eventIMG/2018/85021/m/tit_medal.png" alt="메달갯수를 맞혀라" /></h2>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2018/85021/m/tit_medal_ver2.png" alt="메달갯수를 맞혀라" /></span>
					<img src="http://webimage.10x10.co.kr/eventIMG/2018/85021/m/bg_headline.png" alt="우리나라 메달 최종 총 개수를 맞추신 분들께 메달 개수 x 100마일리지 적립!" />
				</div>
				<div class="event-view">
					<div class="count-view real-num">
						<div class="counter-area">
							<div class="counter"><%=KorMedalCnt%></div> 개
						</div>
						<p>
							<% If hour(now()) >= 10 Then %>
								3월 <%=day(now())%>일 오전 10시 기준
							<% Else %>
								3월 <%=day(dateadd("d",-1,now()))%>일 오전 10시 기준
							<% End If %>
						</p>
						<img src="http://webimage.10x10.co.kr/eventIMG/2018/85021/m/img_real.png" alt="현재 우리나라 총 메달 개수" />
					</div>
					<div class="count-view mine-num">
						<div class="counter-area" id="mymedal">
							<div class="counter2"><%=MedalCnt%></div> 개
						</div>
						<img src="http://webimage.10x10.co.kr/eventIMG/2018/85021/m/img_mine.png" alt="내가 예상하는 메달 개수" />
					</div>
				</div>
				<div class="event-input">
					<form action="" method="" name="" id="">
						<div class="input-box">
							<p><input type="number" id="counting" name="medalcnt" maxlength="3" style="background:url('http://webimage.10x10.co.kr/eventIMG/2018/85021/m/cursor.gif') 100% 50% no-repeat; background-size:auto 100%;" onFocus="this.style.backgroundImage='url(none)';" /> 개</p>
							<% If userid<>"" Then %>
								<% If MedalCnt <> 0 Then %>
									<button type="button" onClick="fnGoEnter();"><img src="http://webimage.10x10.co.kr/eventimg/2018/85021/m/btn_edit_v6.png" alt="수정하기" /></button>
								<% Else %>
									<button type="button" onClick="fnGoEnter();"><img src="http://webimage.10x10.co.kr/eventIMG/2018/85021/m/btn_input_v5.png" alt="입력하기" /></button>
								<% End If %>
							<% Else %>
								<button type="button" onClick="fnlogin();"><img src="http://webimage.10x10.co.kr/eventIMG/2018/85021/m/btn_input_v5.png" alt="입력하기" /></button>
							<% End If %>
						</div>
					</form>
					<img src="http://webimage.10x10.co.kr/eventIMG/2018/85021/m/txt_event.png" alt="예상하는 우리나라 최종 메달 개수는?" />
				</div>
				<div class="noti">
					<div class="inner">
						<h3>유의사항</h3>
						<ul>
							<li>우리나라 총 메달 개수는 매일 오전 10시에 집계됩니다. (휴일 제외)</li>
							<li>예상하는 메달 개수는 3월 17일 토요일 자정까지 최종 수정 가능합니다.</li>
							<li>우리나라 총 메달 개수는 3월 18일까지 집계된 우리나라의 금, 은, 동메달의 개수로 결과를 냅니다.</li>
							<li>이벤트 당첨자는 3월 19일, 마일리지가 지급 될 예정입니다.</li>
						</ul>
					</div>
				</div>
			</div>

			<script type="text/javascript">
			$(function() {
//				var position = $('.real-num').offset();
//				$('html,body').delay(800).animate({ scrollTop : (position.top)+22 },1500);

				setTimeout(function(){
					$(".counter").rollingCounter({
						animate : true,
						attrCount : 'data-count',
						delayTime : 15 ,
						waitTime : 1 ,
						duration : 800
					});
				}, 1500);

				setTimeout(function(){
					$(".counter2").rollingCounter({
						animate : true,
						attrCount : 'data-count',
						delayTime : 20 ,
						waitTime : 12,
						duration : 900
					});
				}, 2500);
			});
			</script>
<% If userid="corpse2" Or userid="ley330" Or userid="greenteenz" or userid="motions" or userid="yangpa" Then %>
<script type="text/javascript">
<!--
	function fnGoKorMedalEnter(){
		var medalcnt=$("#totalmedal").val();
		var str = $.ajax({
			type: "POST",
			url: "/event/etc/doEventSubscript85021.asp",
			data: "mode=edit&medalcnt="+medalcnt,
			dataType: "text",
			async: false
		}).responseText;
		var str1 = str.split("|")
		if (str1[0] == "11"){
			alert('메달 개수 수정이 완료 되었습니다.');
			location.reload();
			return false;
		}else if (str1[0] == "12"){
			alert('이벤트 기간이 아닙니다.');
			return false;
		}else if (str1[0] == "01"){
			alert('잘못된 접속입니다.');
			return false;
		}else if (str1[0] == "00"){
			alert('정상적인 경로가 아닙니다.');
			return false;
		}else{
			alert('오류가 발생했습니다.');
			return false;
		}
	}
//-->
</script>
<br><br>
<p>관리자 메달 개수 입력 :</p>
		<p><input type="number" id="totalmedal" maxlength="3" style="background:url('http://webimage.10x10.co.kr/eventIMG/2018/84256/m/cursor.gif') 100% 50% no-repeat; background-size:auto 100%;" onFocus="this.style.backgroundImage='url(none)';" /> 개&nbsp;&nbsp;&nbsp;<button type="button" onClick="fnGoKorMedalEnter();">입력</button></p>
			
<% End If %>
<!-- #include virtual="/lib/db/dbclose.asp" -->
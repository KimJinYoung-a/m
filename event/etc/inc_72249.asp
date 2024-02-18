<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
Dim eCode, vUserId, eventPossibleDate
Dim strSql, totcnt, todaycnt
Dim prize1 : prize1 = 0
Dim prize2 : prize2 = 0 
Dim prize3 : prize3 = 0 
dim currenttime, toDate
currenttime =  now()
toDate		= date()
vUserId = GetEncLoginUserID()

IF application("Svr_Info") = "Dev" THEN
	eCode 		= "66179"
	If not( left(currenttime,10) >= "2016-08-04" and left(currenttime,10) <= "2016-08-14" ) Then 
		eventPossibleDate = False
	Else
		eventPossibleDate = True
	End If
Else
	eCode 		= "72249"
	If not( left(currenttime,10) >= "2016-08-08" and left(currenttime,10) <= "2016-08-14" ) Then 
		eventPossibleDate = False
	Else
		eventPossibleDate = True
	End If
End If

If IsUserLoginOK Then 
	'// 출석 여부
	strSql = ""
	strSql = strSql & " SELECT isnull(sum(CASE WHEN convert(varchar(10), t.regdate, 120) = '"& toDate &"' THEN 1 ELSE 0 END ),0) as todaycnt "
	strSql = strSql & " ,count(*) as totcnt "
	strSql = strSql & " FROM db_temp.[dbo].[tbl_event_attendance] as t "
	strSql = strSql & " INNER JOIN db_event.dbo.tbl_event as e "
	strSql = strSql & " on t.evt_code = e.evt_code and convert(varchar(10),t.regdate,120) between convert(varchar(10),e.evt_startdate,120) and convert(varchar(10),e.evt_enddate,120) "
	strSql = strSql & "	WHERE t.userid = '"& vUserId &"' and t.evt_code = '"& eCode &"' " 
	rsget.Open strSql,dbget,1
	IF Not rsget.Eof Then
		todaycnt = rsget("todaycnt") '// 오늘 출석 여부 1-ture 0-false
		totcnt = rsget("totcnt") '// 내 전체 출석수
	End IF
	rsget.close()

	'// 각 상품 응모 여부
	strSql = ""
	strSql = strSql & " SELECT "
	strSql = strSql & "	isnull(sum(case when sub_opt1 = 2 THEN 1 else 0 end),0) as prize1 "
	strSql = strSql & "	,isnull(sum(case when sub_opt1 = 5 THEN 1 else 0 end),0) as prize2 "
	strSql = strSql & "	,isnull(sum(case when sub_opt1 = 7 THEN 1 else 0 end),0) as prize3  "
	strSql = strSql & "	FROM db_event.dbo.tbl_event_subscript "
	strSql = strSql & "	WHERE evt_code = '"& eCode &"' and userid = '"& vUserId &"' "
	rsget.Open strSql,dbget,1
	IF Not rsget.Eof Then
		prize1	= rsget("prize1")	'// 2일차 응모
		prize2	= rsget("prize2")	'//	5일차 응모
		prize3	= rsget("prize3")	'//	7일차 응모
	End IF
	rsget.close()
End If 
%>
<style type="text/css">
img {vertical-align:top;}

.catchMosquito {overflow:hidden;}
.catchMosquito button {background-color:transparent;}

.catch {position:relative;}
.catch .topic {position:absolute; top:5.94%; left:6.56%; width:87.5%;}
.catch h3 {position:absolute; bottom:11.69%; left:0; z-index:5; width:100%;}
.catch .light {position:absolute; top:42.4%; left:-10%; width:74%;}
.catch .light {
	animation-name:move; animation-iteration-count:2; animation-duration:10s; animation-delay:5s;
	-webkit-animation-name:move; -webkit-animation-iteration-count:2; -webkit-animation-duration:10s; -webkit-animation-delay:5s;
}
@keyframes move {
	from, to{top:42.4%; left:-10%;}
	50% {top:20%; left:50%;}
}
@-webkit-keyframes move {
	from, to{top:42.4%; left:-10%;}
	50% {top:20%; left:50%;}
}
.catch .btnClick {position:absolute; bottom:17.84%; left:37.3%; width:28.43%;}
.catch .btnClick .flyswatter img {
	animation-name:pulse; animation-duration:1s; animation-iteration-count:2; animation-delay:2s;
	-webkit-animation-name:pulse; -webkit-animation-duration:1s; -webkit-animation-iteration-count:2; -webkit-animation-delay:2s;
}
.catch .btnClick:active .flyswatter img {
	animation-name:pulse; animation-duration:1s; animation-iteration-count:infinite;
	-webkit-animation-name:pulse; -webkit-animation-duration:1s; -webkit-animation-iteration-count:infinite;
}
@keyframes pulse {
	0% {transform:scale(1);}
	50% {transform:scale(0.9);}
	100% {transform:scale(1);}
}
@-webkit-keyframes pulse {
	0% {-webkit-transform:scale(1);}
	50% {-webkit-transform:scale(0.9);}
	100% {-webkit-transform:scale(1);}
}

.catch .btnClick .word {position:absolute; top:17.1%; left:16.48%; z-index:5; width:54.94%;}
.catch .btnClick .word {
	animation-name:flash; animation-duration:2s; animation-fill-mode:both; animation-iteration-count:5;
	-webkit-animation-name:flash; -webkit-animation-duration:2s; -webkit-animation-fill-mode:both; -webkit-animation-iteration-count:5;
}
@keyframes flash {
	0%, 50%, 100% {opacity:1;}
	25%, 75% {opacity:0;}
}
@-webkit-keyframes flash {
	0%, 50%, 100% {opacity:1;}
	25%, 75% {opacity:0;}
}

.catch .mosquito {position:absolute; top:30.76%; left:24.68%; width:16.09%;}
.catch .mosquito span img {background:url(http://webimage.10x10.co.kr/eventIMG/2016/72249/m/img_mosquito_01.png) no-repeat 0 0; background-size:100% auto;}
.catch .mosquito .on img {background-position:0 100%;}
.catch .mosquito2 {top:48.71%; left:11.09%;}
.catch .mosquito2 span img {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/72249/m/img_mosquito_02.png);}
.catch .mosquito3 {top:65.4%; left:13.28%;}
.catch .mosquito3 span img {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/72249/m/img_mosquito_03.png);}
.catch .mosquito4 {top:33.94%; left:50.78%;}
.catch .mosquito4 span img {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/72249/m/img_mosquito_04.png);}
.catch .mosquito5 {top:28.2%; left:71.09%;}
.catch .mosquito5 span img {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/72249/m/img_mosquito_05.png);}
.catch .mosquito6 {top:40.51%; left:83.125%;}
.catch .mosquito6 span img {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/72249/m/img_mosquito_06.png);}
.catch .mosquito7 {top:56.82%; left:74.06%;}
.catch .mosquito7 span img {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/72249/m/img_mosquito_07.png);}

.flying {
	animation-name:flying; animation-iteration-count:10; animation-duration:1.5s; animation-delay:4s;
	-webkit-animation-name:flying; -webkit-animation-iteration-count:10; -webkit-animation-duration:1.5s; -webkit-animation-delay:4s;
}
@keyframes flying {
	from, to{margin-left:0; animation-timing-function:ease-out;}
	50% {margin-left:5px; animation-timing-function:ease-in;}
}
@-webkit-keyframes flying {
	from, to{margin-left:0; -webkit-animation-timing-function:ease-out;}
	50% {margin-left:5px; -webkit-animation-timing-function:ease-in;}
}
.flying2 {
	animation-name:flying2; animation-iteration-count:10; animation-duration:1.5s; animation-delay:4.2s;
	-webkit-animation-name:flying2; -webkit-animation-iteration-count:10; -webkit-animation-duration:1.5s; -webkit-animation-delay:4.2s;
}
@keyframes flying2 {
	from, to{margin-top:0; animation-timing-function:ease-out;}
	50% {margin-top:5px; animation-timing-function:ease-in;}
}
@-webkit-keyframes flying2 {
	from, to{margin-top:0; -webkit-animation-timing-function:ease-out;}
	50% {margin-top:5px;-webkit- animation-timing-function:ease-in;}
}

.catch .count {position:absolute; bottom:6.15%; left:0; width:100%; color:#fff; font-weight:bold; text-align:center;}
.catch .count p {font-size:1.2rem;}
.catch .count b {color:#ffef68; padding-bottom:2px; border-bottom:1px solid #ffef68;}

.gift {padding-bottom:12%; background-color:#a6dce6;}
.gift ol {overflow:hidden; padding:0 3.2%;}
.gift ol li {float:left; position:relative; width:33.333%; padding:0 0.3%;}
.gift ol li button {position:absolute; bottom:10.78%; left:50%; width:87.4%; margin-left:-43.7%;}

.noti {padding:6% 1.3rem; background-color:#f7f7f7;}
.noti h3 {margin-left:0.85rem; color:#122b6e; font-size:1.4rem; font-weight:bold;}
.noti h3 span {padding-bottom:1px; border-bottom:2px solid #122b6e;}
.noti ul {margin-top:1.5rem;}
.noti ul li {position:relative; margin-top:0.3rem; padding-left:1rem; color:#444; font-size:1rem; line-height:1.688em;}
.noti ul li:first-child {margin-top:0;}
.noti ul li:after {content:' '; display:block; position:absolute; top:0.7rem; left:0; width:0.4rem; height:0.1rem; background-color:#444;}
.noti ul li b {color:#213f9e; font-weight:normal;}
</style>
<script type="text/javascript" src="http://www.10x10.co.kr/lib/js/jquery-ui-1.10.3.custom.min.js"></script>
<script type="text/javascript">
$(function(){
	/* title animation */
	function animation() {
		$("#animation").delay(100).effect("shake", {direction:"center", times:3, easing:"easeInOutCubic"},600);
	}
	animation();
});

<%''// 출석체크 %>
function jsdailychk(){
<% If IsUserLoginOK() Then %>
	<% If eventPossibleDate = False Then %>
		alert('이벤트 응모 기간이 아닙니다.');
		return;
	<% Else %>
		var result;
		$.ajax({
			type:"GET",
			url:"/event/etc/doeventsubscript/doEventSubscript72249.asp",
			data: "mode=daily",
			dataType: "text",
			async:false,
			cache:false,
			success : function(Data){
				result = jQuery.parseJSON(Data);
				if (result.resultcode=="22"){
					alert('하루에 한번만 모기를 잡을 수 있습니다.');
					return;
				}else if (result.resultcode=="44"){
					alert('로그인이 필요한 서비스 입니다.');
					return;
				}else if (result.resultcode=="11"){
					alert('오늘의 모기를 잡았습니다.');
					location.reload();
					return;
				}else if (result.resultcode=="88"){
					alert('이벤트 응모 기간이 아닙니다.');
					return;
				}
			}
		});
	<% End If %>
<% Else %>
	<% if isApp=1 then %>
		calllogin();
		return false;
	<% else %>
		jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
		return false;
	<% end if %>
	return false;
<% End IF %>
}

<%''// 응모 %>
function jsCatches(v){
<% If IsUserLoginOK() Then %>
	<% If eventPossibleDate = False Then %>
		alert('이벤트 응모 기간이 아닙니다.');
		return;
	<% Else %>
		var result;
		$.ajax({
			type:"GET",
			url:"/event/etc/doeventsubscript/doEventSubscript72249.asp",
			data: "mode=mogis&catches="+v,
			dataType: "text",
			async:false,
			cache:false,
			success : function(Data){
				result = jQuery.parseJSON(Data);
				if (result.resultcode=="77"){
					alert('응모가 완료 되었습니다.\n마일리지는 8월 17일에\n일괄 지급될 예정입니다.');
					location.reload();
					return;
				} else if (result.resultcode=="11"){
					alert('응모가 완료되었습니다.\n당첨자는 추첨을통해\n8월 17일에 발표할 예정입니다.');
					location.reload();
					return;
				} else if (result.resultcode=="33"){
					alert('모기를 더 잡아주세요.');
					return;
				} else if (result.resultcode=="88"){
					alert('이벤트 응모 기간이 아닙니다.');
					return;
				} else if (result.resultcode=="99"){
					alert('이미 응모 하셨습니다.\n감사합니다.');
					return;
				}else if (result.resultcode=="44"){
					alert('로그인이 필요한 서비스 입니다.');
					return;
				}else if (result.resultcode=="66"){
					alert('잘못된 접속입니다.');
					return;
				}
			}
		});
	<% End If %>
<% Else %>
	<% if isApp=1 then %>
		calllogin();
		return false;
	<% else %>
		jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
		return false;
	<% end if %>
	return false;
<% End IF %>
}
</script>
<div class="mEvt72249 catchMosquito">
	<div class="catch">
		<p id="animation" class="topic"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72249/m/txt_catch_mosquito.png" alt="매일 모기잡고 다양한 경품에 응모하세요! 모기다잉~" /></p>

		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/72249/m/tit_click_everyday.png" alt="매일 한 번씩 모기채를 클릭해주세요!" /></h3>

		<div class="light"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72249/img_light.png" alt="" /></div>
<%
	If eventPossibleDate = False Then 
%>
		<button type="button" class="btnClick">
			<span class="flyswatter"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72249/m/btn_fly_swatter.png" alt="모기채" /></span>
		</button>
<%
	Else 
		If todaycnt = 0 then 
		' for dev msg : 버튼 클릭 후 버튼은 숨겨주세요. 
%>
		<button type="button" class="btnClick" onclick="jsdailychk(); return false;">
			<span class="word"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72249/m/txt_click.png" alt="Click" /></span>
			<span class="flyswatter"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72249/m/btn_fly_swatter.png" alt="모기채" /></span>
		</button>
<%
		Else
%>
		<button type="button" class="btnClick">
			<span class="flyswatter"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72249/m/btn_fly_swatter.png" alt="모기채" /></span>
		</button>
<%
		End If
	End If
%>
		<%' for dev msg : 버튼 클릭시 모기에 클래스 on 붙여주세요 %>
		<span class="mosquito mosquito1 flying2"><span <%= Chkiif(totcnt >= 1, " class='on'", "") %>><img src="http://webimage.10x10.co.kr/eventIMG/2016/72249/m/img_mosquito_white.png" alt="모기 하나" /></span></span>
		<span class="mosquito mosquito2 flying"><span <%= Chkiif(totcnt >= 2, " class='on'", "") %>><img src="http://webimage.10x10.co.kr/eventIMG/2016/72249/m/img_mosquito_white.png" alt="모기 둘" /></span></span>
		<span class="mosquito mosquito3 flying2"><span <%= Chkiif(totcnt >= 3, " class='on'", "") %>><img src="http://webimage.10x10.co.kr/eventIMG/2016/72249/m/img_mosquito_white.png" alt="모기 셋" /></span></span>
		<span class="mosquito mosquito4 flying"><span <%= Chkiif(totcnt >= 4, " class='on'", "") %>><img src="http://webimage.10x10.co.kr/eventIMG/2016/72249/m/img_mosquito_white.png" alt="모기 넷" /></span></span>
		<span class="mosquito mosquito5 flying"><span <%= Chkiif(totcnt >= 5, " class='on'", "") %>><img src="http://webimage.10x10.co.kr/eventIMG/2016/72249/m/img_mosquito_white.png" alt="모기 다섯" /></span></span>
		<span class="mosquito mosquito6 flying2"><span <%= Chkiif(totcnt >= 6, " class='on'", "") %>><img src="http://webimage.10x10.co.kr/eventIMG/2016/72249/m/img_mosquito_white.png" alt="모기 여섯" /></span></span>
		<span class="mosquito mosquito7 flying2"><span <%= Chkiif(totcnt >= 7, " class='on'", "") %>><img src="http://webimage.10x10.co.kr/eventIMG/2016/72249/m/img_mosquito_white.png" alt="모기 일곱" /></span></span>
		<%' for dev msg : 모기 잡은 횟수 카운트 %>
		<% If vUserId <> "" Then %>
		<div class="count">
			<p><b><%= vUserId %></b> 님이 총 <b><%= totcnt %></b> 마리의 모기를 잡았습니다.</p>
		</div>
		<% End If %>
		<img src="http://webimage.10x10.co.kr/eventIMG/2016/72249/m/bg_room.jpg" alt="" />
	</div>

	<div class="gift">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/72249/m/tit_gift.png" alt="모기 잡고 선물 받기 잡은 모기의 수만큼 응모하실 수 있어요!" /></h3>
		<ol>
			<li>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/72249/m/img_gift_01.jpg" alt="모기 2마리를 잡고 응모하신 모든 분께 100마일리지를 드립니다." /></p>
		<% If totcnt < 2 Then %>
				<button type="button" onclick="alert('모기를 더 잡아주세요.');"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72249/m/btn_apply_disable.png" alt="신청하기x" /></button>
		<% Else %>
			<% If prize1 = 1 Then %>
				<button type="button" onclick="alert('이미 신청하셨습니다.\n감사합니다.');"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72249/m/btn_apply_done.png" alt="신청완료" /></button>
			<% Else %>
				<button type="button" onclick="jsCatches('2'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72249/m/btn_apply.png" alt="신청하기" /></button>
			<% End If %>
		<% End If %>
			</li>
			<li>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/72249/m/img_gift_02.jpg" alt="모기 5마리를 잡고 응모하신 분께는 추첨을 통해 500분께 모기 기피제를 드립니다." /></p>
		<% If totcnt < 5 then %>
			<button type="button" onclick="alert('모기를 더 잡아주세요.');"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72249/m/btn_enter_disable.png" alt="응모하기x" /></button>
		<% Else %>
			<% If prize2 = 1 Then %>
				<button type="button" onclick="alert('이미 응모하셨습니다.\n감사합니다.');"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72249/m/btn_enter_done.png" alt="응모완료" /></button>
			<% Else %>
				<button type="button" onclick="jsCatches('5'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72249/m/btn_enter.png" alt="응모하기" /></button>
			<% End If %>
		<% End If %>
			</li>
			<li>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/72249/m/img_gift_03.jpg" alt="모기 7마리를 잡고 응모하신 모든 분께 700마일리지를 드립니다." /></p>
		<% If totcnt < 7 Then %>
				<button type="button" onclick="alert('모기를 더 잡아주세요.');"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72249/m/btn_apply_disable.png" alt="신청하기x" /></button>
		<% Else %>
			<% If prize3 = 1 Then %>
				<button type="button" onclick="alert('이미 신청하셨습니다.\n감사합니다.');"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72249/m/btn_apply_done.png" alt="신청완료" /></button>
			<% Else %>
				<button type="button" onclick="jsCatches('7'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72249/m/btn_apply.png" alt="신청하기" /></button>
			<% End If %>
		<% End If %>
			</li>
		</ol>
	</div>

	<div class="noti">
		<h3><span>이벤트 유의사항</span></h3>
		<ul>
			<li><b>하루 한 마리</b>의 모기만 잡을 수 있습니다.</li>
			<li>모기 잡은 개수에 따라서 각 경품에 응모 및 신청할 수 있습니다.</li>
			<li>이벤트 기간 후에 응모하실 수 없습니다.</li>
			<li>이벤트를 통해 받으실 마일리지는 <b>2016년 8월 17일(수요일)에 일괄 지급</b>됩니다.</li>
			<li>당첨자 안내 공지는 2016년 8월 17일(수요일)에 진행됩니다.</li>
		</ul>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
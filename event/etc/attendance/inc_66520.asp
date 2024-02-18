<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 2015 주년이벤트 - 출석 체크
' History : 2015-10-02 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
Dim eCode , userid
Dim strSql , totcnt , todaycnt
Dim prize1 : prize1 = 0
Dim prize2 : prize2 = 0 
Dim prize3 : prize3 = 0 
Dim prize4 : prize4 = 0 
Dim prize5 : prize5 = 0 
Dim prize6 : prize6 = 0
Dim win1 , win2 , win3 , win4 , win5 , win6
	
	userid = GetEncLoginUserID()

IF application("Svr_Info") = "Dev" THEN
	eCode   =  64908
Else
	eCode   =  66520
End If

	If IsUserLoginOK Then 
		'// 출석 여부
		strSql = "select "
		strSql = strSql & " isnull(sum(case when convert(varchar(10),t.regdate,120) = '"& Date() &"' then 1 else 0 end ),0) as todaycnt "
		strSql = strSql & " , count(*) as totcnt "
		strSql = strSql & " from db_temp.[dbo].[tbl_event_attendance] as t "
		strSql = strSql & " inner join db_event.dbo.tbl_event as e "
		strSql = strSql & " on t.evt_code = e.evt_code and convert(varchar(10),t.regdate,120) between convert(varchar(10),e.evt_startdate,120) and convert(varchar(10),e.evt_enddate,120) "
		strSql = strSql & "	where t.userid = '"& userid &"' and t.evt_code = '"& eCode &"' " 
		rsget.Open strSql,dbget,1
		IF Not rsget.Eof Then
			todaycnt = rsget("todaycnt") '// 오늘 출석 여부 1-ture 0-false
			totcnt = rsget("totcnt") '// 전체 응모수
		End IF
		rsget.close()

		'// 응모 여부
		strSql = " select "
		strSql = strSql & "	isnull(sum(case when sub_opt1 = 1 then 1 else 0 end),0) as prize1 , "
		strSql = strSql & "	isnull(sum(case when sub_opt1 = 1 and sub_opt2 = 1 then 1 else 0 end),0) as win1 , "
		strSql = strSql & "	isnull(sum(case when sub_opt1 = 2 then 1 else 0 end),0) as prize2 , "
		strSql = strSql & "	isnull(sum(case when sub_opt1 = 2 and sub_opt2 = 1 then 1 else 0 end),0) as win2 , "
		strSql = strSql & "	isnull(sum(case when sub_opt1 = 3 then 1 else 0 end),0) as prize3 , "
		strSql = strSql & "	isnull(sum(case when sub_opt1 = 3 and sub_opt2 = 1 then 1 else 0 end),0) as win3 , "
		strSql = strSql & "	isnull(sum(case when sub_opt1 = 4 then 1 else 0 end),0) as prize4 , "
		strSql = strSql & "	isnull(sum(case when sub_opt1 = 4 and sub_opt2 = 1 then 1 else 0 end),0) as win4 , "
		strSql = strSql & "	isnull(sum(case when sub_opt1 = 5 then 1 else 0 end),0) as prize5 , "
		strSql = strSql & "	isnull(sum(case when sub_opt1 = 5 and sub_opt2 = 1 then 1 else 0 end),0) as win5 , "
		strSql = strSql & "	isnull(sum(case when sub_opt1 = 6 then 1 else 0 end),0) as prize6 , "
		strSql = strSql & "	isnull(sum(case when sub_opt1 = 6 and sub_opt2 = 1 then 1 else 0 end),0) as win6  "
		strSql = strSql & "	from db_temp.dbo.tbl_event_66520 "
		strSql = strSql & "	where evt_code = '"& eCode &"' and userid = '"& userid &"' "
		rsget.Open strSql,dbget,1
		IF Not rsget.Eof Then
			prize1	= rsget("prize1")	'// 2일차 응모 - 마일리지 200point - 전원지급
			win1	= rsget("win1")		'// 참여여부
			prize2	= rsget("prize2")	'//	5일차 응모 - 새싹키우기(랜덤) - 200명 - 1%
			win2	= rsget("win2")		'// 참여여부
			prize3	= rsget("prize3")	'//	8일차 응모 - 마일리지 300point - 전원지급
			win3	= rsget("win3")		'// 참여여부
			prize4	= rsget("prize4")	'//	11일차 응모 - 기상예측 유리병 - 100명 - 1%
			win4	= rsget("win4")		'// 참여여부
			prize5	= rsget("prize5")	'//	14일차 응모 - 마일리지 500point -  전원지급
			win5	= rsget("win5")		'// 참여여부
			prize6	= rsget("prize6")	'//	17일차 응모 - 샤오미 공기청정기 50명 - 0.1%
			win6	= rsget("win6")		'// 참여여부
		End IF
		rsget.close()
	End If 

	'//js , class 구분
	Dim scnum
	Dim arrcnt : arrcnt = array(2,5,8,11,14,17) '//필요 별 포인트 배열
	Dim prizenum : prizenum = array(prize1,prize2,prize3,prize4,prize5,prize6) '//상품 응모여부 배열
	ReDim strScript(6) , strClass(6)
	For scnum = 1 To 6 '//응모 가짓수
		If totcnt >= arrcnt(scnum-1) Then '//응모 가능 체크
			If prizenum(scnum-1) = 0 Then '//미참여
				strScript(scnum) = "jsattendance("& arrcnt(scnum-1) &");"
				strClass(scnum) = "class=""call"&scnum&" callOk"""
			Else 
				strScript(scnum) = "return false;"
				strClass(scnum) = "class=""call"&scnum&" callEnd"""
			End If 
		Else
			strScript(scnum) = "return false;"
			strClass(scnum) = "class=""call"&scnum&""""
		End If
	Next 
%>
<style type="text/css">
img {vertical-align:top;}
.anniversary14th {background:#d9f4ff;}
.growTree {margin-top:-30px; text-align:center; background:url(http://webimage.10x10.co.kr/eventIMG/2015/14th/66520/m/grow_bg_wave.png) no-repeat 50% 100%; background-size:100% auto;}
.growCanAct {position:relative; padding-bottom:45%;}
.growCanAct strong {display:block; position:absolute; left:50%; top:48%; width:20.625%; margin-left:21%; animation-iteration-count:infinite; animation-duration:1.5s; animation-name:bounce; animation-iteration-count:3;}
@keyframes bounce {
	from, to{margin-top:0; animation-timing-function:ease-out;}
	50% {margin-top:-3px; animation-timing-function:ease-in;}
}
.growCanAct button {display:block; position:absolute; left:50%; top:0; width:26.25%; margin-left:11%; background-color:transparent; z-index:5; cursor:pointer; outline:none;}
.growCanAct button.water {animation:water 2s ease-in-out 0s 1;}
@keyframes water {
	0% {transform:rotate(0);}
	50% {transform:rotate(-8deg);}
	100% {transform:rotate(0);}
}
.growCanAct span {display:block; position:absolute; width:2.96875%;}
.growCanAct span.drop1 {left:50%; top:40%; margin-left:5%;}
.growCanAct span.drop2 {left:50%; top:44%; margin-left:-2%;}
.growCanAct span.drop3 {left:50%; top:54%; margin-left:2%;}
.growCanAct span.drop4 {left:50%; top:61%; margin-left:-3%;}
.growCanAct span.drop5 {left:50%; top:74%; margin-left:1%;}
.growTxt {display:table; position:relative; width:100%; padding-bottom:11.40625%;}
.growTxt p {display:table-cell; position:absolute; left:0; bottom:0; width:100%; height:100%; font-size:11px; line-height:360%; font-weight:bold; vertical-align:middle;}
.growTxt em {margin-left:6px; color:#d50c0c; text-decoration:underline;}
.callWrap {padding:20px 0 35px; background-color:#a79a87; text-align:center;}
.callWrap strong {color:#fff; font-size:11px; text-decoration:underline;}
.chkList {overflow:hidden; width:100%; margin-top:28px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/14th/66520/m/call_chk_bg.png) no-repeat 50% 50%; background-size:100% auto;}
.chkList li {position:relative; float:left; width:33.333%; padding-bottom:49.847%; margin-bottom:1px; background-repeat:no-repeat; background-position:50% 0;}
.chkList li dfn {overflow:hidden; display:block; position:absolute; left:0; top:0; width:100%; height:100%;  text-indent:-999em;}
.chkList li.callOk {background-position:50% 42.4%; cursor:pointer;}
.chkList li.callEnd {background-position:50% 84.7%;}
.chkList .call1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/14th/66520/m/call_chk01.png); background-size:66% auto;}
.chkList .call2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/14th/66520/m/call_chk02.png); background-size:73.3% auto;}
.chkList .call3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/14th/66520/m/call_chk03.png); background-size:66% auto;}
.chkList .call4 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/14th/66520/m/call_chk04.png); background-size:82.1% auto;}
.chkList .call5 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/14th/66520/m/call_chk05.png); background-size:66% auto;}
.chkList .call6 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/14th/66520/m/call_chk06.png); background-size:73.3% auto;}
.caution {padding:20px; background-color:#7e6f5b; color:#fff;}
.caution strong {font-size:13px;}
.caution ul {padding-top:10px;}
.caution ul li {position:relative; padding:3px 0 3px 10px; font-size:10px; line-height:1.2;}
.caution ul li:before {content:''; display:block; position:absolute; left:0; top:8px; width:5px; height:1px; background-color:#fff;}

.callLayer {display:none; position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,.75); z-index:10;}
.layerCont {position:absolute; left:50%; top:180px; width:75%; padding:7.5%; margin-left:-37.5%; background-color:#fff; text-align:center; border-radius:15px; border:3px solid #d60000;}
.layerCont strong {font-size:18px; color:#000;}
.layerCont .giftPhoto {display:block; width:60%; margin:15px auto 0 auto;}
.layerCont .congMsg {font-size:12px; color:#000; font-weight:bold;}
.layerCont .contInfo {font-size:11px; color:#666; line-height:1.4;}
.layerCont .btnLyrClose {border-radius:0;}

@media all and (min-width:375px){
	.growTree {margin-top:-33px;}
	.growTxt p {font-size:12px;}
	.callWrap {padding:22px 0 38px;}
	.callWrap strong {font-size:12px;}
	.chkList {margin-top:30px;}
	.caution strong {font-size:14px;}
	.caution ul {padding-top:11px;}
	.caution ul li {padding:3px 0 3px 11px; font-size:11px;}
	.caution ul li:before {top:8px; width:5px;}
	.layerCont strong {font-size:19px;}
	.layerCont .giftPhoto {margin:16px auto 0 auto;}
	.layerCont .congMsg {font-size:13px;}
	.layerCont .contInfo {font-size:12px;}
}
@media all and (min-width:480px){
	.growTree {margin-top:-45px;}
	.growTxt p {font-size:17px; line-height:450%;}
	.growTxt em {margin-left:9px;}
	.callWrap {padding:30px 0 52px;}
	.callWrap strong {font-size:16px;}
	.chkList {margin-top:42px;}
	.caution {padding:30px;}
	.caution strong {font-size:19px;}
	.caution ul {padding-top:15px;}
	.caution ul li {padding:4px 0 4px 15px; font-size:15px;}
	.caution ul li:before {top:10px; width:7px;}
	.layerCont strong {font-size:27px;}
	.layerCont .giftPhoto {margin:22px auto 0 auto;}
	.layerCont .congMsg {font-size:18px;}
	.layerCont .contInfo {font-size:16px;}
}
</style>
<script>
$(function(){
	$(".growTree span").css({"opacity":"0"});
	$(".growTree button, .growTree strong").click(function(){
	$(".growTree button").addClass("water");
	$(".growTree .drop1").delay(200).animate({"opacity":"1"},500);
	$(".growTree .drop2").delay(300).animate({"opacity":"1"},500);
	$(".growTree .drop3").delay(400).animate({"opacity":"1"},500);
	$(".growTree .drop4").delay(500).animate({"opacity":"1"},500);
	$(".growTree .drop5").delay(600).animate({"opacity":"1"},500);
	});

	$('.chkList .callOk').click(function(){
		$('.callLayer').show();
		window.parent.$('html,body').animate({scrollTop:140}, 300);
	});
});

function clolyr(){
	$('.callLayer').hide();
}

<%' 출석체크 %>
function jsdailychk(){
	<% if Date() < "2015-10-10" or Date() > "2015-10-26" then %>
		alert('이벤트 응모 기간이 아닙니다.');
		return;
	<% else %>
	var result;
		$.ajax({
			type:"GET",
			url:"/event/etc/doeventsubscript/doEventSubscript66520.asp",
			data: "mode=daily",
			dataType: "text",
			async:false,
			cache:false,
			success : function(Data){
				result = jQuery.parseJSON(Data);
				if (result.resultcode=="22")
				{
					alert('매일 한 번 물을 주실 수 있어요!');
					return;
				}
				else if (result.resultcode=="44")
				{
					<% If isapp="1" Then %>
						calllogin();
						return;
					<% else %>
						jsevtlogin();
						return;
					<% End If %>
				}
				else if (result.resultcode=="11")
				{
					setTimeout(function(){
						$(".growCanAct .waterdrops img").attr("src","http://webimage.10x10.co.kr/eventIMG/2015/14th/66520/m/grow_txt_after.png");
					},1500);

					var tcnt = result.Tcnt;
					if (tcnt < 10){ tcnt = "0"+tcnt }
					$(".treeView img").attr("src","http://webimage.10x10.co.kr/eventIMG/2015/14th/66520/m/grow_tree"+tcnt+".png");
					$("#treecnt").text(result.Tcnt+"회");

					$( ".chkList li" ).each( function(index,item){
						if (index == (result.Lcode-1)){
							$(this).attr("class","call"+result.Lcode+" callOk");
							$(this).children('dfn').attr("onclick","jsattendance("+tcnt+");");
						}
					});
					return;
				}
			}
		});
	<% end if %>
	}
<%' 응모 %>
function jsattendance(v){
	<% if date() < "2015-10-10" or date() > "2015-10-26" then %>
		alert('이벤트 응모 기간이 아닙니다.');
		return;
	<% else %>
	var result;
		$.ajax({
			type:"GET",
			url:"/event/etc/doeventsubscript/doEventSubscript66520.asp",
			data: "mode=water&waterdrops="+v,
			dataType: "text",
			async:false,
			cache:false,
			success : function(Data){
				result = jQuery.parseJSON(Data);

				var txt = result.txt;
				if (result.resultcode=="11")
				{
					$(".layerCont").html(txt);
					$(".callLayer").show();
					window.parent.$('html,body').animate({scrollTop:100}, 300);
					$( ".chkList li" ).each( function(index,item){
						if (index == (result.Lcode-1)){
							$(this).removeClass("callOk");
							$(this).addClass("callEnd");
						}
					});
					return;
				}
				else if (result.resultcode=="22")
				{
					$(".layerCont").html(txt);
					$(".callLayer").show();
					window.parent.$('html,body').animate({scrollTop:100}, 300);
					$( ".chkList li" ).each( function(index,item){
						if (index == (result.Lcode-1)){
							$(this).removeClass("callOk");
							$(this).addClass("callEnd");
						}
					});
					return;
				}
				else if (result.resultcode=="33")
				{
					alert('하루 한번 물을 주세요!');
					return;
				}

				else if (result.resultcode=="88")
				{
					alert('이벤트 응모 기간이 아닙니다.');
					return;
				}

				else if (result.resultcode=="99")
				{
					alert('이미 응모 하셨습니다.');
					return;
				}
			}
		});
	<% end if %>
	}
</script>
<div class="anniversary14th">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/14th/66520/m/call_tit.png" alt="출석하고 선물받자 - 매일매일 자란다" /></h2>
	<div class="growTree">
		<div class="growCanAct">
			<strong onclick="jsdailychk();" class="waterdrops"><img src="http://webimage.10x10.co.kr/eventIMG/2015/14th/66520/m/grow_txt<%=chkiif(todaycnt,"_after","")%>.png" alt="<%=chkiif(todaycnt,"내일 또 만나요","하루 한번 CLICK!")%>" /></strong>
			<button onclick="jsdailychk();"><img src="http://webimage.10x10.co.kr/eventIMG/2015/14th/66520/m/grow_can.png" alt="10x10 물뿌리개" /></button>
			<span class="drop1"><img src="http://webimage.10x10.co.kr/eventIMG/2015/14th/66520/m/grow_dropwater.png" alt="물방울1" /></span>
			<span class="drop2"><img src="http://webimage.10x10.co.kr/eventIMG/2015/14th/66520/m/grow_dropwater.png" alt="물방울2" /></span>
			<span class="drop3"><img src="http://webimage.10x10.co.kr/eventIMG/2015/14th/66520/m/grow_dropwater.png" alt="물방울3" /></span>
			<span class="drop4"><img src="http://webimage.10x10.co.kr/eventIMG/2015/14th/66520/m/grow_dropwater.png" alt="물방울4" /></span>
			<span class="drop5"><img src="http://webimage.10x10.co.kr/eventIMG/2015/14th/66520/m/grow_dropwater.png" alt="물방울5" /></span>
		</div>
		<p class="treeView"><% If totcnt > 0 Then %><img src="http://webimage.10x10.co.kr/eventIMG/2015/14th/66520/m/grow_tree<%=chkiif(totcnt < 10 ,"0"&totcnt,totcnt)%>.png" alt="<%=totcnt%>일차 나무" id="tree" /><% Else %><img src="http://webimage.10x10.co.kr/eventIMG/2015/14th/66520/m/grow_tree00.png" alt="나무 시작전" id="tree" /><% End If %></p>
		<% If IsUserLoginOK Then %>
		<div class="growTxt"><p><%=userid%> 님이 물을 준 횟수 <em id="treecnt"><%=totcnt%>회</em></p></div>
		<% Else %>
		<div class="growTxt" onclick="jsdailychk();"><p>로그인을 해주세요! : )</p></div>
		<% End If %>
	</div>
	<div class="callWrap">
		<strong>출석하고 횟수에 따라 선물을 받아가세요!</strong>
		<ul class="chkList">
			<li <%=strClass(1)%>><dfn onclick="<%=strScript(1)%>">2회 출석 - 200마일리지 전원증정</dfn></li>
			<li <%=strClass(2)%>><dfn onclick="<%=strScript(2)%>">5회 출석 - 새싹 키우기(랜덤) 200명 증정</dfn></li>
			<li <%=strClass(3)%>><dfn onclick="<%=strScript(3)%>">8회 출석 - 300마일리지 전원증정</dfn></li>
			<li <%=strClass(4)%>><dfn onclick="<%=strScript(4)%>">11회 출석 - 포그링 가습기(랜덤) 100명 증정</dfn></li>
			<li <%=strClass(5)%>><dfn onclick="<%=strScript(5)%>">14회 출석 - 500마일리지 전원증정</dfn></li>
			<li <%=strClass(6)%>><dfn onclick="<%=strScript(6)%>">17회 출석 - 샤오미 공기청정기 10명 증정</dfn></li>
		</ul>
	</div>
	<div class="caution">
		<strong>유의사항</strong>
		<ul>
			<li>하루에 한 번만 참여할 수 있습니다.</li>
			<li>물을 준 횟수에 따라서 각 미션에 모두 응모할 수 있습니다.</li>
			<li>지급될 마일리지는 2015년 10월 28일 (수)에 일괄 적용됩니다.</li>
			<li>이벤트 경품에 당첨되신 고객님은 2015년 10월 28일 (수)에 배송지 주소를 입력해주세요.</li>
			<li>비정상적인 참여를 할 경우엔, 당첨이 취소될 수 있습니다.</li>
			<li>상품이 당첨되신 분께는 세무신고를 위해 개인정보를 요청할 수 있습니다.</li>
		</ul>
	</div>
	<div class="bnr">
		<ul>
			<% If isapp="1" Then %>
			<li><a href="/apps/appcom/wish/web2014/event/eventmain.asp?eventid=66519"><img src="http://webimage.10x10.co.kr/eventIMG/2015/14th/m/img_bnr_01.jpg" alt="습격자들 5분 동안 텐바이텐을 털어라!" /></a></li>
			<% Else %>
			<li><a href="/event/eventmain.asp?eventid=66519"><img src="http://webimage.10x10.co.kr/eventIMG/2015/14th/m/img_bnr_01.jpg" alt="습격자들 5분 동안 텐바이텐을 털어라!" /></a></li>
			<% End If %>
			<% If isapp="1" Then %>
			<li><a href="/apps/appcom/wish/web2014/event/eventmain.asp?eventid=66518"><img src="http://webimage.10x10.co.kr/eventIMG/2015/14th/m/img_bnr_06.jpg" alt="그것이 알고싶다" /></a></li>
			<% Else %>
			<li><a href="/event/eventmain.asp?eventid=66518"><img src="http://webimage.10x10.co.kr/eventIMG/2015/14th/m/img_bnr_06.jpg" alt="그것이 알고싶다" /></a></li>
			<% End If %>
			<% If isapp="1" Then %>
			<li><a href="/apps/appcom/wish/web2014/event/eventmain.asp?eventid=66712"><img src="http://webimage.10x10.co.kr/eventIMG/2015/14th/m/img_bnr_03.jpg" alt="자꾸 사고 싶은 최대 30프로 할인 쿠폰이 당신을 기다립니다." /></a></li>
			<% Else %>
			<li><a href="/event/eventmain.asp?eventid=66712"><img src="http://webimage.10x10.co.kr/eventIMG/2015/14th/m/img_bnr_03.jpg" alt="자꾸 사고 싶은 최대 30프로 할인 쿠폰이 당신을 기다립니다." /></a></li>
			<% End If %>
		</ul>
	</div>
	<div class="callLayer">
		<div class="layerCont"></div>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
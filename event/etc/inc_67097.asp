<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 모여라 꿈동산
' History : 2015-10-28 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
Dim eCode , userid , i
Dim strSql , totcnt , todaycnt , usercell
Dim todaywinner , contemp
	
	userid = GetEncLoginUserID()

IF application("Svr_Info") = "Dev" THEN
	eCode   =  64941
Else
	eCode   =  67097
End If

	'// 오늘 참여
	strSql = "select count(*) "
	strSql = strSql & " From [db_event].[dbo].[tbl_event_subscript] "
	strSql = strSql & " where evt_code = "& eCode &" and datediff(day,regdate,getdate()) = 0 "
	rsget.CursorLocation = adUseClient
	rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly 
	IF Not rsget.Eof Then
		todaycnt = rsget(0) '// 오늘 응모자
	End IF
	rsget.close()

	'// 예정 당첨자 수
	If todaycnt <= 5000 Then '//응모자 수 기준
		todaywinner = 3 '// 예정 당첨자 수
	ElseIf todaycnt > 5000 And todaycnt <= 10000 Then
		todaywinner = 5
	ElseIf todaycnt > 10000 And todaycnt <= 20000 then	
		todaywinner = 7
	ElseIf todaycnt > 20000 And todaycnt <= 50000 Then
		todaywinner = 10
	ElseIf todaycnt > 50000 Then
		todaywinner = 50	
	Else
		todaywinner = 3
	End If 

	'// 실시간 당첨자 id
	strSql = "SELECT top 5 userid, regdate"
	strSql = strSql & " From [db_event].[dbo].[tbl_event_subscript]"
	strSql = strSql & " where evt_code="& eCode &" and datediff(day,regdate,getdate()) = 0 And sub_opt2 = 1 "
	strSql = strSql & " order by regdate desc"
	'response.write strSql & "<Br>"
	rsget.Open strSql,dbget
	IF not rsget.EOF THEN
		contemp = rsget.getrows()
	END IF
	rsget.close

	If IsUserLoginOK Then
		strSql = "select top 1 usercell "
		strSql = strSql & " From db_user.dbo.tbl_user_n "
		strSql = strSql & " where userid = '"& userid &"'"
		rsget.CursorLocation = adUseClient
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly 
		IF Not rsget.Eof Then
			usercell = rsget(0) '// 오늘 응모자
		End IF
		rsget.close()
	End If 
%>
<style type="text/css">
img {vertical-align:top;}
.mEvt67097 {position:relative;}
.mEvt67097 button {width:100%; vertical-align:top; background:transparent;}
.todayDreamPrd {overflow:hidden; background:url(http://webimage.10x10.co.kr/eventIMG/2015/67097/bg_slash.gif) 0 0 repeat-y; background-size:100% auto;}
.todayDreamPrd .pic {position:relative; width:84%; margin:0 auto 3%; padding:2px; background:#d2d2d2;}
.todayDreamPrd .pic div {padding:1px; background:#fff;}
.todayDreamPrd .pic div img {display:inline-block; padding:1.5px; border:2px solid #e2e2e2;}
.todayDreamPrd .btnNext {display:block; position:absolute; right:-11%; top:-13%; width:30%; z-index:40;}
.situation {padding-bottom:5%; font-size:15px; font-weight:600; color:#000; text-align:center; }
.situation span {display:inline-block; margin:3px 0; border-bottom:1px solid #000;}
.situation strong {color:#e80101; font-size:16px; font-style:italic; padding-right:2px; font-family:arial;}
.realTimeWinner {position:relative; padding:0 3% 3%; background:#ffca63;}
.realTimeWinner .winnerIs {position:relative; background:#fff4d7;}
.realTimeWinner .btnMore {position:absolute; right:2%; top:10px; width:27px; height:27px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/67097/btn_more_down.png) no-repeat 50% 50%; background-size:100% 100%; text-indent:-999em; outline:none;}
.realTimeWinner .btnMore.fold {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/67097/btn_more_up.png);}
.realTimeWinner h3 {position:absolute; left:0; top:0; display:inline-block; width:70px; height:47px; vertical-align:top;}
.realTimeWinner h3 img {height:47px;}
.realTimeWinner li {width:100%; height:47px; font-size:10px; color:#000; letter-spacing:-0.045em; vertical-align:top;}
.realTimeWinner li div {display:table-cell; width:100%; height:47px; padding:5px 0 0 76px; vertical-align:middle;}
.realTimeWinner li:nth-child(even) {background:#fffbf1;}
.realTimeWinner li:first-child {background:#fff4d7;}
.realTimeWinner li .winner {font-size:12px; margin-bottom:4px;}
.realTimeWinner li .winner strong {display:inline-block; line-height:11px; font-weight:normal; color:#b30000; border-bottom:1px solid #b30000;}
.evtNoti {padding:6.5% 8%; text-align:left; background:#e7e7e7;}
.evtNoti h3 {display:inline-block; font-size:15px; padding-left:10px; font-weight:bold; color:#333; margin-bottom:12px;}
.evtNoti li {position:relative; font-size:11px; line-height:1.4; padding:0 0 4px 10px; color:#6e6e6e; }
.evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:4px; width:2px; height:2px; background:#808080;}

/* layer popup */
.dreamLayer {display:none; position:absolute; left:0; top:0; width:100%; height:100%; padding:10% 11% 0; background:rgba(0,0,0,.7); z-index:100;}
.dreamLayer .dreamLayerCont {position:relative; top:24%; display:none;}
.dreamLayer .btnClose {display:inline-block; position:absolute; right:2%; top:1%; width:10%; background:transparent; z-index:100;}
.modNum {padding:0 9% 6%; background:#ffec94;}
.modNum div {position:relative;}
.modNum .num {position:absolute; left:0; top:50%; width:75%; font-size:16px; margin-top:-7px; text-align:center;}
.modNum .btnMod {position:absolute; right:0; top:0; width:25.75%; vertical-align:top;}
.dreamLayer .nextPdt .btnClose {top:9%;}
@media all and (min-width:480px){
	.situation {font-size:23px;}
	.situation span {margin:4px 0; border-bottom:2px solid #000;}
	.situation strong {font-size:24px; padding-right:3px;}
	.realTimeWinner .btnMore {top:15px; width:41px; height:41px;}
	.realTimeWinner h3 {width:110px; height:73px;}
	.realTimeWinner h3 img {height:73px;}
	.realTimeWinner li {font-size:15px; height:73px;}
	.realTimeWinner li div {height:73px; padding:7px 0 0 115px;}
	.realTimeWinner li .winner {font-size:16px; margin-bottom:6px;}
	.realTimeWinner li .winner strong {line-height:17px; border-bottom:2px solid #b30000;}
	.evtNoti h3 {font-size:23px; padding-left:15px; margin-bottom:18px;}
	.evtNoti li {font-size:17px; padding:0 0 6px 15px;}
	.evtNoti li:after {top:6px; width:3px; height:3px;}
	.modNum .num { font-size:24px; margin-top:-11px;}
}
</style>
<script>
<%' 출석체크 %>
function jsevtchk(){
	<% if Date() < "2015-11-02" or Date() > "2015-11-06" then %>
		alert('이벤트 응모 기간이 아닙니다.');
		return;
	<% else %>
	var totcnt;
	var result;
		$.ajax({
			type:"GET",
			url:"/event/etc/doeventsubscript/doEventSubscript67097.asp",
			data: "mode=daily",
			dataType: "text",
			async:false,
			cache:false,
			success : function(Data){
				result = jQuery.parseJSON(Data);
				if (result.resultcode=="22")
				{
					totcnt = result.totcnt;
					$("#totcnt").text(totcnt);
					alert("응모가 완료되었습니다.\n당첨자는 내일 오전에 발표합니다.");
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
					totcnt = result.totcnt;
					$("#totcnt").text(totcnt);
					alert("응모가 완료되었습니다.\n당첨자는 내일 오전에 발표합니다.");
					return;
				}
				else if (result.resultcode=="33")
				{
					alert("오늘은 이미 응모 하셨습니다.");
					return;
				}
				else if (result.stcode=="88")
				{
					alert("이벤트 기간이 아닙니다.");
					return;
				}
			}
		});
	<% end if %>
}

$(function(){
	$('.realTimeWinner li').hide();
	$('.realTimeWinner li:first').show();
	$('.realTimeWinner .btnMore').click(function(){
		if ($(this).hasClass('fold')){
			$(this).removeClass('fold');
			$('.realTimeWinner li:gt(0)').slideUp(500);
		} else {
			$(this).addClass('fold');
			$('.realTimeWinner li:gt(0)').slideDown(500);
		}
	});
	$('.btnNext').click(function(){
		$('.dreamLayer').show();
		$('.dreamLayer .nextPdt').show();
		window.parent.$('html,body').animate({scrollTop:$('.todayDreamPrd').offset().top}, 300);
	});
	$('.btnClose').click(function(){
		$('.dreamLayer').hide();
		$('.dreamLayerCont').hide();
	});
	window.parent.$('html,body').animate({scrollTop:$('.todayDreamPrd').offset().top}, 0);
});

function jsinvite() {
	var result;
	$.ajax({
		type:"GET",
		url: "/event/etc/doeventsubscript/doEventSubscript67097.asp",
		data: "mode=kakao",
		dataType: "text",
		async:false,
		cache:true,
		success : function(Data){
			result = jQuery.parseJSON(Data);
			if (result.stcode=="11")
			{
				alert("이벤트 응모 후 친구 초대를 해주세요.");
				return;
			}
			else if (result.stcode=="22")
			{
				<% if isApp="1" then %>
					parent_kakaolink('[텐바이텐] 모여라 꿈동산\n\n갖고 싶었던 상품을 득템할 기회!\n응모자가 늘어날수록\n당첨자도 함께 많아집니다.\n\n매일 달라지는 기프티콘 당첨의\n행운도 놓치지 마세요!\n\n오직 텐바이텐에서만!\n모여라,꿈동산!' , 'http://webimage.10x10.co.kr/eventIMG/2015/67097/67097_kakao_banner.jpg' , '200' , '200' , 'http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=67097' );
				<% else %>
					parent_kakaolink('[텐바이텐] 모여라 꿈동산\n\n갖고 싶었던 상품을 득템할 기회!\n응모자가 늘어날수록\n당첨자도 함께 많아집니다.\n\n매일 달라지는 기프티콘 당첨의\n행운도 놓치지 마세요!\n\n오직 텐바이텐에서만!\n모여라,꿈동산!' , 'http://webimage.10x10.co.kr/eventIMG/2015/67097/67097_kakao_banner.jpg' , '200' , '200' , 'http://m.10x10.co.kr/event/eventmain.asp?eventid=67097' );
				<% end if %>
			}
			else if (result.stcode=="33")
			{
				<% if isApp="1" then %>
					parent_kakaolink('[텐바이텐] 모여라 꿈동산\n\n갖고 싶었던 상품을 득템할 기회!\n응모자가 늘어날수록\n당첨자도 함께 많아집니다.\n\n매일 달라지는 기프티콘 당첨의\n행운도 놓치지 마세요!\n\n오직 텐바이텐에서만!\n모여라,꿈동산!' , 'http://webimage.10x10.co.kr/eventIMG/2015/67097/67097_kakao_banner.jpg' , '200' , '200' , 'http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=67097' );
				<% else %>
					parent_kakaolink('[텐바이텐] 모여라 꿈동산\n\n갖고 싶었던 상품을 득템할 기회!\n응모자가 늘어날수록\n당첨자도 함께 많아집니다.\n\n매일 달라지는 기프티콘 당첨의\n행운도 놓치지 마세요!\n\n오직 텐바이텐에서만!\n모여라,꿈동산!' , 'http://webimage.10x10.co.kr/eventIMG/2015/67097/67097_kakao_banner.jpg' , '200' , '200' , 'http://m.10x10.co.kr/event/eventmain.asp?eventid=67097' );
				<% end if %>
			}
			else if (result.stcode=="88")
			{
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			}
		}
	});
}
</script>
<!-- 모여라 꿈동산 -->
<div class="mEvt67097">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/tit_dream_hill.gif" alt="모여라 꿈동산" /></h2>
	<div class="todayDreamPrd">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/tit_today_gift_v2.png" alt="오늘의 꿈상품" /></h3>
		<div class="pic">
			<div>
				<% If Date() <= "2015-11-02" Then %>
				<% If isapp = "1" Then %>
					<a href="" onclick="fnAPPpopupProduct('1119270'); return false;">
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1119270">
				<% End If %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/img_today_1102.jpg" alt="스티키몬스터 램프" /></a>
				<% End If %>
				<% If Date() = "2015-11-03" Then %>
				<% If isapp = "1" Then %>
					<a href="" onclick="fnAPPpopupProduct('1197447'); return false;">
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1197447">
				<% End If %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/img_today_1103.jpg" alt="아이리버 블루투스 오디오" /></a>
				<% End If %>
				<% If Date() = "2015-11-04" Then %>
				<% If isapp = "1" Then %>
					<a href="" onclick="fnAPPpopupProduct('1151190'); return false;">
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1151190">
				<% End If %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/img_today_1104.jpg" alt="라비또 빈백" /></a>
				<% End If %>
				<% If Date() = "2015-11-05" Then %>
				<% If isapp = "1" Then %>
					<a href="" onclick="fnAPPpopupProduct('1327818'); return false;">
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1327818">
				<% End If %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/img_today_1105.jpg" alt="인스탁스미니8" /></a>
				<% End If %>
				<% If Date() = "2015-11-06" Then %>
				<% If isapp = "1" Then %>
					<a href="" onclick="fnAPPpopupProduct('1267205'); return false;">
				<% Else %>
					<a href="/category/category_itemPrd.asp?itemid=1267205">
				<% End If %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/img_today_1106.jpg" alt="스마트빔프로젝터" /></a>
				<% End If %>
			</div>
			<% If Date() < "2015-11-06" Then %><button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/btn_next.png" alt="내일의 상품보기" /></button><% End If %>
		</div>
		<div class="winnerCount">
			<% If todaywinner = 3 Then %>
			<img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/img_winner_case01_v2.gif" alt="현재 당첨자:3명" />
			<% End If %>
			<% If todaywinner = 5 Then %>
			<img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/img_winner_case02_v2.gif" alt="현재 당첨자:5명" />
			<% End If %>
			<% If todaywinner = 7 Then %>
			<img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/img_winner_case03_v2.gif" alt="현재 당첨자:6명" />
			<% End If %>
			<% If todaywinner = 10 Then %>
			<img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/img_winner_case04_v2.gif" alt="현재 당첨자:10명" />
			<% End If %>
			<% If todaywinner = 50 Then %>
			<img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/img_winner_case05_v2.gif" alt="현재 당첨자:50명" />
			<% End If %>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/txt_applicant.png" alt="" /></p>
		</div>
		<div class="situation">
			<p><span>현재 <strong id="totcnt"><%=FormatNumber(todaycnt,0)%></strong>명 응모하셨습니다.</span></p>
			<p><span>당첨자는 <strong><%=FormatNumber(todaywinner,0)%></strong>명 입니다.</span></p>
		</div>
		<button type="button" class="btnSubmit" onclick="jsevtchk();"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/btn_submit.gif" alt="응모하기" /></button>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/txt_winner_noti_v2.png" alt="당첨자는 익일 오전에 발표!" /></p>
	</div>
	<div><a href="" onclick="jsinvite();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/btn_kakao_v2.gif" alt="카톡으로 친구 초대하면 당첨확률이 2배!" /></a></div>

	<% If Date() = "2015-11-02" then %>
	<div>
		<% If Date() <= "2015-11-02" Then %>
		<img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/txt_win_now_1102.jpg" alt="이벤트 응모하면 100명에게 즉석당첨의 행운이!" />
		<% End If %>
		<% If Date() = "2015-11-03" Then %>
		<img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/txt_win_now_1103.jpg" alt="이벤트 응모하면 100명에게 즉석당첨의 행운이!" />
		<% End If %>
		<% If Date() = "2015-11-04" Then %>
		<img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/txt_win_now_1104.jpg" alt="이벤트 응모하면 100명에게 즉석당첨의 행운이!" />
		<% End If %>
		<% If Date() = "2015-11-05" Then %>
		<img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/txt_win_now_1105.jpg" alt="이벤트 응모하면 100명에게 즉석당첨의 행운이!" />
		<% End If %>
		<% If Date() = "2015-11-06" Then %>
		<img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/txt_win_now_1106.jpg" alt="이벤트 응모하면 100명에게 즉석당첨의 행운이!" />
		<% End If %>
	</div>
	<div class="realTimeWinner">
		<div class="winnerIs">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/tit_now_win.gif" alt="실시간 즉석당첨" /></h3>
			<button type="button" class="btnMore">더보기</button>
			<ul>
			<% if isarray(contemp) then %>
				<% for i = 0 to ubound(contemp,2) %>
					<li>
						<div>
							<p class="winner"><strong><%= printUserId(Left(contemp(0,i),10),2,"*")%>님</strong>이 기프티콘에 당첨되셨습니다.</p>
							<span class="date"><%= Left(contemp(1,i),22) %></span>
						</div>
					</li>
				<% next %>
			<% else %>
				<li>
					<div>
						<p class="winner">아직 기프티콘 당첨자가 없습니다.</p>
					</div>
				</li>
			<% end if %>
			</ul>
		</div>
	</div>
	<% End If %>

	<div class="evtNoti">
		<h3>이벤트 유의사항</h3>
		<ul>
			<li>한 ID당 매일 1번만 참여할 수 있습니다.</li>
			<li>꿈상품의 당첨자는 익일 오전에 공지됩니다.</li>
			<% If Date() = "2015-11-02" Then %>
			<li>즉석당첨 경품은 모바일 상품권으로 익일 전송될 예정입니다.</li>
			<% End If %>
			<li>당첨자 안내를 위해 정확한 개인정보를 입력해주세요.</li>
			<li>당첨된 ID가 다르더라도 배송지 또는 전화번호가 동일할 경우 경품 증정이 취소될 수 있습니다.</li>
			<li>경품에 대한 제세공과금은 텐바이텐 부담입니다.</li>
			<li>당첨자에 한해 개인정보를 취합한 후 경품이 증정됩니다.</li>
		</ul>
	</div>

	<div class="dreamLayer">
		<% If Date() = "2015-11-02" Then %>
		<div class="dreamLayerCont result">
			<button type="button" class="btnClose"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/btn_layer_close.png" alt="닫기" /></button>
			<div>
				<% If Date() <= "2015-11-02" Then %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/layer_win_1102.png" alt="바나나우유 당첨" />
				<% End If %>
				<% If Date() = "2015-11-03" Then %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/layer_win_1103.png" alt="트윅스 당첨" />
				<% End If %>
				<% If Date() = "2015-11-04" Then %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/layer_win_1104.png" alt="레쓰비 당첨" />
				<% End If %>
				<% If Date() = "2015-11-05" Then %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/layer_win_1105.png" alt="비타500 당첨" />
				<% End If %>
				<% If Date() = "2015-11-06" Then %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/layer_win_1106.png" alt="허쉬드링크 당첨" />
				<% End If %>
			</div>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/txt_confirm_number.png" alt="개인정보에 있는 휴대폰 번호로 상품권이 발송됩니다. 휴대폰 번호를 확인해주세요!" /></p>
			<div class="modNum">
				<div>
					<p class="num"><%=usercell%></p>
					<% If isapp = "1" Then %>
					<a href="" onclick="fnAPPpopupMy10x10();return false;" class="btnMod">
					<% Else %>
					<a href="/my10x10/mymain.asp" class="btnMod">
					<% End If %>
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/btn_modify.png" alt="수정" /></a>
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/bg_tel.png" alt="" />
				</div>
			</div>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/txt_noti_tomorrow.png" alt="꿈 당첨자는 내일 오전에 발표합니다!" /></p>
		</div>
		<% End If %>
		<div class="dreamLayerCont nextPdt">
			<button type="button" class="btnClose"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/btn_layer_close.png" alt="닫기" /></button>
			<div>
				<% If Date() <= "2015-11-02" Then %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/img_next_1102.png" alt="3일 상품:아이리버 블루투스 오디오" />
				<% End If %>
				<% If Date() = "2015-11-03" Then %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/img_next_1103.png" alt="4일 상품:라비또 빈백" />
				<% End If %>
				<% If Date() = "2015-11-04" Then %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/img_next_1104.png" alt="5일 상품:인스탁스미니8" />
				<% End If %>
				<% If Date() = "2015-11-05" Then %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/67097/img_next_1105.png" alt="6일 상품:스마트빔프로젝터" />
				<% End If %>
			</div>
		</div>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	History	: 2015.05.28 유태욱 생성
'	Description : ##티켓킹
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
	dim bancode
	Dim imgmon, tempcnt
	Dim eCode, vDisp, sqlstr, cnt, realcnt, i, contemp, evtimagenum
	Dim nowdate
	Dim LoginUserid
	Dim DayName, pdName1, pdName2, pdName3, pdName4, pdName5
	Dim evtItemCode1, evtItemCode2, evtItemCode3, evtItemCode4, evtItemCode5
	Dim evtItemCnt1, evtItemCnt2, evtItemCnt3, evtItemCnt4, evtItemCnt5
	Dim isEvtSoldOut1, isEvtSoldOut2, isEvtSoldOut3, isEvtSoldOut4, result1, result2, result3

	isEvtSoldOut1 = False
	isEvtSoldOut2 = False
	isEvtSoldOut3 = False
	isEvtSoldOut4 = False

	nowdate = now()
'	nowdate = "2015-06-08 09:10:00"

	LoginUserid = getLoginUserid()

	bancode = 63082

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  63772
	Else
		eCode   =  62985
	End If

	''1주차,2주차 구분
	If left(nowdate,10)<"2015-06-06" Then
		DayName = "mon_01"
		imgmon	=	"01"
	else
		DayName = "mon_02"
		imgmon	=	"02"
	end if

	
	''5일치 구분
	If left(nowdate,10)<"2015-06-02" or left(nowdate,10)="2015-06-06" or left(nowdate,10)="2015-06-07" or left(nowdate,10)="2015-06-08" Then
		evtimagenum	=	"01"

		pdName1 = "무배쿠폰"
		evtItemCode1 = "1111111"
		evtItemCnt1 = 1

		pdName2 = "캐리어 핑크"
		evtItemCode2 = "2222222"
		evtItemCnt2 = 2

		pdName3 = "에어프레임도쿄"
		evtItemCode3 = "3333333"
		evtItemCnt3 = 495

		pdName4 = "포카리"
		evtItemCode4 = "4444444"
		evtItemCnt4 = 2503

		pdName5 = "기프트카드"
		evtItemCode5 = "5555555"
		evtItemCnt5 = 10
	elseif left(nowdate,10)="2015-06-02" or left(nowdate,10)="2015-06-09" Then
		evtimagenum	=	"02"

		pdName1 = "무배쿠폰"
		evtItemCode1 = "1111111"
		evtItemCnt1 = 2

		pdName2 = "시마헬기"
		evtItemCode2 = "2222222"
		evtItemCnt2 = 2

		pdName3 = "마주로클립"
		evtItemCode3 = "3333333"
		evtItemCnt3 = 700

		pdName4 = "제주보석건귤"
		evtItemCode4 = "4444444"
		evtItemCnt4 = 2297

		pdName5 = "기프트카드"
		evtItemCode5 = "5555555"
		evtItemCnt5 = 10
	elseif left(nowdate,10)="2015-06-03" or left(nowdate,10)="2015-06-10" Then
		evtimagenum	=	"03"

		pdName1 = "무배쿠폰"
		evtItemCode1 = "1111111"
		evtItemCnt1 = 1

		pdName2 = "아이리버블루투스오디오"
		evtItemCode2 = "2222222"
		evtItemCnt2 = 2

		pdName3 = "오야스미양"
		evtItemCode3 = "3333333"
		evtItemCnt3 = 745

		pdName4 = "짜파게티"
		evtItemCode4 = "4444444"
		evtItemCnt4 = 2253

		pdName5 = "기프트카드"
		evtItemCode5 = "5555555"
		evtItemCnt5 = 10
	elseif left(nowdate,10)="2015-06-04" or left(nowdate,10)="2015-06-11" Then
		evtimagenum	=	"04"

		pdName1 = "무배쿠폰"
		evtItemCode1 = "1111111"
		evtItemCnt1 = 1

		pdName2 = "커피메이커오븐"
		evtItemCode2 = "2222222"
		evtItemCnt2 = 2

		pdName3 = "스크래치맵세계지도"
		evtItemCode3 = "3333333"
		evtItemCnt3 = 295

		pdName4 = "베스킨라빈스싱글"
		evtItemCode4 = "4444444"
		evtItemCnt4 = 2703

		pdName5 = "기프트카드"
		evtItemCode5 = "5555555"
		evtItemCnt5 = 10
	elseif left(nowdate,10)="2015-06-05" or left(nowdate,10)>="2015-06-12" Then
		evtimagenum	=	"05"

		pdName1 = "무배쿠폰"
		evtItemCode1 = "1111111"
		evtItemCnt1 = 1

		pdName2 = "인스탁스미니"
		evtItemCode2 = "2222222"
		evtItemCnt2 = 2

		pdName3 = "비킷BGP방수팩"
		evtItemCode3 = "3333333"
		evtItemCnt3 = 1000

		pdName4 = "도라에몽얼굴물총"
		evtItemCode4 = "4444444"
		evtItemCnt4 = 1998

		pdName5 = "기프트카드"
		evtItemCode5 = "5555555"
		evtItemCnt5 = 10
	end if

	'// 일자별 상품 재고파악
	sqlstr = " Select sub_opt2, count(*) as cnt From db_event.dbo.tbl_event_subscript "
	sqlstr = sqlstr & " Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' And sub_opt2 <> 0 And sub_opt2<>'5555555' "
	sqlstr = sqlstr & " group by sub_opt2 "
	rsget.Open sqlstr, dbget, 1
	If Not(rsget.bof Or rsget.eof) Then
		Do Until rsget.eof
			If Trim(rsget("sub_opt2")) = Trim(evtItemCode1) Then
				If rsget("cnt") > 0 Then
					isEvtSoldOut1 = True '//  재고파악
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

	if left(nowdate,10)="2015-06-09" Or left(nowdate,10)="2015-06-08" then	'2,9일만 총 수량이 2999개
		tempcnt=2999
	else
		tempcnt=3000
	end if

	'// 남은 티켓 수량(기프트카드 제외)
	sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' And sub_opt2<>0 And sub_opt2<>'5555555'"
	rsget.Open sqlstr, dbget, 1
		cnt = rsget(0)
	rsget.close
	realcnt = Cint(tempcnt)-Cint(cnt)



'realcnt =0

	'// 실시간 당첨자 id
	sqlstr = "SELECT top 5 userid, regdate"
	sqlstr = sqlstr & " From [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' And sub_opt2<>0 "
	sqlstr = sqlstr & " order by regdate desc"
	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		contemp = rsget.getrows()
	END IF
	rsget.close
%>
<style type="text/css">
img {vertical-align:top;}
.topic p {visibility:hidden; width:0; height:0;}
.ticket {position:relative;}
.ticket .soldout {position:absolute; top:0; left:0; z-index:10; width:100%;}
.booth {position:relative;}
.booth strong {position:absolute; top:32%; left:0; width:100%; text-align:center; color:#222d38; font-size:60px; line-height:60px;}
.ticket .btnget {position:absolute; bottom:21%; left:50%; width:78%; margin-left:-39%; background-color:transparent;}
.ticket .btnnext {position:absolute; bottom:7.5%; left:50%; width:45.4%; margin-left:-22.7%;}
.ticket em {display:none; position:absolute; top:21.1%; right:16%; width:20.8%;}

.winner {position:relative;}
.winner .news {position:absolute; top:0; left:0; z-index:10; width:100%;}
.winner button {position:absolute; top:0; left:0; z-index:10; width:100%; background-color:transparent;}
.winner button:active {background-color:transparent;}
.winner ul li {position:relative;}
.winner ul li div {position:absolute; top:21%; left:25%; color:#fff; font-size:10px; line-height:1.8em;}
.winner ul li div strong {display:block; font-size:12px; font-weight:normal;}
.winner ul li div strong span {border-bottom:1px solid #fcff00; color:#fcff00;}
.noWinner {position:relative;}
.noWinner strong {position:absolute; top:30%; left:25%; color:#fff; font-size:14px; font-weight:normal; line-height:1.8em;}
.winner .btnlast {display:none;}

/* layer */
.layer {display:none; position:absolute; top:1.5%; left:50%; z-index:250; width:88%; margin-left:-44%;}
.layer .inner {position:relative; padding-top:6%;}
.layer .no {position:absolute; top:17.5%; left:0; width:100%; padding-left:5%; color:#003e62; font-size:16px; line-height:16px; text-align:center; letter-spacing:-0.05em;}
.layer .btnfacebook, .layer .btncoupon {position:absolute; bottom:9%; left:50%; width:78%; margin-left:-39%;}
.layer .btnclose {position:absolute; top:0; right:-6%; width:14%; background-color:transparent;}

.serialnumber {position:absolute; bottom:1.5%; left:0; width:100%; text-align:left;}
.serialnumber strong {padding-left:5%; color:#000; font-size:10px; font-weight:normal; letter-spacing:-0.05em;}
.mask {display:none; position:absolute; top:0; left:0; z-index:200; width:100%; height:100%; background:rgba(0,0,0,.6);}

.noti {padding:25px 25px 25px 10px; background-color:#f4f7f7;}
.noti h2 {color:#29a19e; font-size:14px;}
.noti h2 strong {padding-bottom:2px; border-bottom:2px solid #4fc1be;}
.noti ul {margin-top:13px;}
.noti ul li {position:relative; margin-top:2px; padding-left:10px; color:#444; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:5px; left:0; width:4px; height:4px; border-radius:50%; background-color:#4fc1be;}

@media all and (min-width:360px){
	.layer .no {top:17.7%; font-size:17px; line-height:17px;}
}

@media all and (min-width:375px){
	.layer .no {font-size:19px; line-height:19px;}
}
@media all and (min-width:480px){
	.booth strong {font-size:85px; line-height:85px;}
	.winner ul li div {font-size:13px;}
	.winner ul li div strong {font-size:16px;}
	.noWinner strong {font-size:18px;}
	.layer .no {font-size:24px; line-height:24px;}
	.serialnumber strong {font-size:15px;}
	.noti {padding:25px 15px;}
	.noti ul {margin-top:16px;}
	.noti h2 {font-size:17px;}
	.noti ul li {margin-top:4px; font-size:13px;}
}

@media all and (min-width:600px){
	.booth strong {font-size:96px; line-height:96px;}
	.winner ul li div {font-size:18px;}
	.winner ul li div strong {font-size:22px;}
	.noWinner strong {font-size:24px;}
	.layer .no {font-size:26px; line-height:26px;}
	.serialnumber {bottom:1.8%;}
	.serialnumber strong {font-size:16px;}
	.noti h2 {font-size:20px;}
	.noti ul {margin-top:20px;}
	.noti ul li {margin-top:6px; font-size:16px;}
	.noti ul li:after {top:9px;}
}

@media all and (min-width:768px){
	.booth strong {font-size:120px; line-height:120px;}
	.layer .no {font-size:36px; line-height:36px;}
	.noWinner strong {font-size:36px;}
	.winner ul li div {font-size:20px;}
	.winner ul li div strong {font-size:24px;}
}

.animated {-webkit-animation-duration:5s; animation-duration:5s; -webkit-animation-fill-mode:both; animation-fill-mode:both; -webkit-animation-iteration-count:infinite;animation-iteration-count:infinite;}
/* flash animation */
@-webkit-keyframes flash {
	0% {opacity:0;}
	100% {opacity:1;}
}
@keyframes flash {
	0% {opacity:0;}
	100% {opacity:1;}
}
.flash {-webkit-animation-duration:1s; animation-duration:1s; -webkit-animation-name:flash; animation-name:flash; -webkit-animation-iteration-count:infinite; animation-iteration-count:infinite;}
</style>

<script type="text/javascript">
	
function fnClosemask(){
	$('.lywin inner').hide();
//	$('.lyLose').hide();
	$('.mask').hide();
	$("#rtp").empty();
	document.location.reload();
}

function goLostFound(){
<% If left(nowdate,10)>="2015-06-01" and left(nowdate,10)<"2015-06-13" Then %>
	<% If IsUserLoginOK Then %>
		$.ajax({
			type:"POST",
			url:"/apps/appcom/wish/web2014/event/etc/doEventSubscript62985.asp",
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
								$("#rtp").show();
								$(".mask").show();
								window.$('html,body').animate({scrollTop:70}, 300);
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
							alert("잘못된 접근 입니다1.");
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
	<% Else %>
		calllogin();
		return;
	<% End If %>
<% else %>
	alert('이벤트 기간이 아닙니다!');
	return;
<% end if %>
}

<%''카카오 친구 초대(재도전용)%>
function kakaosendcall(){
	<% If IsUserLoginOK Then %>
		<% If left(nowdate,10)>="2015-06-01" and left(nowdate,10)<"2015-06-13" Then %>
			var rstStr = $.ajax({
				type: "POST",
				url: "/apps/appcom/wish/web2014/event/etc/doEventSubscript62985.asp",
				data: "mode=kakao",
				dataType: "text",
				async: false
			}).responseText;
			if (rstStr == "SUCCESS"){
				// success
				parent_kakaolink('[텐바이텐] 티켓킹!\n당신의 여름휴가를 도와드릴\n놀라운 선물을 갖고 텐바이텐이\n돌아왔습니다.\n하루 3,000명 티켓만 잘 뽑아도\n놀라운 선물이 당신을 찾아갑니다!\n지금 도전하세요!\n오직 텐바이텐 APP에서!' , 'http://webimage.10x10.co.kr/eventIMG/2015/62985/img_ticket_king_kakao.gif' , '200' , '200' , 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= eCode %>' );
				return false;
			}else if (rstStr == "FAIL"){
				// fail
				alert('카카오톡 실패 관리자에게 문의 하세요');
				return false;
			}else if (rstStr == "END"){
				alert('오늘의 초대는 모두 완료!\n내일 또 도전해 주세요!');
				return false;
			}else if (rstStr == "NOT1"){
				alert('먼저 응모 후 친구에게 알려주면\n응모 기회가 한번더 생겨요!');
				return false;
			}else if (rstStr == "NOT2"){
				alert('오늘의 초대는 모두 완료!\n내일 또 도전해 주세요!');////////////////////////
				return false;
			}else if (rstStr == "Err|잘못된 접속입니다."){
				alert('잘못된 접속입니다.');
				return false;
			}else if (rstStr == "Err|이벤트 응모 기간이 아닙니다."){
				alert('이벤트 응모 기간이 아닙니다.');
				return false;
			}else if (rstStr == "Err|월요일은 오전 10시부터 응모하실 수 있습니다."){
				alert('월요일은 오전 10시부터 응모하실 수 있습니다.');
				return false;
			}else if (rstStr == "Err|로그인 후 참여하실 수 있습니다."){
				alert('로그인 후 참여하실 수 있습니다.');
				return false;
			}else if (rstStr == "Err|주말엔 쉽니다."){
				alert('주말엔 쉽니다.');
				return false;
			}
		<% else %>
			alert("이벤트 기간이 아닙니다.");
			return;
		<% end if %>
	<% Else %>
		calllogin();
		return;
	<% End If %>
}

//쿠폰Process
function get_coupon(){
	<% If IsUserLoginOK Then %>
		<% If left(nowdate,10) >="2015-06-01" and left(nowdate,10) < "2015-06-13" Then %>
			var rstStr = $.ajax({
				type: "POST",
				url: "/apps/appcom/wish/web2014/event/etc/doEventSubscript62985.asp",
				data: "mode=coupon",
				dataType: "text",
				async: false
			}).responseText;
			if (rstStr == "SUCCESS"){
				alert('쿠폰이 발급되었습니다.');
				document.location.reload();
			}else{
				alert('관리자에게 문의하세요');
				return false;
			}
		<% else %>
			alert("이벤트 기간이 아닙니다.");
			return;
		<% end if %>
	<% Else %>
		calllogin();
		return;
	<% End If %>
}
</script>
	<!-- [APP] 티켓 KING -->
	<div class="mEvt62985">
		<div class="topic">
			<%	'' for dev msg : 이미지 변경 6월 1일~6월 7일 /01/폴더로 6월 8일~ /02/ %>
				<h1><img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/<%= imgmon %>/tit_ticket_king.png" alt="텐아비텐 여름 휴가 지원 프로젝트 티켓킹!" /></h1>
			<p>티켓을 뽑아보세요! 하루에 3,000명! 여름휴가를 도와드릴 놀라운 선물이 찾아갑니다! 이벤트 기간은 6월 1일부터 6월 12일까지 입니다.</p>
		</div>

		<div class="place">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/img_place_<%=DayName%>_<%=evtimagenum%>v1.jpg" alt="오늘의 휴가지 니뽕! 일본 여행상품권 백만원 및 에다스 25형 수화물용 캐리어, 에어프레임 도쿄, 포카리스웨트 캔 250ml" /></p>
		</div>

		<div class="ticket">
			<p class="booth">
				<%	'' ffor dev msg : 이미지 변경 %>
				<% If left(nowdate,10)<"2015-06-06" Then %>
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/<%= imgmon %>/txt_welcome_v1.png" alt="어서 오세요, 고객님! 티켓을 발급받고, 당첨을 확인해 보세요." />
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/<%= imgmon %>/img_booth.png" alt="" />
				<% else %>
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/<%= imgmon %>/txt_welcome.png" alt="어서 오세요, 고객님! 티켓을 발급받고, 당첨을 확인해 보세요." />
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/<%= imgmon %>/img_booth.png" alt="" />
				<% end if %>
				<strong title="남은 티켓수량"><%= realcnt %></strong>
				<% if realcnt>0 and realcnt <= 500 then %>
					<em class="animated flash" style="display:block;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/ico_neart_soldout.png" alt="매진 임박" /></em>
				<% end if %>
			</p>

			<%	'' 금요일 솔드아웃시 금,토,일 솔드아웃레이어 %>
			<% if left(nowdate,10)>="2015-06-05" and left(nowdate,10)<"2015-06-08" then %>
				<% If cnt >= 3000 then %>
					<p class="soldout">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/txt_soldout_weekend.png" alt="오늘의 티켓이 매진 되었습니다. 다음주 월요일, 새로운 휴가지가 찾아옵니다." />
					</p>
				<% end if %>
			<% else %>
				<% If cnt >= tempcnt then %>
					<% if left(nowdate,10)>="2015-06-12" then %>
						<p class="soldout">
							<img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/txt_soldout_last.png" alt="오늘의 티켓이 매진 되었습니다. 또 다시 재미있는 이벤트로 돌아오겠습니다!" />
						</p>
					<% else %>
						<p class="soldout">
							<img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/txt_soldout.png" alt="오늘의 티켓이 매진 되었습니다. 오전 12시, 새로운 휴가지가 찾아옵니다." />
						</p>
					<% end if %>
				<% end if %>
			<% end if %>

			<%	'' for dev msg : 티켓 발급 받기 버튼 %>
			<% if left(nowdate,10)="2015-06-01" or left(nowdate,10)="2015-06-08" then %>
				<% If Not(TimeSerial(Hour(nowdate), minute(nowdate), second(nowdate)) >= TimeSerial(10, 00, 00) And TimeSerial(Hour(nowdate), minute(nowdate), second(nowdate)) < TimeSerial(23, 59, 59)) Then %>
					<a href="" onclick="	alert('월요일은 오전 10시부부터 응모하실 수 있습니다.');return false;" class="btnget"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_get.png" alt="발급받기 ID당 하루에 1회 응모할 수 있어요" /></a>
				<% ElseIf result1 >= "2" Then %>
					<span class="btnget"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_end.png" alt="응모완료 내일 또 도전해 주세요!" /></span>
				<% Else %>
					<a href="" onclick="goLostFound();return false;" class="btnget"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_get.png" alt="발급받기 ID당 하루에 1회 응모할 수 있어요" /></a>
				<% end if %>
			<% elseif left(nowdate,10)="2015-06-06" or left(nowdate,10)="2015-06-07" then %>
				<a href="" onclick="	alert('주말은 쉽니다.');return false;" class="btnget"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_get.png" alt="발급받기 ID당 하루에 1회 응모할 수 있어요" /></a>
			<% else %>
				<% If result1 >= "2" Then %>
					<span class="btnget"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_end.png" alt="응모완료 내일 또 도전해 주세요!" /></span>
				<% else %>
					<a href="" onclick="goLostFound();return false;" class="btnget"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_get.png" alt="발급받기 ID당 하루에 1회 응모할 수 있어요" /></a>
				<% end if %>
			<% end if %>
			
			<% if left(nowdate,10)="2015-06-05" or left(nowdate,10)="2015-06-06" then %>
				<%	'' for dev msg : 다음의 휴가지 버튼 주말용 %>
				<a href="#lyPreview" class="btnnext"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_next_weekend.png" alt="다음의 휴가지는?" /></a>
			<% elseif left(nowdate,10)<"2015-06-12" then %>
				<%	'' for dev msg : 내일의 휴가지 버튼 %>
				<a href="#lyPreview" class="btnnext"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_next.png" alt="내일의 휴가지는?" /></a>
			<% end if %>

		</div>

		<%'' for dev msg : 당첨 OR 꽝 팝업 그려지는곳 <div class="mask"></div> 보여주세요 %>
		<div id="rtp" class="layer">
		</div>
		<div id="lyPreview" class="layer">
			<div class="inner">
			<% if left(nowdate,10)<="2015-06-01" or left(nowdate,10)="2015-06-08" then %>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/img_next_shilla.png" alt="내일의 휴가지 제주 신라호텔 1박 이용권" /></p>
			<% elseif left(nowdate,10)="2015-06-02" or left(nowdate,10)="2015-06-09" then %>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/img_next_macbook.png" alt="내일의 휴가지 집에서 편히 즐기가 맥북에어" /></p>
			<% elseif left(nowdate,10)="2015-06-03" or left(nowdate,10)="2015-06-10" then %>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/img_next_europe.png" alt="내일의 휴가지 유럽 여행상품권" /></p>
			<% elseif left(nowdate,10)="2015-06-04" or left(nowdate,10)="2015-06-11" then %>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/img_next_southeast_asia.png" alt="내일의 휴가지 동남아 여행상품권" /></p>
			<% elseif left(nowdate,10)="2015-06-05" or left(nowdate,10)="2015-06-06" or left(nowdate,10)="2015-06-07"then %>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/img_next_japan.png" alt="다음 휴가지 일본 여행상품권" /></->
			<% end if %>
				<button type="button" class="btnclose"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png" alt="닫기" /></button>
			</div>
		</div>
		<%	''  for dev msg : 실시간 당첨 리스트 %>
		<%	''  for dev msg : 이미지 변경 %>
		<div id="winner" class="winner">
			<strong class="news"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/<%= imgmon %>/txt_winner.png" alt="실시간 당첨소식" /></strong>
			<button type="button" class="btnmore"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/<%= imgmon %>/btn_more.png" alt="실시간 당첨소식 더보기" /></button>
			<% if isarray(contemp) then %>
			<ul>
			
				<% for i = 0 to ubound(contemp,2) %>
					<li>
						<div><strong><span><%= printUserId(Left(contemp(0,i),10),2,"*")%>님</span>이 티켓에 당첨되셨습니다.</strong><%= Left(contemp(1,i),22) %></div>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/<%= imgmon %>/bg_pattern_number_01.png" alt="" />
					</li>
				<% next %>
			</ul>
			<% else %>
				<p class="noWinner">
					<strong>아직 당첨된 인원이 없습니다.</strong>
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/<%= imgmon %>/bg_pattern_number_01.png" alt="" />
				</p>
			<% end if %>
			<button type="button" class="btnlast"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/<%= imgmon %>/btn_no_more.png" alt="" /></button>
		</div>

		<%	''  for dev msg : 카카오톡 %>
		<%	''  for dev msg : 이미지 변경 %>
		<div class="kakao">
			<a href="" onclick="kakaosendcall();return false;" title="카카오톡으로 티켓킹 알려주기"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/<%= imgmon %>/btn_kakao.png" alt="또 발급 받고싶을 땐, 친구찬스! 친구에게 티켓킹을 알려주고, 응모기회 한 번 더 받으세요!" /></a>
		</div>

		<div class="noti">
			<h2><strong>이벤트 주의사항</strong></h2>
			<ul>
				<li> 본 이벤트는 텐바이텐 app에서만 참여 가능합니다.</li>
				<li> 본 이벤트는 ID당 1회만 응모가능하며, 친구 초대 시 한 번 더 응모기회가 주어집니다.</li>
				<li> 5만원 이상의 상품을 받으신 분께는 세무신고를 위해 개인정보를 요청할 수 있습니다. 제세공과금은 텐바이텐 부담입니다.</li>
				<li> 본 이벤트의 1등 상품에 대한 제세공과금은 고객부담입니다.</li>
				<li> 무료배송쿠폰은 ID당 하루에 최대 2회까지 발행되며, 발급 당일 자정 기준으로 자동 소멸됩니다.(1만원 이상 구매 시 사용 가능)</li>
				<li> 당첨된 고객께는 익일 당첨안내 문자가 전송될 예정입니다.</li>
				<li> 당첨된 상품은 당첨안내 확인 후에 발송됩니다! 마이텐바이텐에서 당첨안내를 확인해주세요.</li>
				<li> 당첨된 기프티콘은 익일 오후 1시에 발송됩니다! 마이텐바이텐에서 연락처를 확인해주세요.</li>
				<li> 이벤트 내 모든 상품의 컬러는 랜덤으로 발송되며, 선택이 불가능합니다.</li>
				<li> 본 이벤트의 1등 당첨자는 금일 2~4등 당첨자 중 추첨을 통해 익일 발표합니다.공지사항을 확인해주세요.</li>
				<li> 본 이벤트는 주말(토,일)에는 진행되지 않습니다.</li>
			</ul>
		</div>
		<div class="bnr" style="padding-top:2.5%;">
			<!--<a href="" onclick="fnAPPopenerJsCallClose('callgnb(\'cool\',\'http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=63082\')');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/img_bnr.png" alt="쿨 썸머 오감꽁꽁 프로젝트 보러가기" /></a>-->
			<a href="" onclick="parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= bancode %>');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/img_bnr.png" alt="쿨 썸머 오감꽁꽁 프로젝트 보러가기" /></a>
		</div>
		<div class="mask"></div>
	</div>
	<!-- //티켓 KING -->
<script type="text/javascript">
$(function(){
//	$(".btnget").click(function(){
//		$("#rtp").show();
//		$(".mask").show();
//	});

	$(".btnnext").click(function(){
		$("#lyPreview").show();
		$(".mask").show();
	});

	/* layer */
	$(".mask, #rtp .btnclose").click(function(){
		$("#rtp").hide();
		$(".mask").hide();
		document.location.reload();
	});

	$(".mask, #lyPreview .btnclose").click(function(){
		$("#lyPreview").hide();
		$(".mask").hide();
	});

	$("#winner ul li").hide();
	$("#winner ul li:first").show();
	if ($("#winner ul li").length > 1) {
		$("#winner .btnmore").click(function(){
			$("#winner .btnmore").hide();
			$("#winner ul li").slideDown();
			$("#winner .btnlast").show();
		});

		$("#winner .btnlast").click(function(){
			$("#winner .btnlast").hide();
			$("#winner ul li").hide();
			$("#winner ul li:first").show();
			$("#winner .btnmore").show();
		});
	} else {
		$("#winner .btnmore").hide();
	}
	
});
</script>
<form method="post" name="frmEvt" id="frmEvt">
	<input type="hidden" name="mode" id="mode" value="add">
</form>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
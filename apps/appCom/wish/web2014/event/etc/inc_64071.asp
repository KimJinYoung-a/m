<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	History	: 2015.06.25 유태욱 생성
'	Description : (초)능력자들
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
	Dim imgmon, tempcnt
	dim bancode, nowdate, LoginUserid
	Dim eCode, sqlstr, cnt, realcnt, i, contemp, evtimagenum
	Dim result1, result2, result3
	Dim pdName1, pdName2, pdName3, pdName4
	Dim evtItemCnt1, evtItemCnt2, evtItemCnt3, evtItemCnt4
	Dim evtItemCode1, evtItemCode2, evtItemCode3, evtItemCode4

	nowdate = now()
'	nowdate = "2015-07-06 10:10:00"

	LoginUserid = getLoginUserid()

	bancode = 64101

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  63801
	Else
		eCode   =  64071
	End If

	''1주차,2주차 구분
	If left(nowdate,10)<"2015-07-06" Then
		imgmon	=	"01"
	else
		imgmon	=	"02"
	end if

	If left(nowdate,10)<"2015-06-30" or left(nowdate,10)="2015-07-06" Then
		evtimagenum	=	"01"

		pdName1 = "에어휠"
		evtItemCode1 = "1111111"
		evtItemCnt1 = 1

		pdName2 = "드론캠"
		evtItemCode2 = "2222222"
		evtItemCnt2 = 2

		pdName3 = "선풍기"
		evtItemCode3 = "3333333"
		evtItemCnt3 = 300

		pdName4 = "17차"
		evtItemCode4 = "4444444"
		evtItemCnt4 = 2697

	elseif left(nowdate,10)="2015-06-30" Then
		evtimagenum	=	"02"

		pdName1 = "아이폰"
		evtItemCode1 = "1111111"
		evtItemCnt1 = 1

		pdName2 = "배터리"
		evtItemCode2 = "2222222"
		evtItemCnt2 = 2

		pdName3 = "피규어"
		evtItemCode3 = "3333333"
		evtItemCnt3 = 700

		pdName4 = "핫식스"
		evtItemCode4 = "4444444"
		evtItemCnt4 = 2297

	elseif left(nowdate,10)="2015-07-07" Then
		evtimagenum	=	"02"

		pdName1 = "아이폰"
		evtItemCode1 = "1111111"
		evtItemCnt1 = 1

		pdName2 = "배터리"
		evtItemCode2 = "2222222"
		evtItemCnt2 = 2

		pdName3 = "피규어"
		evtItemCode3 = "3333333"
		evtItemCnt3 = 300

		pdName4 = "핫식스"
		evtItemCode4 = "4444444"
		evtItemCnt4 = 2697

	elseif left(nowdate,10)="2015-07-01" or left(nowdate,10)="2015-07-08" Then
		evtimagenum	=	"03"

		pdName1 = "lgtv"
		evtItemCode1 = "1111111"
		evtItemCnt1 = 1

		pdName2 = "시계"
		evtItemCode2 = "2222222"
		evtItemCnt2 = 2

		pdName3 = "비밀의정원"
		evtItemCode3 = "3333333"
		evtItemCnt3 = 100

		pdName4 = "태엽토이"
		evtItemCode4 = "4444444"
		evtItemCnt4 = 2898			''원래 2897 인데 1일꺼 1개 남은거 추가됨

	elseif left(nowdate,10)="2015-07-02" Then
		evtimagenum	=	"04"

		pdName1 = "아이패드"
		evtItemCode1 = "1111111"
		evtItemCnt1 = 1

		pdName2 = "레이밴"
		evtItemCode2 = "2222222"
		evtItemCnt2 = 2

		pdName3 = "월리퍼즐"
		evtItemCode3 = "3333333"
		evtItemCnt3 = 700

		pdName4 = "하리보"
		evtItemCode4 = "4444444"
		evtItemCnt4 = 2297

	elseif left(nowdate,10)="2015-07-09" Then
		evtimagenum	=	"04"

		pdName1 = "아이패드"
		evtItemCode1 = "1111111"
		evtItemCnt1 = 1

		pdName2 = "레이밴"
		evtItemCode2 = "2222222"
		evtItemCnt2 = 2

		pdName3 = "월리퍼즐"
		evtItemCode3 = "3333333"
		evtItemCnt3 = 300

		pdName4 = "하리보"
		evtItemCode4 = "4444444"
		evtItemCnt4 = 2788		''원래 2697개 인데 2일꺼 91개 남은거 추가됨

	elseif left(nowdate,10)="2015-07-03"  or left(nowdate,10)="2015-07-04" or left(nowdate,10)="2015-07-05" or left(nowdate,10)>="2015-07-10" Then
		evtimagenum	=	"05"

		pdName1 = "여행100만"
		evtItemCode1 = "1111111"
		evtItemCnt1 = 1

		pdName2 = "스마트빔"
		evtItemCode2 = "2222222"
		evtItemCnt2 = 2

		pdName3 = "고잉캔들"
		evtItemCode3 = "3333333"
		evtItemCnt3 = 350

		pdName4 = "설레임"
		evtItemCode4 = "4444444"
		evtItemCnt4 = 2647

	end if

	'// 응모내역 검색
	sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
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

	if left(nowdate,10)="2015-07-06" then
		tempcnt=2991
	elseif left(nowdate,10)="2015-07-08" then
		tempcnt=3001
	elseif left(nowdate,10)="2015-07-09" then
		tempcnt=3091
	else
		tempcnt=3000
	end if

	'// 남은 티켓 수량
	sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" and datediff(day,regdate,getdate()) = 0 And sub_opt2<>0"
	rsget.Open sqlstr, dbget, 1
		cnt = rsget(0)
	rsget.close
	realcnt = Cint(tempcnt)-Cint(cnt)
'	cnt=3000
	
	'// 실시간 당첨자 id
	sqlstr = "SELECT top 5 userid, regdate"
	sqlstr = sqlstr & " From [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eCode &" and datediff(day,regdate,getdate()) = 0 And sub_opt2<>0 "
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

.mEvt64071 button {background-color:transparent;}
.topic p {visibility:hidden; width:0; height:0;}

.item {position:relative;}
.item .soldout {position:absolute; top:0; left:0; width:100%;}

.fingerprint {position:relative;}
.fingerprint .btnFingerprint {overflow:hidden; display:block; position:absolute; top:39.5%; left:50%; width:40%; height:0; margin-left:-20%; padding-bottom:52.25%; font-size:11px; line-height:11px; text-align:center; text-indent:-999em;}
.fingerprint .btnFingerprint span {position:absolute; top:0; left:0; width:100%; height:100%; /*background-color:black; opacity:0.3;*/}
.fingerprint .btnNext {position:absolute; bottom:7%; left:50%; width:75.4%; margin-left:-37.7%;}

.winner {padding-bottom:13.5%; background:#1f326a url(http://webimage.10x10.co.kr/eventIMG/2015/64071/01/bg_space.png) no-repeat 50% 0; background-size:100% auto;}
.winner .inner {position:relative; width:94%; margin:0 auto; border:3px solid #c9ddf5;}
.winner .news {position:absolute; top:0; left:0; z-index:10; width:100%;}
.winner button {position:absolute; top:0; left:0; z-index:10; width:100%; background-color:transparent;}
.winner button:active {background-color:transparent;}
.winner ul li {position:relative; background-color:rgba(0,14,58,0.4);}
.winner ul li:nth-child(2), .winner ul li:nth-child(4) {background-color:rgba(0,14,58,0.6);}
.winner ul li.first {background-color:rgba(0,14,58,0.6);}
.winner ul li div {position:absolute; top:21%; left:25%; color:#fff; font-size:10px; line-height:1.8em;}
.winner ul li div strong {display:block; font-size:12px; font-weight:normal;}
.winner ul li div strong b {border-bottom:1px solid #ffe764; color:#ffe764;}
.winner ul li span {position:absolute; top:0; left:0; width:20.2%; height:100%; background-color:rgba(236,236,236,0.1);}
.noWinner {position:relative;}
.noWinner strong {position:absolute; top:30%; left:25%; color:#fff; font-size:14px; font-weight:normal; line-height:1.8em;}
.winner .btnlast {display:none;}

<% if left(nowdate,10)>="2015-07-06" then %>
/* style change */
.winner {background:#18505d url(http://webimage.10x10.co.kr/eventIMG/2015/64071/02/bg_space.png) no-repeat 50% 0; background-size:100% auto;}
.winner .inner {border:3px solid #c9f2f5;}
.winner ul li {background-color:rgba(0,101,119,0.15);}
.winner ul li:nth-child(2), .winner ul li:nth-child(4) {background-color:rgba(10,31,38,0.15);}
.winner ul li.first {background-color:rgba(10,31,38,0.15);}
<% end if %>
/* layer */
.layer {display:none; position:absolute; top:2%; left:50%; z-index:250; width:87.5%; margin-left:-43.75%;}
.layer .inner {position:relative; padding-top:1.5%;}
.layer .no {position:absolute; top:17.5%; left:0; width:100%; color:#003e62; font-size:16px; line-height:16px; text-align:center; letter-spacing:-0.05em;}
.layer .btnMy10x10 {position:absolute; bottom:9%; left:50%; width:67.8%; margin-left:-33.9%;}
.layer .btncoupon {position:absolute; bottom:28%; left:50%; width:34.34%; margin-left:-17.17%;}
.layer .btnclose {position:absolute; top:0; right:-1.5%; width:24%; background-color:transparent;}

.serialnumber {position:absolute; bottom:2%; left:0; width:100%; text-align:center;}
.serialnumber strong {color:#000; font-size:10px; font-weight:normal; letter-spacing:-0.05em;}
.mask {display:none; position:absolute; top:0; left:0; z-index:200; width:100%; height:100%; background:rgba(0,0,0,.7);}

.noti {padding:22px 16px;}
.noti h2 {color:#377183; font-size:14px;}
.noti h2 strong {padding-bottom:2px; border-bottom:2px solid #377183;}
.noti ul {margin-top:13px;}
.noti ul li {position:relative; margin-top:2px; padding-left:8px; color:#444; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:4px; left:0; width:4px; height:4px; border-radius:50%; background-color:#377183;}

@media all and (min-width:480px){
	.serialnumber strong {font-size:15px;}

	.winner ul li div {font-size:13px;}
	.winner ul li div strong {font-size:16px;}
	.noWinner strong {font-size:18px;}

	.noti {padding:40px 35px;}
	.noti ul {margin-top:16px;}
	.noti h2 {font-size:17px;}
	.noti ul li {margin-top:4px; padding-left:12px; font-size:13px;}
	.noti ul li:after {top:5px; width:5px; height:5px;}
}

@media all and (min-width:600px){
	.serialnumber {bottom:1.8%;}
	.serialnumber strong {font-size:16px;}

	.winner ul li div {font-size:18px;}
	.winner ul li div strong {font-size:22px;}
	.noWinner strong {font-size:24px;}

	.noti h2 {font-size:20px;}
	.noti ul {margin-top:20px;}
	.noti ul li {margin-top:6px; padding-left:20px; font-size:16px;}
	.noti ul li:after {top:9px;}
}

@media all and (min-width:768px){
	.noWinner strong {font-size:36px;}
	.winner ul li div {font-size:20px;}
	.winner ul li div strong {font-size:24px;}
}
</style>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type="text/javascript">

function fnClosemask(){
	$('.lywin inner').hide();
	$('.lylose inner').hide();
	$('.mask').hide();
	$("#rtp").empty();
	document.location.reload();
}

function goLostFound(){
<% If left(nowdate,10)>="2015-06-29" and left(nowdate,10)<"2015-07-11" Then %>
	<% If IsUserLoginOK Then %>
		<% if cnt < tempcnt then %>
			$.ajax({
				type:"POST",
				url:"/apps/appcom/wish/web2014/event/etc/doEventSubscript64071.asp",
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
									window.$('html,body').animate({scrollTop:50}, 300);
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
								alert("잘못된 접근 입니다..");
								document.location.reload();
								return false;
							}
						}
					}
				},
				error:function(jqXHR, textStatus, errorThrown){
					alert("잘못된 접근 입니다.!");
					document.location.reload();
					return false;
				}
			});
		<% else %>
			alert('오늘은 마감되었습니다.');
			return;
		<% end if %>
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
		<% If left(nowdate,10)>="2015-06-29" and left(nowdate,10)<"2015-07-11" Then %>
			var rstStr = $.ajax({
				type: "POST",
				url: "/apps/appcom/wish/web2014/event/etc/doEventSubscript64071.asp",
				data: "mode=kakao",
				dataType: "text",
				async: false
			}).responseText;
			if (rstStr == "SUCCESS"){
				// success
				parent_kakaolink('[텐바이텐] (초)능력자들\n당신의 더위를 우주로 날려 보낼\n초능력을 갖고 텐바이텐이\n돌아왔습니다.\n\n손가락을 올려보세요!\n하루 3,000명에게 초능력을 가져다 줄 놀라운 선물이 당신을 찾아갑니다!\n\n지금 도전하세요!\n오직 텐바이텐 APP에서!' , 'http://webimage.10x10.co.kr/eventIMG/2015/64071/img_kakao.png' , '200' , '200' , 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= eCode %>' );
				return false;
			}else if (rstStr == "FAIL"){
				// fail
				alert('카카오톡 실패 관리자에게 문의 하세요');
				return false;
			}else if (rstStr == "END"){
				alert('초능력을 모두 확인하셨습니다.\n내일 또 도전해 주세요!');
				return false;
			}else if (rstStr == "NOT1"){
				alert('초능력을 먼저 확인하고,\n친구에게 알려주세요!');
				return false;
			}else if (rstStr == "NOT2"){
				alert('초능력을 모두 확인하셨습니다.\n내일 또 도전해 주세요!');////////////////////////
				return false;
			}else if (rstStr == "Err|잘못된 접속입니다."){
				alert('잘못된 접속입니다.');
				return false;
			}else if (rstStr == "Err|오늘은 마감되었습니다.!"){
				alert('오늘은 마감되었습니다.!');
				return false;
			}else if (rstStr == "Err|이벤트 응모 기간이 아닙니다."){
				alert('이벤트 응모 기간이 아닙니다.');
				return false;
			}else if (rstStr == "Err|월요일은 오전 10시부터 응모하실 수 있습니다."){
				alert('월요일은 오전 10시부터 응모하실 수 있습니다.');
				return false;
			}else if (rstStr == "Err|로그인 후 참여하실 수 있습니다."){
				alert('로그인을 해야\n이벤트에 참여할 수 있어요.');
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
		<% If left(nowdate,10) >="2015-06-29" and left(nowdate,10) < "2015-07-11" Then %>
			var rstStr = $.ajax({
				type: "POST",
				url: "/apps/appcom/wish/web2014/event/etc/doEventSubscript64071.asp",
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
	<div class="mEvt64071">
		<%'' for dev msg : 이미지 폴더 6/29~7/3까지는 /01/ 폴더, 7/6~7/10까지는 /02/ 폴더입니다.  %>
		<section>
			<div class="topic">
				<h1><img src="http://webimage.10x10.co.kr/eventIMG/2015/64071/<%=imgmon%>/tit_super_hamans.png" alt="더위를 우주로 날려보내는 초능력자들" /></h1>
				<p>손가락을 올려보세요! 초능력을 가져다 줄 선물이 당신을 찾아갑니다! 이벤트 기간은 6월 29일부터 7월 10일까지 진행됩니다.</p>
			</div>

			<div class="item">
				<%'' for dev msg :  6/29~7/3일까지 상품 img_today_item_01~05까지입니다.  %>
				<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/64071/<%=imgmon%>/img_today_item_<%=evtimagenum%>.jpg" alt="오늘의 초능력자 공중부양 삼천명!" /></div>

				<%'' for dev msg : 솔드아웃  %>
				<% if cnt >= tempcnt then %>
					<% If left(nowdate,10) > "2015-07-05" and left(nowdate,10) < "2015-07-10" or left(nowdate,10) < "2015-07-03" then %>
						<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64071/01/txt_solid_out.png" alt="SOLD OUT 초능력을 가져다 줄 선물이 매진되었습니다. 오전 12시를 기다려주세요!" /></p>
					<% elseif left(nowdate,10) > "2015-07-02" and left(nowdate,10) < "2015-07-06" then %>
						<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64071/01/txt_solid_out_weekend.png" alt="SOLD OUT 초능력을 가져다 줄 선물이 매진 되었습니다. 다음주 월요일 오전 10시를 기다려주세요!" /></p>
					<% elseif left(nowdate,10) > "2015-07-09" then %>
						<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64071/02/txt_end_v1.png" alt="THE END 재밌는 이벤트로 기억되고 싶습니다. 참여해주신 모든 분들께 감사드립니다" /></p>
					<% end if %>
				<% end if %>
				<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64071/02/txt_end_v1.png" alt="THE END 재밌는 이벤트로 기억되고 싶습니다. 참여해주신 모든 분들께 감사드립니다" /></p>
			</div>

			<%'' 지문인식  %>
			<div class="fingerprint">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64071/<%=imgmon%>/img_fingerprint.png" alt="손가락을 올려 초능력을 확인하세요!" /></p>
					<% if cnt < tempcnt then %>
						<a href="" onclick="goLostFound();return false;" class="btnFingerprint"><span></span>나의 초능력 확인하기</a>
					<% end if %>
				<a href="#lyPreview" class="btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64071/<%=imgmon%>/btn_next.png" alt="내일의 초능력 미리보기" /></a>
			</div>

			<%'' for dev msg : 당첨 layer  %>
			<div id="rtp" class="layer">
			</div>

			<%'' for dev msg : 내일의 초능력자 layer  %>
			<div id="lyPreview" class="layer">
				<div class="inner">
					<% if left(nowdate,10)="2015-06-29" or left(nowdate,10)="2015-07-06" then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_next_tue.png" alt="내일의 초능력 슈퍼파월" />
					<% elseif left(nowdate,10)="2015-06-30" or left(nowdate,10)="2015-07-07" then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_next_wed.png" alt="내일의 초능력 시간여행" /-->
					<% elseif left(nowdate,10)="2015-07-01" or left(nowdate,10)="2015-07-08" then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_next_thu.png" alt="내일의 초능력 분신술사" /-->
					<% elseif left(nowdate,10)="2015-07-02" or left(nowdate,10)="2015-07-09" then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_next_fri.png" alt="내일의 초능력 순간이동" /-->
					<% elseif left(nowdate,10)<"2015-06-29" or left(nowdate,10)="2015-07-03" or left(nowdate,10)="2015-07-04" or left(nowdate,10)="2015-07-05" then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_next_mon.png" alt="다음주 초능력 초능력 공중부양" /-->
					<% else %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_next_new.png" alt="" >
					<% end if %>
					<button type="button" class="btnclose"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64071/02/btn_close.png" alt="닫기" /></button>
				</div>
			</div>

			<%'' for dev msg : 실시간 당첨 리스트  %>
			<div id="winner" class="winner">
				<div class="inner">
					<strong class="news"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64071/<%=imgmon%>/txt_winner.png" alt="실시간 당첨소식" /></strong>
					<button type="button" class="btnmore"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64071/<%=imgmon%>/btn_more.png" alt="실시간 당첨소식 더보기" /></button>
					<% if isarray(contemp) then %>
						<ul>
							<% for i = 0 to ubound(contemp,2) %>
							<li>
								<div><strong><b><%= printUserId(Left(contemp(0,i),10),2,"*")%>님</b>이 초능력자가 되셨습니다.</strong> <%= Left(contemp(1,i),22) %></div>
								<img src="http://webimage.10x10.co.kr/eventIMG/2015/64071/<%=imgmon%>/bg_transparent_box.png" alt="" />
								<span></span>
							</li>
							<% next %>
						</ul>
					<% else %>
						<p class="noWinner">
							<strong>아직 당첨된 인원이 없습니다.</strong>
							<img src="http://webimage.10x10.co.kr/eventIMG/2015/64071/<%=imgmon%>/bg_transparent_box.png" alt="" />
						</p>
					<% end if %>
					<button type="button" class="btnlast"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64071/<%=imgmon%>/btn_no_more.png" alt="" /></button>
				</div>
			</div>

			<%'' for dev msg : 카카오톡 %>
			<div class="kakao">
				<a href="" onclick="kakaosendcall();return false;" title="카카오톡으로 초능력자들 알려주기"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64071/<%=imgmon%>/btn_kakao.png" alt="또 하고 싶을 땐, 친구찬스! 친구에게 능력자들을 알리고, 응모기회 한 번 더 받으세요!" /></a>
			</div>

			<div class="bnr">
				<a href="eventmain.asp?eventid=64101" title="별 세는 밤 이벤트 보기"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_bnr_event.png" alt="매일 한 번씩 밤하늘을 클릭해주세요! 별이 많아지면 깜짝 선물이 찾아옵니다!" /></a>
			</div>

			<div class="noti">
				<h2><strong>이벤트 유의사항</strong></h2>
				<ul>
					<li>본 이벤트는 텐바이텐 app에서만 참여 가능합니다.</li>
					<li>본 이벤트는 ID당 1일 1회만 응모가능하며, 친구 초대 시 한 번 더 응모기회가 주어집니다.</li>
					<li>5만원 이상의 상품을 받으신 분께는 세무신고를 위해 개인정보를 요청할 수 있습니다. 제세공과금은 텐바이텐 부담입니다.</li>
					<li>본 이벤트의 1등 상품에 대한 제세공과금은 고객부담입니다.</li>
					<li>무료배송쿠폰은 ID당 하루에 최대 2회까지 발행되며, 발급 당일 자정 기준으로 자동 소멸됩니다.(1만원 이상 구매 시 사용 가능)</li>
					<li>당첨된 고객께는 마이텐바이텐에 기재된 연락처로 익일 당첨안내 문자가 전송될 예정이며, 연락처 변경 혹은 미 기입시 당첨이 취소될 수 있습니다.</li>
					<li>당첨된 상품은 기본정보에 입력된 주소로 발송됩니다! 마이텐바이텐에서 당첨안내를 확인해주세요.</li>
					<li>당첨된 기프티콘은 익일 발송됩니다! 마이텐바이텐에서 연락처를 확인해주세요.</li>
					<li>이벤트 내 모든 상품의 컬러는 랜덤으로 발송되며, 선택이 불가능합니다.</li>
					<li>본 이벤트는 주말(토, 일)에는 진행되지 않습니다.</li>
				</ul>
			</div>

			<div class="mask"></div>
		</section>
	</div>

<script type="text/javascript">
$(function(){
//	$(".btnFingerprint").click(function(){
//		$("#rtp").show();
//		$(".mask").show();
//	});

	$(".btnNext").click(function(){
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
	$("#winner ul li:first").addClass("first");

	if ($("#winner ul li").length > 1) {
		$("#winner .btnmore").click(function(){
			$("#winner .btnmore").hide();
			$("#winner ul li:first").removeClass("first");
			$("#winner ul li").slideDown();
			$("#winner .btnlast").show();
		});

		$("#winner .btnlast").click(function(){
			$("#winner .btnlast").hide();
			$("#winner ul li:first").addClass("first");
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
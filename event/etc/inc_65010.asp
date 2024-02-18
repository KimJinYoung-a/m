<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	History	: 2015.07.23 유태욱 생성
'	Description : 냉동실을 부탁해
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
	Dim imgmon, tempcnt
	dim nowdate, LoginUserid
	Dim eCode, sqlstr, cnt, realcnt, i, contemp, evtimagenum
	Dim result1, result2, result3
	Dim pdName1, pdName2, pdName3, pdName4
	Dim evtItemCnt1, evtItemCnt2, evtItemCnt3, evtItemCnt4
	Dim evtItemCode1, evtItemCode2, evtItemCode3, evtItemCode4

	nowdate = now()
'					nowdate = "2015-08-07 10:10:00"

	LoginUserid = getLoginUserid()

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  64837
	Else
		eCode   =  65010
	End If

	''1주차,2주차 구분
	If left(nowdate,10)<"2015-08-03" Then
		imgmon	=	"01"
	else
		imgmon	=	"02"
	end if

	If left(nowdate,10)<"2015-07-28" Then
		evtimagenum	=	"0727"
	elseIf left(nowdate,10)="2015-07-28" then
		evtimagenum	=	"0728"
	elseIf left(nowdate,10)="2015-07-29" then
		evtimagenum	=	"0729"
	elseIf left(nowdate,10)="2015-07-30" then
		evtimagenum	=	"0730"
	elseIf left(nowdate,10)="2015-07-31" then
		evtimagenum	=	"0731"
	elseIf left(nowdate,10)="2015-08-01" or left(nowdate,10)="2015-08-02" or left(nowdate,10)="2015-08-03" then
		evtimagenum	=	"0727"
	elseIf left(nowdate,10)="2015-08-04" then
		evtimagenum	=	"0728"
	elseIf left(nowdate,10)="2015-08-05" then
		evtimagenum	=	"0729"
	elseIf left(nowdate,10)="2015-08-06" then
		evtimagenum	=	"0730"
	elseIf left(nowdate,10)>="2015-08-07" then
		evtimagenum	=	"0731"
	end if

	If left(nowdate,10)<"2015-07-28" or left(nowdate,10)="2015-08-03" or left(nowdate,10)="2015-08-01" or left(nowdate,10)="2015-08-02"Then

		pdName1 = "베스킨베리"
		evtItemCode1 = "1111111"
		evtItemCnt1 = 5

		pdName2 = "설레임밀크"
		evtItemCode2 = "2222222"
		evtItemCnt2 = 485

		pdName3 = "파리팥빙수"
		evtItemCode3 = "3333333"
		evtItemCnt3 = 10

	elseif left(nowdate,10)="2015-07-28" or left(nowdate,10)="2015-08-04" Then

		pdName1 = "던킨아이스"
		evtItemCode1 = "1111111"
		evtItemCnt1 = 10

		pdName2 = "우유속모카"
		evtItemCode2 = "2222222"
		evtItemCnt2 = 480

		pdName3 = "스타아이스"
		evtItemCode3 = "3333333"
		evtItemCnt3 = 10

	elseif left(nowdate,10)="2015-07-29" Then

		pdName1 = "스무디베리"
		evtItemCode1 = "1111111"
		evtItemCnt1 = 10

		pdName2 = "메로나"
		evtItemCode2 = "2222222"
		evtItemCnt2 = 480

		pdName3 = "베스킨사과"
		evtItemCode3 = "3333333"
		evtItemCnt3 = 10
		
	elseif left(nowdate,10)="2015-08-05" Then
		evtimagenum	=	"0805"

		pdName1 = "스무디베리"
		evtItemCode1 = "1111111"
		evtItemCnt1 = 12

		pdName2 = "메로나"
		evtItemCode2 = "2222222"
		evtItemCnt2 = 580

		pdName3 = "베스킨사과"
		evtItemCode3 = "3333333"
		evtItemCnt3 = 13

	elseif left(nowdate,10)="2015-07-30" or left(nowdate,10)="2015-08-06" Then

		pdName1 = "베스킨엄마"
		evtItemCode1 = "1111111"
		evtItemCnt1 = 10

		pdName2 = "베스킨롤"
		evtItemCode2 = "2222222"
		evtItemCnt2 = 470

		pdName3 = "스타초콜릿"
		evtItemCode3 = "3333333"
		evtItemCnt3 = 20

	elseif left(nowdate,10)="2015-07-31" Then

		pdName1 = "베스킨감사"
		evtItemCode1 = "1111111"
		evtItemCnt1 = 5

		pdName2 = "베스킨마카롱"
		evtItemCode2 = "2222222"
		evtItemCnt2 = 45

		pdName3 = "베스킨싱글"
		evtItemCode3 = "3333333"
		evtItemCnt3 = 450
	elseif left(nowdate,10)>="2015-08-07" Then

		pdName1 = "베스킨감사"
		evtItemCode1 = "1111111"
		evtItemCnt1 = 5

		pdName2 = "베스킨마카롱"
		evtItemCode2 = "2222222"
		evtItemCnt2 = 10

		pdName3 = "베스킨싱글"
		evtItemCode3 = "3333333"
		evtItemCnt3 = 485
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

	if left(nowdate,10)="2015-08-05" then
		tempcnt=605
	else
		tempcnt=500
	end if

	'// 남은 상품 수량
	sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" and datediff(day,regdate,getdate()) = 0 And sub_opt2<>0"
	rsget.Open sqlstr, dbget, 1
		cnt = rsget(0)
	rsget.close
	realcnt = Cint(tempcnt)-Cint(cnt)
'	cnt=500
	
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
.mEvt65010 {position:relative; margin-bottom:-20px; background:#bae9ed;}
.btnNext {width:87%; margin:0 auto; padding-bottom:30px;}
.realTimeWinner {position:relative; width:94%; margin:0 auto 25px; border:3px solid #009be2;}
.realTimeWinner .btnMore {position:absolute; right:0; top:8px; width:56px; height:56px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_more_down.png) no-repeat 100% 100%; background-size:36px 36px; text-indent:-999em; outline:none;}
.realTimeWinner .btnMore.fold {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_more_up.png)}
.realTimeWinner h3 {position:absolute; left:0; top:0; width:64px;}
.realTimeWinner ul {overflow:hidden; width:100%;}
.realTimeWinner li {/*display:table;*/ width:100.2%; font-size:11px; color:#444; background:rgba(255,255,255,.7);}
.realTimeWinner li:first-child {background:none; }
.realTimeWinner li:nth-child(2) {border-top:3px solid #009be2;}
.realTimeWinner li:nth-child(even) {background:rgba(255,255,255,.5);}
.realTimeWinner li div {display:table-cell; padding:0 12px; vertical-align:middle;}
.realTimeWinner li .deco {width:64px; padding:0; background:rgba(0,155,226,.07);}
.realTimeWinner li .winner {font-size:12px; margin-bottom:5px;}
.realTimeWinner li .winner strong {display:inline-block; line-height:11px; color:#0073d4; border-bottom:1.5px solid #0073d4;}
.applyEvent {position:relative;}
.applyEvent .soldout {position:absolute; left:0; top:0; width:100%; z-index:100;}
.selectChef {position:relative; text-align:center;}
.selectChef ul {position:absolute; left:7%; top:3%;  width:86%; height:60%;}
.selectChef li {float:left; width:33.33333%; padding:0 1%; height:100%; }
.selectChef li:nth-child(2) {margin-top:5.5%;}
.selectChef li label {display:block; height:85%; text-indent:-999em; cursor:pointer;}
.selectChef li input[type=radio] {display:inline-block; position:relative; width:20px; height:20px; border-radius:50%; background:#f3f2f2;}
.selectChef li input[type=radio]:checked {background-image:none;}
.selectChef li input[type=radio]:checked:after {content:''; display:inline-block; position:absolute; left:50%; top:50%; width:10px; height:10px; margin:-5px 0 0 -5px; background:#d50c0c; border-radius:50%;}
.selectChef li:nth-child(1) input[type=radio] {border:2.5px solid #3bcda3;}
.selectChef li:nth-child(2) input[type=radio] {border:2.5px solid #60b3f4;}
.selectChef li:nth-child(3) input[type=radio] {border:2.5px solid #bc41d2;}
.selectChef .btnSelect {display:block; position:absolute; left:26%; bottom:16%; width:49%;}
.evtNoti {padding:25px 20px; background:#f4f7f7;}
.evtNoti h3 {position:relative; display:inline-block; font-size:14px; padding-bottom:5px; letter-spacing:3px; color:#009be2; margin:0 0 13px 14px;}
.evtNoti h3:after {content:' '; display:inline-block; position:absolute; left:0; bottom:0; width:96%; height:3px; background:#009be2;}
.evtNoti li {position:relative; font-size:12px; line-height:1.3; color:#000; padding:0 0 3px 14px;}
.evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:3px; width:2px; height:2px; border:2px solid #2387ee; border-radius:50%;}

/* 레이어팝업 */
.freezerLayer {display:none; position:absolute; left:0; top:0; width:100%; height:100%; padding-top:16%; background:rgba(0,0,0,.7);}
.freezerLayer .freezerCont {position:relative; margin:0 auto; padding-bottom:20px; background-color:#fff; border-radius:12px;}
.freezerLayer .btnClose {position:absolute; right:-12px; top:-12px; width:35px; cursor:pointer;}
.viewResult .lose {padding-bottom:0 !important;}
.viewResult .btnCopon {display:block; width:40%; margin:0 auto; padding-bottom:20px;}
.viewResult .freezerCont {width:76.5%; }
.viewResult .myNumber {position:relative; overflow:hidden; width:67%; margin:0 auto; border:2.5px solid #ffb400; background:#f7f7f7; border-radius:20px;}
.viewResult .myNumber p {overflow:hidden; position:absolute; left:0; top:50%; width:72%; height:30px; margin-top:-15px;}
.viewResult .myNumber input {display:inline-block; width:100%; height:100%; color:#888; font-size:14px; text-align:center; background:transparent; border:0;}
.viewResult .myNumber a {display:inline-block; float:right; width:28%;}
.viewNext .freezerCont {width:73.5%;}
.viewNext .btnConfirm {width:50%; margin:0 auto;}
.anotherEvt {position:absolute; left:0; bottom:-27.5%; width:100%; border-top:10px solid #fff; z-index:100;}
.lastDay .freezerCont {background:none;}
.lastDay .btnConfirm {display:none;}
@media all and (min-width:480px){
	.btnNext {padding-bottom:45px;}
	.realTimeWinner {margin:0 auto 38px; border:4px solid #009be2;}
	.realTimeWinner .btnMore {top:12px; width:84px; height:84px; background-size:54px 54px;}
	.realTimeWinner h3 {width:96px;}
	.realTimeWinner li {font-size:17px;}
	.realTimeWinner li:nth-child(2) {border-top:4px solid #009be2;}
	.realTimeWinner li div {padding:0 18px;}
	.realTimeWinner li .deco {width:96px;}
	.realTimeWinner li .winner {font-size:18px; margin-bottom:7px;}
	.realTimeWinner li .winner strong {line-height:17px; border-bottom:2px solid #0073d4;}
	.selectChef li input[type=radio] {width:30px; height:30px;}
	.selectChef li input[type=radio]:checked:after {width:15px; height:15px; margin:-7px 0 0 -7px;}
	.selectChef li:nth-child(1) input[type=radio] {border:3px solid #3bcda3;}
	.selectChef li:nth-child(2) input[type=radio] {border:3px solid #60b3f4;}
	.selectChef li:nth-child(3) input[type=radio] {border:3px solid #bc41d2;}
	.evtNoti {padding:38px 30px;}
	.evtNoti h3 {font-size:21px; padding-bottom:7px; letter-spacing:4px; margin:0 0 20px 21px;}
	.evtNoti h3:after {height:4px;}
	.evtNoti li {font-size:18px; padding:0 0 4px 21px;}
	.evtNoti li:after {top:5px; width:3px; height:3px; border:3px solid #2387ee;}

	/* 레이어팝업 */
	.freezerLayer .freezerCont {padding-bottom:30px; border-radius:18px;}
	.freezerLayer .btnClose {right:-18px; top:-18px; width:53px;}
	.viewResult .btnCopon {padding-bottom:30px;}
	.viewResult .myNumber {border:3px solid #ffb400; border-radius:30px;}
	.viewResult .myNumber p {height:45px; margin-top:-23px;}
	.viewResult .myNumber input {font-size:21px;}
}
</style>
<script type="text/javascript">
$(function(){
	// 실시간 당첨자
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

	// 레이어팝업
	$('.btnNext a').click(function(){
		$('.viewNext').show();
		window.parent.$('html,body').animate({scrollTop:$('#viewNext').offset().top}, 800);
	});
	$('.lyrClose').click(function(){
		$('.freezerLayer').hide();
	});

});

function fnClosemask(){
	$('.freezerCont win').hide();
	$('.freezerCont lose').hide();
	$('.mask').hide();
	$("#viewResult").empty();
	document.location.reload();
}

function goLostFound(){
//alert("시스템 오류 입니다");
//return false;
<% If left(nowdate,10)>="2015-07-27" and left(nowdate,10)<"2015-08-08" Then %>
	<% If IsUserLoginOK Then %>
		<% if cnt < tempcnt then %>
			var selchef = $(':radio[name="selchef"]:checked').val();
			$("#fselchef").val(selchef);
			
			 if( selchef ){
				$.ajax({
					type:"POST",
					url:"/event/etc/doEventSubscript65010.asp",
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
										$("#viewResult").empty().html(res[1]);
										$("#viewResult").show();
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
			}else{
	            alert("셰프를 선택해 주세요.");
	            return false;
	        }  
		<% else %>
			alert('오늘은 마감되었습니다.');
			return;
		<% end if %>
	<% Else %>
		<% If isapp="1" Then %>
			parent.calllogin();
			return;
		<% else %>
			parent.jsevtlogin();
			return;
		<% End If %>
	<% End If %>
<% else %>
	alert('이벤트 기간이 아닙니다!');
	return;
<% end if %>
}

<%''카카오 친구 초대(재도전용)%>
function kakaosendcall(){
//alert("시스템 오류 입니다");
//return false;
	<% If IsUserLoginOK Then %>
		<% If left(nowdate,10)>="2015-07-27" and left(nowdate,10)<"2015-08-08" Then %>
			var rstStr = $.ajax({
				type: "POST",
				url: "/event/etc/doEventSubscript65010.asp",
				data: "mode=kakao",
				dataType: "text",
				async: false
			}).responseText;
			if (rstStr == "SUCCESS"){
				// success
				parent_kakaolink('[텐바이텐] 냉동고를 부탁해\n무더운 더위를 날려버리기 위해\n냉동실이 열렸습니다!\n\n좋아하는 셰프를 선택하면 \n시원한 디저트가 등장!\n\n지금 도전하세요!\n오직 텐바이텐에서!' , 'http://webimage.10x10.co.kr/eventIMG/2015/65010/01/bnr_kakao.jpg' , '200' , '200' , 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= eCode %>' );
				return false;
			}else if (rstStr == "FAIL"){
				// fail
				alert('카카오톡 실패 관리자에게 문의 하세요');
				return false;
			}else if (rstStr == "END"){
				alert('오늘은 모두 응모하셨습니다.\n내일 또 도전해 주세요!');
				return false;
			}else if (rstStr == "NOT1"){
				alert('셰프를 먼저 선택하고,\n친구에게 알려주세요!');
				return false;
			}else if (rstStr == "NOT2"){
				alert('오늘은 모두 응모하셨습니다.\n내일 또 도전해 주세요!');////////////////////////
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
			}else if (rstStr == "Err|오전 10시부터 응모하실 수 있습니다."){
				alert('오전 10시부터 응모하실 수 있습니다.');
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
		<% If isapp="1" Then %>
			parent.calllogin();
			return;
		<% else %>
			parent.jsevtlogin();
			return;
		<% End If %>
	<% End If %>
}

//쿠폰Process
function get_coupon(){
	<% If IsUserLoginOK Then %>
		<% If left(nowdate,10) >="2015-07-27" and left(nowdate,10)<"2015-08-08" Then %>
			var rstStr = $.ajax({
				type: "POST",
				url: "/event/etc/doEventSubscript65010.asp",
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
		<% If isapp="1" Then %>
			parent.calllogin();
			return;
		<% else %>
			parent.jsevtlogin();
			return;
		<% End If %>
	<% End If %>
}
</script>
	<!-- 냉동실을 부탁해 -->
	<div class="mEvt65010">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/65010/<%=imgmon%>/tit_request_freezer.gif" alt="냉동실을 부탁해" /></h2>
		<div class="todayDessert">
			<img src="http://webimage.10x10.co.kr/eventIMG/2015/65010/<%=imgmon%>/img_dessert_<%=evtimagenum%>.png" alt="오늘의 디저트" />
		</div>
		<%	''  셰프 선택하기 %>
		<div class="applyEvent">
			<% if cnt >= tempcnt then %>
				<div class="soldout">
				<% if left(nowdate,10)="2015-07-31" then %>
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/65010/01/txt_soldout02.png" alt="SOLDOUT" />
				<% elseif left(nowdate,10)="2015-08-07" then %>
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/65010/02/txt_soldout03.png" alt="THANK YOU 다음주 월요일 오전 10시 새로운 이벤트가 찾아옵니다!" />
				<% else %>
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/65010/01/txt_soldout.png" alt="SOLDOUT" />
				<% end if %>
				</div>
			<% end if %>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65010/<%=imgmon%>/txt_select_chef.gif" alt="오늘의 디저트를 만들어 줄 셰프를 선택해보세요!" /></p>
			<div class="selectChef">
				<ul>
					<li><label for="chef01">허셰프</label><input type="radio" name="selchef" value="1" id="chef01" /></li>
					<li><label for="chef02">풍셰프</label><input type="radio" name="selchef" value="2" id="chef02" /></li>
					<li><label for="chef03">홍셰프</label><input type="radio" name="selchef" value="3" id="chef03" /></li>
				</ul>
				<input type="image" onclick="goLostFound();return false;" src="http://webimage.10x10.co.kr/eventIMG/2015/65010/<%=imgmon%>/btn_select.gif" alt="선택하기" class="btnSelect" />
				<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/65010/<%=imgmon%>/img_chef.gif" alt="" /></div>
			</div>
		</div>
		<p class="btnNext">
			<a href="#viewNext">
				<% if left(nowdate,10)="2015-07-31" or left(nowdate,10)="2015-08-07" then %>
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/65010/<%=imgmon%>/btn_view_next02.png" alt="월요일의 디저트 보기" />
				<% else %>
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/65010/<%=imgmon%>/btn_view_next.png" alt="내일의 디저트 보기" />
				<% end if %>
			</a>
		</p>

		<%	'' 실시간 당첨소식 %>
		<div class="realTimeWinner">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/65010/<%=imgmon%>/txt_realtime_win.gif" alt="실시간 당첨소식" /></h3>
			<button type="button" class="btnMore">더보기</button>
			<ul>
			<% if isarray(contemp) then %>
				<% for i = 0 to ubound(contemp,2) %>
					<li>
						<div class="deco"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65010/<%=imgmon%>/ico_ice.png" alt="" /></div>
						<div>
							<p class="winner"><strong><%= printUserId(Left(contemp(0,i),10),2,"*")%>님</strong>이 디저트에 당첨되셨습니다.</p>
							<span class="date"> <%= Left(contemp(1,i),22) %></span>
						</div>
					</li>
				<% next %>
			<% else %>
				<li>
					<div class="deco"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65010/<%=imgmon%>/ico_ice.png" alt="" /></div>
					<div>
						<p class="winner">아직 당첨자가 없습니다.</p>
					</div>
				</li>
			<% end if %>
			</ul>
		</div>

		<p><a href="" onclick="kakaosendcall();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_kakao.gif" alt="다시 도전하고 싶을 땐, 친구찬스!" /></a></p>
		<div class="evtNoti">
			<h3><strong>유의사항</strong></h3>
			<ul>
				<li>텐바이텐 고객님을 위한 이벤트 입니다.<br />비회원이신 경우 회원가입 후 참여해 주세요.</li>
				<li>본 이벤트는 텐바이텐 모바일과 APP에서만 참여 가능합니다.</li>
				<li>본 이벤트는 ID당 1일 1회만 응모가능하며, 친구 초대 시 한 번 더 응모기회가 주어집니다.</li>
				<li>모바일 상품권은 익일 오후 1시이후에 순차적으로 일괄 발급됩니다.</li>
				<li>본 이벤트는 주말(토, 일)에는 진행되지 않습니다.</li>
			</ul>
		</div>

		<div class="freezerLayer viewResult" id="viewResult">
		</div>

		<%'' 내일의 디저트(레이어팝업) %>
		<div class="freezerLayer viewNext <% if left(nowdate,10)>="2015-08-07" then %>lastDay<% end if %>" id="viewNext">
			<div class="freezerCont">
				<p class="btnClose lyrClose"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_close.png" alt="닫기" /></p>
				<div>
					<% if left(nowdate,10)<"2015-07-28" then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_next_0727.png" alt="내일의 디저트" />
					<% elseif left(nowdate,10)="2015-07-28" then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_next_0728.png" alt="내일의 디저트" />
					<% elseif left(nowdate,10)="2015-07-29" then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_next_0729.png" alt="내일의 디저트" />
					<% elseif left(nowdate,10)="2015-07-30" then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_next_0730.png" alt="내일의 디저트" />
					<% elseif left(nowdate,10)="2015-07-31" or left(nowdate,10)="2015-08-01" or left(nowdate,10)="2015-08-02" then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_next_0731.png" alt="월요일의 디저트" />
					<% elseif left(nowdate,10)="2015-08-03" then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_next_0803.png" alt="내일의 디저트" />
					<% elseif left(nowdate,10)="2015-08-04" then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_next_0804.png" alt="내일의 디저트" />
					<% elseif left(nowdate,10)="2015-08-05" then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_next_0805.png" alt="내일의 디저트" />
					<% elseif left(nowdate,10)="2015-08-06" then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/65010/01/img_next_0806.png" alt="내일의 디저트" />
					<% elseif left(nowdate,10)>="2015-08-07" then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/65010/02/img_next_0807.png" alt="내일의 디저트" />
					<% end if %>
				</div>
				<p class="btnConfirm lyrClose"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65010/01/btn_confirm.gif" alt="확인" /></p>
			</div>
		</div>
	</div>
<form method="post" name="frmEvt" id="frmEvt">
	<input type="hidden" name="mode" id="mode" value="add">
	<input type="hidden" name="fselchef" id="fselchef">
</form>
<!-- #include virtual="/lib/db/dbclose.asp" -->
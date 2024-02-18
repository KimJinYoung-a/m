<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<%
'####################################################
' Description : 비밀의방 메인
' History : 2015.08.14 원승현 생성
'####################################################
	Dim vUserID, eCode, nowdate
	Dim strSql, totcnt, dvalue, altvalue, procdate, chasu, todayPw

	vUserID = GetLoginUserID

	IF application("Svr_Info") = "Dev" THEN
		eCode = "64855"
	Else
		eCode = "65479"
	End If


	'// 일자별 값 셋팅
	select case Trim(Left(now(), 10))

		Case "2015-08-17"
			dvalue = "0817"
			procdate = "2015-08-17"
			chasu = 1
			todayPw = 3958

		Case "2015-08-18"
			dvalue = "0818"
			procdate = "2015-08-18"
			chasu = 2
			todayPw = 8519

		Case "2015-08-19"
			dvalue = "0819"
			procdate = "2015-08-19"
			chasu = 3
			todayPw = 1826

		Case "2015-08-20"
			dvalue = "0820"
			procdate = "2015-08-20"
			chasu = 4
			todayPw = 1959

		Case "2015-08-21"
			dvalue = "0821"
			procdate = "2015-08-21"
			chasu = 5
			todayPw = 1117

		Case "2015-08-24"
			dvalue = "0824"
			procdate = "2015-08-24"
			chasu = 6
			todayPw = 1221

		Case "2015-08-25"
			dvalue = "0825"
			procdate = "2015-08-25"
			chasu = 7
			todayPw = 4349

		Case "2015-08-26"
			dvalue = "0826"
			procdate = "2015-08-26"
			chasu = 8
			todayPw = 5397

		Case "2015-08-27"
			dvalue = "0827"
			procdate = "2015-08-27"
			chasu = 9
			todayPw = 8514

		Case "2015-08-28"
			dvalue = "0828"
			procdate = "2015-08-28"
			chasu = 10
			todayPw = 1111

		Case  Else
			dvalue = "0817"
			procdate = "2015-08-17"
			chasu = 1
			todayPw = 3958

	End Select
%>
<style type="text/css">
img {vertical-align:top;}

.mEvt65477 button {background-color:transparent;}
.chamber {position:relative;}
.chamber .btnToday {position:absolute; bottom:0; left:50%; width:51.56%; margin-left:-25.78%;}

.layerBox {display:none; position:absolute; top:18%; left:50%; z-index:50; width:83.75%; margin-left:-41.875%;}
.layerBox .btnclose {position:absolute; top:5%; right:6%; width:10%;}
.layerBox .btnAddress {position:absolute; bottom:8%; left:50%; width:72.94%; margin-left:-36.47%;}
.winCoupon .btnCoupon {position:absolute; top:59.2%; left:50%; width:67.35%; margin-left:-33.67%;}
.winCoupon .bnr {position:absolute; bottom:1.7%; left:50%; width:100%; margin-left:-50%;}
.layerBox .winCoupon .btnclose {top:3.6%;}

.open {position:relative;}
.keypad {position:absolute; top:0; left:50%; width:252px; margin-left:-126px;}
.keypad .key {overflow:hidden; margin-top:6%;}
.keypad .key button {float:left; width:82px; height:82px; margin:0 1px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/65479/bg_keypad.png) no-repeat 0 0; background-size:738px auto; text-indent:-999em; outline:none;}
.keypad .key .num1 {background-position:0 0;}
.keypad .key .num1:active {background-position:0 100%;}
.keypad .key .num2 {background-position:-82px 0;}
.keypad .key .num2:active {background-position:-82px 100%;}
.keypad .key .num3 {background-position:-164px 0;}
.keypad .key .num3:active {background-position:-164px 100%;}
.keypad .key .num4 {background-position:-246px 0;}
.keypad .key .num4:active {background-position:-246px 100%;}
.keypad .key .num5 {background-position:-328px 0;}
.keypad .key .num5:active {background-position:-328px 100%;}
.keypad .key .num6 {background-position:-410px 0;}
.keypad .key .num6:active {background-position:-410px 100%;}
.keypad .key .num7 {background-position:-492px 0;}
.keypad .key .num7:active {background-position:-492px 100%;}
.keypad .key .num8 {background-position:-574px 0;}
.keypad .key .num8:active {background-position:-574px 100%;}
.keypad .key .num9 {background-position:100% 0;}
.keypad .key .num9:active {background-position:100% 100%;}

.field {display:block; width:227px; height:55px; margin:6% auto 0; background:url(http://webimage.10x10.co.kr/eventIMG/2015/65479/bg_line_white.png) no-repeat 50% 100%; background-size:100% auto;}
.field .star {background:url(http://webimage.10x10.co.kr/eventIMG/2015/65479/bg_star_white.png) no-repeat 0 0; background-size:100% auto;}
#nmTyping {display:block; width:227px; height:53px; margin:5px auto 6%; padding-left:15px; color:#fff; font-size:50px; font-family:helveticaNeue, helvetica, sans-serif !important; font-weight:normal; letter-spacing:29px; line-height:53px;}

.keypad .btnConfirm {display:block; width:94%; margin:9% auto 0;}
.keypad .btnpw {display:block; width:72%; margin:9% auto 0;}

.mask {display:none; position:absolute; top:0; left:0; z-index:30; width:100%; height:100%; background:rgba(0,0,0,.6);}

.noti {padding:5% 3.125%;}
.noti h2 {color:#000; font-size:13px;}
.noti h2 strong {display:inline-block; padding-bottom:1px; border-bottom:2px solid #000; line-height:1.25em;}
.noti ul {margin-top:13px;}
.noti ul li {position:relative; margin-top:2px; padding-left:10px; color:#444; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:4px; left:0; width:4px; height:4px; border-radius:50%; background-color:#d20700;}

@media all and (min-width:360px){
	.keypad {top:1%; width:264px; margin-left:-132px;}
	.keypad .key {margin-top:12%;}
	.keypad .key button {width:86px; height:86px; background-size:774px auto;}
	.keypad .key .num2 {background-position:-86px 0;}
	.keypad .key .num2:active {background-position:-86px 100%;}
	.keypad .key .num3 {background-position:-172px 0;}
	.keypad .key .num3:active {background-position:-172px 100%;}
	.keypad .key .num4 {background-position:-258px 0;}
	.keypad .key .num4:active {background-position:-258px 100%;}
	.keypad .key .num5 {background-position:-344px 0;}
	.keypad .key .num5:active {background-position:-344px 100%;}
	.keypad .key .num6 {background-position:-430px 0;}
	.keypad .key .num6:active {background-position:-430px 100%;}
	.keypad .key .num7 {background-position:-516px 0;}
	.keypad .key .num7:active {background-position:-516px 100%;}
	.keypad .key .num8 {background-position:-602px 0;}
	.keypad .key .num8:active {background-position:-602px 100%;}

	.field {width:240px; height:56px;}
	#nmTyping {width:240px; height:56px; letter-spacing:31px;}
}

@media all and (min-width:375px){
	#nmTyping {width:240px; height:56px; letter-spacing:32px;}
}

@media all and (min-width:480px){
	.keypad {top:5%; width:381px; margin-left:-190px;}
	.keypad .key {margin-top:12%;}
	.keypad .key button {width:123px; height:123px; margin:0 2px; background-size:1107px auto;}
	.keypad .key .num2 {background-position:-123px 0;}
	.keypad .key .num2:active {background-position:-123px 100%;}
	.keypad .key .num3 {background-position:-246px 0;}
	.keypad .key .num3:active {background-position:-246px 100%;}
	.keypad .key .num4 {background-position:-369px 0;}
	.keypad .key .num4:active {background-position:-369px 100%;}
	.keypad .key .num5 {background-position:-492px 0;}
	.keypad .key .num5:active {background-position:-492px 100%;}
	.keypad .key .num6 {background-position:-615px 0;}
	.keypad .key .num6:active {background-position:-615px 100%;}
	.keypad .key .num7 {background-position:-738px 0;}
	.keypad .key .num7:active {background-position:-738px 100%;}
	.keypad .key .num8 {background-position:-861px 0;}
	.keypad .key .num8:active {background-position:-861px 100%;}

	.field {width:340px; height:80px;}
	#nmTyping {width:340px; height:80px; padding-left:22px; font-size:75px; letter-spacing:42px;}

	.keypad .btnConfirm, .keypad .btnpw {margin-top:12%;}

	.noti ul {margin-top:16px;}
	.noti h2 {font-size:17px;}
	.noti ul li {margin-top:4px; font-size:13px;}
}

@media all and (min-width:600px){
	.noti h2 {font-size:20px;}
	.noti ul {margin-top:20px;}
	.noti ul li {margin-top:6px; padding-left:15px; font-size:16px;}
	.noti ul li:after {top:9px;}
}
</style>
<script type="text/javascript">

function checkform(){
	<% If vUserID = "" Then %>
		if ("<%=IsUserLoginOK%>"=="False") {
			parent.calllogin();
			return false;
		}
	<% End If %>
	<% If vUserID <> "" Then %>
		if ($("#nmTyping").text().length< 4) {
			alert("비밀의 문 암호 4자리를 입력해주세요.");
			return false;
		}
		else if ($("#nmTyping").text()!=<%=todayPw%>)
		{
			alert("비밀번호를 다시 확인하시고 입력해주세요");
			$("#nmTyping").empty();
			return false;
		}
		else
		{
			$.ajax({
				type:"GET",
				url:"/apps/appCom/wish/web2014/event/etc/doEventSubscript65479.asp?procdate=<%=procdate%>&chasu=<%=chasu%>&dvalue=<%=dvalue%>&todaypw=<%=todayPw%>",
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
									$("#lyItem").empty().html(res[1]);
									$(".mask").show();
									$("#lyItem").show();
									window.$('html,body').animate({scrollTop:200}, 500);
								}
								else
								{
									errorMsg = res[1].replace(">?n", "\n");
									$("#lyItem").hide();
									$(".mask").hide();
									alert(errorMsg );
									document.location.reload();
									return false;
								}
							} else {
								alert("잘못된 접근 입니다.");
								document.location.reload();
								return false;
							}
						}
					}
				},
				error:function(jqXHR, textStatus, errorThrown){
					alert("잘못된 접근 입니다.");
					var str;
					for(var i in jqXHR)
					{
						 if(jqXHR.hasOwnProperty(i))
						{
							str += jqXHR[i];
						}
					}
					alert(str);
					document.location.reload();
					return false;
				}
			});
		}
	<% End If %>
}

function lyCloseW()
{
	$("#lyToday").hide();
	$("#lyItem").hide();
	$(".mask").fadeOut();
	document.location.reload();
	return false;
}

</script>

<div class="mEvt65477">
	<div class="chamber">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65479/txt_open_chamber.png" alt="발송 된 비밀번호를 입력해보세요! 비밀의 방이 열립니다!" /></p>
		<%' for dev msg : 오늘의 상품보기 %>
		<div id="btnToday" class="btnToday">
			<a href="#lyToday"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65479/btn_today.png" alt="오늘의 상품보기!" /></a>
		</div>
	</div>

	<%' layer 오늘의 상품보기%>
	<div id="lyToday" class="layerBox">
		<figure>
			<% If Trim(Left(now(), 10))="2015-08-19" Then %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/65479/im_today_item_<%=dvalue%>_v1.png" alt="" />
			<% Else %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/65479/im_today_item_<%=dvalue%>.png" alt="" />
			<% End If %>
		</figure>
		<button type="button" class="btnclose"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65479/btn_close_brown.png" alt="오늘의 상품 레이어 팝업 닫기" /></button>
	</div>

	<div class="open">
		<div class="keypad">
			<div class="field">
				<div class="inner">
					<%' for dev msg : pw 입력되는 부분 %>
					<strong id="nmTyping" class="star"></strong>
				</div>
			</div>

			<div class="key">
				<button type="button" class="num1" onclick="goTypeNm(1);">1</button>
				<button type="button" class="num2" onclick="goTypeNm(2);">2</button>
				<button type="button" class="num3" onclick="goTypeNm(3);">3</button>
				<button type="button" class="num4" onclick="goTypeNm(4);">4</button>
				<button type="button" class="num5" onclick="goTypeNm(5);">5</button>
				<button type="button" class="num6" onclick="goTypeNm(6);">6</button>
				<button type="button" class="num7" onclick="goTypeNm(7);">7</button>
				<button type="button" class="num8" onclick="goTypeNm(8);">8</button>
				<button type="button" class="num9" onclick="goTypeNm(9);">9</button>
			</div>
			<button type="button" class="btnConfirm" onclick="checkform();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65479/btn_confirm.png" alt="확인" /></button>

			<%' for dev msg : 얼럿 띄어주세요 오늘의 비밀번호는 0000입니다. %>
			<a href="" class="btnpw"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65479/btn_pw.png" alt="비밀번호 다시 확인하기" /></a>
		</div>
		<img src="http://webimage.10x10.co.kr/eventIMG/2015/65479/img_door.png" alt="" />
	</div>

	<!-- layer 당첨 -->
	<div id="lyItem" class="layerBox"></div>

	<div class="invite">
		<a href="" onclick="fnAPPpopupEvent('65477');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65479/btn_invite.png" alt="매일매일 새로운 문이 열려요 내일의 초대권 신청하러가기" /></a>
	</div>

	<div class="noti">
		<h2><strong>이벤트 안내</strong></h2>
		<ul>
			<li>텐바이텐 고객님을 위한 이벤트 입니다. 비회원이신 경우 회원가입 후 참여해 주세요.</li>
			<li>본 이벤트는 텐바이텐 APP에서만 참여 가능합니다.</li>
			<li>본 이벤트는 ID당 1일 1회만 응모가능 합니다.</li>
			<li>본 이벤트는 주말(토, 일)에는 진행되지 않습니다.</li>
			<li>당첨된 상품은 기본정보에 입력된 주소로 발송됩니다! 마이텐바이텐에서 당첨안내를 확인해주세요.</li>
			<li>이벤트 내 모든 상품의 컬러는 랜덤으로 발송되며, 선택이 불가능합니다.</li>
			<li>5만원 이상의 상품을 받으신 분께는 세무신고를 위해 개인정보를 요청할 수 있습니다. 제세공과금은 고객 부담입니다.</li>
			<li>비밀의 쿠폰은 발급 당일 자정 기준으로 자동 소멸됩니다.(4만원 이상 구매 시 사용 가능)</li>
			<li>당첨된 고객께는 익일 당첨안내 문자가 전송될 예정입니다.</li>
			<li>당첨된 상품은 당첨안내 확인 후에 발송됩니다! 마이텐바이텐에서 당첨안내를 확인해주세요.</li>
		</ul>
	</div>

	<div class="mask"></div>
</div>
<script type="text/javascript">
$(function() {
	$("#btnToday a").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top},800);
	});

	$(".btnpw").click(function(){
		alert("오늘의 비밀번호는 <%=todayPw%>입니다.");
	});

	/* layer */
	$(".btnToday").click(function(){
		$("#lyToday").show();
		$(".mask").fadeIn();
	});


	$(".btnclose, .mask").click(function(){
		$("#lyToday").hide();
		$("#lyItem").hide();
		$(".mask").fadeOut();
	});

	/* keypad */
	$(".key button").click(function(){
		$("#nmTyping").removeClass("star");
	});

});

/* password */
function goTypeNm(nm) {
	if ($("#nmTyping").text().length> 3) {
		alert("비밀번호는 4자리 입니다.");
		$(".key button").unbind();
		return false;
	}
	$("#nmTyping").append(nm);
}
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->

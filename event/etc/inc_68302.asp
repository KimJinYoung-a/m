<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : up! 등업
' History : 2015.12.21 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myTenbytenInfoCls.asp" -->

<% '<!-- #include virtual="/lib/inc/head.asp" --> %>
<%
dim eCode, userid, currenttime
	IF application("Svr_Info") = "Dev" THEN
		eCode = "65992"
	Else
		eCode = "68302"
	End If

	currenttime = now()
	'currenttime = #12/23/2015 10:05:00#

	userid = GetEncLoginUserID()

dim subscriptcount
subscriptcount=0

'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")

	'// 이번달 기준
	dim oMyInfo2, yyyymm, userlevel2, BuyCount2, BuySum2
	set oMyInfo2 = new CMyTenByTenInfo
	oMyInfo2.FRectUserID = userid
	oMyInfo2.GetLastMonthUserLevelData
	    yyyymm			= oMyInfo2.FOneItem.Fyyyymm
	    userlevel2		= oMyInfo2.FOneItem.Fuserlevel
	    BuyCount2		= oMyInfo2.FOneItem.FBuyCount
	    BuySum2			= oMyInfo2.FOneItem.FBuySum
	set oMyInfo2 = Nothing

	'// 다음달 기준
	dim oMyInfo, userlevel, BuyCount, BuySum, NextuserLevel, vLevelUpNeedBuyCount
	set oMyInfo = new CMyTenByTenInfo
	oMyInfo.FRectUserID = userid
	oMyInfo.getNextUserBaseInfoData
	    userlevel		= oMyInfo.FOneItem.Fuserlevel
	    BuyCount		= oMyInfo.FOneItem.FBuyCount
	    BuySum			= oMyInfo.FOneItem.FBuySum
	set oMyInfo = Nothing

	NextuserLevel = getUserLevelByQual(BuyCount,BuySum)			'조건으로 회원등급 확인

	if cStr(userlevel) = "5" and cStr(NextuserLevel) = "0" then NextuserLevel = "5"	'오렌지회원
	if cStr(userlevel) = "7" then NextuserLevel = "7"								'STAFF		'/GetLoginUserLevel
	if GetLoginUserLevel="7" then
		userlevel2 = "7"
		userlevel = "7"
	end if

	dim userlevel2name
	if userlevel2="0" then
		userlevel2name="grYELLOW"
	elseif userlevel2="1" then
		userlevel2name="grGREEN"
	elseif userlevel2="2" then
		userlevel2name="grBLUE"
	elseif userlevel2="3" then
		userlevel2name="grSILVER"
	elseif userlevel2="4" then
		userlevel2name="grGOLD"
	elseif userlevel2="5" then
		userlevel2name="grORANGE"
	elseif userlevel2="7" then
		userlevel2name="grSTAFF"				
	end if

	NextuserLevel = getNextMayLevel(NextuserLevel)
	if GetLoginUserLevel="7" then
		NextuserLevel = "7"
	end if

	dim NextuserLevelname
	Select case NextuserLevel
		case "1"
			NextuserLevelname="GREEN"
		case "2"
			NextuserLevelname="BLUE"
		case "3"
			NextuserLevelname="VIP SILVER"
		case "4"
			NextuserLevelname="VIP GOLD"
		case "7"
			NextuserLevelname="STAFF"
		Case Else
			NextuserLevelname="YELLOW"
	End Select

	dim userlevelname
	if NextuserLevel="0" then
		userlevelname="grYELLOW"
	elseif NextuserLevel="1" then
		userlevelname="grGREEN"
	elseif NextuserLevel="2" then
		userlevelname="grBLUE"
	elseif NextuserLevel="3" then
		userlevelname="grSILVER"
	elseif NextuserLevel="4" then
		userlevelname="grGOLD"
	elseif NextuserLevel="5" then
		userlevelname="grORANGE"
	elseif NextuserLevel="7" then
		userlevelname="grSTAFF"				
	end if

end if

if GetLoginUserID="okkang7" or GetLoginUserID="tozzinet" then
	'response.write userlevel2 & "/" & NextuserLevel
end if
%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:21px;}}

img {vertical-align:top;}
.mEvt68302 {background-color:#f5f5f2;}
.mEvt68302 .topic p , .mEvt68302 legend {visibility:hidden; width:0; height:0;}

.eventBox .check {position:relative;}
.eventBox .check .inner {position:absolute; top:40%; left:0; width:100%; padding:5% 0 30% 45%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/68302/m/up_check_thumb0.png) no-repeat 15% 10%; background-size:7.35rem 7.35rem;}
.eventBox .check ul {width:75%; padding:5% 0; border-top:1px solid #8f8f8f; border-bottom:1px solid #8f8f8f;}
.eventBox .check ul li {padding:3% 0;}
.eventBox .check ul li:after {content:' '; display:block; clear:both;}
.eventBox .check ul li span, .eventBox .check ul li img {vertical-align:top;}
.eventBox .check ul li strong {display:inline-block; min-width:1rem; height:1rem; font-size:1.2rem; line-height:1.1; text-align:right; vertical-align:top;}
.eventBox .check ul li strong em {padding-left:1rem; color:#c0c0c0;}
.eventBox .check .btncheck {position:absolute; bottom:13%; left:0; width:100%; background-color:transparent;}

.eventBox .check div.grSTAFF {background:url(http://webimage.10x10.co.kr/eventIMG/2015/68302/m/up_check_thumb_STAFF.png) no-repeat 15% 10%; background-size:7.35rem 7.35rem;}
.eventBox .check div.grORANGE {background:url(http://webimage.10x10.co.kr/eventIMG/2015/68302/m/up_check_thumb_ORNAGE.png) no-repeat 15% 10%; background-size:7.35rem 7.35rem;}
.eventBox .check div.grYELLOW {background:url(http://webimage.10x10.co.kr/eventIMG/2015/68302/m/up_check_thumb_YELLOW.png) no-repeat 15% 10%; background-size:7.35rem 7.35rem;}
.eventBox .check div.grGREEN {background:url(http://webimage.10x10.co.kr/eventIMG/2015/68302/m/up_check_thumb_GREEN.png) no-repeat 15% 10%; background-size:7.35rem 7.35rem;}
.eventBox .check div.grBLUE {background:url(http://webimage.10x10.co.kr/eventIMG/2015/68302/m/up_check_thumb_BLUE.png) no-repeat 15% 10%; background-size:7.35rem 7.35rem;}
.eventBox .check div.grSILVER {background:url(http://webimage.10x10.co.kr/eventIMG/2015/68302/m/up_check_thumb_SILVER.png) no-repeat 15% 10%; background-size:7.35rem 7.35rem;}
.eventBox .check div.grGOLD {background:url(http://webimage.10x10.co.kr/eventIMG/2015/68302/m/up_check_thumb_GOLD.png) no-repeat 15% 10%; background-size:7.35rem 7.35rem;}
.eventBox .check div.grView ul li strong em {color:#fe3b18;}
.eventBox .check div.grView div {position:absolute; bottom:13%; left:0;}
.eventBox .check div.grView div p {position:relative;}
.eventBox .check div.grView div p strong {position:absolute; top:38%; left:45%; font-size:1.245rem;}
.eventBox .check div.grView div p span {display:block; position:absolute; top:25%; right:15%; font-size:1.2rem; font-weight:bold; border-radius:0.3rem; background-color:#000; color:#fff; width:4.4rem; height:2rem; text-align:center; line-height:2rem; font-family:helveticaNeue, helvetica, sans-serif !important;}

.eventBox .check div.grView div.grUp p span {background-color:#5938b4;}
.eventBox .check div.grView div.grDown p span {background-color:#a58fe1;}
.eventBox .check div.grView div.grMid p span {background-color:#8b8b8b;}
.eventBox .check div.grSTAFF .grTxt {color:#d20000;}
.eventBox .check div.grORANGE .grTxt {color:#ff7c14;}
.eventBox .check div.grYELLOW .grTxt {color:#ffc30b;}
.eventBox .check div.grGREEN .grTxt {color:#44a46f;}
.eventBox .check div.grBLUE .grTxt {color:#57bffa;}
.eventBox .check div.grSILVER .grTxt {color:#8e8d8d;}
.eventBox .check div.grGOLD .grTxt {color:#e3b82c;}


.presentBox {position:relative; background-color:#fff;}
.presentBox ul {position:absolute; left:0; top:20%; overflow:hidden; width:100%;}
.presentBox ul li {float:left; position:relative; width:50%; text-align:center;}
.presentBox ul li label {display:block; margin-bottom:3%;}
.presentBox ul li input {width:16px; height:16px; margin-top:0.5rem; border:1px solid #acacac; border-radius:50%; vertical-align:baseline;}
.presentBox ul li input[type=radio]:checked {background:#fff url(http://webimage.10x10.co.kr/eventIMG/2015/65685/m/bg_input_radio.png) no-repeat 50% 50%; background-size:8px 8px;}
.presentBox ul li:first-child input {margin-left:2rem;}
.presentBox ul li:last-child input {margin-right:2rem;}
.presentBox .btnsubmit input {width:100%;}

.noti {padding:7% 4.68% 8%; background-color:#f1f1f1;}
.noti h3 {margin-bottom:1.3rem; color:#222; font-size:1.4rem; font-weight:bold;}
.noti h3 strong {display:inline-block; padding-bottom:1px; border-bottom:2px solid #222;}
.noti ul li {position:relative; margin-top:3px; padding-left:0.7rem; color:#666; font-size:1.1rem; line-height:1.5em; }
.noti ul li:before {content:''; position:absolute; left:0; top:0.55rem; width:0.2rem; height:0.2rem; border-radius:50% 50%; background-color:#ff6549;}
</style>
<script type="text/javascript">

function jsorder(){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2015-12-23" and left(currenttime,10)<"2016-01-01" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if subscriptcount>0 then %>
				alert("한 개의 아이디당 한 번만 응모가 가능 합니다.");
				return;
			<% else %>
				<% 'if Hour(currenttime) < 10 then %>
					//alert("오전 10시부터 다운 받으실수 있습니다.");
					//return;
				<% 'else %>
					var str = $.ajax({
						type: "POST",
						url: "/event/etc/doeventsubscript/doEventSubscript68302.asp",
						data: "mode=order",
						dataType: "text",
						async: false
					}).responseText;
					//alert(str);
					var str1 = str.split("||")
					//alert(str1[0]);
					if (str1[0] == "04"){
						<% if request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW %>
							//alert("텐바이텐 스탭이시군요!\n직원등급 말고 원래 본인의 회원등급으로 표기해 드릴께요 ^_^");
						<% end if %>

						$("#totalcnt").html(str1[1]);
						$("#totalsum").html(str1[2]);
						$(".inner").addClass("grView <%= userlevelname %>");
						$(".btncheck").hide();
						$("#grval").show();
						evtFrm1.clickvar.value="ON";
						evtFrm1.totalcnt.value=str1[1];
						evtFrm1.totalsum.value=str1[2];
						return false;
					}else if (str1[0] == "03"){
						alert('이벤트 응모 기간이 아닙니다.');
						return false;
					}else if (str1[0] == "02"){
						alert('로그인을 해주세요.');
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
				<% 'end if %>
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End IF %>
}

function jsgift(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2015-12-23" and left(currenttime,10)<"2016-01-01" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if subscriptcount>0 then %>
				alert("한 개의 아이디당 한 번만 응모가 가능 합니다.");
				return;
			<% else %>
				<% 'if Hour(currenttime) < 10 then %>
					//alert("오전 10시부터 다운 받으실수 있습니다.");
					//return;
				<% 'else %>
					if (evtFrm1.clickvar.value!="ON"){
						alert('12월 고객님의 구매내역을 먼저 확인해 주세요.');
						return false;
					}
					if (evtFrm1.totalcnt.value==0 && evtFrm1.totalsum.value==0){
						alert('12월 구매내역이 있어야 응모할수 있습니다.');
						return false;
					}
					var selval;
					for(var i=0; i < evtFrm1.selval.length ;i++){
						if (evtFrm1.selval[i].checked){
							selval = evtFrm1.selval[i].value;
						}
					}

					if (selval==""){
						alert('사은품을 선택해 주세요.');
						return false;
					}

					var str = $.ajax({
						type: "POST",
						url: "/event/etc/doeventsubscript/doEventSubscript68302.asp",
						data: "mode=giftinsert&isapp=<%= isapp %>&selval="+selval,
						dataType: "text",
						async: false
					}).responseText;
					//alert(str);
					var str1 = str.split("||")
					//alert(str1[0]);
					if (str1[0] == "08"){
						alert('응모가 완료 되었습니다.\n당첨자 발표는 1월13일 입니다.');
						location.reload();
						return false;
					}else if (str1[0] == "07"){
						alert('12월 구매내역이 있어야 응모할수 있습니다.');
						return false;
					}else if (str1[0] == "06"){
						alert('사은품을 선택해 주세요!');
						return false;
					}else if (str1[0] == "05"){
						alert('한 개의 아이디당 한 번만 응모가 가능 합니다.');
						return false;
					}else if (str1[0] == "03"){
						alert('이벤트 응모 기간이 아닙니다.');
						return false;
					}else if (str1[0] == "02"){
						alert('로그인을 해주세요.');
						return false;
					}else if (str1[0] == "01"){
						alert('잘못된 접속입니다.');
						return false;
					}else if (str1[0] == "00"){
						alert('정상적인 경로가 아닙니다.');
						return false;
					}else{
						alert('오류가 발생했습니다!');
						return false;
					}
				<% 'end if %>
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End IF %>
}

</script>
</head>
<body>

<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
<input type="hidden" name="mode">
<input type="hidden" name="isapp" value="<%= isApp %>">
<input type="hidden" name="clickvar">
<input type="hidden" name="totalcnt">
<input type="hidden" name="totalsum">
<div class="mEvt68302">
	<article>
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/68302/m/up_tit.png" alt ="업 UP! - 여러분의 구매내역을 확인하세요! 새롭게 등급UP되는 여러분을 응원합니다" /></h2>

		<!-- 구매내역 확인 -->
		<div class="eventBox">
			<div class="check">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/68302/m/up_check.png" alt="12월 고객님의 구매내역을 확인하세요!" /></h3>
				<% '<!-- 1. grView 클래스는 확인하기 이후 무조건 붙여주세요 / 2. grSTAFF/grORANGE/grYELLOW/grGREEN/grBLUE/grSILVER/grGOLD 등급별 클래스 적용해주세요 --> %>
				<div class="inner">
					<ul>
						<li>
							<span class="ftLt"><strong>구매횟수 :</strong></span>
							<span class="ftRt"><strong><em id="totalcnt">*</em> 회</strong></span><!-- 확인하기 이후 em 태그 안에 해당 회수과 금액 숫자 들어가면 됩니다. -->
						</li>
						<li>
							<span class="ftLt"><strong>구매금액 :</strong></span>
							<span class="ftRt"><strong><em id="totalsum">*</em> 원</strong></span>
						</li>
					</ul>
					<button type="button" onclick="jsorder(); return false;" class="btncheck">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/68302/m/up_check_btn.png" alt="확인하기" />
					</button>

					<% '<!-- 확인하기 이후 노출됩니다.--> %>
					<% '<!-- grUp/grMid/grDown 각각 클래스 적용해주세요 --> %>
					<div class="grMid" id="grval" style="display:none">
						<p>
							<img src="http://webimage.10x10.co.kr/eventIMG/2015/68302/m/up_grade_txtbox.png" alt="1월 예상등급" />
							<strong class="grTxt"><%= NextuserLevelname %></strong>
							<%' <!-- UP/-/Down 각각 텍스트 적용해주세요 --> %>
							<!--<span>-</span>-->
						</p>
					</div>
				</div>
			</div>

			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/68302/m/up_txt.png" alt="사은품을 확인하고 응모하세요! 1월 예상등급을 확인하셨다면, 응모하기를 눌러주세요! " /></p>
		<div>
		<!--// 구매내역 확인 -->

		<!-- 받고 싶은 상품 선택 및 응모 -->
		<div class="presentBox">
			<form action="">
				<fieldset>
				<legend>받고 싶은 사은품 선택하고 응모하기</legend>
					<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/68302/m/up_gift.png" alt="선택하신 사은품을 보내드려요!" /></h3>
					<ul>
						<li>
							<label for="select01"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68302/m/up_gift1.png" alt="깊이있는 SOUL FOOD" /></label>
							<input type="radio" id="select01" name="selval" value="01" />
						</li>
						<li>
							<label for="select02"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68302/m/up_gift2.png" alt="감성충만 POINT ITEM" /></label>
							<input type="radio" id="select02" name="selval" value="02" />
						</li>
					</ul>
					<div class="btnsubmit" onclick="jsgift(); return false;"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2015/68302/m/up_btn.png" alt="사은품 응모하기" /></div>
				</fieldset>
			</form>
		</div>

		<div class="noti">
			<h3><strong>이벤트 유의사항</strong></h3>
			<ul>
				<li>이벤트는 SMS 또는 푸쉬로 이벤트 안내를 받으신 회원님만을 위한 혜택입니다.</li>
				<li>응모하기는 이벤트 기간 중 1회만 가능합니다.</li>
				<li>12월 구매내역이 있어야 응모하기가 가능합니다.</li>
				<li>당첨자가 발표 후, 주소 입력이 확인 되면 상품이 발송됩니다. (미 입력시 발송 불가)</li>
				<li>환불이나 교환으로 인해 12월 구매횟수나 구매금액이 충족되지 않을 경우 응모는 자동 취소 됩니다.</li>
				<li>이벤트는 조기종료 될 수 있습니다.</li>
			</ul>
		</div>
	</article>
</div>
</form>

<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->

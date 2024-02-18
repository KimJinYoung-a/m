<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 3월 up! 등업
' History : 2016.03.28 유태욱 생성
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
		eCode = "66095"
	Else
		eCode = "69959"
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

'if GetLoginUserID="baboytw" then
'	response.write userlevel2 & "/" & NextuserLevel
'end if
%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:21px;}}

img {vertical-align:top;}
.mEvt69959 {background-color:#f5f5f2;}
.mEvt69959 .topic p {visibility:hidden; width:0; height:0;}

.eventBox .check {position:relative;}
.eventBox .check .inner {position:absolute; top:40%; left:0; width:100%; height:60%; padding:0 0 0 45%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/68302/m/up_check_thumb0.png) no-repeat 15% 0; background-size:7.35rem 7.35rem;}
.eventBox .check ul {width:75%; padding:3% 0; margin-top:0.75rem; border-top:1px solid #8f8f8f; border-bottom:1px solid #8f8f8f;}
.eventBox .check ul li {padding:3% 0;}
.eventBox .check ul li:after {content:' '; display:block; clear:both;}
.eventBox .check ul li span, .eventBox .check ul li img {vertical-align:top;}
.eventBox .check ul li strong {display:inline-block; min-width:1rem; height:1rem; font-size:1.2rem; line-height:1.1; text-align:right; vertical-align:top;}
.eventBox .check ul li strong em {padding-left:1rem; color:#c0c0c0;}
.eventBox .check .btncheck {position:absolute; bottom:17%; left:0; width:100%; z-index:30; background-color:transparent;}
.eventBox .check div.grSTAFF {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/69959/m/up_check_thumb_STAFF.png);}
.eventBox .check div.grORANGE {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/69959/m/up_check_thumb_ORANGE.png);}
.eventBox .check div.grYELLOW {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/69959/m/up_check_thumb_YELLOW.png);}
.eventBox .check div.grGREEN {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/69959/m/up_check_thumb_GREEN.png);}
.eventBox .check div.grBLUE {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/69959/m/up_check_thumb_BLUE.png);}
.eventBox .check div.grSILVER {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/69959/m/up_check_thumb_SILVER.png);}
.eventBox .check div.grGOLD {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/69959/m/up_check_thumb_GOLD.png);}
.eventBox .check div.grView ul li strong em {color:#fe3b18;}
.eventBox .check div.grSTAFF .grTxt {color:#d20000;}
.eventBox .check div.grORANGE .grTxt {color:#ff7c14;}
.eventBox .check div.grYELLOW .grTxt {color:#ffc30b;}
.eventBox .check div.grGREEN .grTxt {color:#44a46f;}
.eventBox .check div.grBLUE .grTxt {color:#57bffa;}
.eventBox .check div.grSILVER .grTxt {color:#8e8d8d;}
.eventBox .check div.grGOLD .grTxt {color:#e3b82c;}
.eventBox .nextGrade {position:absolute; bottom:0; left:0; width:100%; height:42%; z-index:40;}
.eventBox .nextGrade div {border:1px solid red; width:77%; height:4rem; margin:0 auto; font-weight:bold; font-size:1.2rem; line-height:4.1rem; color:#5b5b5b; text-align:center; border:1px solid #ebebeb; background:#f8f8f8;}

.presentBox {position:relative; background-color:#fff;}
.presentBox .btnsubmit {position:absolute; left:0; bottom:11.4%; width:100%;}
.presentBox .btnsubmit input {width:100%;}

.noti {padding:7% 4.68% 8%; background-color:#f1f1f1;}
.noti h3 {margin-bottom:1.3rem; color:#222; font-size:1.4rem; font-weight:bold;}
.noti h3 strong {display:inline-block; padding-bottom:1px; border-bottom:2px solid #222;}
.noti ul li {position:relative; margin-top:3px; padding-left:0.7rem; color:#666; font-size:1.1rem; line-height:1.5em;}
.noti ul li:before {content:''; position:absolute; left:0; top:0.55rem; width:0.2rem; height:0.2rem; border-radius:50% 50%; background-color:#ff6549;}
</style>
<script type="text/javascript">

function jsorder(){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2016-03-28" and left(currenttime,10)<"2016-04-01" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if subscriptcount>0 then %>
				alert("한 개의 아이디당 한 번만 응모가 가능 합니다.");
				return;
			<% else %>
				var str = $.ajax({
					type: "POST",
					url: "/event/etc/doeventsubscript/doEventSubscript69959.asp",
					data: "mode=order",
					dataType: "text",
					async: false
				}).responseText;
				var str1 = str.split("||")
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
		<% If not( left(currenttime,10)>="2016-03-28" and left(currenttime,10)<"2016-04-01" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if subscriptcount>0 then %>
				alert("한 개의 아이디당 한 번만 응모가 가능 합니다.");
				return;
			<% else %>
				if (evtFrm1.clickvar.value!="ON"){
					alert('3월 고객님의 구매내역을 먼저 확인해 주세요.');
					return false;
				}
				if (evtFrm1.totalcnt.value==0 && evtFrm1.totalsum.value==0){
					alert('3월 구매내역이 있어야 응모할수 있습니다.');
					return false;
				}
				var str = $.ajax({
					type: "POST",
					url: "/event/etc/doeventsubscript/doEventSubscript69959.asp",
					data: "mode=giftinsert&isapp=<%= isapp %>",
					dataType: "text",
					async: false
				}).responseText;
				var str1 = str.split("||")
				//alert(str1[0]);
				if (str1[0] == "08"){
					alert('응모가 완료 되었습니다.\n당첨자 발표는 4월11일 입니다.');
					location.reload();
					return false;
				}else if (str1[0] == "07"){
					alert('3월 구매내역이 있어야 응모할수 있습니다.');
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

<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
<input type="hidden" name="mode">
<input type="hidden" name="isapp" value="<%= isApp %>">
<input type="hidden" name="clickvar">
<input type="hidden" name="totalcnt">
<input type="hidden" name="totalsum">

<div class="mEvt69959">
	<article>
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/69959/m/tit_up.png" alt ="업 UP! - 여러분의 구매내역을 확인하세요! 새롭게 등급UP되는 여러분을 응원합니다" /></h2>
		<%''// 구매내역 확인 %>
		<div class="eventBox">
			<div class="check">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/69959/m/tit_check.png" alt="3월 고객님의 구매내역을 확인하세요!" /></h3>
				<div class="inner"><%''// 1. grView 클래스는 확인하기 이후 무조건 붙여주세요 / 2. grSTAFF/grORANGE/grYELLOW/grGREEN/grBLUE/grSILVER/grGOLD 등급별 클래스 적용해주세요 %>
					<ul>
						<li>
							<span class="ftLt"><strong>구매횟수 :</strong></span>
							<%''// 확인하기 이후 em 태그 안에 해당 횟수과 금액 숫자 들어가면 됩니다. %>
							<span class="ftRt"><strong><em id="totalcnt">*</em> 회</strong></span>
						</li>
						<li>
							<span class="ftLt"><strong>구매금액 :</strong></span>
							<span class="ftRt"><strong><em id="totalsum">*</em> 원</strong></span>
						</li>
					</ul>
					<button type="button" onclick="jsorder(); return false;" class="btncheck">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/68302/m/up_check_btn.png" alt="확인하기" />
					</button>

					<%''// 확인하기 이후 노출됩니다.%>
					<div class="nextGrade" id="grval" style="display:none">
						<div>4월 예상등급 : <em class="grTxt"><%= NextuserLevelname %></em></div>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69959/m/txt_today.png" alt="확인하기" /></p>
					</div>
				</div>
			</div>
		</div>

		<%''// 마일리지 응모 %>
		<div class="presentBox">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/69959/m/tit_apply.png" alt="4월 예상등급 확인하고 응모하세요! 다음달 등급UP되신 분들 중 1천명을 추첨하여 2,000마일리지 증정" /></h3>
			<div class="btnsubmit" onclick="jsgift(); return false;"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2016/69959/m/btn_apply.png" alt="응모하기" /></div>
		</div>
		<div class="noti">
			<h3><strong>이벤트 유의사항</strong></h3>
			<ul>
				<li>이벤트는 SMS 또는 푸쉬로 이벤트 안내를 받으신 회원님만을 위한 혜택입니다.</li>
				<li>응모하기는 이벤트 기간 중 1회만 가능합니다.</li>
				<li>3월 구매내역이 있어야 응모하기가 가능합니다.</li>
				<li>환불이나 교환으로 인해 3월 구매횟수나 구매금액이 충족되지 않을 경우 응모는 자동 취소 됩니다.</li>
				<li>이벤트는 조기종료 될 수 있습니다.</li>
			</ul>
		</div>
	</article>
</div>
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
<!-- #include virtual="/lib/db/dbclose.asp" -->

<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  order 참 잘했어요
' History : 2015.09.24 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode="64897"
Else
	eCode="66419"
End If

dim currenttime
	currenttime =  now()
	'currenttime = #09/25/2015 09:00:00#

dim userid
	userid = GetEncLoginUserID()

dim myuserLevel
	myuserLevel = GetLoginUserLevel

Dim vCount, sqlStr, vTotalCount, vTotalSum

'나의 참여수
vCount = getevent_subscriptexistscount(eCode, userid, "", "", "")
	
'//9월 구매 내역 체킹 (응모는 9월 구매고객만 가능)
'vTotalCount = get10x10onlineordercount(userid, "2015-09-01", "2015-10-01", "'10x10'", "", "", "N")
sqlStr = " EXEC [db_order].[dbo].[sp_Ten_MyOrderList_SUM] '" & userid & "', '', '', '2015-09-01', '2015-10-01', '10x10', '', 'issue' "

'response.write sqlStr & "<br>"
rsget.CursorLocation = adUseClient
rsget.CursorType = adOpenStatic
rsget.LockType = adLockOptimistic
rsget.Open sqlStr,dbget,1
	vTotalCount = rsget("cnt")
	vTotalSum   = CHKIIF(isNull(rsget("tsum")),0,rsget("tsum"))
rsget.Close

'vTotalCount = 1
'vTotalSum = 1000

%>

<% '<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" --> %>
<style type="text/css">
img {vertical-align:top;}
.mEvt66419 {background-color:#f5f5f2;}
.mEvt66419 .topic p , .mEvt66419 legend {visibility:hidden; width:0; height:0;}
.eventBox .check {position:relative;}
.eventBox .check ul {position:absolute; top:31%; left:42%; width:45%; height:27%; padding-top:3%; border-top:1px solid #8f8f8f; border-bottom:1px solid #8f8f8f;}
.eventBox .check ul li {padding-top:6%;}
.eventBox .check ul li:after {content:' '; display:block; clear:both;}
.eventBox .check ul li span, .eventBox .check ul li img {vertical-align:top;}
.eventBox .check ul li strong {display:inline-block; min-width:10px; height:10px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/65685/m/ico_star.png) 100% 0 no-repeat; background-size:150px auto; font-size:12px; line-height:13px; text-align:right; vertical-align:top; }
.eventBox .check ul li strong em {padding-left:10px; background:#fff; color:#e33840;}
.eventBox .check ul li .ftLt img {width:46px;}
.eventBox .check ul li .ftRt img {width:9px; margin-left:5px;}
.eventBox .check .btncheck {position:absolute; bottom:19%; left:50%; width:74%; margin-left:-37%; background-color:transparent;}

.presentBox {padding:9% 0 12%; background-color:#e9e8e3;}
.presentBox .inner {width:90%; margin:0 auto; padding:2% 5.2% 5.2%; background-color:#fff;}
.presentBox .inner {-webkit-box-shadow: 0px 0px 22px 0px rgba(5,5,5,0.20);
-moz-box-shadow: 0px 0px 22px 0px rgba(5,5,5,0.20);
box-shadow: 0px 0px 22px 0px rgba(5,5,5,0.20);}
.presentBox ul {overflow:hidden; margin:2% -3.5% 0;}
.presentBox ul li {float:left; position:relative; width:50%; padding:0 9%; margin-top:6%; text-align:center;}
.presentBox ul li:nth-child(1):after, .presentBox ul li:nth-child(3):after {content:' '; position:absolute; top:0; right:0; width:1px; height:82%; border-right:1px dashed #bfbfbf;}
.presentBox ul li label {display:block; margin-bottom:3%;}
.presentBox ul li input {width:16px; height:16px; margin-top:5px; border:1px solid #acacac; border-radius:50%; vertical-align:baseline;}
.presentBox ul li input[type=radio]:checked {background:#fff url(http://webimage.10x10.co.kr/eventIMG/2015/65685/m/bg_input_radio.png) no-repeat 50% 50%; background-size:8px 8px;}

.presentBox .btnsubmit {width:78.12%; margin:9% auto 0;}
.presentBox .btnsubmit input {width:100%;}

.noti {border-top:3px solid #d2d0c8; padding:7% 4.68% 8%;}
.noti h3 {margin-bottom:13px; color:#222; font-size:14px; font-weight:bold;}
.noti h3 strong {display:inline-block; padding-bottom:1px; border-bottom:2px solid #222;}
.noti ul li {position:relative; margin-top:3px; padding-left:7px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/65685/m/blt_arrow.png) 0 4px no-repeat; background-size:4px auto; color:#000; font-size:11px; line-height:1.5em; }


@media all and (min-width:480px){
	.eventBox .check ul li {padding-top:8%;}
	.eventBox .check ul li strong {min-width:15px; height:15px; background-size:230px auto; font-size:18px; line-height:20px;}
	.eventBox .check ul li strong em {padding-left:15px;}
	.eventBox .check ul li .ftLt img {width:69px;}
	.eventBox .check ul li .ftRt img {width:14px; margin-left:7px;}

	.presentBox ul li input {width:20px; height:20px; margin-top:7px;}
	.presentBox ul li input[type=radio]:checked {background-size:10px 10px;}

	.noti h3 {margin-bottom:20px; font-size:21px;}
	.noti ul li {padding-left:17px; background-position:0 7px; background-size:6px auto; font-size:17px;}
}
@media all and (min-width:768px){
	.eventBox .welcome ul {border-top:2px solid #8f8f8f; border-bottom:2px solid #8f8f8f;}
}
</style>
<script type='text/javascript'>

$(function(){
	if ("<%=IsUserLoginOK%>"=="False") {
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
		return false;
	}
});

function jsSubmitComment(){
	var frm = document.frmGubun2;

	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2015-09-25" and left(currenttime,10)<"2015-10-01" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if not( vTotalCount > 0 and vTotalSum ) > 0 then %>
				alert("응모 대상자가 아닙니다.");
				return;
			<% else %>
				<% if vCount < 1 then %>
					var spointtemp='';
					for (var i=0; i < frm.spointtemp.length; i++){
						if( frm.spointtemp[i].checked ){
							spointtemp = frm.spointtemp[i].value
						}
					}
					if (spointtemp==''){
						alert('사은품을 선택해 주세요.');
						return false;
					}
					frm.spoint.value=spointtemp;

					var totcnt , totsum
					totcnt = $("#totcnt").text();
					totsum = $("#totsum").text();

					if (totcnt == "0" && totcnt == "0" ){
						alert('먼저 구매 내역 확인버튼을 눌러주세요');
						return;
					}else{
						frm.action = "/apps/appCom/wish/web2014/event/etc/doeventsubscript/doEventSubscript66419.asp";
						frm.submit();
					}
				<% else %>
					alert("이미 응모 하셨습니다.");
					return;
				<% End If %>
			<% end if %>
		<% end if %>
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

function chkmyorder(){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2015-09-25" and left(currenttime,10)<"2015-10-01" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			var rstStr = $.ajax({
				type: "POST",
				url: "/apps/appCom/wish/web2014/event/etc/doeventsubscript/doEventSubscript66419.asp",
				data: "mode=myorder",
				dataType: "text",
				async: false
			}).responseText;
			//alert( rstStr );
			$("#tempdiv").empty().append(rstStr);
			$("#totcnt").css("display","block");
			$("#totsum").css("display","block");
			$("#totcnt").text($("div#tcnt").text());
			$("#totsum").text($("div#tsum").text());
		<% end if %>
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
</head>
<body>

<div class="mEvt66419">
	<article>
		<div class="topic">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/66419/tit_good.png" alt ="참 잘했어요!" /></h2>
			<p>8이벤트 기간은 9월 26일부터 9월 30일까지며, 당첨자 발표는 10월 14일입니다.</p>
		</div>

		<% '<!-- 구매내역 확인 --> %>
		<div class="eventBox">
			<div class="check">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/66419/tit_got.png" alt="9월 고객님의 구매내역을 확인하세요!" /></h3>
				<ul>
					<% '<!-- for dev msg : 확인하기 버튼을 누르면 <em>..</em> 보여주세요 --> %>
					<li>
						<span class="ftLt"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66419/txt_count.png" alt ="구매횟수" /></span>
						<span class="ftRt"><strong><em id="totcnt" style="display:none;">0</em></strong><img src="http://webimage.10x10.co.kr/eventIMG/2015/66419/txt_no.png" alt ="회" /></span>
					</li>
					<li>
						<span class="ftLt"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66419/txt_price.png" alt ="구매금액" /></span>
						<span class="ftRt"><strong><em id="totsum" style="display:none;">0</em></strong><img src="http://webimage.10x10.co.kr/eventIMG/2015/66419/txt_won.png" alt ="원" /></span>
					</li>
				</ul>
				<button type="button" onclick="chkmyorder(); return false;" class="btncheck"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66419/btn_check.png" alt="확인하기" /></button>
			</div>

			<div class="check">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66419/txt_present.png" alt="사은품을 확인하고 응모하세요! 구매내역이 있으시면 선물을 확인하고, 하단의 응모하기를 누르세요! 10월 14일 당첨자가 발표됩니다! 500명 추첨" /></p>
			</div>
		<div>
		<!--// 구매내역 확인 -->

		<!-- 받고 싶은 상품 선택 및 응모 -->
		<div class="presentBox">
			<form name="frmGubun2" method="post" style="margin:0px;" target="prociframe">
			<input type="hidden" name="mode" value="add"  />
			<input type="hidden" name="spoint" />
				<fieldset>
				<legend>받고 싶은 사은품 선택하고 응모하기</legend>
					<div class="inner">
						<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/66419/tit_present.png" alt="선택하신 사은품을 보내드려요!" /></h3>
						<ul>
							<li>
								<label for="select01"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66419/txt_label_01.png" alt="깊이있는 SOUL FOOD" /></label>
								<input type="radio" name="spointtemp" value="1" id="select01" />
							</li>
							<li>
								<label for="select02"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66419/txt_label_02.png" alt="감성충만 POINT ITEM" /></label>
								<input type="radio" name="spointtemp" value="2" id="select02" />
							</li>
						</ul>
					</div>

					<div class="btnsubmit"><input type="image" onClick="jsSubmitComment(); return false;" src="http://webimage.10x10.co.kr/eventIMG/2015/66419/btn_submit.png" alt="사은품 응모하기" /></div>
				</fieldset>
			</form>
		</div>

		<div class="noti">
			<h3><strong>이벤트 유의사항</strong></h3>
			<ul>
				<li>이벤트는 이메일 또는 푸쉬로 이벤트 안내를 받으신 회원님만을 위한 헤택입니다.</li>
				<li>응모하기는 이벤트 기간 중 1회만 가능합니다.</li>
				<li>9월 구매내역이 있어야 응모하기가 가능합니다.</li>
				<li>10월 14일 당첨자가 발표되며, 주소 입력 이후 배송됩니다.</li>
				<li>환불이나 교환으로 인해 9월 구매횟수나 구매금액이 충족되지 않을 경우 응모는 자동 취소 됩니다.</li>
				<li>이벤트는 조기종료 될 수 있습니다.</li>
			</ul>
		</div>
	</article>
	<iframe name="prociframe" id="prociframe" frameborder="0" width="0" height="0" style="display:none;"></iframe>
	<div id="tempdiv" style="display:none;"></div>
</div>

<!-- #include virtual="/lib/db/dbclose.asp" -->
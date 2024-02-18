<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 가을을 준비하는 올바른 자세
' History : 2015-08-19 이종화
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
dim eCode, vUserID, userid, myuserLevel, sqlStr, vTotalCount, vTotalSum
	vUserID = GetLoginUserID()
	myuserLevel = GetLoginUserLevel
	userid = vUserID

	IF application("Svr_Info") = "Dev" THEN
		eCode = "64859"
	Else
		eCode = "65685"
	End If

Dim vQuery, vCount
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' AND evt_code = '" & eCode & "' "
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly

	IF Not rsget.Eof Then
		vCount = rsget(0)
	End IF
	rsget.close

	'//7월 구매 내역 체킹 (응모는 7월 구매고객만 가능)
	sqlStr = " EXEC [db_order].[dbo].[sp_Ten_MyOrderList_SUM] '" & userid & "', '', '', '2015-07-01', '2015-08-01', '10x10', '', 'issue' "
	rsget.CursorLocation = adUseClient
	rsget.CursorType = adOpenStatic
	rsget.LockType = adLockOptimistic
	rsget.Open sqlStr,dbget,1
		vTotalCount = rsget("cnt")
		vTotalSum   = CHKIIF(isNull(rsget("tsum")),0,rsget("tsum"))
	rsget.Close

	vTotalCount = 1
	vTotalSum = 1000

%>
<style type="text/css">
img {vertical-align:top;}
.mEvt65685 {background-color:#f5f5f2;}
.mEvt65685 .topic h2 , .mEvt65685 legend {visibility:hidden; width:0; height:0;}
.eventBox .check {position:relative;}
.eventBox .check ul {position:absolute; top:31%; left:42%; width:45%; height:27%; padding-top:3%; border-top:1px solid #8f8f8f; border-bottom:1px solid #8f8f8f;}
.eventBox .check ul li {padding-top:6%;}
.eventBox .check ul li:after {content:' '; display:block; clear:both;}
.eventBox .check ul li span, .eventBox .check ul li img {vertical-align:top;}
.eventBox .check ul li strong {display:inline-block; min-width:10px; height:10px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/65685/m/ico_star.png) 100% 0 no-repeat; background-size:150px auto; font-size:12px; line-height:13px; text-align:right; vertical-align:top; }
.eventBox .check ul li strong em {padding-left:10px; background:#fff; color:#e33840;}
.eventBox .check ul li .ftLt img {width:46px;}
.eventBox .check ul li .ftRt img {width:9px; margin-left:5px;}
.eventBox .check .btncheck {position:absolute; bottom:17%; left:50%; width:74%; margin-left:-37%; background-color:transparent;}

.presentBox {padding:9% 0 12%; background-color:#e9e8e3;}
.presentBox .inner {width:90%; margin:0 auto; padding:2% 5.2% 5.2%; background-color:#fff;}
.presentBox .inner {-webkit-box-shadow: 0px 0px 22px 0px rgba(5,5,5,0.20);
-moz-box-shadow: 0px 0px 22px 0px rgba(5,5,5,0.20);
box-shadow: 0px 0px 22px 0px rgba(5,5,5,0.20);}
.presentBox ul {overflow:hidden; margin:2% -3.5% 0;}
.presentBox ul li {float:left; position:relative; width:50%; margin-top:6%; text-align:center;}
.presentBox ul li:nth-child(1):after, .presentBox ul li:nth-child(3):after {content:' '; position:absolute; top:0; right:0; width:1px; height:80%; border-right:1px dashed #bfbfbf;}
.presentBox ul li a, .presentBox ul li label {display:block; padding:0 7%;}
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
<script>
$(function(){
	<% 
		If vUserID = "" Then 
			if isapp = "1" Then 
	%>
			calllogin();
			return;
	<% Else %>
			jsevtlogin();
			return;
	<% 
			End If 
		End If 
	%>
});

function jsSubmitComment(){
	var frm = document.frmGubun2;

	<% If vUserID = "" Then %>
		<% If isapp="1" Then %>
		calllogin();
		return;
		<% else %>
		jsevtlogin();
		return;
		<% End If %>
	<% End If %>

	<% If Now() > #08/31/2015 23:59:59# Then %>
		alert("이벤트가 종료되었습니다.");
		return;
	<% Elseif Now() < #08/24/2015 00:00:00# Then %>
		alert("이벤트 기간이 아닙니다.");
		return;
	<% else %>
		<% If vUserID <> "" Then %>
			<% if vTotalCount > 0 and vTotalSum > 0 then %>
				<% if vCount = 0 then %>
				var totcnt , totsum
				totcnt = $("#totcnt").text();
				totsum = $("#totsum").text();

				if (!frm.spoint[0].checked && !frm.spoint[1].checked && !frm.spoint[2].checked && !frm.spoint[3].checked)
				{
					alert('상품을 선택 하고 응모하세요');
					return false;
				}

				if (totcnt == "0" && totcnt == "0" ){
					alert('먼저 구매 내역 확인버튼을 눌러주세요');
					return;
				}else{
					frm.action = "/event/etc/doeventsubscript/doEventSubscript65685.asp";
					frm.submit();
				}
				<% else %>
				alert("이미 응모 하셨습니다.");
				return;
				<% End If %>
			<% else %>
				alert("응모 대상자가 아닙니다.");
				return;
			<% End If %>
		<% End If %>
	<% End if %>
}

function chkmyorder(){
	var rstStr = $.ajax({
		type: "POST",
		url: "/event/etc/doeventsubscript/doEventSubscript65685.asp",
		data: "mode=myorder",
		dataType: "text",
		async: false
	}).responseText;
		$("#tempdiv").empty().append(rstStr);
		$("#totcnt").css("display","block");
		$("#totsum").css("display","block");
		$("#totcnt").text($("div#tcnt").text());
		$("#totsum").text($("div#tsum").text());
}
</script>
<div class="mEvt65685">
	<article>
		<div class="topic">
			<h2>가을을 준비하는 올바른 자세</h2>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65685/m/txt_fall.png" alt ="8월 구매내역이 있다면, 가을 감성 가득한 선물에 응모하세요. 1,000명을 추첨하여 선택한 사은품을 보내드립니다! 이벤트 기간은 8월 24일부터 8월 31일까지며, 당첨자 발표는 9월 8일입니다." /></p>
		</div>

		<div class="eventBox">
			<div class="check">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/65685/m/txt_got.png" alt="8월 고객님의 구매내역을 확인하세요!" /></h3>
				<ul>
					<li>
						<span class="ftLt"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65685/m/txt_count.png" alt ="구매횟수" /></span>
						<span class="ftRt"><strong><em id="totcnt" style="display:none;">0</em></strong><img src="http://webimage.10x10.co.kr/eventIMG/2015/65685/m/txt_no.png" alt ="회" /></span>
					</li>
					<li>
						<span class="ftLt"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65685/m/txt_price.png" alt ="구매금액" /></span>
						<span class="ftRt"><strong><em id="totsum" style="display:none;">0</em></strong><img src="http://webimage.10x10.co.kr/eventIMG/2015/65685/m/txt_won.png" alt ="원" /></span>
					</li>
				</ul>
				<button type="button" class="btncheck" onclick="chkmyorder();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65685/m/btn_check.png" alt="확인하기" /></button>
			</div>
			<div class="check">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65685/m/txt_present.png" alt="선물을 확인하고 응모하세요! 구매내역이 있으시면 선물을 확인하고, 하단의 응모하기를 누르세요! 9월 8일 당첨자가 발표됩니다! 1,000명 추첨" /></p>
			</div>
		<div>

		<div class="presentBox">
			<form name="frmGubun2" method="post" style="margin:0px;" target="prociframe">
			<input type="hidden" name="mode" value="add"  />
				<fieldset>
				<legend>받고 싶은 상품을 선택하고 응모하기</legend>
					<div class="inner">
						<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/65685/m/tit_present.png" alt="받고 싶은 상품을 선택하고 응모하세요!" /></h3>
						<ul>
							<li>
								<% If IsApp="1" Then %>
								<a href="" onclick="fnAPPpopupProduct('1182503');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65685/m/img_item_01.jpg" alt="Merry light 2p set" /></a>
								<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1182503"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65685/m/img_item_01.jpg" alt="Merry light 2p set" /></a>
								<% End If %>
								<label for="select01"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65685/m/txt_label_01.png" alt="모두가 매일매일 좋은밤 Merry light 2p set" /></label>
								<input type="radio" id="select01" name="spoint" value="1"/>
							</li>
							<li>
								<% If IsApp="1" Then %>
								<a href="" onclick="fnAPPpopupProduct('1263982');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65685/m/img_item_02.jpg" alt="프리저브드 디퓨저" /></a>
								<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1263982"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65685/m/img_item_02.jpg" alt="프리저브드 디퓨저" /></a>
								<% End If %>
								<label for="select02"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65685/m/txt_label_02.png" alt="가을 향기 가득한 프리저브드 디퓨저" /></label>
								<input type="radio" id="select02" name="spoint" value="2"/>
							</li>
							<li>
								<% If IsApp="1" Then %>
								<a href="" onclick="fnAPPpopupProduct('1040465');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65685/m/img_item_03.jpg" alt="마리안케이트 럭키독 파우치" /></a>
								<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=1040465"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65685/m/img_item_03.jpg" alt="마리안케이트 럭키독 파우치" /></a>
								<% End If %>
								<label for="select03"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65685/m/txt_label_03.png" alt="외출하고싶은 계절 마리안케이트 파우치" /></label>
								<input type="radio" id="select03" name="spoint" value="3"/>
							</li>
							<li>
								<% If IsApp="1" Then %>
								<a href="" onclick="fnAPPpopupProduct('971835');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65685/m/img_item_04.jpg" alt="아이엠 낫 타이어드 아이패치" /></a>
								<% Else %>
								<a href="/category/category_itemPrd.asp?itemid=971835"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65685/m/img_item_04.jpg" alt="아이엠 낫 타이어드 아이패치" /></a>
								<% End If %>
								<label for="select04"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65685/m/txt_label_04.png" alt="촉촉한 가을여자 컨셉 아이엠 낫 타이어드 아이패치" /></label>
								<input type="radio" id="select04" name="spoint" value="4"/>
							</li>
						</ul>
					</div>
					<div class="btnsubmit"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2015/65685/m/btn_submit.png" alt="응모하기" onClick="jsSubmitComment(); return false;"/></div>
				</fieldset>
			</form>
		</div>

		<div class="noti">
			<h3><strong>이벤트 유의사항</strong></h3>
			<ul>
				<li>이벤트는 이메일 또는 푸쉬로 이벤트 안내를 받으신 회원님만을 위한 헤택입니다.</li>
				<li>응모하기는 이벤트 기간 중 1회만 가능합니다.</li>
				<li>8월 구매내역이 있어야 응모하기가 가능합니다.</li>
				<li>9월 8일 당첨자가 발표되며, 주소 입력 이후 배송됩니다.</li>
				<li>환불이나 교환으로 인해 8월 구매횟수나 구매금액이 충족되지 않을 경우 응모는 자동 취소 됩니다.</li>
				<li>이벤트는 조기종료 될 수 있습니다.</li>
			</ul>
		</div>
		<div id="tempdiv" style="display:none;"></div>
		<iframe name="prociframe" id="prociframe" frameborder="0" width="0px" height="0px"></iframe>
	</article>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
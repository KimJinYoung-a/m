<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
	dim eCode, mECd, strSql
	dim chkSubInfo: chkSubInfo=0
	dim chkSubDate
	dim chkOrder: chkOrder=false
	IF application("Svr_Info") = "Dev" THEN
		eCode = "21072"
		mECd = "21073"
	Else
		eCode = "48946"
		mECd = "48948"
	End If

	'// 이벤트 참여 확인
	if IsUserLoginOK then
		strSql = "select sub_opt2, regdate "
		strSql = strSql & "from db_event.dbo.tbl_event_subscript "
		strSql = strSql & "where evt_code=" & eCode
		strSql = strSql & "	and userid='" & GetLoginUserID & "'"
		rsget.Open strSql,dbget,1
		if Not(rsget.EOF or rsget.BOF) then
			chkSubInfo = rsget("sub_opt2")
			chkSubDate = rsget("regdate")
		end if
		rsget.Close
	end if

	'// 이벤트 기간동안 구매이력 확인
	if chkSubInfo=3 then
		strSql = "select count(*) cnt "
		strSql = strSql & "From db_order.dbo.tbl_order_master "
		strSql = strSql & "Where regdate between '2014-02-04' and '2014-02-11' "
		strSql = strSql & "	and ipkumdiv>3 and jumundiv<>'9' and cancelyn='N' and userid='" & GetLoginUserID & "'"
		rsget.Open strSql,dbget,1
		if rsget(0)>0 then
			chkOrder = true
		end if
		rsget.Close
	end if
%>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > TO GET HER, TOGETHER</title>
<style type="text/css">
.mEvt48948 img {vertical-align:top;}
.together legend {visibility:hidden; overflow:hidden; position:absolute; top:-1000%; width:0; height:0; line-height:0;}
.together img {width:100%;}
.together .getClose .mission li span {cursor:pointer;}
.together .getClose .missionEnd {background-color:#ffd1d1;}
.together .getClose .missionEnd input {vertical-align:top;}
.together .getClose .missionEnd ul li {float:left; padding-bottom:15px; text-align:center;}
.together .getClose .missionEnd ul li.giftSelect01, .together .getClose .missionEnd ul li.giftSelect02 {width:28%;}
.together .getClose .missionEnd ul li.giftSelect01 {padding-left:20%; padding-right:2%;}
.together .getClose .missionEnd ul li.giftSelect02 {padding-left:2%; padding-right:20%;}
.together .getClose .missionEnd ul li.giftSelect01 img, .together .getClose .missionEnd ul li.giftSelect02 img {width:100%;}
.together .getClose .missionEnd ul li.giftSelect03, .together .getClose .missionEnd ul li.giftSelect04, .together .getClose .missionEnd ul li.giftSelect05 {width:33.33333%;}
.together .getClose .missionEnd ul li.giftSelect03 img, .together .getClose .missionEnd ul li.giftSelect04 img, .together .getClose .missionEnd ul li.giftSelect05 img {width:84.375%;}
.together .getClose .missionEnd ul li label {display:block; padding-bottom:6px;}
.together .togetherGift ul {overflow:hidden;}
.together .togetherGift ul li {float:left; width:50%;}
.together .togetherNote {background-color:#fde06e;}
.together .togetherNote h3 {padding-bottom:10px;}
.together .togetherNote ul {padding:0 6% 20px;}
.together .togetherNote ul li {margin-top:6px; padding-left:14px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/48948/blt_dot.gif) left 8px no-repeat; background-size:6px 6px; color:#e57d38; font-size:15px; line-height:1.5em;}
@media all and (max-width:480px){
	.together .togetherNote ul {padding:0 5% 20px;}
	.together .togetherNote ul li {padding-left:7px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/48948/blt_dot.gif) left 6px no-repeat; background-size:3px 3px; font-size:11px;}
}
</style>
<script type="text/javascript">
function fnSubmitStep(stp) {
var frm = document.frmSub;
<%
	if IsUserLoginOK then
		if chkSubInfo=0 then
		'// Step1
			Response.Write "if(stp==1) {" & vbCrLf
			Response.Write "	frm.evt_option.value=stp;" & vbCrLf
			Response.Write "	frm.submit();" & vbCrLf
			Response.Write "} else {" & vbCrLf
			Response.Write "	alert(""미션을 먼저 시작해주세요!"");" & vbCrLf
			Response.Write "}" & vbCrLf

		elseif chkSubInfo=1 then
		'// Step2
			Response.Write "if(stp==2) {" & vbCrLf

			if dateDiff("d",chkSubDate,date)=0 then
				Response.Write "	alert(""너무 조급하지 않게!\n내일 다시 들러주세요. :)"");" & vbCrLf
			else
				Response.Write "	frm.evt_option.value=stp;" & vbCrLf
				Response.Write "	frm.submit();" & vbCrLf
			end if
			Response.Write "} else {" & vbCrLf
			Response.Write "	alert(""첫번째 미션을 먼저 완료해주세요!"");" & vbCrLf
			Response.Write "}" & vbCrLf

		elseif chkSubInfo=2 then
		'// Step3
			Response.Write "if(stp==3) {" & vbCrLf
			Response.Write "	frm.evt_option.value=stp;" & vbCrLf
			Response.Write "	frm.submit();" & vbCrLf
			Response.Write "} else {" & vbCrLf
			Response.Write "	alert(""두번째 미션을 완료해주세요!"");" & vbCrLf
			Response.Write "}" & vbCrLf

		elseif chkSubInfo=3 then
		'// Step4
			Response.Write "if(stp==4) {" & vbCrLf
			if chkOrder then
				Response.Write "	frm.evt_option.value=stp;" & vbCrLf
				Response.Write "	frm.submit();" & vbCrLf
			else
				Response.Write "	alert(""조금만 더 노력하면 그녀를 만날 수 있어요!\n지금 바로 설레는 쇼핑을 시작해볼까요?"");" & vbCrLf
			end if
			Response.Write "}" & vbCrLf
		end if
	else
%>
	alert("로그인 후에 응모하실 수 있습니다.");
	top.location.href="<%=M_SSLUrl%>/login/login.asp?backpath=%2Fevent%2Feventmain%2Easp%3Feventid%3D<%=mECd%>";
    return;
<% end if %>
}

function fnSubmitSelect() {
var frm = document.frmSel;
<%
	if IsUserLoginOK then
		if chkSubInfo=5 then
			Response.write "alert(""이미 응모하셨습니다.\n당첨자 발표는 2014년 2월 13일 목요일!\n행운을 빌어요!"");"
			Response.write "return false;"
		else
%>
	if($("#frmSel input[name='evt_option']:checked").length==0) {
		alert("원하는 사은품을 선택해주세요.");
		return false;
	} else {
		return true;
	}
<%
		end if
	else
%>
	alert("로그인 후에 응모하실 수 있습니다.");
	top.location.href="<%=M_SSLUrl%>/login/login.asp?backpath=%2Fevent%2Feventmain%2Easp%3Feventid%3D<%=mECd%>";
    return;
<%	end if %>
}

</script>
</head>
<body>
<div class="content" id="contentArea">
	<div class="mEvt48948">
		<div class="together">
			<h2>
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/48948/tit_together_01.gif" alt="그녀를 잡고 싶다면 TO GET HER" style="width:100%;" />
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/48948/tit_together_02.gif" alt="그녀와 함께 있어요 TOGETHER" style="width:100%;" />
			</h2>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/48948/txt_together_01.gif" alt="무엇 때문인지 단단히 토라져 있는 그녀 하트 속 미션을 하나씩 성공시키면서 그녀를 달래주세요. 너무 오래 기다리게 하지는 말아요! 그녀에게 도착한 당신, 원하는 선물도 고를 수 있어요! " style="width:100%;" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/48948/txt_together_02.gif" alt="이벤트 기간 : 02. 04 ~ 02. 10 | 당첨자 발표 : 02.13" style="width:100%;" /></p>

			<!-- 다가가기 -->
			<div class="getClose">
			<% if chkSubInfo<4 then %>
				<ol class="mission">
					<% if chkSubInfo=0 then %>
					<li><span onclick="fnSubmitStep(1);"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48948/img_get_close_01.gif" alt="그녀에게 가기 전 예쁜 꽃다발 하나쯤은 준비해야겠죠? 로그인 후, 클릭하면 준비 완료! (PC웹 또는 모바일에서 참여 가능) START" style="width:100%;" /></span></li>
					<% else %>
					<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/48948/img_get_close_01<%=chkIIF(chkSubInfo=1,"_on","_end")%>.gif" alt="그녀에게 가기 전 예쁜 꽃다발 하나쯤은 준비해야겠죠? 로그인 후, 클릭하면 준비 완료! (PC웹 또는 모바일에서 참여 가능) START" style="width:100%;" /></li>
					<% end if %>

					<% if chkSubInfo<=1 then %>
					<li><span onclick="fnSubmitStep(2);"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48948/img_get_close_02.gif" alt="STEP 01 한번 더 찾아주세요 그녀를 향한 첫 발걸음! 오늘 찾아온 것처럼 다시 들러주세요. 기회는 2월 10일까지만! (PC웹 또는 모바일에서 참여 가능)" style="width:100%;" /></span></li>
					<% else %>
					<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/48948/img_get_close_02<%=chkIIF(chkSubInfo=2,"_on","_end")%>.gif" alt="STEP 01 한번 더 찾아주세요 그녀를 향한 첫 발걸음! 오늘 찾아온 것처럼 다시 들러주세요. 기회는 2월 10일까지만! (PC웹 또는 모바일에서 참여 가능)" style="width:100%;" /></li>
					<% end if %>

					<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/48948/img_get_close_03<%=chkIIF(chkSubInfo<=2,"","_on")%>.gif" alt="STEP 02 즐겨찾기에 추가 가장 가까운 곳에 두고 자주 찾아주세요. 즐겨 찾는다는 건 그만큼 좋아한다는 뜻이니까요~ (PC웹에서만 참여 가능)" style="width:100%;" /></li>

					<li><span onclick="fnSubmitStep(4);"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48948/img_get_close_04.gif" alt="STEP 03 발렌타인데이 기념 쇼핑 드디어 마지막 관문이예요! 2월 10일까지 그녀, 혹은 나를 위한 쇼핑을 한번쯤은 즐겨주세요~ (PC웹 또는 모바일에서 참여 가능)" style="width:100%;" /></span></li>
				</ol>
			<% else %>
				<form name="frmSel" id="frmSel" method="post" action="/event/etc/doEventSubscript48948.asp" onsubmit="return fnSubmitSelect();" style="margin:0px;" target="prociframe">
				<input type="hidden" name="evt_code" value="<%=eCode%>">
				<input type="hidden" name="mode" value="sel">
				<fieldset>
					<legend>선물 선택하기</legend>
					<div class="missionEnd">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/48948/txt_together_gift_select.gif" alt="당신의 사랑에 그녀도 감동했어요! 자, 이제 아래에서 원하는 선물을 골라봐요!" style="width:100%;" /></p>
						<ul>
							<li class="giftSelect01">
								<label for="giftSelect01"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48948/img_together_gift_select_01.gif" alt="아이띵소 DEAR BAG" /></label>
								<input type="radio" id="giftSelect01" name="evt_option" value="1" />
							</li>
							<li class="giftSelect02">
								<label for="giftSelect02"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48948/img_together_gift_select_02.gif" alt="랑방 메리미 향수 30ml" /></label>
								<input type="radio" id="giftSelect02" name="evt_option" value="2" />
							</li>
							<li class="giftSelect03">
								<label for="giftSelect03"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48948/img_together_gift_select_03.gif" alt="HAPPY SUNRISE 마카롱 5PACK" /></label>
								<input type="radio" id="giftSelect03" name="evt_option" value="3" />
							</li>
							<li class="giftSelect04">
								<label for="giftSelect04"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48948/img_together_gift_select_04.gif" alt="카루셀리 머그컵" /></label>
								<input type="radio" id="giftSelect04" name="evt_option" value="4" />
							</li>
							<li class="giftSelect05">
								<label for="giftSelect05"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48948/img_together_gift_select_05.gif" alt="텐바이텐 1만원 Gift 카드" /></label>
								<input type="radio" id="giftSelect05" name="evt_option" value="5" />
							</li>
						</ul>
						<div><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/48948/btn_enter.gif" alt="응모하기" style="width:100%;" /></div>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/48948/txt_together_gift_select_02.gif" alt="혹시 원하는 선물에 당첨되지 않는다면, 사과의 의미로 달콤한 쿠폰을 드립니다!" style="width:100%;" /></p>
					</div>
				</fieldset>
				</form>
			<% end if %>
			</div>
			<!-- //다가가기 -->

			<div class="togetherGift">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/48948/tit_together_gift.gif" alt="사은품 세 가지 미션을 달성하면 선물을 고를 수 있어요" style="width:100%;" /></h3>
				<ul>
					<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/48948/img_together_gift_01.jpg" alt="고급진 빽 하나는 기본 : 아이띵소 DEAR BAG 10분에게 증정" /></li>
					<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/48948/img_together_gift_02.jpg" alt="사랑은 향기를 남기니까 : 랑방 메리미 향수 30ml 10분에게 증정" /></li>
					<li style="width:35%;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48948/img_together_gift_03.jpg" alt="여자는 달달한걸 좋아해 : HAPPY SUNRISE 마카롱 5PACK 10분에게 증정" /></li>
					<li style="width:32.5%;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48948/img_together_gift_04.jpg" alt="카루셀리 머그컵 : 10분에게 증정내일 뭐해? 차 한잔 할까?" /></li>
					<li style="width:32.5%;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48948/img_together_gift_05.jpg" alt="텐바이텐 쇼핑이 진리! : 텐바이텐 1만원 Gift 카드 10분에게 증정" /></li>
				</ul>
			</div>

			<div class="togetherNote">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/48948/tit_together_note.gif" alt="유의사항 그녀를 만나러 가기 전에 …" /></h3>
				<ul>
					<li>텐바이텐 회원을 위한 혜택입니다. (비회원은 참여가 어려워요.)</li>
					<li>세 가지 미션을 모두 성공했을 때, 사은품을 선택할 수 있습니다.</li>
					<li>이벤트 기간내의 구매 횟수가 높을 수록 당첨 확률이 높아집니다.</li>
					<li>당첨자 발표 후, 경품의 교환 및 양도는 불가합니다.</li>
					<li>당첨되신 분에게는 세무 신고를 위해 개인정보를 요청할 수 있습니다.</li>
					<li>경품지급 후 이벤트 기간 내의 구매가 취소되었을 시, 사은품도 함께 반환하셔야 합니다.</li>
				</ul>
			</div>
		</div>
	</div>
<form name="frmSub" method="post" action="/event/etc/doEventSubscript48948.asp" style="margin:0px;" target="prociframe">
<input type="hidden" name="evt_code" value="<%=eCode%>">
<input type="hidden" name="mode" value="stp">
<input type="hidden" name="evt_option" value="">
</form>
<iframe name="prociframe" id="prociframe" frameborder="0" width="0" height="0" src="about:blank"></iframe>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
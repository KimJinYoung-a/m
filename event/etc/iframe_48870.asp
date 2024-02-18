<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
	Dim vUserID, eCode, vQuery, vArr, vTemp, vRemainCount, vIsSoldOut, vEnterOX
	vUserID = GetLoginUserID
	vEnterOX = "x"
	IF application("Svr_Info") = "Dev" THEN
		eCode = "21068"
	Else
		eCode = "48870"
	End If
	
	''''''''''''''''''rsget(0), rsget(1), rsget(2), 	rsget(3), rsget(4) 
	vQuery = "SELECT i.itemid, i.LimitNo, i.LimitSold, i.SellYn, i.limitYn From [db_item].[dbo].[tbl_item] AS i WHERE i.itemid IN(1000220,1000221,1000223,1000210,1000224)"
	rsget.Open vQuery, dbget, 1
	If Not rsget.Eof Then
		vArr = rsget.getrows()
	End IF
	rsget.close
	
	vQuery = "SELECT count(sub_idx) From [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & vUserID & "' AND evt_code = '" & eCode & "' AND Convert(varchar(10),regdate,120) = '" & date() & "'"


	rsget.Open vQuery, dbget, 1
	If rsget(0) > 0 Then
		vEnterOX = "o"
	End IF
	rsget.close
	
	
	Function fnRemainCount(arr,itemid)
		Dim gg, i, isSoldOut
		If IsArray(arr) Then
			For i=0 To UBound(arr,2)
				If CStr(arr(0,i)) = CStr(itemid) Then
					IF arr(1,i)<>"" and arr(2,i)<>"" Then
						isSoldOut = (arr(3,i)<>"Y") or ((arr(4,i) = "Y") and (clng(arr(1,i))-clng(arr(2,i))<1))
					Else
						isSoldOut = (arr(3,i)<>"Y")
					End If
					
					if IsSoldOut then
						gg = 0
					else
						gg = (clng(arr(1,i)) - clng(arr(2,i)))
					end if
					
					Exit For
				End IF
			Next
		End IF
		fnRemainCount = gg & "||" & isSoldOut
	End Function
%>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 선물이 막걸립니다</title>
<style type="text/css">
.mEvt48870 img {vertical-align:top;}
.mEvt48870 legend {visibility:hidden; overflow:hidden; position:absolute; top:-1000%; width:0; height:0; line-height:0;}
.betweenValentineDay .goods {overflow:hidden;}
.betweenValentineDay .goods li {position:relative; float:left; width:50%;}
.betweenValentineDay .goods li img {width:100%;}
.betweenValentineDay .goods li strong {display:block; position:absolute; left:59%; bottom:13%; width:32px; height:21px; line-height:21px; font-size:15px; font-weight:normal; text-align:right;}
.betweenValentineDay .goods li:nth-child(1) strong, .betweenValentineDay .goods li:nth-child(2) strong {bottom:12.5%;}
.betweenValentineDay .goods li.goodsRight strong {left:48.5%;}
.betweenValentineDay .goods li.goodsWide {width:100%;}
.betweenValentineDay .goods li.goodsWide strong {left:71%; bottom:26%;}
@media all and (max-width:480px){
	.betweenValentineDay .goods li strong {width:21px; height:14px; font-size:12px; line-height:14px;}
}
.betweenValentineDay .betweenEvent02 .giftEnterForm {position:relative;}
.betweenValentineDay .betweenEvent02 .giftEnterForm .iText {height:28px; border:0; background-color:#fff; color:#333; font-size:11px; text-align:center;}
.betweenValentineDay .betweenEvent02 .giftEnterForm .iText:focus {color:#333;}
.betweenValentineDay .betweenEvent02 .giftEnterForm .name {position:absolute; left:28%; top:53.5%;}
.betweenValentineDay .betweenEvent02 .giftEnterForm .name .iText {width:58%;}
.betweenValentineDay .betweenEvent02 .giftEnterForm .phone {position:absolute; left:28%; top:75.5%;}
.betweenValentineDay .betweenEvent02 .giftEnterForm .phone .iText {width:13.5%;}
.betweenValentineDay .betweenEvent02 .giftEnterForm .phone .iText:nth-child(1) {width:12%;}
.betweenValentineDay .betweenEvent02 .giftEnterForm .btnSubmit {position:absolute; right:5%; bottom:5%; width:29.375%;}
.betweenValentineDay .betweenEvent02 .giftEnterForm .btnSubmit input {width:100%;}
@media all and (max-width:480px){
	.betweenValentineDay .betweenEvent02 .giftEnterForm .name {position:absolute; left:28%; top:52.5%;}
	.betweenValentineDay .betweenEvent02 .giftEnterForm .phone {position:absolute; left:28%; top:74.5%;}
	.betweenValentineDay .betweenEvent02 .giftEnterForm .iText {height:19px;}
	.betweenValentineDay .betweenEvent02 .giftEnterForm .name .iText {width:39.5%;}
	
}
</style>
<script type="text/javascript">
$(function() {
	$(".gnb li span").click(function(){
		$(".gnb li").removeClass("current");
		$(this).parent().addClass("current");
	});
});

function jsGoSave(){
<% If vUserID <> "" Then %>
	<% If vEnterOX = "x" Then %>
	if($('input[name="uname"]').val() == ""){
		alert("애인 이름을 입력하세요.");
		$('input[name="uname"]').focus();
		return;
	}
	if($('input[name="uphone1"]').val() == ""){
		alert("애인 핸드폰번호를 입력하세요.");
		$('input[name="uphone1"]').focus();
		return;
	}
	if($('input[name="uphone2"]').val() == ""){
		alert("애인 핸드폰번호를 입력하세요.");
		$('input[name="uphone2"]').focus();
		return;
	}
	if($('input[name="uphone3"]').val() == ""){
		alert("애인 핸드폰번호를 입력하세요.");
		$('input[name="uphone3"]').focus();
		return;
	}
	frm1.submit();
	<% Else %>
	alert("하루에 1회만 응모 가능합니다.\n내일 다시 응모해 주세요!");
	return;
	<% End If %>
<% Else %>
	alert('로그인을 하셔야 이벤트\n응모가 가능합니다.');
	return;
<% End If %>
}
</script>
</head>
<body>
<div class="content" id="contentArea">
	<div class="mEvt48870">
		<div class="betweenValentineDay">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/48870/txt_between_valentine_01.gif" alt="텐바이텐과 비트윈이 함께하는 발렌타인 이벤트" style="width:100%;" /></p>
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/48870/tit_between_valentine_01.gif" alt="氣 살리고~살리고!" style="width:100%;" /></h2>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/48870/txt_between_valentine_02.gif" alt="요즘 애인이 기운 없어 보이나요? 달콤한 사랑 담은 DIY 초콜릿으로 애인 기 한 번 살려주세요! 그리고 응모 이벤트 참여하고 애인에게 기프티콘 선물하세요!" style="width:100%;" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/48870/txt_between_valentine_03.gif" alt="이벤트 기간: 02.03~02.09 한정 수량! 조기 품절 될 수 있습니다." style="width:100%;" /></p>
			<p><a href="/member/join.asp?rdsite=between"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48870/btn_join.gif" alt="아직 텐바이텐 회원이 아니신가요? 회원 가입하고 3,000원 쿠폰 받으세요! 회원 가입하러 가기" style="width:100%;" /></a></p>

			<!-- Event 01 -->
			<div class="betweenEvent01">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/48870/tit_between_valentine_02.gif" alt="기 한 번 살리고! 2014 Best DIY 초콜릿! 스폐셜 최대 20% 할인!" style="width:100%;" /></h3>
				<ul class="goods">
					<%
						vTemp = fnRemainCount(vArr,"1000220")
						vRemainCount	= Split(vTemp,"||")(0)
						vIsSoldOut		= Split(vTemp,"||")(1)
					%>
					<li>
						<a href="/category/category_itemPrd.asp?itemid=1000220&amp;flag=b&amp;rdsite=between">
							<img src="http://webimage.10x10.co.kr/eventIMG/2014/48870/img_goods_01<%=CHKIIF(vIsSoldOut="True","_off","")%>.jpg" alt="슈슈 초콜릿 만들기 세트 32,900 &rarr; 26,300원" />
							<strong <%=CHKIIF(vIsSoldOut="True","style='display:none;'","")%>><%=vRemainCount%></strong>
						</a>
					</li>
					<%
						vTemp = fnRemainCount(vArr,"1000221")
						vRemainCount	= Split(vTemp,"||")(0)
						vIsSoldOut		= Split(vTemp,"||")(1)
					%>
					<li class="goodsRight">
						<a href="/category/category_itemPrd.asp?itemid=1000221&amp;flag=b&amp;rdsite=between">
							<img src="http://webimage.10x10.co.kr/eventIMG/2014/48870/img_goods_02<%=CHKIIF(vIsSoldOut="True","_off","")%>.jpg" alt="로맨틱 부게 초콜릿 만들기 28,300 &rarr; 22,600원" />
							<strong <%=CHKIIF(vIsSoldOut="True","style='display:none;'","")%>><%=vRemainCount%></strong>
						</a>
					</li>
					<%
						vTemp = fnRemainCount(vArr,"1000223")
						vRemainCount	= Split(vTemp,"||")(0)
						vIsSoldOut		= Split(vTemp,"||")(1)
					%>
					<li class="">
						<a href="/category/category_itemPrd.asp?itemid=1000223&&amp;lag=b&amp;rdsite=between">
							<img src="http://webimage.10x10.co.kr/eventIMG/2014/48870/img_goods_03<%=CHKIIF(vIsSoldOut="True","_off","")%>.jpg" alt="야미 파베 초콜릿 만들기 25,000 &rarr; 19,000원" />
							<strong <%=CHKIIF(vIsSoldOut="True","style='display:none;'","")%>><%=vRemainCount%></strong>
						</a>
					</li>
					<%
						vTemp = fnRemainCount(vArr,"1000210")
						vRemainCount	= Split(vTemp,"||")(0)
						vIsSoldOut		= Split(vTemp,"||")(1)
					%>
					<li class="goodsRight">
						<a href="/category/category_itemPrd.asp?itemid=1000210&amp;flag=b&amp;rdsite=between">
							<img src="http://webimage.10x10.co.kr/eventIMG/2014/48870/img_goods_04<%=CHKIIF(vIsSoldOut="True","_off","")%>.jpg" alt="귀요미 로망스컵 초콜릿 28,500 &rarr; 22,800원" />
							<strong <%=CHKIIF(vIsSoldOut="True","style='display:none;'","")%>><%=vRemainCount%></strong>
						</a>
					</li>
					<%
						vTemp = fnRemainCount(vArr,"1000224")
						vRemainCount	= Split(vTemp,"||")(0)
						vIsSoldOut		= Split(vTemp,"||")(1)
					%>
					<li class="goodsWide">
						<a href="/category/category_itemPrd.asp?itemid=1000224&amp;flag=b&amp;rdsite=between">
							<img src="http://webimage.10x10.co.kr/eventIMG/2014/48870/img_goods_05<%=CHKIIF(vIsSoldOut="True","_off","")%>.jpg" alt="요즘 바쁘다면 완제품 세트 추천! 발렌타인데이 A세트 19,530 &rarr; 15,600원" />
							<strong <%=CHKIIF(vIsSoldOut="True","style='display:none;'","")%>><%=vRemainCount%></strong>
						</a>
					</li>
				</ul>
			</div>
			<!-- //Event 01 -->

			<!-- Event 02 -->
			<div class="betweenEvent02">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/48870/tit_between_valentine_03.gif" alt="기 두 번 살리고! 발렌타인 데이트를 위한 깨알 응원 선물 이벤트!" style="width:100%;" /></h3>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/48870/txt_between_valentine_04.gif" alt="내 애인에게 기프티콘을 보내주세요!! 애인 정보(성명/핸드폰)를 입력하고 응모하면, 기프티콘을 애인 핸드폰 번호로, 할인 쿠폰은 나에게 발송됩니다." style="width:100%;" /></p>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/48870/txt_between_valentine_05.gif" alt="Tip! 많이 응모할 수록 당첨 확률은 UP! 이벤트 기간: 02.03~02.09 / 당첨자 발표일: 02.10 오후2시" style="width:100%;" /></p>

				<form name="frm1" method="post" action="doEventSubscript48870.asp">
				<fieldset>
					<legend>애인과 연락처 입력</legend>
					<div class="giftEnterForm">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/48870/txt_between_valentine_06.gif" alt="우리 애인의 사랑스런 이름과 귀한 연락처를 입력해주세요!" style="width:100%;" /></p>
						<div class="name"><input type="text" name="uname" class="iText" title="애인 이름 입력" value="" /></div>
						<div class="phone">
							<input type="text" name="uphone1" class="iText" title="애인 폰번호 앞자리 입력" value="" maxlength="3" />
							<input type="text" name="uphone2" class="iText" title="애인 폰번호 가운데자리 입력" value="" maxlength="4" />
							<input type="text" name="uphone3" class="iText" title="애인 폰번호 뒷자리 입력" value="" maxlength="4" />
						</div>
						<div class="btnSubmit"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48870/btn_enter.png" style="width:100%;" alt="응모하기" onClick="jsGoSave()" /></div>
						<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/48870/txt_between_valentine_07.gif" alt="" style="width:100%;" /></div>
					</div>
				</fieldset>
				</form>

				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/48870/txt_between_valentine_08.gif" alt="아웃백 갈릭립아이 +투움바파스타(3명), CGV주말 예매권 2매 (10명), 까페 아메리카노 Tall 2잔 (50명)" style="width:100%;" /></p>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/48870/txt_between_valentine_09.gif" alt="기프트콘 당첨자외 전원 발렌타인 쿠폰 6,000원 (5만원 이상 구매시) * 쿠폰은 내 아이디로 지급됩니다." style="width:100%;" /></p>

				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/48870/tit_between_valentine_guide.gif" alt="이벤트 안내" style="width:100%;" /></h3>
				<ul>
					<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/48870/txt_between_valentine_guide_01.gif" alt="본 이벤트는 오직 비트윈 고객들만을 위한 이벤트입니다." style="width:100%;" /></li>
					<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/48870/txt_between_valentine_guide_02.gif" alt="이벤트 기간 동안, 비트윈을 통해 가입하신 모든 분들께는 3,000할인    쿠폰을 드립니다. (4만원 이상 구매시/ 이벤트기간 동안만 사용가능)" style="width:100%;" /></li>
					<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/48870/txt_between_valentine_guide_03.gif" alt="한정 판매이므로 상품은 조기품절 될 수 있습니다." style="width:100%;" /></li>
					<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/48870/txt_between_valentine_guide_04.gif" alt="응모 이벤트 참여는 회원가입 후(로그인 후) 가능합니다." style="width:100%;" /></li>
					<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/48870/txt_between_valentine_guide_05.gif" alt="응모 이벤트는 하루에 한 번만 참여 가능합니다." style="width:100%;" /></li>
					<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/48870/txt_between_valentine_guide_06.gif" alt="응모 이벤트의 사은품 중, 발렌타인 쿠폰은 내 아이디로 발급이 되고, 나머지 기프티콘 사은품은 입력하신 애인 연락처로 발급됩니다." style="width:100%;" /></li>
					<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/48870/txt_between_valentine_guide_07.gif" alt="애인 이름과 핸드폰 번호를 정확히 입력해주세요." style="width:100%;" /></li>
					<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/48870/txt_between_valentine_guide_08.gif" alt="기프티콘 사은품은 2월10일 오후2시에 입력하신 애인 연락처로 일괄 발송되며, 발렌타인 쿠폰은 동일한 시간에 내 아이디로 지급될 예정입니다." style="width:100%;" /></li>
					<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/48870/txt_between_valentine_guide_09.gif" alt="발렌 타인 쿠폰의 사용기간은 2014.02.10~02.12(2일간)입니다." style="width:100%;" /></li>
					<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/48870/txt_between_valentine_guide_10.gif" alt="이벤트 문의: 텐바이텐 CS 1644-6030" style="width:100%;" /></li>
				</ul>

				<!--div><a href="/event/eventmain.asp?eventid=48744&amp;rdsite=between"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48870/btn_go_mr_valentine.gif" alt="Mr. Valentine 발렌타인 이벤트 보러가기" style="width:100%;" /></a></div-->
			</div>
			<!-- //Event 02 -->
		</div>
	</div>
	<iframe name="prociframe" id="prociframe" frameborder="0" width="0px" height="0px"></iframe>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
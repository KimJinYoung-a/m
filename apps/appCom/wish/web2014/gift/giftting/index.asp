<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<script type="application/x-javascript" src="/lib/js/iui_clickEffect.js"></script>
<script type="application/x-javascript" src="/lib/js/itemPrdDetail.js"></script>

<%
	Dim vCouponNO
	vCouponNO = requestCheckVar(request("pin_no"),20)

	'// 일시 쿠폰교환 정지 여부 지정
	dim chkDisable, strDsbMsg : chkDisable=false
	if now>"2012-06-15 23:55:00" and now< "2012-06-18 00:00:00" then
		chkDisable=true
		strDsbMsg = "2012년 6월 16일(토) 00시 ~ 17일(일) 24시까지 " &_
					"기프팅 시스템 성능 개선 작업으로 인해 서비스가 일시 중단 됩니다." & vbCrLf &_
					"해당 기간 동안 상품 교환이 불가 합니다." & vbCrLf &_
					"17일 이후에 상품 교환을 부탁 드립니다. 불편을 끼쳐드려 죄송합니다."
	end if
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/oldContent.css">
<title>10x10: 기프팅 교환하기</title>
<script language="javascript">
<% if chkDisable then %>
	alert("<%=Replace(strDsbMsg,vbCrLf,"\n")%>");
<% end if %>

function checkchk()
{
    if(document.frm1.pin_no.value == "")
    {
		alert("인증번호를 입력하세요!");
		document.frm1.pin_no.focus();
		return false;
    }

    var chr1;
    for (var i=0; i<frm1.pin_no.value.length; i++){
        chr1 = frm1.pin_no.value.charAt(i);
        if(!(chr1 >= '0' && chr1 <= '9')) {
            alert("인증번호를 숫자만 입력하세요.");
            frm1.pin_no.value = "";
            frm1.pin_no.focus();
            return false;
        }
    }
    return true;
}

function goNext()
{
	<% if chkDisable then %>
		alert("<%=Replace(strDsbMsg,vbCrLf,"\n")%>");
		return false;
	<% end if %>

	<% If IsUserLoginOK() = "False" Then %>
	if(confirm("비회원 구매 시 주문번호와 성함을\n입력하셔야 주문조회가 가능합니다.\n\n비회원 구매를 진행 하시겠습니까?\n\n※ 취소시 로그인페이지로 이동합니다.") == true) {
	    if (!checkchk()){
	        return false;
	    }

		document.frm1.submit();
	} else {
		location.href = "<%=M_SSLUrl%>/login/login.asp?backpath=/gift/giftting/gate.asp?pin_no=<%=vCouponNO%>";
		return false;
	}
	<% Else %>
	    if (!checkchk()){
	        return;
	    }

		document.frm1.submit();
	<% End If %>
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- content area -->
			<div class="content" id="contentArea">
				<!--카카오톡기프팅 START-->
				<div id="kakao_gifting">
					<h2>기프팅 교환하기</h2>
					<p class="pDesc lPad10">휴대폰으로 받으신 인증번호를 입력해주세요.</p>

					<!--상품정보 START-->
					<div class="gifting_product tMar20">
					<form name="frm1" method="post" action="index_proc.asp">
						<ul>
							<li>
								<table width="95%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<th width="100px"><label for="coupon_num">기프팅 인증번호</label></th>
										<td><input name="pin_no" type="text" id="coupon_num" maxlength="20" value="<%=vCouponNO%>" class="text" style="width:95%;" <%=chkIIF(chkDisable,"disabled style='background-color:#F0F0F0;'","")%> /></td>
									</tr>
								</table>
							</li>
						</ul>
						<div class="ct tMar15">
							<span class="btn btn1 redB w100B"><a href="javascript:goNext()">확인</a></span>
						</div>
					</form>
					</div>
					<!--상품정보 END-->

					<!--정보-->
					<div class="gifting_info">
						<ul class="bulArr round">
							<% if chkDisable then %>
							<li><span class="strong_red"><%=nl2br(strDsbMsg)%></span></li>
							<% end if %>
							<li>기프팅은 상품교환권과 Gift카드교환권 2가지로 구분됩니다.</li>
							<li>Gift카드 기프팅을 사용하시려면 텐바이텐 로그인이 필요합니다.</li>
							<li>옵션이 있는 상품의 경우 텐바이텐에서 기프팅을 상품으로 교환할 때 원하시는 옵션을 선택해주셔야 합니다.</li>
							<li>기프팅으로 받은 상품이 <span class="strong_red">품절일 경우 동일 금액의 텐바이텐 쿠폰(텐바이텐 온라인 및 모바일에서 사용가능)으로 교환</span>해드립니다.</li>
							<li>기프팅을 텐바이텐의 상품으로 교환하시는 경우 단독구매만 가능하시며 텐바이텐의 다른 상품들과 같이 구매 및 결제할 수 없습니다.</li>
							<li><span class="strong_red">기프팅을 텐바이텐 상품 또는 텐바이텐 Gift 카드로 교환한 경우, 취소 및 반품이 불가</span>합니다.</li>
							<li>기프팅 이용 시, 할인 및 기타 제휴 할인 및 마일리지 적립 불가합니다.</li>
							<li>인증번호 오류 시 기프팅 고객센터로 문의 바랍니다. (1666-5046)</li>
						</ul>
					</div>

					<!--CS연결-->
					<div class="cs_center">
						<p><strong>기타 문의사항은 고객센터로 연락주세요.</strong></p>
						<div class="btn_cs">
							<span class="btn btn1 whtB w100B"><a href="tel:1644-6040">1644-6040</a></span>
							<span class="btn btn1 gryB w100B"><a href="/my10x10/qna/myqnalist.asp">1:1 상담</a></span>
						</div>
						<p class="time">AM 09:00~ PM 06:00 (점심시간 : PM 12:00~01:00)<br />주말 공휴일 휴무</p>
					</div>

				</div>
				<!--카카오톡기프팅 END-->
			</div>
			<!-- //content area -->
		</div>
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
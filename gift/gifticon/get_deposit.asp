<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<script type="application/x-javascript" src="/lib/js/iui_clickEffect.js"></script>
<script type="application/x-javascript" src="/lib/js/itemPrdDetail.js"></script>

<%
	Dim vQuery, vIdx, vResult, vOrderserial, vCouponNo, vSellCash, vItemID
	vIdx = requestCheckVar(request("idx"),20)
	If vIdx = "" Then
		Response.Write "<script language='javascript'>alert('잘못된 접근입니다.');document.location.href = '/';</script>"
		dbget.close()
		Response.End
	End If
	IF IsNumeric(vIdx) = false Then
		Response.Write "<script language='javascript'>alert('잘못된 접근입니다.');document.location.href = '/';</script>"
		dbget.close()
		Response.End
	End If

	vQuery = "SELECT * From [db_order].[dbo].[tbl_mobile_gift] Where idx = '" & vIdx & "' AND IsPAy = 'N'"
	rsget.Open vQuery,dbget,1
	IF Not rsget.EOF THEN
		vCouponNo 	= rsget("couponno")
		vItemID		= rsget("itemid")
		rsget.close
	Else
		rsget.close
		dbget.close()
		Response.Write "<script language='javascript'>alert('잘못된 접근입니다.');document.location.href = '/';</script>"
		Response.End
	End IF

	vQuery = "SELECT tot_sellcash From [db_order].[dbo].[tbl_mobile_gift_item] Where itemid = '" & vItemID & "' AND gubun = 'gifticon'"
	rsget.Open vQuery,dbget,1
	IF Not rsget.EOF THEN
		vSellCash = rsget("tot_sellcash")
	End IF
	rsget.close


	Dim vValue, vImage, i, vNowDate, v60LaterDate
	vImage 	= ""
	vValue = vSellCash

	If IsNumeric(vValue) Then
		vValue = FormatNumber(vValue,0)
	End IF

	For i=1 To Len(vValue)
		If Mid(vValue,i,1) = "," Then
			vImage = vImage & "<img src='http://fiximage.10x10.co.kr/m/kakaotalk/coupon_num_com.png' height='42' />"
		Else
			vImage = vImage & "<img src='http://fiximage.10x10.co.kr/m/kakaotalk/coupon_num_" & Mid(vValue,i,1) & ".png' height='42' />"
		End If
	Next


%>
<!doctype html>
<html lang="ko">
<head>
	<!-- #include virtual="/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/oldContent.css">
<script language="javascript">
function goGetCoupon()
{
	<% If IsUserLoginOK() = False Then %>
	alert("예치금 및 사용을 위해서는\n로그인 및 회원가입이 필요합니다.");
	<% Else %>
	document.frm1.submit();
	<% End If %>
}
</script>
<style type="text/css">
.gifticon .gifticon-section {padding:1.71rem 0.85rem; background-color:#fff;}

.gifticon .btn-group {padding:0.85rem;}

.gifticon .alert-text {color:#6e6e6e; font-size:1.11rem; line-height:1.38; background-color:#f4f4f4; text-align:left;}
.gifticon .alert-text .inner {padding:1.71rem 2.5rem 1.71rem 5.03rem;}
.gifticon .alert-text a {color:#ff3131; text-decoration:underline;}

.gifticon-msg {margin-bottom:0.85rem; padding:2.4rem 0; text-align:center; background-color:#fff;}
.gifticon-msg .msg1 {padding-bottom:2.56rem; font-size:1.62rem; line-height:1.3; font-weight:600; color:#000002;}
.gifticon-msg .msg2 {padding-top:1.7rem; font-size:1.1rem; line-height:1.4; color:#6e6e6e; border-top:1px solid #f4f4f4;}
/* 공통 */

.gifti-sold-out {text-align:center;}
.gifti-sold-out {margin:0; padding-bottom:1.45rem;}
.gifti-sold-out .gifticon-msg {margin:0; padding:.68rem 0 1.45rem 0;}
.gifti-sold-out .msg1 .icon-sold-out {display:block; width:4.1rem; height:3.01rem; margin:0 auto 1.45rem; background:url(http://fiximage.10x10.co.kr/m/2017/common/ico_sold_out.png); background-size:100%; }
.gifti-sold-out .msg2 {font-weight:300;}
.gifti-sold-out .msg2 span {font-family:'AvenirNext-Medium', 'AppleSDGothicNeo-Medium'; font-weight:500;}
.gifti-sold-out .msg2 .cash {display:inline-block; min-width:17.01rem; margin:.85rem auto 0; padding:.94rem 2.82rem; background-color:#f8f8f8; border-radius:1.71rem; font-size:1.28rem; font-family: 'AvenirNext-Medium', 'AppleSDGothicNeo-Medium'; font-weight:500;}
.gifti-sold-out .msg2 .cash span {display:inline-block; margin-left:1.58rem; font-family:'AvenirNext-DemiBold', 'AppleSDGothicNeo-SemiBold'; font-weight:bold;}
.gifti-sold-out .btn-group {padding:1.71rem 0.85rem 0;}
.cs-center {margin-top:3.16rem; font-size:1.11rem; line-height:1.38; color:rgba(0,0,0,.4);}
.cs-center span {text-decoration:underline;}
</style>
</head>
<body class="default-font body-sub bg-grey">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<!-- contents -->
	<div id="content" class="content gifticon gifti-sold-out">
		<% If IsUserLoginOK() = False Then %>
		<div class="non-login alert-text">
			<div class="inner">
				<p>예치금 교환 및 사용을 위해서는 <a href="javascript:location.href='<%=M_SSLUrl%>/login/login.asp?backpath=/gift/gifticon/?pin_no=<%=vCouponNO%>'" class="color-red">로그인</a> 혹은 <a href="/member/join.asp" class="color-red">회원가입</a>이 필요합니다.</p>
			</div>
		</div>
		<% End If %>
		<form name="frm1" method="post" action="get_deposit_proc.asp">
			<input type="hidden" name="idx" value="<%=vIdx%>">
		</form>
		<div class="gifticon-section">
			<div class="gifticon-msg">
				<div class="msg1">
					<span class="icon icon-sold-out"></span>
					<p>해당 상품은<span class="color-red">품절</span>되었습니다.</p>
				</div>
				<div class="msg2">
					<p>텐바이텐 온라인 및 모바일에서 사용할 수 있는 <br/ ><span>텐바이텐 예치금</span>으로 교환해 드립니다.</p>
					<!-- <p class="cash color-black">예치금 <span class="color-red">999,999</span> 원</p> -->
				</div>
			</div>
		</div>
		<div class="btn-group">
			<button type="submit" class="btn btn-xlarge btn-red btn-block" onclick="goGetCoupon()">예치금으로 교환하기</a>
		</div>
		<p class="cs-center"><a href="tel:1800-0133">기프티콘 고객센터 <span>1800-0133</span></a></p>

	</div>
	<!-- //contents -->
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
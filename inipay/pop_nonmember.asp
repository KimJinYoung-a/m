<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<% const midx = 0 %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/header.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->

<script language="javascript">
<!--
	function chkAgreement() {
		var fag = document.frm.chkAgree;
		if(!(fag[0].checked||fag[1].checked)) {
			alert("비회원 정보수집 동의사항을 선택해주세요.")
		}
		if(fag[1].checked) {
			self.close();
		} else if(fag[0].checked) {
			opener.TnDoBaguniGuestLogin(opener.document.frmLogin4);
			opener.focus();
			self.close();
		}
	}
//-->
</script>

<div class="toolbar">
	<!-- #INCLUDE Virtual="/lib/inc_topMenu.asp" -->
</div>

<div id="home" selected="true">

<form name="frm">

	<div style="padding:10px 10px 10px 10px;font-size:0.8em;color:#888;text-align:left;">
		<div style="padding:0 0 5px 0;"><img src="http://fiximage.10x10.co.kr/m/login/tit_nomember.png" width="200" /></div>
		<div style="padding:5px 0 10px 0;"><img src="http://fiximage.10x10.co.kr/web2009/order/popup_nomember_img02.gif" width="300"  /></div>
		<div style="padding:5px 5px 5px 5px;border-top:#ddd 1px solid;border-left:#ddd 1px solid;border-right:#ddd 1px solid;border-bottom:#ddd 1px solid;">
		1. 수집하는 개인정보 항목<br>
		&nbsp;&nbsp;- e-mail, 전화번호, 성명, 주소, 은행계좌번호<br>
		<br>
		2. 수집 목적<br>
		&nbsp;&nbsp;① e-mail, 전화번호: 고지의 전달. 불만처리나 주문/배송정보 안내 등 원활한 의사소통경로의 확보.<br>
		&nbsp;&nbsp;② 성명, 주소: 고지의 전달, 청구서, 정확한 상품 배송지의 확보.<br>
		&nbsp;&nbsp;③ 은행계좌번호: 구매상품에 대한 환불시 확보.<br>
		<br>
		3. 개인정보 보유기간<br>
		&nbsp;&nbsp;① 계약 또는 청약철회 등에 관한 기록 : 5년<br>
		&nbsp;&nbsp;② 대금결제 및 재화 등의 공급에 관한 기록 : 5년<br>
		&nbsp;&nbsp;③ 소비자의 불만 또는 분쟁처리에 관한 기록 : 3년<br>
		<br>
		4. 비회원 주문 시 제공하신 모든 정보는 상기 목적에 필요한 용도 이외로는 사용되지
		않습니다. 기타 자세한 사항은 '개인정보취급방침'을 참고하여주시기 바랍니다. <br>
		</div>
		<div style="font-size:1.2em">
				<table border="0" cellspacing="0" cellpadding="0">
				<tr height="20"><td colspan="5"></td></tr>
				<tr>
					<td style="padding:4px 15px 0 0;">위 내용에 동의 하십니까? </td>
					<td><input type="radio" name="chkAgree" id="chkAgree" value="Y" /></td>
					<td style="padding:4px 7px 0 0;"><strong>동의함</strong></td>
					<td><input type="radio" name="chkAgree" id="chkAgree" value="N" /></td>
					<td style="padding-top:4px;"><strong>동의안함</strong></td>
				</tr>
				</table>
		</div>
	</div>
	<div align="center" style="padding:0 0 10px 0;">
		<img src="http://fiximage.10x10.co.kr/m/common/btn_ok02.png" border="0" style="cursor:pointer" onClick="chkAgreement()">
		<img src="http://fiximage.10x10.co.kr/m/common/btn_cancel_01.png" border="0" style="cursor:pointer" onClick="self.close()">
	</div>
</form>

<!-- #INCLUDE Virtual="/lib/inc_bottomMenu.asp" -->
</div>
<!-- #INCLUDE Virtual="/lib/footer.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->
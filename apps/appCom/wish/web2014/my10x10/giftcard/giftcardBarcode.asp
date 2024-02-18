<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/login/checkUserGuestlogin.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/offshop/lib/classes/offshopCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_MyCardInfoCls.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
'##################################################
' PageName : 
' Description : 기프트카드 바코드 
' History : 2019-06-21 최종원 - 리뉴얼
'##################################################
dim oGiftcard, currentCash : currentCash =0
dim userid

userid = getEncLoginUserID

set oGiftcard = new myGiftCard
	oGiftcard.FRectUserid = userid

	if (userid<>"") then
		currentCash = oGiftcard.myGiftCardCurrentCash
	end If
'// 맴버쉽카드 
Dim ClsOSPoint , cardno 
set ClsOSPoint = new COffshopPoint1010
	ClsOSPoint.fnGetMyMemberCard
	cardno = ClsOSPoint.Fcardno
set ClsOSPoint = Nothing	
%>
<script>
	function mreload(){
		window.location.reload();
	}
</script>
</head>
<body class="default-font body-popup">	
	<div id="content" class="content gift-card member-card ">
		<div class="mileage-info ftLt">
			<div class="inner">
				<p>현재 나의 기프트카드</p>
				<div class="my-mileage">
					<%=FormatNumber(currentCash,0)%><span>원</span>
					<button class="btn-reload btn-reload-blue" onclick="mreload();"></button>					
				</div>
			</div>
		</div>

		<div class="barcode-img ftRt">
			<div class="inner" style="background-image:url(http://company.10x10.co.kr/barcode/barcode.asp?image=3&type=25&data=<%=cardno%>&height=95&barwidth=2)"></div>
		</div>
	</div>		
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
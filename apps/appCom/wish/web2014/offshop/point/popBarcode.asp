<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/offshop/lib/classes/offshopCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_mileage_logcls.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
'##################################################
' PageName : /offshop/point/popbarcode.asp
' Description : 바코드 모달창
' History : 2015-04-23 이종화 생성
'##################################################
'//온라인 total-mileage
dim myMileage
set myMileage = new TenPoint
myMileage.FRectUserID = getloginuserid
if (getloginuserid<>"") then
	myMileage.getTotalMileage

	Call SetLoginCurrentMileage(myMileage.FTotalmileage)
end If

'//오프라인 total-mileage
dim myOffMileage
set myOffMileage = new TenPoint
myOffMileage.FGubun = "my10x10"
myOffMileage.FRectUserID = getloginuserid
if (getloginuserid<>"") then
	myOffMileage.getOffShopMileagePop
end If

'// 맴버쉽카드 
Dim ClsOSPoint , cardno 
set ClsOSPoint = new COffshopPoint1010
	ClsOSPoint.fnGetMyMemberCard
	cardno = ClsOSPoint.Fcardno
set ClsOSPoint = Nothing

%>
<script>
<%	if cardno="" or isNull(cardno) then %>
	fnAPPmoveTabMenu('mypage');
	setTimeout(function() {fnAPPclosePopup();},50);
<%	end if %>

	function mreload(){
		$.ajax({
		url: "/apps/appcom/wish/web2014/offshop/point/popbarcode_ajax.asp",
		cache: false,
		async: false,
			success: function(message) {
				$("#tempdiv").empty().append(message);
				$("#reonpoint").text($("#onpoint").text());
				$("#reoffpoint").text($("#offpoint").text());
			}
		});
	}
</script>
</head>
<body class="default-font body-popup">
<div class="layerPopup barCode">	
	<div id="content" class="content member-card">
		<div class="mileage-info ftLt">
			<div class="inner">
				<p>사용 가능한 마일리지</p>
				<div class="my-mileage">
					<%=FormatNumber(getLoginCurrentMileage(),0)%><span>P</span>
					<button class="btn-reload" onclick="mreload();"></button>
				</div>
			</div>
		</div>

		<div class="barcode-img ftRt">
			<div class="inner" style="background-image:url(http://company.10x10.co.kr/barcode/barcode.asp?image=3&type=25&data=<%=cardno%>&height=95&barwidth=2)"></div>
		</div>
	</div>		
</div>
<!--
	<div class="barCodeView">
		<div class="mileageInfo">
			<dl>
				<dt>온라인</dt>
				<dd id="reonpoint"><%=FormatNumber(myMileage.FTotalMileage,0)%>p</dd>
			</dl>
			<dl>
				<dt>오프라인</dt>
				<dd id="reoffpoint"><%=FormatNumber(myOffMileage.FOffShopMileage,0)%>p</dd>
			</dl>
			<p><a href="" onclick="fnAPPpopupBrowserURL('마일리지 내역','<%=wwwUrl%>/apps/appCom/wish/web2014/offshop/point/mileagelist.asp'); return false;">마일리지 내역</a></p>
			<dfn onclick="mreload();">새로고침</dfn>
		</div>
		<div class="barCodeImg">
			<div style="background-image:url(http://company.10x10.co.kr/barcode/barcode.asp?image=3&type=25&data=<%=cardno%>&height=95&barwidth=2);"></div>
		</div>
	</div>
	<div id="tempdiv" style="display:none;"></div>
-->	
</body>
</html>
<%
	Set myMileage = Nothing
	Set myOffMileage = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
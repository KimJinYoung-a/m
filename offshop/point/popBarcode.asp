<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/offshop/lib/classes/offshopCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_mileage_logcls.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
'##################################################
' PageName : /offshop/point/popbarcode.asp
' Description : 바코드 모달창
' History : 2015-04-23 이종화 생성
'			2019-01-15 최종원 - 리뉴얼
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
	function mreload(){
		$.ajax({
		url: "/offshop/point/popbarcode_ajax.asp",
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
	<header class="tenten-header header-popup">
		<div class="title-wrap">
			<h1>멤버십 앱카드</h1>
			<button type="button" class="btn-close" onclick="history.back();">닫기</button>
		</div>
	</header>
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
</body>
</html>
<%
	Set myMileage = Nothing
	Set myOffMileage = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
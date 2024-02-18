<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet="UTF-8"
%>
<!-- #include virtual="/login/checkBaguniLogin.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/classes/ordercls/frontGiftCls.asp" -->
<%
	Dim cGiftt, vEventID, vGiftKindCode, vGiftNoti, vGiftName, vGiftRange, i
	vEventID		= requestCheckVar(request("evid"),10)
	vGiftKindCode	= requestCheckVar(request("gkc"),10)
	vGiftNoti		= Trim(requestCheckVar(request("gnoti"),100))	'### 이거 하나때문에 다른테이블 또 읽고 다른 클래스 수정을 해야하는 비효율이라 그냥 text 받아옴.
	
	Set cGiftt = New CopenGift
	cGiftt.FRectEventCode = vEventID
	cGiftt.FRectGiftKindCode = vGiftKindCode
	cGiftt.getGiftKindItemAddImage
	
	vGiftName = cGiftt.FGiftName
	vGiftRange = cGiftt.FGiftRange
%>
<script type="text/javascript">
$(function(){
	var swiper = new Swiper('.freebieViewV16a .swiper-container', {
		pagination: '.freebieViewV16a .swiper-pagination',
		paginationClickable: true,
		paginationBulletRender: function (index, className) {
		var imgSrc= $('.swiper-slide img').eq(index).attr("src");
			return '<span class="' + className + '">' + '<em><img src="'+ imgSrc + '"/></em>' + '</span>';
		}
	});
});
</script>
</head>
<body>
<div class="layerPopup">
	<div class="popWin">
		<div class="header">
			<h1>사은품 선택</h1>
			<p class="btnPopClose"><button class="pButton" onclick="fnCloseModal();">닫기</button></p>
		</div>
		<!-- content area -->
		<div class="content" id="layerScroll">
			<div id="scrollarea">
				<div class="freebieViewV16a">
					<div class="bxWt1V16a">
						<h2><%=vGiftRange%>원 이상 구매 사은품</h2>
						<p class="fs1-2r cMGy1V16a tMar0-4r"><%=vGiftName%> <%=CHKIIF(vGiftNoti<>"","("&vGiftNoti&")","")%></p>

						<div class="swiper-container">
							<div class="swiper-wrapper">
							<%
							if cGiftt.FResultCount > 0 then
								for i=0 to cGiftt.FResultCount-1
							%>
								<div class="swiper-slide"><img src="<%=cGiftt.FItemList(i).Fgift_kind_addimage%>" alt="사은품이미지<%=i+1%>" /></div>
							<%
								next
							end if
							%>
							</div>
							<div class="swiper-pagination"></div>
						</div>

					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</html>
<% Set cGiftt = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->
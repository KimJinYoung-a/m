<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'#############################################################
'	Description : 모바일 HITCHHIKER Index.asp
'	History		: 2015.01.26 유태욱 생성
'#############################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/hitchhiker/hitchhikerCls.asp"-->
<!-- #include virtual="/lib/classes/enjoy/hitchhikerCls.asp" -->
<%
Dim opreview
set opreview = new CHitchhikerlist
	opreview.Frectisusing = "Y"
	opreview.FrectCurrentpreview = "Y"
	opreview.fngetpreview
	'//최근 오픈 인것이 없으면, 종료된것중 최근것을 가져옴
	if opreview.ftotalcount < 1 then
		set opreview = new CHitchhikerlist
			opreview.Frectisusing = "Y"
			opreview.FrectCurrentpreview = ""
			opreview.fngetpreview
	end if

Dim ovideo
set ovideo = new CHitchhikerlist
	ovideo.Frectisusing = "Y"
	ovideo.FrectCurrentpreview = "Y"
	ovideo.FPageSize = 30
	ovideo.Fgubun = 3
	ovideo.fngetvideo
	'//최근 오픈 인것이 없으면, 종료된것중 최근것을 가져옴
	if ovideo.ftotalcount < 1 then
		set ovideo = new CHitchhikerlist
			ovideo.Frectisusing = "Y"
			ovideo.FrectCurrentpreview = ""
			ovideo.Fgubun = 3
			ovideo.FPageSize = 30
			ovideo.fngetvideo
	end if
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script type="text/javascript">
$(function(){
	showSwiper= new Swiper('.swiper',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		pagination:'.hPagination',
		paginationClickable:true,
		speed:300,
		autoplay:false,
		autoplayDisableOnInteraction: true,
		nextButton:".preview .btnNext",
		prevButton:".preview .btnPrev"
	});
});

var userAgent = navigator.userAgent.toLowerCase();
function gotoDownload(){
	// 모바일 홈페이지 바로가기 링크 생성
	if(userAgent.match('iphone')) { //아이폰
		parent.document.location="https://itunes.apple.com/kr/app/10x10-hichihaikeo/id635127946?mt=8"
	} else if(userAgent.match('ipad')) { //아이패드
		parent.document.location="https://itunes.apple.com/kr/app/10x10-hichihaikeo/id635127946?mt=8"
	} else if(userAgent.match('ipod')) { //아이팟
		parent.document.location="https://itunes.apple.com/kr/app/10x10-hichihaikeo/id635127946?mt=8"
	} else if(userAgent.match('android')) { //안드로이드 기기
		parent.document.location="market://details?id=kr.tenbyten.hitchhiker"
	} else { //그 외
		parent.document.location="https://play.google.com/store/apps/details?id=kr.tenbyten.hitchhiker"
	}
};

function jsViewItem(i){
	<% if isApp=1 then %>
		parent.fnAPPpopupProduct(i);
		return false;
	<% else %>
		top.location.href = "/category/category_itemprd.asp?itemid="+i+"";
		return false;
	<% end if %>
}

// 관심 품목 담기 - 상품 페이지 전용 : 상품 코드로 변경
function TnAddFavoritePrd(iitemid){
<% If IsUserLoginOK() Then %>
	fnAPPpopupBrowserURL("위시폴더","<%=wwwUrl%>/apps/appcom/wish/web2014/common/popWishFolder.asp?itemid="+iitemid+"&ErBValue=3");
<% Else %>
	calllogin();
<% End If %>
}
</script>
</head>
<body class="default-font body-sub">
	<div id="content" class="content">
		<!-- HITCHHIKER -->
		<div class="hitchhikerMain">
			<h2><img src="http://fiximage.10x10.co.kr/m/2014/hitchhiker/tit_hitchhiker.jpg" alt="HITCHHIKER" /></h2>
			<div class="hhCont">
				<div class="section about">
					<h3>about <strong>HITCHHIKER</strong></h3>
					<p>텐바이텐 감성매거진 '히치하이커'는 격월간으로 발행되며,<br />매 호 다른 주제로 일상의 풍경을 담아냅니다.<br />히치하이커가 소소한 즐거움, 작은 위로가 되길 바랍니다.</p>
				</div>
				<% if opreview.ftotalcount > 0 then %>
					<%
					Dim opreviewdetail
					set opreviewdetail = new CHitchhikerlist
						opreviewdetail.Frectmasteridx = opreview.FOneItem.Fidx
						opreviewdetail.Frectisusing = "Y"
						opreviewdetail.Frectdevice = "M"
						opreviewdetail.fngetpreviewdetail
					%>
					<div class="section preview">
						<h3>PREVIEW</h3>
						<div class="swiperWrap">
							<div class="hhSwiper">
								<div class="swiper-container swiper">
								<% if opreviewdetail.FResultCount > 0 then %>
									<div class="swiper-wrapper">
									<% for i = 0 to opreviewdetail.FResultCount - 1 %>
										<div class="swiper-slide"><img src="<%= staticImgUrl %>/hitchhiker/preview/detail/<%= opreviewdetail.FItemList(i).fpreviewimg %>" alt="<%= i %>" /></div>
									<% next %>
									</div>
								<% end if %>
								</div>
								<div class="hPagination"></div>
								<button type="button" class="nav btnPrev"><img src="http://fiximage.10x10.co.kr/m/2014/hitchhiker/btn_slide_prev.png" alt="" /></button>
								<button type="button" class="nav btnNext"><img src="http://fiximage.10x10.co.kr/m/2014/hitchhiker/btn_slide_next.png" alt="" /></button>
							</div>
							<p><img src="http://fiximage.10x10.co.kr/m/2014/hitchhiker/bg_slide.gif" alt ="" /></p>
						</div>
					</div>
				<% end if %>
				<% if ovideo.FResultCount > 0 then %>
				<% i=0 %>
					<div class="section video">
						<h3>VIDEO<span><%= ovideo.FItemList(i).FReqTitle %></span></h3>
						<p class="bPad15">다양한 이야기를 가진 히치하이커 비디오 콘텐츠는<br />매번 새로운 주제로 홀수 달 셋째주 월요일에 업데이트 됩니다.</p>
						<div class="youtube"><iframe src="<%=ovideo.FItemList(i).FReqmovie%>" frameborder="0" webkitallowfullscreen="" mozallowfullscreen="" allowfullscreen=""></iframe></div>
					</div>
				<% end if %>
			</div>
			<!--
			<p><a href="#" onclick="gotoDownload()"><img src="http://fiximage.10x10.co.kr/m/2014/hitchhiker/btn_app_download.gif" alt ="언제든 히치하이커를 만나보세요!" /></a></p>
			-->
		</div>
		<!--// HITCHHIKER -->
	</div>
	<!-- #include virtual="/hitchhiker/inc_hitchitemlist.asp" -->
</body>
</html>
<%
set opreview = nothing
set opreviewdetail = nothing
set ovideo = nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
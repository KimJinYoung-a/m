<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description :  브랜드
' History : 2013.12.13 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/classes/street/sp_ZZimBrandCls.asp" -->
<!-- #INCLUDE Virtual="/lib/classes/street/BrandStreetCls.asp" -->
<%
dim  page, pagesize, SortMethod, OrderType, i, Zzimbrandgubun, vitemarr, vitemarrTemp, vimgblank
	page        = requestCheckVar(request("page"),9)
	pagesize    = requestCheckVar(request("pagesize"),9)
	SortMethod  = requestCheckVar(request("SortMethod"),10)
	OrderType   = requestCheckVar(request("OrderType"),10)

'if page="" then page=1
page=1
'if OrderType="" then OrderType="recent"
OrderType="recent"
Zzimbrandgubun="MY"

dim omyZzimbrand
set omyZzimbrand = new CMyZZimBrand
	omyZzimbrand.FRectUserid = GetLoginUserID
	omyZzimbrand.FCurrPage  = page
	omyZzimbrand.FPageSize  = 6
	omyZzimbrand.FRectOrder = OrderType
	
	'/로그인 상태일경우, 마이 찜 브랜드
	'if GetLoginUserID<>"" then
	   'omyZzimbrand.GetstreetMyZZimBrand
	'end if
	
	'/비로그인 상태 이거나, 로그인중인데 마이 찜 브랜드가 없는경우
	'if omyZzimbrand.FTotalCount<6 then
		omyZzimbrand.GetstreetbestMyZZimBranditem
		
		'Zzimbrandgubun="추천"
	'end if
%>

<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script type="text/javascript">

function TnMyBrandZZim(makerid){
	if (makerid==''){
		alert('브랜드가 없습니다.');
		return;
	}

	<% If IsUserLoginOK() Then %>
		jjimfrm.makerid.value=makerid;
		jjimfrm.action = "/apps/appCom/wish/web2014/street/domybrandjjim.asp";
		jjimfrm.submit();
	<% Else %>
		alert("찜브랜드 추가는 로그인이 필요한 서비스입니다.\n로그인 하시겠습니까?");
		top.location.href = "<%=M_SSLUrl%>/apps/appCom/wish/web2014/login/login.asp?backpath=<%=Server.URLEncode(CurrURLQ())%>";
	<% End If %>
}

$(function(){
	mySwiper1 = new Swiper('.swiper1',{
		pagination:'.bnrPagingV15a',
		paginationClickable:true,
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		autoplay:1700,
		speed:800
	});
	
	// Top버튼 위치 이동
	//$(".goTop").addClass("topHigh");	
});

//브랜드리스트		//2013.12.18 한용민 생성
function moveShowBrandList(chrCd,Lang,flag,page,imgsize){
	//top.location.href = "/apps/appCom/wish/web2014/street/brandlist.asp?page="+page+"&chrCd="+chrCd+"&Lang="+Lang+"&flag="+flag+"&imgsize="+imgsize
	var url = "http://m.10x10.co.kr/apps/appCom/wish/web2014/street/brandlist.asp?page="+page+"&chrCd="+chrCd+"&Lang="+Lang+"&flag="+flag+"&imgsize="+imgsize
	fnAPPpopupBrend_URL(url);
}

//나의 찜브랜드 가기.
function GoMyZzimBrand(){
	top.location.href = "/apps/appCom/wish/web2014/my10x10/myzzimbrand.asp";
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container bgGry">
		<!-- content area -->
		<div class="content" id="contentArea">
			<script type="text/javascript" src="/chtml/street/js/main/brand_MainBranPick_app.js"></script>
			<div class="brandMain inner5">
				<section class="brandWordList inner5">
					<h2 class="tit02"><span>가나다순</span></h2>
					<ul>
						<li onclick="moveShowBrandList('<%=server.URLEnCode("가")%>','K','',1,'');"><span>가</span></li>
						<li onclick="moveShowBrandList('<%=server.URLEnCode("나")%>','K','',1,'');"><span>나</span></li>
						<li onclick="moveShowBrandList('<%=server.URLEnCode("다")%>','K','',1,'');"><span>다</span></li>
						<li onclick="moveShowBrandList('<%=server.URLEnCode("라")%>','K','',1,'');"><span>라</span></li>
						<li onclick="moveShowBrandList('<%=server.URLEnCode("마")%>','K','',1,'');"><span>마</span></li>
						<li onclick="moveShowBrandList('<%=server.URLEnCode("바")%>','K','',1,'');"><span>바</span></li>
						<li onclick="moveShowBrandList('<%=server.URLEnCode("사")%>','K','',1,'');"><span>사</span></li>
						<li onclick="moveShowBrandList('<%=server.URLEnCode("아")%>','K','',1,'');"><span>아</span></li>
						<li onclick="moveShowBrandList('<%=server.URLEnCode("자")%>','K','',1,'');"><span>자</span></li>
						<li onclick="moveShowBrandList('<%=server.URLEnCode("차")%>','K','',1,'');"><span>차</span></li>
						<li onclick="moveShowBrandList('<%=server.URLEnCode("카")%>','K','',1,'');"><span>카</span></li>
						<li onclick="moveShowBrandList('<%=server.URLEnCode("타")%>','K','',1,'');"><span>타</span></li>
						<li onclick="moveShowBrandList('<%=server.URLEnCode("파")%>','K','',1,'');"><span>파</span></li>
						<li onclick="moveShowBrandList('<%=server.URLEnCode("하")%>','K','',1,'');"><span>하</span></li>
					</ul>

					<h2 class="tit02"><span>ABC순</span></h2>
					<ul>
						<li onclick="moveShowBrandList('A','E','',1,'');"><span>A</span></li>
						<li onclick="moveShowBrandList('B','E','',1,'');"><span>B</span></li>
						<li onclick="moveShowBrandList('C','E','',1,'');"><span>C</span></li>
						<li onclick="moveShowBrandList('D','E','',1,'');"><span>D</span></li>
						<li onclick="moveShowBrandList('E','E','',1,'');"><span>E</span></li>
						<li onclick="moveShowBrandList('F','E','',1,'');"><span>F</span></li>
						<li onclick="moveShowBrandList('G','E','',1,'');"><span>G</span></li>
						<li onclick="moveShowBrandList('H','E','',1,'');"><span>H</span></li>
						<li onclick="moveShowBrandList('I','E','',1,'');"><span>I</span></li>
						<li onclick="moveShowBrandList('J','E','',1,'');"><span>J</span></li>
						<li onclick="moveShowBrandList('K','E','',1,'');"><span>K</span></li>
						<li onclick="moveShowBrandList('L','E','',1,'');"><span>L</span></li>
						<li onclick="moveShowBrandList('M','E','',1,'');"><span>M</span></li>
						<li onclick="moveShowBrandList('N','E','',1,'');"><span>N</span></li>
						<li onclick="moveShowBrandList('O','E','',1,'');"><span>O</span></li>
						<li onclick="moveShowBrandList('P','E','',1,'');"><span>P</span></li>
						<li onclick="moveShowBrandList('Q','E','',1,'');"><span>Q</span></li>
						<li onclick="moveShowBrandList('R','E','',1,'');"><span>R</span></li>
						<li onclick="moveShowBrandList('S','E','',1,'');"><span>S</span></li>
						<li onclick="moveShowBrandList('T','E','',1,'');"><span>T</span></li>
						<li onclick="moveShowBrandList('U','E','',1,'');"><span>U</span></li>
						<li onclick="moveShowBrandList('V','E','',1,'');"><span>V</span></li>
						<li onclick="moveShowBrandList('W','E','',1,'');"><span>W</span></li>
						<li onclick="moveShowBrandList('X','E','',1,'');"><span>X</span></li>
						<li onclick="moveShowBrandList('Y','E','',1,'');"><span>Y</span></li>
						<li onclick="moveShowBrandList('Z','E','',1,'');"><span>Z</span></li>
						<li onclick="moveShowBrandList('<%=server.URLEnCode("Σ")%>','E','',1,'');"><span>etc.</span></li>
					</ul>
				</section>

				<div class="btnWrap w100p">
					<div><span class="button btB1 btRed cWh1 w100p"><a href="" onclick="GoMyZzimBrand(); return false;"><%= Zzimbrandgubun %> 찜브랜드</a></span></div>
				</div>
			</div>
		</div>
		<form method="post" name="jjimfrm" style="margin:0px;" target="ifrm">
			<input type="hidden" name="makerid" value="">
		</form>
		<iframe name="ifrm" frameborder="0" width="0" height="0"></iframe>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</div>
</body>
</html>

<%
set omyZzimbrand = nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
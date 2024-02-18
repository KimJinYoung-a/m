<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/itemOptionCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoritecls.asp" -->
<%
dim userid, page, pagesize, SortMethod, OrderType
Dim arrList, intLoop,fidx
userid     	 	= getEncLoginUserID
page       	= requestCheckVar(request("page"),9)
pagesize    	= requestCheckVar(request("pagesize"),9)
SortMethod  	= requestCheckVar(request("SortMethod"),10)
OrderType   	= requestCheckVar(request("OrderType"),10)
fidx			= requestCheckVar(request("fidx"),10)
if page="" then page=1
'if pagesize="" then pagesize= 5
pagesize= 10
if fidx	= "" then fidx = 0

dim myfavorite
set myfavorite = new CMyFavorite

myfavorite.FPageSize        	= pagesize
myfavorite.FCurrpage        	= page
myfavorite.FScrollCount     	= 4
myfavorite.FRectOrderType   	= OrderType
myfavorite.FRectSortMethod  	= SortMethod
myfavorite.FRectUserID      	= userid
myfavorite.FFolderIdx		= fidx	
myfavorite.getMyWishList
arrList = myfavorite.fnGetFolderList	

dim i,j, lp, ix
dim Cols, Rows
Cols = 5
Rows = myfavorite.FResultCount

dim ooption, optionBoxHtml

'######## 위시리스트 이벤트용########
Dim vWishEventIN, vWishEventFIdx, vWishPrice, vWishTotal, vWishEventOX
	vWishEventIN = "x"
	vWishEventFIdx = 999999
	
	myfavorite.FRectUserID	= userid
	myfavorite.FFolderIdx	= fidx
	myfavorite.fnWishListEventView
	
	vWishPrice = myfavorite.FWishEventPrice
	vWishTotal = myfavorite.FWishEventTotalCnt
'####################################
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: 위시:MY WISH</title>
<script language='javascript'>
function SwapFidx(fidx){
	document.frmsearch.fidx.value = fidx;
	document.frmsearch.submit();
}


// 상품목록 페이지 이동
function goPage(pg){
	var frm = document.frmsearch;
	frm.action="mywishlist.asp";
	frm.page.value=pg;
	frm.submit();
}

function DelFavItems(itemid){
	var frm = document.SubmitFrm;
    if (frm.bagarray==undefined) return;
    
    var buf = "";
    
    frm.bagarray.value = "";
	frm.bagarray.value = itemid;

    if (frm.bagarray.value == "") {
        alert("선택된 상품이 없습니다.");
        return;
    }

    if (confirm("선택된 상품을 삭제 하시겠습니까?") == true) {
        frm.mode.value = "DelFavItems";
        frm.action = "/my10x10/myfavorite_process.asp";

        frm.submit();
    }
}

function jsChangeFolder(itemid){
	SubmitFrm.bagarray.value = itemid;
	SubmitFrm.submit();
}

// 관심 품목 담기 - 상품 페이지 전용 : 상품 코드로 변경
function TnAddFavoritePrd(iitemid){
	var popwin = window.open('/my10x10/popMyFavorite.asp?ispop=pop&mode=Change&fidx=<%=fidx%>&bagarray=' + iitemid + '&backurl=', 'FavoritePrd', 'width=500,height=500,scrollbars=yes,resizable=yes');
	popwin.focus();
}

function jsWishEvent()
{
	var frm = document.frm;
	if (!frm.pname.value)
	{
		alert("폴더 이름을 붙여주세요");
		frm.pname.focus();
		return;
	}else{

		//wishlistevent.location.href = "/my10x10/event/myfavorite_folderProc.asp?hidM=I&pname"+document.frm.pname.value;
		frm.target= "wishlistevent";
		frm.action= "/my10x10/event/myfavorite_folderProc.asp";
		frm.submit();
	}
	
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
				<div class="innerW tPad15">
					<h2>WISH</h2>
					<p class="c999 ftMidSm2 tMar05">바로 지금! 다른 사람들의 ♥위시는?<br /><strong>POPULAR</strong> 위시에서 텐바이텐의 쇼핑 트랜드를 만나보세요.</p>
				</div>
				<ul class="tabItem tMar20">
					<li class="w50"><a href="/my10x10/popularwish.asp">POPULAR<span class="elmBg"></span></a></li>
					<li class="on w50"><a href="/my10x10/mywishlist.asp">MY WISH<span class="elmBg"></span></a></li>
				</ul>

				<div class="overHidden topGyBdr inner bgf7f7f7">
					<form name="frmsearch" method="post" action="mywishlist.asp" style="margin:0px;">
					<input type="hidden" name="fidx" value="<%=fidx%>">
					<input type="hidden" name="page" value="1"> 
					<select class="ftLt" id="foldernameselectbox" onChange="SwapFidx(this.value);">
						<option value="0" <%=CHKIIF(Cstr(fidx)="0","selected","")%>>기본폴더</option>
						<% IF isArray(arrList) THEN
							For intLoop = 0 To UBound(arrList,2)
	
								If Left(Replace(arrList(1,intLoop),chr(32),""),11) = "[pick show]" Then
									vWishEventIN = "o"
								End If
									
								'//이벤트용
								If Cstr(fidx) = Cstr(arrList(0,intloop))  Then
									If Left(Replace(arrList(1,intLoop),chr(32),""),11) = "[pick show]" Then
										vWishEventOX = "o"
										vWishEventFIdx = arrList(0,intloop)
									End If
								End If

								Response.Write "<option value=""" & arrList(0,intloop) & """ " & CHKIIF(Cstr(fidx)=Cstr(arrList(0,intloop)),"selected","") & ">" & arrList(1,intLoop) & "</option>"
							Next
						End IF
						%>
					</select>
					</form>
					<span class="ftRt btn btn3 gryB2 w70B"><a href="popmyfavorite_folder.asp">폴더관리</a></span>
				</div>
				<%
				'### 위시리스트 이벤트 이고 8월 22일 00시 이후 부터 시작
				'If vWishEventIN = "o" AND Now() >= #07/30/2013 00:00:00# Then
				If Now() > #10/04/2013 00:00:00# AND Now() < #10/14/2013 00:00:00# Then
				%>
				<!-- <dl class="btmGrBdr topGrBdr tPad10 lMar10 rMar10 bMar10">
					<dt class="c333 ftMidSm"><strong>&lt;몽땅 비워드릴게요!&gt; 이벤트에 참여하세요</strong> <img src="http://fiximage.10x10.co.kr/m/2013/common/tag_ongoing.png" alt="진행중" class="vTop" style="height:14px;" /></dt>
					<dd class="c999 ftSmall tMar05 lh14">
						<span class="c00a9af">약 20만원 상당</span>의 원하는 상품을 <span class="c333">[pick show]</span> 폴더에 담아주세요.
						<ul class="listArr">
							<li class="elmBg3">이벤트 종료일시 : <span class="c00a9af">10월 14일 24시</span></li>
							<li class="elmBg3 c333">이벤트 자세히 보러가기 <a href="/event/eventmain.asp?eventid=44899" class="vMid"><img src="http://fiximage.10x10.co.kr/m/2013/common/btn_go.png" alt="GO" style="height:12px;" /></a></li>
						</ul>

						<% If vWishEventIN <> "o" then %>
						<p class="ct tMar10 bMar10"><span class="btn btn1 dkGryB w90B arrowBg2"><a href="#" onClick="jsWishEvent()"><em class="elmBg3">참여하기</em></a></span></p>
						<% End If %>
						<% If vWishEventOX = "o" Then %>
						<div class="bgGry4 c333 innerH15 ct tMar10">
							현재 [pick show] 폴더에 담으신 상품의 갯수와 금액은<br /><strong class="cC40"><%=FormatNumber(vWishTotal,0)%></strong>개 <strong class="cC40"><%=FormatNumber(vWishPrice,0)%></strong>원 입니다.
						</div>
						<% End If %>
					</dd>
				</dl> -->
				<!-- pick show -->
				<form name="frm" method="post">
				<input type="hidden" name="hidM" value="I">
				<div class="ct bPad20 btmGyBdr">
					<div class="tPad15 bPad20" style="background:#fff647;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45783/45783_wish_txt.png" alt="지상최대의 Pick Show 여러분의 참여를 기다립니다" style="width:270px;" /></div>
					<p class="tMar10 bMar10"><input type="text" class="text lh1" style="width:94%" placeholder="추가할 폴더명을 입력하세요." name="pname" /></p>
					<div>
						<span class="btn btn3 whtB w80B"><a href="/event/eventmain.asp?eventid=45783">이벤트 확인</a></span>
						<span class="btn btn3 redB w80B"><a href="javascript:jsWishEvent()">참여하기</a></span>
					</div>
				</div>
				</form>
				<!--// pick show -->
				<%
				End If
				%>
				<div class="wishList topGyBdr btmGyBdr">
				<% If (myfavorite.FResultCount < 1) Then %>
					<div class="afterNone bgDiagonal tMar20">
						<div class="box1 bgWt rdBox2 inner15 ct ftMidSm2 b tMar05">
							<em class="elmBg"></em>
							등록된 위시 상품이 없습니다.
						</div>
					</div>
				<% else
					for i = 0 to Rows-1
				%>
					<ul class="tMar15">
						<li>
							<div class="time">
								<span class="frLt" id="foldername"></span>
								<span class="ftRt elmBg"><%= Left(myfavorite.FItemList(i).Fregdate,10) %></span>
								<span class="arr"></span>
							</div>
							<div class="innerW tPad15">
								<p class="ftSmall c999"><a href="/street/street_brand.asp?makerid=<%=myfavorite.FItemList(i).Fmakerid%>"><u><%= myfavorite.FItemList(i).FBrandName %></u></a></p>
								<p class="ftMidSm b tMar05"><%= myfavorite.FItemList(i).FItemName %></p>
							</div>
							<div class="pic" onClick="location.href='/category/category_itemPrd.asp?itemid=<%= myfavorite.FItemList(i).FItemID %>';"><img src="<%= myfavorite.FItemList(i).FImageBasic %>" alt="<%= myfavorite.FItemList(i).FItemName %>" style="width:100%" /></div>
							<div class="overHidden inner bPad15">
								<p class="ftLt">
									<span class="btn btn1 redB w80B folderBg"><a href="javascript:TnAddFavoritePrd('<%= myfavorite.FItemList(i).FItemID %>');"><em class="elmBg3">폴더이동</em></a></span>
									<span class="btn btn1 gryB w70B delBg"><a href="javascript:DelFavItems('<%= myfavorite.FItemList(i).FItemID %>');"><em class="elmBg3">삭제</em></a></span>
								</p>
								<p class="tMar10 ftRt">
									<span class="heartBg cC40"><em class="elmBg3"><%= FormatNumber(myfavorite.FItemList(i).FFavCount,0) %></em></span>
								</p>
							</div>
						</li>
					</ul>
				<%
					next
				   end if %>
				</div>
				<br /><br />
				<%=fnDisplayPaging_New(page,myfavorite.FTotalCount,PageSize,4,"goPage")%>
				<form name="SubmitFrm" method="post" action="/my10x10/popMyFavorite.asp" style="margin:0px;">
				<input type="hidden" name="mode" value="Change">
				<input type="hidden" name="bagarray" value="">
				<input type="hidden" name="fidx" value="<%=fidx%>">
				<input type="hidden" name="backurl" value="/my10x10/mywishlist.asp">
				</form>
			</div>
			<!-- //content area -->
			<iframe src="about:blank" name="wishlistevent" frameborder="0" width="0" height="0"></iframe>
		</div>
		<!-- #include virtual="/lib/inc/incFooter.asp" -->
	</div>
	<!-- #include virtual="/category/incCategory.asp" -->
</div>
<script>
$("*#foldername").text($("#foldernameselectbox option:selected").text());
</script>
</body>
</html>
<%
set myfavorite = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
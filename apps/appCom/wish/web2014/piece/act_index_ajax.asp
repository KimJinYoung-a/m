<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/piece/piececls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls_useDB.asp" -->
<%
	'####################################################
	' Description :  피스 리스트
	' History : 2017-11-17 이종화 수정
	'####################################################
	
	Dim SearchText, CurrPage, PageSize, i, t, p, oPi, vTotalCount, vWishArr, vListGubun, vAdminID
	Dim vLinkItemID, vItemID, vBasicImage, vP_NickName , piecepop , oPie
	'// A/B 테스트용
	Dim RvSelPiece

	SearchText	 	= requestCheckVar(request("rect"),100)
	CurrPage		= getNumeric(requestCheckVar(request("cpg"),8))
	PageSize		= requestCheckVar(request("psz"),5)
	vAdminID		= requestCheckVar(request("adminid"),50)
	piecepop		= requestCheckVar(request("piecepop"),2)
	RvSelPiece		= requestCheckVar(request("RvSelPiece"),1)
	
	'SearchText = "내용"
	if CurrPage="" then CurrPage="1"
    if PageSize="" then PageSize="5"
    	
    '## list 일때는 gubun이 모두 나오나, allsearch와 tagsearch 는 (배너,베스트키워드,파이를제외한조각검색결과만노출) 라고 기획서에 표기되있음.
    If SearchText = "" Then
    	vListGubun = "list"
    Else
		vListGubun = "allsearch"
	End If
        
	If vAdminID <> "" Then
		vListGubun = "allsearch"
	End If
        

	'// 검색결과 내위시 표시정보 접수
	if IsUserLoginOK then
		'// 검색결과 상품목록 작성
		vWishArr = fnGetMyPieceWishItem()
	end if
%>
<%
'// 검색결과
set oPi = new SearchPieceCls
oPi.FRectSearchTxt = SearchText
oPi.FCurrPage = CurrPage
oPi.FPageSize = PageSize
oPi.FRectSearchGubun = vListGubun
oPi.FRectAdminID = vAdminID
oPi.FRectIsOpening = ""
oPi.FScrollCount = 10
oPi.getPieceList2017

vTotalCount = oPi.FTotalCount

If oPi.FResultCount > 0 Then
%>
<script type="text/javascript">
$(function(){
	/// app용 스와이퍼 정의
	var tagitemSwiper = new Swiper(".tag-and-items .swiper-container", {
		slidesPerView:"auto",
		freeMode:true,
		freeModeMomentumRatio:0.5
	});

	var pieSwiper = new Swiper(".pie .swiper-container", {
		slidesPerView:"auto"
	});

	$('.pie img').load(function(){
		$('.pie .swiper-slide .thumbnail img').each(function(){
			var pieImgH = $(this).height();
			$(this).css('margin-top', -pieImgH/2+'px');
		});
	});
});
</script>
<%
	For i = 0 To oPi.FResultCount-1
	
	vP_NickName = oPi.FItemList(i).Fnickname

	If oPi.FItemList(i).Fpitem <> "" Then
		vLinkItemID = Split(Split(oPi.FItemList(i).Fpitem,",")(0),"$$")(0)
	End If
%>
	<% If oPi.FItemList(i).Fgubun = "1" Then '### 조각 %>
		<!-- #include file="./inc_piece.asp" -->
	<% ElseIf oPi.FItemList(i).Fgubun = "4" Then	'### 배너 %>
		<% If oPi.FItemList(i).Fbannergubun = "1" Then	'### 텍스트 %>
		<div class="bnr bnr-piece-ad type-text">
			<a href="<%=oPi.FItemList(i).Fetclink%>"><%=oPi.FItemList(i).Flisttitle%></a>
		</div>
		<% ElseIf oPi.FItemList(i).Fbannergubun = "2" Then	'### 이미지 %>
		<div class="bnr bnr-piece-ad type-img">
			<a href="<%=oPi.FItemList(i).Fetclink%>"><div class="thumbnail"><img src="<%=oPi.FItemList(i).Flistimg%>" alt=""></div></a>
		</div>
		<% End If %>
	<% ElseIf oPi.FItemList(i).Fgubun = "2" Then	'### 파이 %>
		<!-- #include file="./inc_pie.asp" -->
	<% End If %>
	<%'!-- best keyword 들어갈 자리 나중에.--%>
<%
		vLinkItemID = ""
	Next
End If
%>
<% 
	set oPi = nothing
	Set oPie = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
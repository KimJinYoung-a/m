<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/enjoy/shoppingchanceCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<%
	Dim scType, sCategory, sCateMid, vIsMine
	Dim cShopchance
	Dim iTotCnt, arrList,intLoop
	Dim iPageSize, iCurrpage ,iDelCnt
	Dim iStartPage, iEndPage, iTotalPage, ix,iPerCnt, k
	Dim atype, selOp
	atype = RequestCheckVar(request("atype"),1)
	if atype="" then atype="b"

	selOp		=  requestCheckVar(Request("selOP"),1) '정렬
	vIsMine		= requestCheckVar(Request("ismine"),1)
	
	If vIsMine = "o" Then
		selOp = ""
		sCategory = ""
	End If

	'파라미터값 받기 & 기본 변수 값 세팅
	scType 		= requestCheckVar(Request("scT"),4) '쇼핑찬스 분류
	sCategory 	= requestCheckVar(Request("disp"),3) '카테고리 대분류
	iCurrpage 	= requestCheckVar(Request("iC"),10)	'현재 페이지 번호

	If scType ="end" then
		selOp = "1"
	ElseIf selOp = "" Then
		selOp = "0"
	End if

	IF iCurrpage = "" THEN	iCurrpage = 1


	iPageSize = 12
	iPerCnt = 4		'보여지는 페이지 간격

	if (iCurrpage*iPageSize)>500 then
		'500개까지만 표시
		dbget.Close: Response.End
	end if

	'데이터 가져오기
	set cShopchance = new ClsShoppingChance
	cShopchance.FCPage 			= iCurrpage		'현재페이지
	cShopchance.FPSize 			= iPageSize		'페이지 사이즈
	cShopchance.FSCType 		= scType    	'이벤트구분(전체,세일,사은품,상품후기, 신규,마감임박)
	cShopchance.FSCategory 		= sCategory 	'제품 카테고리 대분류
	cShopchance.FSCateMid 		= sCateMid		'제품 카테고리 중분류
	cShopchance.FEScope 		= 2				'view범위: 10x10
	cShopchance.FselOp	 		= selOp			'이벤트정렬
	cShopchance.FUserID			= CHKIIF(vIsMine="o",GetLoginUserID(),"")
	cShopchance.Fis2014renew	= "o"			'2014리뉴얼구분
	arrList = cShopchance.fnGetAppBannerList	'배너리스트 가져오기
	iTotCnt = cShopchance.FTotCnt 				'배너리스트 총 갯수
	set cShopchance = nothing

	iTotalPage =   int((iTotCnt-1)/iPageSize) +1  '전체 페이지 수

	Dim vLink, vIcon
	
	IF isArray(arrList) THEN
		For intLoop =0 To UBound(arrList,2)
			IF arrList(6,intLoop)="I" and arrList(7,intLoop)<>"" THEN '링크타입 체크
				'vLink = "fnAPPpopupEvent_URL('" & arrList(7,intLoop) & "');"
				vLink = "location.href='" & arrList(7,intLoop) & "';"
			ELSE
				'vLink = "fnAPPpopupEvent('" & arrList(0,intLoop) & "'); return false;"
				vLink = "jsGoEvent(" & arrList(0,intLoop) & ");return false;"
			END IF
			

			If arrList(12,intLoop) AND vIcon = "" Then vIcon = " <span class=""cGr2"">GIFT</span>" End IF
			If arrList(18,intLoop) AND vIcon = "" Then vIcon = " <span class=""cBl2"">참여</span>" End IF
			If arrList(15,intLoop) AND vIcon = "" Then vIcon = " <span class=""cGr2"">1+1</span>" End IF
			
			'If arrList(11,intLoop) Then vIcon = "" End IF
			'If arrList(13,intLoop) Then vIcon = "" End IF
			'If datediff("d",arrList(2,intLoop),date)<=3 Then vIcon = "" End IF
%>
	<li onclick="<%=vLink%>">
		<div class="pic"><img src="<%=chkiif(arrList(24,intLoop)="",arrList(25,intLoop),arrList(24,intLoop))%>" alt="<%=db2html(arrList(10,intLoop))%>" /></div>
		<dl>
			<dt>
				<%=db2html(arrList(10,intLoop))%>
				<%=vIcon%>
			</dt>
			<dd><%=db2html(arrList(23,intLoop))%></dd>
		</dl>
	</li>
<%
		vLink = ""
		vIcon = ""
		Next
	End If
%>

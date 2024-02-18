﻿<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/gnbevent/shoppingchanceCls_B_chuseok2021.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/event/mktevtbannerCls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
	Dim scType, scTypegb, sCategory, sCateMid, vIsMine, ddayicon
	Dim cShopchance
	Dim iTotCnt, arrList,intLoop
	Dim iPageSize, iCurrpage ,iDelCnt
	Dim iStartPage, iEndPage, iTotalPage, ix,iPerCnt, k
	Dim atype, selOp
	Dim cMktbanner , sqlStr , arrMktevt , mPageSize , MktCnt
	Dim eName, eNameredsale, eNamegreensale

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
	scTypegb 		= requestCheckVar(Request("scTgb"),10) '마케팅이벤트/기획전 이벤트 분류 2016-05-02 유태욱
	sCategory 	= requestCheckVar(Request("disp"),3) '카테고리 대분류
	iCurrpage 	= requestCheckVar(Request("iC"),10)	'현재 페이지 번호

	If scType ="end" then
		selOp = "1"
	ElseIf selOp = "" Then
		selOp = "0"
	End if

	If scTypegb = "" then		''planevt - 기획전 , mktevt - 마케팅 이벤트
		scTypegb = "planevt"
	end if

	IF iCurrpage = "" THEN	iCurrpage = 1

	iPageSize = 15  '이벤트 배너
	iPerCnt = 4		'보여지는 페이지 간격

	mPageSize = CInt(iPageSize/5) '//마케팅 배너

	'배너 데이터 가져오기 2015-06-11 이종화 추가
	Dim i , gubun , mktimg , m_eventid , a_eventid , isurl
	reDim vHtml(10)
	set cMktbanner = new CEvtMktbanner
	cMktbanner.FPageSize	=	mPageSize '//5개당 1개 노출
	cMktbanner.FCurrPage	=	iCurrpage
	cMktbanner.Fdevice		=	"M"
	If scTypegb = "mktevt" then
		cMktbanner.Fevtgubun		=	2
	else
		cMktbanner.Fevtgubun		=	1
	end if
	cMktbanner.GetMktBannerList()
	MktCnt		= cMktbanner.FResultCount

	If MktCnt > 0 Then
		FOR i=0 to cMktbanner.FResultCount-1
			gubun				= cMktbanner.FItemList(i).Fgubun
			mktimg				= cMktbanner.FItemList(i).Fmktimg
			m_eventid			= cMktbanner.FItemList(i).Fm_eventid
			a_eventid			= cMktbanner.FItemList(i).Fa_eventid

			if m_eventid = 70670 then
				if scTypegb = "planevt" then
					isurl = "/shoppingtoday/shoppingchance_allevent.asp?scTgb=mktevt"
				elseif scTypegb = "mktevt" then
					isurl = "/shoppingtoday/shoppingchance_allevent.asp?scTgb=planevt"
				else
					isurl = "/shoppingtoday/shoppingchance_allevent.asp?scTgb=planevt"
				end if
			else
				isurl = "/event/eventmain.asp?eventid="& m_eventid
			end if

			vHtml(i) = "<li class='ad-bnr'><a href="""" onclick=""location.href='"& isurl &"';return false;"" ><div class=""thumbnail""><img src="""&mktimg&""" alt="""" /></div></a></li>"
		Next
	End If
	Set cMktbanner = Nothing

	'데이터 가져오기
	set cShopchance = new ClsShoppingChance
	cShopchance.FCPage 			= iCurrpage		'현재페이지
	cShopchance.FPSize 			= iPageSize		'페이지 사이즈
	cShopchance.FSCType 			= scType    	'이벤트구분(전체,세일,사은품,상품후기, 신규,마감임박)
	cShopchance.FSCTypegb		= scTypegb    	'이벤트구분(기획전,마케팅))
	cShopchance.FSCategory 		= sCategory 	'제품 카테고리 대분류
	cShopchance.FSCateMid 		= sCateMid		'제품 카테고리 중분류
	cShopchance.FEScope 			= 2				'view범위: 10x10
	cShopchance.FselOp	 		= selOp			'이벤트정렬
	cShopchance.FUserID			= CHKIIF(vIsMine="o",GetLoginUserID(),"")
	cShopchance.Fis2014renew	= "o"			'2014리뉴얼구분
	cShopchance.FFixEvtCode		= ChkIif(Application("Svr_Info")="Dev","88994","116585")		'상단고정 이벤트코드
	arrList = cShopchance.fnGetBannerList("Y")	'배너리스트 가져오기
	iTotCnt = cShopchance.FTotCnt 				'배너리스트 총 갯수
	set cShopchance = nothing

	iTotalPage =   int((iTotCnt-1)/iPageSize) +1  '전체 페이지 수

	Dim vLink, vIcon , vRnum
	vRnum = 0

	IF isArray(arrList) THEN
		For intLoop =0 To UBound(arrList,2)

			if arrList(4,intLoop) = "13" Then '//상품이벤트 일경우
				vLink = "TnGotoProduct('" & arrList(8,intLoop) & "');"
			Else '// 그외에
				IF arrList(6,intLoop)="I" and arrList(7,intLoop)<>"" THEN '링크타입 체크
					vLink = "location.href='" & arrList(7,intLoop) & "';"
				ELSE
					vLink = "TnGotoEventMain('" & arrList(0,intLoop) & "');"
				END IF
			End If

			ddayicon = datediff("d",arrList(3,intLoop),date)
			if ddayicon = 0 then ddayicon = "-0" end if
			dim saleCper

			If arrList(17,intLoop) Then vIcon = " <em class=""color-blue"">예약</em>" End IF
			If arrList(26,intLoop) Then vIcon = " <em class=""color-blue"">후기</em>" End IF
			If arrList(18,intLoop) Then vIcon = " <em class=""color-blue"">코멘트</em>" End IF
			If arrList(14,intLoop) Then vIcon = " <em class=""color-blue"">단독</em>" End IF
			If arrList(15,intLoop) Then vIcon = " <em class=""color-blue"">1+1</em>" End IF
			If arrList(12,intLoop) Then vIcon = " <em class=""color-blue"">기프트</em>" End IF
'			If Not(arrList(27,intLoop)="" or isNull(arrList(27,intLoop))) Then
			If arrList(13,intLoop) <> 0 Then
				saleCper = arrList(27,intLoop)
'				vIcon = " <em class=""color-green"">쿠폰"&saleCper&"</em>"
				vIcon = " <em class=""color-green"">쿠폰</em>"
'						If arrList(11,intLoop) Then vIcon = " <em class=""color-green"">쿠폰"&saleCper&"</em>" End IF
			end if
'				If ddayicon < 1 and ddayicon > -4 Then
'					vIcon = "<b class=""grey""><span><i>D"&ddayicon&"</i></span></b>"
'				End IF
			'If arrList(11,intLoop) Then vIcon = "" End IF
			'If arrList(13,intLoop) Then vIcon = "" End IF
			'If datediff("d",arrList(2,intLoop),date)<=3 Then vIcon = "" End IF

			if vIsMine <> "o" then
				'// 마케팅 배너 삽입 2015-06-11 이종화
				If scTypegb <> "bw" and intLoop > 0 Then
					If intLoop Mod 5 = 0 Then
						Response.write vHtml(vRnum)
						vRnum = vRnum + 1
					End If
				End If
			end if

			eName = ""
			eNameredsale = ""

			'//이벤트 명 할인이나 쿠폰시
			If arrList(11,intLoop) Or arrList(13,intLoop) Then
				if ubound(Split(arrList(10,intLoop),"|"))> 0 Then
					If arrList(11,intLoop) Or (arrList(11,intLoop) And arrList(13,intLoop)) then
						eName	= cStr(Split(arrList(10,intLoop),"|")(0))
						eNameredsale	= cStr(Split(arrList(10,intLoop),"|")(1))
					ElseIf arrList(13,intLoop) Then
						eName	= cStr(Split(arrList(10,intLoop),"|")(0))
						eNameredsale	= cStr(Split(arrList(10,intLoop),"|")(1))
					End If
				Else
					eName = arrList(10,intLoop)
					eNameredsale	= ""
				end If
			Else
				eName = arrList(10,intLoop)
				eNameredsale	= ""
			End If
%>
				<li class="<%=chkiif(arrList(28,intLoop)<>"","has-vod","")%>">
					<a href="" onclick="<%=vLink%> return false;">
						<div class="thumbnail"><img src="<%=chkiif(arrList(24,intLoop)="",arrList(25,intLoop),arrList(24,intLoop))%>" alt=""></div>
						<p class="desc">
							<b class="headline"><span class="ellipsis" style="width:<%=chkiif(arrList(11,intLoop) and eNameredsale <> "","80%","100%")%>;"><%=Replace(stripHTML(db2html(eName)),"[☆2015 다이어리]","")%></span> <% IF arrList(11,intLoop) and eNameredsale <> "" THEN %><b class="discount color-red"><%=eNameredsale%></b><% end if %></b>
							<span class="subcopy"><% if vIcon <> "" then %><span class="label label-color"><%=vIcon%></span><% end if %><%=stripHTML(db2html(arrList(23,intLoop)))%></span>
						</p>
					</a>
					<%	'// 5개 마다 노출
						If intLoop Mod 5 = 0 And scTypegb="planevt" Then
							Response.write fngetListItemHtml(arrList(0,intLoop))
						End If
					%>
				</li>
<%
		vLink = ""
		vIcon = ""
		Next
	End If
%>

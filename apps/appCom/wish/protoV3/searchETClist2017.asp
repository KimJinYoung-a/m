<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64New.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/apps/appCom/wish/protoV3/inc_constVar.asp"-->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls_useDB.asp" -->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/protoV3/searchETC2017.asp
' Discription : 검색 리스트 이벤트,플레잉 API
' History : 2017.09.05 강준구 : 신규 생성
'###############################################

'//헤더 출력
Response.ContentType = "application/json"

Dim sFDesc
Dim sType, sKeyword, sOS, snID, sDeviceId, sAppKey, sVerCd
Dim sCateCd, sCateNm


Dim sData : sData = Request("json")
Dim oJson
dim DocSearchText, sSize
dim SearchText : SearchText = requestCheckVar(request("rect"),100) '현재 입력된 검색어
dim SellScope 	: SellScope=requestCheckVar(request("sscp"),1)			'품절상품 제외여부
dim deliType : deliType = requestCheckVar(request("deliType"),2)
dim SearchFlag : SearchFlag = requestCheckVar(request("sflag"),2)
dim pojangok : pojangok = requestCheckVar(request("pojangok"),1)
Dim mode : mode = requestCheckVar(request("mode"),1) ''리스트형 썸네일형
dim SortMet		: SortMet = requestCheckVar(request("srm"),2)
dim dispCate : dispCate = getNumeric(requestCheckVar(request("dispCate"),18))
dim makerid : makerid = ReplaceRequestSpecialChar(request("mkr"))
dim styleCD : styleCD = CStr(ReplaceRequestSpecialChar(request("styleCd")))
dim colorCD : colorCD = CStr(requestCheckVar(request("iccd"),128))
dim minPrice : minPrice = getNumeric(requestCheckVar(Replace(request("minPrc"),",",""),8))
dim maxPrice : maxPrice = getNumeric(requestCheckVar(Replace(request("maxPrc"),",",""),8))
dim ReSearchText : ReSearchText=requestCheckVar(request("rstxt"),100) '결과내 재검색용
dim offset : offset = requestCheckVar(request("offset"),10)
dim vListOption : vListOption = requestCheckVar(request("listoption"),10)
'// 전송결과 파징
'on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	sType = oResult.type
	'sSize = getNumeric(requestCheckVar(oResult.size,8))			'페이지당 출력수

	'검색 필터 분해
	call getParseFilterV32(oResult.filter, SearchText, SellScope, deliType, SearchFlag, pojangok, mode, SortMet, dispCate, makerid, styleCD, colorCD, minPrice, maxPrice, ReSearchText, offset, vListOption)
set oResult = Nothing


    '페이징넘버
    Dim CurrPage
    If offset = 0 Then
    	CurrPage = 1
	Else
	    If vListOption = "event" Then	'### 이벤트 만
			CurrPage = (offset/16)+1
		ElseIf vListOption = "playing" Then	'### 플레잉 만
			CurrPage = (offset/16)+1
		End If
	End If
	

'// json객체 선언
Set oJson = jsObject()

	'###############################################################################################
	Dim oDoc, oList, i, oSearch, vEnm, vTotalCount, chkMode
	If vListOption = "event" Then
		set oDoc = new SearchEventCls
		oDoc.FRectSearchTxt = SearchText
		oDoc.FRectChannel = "A"		'검색 채널 (W:isWeb, M:isMobile, A:isApp)
		oDoc.FCurrPage = CurrPage
		oDoc.FPageSize = 16
		oDoc.FScrollCount =10
		oDoc.getEventList
		
		vTotalCount = oDoc.FTotalCount
	ElseIf vListOption = "playing" Then
		set oDoc = new SearchPlayingCls
		oDoc.FRectSearchTxt = SearchText
		oDoc.FCurrPage = CurrPage
		oDoc.FPageSize = 16
		oDoc.FScrollCount =10
		oDoc.getPlayingList2017
		
		vTotalCount = oDoc.FTotalCount
	End If

	If oDoc.FResultCount>0 then
		
		set oList = jsArray()
		
		For i = 0 To oDoc.FResultCount-1
		
			Set oSearch = jsObject()
			
			If vListOption = "event" Then
				vEnm = db2html(oDoc.FItemList(i).Fevt_name)
				oSearch("evtcode") = b64encode(mDomain &"/apps/appCom/wish/web2014/event/eventmain.asp?eventid="&oDoc.FItemList(i).Fevt_code&"")
				oSearch("evtname") = stripHTML(fnEventNameSplit(cStr(vEnm),"name"))

				'// 검색결과 이벤트 배너영역 수정
				If oDoc.FItemList(i).Fetc_itemimg = "" Then
					If oDoc.FItemList(i).Fevt_bannerimg = "" Then
						If oDoc.FItemList(i).Fetc_itemid <> "" Then
							oSearch("evtimg") = b64encode("http://webimage.10x10.co.kr/image/icon1/" & GetImageSubFolderByItemid(oDoc.FItemList(i).Fetc_itemid) & "/" & oDoc.FItemList(i).Ficon1image & "")
						End If
					Else
						oSearch("evtimg") = b64encode(oDoc.FItemList(i).Fevt_bannerimg)
					End If
				Else
					oSearch("evtimg") = b64encode(oDoc.FItemList(i).Fetc_itemimg)
				End If

				'If oDoc.FItemList(i).Fetc_itemimg = "" Then
				'	oSearch("evtimg") = b64encode("http://webimage.10x10.co.kr/image/icon1/" & GetImageSubFolderByItemid(oDoc.FItemList(i).Fetc_itemid) & "/" & oDoc.FItemList(i).Ficon1image)
				'Else
				'	oSearch("evtimg") = b64encode(oDoc.FItemList(i).Fetc_itemimg)
				'End If
				
				If oDoc.FItemList(i).Fevt_kind = "28" Then
					oSearch("evtgubun") = cStr("이벤트")
				Else
					oSearch("evtgubun") = cStr("기획전")
				End If
				
				'// 검색결과 이벤트 배너영역 수정
				'oSearch("evtsubcopy") = cStr(db2html(oDoc.FItemList(i).Fevt_subcopyK))
				oSearch("evtsubcopy") = cStr(db2html(oDoc.FItemList(i).Fevt_subname))
				
				if ubound(Split(vEnm,"|"))> 0 Then
					If oDoc.FItemList(i).Fissale Or (oDoc.FItemList(i).Fissale And oDoc.FItemList(i).Fiscoupon) then
						oSearch("evtdiscountgubun") = cStr("sale")
						oSearch("evtdiscount") = cStr(Split(vEnm,"|")(1))
					ElseIf oDoc.FItemList(i).Fiscoupon Then
						oSearch("evtdiscountgubun") = cStr("coupon")
						oSearch("evtdiscount") = cStr(Split(vEnm,"|")(1) & "쿠폰")
					End If
				else
					oSearch("evtdiscountgubun") = cStr("")
					oSearch("evtdiscount") = cStr("")
				end If
			ElseIf vListOption = "playing" Then

				oSearch("didx") = cStr(oDoc.FItemList(i).Fdidx)
				oSearch("linkurl") = b64encode(mDomain &"/apps/appCom/wish/web2014/playing/view.asp?didx="&oDoc.FItemList(i).Fdidx&"")
				oSearch("title") = cStr(db2html(oDoc.FItemList(i).Ftitle))
				If oDoc.FItemList(i).Fimg28 <> "" Then
					oSearch("bggubun") = cStr("i")
					oSearch("background") = b64encode(oDoc.FItemList(i).Fimg28)
				Else
					oSearch("bggubun") = cStr("c")
					If oDoc.FItemList(i).Fmo_bgcolor <> "" Then
						oSearch("background") = cStr(oDoc.FItemList(i).Fmo_bgcolor)
					Else
						oSearch("background") = cStr("ffdddb")
					End If
				End IF

			End If

			set oList(null) = oSearch
			Set oSearch = Nothing
		
		Next
		
	Else
		vTotalCount = "0"
		set oList = jsArray()
	End If
	
	chkMode = "procOK"
	
	set oDoc = nothing

	'###############################################################################################

	'// 결과데이터 생성
	Select Case chkMode
		Case "procOK"
			'// 이미 연동 되어있는 경우 성공시 (요청 type: login)
			oJson("response") = getErrMsg("1000",sFDesc)
			oJson("totalcount") = CStr(vTotalCount)
			
			If vListOption = "event" Then
				set oJson("events") = oList
			ElseIf vListOption = "playing" Then
				set oJson("playings") = oList
			End If

			Dim oFilList
			Set oFilList = jsObject()
			oFilList("keyword") = cStr(SearchText)
			oFilList("sscp") = cStr(SellScope)
			oFilList("delitp") = cStr(deliType)
			oFilList("sflag") = cStr(SearchFlag)
			oFilList("pojangok") = cStr(pojangok)
			oFilList("mode") = cStr(mode)
			oFilList("displaytype") = cStr(SortMet)
			oFilList("categoryid") = cStr(dispCate)
			oFilList("brandid") = cStr(makerid)
			oFilList("pricelimitlow") = cStr(minPrice)
			oFilList("pricelimithigh") = cStr(maxPrice)
			oFilList("rstxt") = cStr(ReSearchText)
			oFilList("stylecd") = cStr(styleCD)
			oFilList("colorcd") = cStr(colorCD)
			oFilList("offset") = cStr(offset)
			oFilList("listoption") = cStr(vListOption)
			set oJson("filter") = oFilList
			Set oFilList = Nothing

	End Select

IF (Err) then
	Set oJson = jsObject()
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."
End if

if ERR then Call OnErrNoti()		'// 오류 이메일로 발송
On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
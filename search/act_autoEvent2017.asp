<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<%
	Dim DocSearchText
	Dim CurrPage, PageSize, lp
	Dim oGrEvt ''//이벤트
	Dim searchviewType

	DocSearchText	 = requestCheckVar(request("rect"),100)
	CurrPage		= getNumeric(requestCheckVar(request("cpg"),8))
	PageSize		= requestCheckVar(request("psz"),5)

	if CurrPage="" then CurrPage="1"
    if PageSize="" then PageSize="1"  ''2016/06/16 추가

	'Amplitude용 데이터
	If InStr(LCase(request.servervariables("HTTP_REFERER")), "search/search_item") > 0 Then
		searchviewType = "search_result"
	Else
		searchviewType = "search_main"
	End If		

	'// 이벤트 검색결과
	set oGrEvt = new SearchEventCls
	oGrEvt.FRectSearchTxt = DocSearchText
	''oGrEvt.FRectExceptText = ExceptText
	oGrEvt.FRectChannel = "M"		'검색 채널 (W:isWeb, M:isMobile, A:isApp)
	oGrEvt.FCurrPage = CurrPage
	oGrEvt.FPageSize = PageSize
	oGrEvt.FRectGubun = "all"
	oGrEvt.FScrollCount =10
	oGrEvt.getEventList

	if oGrEvt.FResultCount>0 then

		Dim vLink, vIcon , vEnm
		FOR lp = 0 to oGrEvt.FResultCount-1
			
			'이벤트 링크
			IF oGrEvt.FItemList(lp).Fevt_kind="16" Then		'#브랜드할인이벤트(16)
				vLink = "top.location.href='/street/street_brand.asp?makerid=" & oGrEvt.FItemList(lp).Fbrand & "&pNtr=qe_" & server.URLEncode(DocSearchText) & "';fnAmplitudeEventMultiPropertiesAction('click_search','action|keyword|searchkeyword|view','event|"&replace(DocSearchText," ","")&"|"&replace(DocSearchText," ","")&"|"&searchviewType&"');"
				vEnm = split(oGrEvt.FItemList(lp).Fevt_name,"|")(0)
			Else
				vEnm = db2html(oGrEvt.FItemList(lp).Fevt_name)
				if ubound(Split(vEnm,"|"))> 0 Then
					If oGrEvt.FItemList(lp).Fissale Or (oGrEvt.FItemList(lp).Fissale And oGrEvt.FItemList(lp).Fiscoupon) then
						vEnm	= cStr(Split(vEnm,"|")(0)) &" <span style=color:red>"&cStr(Split(vEnm,"|")(1))&"</span>"
					ElseIf oGrEvt.FItemList(lp).Fiscoupon Then
						vEnm	= cStr(Split(vEnm,"|")(0)) &" <span style=color:green>"&cStr(Split(vEnm,"|")(1))&"</span>"
					End If 			
				end If

				IF oGrEvt.FItemList(lp).Fevt_LinkType="I" and oGrEvt.FItemList(lp).Fevt_bannerLink<>"" THEN		'#별도 링크타입
					vLink = "top.location.href='" & oGrEvt.FItemList(lp).Fevt_bannerLink & "';fnAmplitudeEventMultiPropertiesAction('click_search','action|keyword|searchkeyword|view','event|"&replace(DocSearchText," ","")&"|"&replace(DocSearchText," ","")&"|"&searchviewType&"');"
				Else
					vLink = "top.location.href='/event/eventmain.asp?eventid=" & oGrEvt.FItemList(lp).Fevt_code & "&pNtr=qe_" & server.URLEncode(DocSearchText) & "';fnAmplitudeEventMultiPropertiesAction('click_search','action|keyword|searchkeyword|view','event|"&replace(DocSearchText," ","")&"|"&replace(DocSearchText," ","")&"|"&searchviewType&"');"
				End If
			End If

			'추가 태그
			If oGrEvt.FItemList(lp).Fisgift AND vIcon = "" Then vIcon = " <span class=""cGr2"">GIFT</span>" End IF
			If oGrEvt.FItemList(lp).FisItemps=1 or oGrEvt.FItemList(lp).Fiscomment=1 AND vIcon = "" Then vIcon = " <span class=""cBl2"">참여</span>" End IF
			If oGrEvt.FItemList(lp).Fisoneplusone AND vIcon = "" Then vIcon = " <span class=""cGr2"">1+1</span>" End IF
			
		Response.Write "<li class=""event"" onClick="""&vLink&" return false;""><a href="""" onClick=""return false;""><span class=""sum"">이벤트</span> <div class=""desc"">"&vEnm&"</div></a></li>"

		Next
	End If

	Set oGrEvt = nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
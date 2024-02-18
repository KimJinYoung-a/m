<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls_useDB.asp" -->
<%
dim oGrCat
dim SearchText : SearchText = requestCheckVar(request("rect"),100) '현재 입력된 검색어
dim dispCate : dispCate = getNumeric(requestCheckVar(request("dispCate"),18))
dim clickdisp : clickdisp = getNumeric(requestCheckVar(request("clickdisp"),18))
dim SortMet		: SortMet = "be"
dim SearchItemDiv : SearchItemDiv="y"	'기본 카테고리만
dim SearchCateDep : SearchCateDep= "T"	'하위카테고리 모두 검색
dim ListDiv : ListDiv = "search" '카테고리/검색 구분용
dim depth
If clickdisp <> "" Then
	depth = (Len(clickdisp)/3)+1
Else
	depth = 1
End If

'SearchText = "가방"

	Dim y, y1, y2, y3, vArrD1, vArrD2, vArrD3, vCa1, vTmp1, vCa2, vTmp2, vCa3, vTmp3, vDispTitle, vBody
	'// 카테고리별 검색결과
	set oGrCat = new SearchItemCls
	oGrCat.FRectSearchTxt = SearchText
	oGrCat.FRectSortMethod = SortMet
	oGrCat.FRectSearchFlag = "n"
	oGrCat.FRectSearchItemDiv = SearchItemDiv
	oGrCat.FRectSearchCateDep = SearchCateDep
	oGrCat.FCurrPage = 1
	oGrCat.FPageSize = 200
	oGrCat.FScrollCount =10
	oGrCat.FListDiv = ListDiv
	oGrCat.FSellScope="Y"
	If clickdisp <> "" Then
	oGrCat.FRectCateCode = clickdisp
	End If
	oGrCat.FGroupScope = depth	'depth
	oGrCat.FLogsAccept = False '그룹형은 절대 !!! False 
	oGrCat.FRectDispExclude = "" '" and idx_catecode != '123' "
	oGrCat.getGroupbyCategoryList
	
	'response.write oGrCat.FItemList(y).FCateCode & ", " & oGrCat.FItemList(y).FCateCd1 & ", 
	'" & oGrCat.FItemList(y).FCateCd2 & ", " & oGrCat.FItemList(y).FCateCd3 & ", " & oGrCat.FItemList(y).FCateName1 & ",
	'" & oGrCat.FItemList(y).FCateName2 & ", " & oGrCat.FItemList(y).FCateName3 & ", " & oGrCat.FItemList(y).FCateDepth & "<br>"
	
	vBody = ""
	
	If oGrCat.FResultCount > 0 Then

		If depth = "1" Then
			vBody = vBody & "<ul class=""depth1"">" & vbCrLf
		End IF

		For y = 0 To oGrCat.FResultCount-1
		
			If depth = "1" Then
				
				vBody = vBody & "<li class=""category" & oGrCat.FItemList(y).FCateCd1 & """><a href="""""
				vBody = vBody & " onClick=""jsDispSearch('" & oGrCat.FItemList(y).FCateCd1 & "','" & oGrCat.FItemList(y).FCateName1 & "'); return false;"">"
				vBody = vBody & "<span>" & oGrCat.FItemList(y).FCateName1 & "</span></a>" & vbCrLf
				vBody = vBody & "	<ul class=""depth2"" id=""disp" & oGrCat.FItemList(y).FCateCd1 & """ style=""display:none;"">" & vbCrLf
				vBody = vBody & "	</ul>" & vbCrLf
				vBody = vBody & "</li>" & vbCrLf
				
			ElseIf depth = "2" Then
				
				vBody = vBody & "<li class=""category" & oGrCat.FItemList(y).FCateCd1 & oGrCat.FItemList(y).FCateCd2 & """><a href="""""
				vBody = vBody & " onClick=""jsDispSearch('" & oGrCat.FItemList(y).FCateCd1 & oGrCat.FItemList(y).FCateCd2 & "','" & oGrCat.FItemList(y).FCateName2 & "'); return false;"">"
				vBody = vBody & "<span>" & oGrCat.FItemList(y).FCateName2 & "</span></a>" & vbCrLf
				vBody = vBody & "	<ul class=""depth3"" id=""disp" & oGrCat.FItemList(y).FCateCd1 & oGrCat.FItemList(y).FCateCd2 & """ style=""display:none;"">" & vbCrLf
				vBody = vBody & "	</ul>" & vbCrLf
				vBody = vBody & "</li>" & vbCrLf
				
			ElseIf depth = "3" Then
				
				vBody = vBody & "<li class=""category" & oGrCat.FItemList(y).FCateCd1 & oGrCat.FItemList(y).FCateCd2 & oGrCat.FItemList(y).FCateCd3 & """><a href="""""
				vBody = vBody & " onClick=""jsDispSearch('" & oGrCat.FItemList(y).FCateCd1 & oGrCat.FItemList(y).FCateCd2 & oGrCat.FItemList(y).FCateCd3 & "','" & oGrCat.FItemList(y).FCateName3 & "'); return false;"">"
				vBody = vBody & "<span>" & oGrCat.FItemList(y).FCateName3 & "</span></a>"
				vBody = vBody & "</li>" & vbCrLf
				
			End If
			
		Next

		If depth = "1" Then
			vBody = vBody & "</ul>" & vbCrLf
		End IF

	End If
	set oGrCat = Nothing
	
	Response.Write vBody
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
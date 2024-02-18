<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<%
'// 실시간 인기검색어
DIM oPpkDoc, arrList, arrTg, iRows
SET oPpkDoc = NEW SearchItemCls
oPpkDoc.FPageSize = 10
arrList = oPpkDoc.getPopularKeyWords()					'인기검색어 일반형태
'oPpkDoc.getPopularKeyWords2 arrList,arrTg				'인기검색어 순위정보 포함
SET oPpkDoc = NOTHING

IF isArray(arrList)  THEN
	if Ubound(arrList)>0 then
		FOR iRows =0 To UBOUND(arrList)
			Response.Write "<a href=""/search/search_item.asp?rect=" & Server.URLEncode(arrList(iRows)) & "&exkw=1"">" & arrList(iRows) & "</a>" & vbCrLf
		Next
	END IF
END IF
%>

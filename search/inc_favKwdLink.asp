<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<%
'// �ǽð� �α�˻���
DIM oPpkDoc, arrList, arrTg, iRows
SET oPpkDoc = NEW SearchItemCls
oPpkDoc.FPageSize = 10
arrList = oPpkDoc.getPopularKeyWords()					'�α�˻��� �Ϲ�����
'oPpkDoc.getPopularKeyWords2 arrList,arrTg				'�α�˻��� �������� ����
SET oPpkDoc = NOTHING

IF isArray(arrList)  THEN
	if Ubound(arrList)>0 then
		FOR iRows =0 To UBOUND(arrList)
			Response.Write "<a href=""/search/search_item.asp?rect=" & Server.URLEncode(arrList(iRows)) & "&exkw=1"">" & arrList(iRows) & "</a>" & vbCrLf
		Next
	END IF
END IF
%>

<%
	Dim vCheckAutoQuery
	vCheckAutoQuery = "SELECT COUNT(refip) FROM "
	vCheckAutoQuery = vCheckAutoQuery & "("
	vCheckAutoQuery = vCheckAutoQuery & "	SELECT Top 20 refip From [db_order].[dbo].[tbl_mobile_gift] WHERE regdate>DATEADD(hour,-1,getdate()) ORDER BY idx DESC "
	vCheckAutoQuery = vCheckAutoQuery & ") AS M "
	vCheckAutoQuery = vCheckAutoQuery & "WHERE refip = '" & Request.ServerVariables("REMOTE_ADDR") & "' "
	rsget.Open vCheckAutoQuery,dbget
	If rsget(0) > 14 Then
		rsget.close
		dbget.close()
		Response.Write "<script language='javascript'>alert('한번에 15회 이상 조회를 하셨습니다.\n잠시 후에 이용하시기 바랍니다.');document.location.href = '/';</script>"
		Response.End
	Else
		rsget.close
	End IF
%>
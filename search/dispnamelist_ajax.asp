<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls_useDB.asp" -->
<%
	Dim cDisp, vDispArr, i, vDisp, vDepth
	vDisp = NullFillWith(requestCheckVar(request("disp"),15),0)
	If (Len(vDisp) mod 3) <> 0 Then		'### 코드값이 3자리씩이 아닐때(잘못입력된경우).
		dbget.close
		Response.End
	End IF
	vDepth = (Len(vDisp)/3)
	
	SET cDisp = New CDBSearch
	cDisp.FRectDisp = vDisp
	vDispArr = cDisp.fnDispNameList
	SET cDisp = Nothing

	If isArray(vDispArr) Then
		For i = 0 To UBound(vDispArr,2)
		
		If i = 0 Then
			Response.Write "<li><a href=""/category/category_list.asp?disp="&vDisp&"""><span>전체보기</span></a></li>"
		End IF
%>
		<% If vDispArr(2,i) > 0 Then %>
		<li><a href="" onclick="jsDispNextDepth('<%=vDispArr(0,i)%>'); return false;"><span><%=vDispArr(1,i)%></span></a>
		<% Else %>
		<li><a href="/category/category_list.asp?disp=<%=vDispArr(0,i)%>"><span><%=vDispArr(1,i)%></span></a>
		<% End If %>
			<ul class="depth<%=vDepth+2%>" id="disp<%=vDispArr(0,i)%>" style="display:none;">
			</ul>
		</li>
<%
		Next
	End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
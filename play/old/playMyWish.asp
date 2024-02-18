<%@ language=vbscript %>
<% option explicit %>
<%
'###########################################################
' Description :  play
' History : 2013.09.11 이종화 생성
'			2014.10.23 한용민 www이전/생성
'###########################################################
%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
Dim playcode , codeidx , subcodeidx , userid , wishcnt 
dim sqlStr , mode , device

	playcode	= getNumeric(RequestCheckVar(request("playcode"),10))
	codeidx	 	= getNumeric(RequestCheckVar(request("codeidx"),10))
	subcodeidx	 	= getNumeric(RequestCheckVar(request("subcodeidx"),10))
	userid		= GetLoginUserID

If playcode <> "" And  codeidx <> "" And userid <> "" Then
	If subcodeidx = "" then
		sqlStr = "SELECT userid FROM db_my10x10.dbo.tbl_myfavorite_play WHERE playcode = "& playcode &" and codeidx = "& codeidx &" and userid = '"& userid &"'" 
	else
		sqlStr = "SELECT userid FROM db_my10x10.dbo.tbl_myfavorite_play WHERE playcode = "& playcode &" and codeidx = "& codeidx &" and userid = '"& userid &"' and subcodeidx = "& subcodeidx &"" 
	End If 
	rsget.Open sqlStr,dbget,1
	if  not rsget.EOF  then
		mode = "delete"
	Else 
		mode = "insert"
	end if
	rsget.Close

	If mode = "insert" Then

		sqlStr = " insert into db_my10x10.dbo.tbl_myfavorite_play (playcode , codeidx , userid , device , subcodeidx)" + VbCrlf
		sqlStr = sqlStr + " values(" + VbCrlf
		sqlStr = sqlStr + " " + playcode + "" + VbCrlf
		sqlStr = sqlStr + " ," + codeidx + "" + VbCrlf
		sqlStr = sqlStr + "	,'" + userid + "'" + VbCrlf
		If playcode = "4" Then 
		sqlStr = sqlStr + "	,'W'" + VbCrlf
		Else
		sqlStr = sqlStr + "	,'" + device + "'" + VbCrlf
		End If 
		sqlStr = sqlStr + "	,'" + subcodeidx + "'" + VbCrlf
		sqlStr = sqlStr + " )"	+ VbCrlf
		dbget.Execute sqlStr
	
	Else
		If subcodeidx = "" then
			sqlStr =" delete from db_my10x10.dbo.tbl_myfavorite_play WHERE playcode = "& playcode &" and codeidx = "& codeidx &" and userid = '"& userid &"'"
		Else 
			sqlStr =" delete from db_my10x10.dbo.tbl_myfavorite_play WHERE playcode = "& playcode &" and codeidx = "& codeidx &" and userid = '"& userid &"' and subcodeidx = "& subcodeidx &""
		End If 
		dbget.Execute sqlStr

	End If 

	sqlStr = "select count(*) as cnt" + VbCrlf
	sqlStr = sqlStr & " from db_my10x10.dbo.tbl_myfavorite_play " + VbCrlf
	sqlStr = sqlStr & " where playcode = "& playcode &"" + VbCrlf
	If subcodeidx <> "" then
	sqlStr = sqlStr & " and subcodeidx = "& subcodeidx &""+ VbCrlf
	End if
	sqlStr = sqlStr & " and codeidx = "& codeidx
	'response.write sqlStr

	rsget.Open sqlStr,dbget,1
		wishcnt = rsget("cnt")
	rsget.Close

End If 

'ajax html

If mode = "insert" Then
%><div id='result' rel='Y' rel2='<%=wishcnt%>'></div><%
Else
%><div id='result' rel='N' rel2='<%=wishcnt%>'></div><%
End If 
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
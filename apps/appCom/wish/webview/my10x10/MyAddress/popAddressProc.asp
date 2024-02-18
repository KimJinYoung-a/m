<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/apps/appcom/wish/webview/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/header.asp" -->
<!-- #include virtual="/lib/classes/orderCls/clsMyAddress.asp" -->

<%
Dim openerYN	: openerYN	= req("openerYN","")

Dim conListURL

Dim i

Dim page		: page			= req("page",1)
Dim countryCode	: countryCode	= req("countryCode","")


Dim mode		: mode		= req("mode","INS")
Dim PKID

Dim obj	: Set obj = new clsMyAddress

obj.GetData ""

obj.Item.idx					= req("idx","")
obj.Item.countryCode			= countryCode
obj.Item.reqPlace				= req("reqPlace","")
obj.Item.reqName				= req("reqName","")
obj.Item.reqZipaddr				= req("reqZipaddr","")
obj.Item.reqAddress				= req("reqAddress","")


If countryCode = "KR" Then		' 국내주소록

	conListURL = "popMyAddressList.asp?openerYN=" & openerYN & "&page=" & page

	obj.Item.reqZipcode				= req("zip1","") & "-" & req("zip2","")
	obj.Item.reqPhone				= req("tel1","") & "-" & req("tel2","") & "-" & req("tel3","")
	obj.Item.reqHp					= req("hp1","") & "-" & req("hp2","") & "-" & req("hp3","")

Else							' 해외주소록
	conListURL = "popSeaAddressList.asp?openerYN=" & openerYN & "&page=" & page

	obj.Item.reqZipcode				= req("reqZipcode","")
	obj.Item.reqPhone				= req("tel1","") & "-" & req("tel2","") & "-" & req("tel3","") & "-" & req("tel4","")
	obj.Item.reqEmail				= req("reqEmail","")

End If 



If mode = "COPY" Then		' 복사
	obj.CopyData req("orderSerial","")
ElseIf mode = "DEL" Then	' 삭제
	PKID = Split(req("idx",""),",")
	For i = 0 To UBound(PKID)
		obj.Item.idx		= PKID(i)
		obj.ProcData mode
	Next 
Else		' 등록,수정
	obj.ProcData mode
End If 

Set obj = Nothing 

If openerYN = "" Then 
	response.redirect conListURL
Else
	Dim alertMode
	If mode = "DEL" Then 
		If countryCode = "KR" Then		' 국내주소록
			conListURL = "MyAddressList.asp?page=" & page
		Else 
			conListURL = "SeaAddressList.asp?page=" & page
		End If
		response.redirect conListURL
	ElseIf mode = "INS" Then 
		alertMode = "등록"
	ElseIf mode = "UPD" Then 
		alertMode = "수정"
	End If 
	response.write "<script>" & vbCrLf
	response.write "alert('" & alertMode & "되었습니다.');" & vbCrLf
	
	If countryCode = "KR" Then
		response.write "location.href='MyAddressList.asp';" & vbCrLf
		'response.write "opener.location.reload();" & vbCrLf
	Else
		response.write "location.href='SeaAddressList.asp';" & vbCrLf
		'response.write "opener.location.reload();" & vbCrLf
	End IF
	'response.write "window.close();" & vbCrLf
	response.write "</script>" & vbCrLf
	dbget.close()	:	response.End 
End If 
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->

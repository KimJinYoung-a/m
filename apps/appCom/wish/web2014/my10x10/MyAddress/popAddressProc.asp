<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet="UTF-8"
%>
<!-- #include virtual="/apps/appCom/wish/web2014/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
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

Dim vIdx , vCountryCode , vReqPlace , vReqName , vReqZipaddr , vReqAddress
Dim vReqZipCode , vReqPhone , vReqEmail

vIdx			= req("idx","")
vCountryCode	= countryCode
vReqPlace		= req("reqPlace","")
vReqName		= req("reqName","")
vReqZipaddr		= req("reqZipaddr","")
vReqAddress		= req("reqAddress"," ")

'// 크로스 사이트 스크립팅 방지
If checkNotValidHTML(vReqAddress) Then
	response.write "<script>alert('HTML태그 및 스크립트는 입력하실 수 없습니다.');history.back();</script>"
	response.End
End If

If checkNotValidHTML(vReqPlace) Then
	response.write "<script>alert('HTML태그 및 스크립트는 입력하실 수 없습니다.');history.back();</script>"
	response.End
End If

If checkNotValidHTML(vReqName) Then
	response.write "<script>alert('HTML태그 및 스크립트는 입력하실 수 없습니다.');history.back();</script>"
	response.End
End If

obj.Item.idx					= vIdx
obj.Item.countryCode			= stripHTML(vCountryCode)
obj.Item.reqPlace				= stripHTML(vReqPlace)
obj.Item.reqName				= stripHTML(vReqName)
obj.Item.reqZipaddr				= stripHTML(vReqZipaddr)
obj.Item.reqAddress				= stripHTML(vReqAddress)


If countryCode = "KR" Then		' 국내주소록

	conListURL = "popMyAddressList.asp?openerYN=" & openerYN & "&page=" & page

	vReqZipCode = req("zip","")
	vReqPhone	= req("tel1","") & "-" & req("tel2","") & "-" & req("tel3","")
	vReqEmail	= req("hp1","") & "-" & req("hp2","") & "-" & req("hp3","")

	obj.Item.reqZipcode		= stripHTML(vReqZipCode)
	obj.Item.reqPhone		= stripHTML(vReqPhone)
	obj.Item.reqHp			= stripHTML(vReqEmail)

Else							' 해외주소록
	conListURL = "popSeaAddressList.asp?openerYN=" & openerYN & "&page=" & page

	vReqZipCode = req("reqZipcode","")
	vReqPhone	= req("tel1","") & "-" & req("tel2","") & "-" & req("tel3","") & "-" & req("tel4","")
	vReqEmail	= req("reqEmail","")

	obj.Item.reqZipcode		= stripHTML(vReqZipCode)
	obj.Item.reqPhone		= stripHTML(vReqPhone)
	obj.Item.reqEmail		= stripHTML(vReqEmail)
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

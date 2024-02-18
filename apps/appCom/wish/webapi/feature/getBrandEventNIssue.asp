<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<!-- #include virtual="/lib/classes/event/eventCls_B.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/webapi/feature/getBrandEventNIssue.asp
' Discription : 브랜드 이벤트 & 이슈 
' Request : json > makerid
' Response : response > 결과 : list
' History : 2018-08-29 이종화 ' 72DB
'###############################################
'//헤더 출력
response.charset = "utf-8"
Response.ContentType = "application/json"

Dim sFDesc
Dim vMakerid , vType
Dim sData : sData = Request("json")
dim basicimage , sqlStr

'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	vMakerid = requestCheckVar(oResult.makerid,32)
	vType	= oResult.type
set oResult = Nothing

'// json객체 선언
Dim oJson
Dim contents_json , contents_object

'// 브랜드 이벤트 top 3개
Dim vArrIssue, vLink, cEvent, vEventcnt , i , vSale ,vName 
    vEventcnt=0

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."

ElseIf vMakerid = "" Then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "브랜드 ID 가 없습니다."

Else
	set cEvent = new ClsEvtCont
		cEvent.FECode = 0
		cEvent.FEKind = "19,26"	'모바일전용,모바일+APP공용
		cEvent.FDevice = "M" 'device
		cEvent.FBrand = vMakerid
		cEvent.FEDispCate = ""
		vArrIssue = cEvent.fnEventISSUEList
	set cEvent = nothing

    if isArray(vArrIssue) THEN
        ReDim contents_object(ubound(vArrIssue,2))
		For i = 0 to ubound(vArrIssue,2)
            vEventcnt = vEventcnt + 1
            vSale = ""
            vName = ""
            If vArrIssue(4,i) Or vArrIssue(5,i) Then '//issale ,  iscoupon
                if ubound(Split(vArrIssue(1,i),"|"))> 0 Then
                    If vArrIssue(4,i) Or (vArrIssue(4,i) And vArrIssue(5,i)) then
                        vName	= cStr(Split(vArrIssue(1,i),"|")(0))
                        vSale	= cStr(Split(vArrIssue(1,i),"|")(1))
                    ElseIf vArrIssue(5,i) Then
                        vName	= cStr(Split(vArrIssue(1,i),"|")(0))
                        vSale	= cStr(Split(vArrIssue(1,i),"|")(1))
                    End If
                Else
                    vName = vArrIssue(1,i)
                end If
            Else
                vName = vArrIssue(1,i)
            End If

            Set contents_json = jsObject()
				if vArrIssue(2,i)="I" and vArrIssue(3,i)<>"" then 
					contents_json("link_url")	= b64encode("http://m.10x10.co.kr/apps/appcom/wish/web2014/category/category_itemprd.asp?itemid="&vArrIssue(3,i))
				else
					contents_json("link_url")	= b64encode("http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&vArrIssue(0,i))
				end if 
   				contents_json("eventname")	= vName
			    contents_json("saleper")	= vSale
			Set contents_object(i) = contents_json
		Next 
    End If
end If

Set oJson = jsObject()
	oJson("response")	= "ok"
    oJson("eventcount")	= vEventcnt
    If i > 0 Then 
		oJson("contents")	= contents_object
	Else
		Set oJson("contents")	= jsArray()
	End If
	'Json 출력(JSON)
	oJson.flush
Set oJson = Nothing

if ERR then Call OnErrNoti()
On Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
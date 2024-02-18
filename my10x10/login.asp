<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
session.codePage = 65001
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.AddHeader "Access-Control-Allow-Origin","*"
Response.AddHeader "Access-Control-Allow-Methods","POST"
Response.AddHeader "Access-Control-Allow-Headers","X-Requested-With"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/lib/classes/cscenter/cs_aslistcls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_couponcls.asp" -->
<!-- #include virtual="/cscenter/lib/csAsfunction.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/lib/util/base64unicode.asp"-->
<%

'// 암호화 링크 생성 샘플
'// /webadmin/cscenter/action/pop_cs_RequestRefundAccountLMS.asp

dim mycslist
dim orderserial, key, validdate, asid, mode
	key = requestCheckVar(trim(request("k")), 1024)

if (key = "") then
	response.write "<script type='text/javascript'>"
	response.write "	alert('링크를 지원하지 않는 메시지입니다.[-1]\n링크를 복사하셔서 브라우저에 붙여넣기 해주세요.');"
	response.write "</script>"
    response.write "링크를 지원하지 않는 메시지입니다.[-1]<br />링크를 복사하셔서 브라우저에 붙여넣기 해주세요."
	dbget.close()	:	response.End
end if


''response.write key
''response.end

key = TBTDecryptUrl(key)

'' mode
'' 01 : 무통장 환불계좌 입력요청
''      01,asid,orderserial,validdate


key = Split(key, ",")

mode = key(0)
if (mode = "01") then
    '// 무통장 환불계좌 입력요청
    asid = key(1)
    orderserial = key(2)
    validdate = key(3)

    if asid="" or not IsNumeric(asid) then
	    response.write "<script type='text/javascript'>"
	    response.write "	alert('잘못된 접근입니다.[0]');"
	    response.write "</script>"
	    dbget.close()	:	response.End
    end if
    if orderserial="" then
	    response.write "<script type='text/javascript'>"
	    response.write "	alert('잘못된 접근입니다.[1]');"
	    response.write "</script>"
	    dbget.close()	:	response.End
    end if
else
    dbget.close : response.end
end if

if (validdate < Left(Now(), 10)) then
	response.write "<script type='text/javascript'>"
	response.write "	alert('유효기간이 경과되었습니다.');"
	response.write "</script>"
	dbget.close()	:	response.End
end if

if (mode = "01") then
    '// 무통장 환불계좌 입력요청


    set mycslist = new CCSASList
    mycslist.FRectCsAsID = asid
    mycslist.FRectOrderserial = orderserial
    mycslist.GetOneCSASMaster

    If mycslist.FResultCount = 0 Then
	    response.write "<script type='text/javascript'>"
	    response.write "	alert('잘못된 접근입니다.[2]');"
	    response.write "</script>"
	    dbget.close()	:	response.End
    end if

    if (mycslist.FOneItem.Fuserid <> "") then
        session("ssnuserid") = mycslist.FOneItem.Fuserid
    else
        session("userorderserial") = mycslist.FOneItem.Forderserial
    end if

    Response.Redirect "/my10x10/order/order_csdetail.asp?CsAsID=" & asid
end if

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->

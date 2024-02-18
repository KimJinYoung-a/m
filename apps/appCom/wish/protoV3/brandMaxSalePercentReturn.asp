<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64New.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/inc_const.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : native 영역
' Discription : APP 브랜드 페이지 진입시 해당 브랜드 최대 할인율값 리턴
' Request : json > makerid, os, versioncode
' Response : response > 결과, makerid, maxsalepercent
' History : 2020.10.07 원승현 : 신규 생성
'###############################################

'//헤더 출력
Response.ContentType = "text/html"

Dim sFDesc
Dim sType, sOS, sMakerID
Dim sMaxSalePercent, sSocName, sSocNameKor, sFrontCategory, sMakerImageUrl, sOrderBy, chkMaxSalePercent
Dim sData : sData = Request("json")
Dim oJson
Dim sAppKey, sVerCd
Dim sqlStr
dim oResult

'// 전송결과 파징
on Error Resume Next


set oResult = JSON.parse(sData)
	sOS = requestCheckVar(oResult.os,8)
    sMakerID = requestCheckVar(oResult.makerid,32)

	sAppKey = getWishAppKey(sOS)
	sVerCd = requestCheckVar(oResult.versioncode,20)
set oResult = Nothing


'// json객체 선언
Set oJson = jsObject()

If sMakerID="" then
	'// makerid가 없을경우
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "브랜드 아이디가 없습니다."

'elseif Not(sOS="ios" or sOS="android") then
	'// OS 파라메터 없음
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "파라메터 정보가 잘못됐습니다."

else

	'// 해당 브랜드 아이디가 할인 대상인지 확인한다.
	sqlStr = " SELECT idx, makerid, socname, socname_kor, frontcategory, makerimageurl, maxsalepercent, orderby "
    sqlStr = sqlStr & " FROM db_temp.dbo.tbl_brandMaxSalePercent WITH(NOLOCK) Where makerid='"&sMakerID&"'"
	rsget.Open sqlStr,dbget, adOpenForwardOnly, adLockReadOnly
	if Not(rsget.EOF or rsget.BOF) then
        sMaxSalePercent = rsget("maxsalepercent")
        sSocName = rsget("socname")
        sSocNameKor = rsget("socname_kor")
        sFrontCategory = rsget("frontcategory")
        sMakerImageUrl = rsget("makerimageurl")
        sOrderBy = rsget("orderby")
        chkMaxSalePercent = true
    Else
        chkMaxSalePercent = false
	End if
	rsget.close


	'// 결과데이터 생성
	if Not(chkMaxSalePercent) then
		oJson("response") = "none"
	else
		oJson("response") = getErrMsg("1000",sFDesc)
		oJson("maxsalepercent") = cStr(FormatNumber(sMaxSalePercent,0))
        oJson("linkurl") = b64encode("http://m.10x10.co.kr/apps/appCom/wish/web2014/event/19th/index.asp")
	end if
end if

IF (Err) then
	Set oJson = jsObject()
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."
End if

''if ERR then Call OnErrNoti()		'// 오류 이메일로 발송

On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbAppNotiopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64New.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/apps/appCom/wish/protoV2/inc_constVar.asp"-->
<!-- #include virtual="/apps/appCom/wish/protoV2/wishCls.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<!-- #include virtual="/apps/appCom/wish/protoV2/protoV2Function.asp"-->
<!-- #include virtual="/lib/classes/cscenter/eventprizeCls.asp" -->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/Proc.asp
' Discription : Wish APP 목록 출력
' Request : json > type, kind, offset, size, filter, OS, versioncode, versionname, verserion
' Response : response > 결과, requestoffset, requestsize, numofproduct, product(array)
' History : 2014.01.15 허진원 : 신규 생성
'###############################################

'//헤더 출력
Response.ContentType = "text/html"

''IOS는 당분간 사용 안함. (personalnoti)

Dim sType, sKind, sOffset, sSize, sFDesc, i, sOS, sVerCd, sAppKey, sDeviceId, slastconfirmtime
Dim sData : sData = Request("json")
Dim oJson, userid

'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	sType = oResult.type
    
    sOS = requestCheckVar(oResult.OS,10)
    sVerCd = requestCheckVar(oResult.versioncode,20)
    sAppKey = getWishAppKey(sOS)
    
    ''2015/01/08 추가
    if ((sAppKey="6") and (sVerCd>"48")) or ((sAppKey="5") and (sVerCd>"1.8")) then  ''안드로이드 49버전부터 , ios 1.9 부터 uuid 추가 //2016/06/25
	    if Not ERR THEN
	        sDeviceId = requestCheckVar(oResult.pushid,256)
	        slastconfirmtime = requestCheckVar(oResult.lastconfirmtime,20)
	        if ERR THEN Err.Clear ''sDeviceId 프로토콜 없음
	    END IF
	end if
set oResult = Nothing

'// json객체 선언
Set oJson = jsObject()

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."

elseif sType="lnbpersonal" then
	'// 로그인 사용자
	userid = GetLoginUserID

	'// 결과 출력
	oJson("response") = getErrMsg("1000",sFDesc)
	oJson("recentordercnt")     = getRecentOrderCount(userid) ''최근 주문 수량.
    Set oJson("personalnoti")   = getPersonalNotiList(userid)
    if (sDeviceId<>"") then
        if (replace(FormatDateTime(now(),4),":","")>"0345") and (replace(FormatDateTime(now(),4),":","")<"0355") then
            ''야간 배치 로그로 이관시 타임아웃 회피 하기 위함.
            oJson("newnotiexists") = 0
        else
            oJson("newnotiexists") = getNotReadPushNotiExists(sDeviceId,slastconfirmtime)
        end if
    else
        oJson("newnotiexists") = 0
    end if
elseif sType="notilist" then
    '// 결과 출력
	oJson("response") = getErrMsg("1000",sFDesc)
	Set oJson("notilist")   = getPushNotiList(sDeviceId,slastconfirmtime)
else
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "잘못된 접근입니다."
end if

if ERR then Call OnErrNoti()
On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
<!-- #include virtual="/lib/db/dbAppNoticlose.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->
<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64New.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/deviceProc.asp
' Discription : Wish APP Pushid 등록 삭제
' Request : json > type, pushid, OS, versioncode, versionname, verserion :: type-reg,rmv
' Response : response > 결과, response, faildesc
' History : 2014.03.21 서동석 : 신규 생성
'###############################################

'//헤더 출력
Response.ContentType = "text/html"

Dim sFDesc
Dim sType, sDeviceId
Dim sOS, sVerCd, sVerNm, sJsonVer, sAppKey, sMinUpVer, sCurrVer, sCurrVerNm, sUUID, snID
Dim sData : sData = Request("json")
Dim oJson


'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	sType = oResult.type
	sDeviceId = requestCheckVar(oResult.pushid,256)

	sOS = requestCheckVar(oResult.OS,10)
	sVerCd = requestCheckVar(oResult.versioncode,20)
	sVerNm = requestCheckVar(oResult.versionname,32)
	sJsonVer = requestCheckVar(oResult.version,10)

	sAppKey = getWishAppKey(sOS)
	
	''if (sAppKey="6") and (sVerCd>"38") then  ''안드로이드 39버전부터 uuid 추가 //2016/06/25
	''if ((sAppKey="6") and (sVerCd>"38")) or ((sAppKey="5") and (sVerCd>"1.3")) then  ''안드로이드 39버전부터 , ios 1.4 부터 uuid 추가 //2016/06/25  //주석 V2
	    if Not ERR THEN
	        sUUID = requestCheckVar(oResult.uuid,40)
	        if ERR THEN Err.Clear ''uuid 프로토콜 없음
	    END IF
	''end if
	
	''2015/07/23
    ''if ((sAppKey="6") and (sVerCd>="66")) or ((sAppKey="5") and (sVerCd>="1.96")) then  ''안드로이드 66버전부터 , ios 1.96 부터 nid 추가 //2015/07/23  //주석 V2
	    if Not ERR THEN
    	    snID = requestCheckVar(oResult.nid,40)
    	    if ERR THEN Err.Clear ''uuid 프로토콜 없음
	    END IF
	''end if
	
set oResult = Nothing

'// json객체 선언
Set oJson = jsObject()

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."

elseif (sType<>"reg") and (sType<>"rmv") then
	'// 잘못된 콜싸인 아님
oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "잘못된 접근입니다."
elseif (sDeviceId="") then
	'// 잘못된 sDeviceId
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "잘못된 접근입니다."
elseif sAppKey="" then
	'// 잘못된 접근
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "파라메터 정보가 없습니다."

else
	dim sqlStr

	if sDeviceId<>"" then
		'// 접속 기기 정보 저장
		if (sType="reg") then  ''구글서버에서 어씽크로 받아옴
    		sqlStr = "IF NOT EXISTS(select regidx from db_contents.dbo.tbl_app_regInfo where appkey=" & sAppKey & " and deviceid='" & sDeviceId & "') " & vbCrLf
    		sqlStr = sqlStr & "begin " & vbCrLf
    		sqlStr = sqlStr & "	insert into db_contents.dbo.tbl_app_regInfo " & vbCrLf
    		sqlStr = sqlStr & "		(appKey,deviceid,regdate,appVer,lastact,isAlarm01,isAlarm02,isAlarm03,isAlarm04,isAlarm05,regrefip) values " & vbCrLf
    		sqlStr = sqlStr & "	(" & sAppKey			'앱고유Key
    		sqlStr = sqlStr & ",'" & sDeviceId & "'"	'접속기기 DeviceID
    		sqlStr = sqlStr & ",getdate()"				'최초접속 일시
    		sqlStr = sqlStr & ",'"&sVerCd&"'"			'버전                       ''/2014/03/21
    		sqlStr = sqlStr & ",'reg'"                  '' 최종액션구분
    		sqlStr = sqlStr & ",'Y'"					'위시메이트 알림 여부
    		sqlStr = sqlStr & ",'Y'"					'구매정보 알림 여부
    		sqlStr = sqlStr & ",'Y'"					'이벤트 및 혜택 알림 여부
    		sqlStr = sqlStr & ",'N','N','"&Request.ServerVariables("REMOTE_ADDR")&"') " & vbCrLf
    		sqlStr = sqlStr & " end"& vbCrLf

    		sqlStr = sqlStr & " ELSE"& vbCrLf
    		sqlStr = sqlStr & " begin " & vbCrLf
    		sqlStr = sqlStr & " update db_contents.dbo.tbl_app_regInfo" & vbCrLf
    	    sqlStr = sqlStr & "	set lastact='rrg'" & vbCrLf                         ''기기삭제후 재등록 등
    	    sqlStr = sqlStr & "	,appVer='"&sVerCd&"'" & vbCrLf
    	    sqlStr = sqlStr & "	,isusing='Y'" & vbCrLf
    	    sqlStr = sqlStr & "	,lastUpdate=getdate()" & vbCrLf
    	    sqlStr = sqlStr & "	where appkey=" & sAppKey & " and deviceid='" & sDeviceId & "'" & vbCrLf
    		sqlStr = sqlStr & " end"& vbCrLf
    		dbget.Execute(sqlStr)
    	elseif (sType="rmv") then ''버전업이 된경우 삭제
    	    sqlStr = "update db_contents.dbo.tbl_app_regInfo" & vbCrLf
    	    sqlStr = sqlStr & "	set isusing='N'" & vbCrLf
    	    sqlStr = sqlStr & "	,lastact='rmv'" & vbCrLf
    	    sqlStr = sqlStr & "	,lastUpdate=getdate()" & vbCrLf
    	    sqlStr = sqlStr & "	where appkey=" & sAppKey & " and deviceid='" & sDeviceId & "'" & vbCrLf
    	    dbget.Execute(sqlStr)
    	end if

        ''변경로그 작성
    	call addDeviceLog(sAppKey,sDeviceId,"",sVerCd,sType)
	end if
    
    if (sDeviceId<>"") and (sType<>"rmv") then
        '' uuid 추가 2014/06/25 --------------------------------
        ''call addUUIDInfo(sAppKey,sDeviceId,sUUID)
        '' nid 추가 2015/07/23 --------------------------------
        call addUUIDNidInfo(sAppKey,sDeviceId,sUUID,snid)
        ''------------------------------------------------------
    end if

	oJson("response") = getErrMsg("1000",sFDesc)

end if

if ERR then Call OnErrNoti()
On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
'---------------------------
'/서버 주기적 업데이트 위한 공사중 처리 '2011.11.11 한용민 생성
'/리뉴얼시 이전해 주시고 지우지 말아 주세요
'@@ 서버 점검시 아래 주석을 풀고 예상 작업시간을 입력해주세요. 
'if Not(isTenbyTenConnect) then
'	Set oJson = jsObject()
'	oJson("response") = getErrMsg("9999",sFDesc)
'	oJson("faildesc") = "불편을 드려 죄송합니다. 텐바이텐 정기점검 중입니다. (02:00~07:00)"
'	oJson.flush
'	Set oJson = Nothing
'	Response.End
'End if
'---------------------------
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64New.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/startupProc.asp
' Discription : Wish APP 최초구동시 정보 처리
' Request : json > type, pushid, OS, versioncode, versionname, verserion
' Response : response > 결과, event
' History : 2014.01.10 허진원 : 신규 생성
'###############################################

'//헤더 출력
Response.ContentType = "text/html"

Dim sFDesc
Dim sType, sDeviceId
Dim sOS, sVerCd, sVerNm, sJsonVer, sAppKey, sMinUpVer, sCurrVer, sCurrVerNm, sAppId, sUUID
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

	if ((sAppKey="6") and (sVerCd>"38")) or ((sAppKey="5") and (sVerCd>"1.3")) then  ''안드로이드 39버전부터 , ios 1.4 부터 uuid 추가 //2016/06/25
	    if Not ERR THEN
    	    sUUID = requestCheckVar(oResult.uuid,40)
    	    if ERR THEN Err.Clear ''uuid 프로토콜 없음
	    END IF
	end if
set oResult = Nothing

'// json객체 선언
Set oJson = jsObject()

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."

elseif sType<>"firstconnection" then
	'// 잘못된 콜싸인 아님
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "잘못된 접근입니다."

elseif sAppKey="" then
	'// 잘못된 접근
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "파라메터 정보가 없습니다."

else
	dim sqlStr

	'// 위시 앱버전 확인
	sqlStr = "Select minuUpVer, currVer, currVerName, appId from db_contents.dbo.tbl_app_master Where appKey=" & sAppKey
	rsget.Open sqlStr,dbget,1
	if Not(rsget.EOF or rsget.BOF) then
		sMinUpVer = rsget("minuUpVer")			'크리티컬한 최소 구동 버전
		sCurrVer = rsget("currVer")				'최신 APP버전
		sCurrVerNm = rsget("currVerName")		'최신 APP버전명 (Android)
		sAppId = rsget("appId")			'앱스토어 AppId
	else
		sMinUpVer = "0"
		sCurrVer = "1"
		sCurrVerNm = "1.0"
		sAppId = ""
	end if
	rsget.Close

'    if (sDeviceId="62ee07d47b6ca7e236b6d3c7318a62d83ae5c68df32e780d838dd4a66bc5735e") then
'        sMinUpVer = "0"
'		sCurrVer = "1.2"
'		sCurrVerNm = "1.2"
'		sAppId = "864817011"
'    end if

	if (cStr(sVerCd)<cStr(sMinUpVer)) then
		'서비스를 제공하기에 현재 앱버전이 너무 낮아 연결 할수 없음
		oJson("response") = getErrMsg("9100",sFDesc)
		oJson("appid")    = sAppId
		oJson("faildesc") = sFDesc
	else

		if sDeviceId<>"" then
			'// 접속 기기 정보 저장 //필요 없을듯 deviceProc.asp 추가됨
			sqlStr = "IF NOT EXISTS(select regidx from db_contents.dbo.tbl_app_regInfo where appkey=" & sAppKey & " and deviceid='" & sDeviceId & "') " & vbCrLf
			sqlStr = sqlStr & " begin " & vbCrLf
			sqlStr = sqlStr & "	insert into db_contents.dbo.tbl_app_regInfo " & vbCrLf
			sqlStr = sqlStr & "		(appKey,deviceid,regdate,appVer,lastact,isAlarm01,isAlarm02,isAlarm03,isAlarm04,isAlarm05,regrefip) values " & vbCrLf
			sqlStr = sqlStr & "	(" & sAppKey			'앱고유Key
			sqlStr = sqlStr & ",'" & sDeviceId & "'"	'접속기기 DeviceID
			sqlStr = sqlStr & ",getdate()"				'최초접속 일시
			sqlStr = sqlStr & ",'"&sVerCd&"'"			'버전                       ''/2014/03/21
			sqlStr = sqlStr & ",'str'"                  '' 최종액션구분
			sqlStr = sqlStr & ",'Y'"					'위시메이트 알림 여부
			sqlStr = sqlStr & ",'Y'"					'구매정보 알림 여부
			sqlStr = sqlStr & ",'Y'"					'이벤트 및 혜택 알림 여부
			sqlStr = sqlStr & ",'N','N','"&Request.ServerVariables("REMOTE_ADDR")&"') " & vbCrLf
			sqlStr = sqlStr & " end" & vbCrLf
			sqlStr = sqlStr & " ELSE" & vbCrLf
			sqlStr = sqlStr & " begin " & vbCrLf
    		sqlStr = sqlStr & " update db_contents.dbo.tbl_app_regInfo" & vbCrLf
    	    sqlStr = sqlStr & "	set lastact='stU'" & vbCrLf
    	    sqlStr = sqlStr & "	,appVer='"&sVerCd&"'" & vbCrLf
    	    sqlStr = sqlStr & "	,isusing='Y'" & vbCrLf
    	    sqlStr = sqlStr & "	,lastUpdate=getdate()" & vbCrLf
    	    sqlStr = sqlStr & "	where appkey=" & sAppKey & " and deviceid='" & sDeviceId & "'" & vbCrLf
			sqlStr = sqlStr & " end" & vbCrLf
			dbget.Execute(sqlStr)

			''call addDeviceLog(sAppKey,sDeviceId,"",sVerCd,"str")
		else
		    call addDeviceLog(sAppKey,sDeviceId,"",sVerCd,"ttt")
		end if

        '' uuid 추가 2014/06/25 --------------------------------
        call addUUIDInfo(sAppKey,sDeviceId,sUUID)
        '' uuid 추가 2014/06/25 --------------------------------

		oJson("response") = getErrMsg("1000",sFDesc)
		oJson("event") = cStr(0)		'신규 APP전용 이벤트

        'if (sDeviceId="96358f330f215a18e7d9609cf6e731513f6b0619c72691c1309729632fe49f42") then
        '    oJson("lastversionname") = cStr("1.2")		'현재App 버전명
		'    oJson("lastversioncode") = cStr("1.2")		'현재App 버전
        'else
		  oJson("lastversionname") = cStr(sCurrVerNm)		'현재App 버전명
		  oJson("lastversioncode") = cStr(sCurrVer)		'현재App 버전
        'end if

		dim strAppWVUrl
		IF application("Svr_Info")="Dev" THEN
			strAppWVUrl = "http://testm.10x10.co.kr/apps/appCom/wish/webview"
		else
			strAppWVUrl = "http://m.10x10.co.kr/apps/appCom/wish/webview"
		end if

		'//현재 진행중인 이벤트 배너 접수 //2014/07/20 이후 주석처리 필요. 더이상 이벤트 팝업 사용 안함
		sqlStr = "select top 1 bannerType "
		sqlStr = sqlStr & "from db_contents.dbo.tbl_app_eventBanner "
		sqlStr = sqlStr & "where isUsing='Y' "
		sqlStr = sqlStr & "	and getdate() between startdate and enddate "
		sqlStr = sqlStr & "	and appname='wishapp' "
		sqlStr = sqlStr & "order by bannerType asc, sortNo asc, idx desc"
		rsget.Open sqlStr,dbget,1

		if Not(rsget.EOF or rsget.BOF) then
			oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/appEventBanner.asp")	'이벤트 배너 URL
			oJson("maineventtype") = chkIIF(rsget("bannerType")="F","full","half")					'full:전체화면 배너, half:작은 사이즈 배너
		else
			oJson("maineventurl") = ""
			oJson("maineventtype") = ""
		end if
		rsget.Close

		''oJson("maineventurl") = ""
		''oJson("maineventtype") = ""

		'// 추후 업데이트시 이동될 AppID
		oJson("appid") = sAppId

	end if

end if

if ERR then Call OnErrNoti()
On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
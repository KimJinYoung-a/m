<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
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
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64New.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/apps/appCom/wish/protoV3/protoV3Function.asp"-->
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
Dim sOS, sVerCd, sVerNm, sJsonVer, sAppKey, sMinUpVer, sCurrVer, sCurrVerNm, sAppId, sUUID, sPushyn, snID, sSetVer, sSetVerName, sAdID, sAmplitudeApiKey
Dim sData : sData = Request("json")
Dim oJson

'// 전송결과 파징
on Error Resume Next

'// AmplitudeApiKey값 정의
if application("Svr_Info")="staging" Then
	sAmplitudeApiKey = "accf99428106843efdd88df080edd82e"
else
	sAmplitudeApiKey = "3de77f281d7d09a7903c1d1fa2e4fa2d"
end if


dim oResult
set oResult = JSON.parse(sData)
	sType = oResult.type
	sDeviceId = requestCheckVar(oResult.pushid,256)

	sOS = requestCheckVar(oResult.OS,10)
	sVerCd = requestCheckVar(oResult.versioncode,20)
	sVerNm = requestCheckVar(oResult.versionname,32)
	sJsonVer = requestCheckVar(oResult.version,10)

	sAppKey = getWishAppKey(sOS)

	''if ((sAppKey="6") and (sVerCd>"38")) or ((sAppKey="5") and (sVerCd>"1.3")) then  ''안드로이드 39버전부터 , ios 1.4 부터 uuid 추가 //2016/06/25
	    if Not ERR THEN
    	    sUUID = requestCheckVar(oResult.uuid,40)
    	    if ERR THEN Err.Clear ''uuid 프로토콜 없음
	    END IF
	''end if
    
    ''2015/07/23
    ''if ((sAppKey="6") and (sVerCd>="66")) or ((sAppKey="5") and (sVerCd>="1.96")) then  ''안드로이드 66버전부터 , ios 1.96 부터 nid 추가 //2015/07/23
	    if Not ERR THEN
    	    snID = requestCheckVar(oResult.nid,40)
    	    if ERR THEN Err.Clear ''uuid 프로토콜 없음
	    END IF
	''end if
	
	''2017/04/06 android adid 추가
	if ((sAppKey="6") and (sVerCd>="91")) then  ''안드로이드 90버전부터
	    if Not ERR THEN
    	    sAdID = requestCheckVar(oResult.adid,40)
    	    if ERR THEN Err.Clear ''adid 프로토콜 없음
	    END IF
	end if
	
'' 나중에 다시
'	if (sAppKey="5") then
'	    if Not ERR THEN
'	        sPushyn  = requestCheckVar(oResult.pushyn,1) '' 2014/09/25
'	        if ERR THEN Err.Clear ''pushyn 프로토콜 없음
'	    END IF
'	end if

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
	sqlStr = "Select minuUpVer, currVer, currVerName, appId, SetVer, SetVerName from db_contents.dbo.tbl_app_master Where appKey=" & sAppKey
	rsget.Open sqlStr,dbget,1
	if Not(rsget.EOF or rsget.BOF) then
		sMinUpVer = rsget("minuUpVer")			'크리티컬한 최소 구동 버전   '' 막음.
		sCurrVer = rsget("currVer")				'최신 APP버전                '' 권장업데이트시
		sCurrVerNm = rsget("currVerName")		'최신 APP버전명 (Android)    '' 권장업데이트시
		sAppId = rsget("appId")			        '앱스토어 AppId
		
		sSetVer     = rsget("setver")           ' 설정페이지 버전 , 항상 최근 버전으로 세팅 버전 업 3시간 이상후
		sSetVerName = rsget("setvername")       ' 설정페이지 버전 , 항상 최근 버전으로 세팅 버전 업 3시간 이상후
	else
		sMinUpVer = "0"
		sCurrVer = "1"
		sCurrVerNm = "1.0"
		sAppId = ""
		sSetVer     = "1"
		sSetVerName = "1.0"
	end if
	rsget.Close

'    if (sDeviceId="62ee07d47b6ca7e236b6d3c7318a62d83ae5c68df32e780d838dd4a66bc5735e") then
'       sMinUpVer = "0"
'		sCurrVer = "1.2"
'		sCurrVerNm = "1.2"
'		sAppId = "864817011"
'    end if

'' IOS
' 테스트 1 - 낮은버전(일반 업데이트)
'    if (sAppKey="5") then
'        sMinUpVer = "0"
'		sCurrVer = "1.7"
'		sCurrVerNm = "1.7"
'		sAppId = "864817011"
'    end if

'' 테스트 2 - 강제업데이트
'    if (sAppKey="5") then
'        sMinUpVer = "1.7"
'		sCurrVer = "1.7"
'		sCurrVerNm = "1.7"
'		sAppId = "864817011"
'    end if

'' Android
'' 테스트 1 - 낮은버전(일반 업데이트)
'    if (sAppKey="6") then
'       sMinUpVer = "32"
'		sCurrVer = "42"
'		sCurrVerNm = "1.41"
'		sAppId = "kr.tenbyten.shoping"
'    end if

'' 테스트 2 - 강제업데이트
'    if (sAppKey="6") then
'        sMinUpVer = "42"
'		sCurrVer = "42"
'		sCurrVerNm = "1.41"
'		sAppId = "kr.tenbyten.shoping"
'    end if

	if (Cdbl(sVerCd)<Cdbl(sMinUpVer)) then
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
        ''call addUUIDInfo(sAppKey,sDeviceId,sUUID)
        '' nid 추가 2015/07/23 --------------------------------
        call addUUIDNidInfo(sAppKey,sDeviceId,sUUID,snid)
        ''------------------------------------------------------
        ''adid 추가 2017/04/06 (android only)-------------------
        if (sAdID<>"") then
            call updateAdIDInfo(sAppKey,snid,sAdID)
        end if
        ''------------------------------------------------------
        
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
			strAppWVUrl = "http://testm.10x10.co.kr/apps/appCom/wish/web2014"
		else
			strAppWVUrl = "http://m.10x10.co.kr/apps/appCom/wish/web2014"
		end if

		'//현재 진행중인 이벤트 배너 접수
'		sqlStr = "select top 1 bannerType "
'		sqlStr = sqlStr & "from db_contents.dbo.tbl_app_eventBanner "
'		sqlStr = sqlStr & "where isUsing='Y' "
'		sqlStr = sqlStr & "	and getdate() between startdate and enddate "
'		sqlStr = sqlStr & "	and appname='wishapp' "
'		sqlStr = sqlStr & "	and bannerType='F' "  '오픈시 주석 풀어주실것
'		sqlStr = sqlStr & "order by bannerType asc, sortNo asc, idx desc"
'		rsget.Open sqlStr,dbget,1
'
'		if Not(rsget.EOF or rsget.BOF) then
'			oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/appEventBanner.asp")	'이벤트 배너 URL
'			oJson("maineventtype") = chkIIF(rsget("bannerType")="F","full","full")					'full:전체화면 배너, half:작은 사이즈 배너 V2에서 half 는 않쓰임.
'		else
'			oJson("maineventurl") = ""
'			oJson("maineventtype") = ""
'		end if
'		rsget.Close

        Dim isIOSreviewSkip : isIOSreviewSkip=FALSE   ''IOS 심사중 배너 띠우지 않음.
'        isIOSreviewSkip = ((sAppKey="5") and (sVerCd="1.995")) ''심사후 액티브 하면 이줄을 주석 처리 할것
        
    '' 앱 이벤트 임시.
        dim inotval : inotval = false

        if (NOT isIOSreviewSkip) and (Now() >= #05/13/2015 10:00:00# And Now() < #05/20/2015 23:59:59#) Then
			'// 주말엔 디스전 이벤트 전면배너 안띄움
			If Left(Now(),10)="2015-05-16" Or Left(Now(),10)="2015-05-17" Then
				oJson("maineventurl") = ""
				oJson("maineventtype") = ""
			Else
				sqlStr = "select top 1 deviceid from db_contents.dbo.tbl_app_regInfo"
				sqlStr = sqlStr & "	where (regdate>='2015-05-13' and regdate<'2015-05-27'"              ''시작 날짜 조절할것.
				sqlStr = sqlStr & "	and deviceid='"&sDeviceId&"')"
				sqlStr = sqlStr & " or (deviceid='"&sDeviceId&"' and userid in ('icommang','baboytw','winnie','gawisonten10','greenteenz','edojun','motions','thensi7','tlswjd0428','bjh2546','eugene20','bborami','stella0117','djjung','areum531','cogusdk','kyungae13'))"  ''TEST

				rsget.Open sqlStr,dbget,1
				if Not(rsget.EOF or rsget.BOF) then
					oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_62086_Banner.asp")
					oJson("maineventtype") = "full"
				else
					inotval = true
				end if
				rsget.Close

				if (inotval) then
					sqlStr = "select top 1 * from db_contents.dbo.tbl_app_uuidInfo"
					sqlStr = sqlStr & "	where (regdate>='2015-05-13' and regdate<'2015-05-27')"              ''시작 날짜 조절할것.
					sqlStr = sqlStr & "	and  uuid='"&sUUID&"'"

					rsget.Open sqlStr,dbget,1
					if Not(rsget.EOF or rsget.BOF) then
						oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_62086_Banner.asp")
						oJson("maineventtype") = "full"
					else
						oJson("maineventurl") = ""
						oJson("maineventtype") = ""
					end if
					rsget.Close
				end If
			End If
		ElseIf  (NOT isIOSreviewSkip) and (Now() >= #10/01/2015 10:00:00# And Now() < #10/10/2015 00:00:00#) Then '//듣기평가

			sqlStr = "select top 1 deviceid from db_contents.dbo.tbl_app_regInfo"
			sqlStr = sqlStr & "	where (regdate>='2015-10-01' and regdate<'2015-10-10'"              ''시작 날짜 조절할것.
			sqlStr = sqlStr & "	and deviceid='"&sDeviceId&"')"
			sqlStr = sqlStr & " or (deviceid='"&sDeviceId&"' and userid in ('icommang','tozzinet','baboytw','winnie','gawisonten10','greenteenz','edojun','motions','thensi7','tlswjd0428','bjh2546','eugene20','bborami','stella0117','djjung','areum531','cogusdk','kyungae13','jinyeonmi'))"  ''TEST

			rsget.Open sqlStr,dbget,1
			if Not(rsget.EOF or rsget.BOF) then
				oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_66480_Banner.asp")
				oJson("maineventtype") = "full"
			else
				inotval = true
			end if
			rsget.Close

			if (inotval) then
				sqlStr = "select top 1 * from db_contents.dbo.tbl_app_uuidInfo"
				sqlStr = sqlStr & "	where (regdate>='2015-10-01' and regdate<'2015-10-10')"              ''시작 날짜 조절할것.
				sqlStr = sqlStr & "	and  uuid='"&sUUID&"'"

				rsget.Open sqlStr,dbget,1
				if Not(rsget.EOF or rsget.BOF) then
					oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_66480_Banner.asp")
					oJson("maineventtype") = "full"
				else
					oJson("maineventurl") = ""
					oJson("maineventtype") = ""
				end if
				rsget.Close
			end If
		ElseIf  (NOT isIOSreviewSkip) and (Now() >= #11/01/2015 10:00:00# And Now() < #11/07/2015 00:00:00#) Then '//모여라 꿈동산
			sqlStr = "select top 1 deviceid from db_contents.dbo.tbl_app_regInfo"
			sqlStr = sqlStr & "	where (regdate>='2015-11-01' and regdate<'2015-11-07'"              ''시작 날짜 조절할것.
			sqlStr = sqlStr & "	and deviceid='"&sDeviceId&"')"
			sqlStr = sqlStr & " or (deviceid='"&sDeviceId&"' and userid in ('icommang','tozzinet','baboytw','winnie','gawisonten10','greenteenz','edojun','motions','thensi7','tlswjd0428','bjh2546','eugene20','bborami','stella0117','djjung','areum531','cogusdk','kyungae13','jinyeonmi'))"  ''TEST

			rsget.Open sqlStr,dbget,1
			if Not(rsget.EOF or rsget.BOF) then
				oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_67097_Banner.asp")
				oJson("maineventtype") = "full"
			else
				inotval = true
			end if
			rsget.Close

			if (inotval) then
				sqlStr = "select top 1 * from db_contents.dbo.tbl_app_uuidInfo"
				sqlStr = sqlStr & "	where (regdate>='2015-11-01' and regdate<'2015-11-07')"              ''시작 날짜 조절할것.
				sqlStr = sqlStr & "	and  uuid='"&sUUID&"'"

				rsget.Open sqlStr,dbget,1
				if Not(rsget.EOF or rsget.BOF) then
					oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_67097_Banner.asp")
					oJson("maineventtype") = "full"
				else
					oJson("maineventurl") = ""
					oJson("maineventtype") = ""
				end if
				rsget.Close
			end If
		ElseIf  (NOT isIOSreviewSkip) and (Now() >= #11/09/2015 10:00:00# And Now() < #11/14/2015 00:00:00#) Then '//습격자들 온라인편
			sqlStr = "select top 1 deviceid from db_contents.dbo.tbl_app_regInfo"
			sqlStr = sqlStr & "	where (regdate>='2015-11-09' and regdate<'2015-11-14'"              ''시작 날짜 조절할것.
			sqlStr = sqlStr & "	and deviceid='"&sDeviceId&"')"
			sqlStr = sqlStr & " or (deviceid='"&sDeviceId&"' and userid in ('icommang','tozzinet','baboytw','winnie','gawisonten10','greenteenz','edojun','motions','thensi7','tlswjd0428','bjh2546','eugene20','bborami','stella0117','djjung','areum531','cogusdk','kyungae13','jinyeonmi'))"  ''TEST

			rsget.Open sqlStr,dbget,1
			if Not(rsget.EOF or rsget.BOF) then
				oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_67204_Banner.asp")
				oJson("maineventtype") = "full"
			else
				inotval = true
			end if
			rsget.Close

			if (inotval) then
				sqlStr = "select top 1 * from db_contents.dbo.tbl_app_uuidInfo"
				sqlStr = sqlStr & "	where (regdate>='2015-11-09' and regdate<'2015-11-14')"              ''시작 날짜 조절할것.
				sqlStr = sqlStr & "	and  uuid='"&sUUID&"'"

				rsget.Open sqlStr,dbget,1
				if Not(rsget.EOF or rsget.BOF) then
					oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_67204_Banner.asp")
					oJson("maineventtype") = "full"
				else
					oJson("maineventurl") = ""
					oJson("maineventtype") = ""
				end if
				rsget.Close
			end If
		ElseIf  (NOT isIOSreviewSkip) and (Now() >= #12/16/2015 10:00:00# And Now() < #12/19/2015 00:00:00#) Then '//돌아온 크리스박스
			If  Left(Now(),10)="2015-12-15" Then		''배너 안띄우는 날
				oJson("maineventurl") = ""
				oJson("maineventtype") = ""
			Else
				sqlStr = "select top 1 deviceid from db_contents.dbo.tbl_app_regInfo"
				sqlStr = sqlStr & "	where (regdate>='2015-12-09' and regdate<'2015-12-19'"              ''시작 날짜 조절할것.
				sqlStr = sqlStr & "	and deviceid='"&sDeviceId&"')"
				sqlStr = sqlStr & " or (deviceid='"&sDeviceId&"' and userid in ('icommang','tozzinet','baboytw','winnie','gawisonten10','greenteenz','edojun','motions','thensi7','tlswjd0428','bjh2546','eugene20','bborami','stella0117','djjung','areum531','cogusdk','kyungae13','jinyeonmi'))"  ''TEST
	
				rsget.Open sqlStr,dbget,1
				if Not(rsget.EOF or rsget.BOF) then
					oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_67929_Banner.asp")
					oJson("maineventtype") = "full"
				else
					inotval = true
				end if
				rsget.Close
	
				if (inotval) then
					sqlStr = "select top 1 * from db_contents.dbo.tbl_app_uuidInfo"
					sqlStr = sqlStr & "	where (regdate>='2015-12-09' and regdate<'2015-12-19')"              ''시작 날짜 조절할것.
					sqlStr = sqlStr & "	and  uuid='"&sUUID&"'"
	
					rsget.Open sqlStr,dbget,1
					if Not(rsget.EOF or rsget.BOF) then
						oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_67929_Banner.asp")
						oJson("maineventtype") = "full"
					else
						oJson("maineventurl") = ""
						oJson("maineventtype") = ""
					end if
					rsget.Close
				end If
			end If
		
		ElseIf  (NOT isIOSreviewSkip) and (Now() >= #03/21/2016 10:00:00# And Now() < #03/27/2016 00:00:00#) Then ''//사대천왕 유태욱

			sqlStr = "select top 1 deviceid from db_contents.dbo.tbl_app_regInfo"
			sqlStr = sqlStr & "	where (regdate>='2016-03-21' and regdate<'2016-03-28'"              ''시작 날짜 조절할것.
			sqlStr = sqlStr & "	and deviceid='"&sDeviceId&"')"
			sqlStr = sqlStr & " or (deviceid='"&sDeviceId&"' and userid in ('icommang','tozzinet','baboytw','greenteenz'))"  ''TEST

			rsget.Open sqlStr,dbget,1
			if Not(rsget.EOF or rsget.BOF) then
				oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_69690_Banner.asp")
				oJson("maineventtype") = "full"
			else
				inotval = true
			end if
			rsget.Close

			if (inotval) then
				sqlStr = "select top 1 * from db_contents.dbo.tbl_app_uuidInfo"
				sqlStr = sqlStr & "	where (regdate>='2016-03-21' and regdate<'2016-03-28')"              ''시작 날짜 조절할것.
				sqlStr = sqlStr & "	and  uuid='"&sUUID&"'"

				rsget.Open sqlStr,dbget,1
				if Not(rsget.EOF or rsget.BOF) then
					oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_69690_Banner.asp")
					oJson("maineventtype") = "full"
				else
					oJson("maineventurl") = ""
					oJson("maineventtype") = ""
				end if
				rsget.Close
			end If

		ElseIf  (NOT isIOSreviewSkip) and (Now() >= #03/28/2016 10:00:00# And Now() < #04/02/2016 00:00:00#) Then ''//10원의 마술상 원승현

			sqlStr = "select top 1 deviceid from db_contents.dbo.tbl_app_regInfo"
			sqlStr = sqlStr & "	where (regdate>='2016-03-28' and regdate<'2016-04-02'"              ''시작 날짜 조절할것.
			sqlStr = sqlStr & "	and deviceid='"&sDeviceId&"')"
			sqlStr = sqlStr & " or (deviceid='"&sDeviceId&"' and userid in ('icommang','tozzinet','baboytw','greenteenz', 'thensi7','kobula'))"  ''TEST

			rsget.Open sqlStr,dbget,1
			if Not(rsget.EOF or rsget.BOF) then
				oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_69883_Banner.asp")
				oJson("maineventtype") = "full"
			else
				inotval = true
			end if
			rsget.Close

			if (inotval) then
				sqlStr = "select top 1 * from db_contents.dbo.tbl_app_uuidInfo"
				sqlStr = sqlStr & "	where (regdate>='2016-03-28' and regdate<'2016-04-02')"              ''시작 날짜 조절할것.
				sqlStr = sqlStr & "	and  uuid='"&sUUID&"'"

				rsget.Open sqlStr,dbget,1
				if Not(rsget.EOF or rsget.BOF) then
					oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_69883_Banner.asp")
					oJson("maineventtype") = "full"
				else
					oJson("maineventurl") = ""
					oJson("maineventtype") = ""
				end if
				rsget.Close
			end If

		ElseIf  (NOT isIOSreviewSkip) and (Now() >= #05/16/2016 10:00:00# And Now() < #05/23/2016 00:00:00#) Then ''//오벤져스 허진원 (비밀의 방2는 전면배너 없음)

			sqlStr = "select top 1 deviceid from db_contents.dbo.tbl_app_regInfo"
			sqlStr = sqlStr & "	where (regdate>='2016-05-16' and regdate<'2016-05-23'"              ''시작 날짜 조절할것.
			sqlStr = sqlStr & "	and deviceid='"&sDeviceId&"')"
			sqlStr = sqlStr & " or (deviceid='"&sDeviceId&"' and userid in ('icommang','tozzinet','baboytw','greenteenz','kobula'))"  ''TEST

			rsget.Open sqlStr,dbget,1
			if Not(rsget.EOF or rsget.BOF) then
				oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_70684_Banner.asp")
				oJson("maineventtype") = "full"
			else
				inotval = true
			end if
			rsget.Close

			if (inotval) then
				sqlStr = "select top 1 * from db_contents.dbo.tbl_app_uuidInfo"
				sqlStr = sqlStr & "	where (regdate>='2016-05-16' and regdate<'2016-05-23')"              ''시작 날짜 조절할것.
				sqlStr = sqlStr & "	and  uuid='"&sUUID&"'"

				rsget.Open sqlStr,dbget,1
				if Not(rsget.EOF or rsget.BOF) then
					oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_70684_Banner.asp")
					oJson("maineventtype") = "full"
				else
					oJson("maineventurl") = ""
					oJson("maineventtype") = ""
				end if
				rsget.Close
			end If
		ElseIf  (NOT isIOSreviewSkip) and (Now() >= #11/14/2016 10:00:00# And Now() < #11/18/2016 00:00:00#) Then ''//사행시 김진영..요청오면 날짜확인 후 주석풀기

			sqlStr = "select top 1 deviceid from db_contents.dbo.tbl_app_regInfo"
			sqlStr = sqlStr & "	where (regdate>='2016-11-14' and regdate<'2016-11-19'"              ''시작 날짜 조절할것.
			sqlStr = sqlStr & "	and deviceid='"&sDeviceId&"')"
			sqlStr = sqlStr & " or (deviceid='"&sDeviceId&"' and userid in ('icommang','tozzinet','baboytw','greenteenz', 'kjy8517'))"  ''TEST

			rsget.Open sqlStr,dbget,1
			if Not(rsget.EOF or rsget.BOF) then
				oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_74249_Banner.asp")
				oJson("maineventtype") = "full"
			else
				inotval = true
			end if
			rsget.Close

			if (inotval) then
				sqlStr = "select top 1 * from db_contents.dbo.tbl_app_uuidInfo"
				sqlStr = sqlStr & "	where (regdate>='2016-11-14' and regdate<'2016-11-19')"              ''시작 날짜 조절할것.
				sqlStr = sqlStr & "	and  uuid='"&sUUID&"'"

				rsget.Open sqlStr,dbget,1
				if Not(rsget.EOF or rsget.BOF) then
					oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_74249_Banner.asp")
					oJson("maineventtype") = "full"
				else
					oJson("maineventurl") = ""
					oJson("maineventtype") = ""
				end if
				rsget.Close
			end If
		ElseIf  (NOT isIOSreviewSkip) and (Now() >= #11/18/2016 00:00:00# And Now() < #11/27/2016 23:59:59#) Then ''//[11월 신규가입이벤트] 1+1 Coupon 김진영

			sqlStr = "select top 1 deviceid from db_contents.dbo.tbl_app_regInfo"
			sqlStr = sqlStr & "	where (regdate>='2016-11-01' and regdate<'2016-12-01'"              ''시작 날짜 조절할것.
			sqlStr = sqlStr & "	and deviceid='"&sDeviceId&"')"
			sqlStr = sqlStr & " or (deviceid='"&sDeviceId&"' and userid in ('icommang','tozzinet','baboytw','greenteenz','kobula','kjy8517'))"  ''TEST

			rsget.Open sqlStr,dbget,1
			if Not(rsget.EOF or rsget.BOF) then
				oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_73892_Banner.asp")
				oJson("maineventtype") = "full"
			else
				inotval = true
			end if
			rsget.Close

			if (inotval) then
				sqlStr = "select top 1 * from db_contents.dbo.tbl_app_uuidInfo"
				sqlStr = sqlStr & "	where (regdate>='2016-11-01' and regdate<'2016-12-01')"              ''시작 날짜 조절할것.
				sqlStr = sqlStr & "	and  uuid='"&sUUID&"'"

				rsget.Open sqlStr,dbget,1
				if Not(rsget.EOF or rsget.BOF) then
					oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_73892_Banner.asp")
					oJson("maineventtype") = "full"
				else
					oJson("maineventurl") = ""
					oJson("maineventtype") = ""
				end if
				rsget.Close
			end If
		ElseIf  (NOT isIOSreviewSkip) and (Now() >= #11/28/2016 10:00:00# And Now() < #12/02/2016 00:00:00#) Then ''//그린 크리스박스 이니스프리

			sqlStr = "select top 1 deviceid from db_contents.dbo.tbl_app_regInfo"
			sqlStr = sqlStr & "	where (regdate>='2016-11-28' and regdate<'2016-12-03'"              ''시작 날짜 조절할것.
			sqlStr = sqlStr & "	and deviceid='"&sDeviceId&"')"
			sqlStr = sqlStr & " or (deviceid='"&sDeviceId&"' and userid in ('icommang','tozzinet','baboytw','greenteenz', 'kjy8517'))"  ''TEST

			rsget.Open sqlStr,dbget,1
			if Not(rsget.EOF or rsget.BOF) then
				oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_74541_Banner.asp")
				oJson("maineventtype") = "full"
			else
				inotval = true
			end if
			rsget.Close

			if (inotval) then
				sqlStr = "select top 1 * from db_contents.dbo.tbl_app_uuidInfo"
				sqlStr = sqlStr & "	where (regdate>='2016-11-28' and regdate<'2016-12-03')"              ''시작 날짜 조절할것.
				sqlStr = sqlStr & "	and  uuid='"&sUUID&"'"

				rsget.Open sqlStr,dbget,1
				if Not(rsget.EOF or rsget.BOF) then
					oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_74541_Banner.asp")
					oJson("maineventtype") = "full"
				else
					oJson("maineventurl") = ""
					oJson("maineventtype") = ""
				end if
				rsget.Close
			end If
		ElseIf  (NOT isIOSreviewSkip) and (Now() >= #12/02/2016 00:00:00# And Now() < #12/18/2016 23:59:59#) Then ''//[12월 신규가입이벤트] 1+1 Coupon 유태욱

			sqlStr = "select top 1 deviceid from db_contents.dbo.tbl_app_regInfo"
			sqlStr = sqlStr & "	where (regdate>='2016-12-01' and regdate<'2017-01-01'"              ''시작 날짜 조절할것.
			sqlStr = sqlStr & "	and deviceid='"&sDeviceId&"')"
			sqlStr = sqlStr & " or (deviceid='"&sDeviceId&"' and userid in ('icommang','tozzinet','baboytw','greenteenz','kobula','kjy8517'))"  ''TEST

			rsget.Open sqlStr,dbget,1
			if Not(rsget.EOF or rsget.BOF) then
				oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_74620_Banner.asp")
				oJson("maineventtype") = "full"
			else
				inotval = true
			end if
			rsget.Close

			if (inotval) then
				sqlStr = "select top 1 * from db_contents.dbo.tbl_app_uuidInfo"
				sqlStr = sqlStr & "	where (regdate>='2016-12-01' and regdate<'2017-01-01')"              ''시작 날짜 조절할것.
				sqlStr = sqlStr & "	and  uuid='"&sUUID&"'"

				rsget.Open sqlStr,dbget,1
				if Not(rsget.EOF or rsget.BOF) then
					oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_74620_Banner.asp")
					oJson("maineventtype") = "full"
				else
					oJson("maineventurl") = ""
					oJson("maineventtype") = ""
				end if
				rsget.Close
			end If
		ElseIf  (NOT isIOSreviewSkip) and (Now() >= #12/19/2016 00:00:00# And Now() < #12/24/2016 00:00:00#) Then ''//12월 30일

			sqlStr = "select top 1 deviceid from db_contents.dbo.tbl_app_regInfo"
			sqlStr = sqlStr & "	where (regdate>='2016-12-19' and regdate<'2016-12-24'"              ''시작 날짜 조절할것.
			sqlStr = sqlStr & "	and deviceid='"&sDeviceId&"')"
			sqlStr = sqlStr & " or (deviceid='"&sDeviceId&"' and userid in ('icommang','tozzinet','baboytw','greenteenz', 'thensi7','kobula'))"  ''TEST

			rsget.Open sqlStr,dbget,1
			if Not(rsget.EOF or rsget.BOF) then
				oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_75048_Banner.asp")
				oJson("maineventtype") = "full"
			else
				inotval = true
			end if
			rsget.Close

			if (inotval) then
				sqlStr = "select top 1 * from db_contents.dbo.tbl_app_uuidInfo"
				sqlStr = sqlStr & "	where (regdate>='2016-12-19' and regdate<'2016-12-24')"              ''시작 날짜 조절할것.
				sqlStr = sqlStr & "	and  uuid='"&sUUID&"'"

				rsget.Open sqlStr,dbget,1
				if Not(rsget.EOF or rsget.BOF) then
					oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_75048_Banner.asp")
					oJson("maineventtype") = "full"
				else
					oJson("maineventurl") = ""
					oJson("maineventtype") = ""
				end if
				rsget.Close
			end If
		ElseIf  (NOT isIOSreviewSkip) and (Now() >= #01/01/2017 00:00:00# And Now() < #01/31/2017 23:59:59#) Then ''//[1월 신규가입이벤트] 1+1 Coupon 유태욱

			sqlStr = "select top 1 deviceid from db_contents.dbo.tbl_app_regInfo"
			sqlStr = sqlStr & "	where (regdate>='2017-01-01' and regdate<'2017-02-01'"              ''시작 날짜 조절할것.
			sqlStr = sqlStr & "	and deviceid='"&sDeviceId&"')"
			sqlStr = sqlStr & " or (deviceid='"&sDeviceId&"' and userid in ('icommang','tozzinet','baboytw','greenteenz','kobula','kjy8517'))"  ''TEST

			rsget.Open sqlStr,dbget,1
			if Not(rsget.EOF or rsget.BOF) then
				oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_75258_Banner.asp")
				oJson("maineventtype") = "full"
			else
				inotval = true
			end if
			rsget.Close

			if (inotval) then
				sqlStr = "select top 1 * from db_contents.dbo.tbl_app_uuidInfo"
				sqlStr = sqlStr & "	where (regdate>='2017-01-01' and regdate<'2017-02-01')"              ''시작 날짜 조절할것.
				sqlStr = sqlStr & "	and  uuid='"&sUUID&"'"

				rsget.Open sqlStr,dbget,1
				if Not(rsget.EOF or rsget.BOF) then
					oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_75258_Banner.asp")
					oJson("maineventtype") = "full"
				else
					oJson("maineventurl") = ""
					oJson("maineventtype") = ""
				end if
				rsget.Close
			end If
		ElseIf  (NOT isIOSreviewSkip) and (Now() >= #02/01/2017 00:00:00# And Now() < #02/28/2017 23:59:59#) Then ''//[2월 신규가입이벤트] 1+1 Coupon 유태욱

			sqlStr = "select top 1 deviceid from db_contents.dbo.tbl_app_regInfo"
			sqlStr = sqlStr & "	where (regdate>='2017-02-01' and regdate<'2017-03-01'"              ''시작 날짜 조절할것.
			sqlStr = sqlStr & "	and deviceid='"&sDeviceId&"')"
			sqlStr = sqlStr & " or (deviceid='"&sDeviceId&"' and userid in ('icommang','tozzinet','baboytw','greenteenz','kobula','kjy8517'))"  ''TEST

			rsget.Open sqlStr,dbget,1
			if Not(rsget.EOF or rsget.BOF) then
				oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_75890_Banner.asp")
				oJson("maineventtype") = "full"
			else
				inotval = true
			end if
			rsget.Close

			if (inotval) then
				sqlStr = "select top 1 * from db_contents.dbo.tbl_app_uuidInfo"
				sqlStr = sqlStr & "	where (regdate>='2017-02-01' and regdate<'2017-03-01')"              ''시작 날짜 조절할것.
				sqlStr = sqlStr & "	and  uuid='"&sUUID&"'"

				rsget.Open sqlStr,dbget,1
				if Not(rsget.EOF or rsget.BOF) then
					oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_75258_Banner.asp")
					oJson("maineventtype") = "full"
				else
					oJson("maineventurl") = ""
					oJson("maineventtype") = ""
				end if
				rsget.Close
			end If

		ElseIf  (NOT isIOSreviewSkip) and (Now() >= #10/10/2015 10:00:00# And Now() < #10/27/2015 00:00:00#) Then '14주년 오픈 배너 안드로이드 신버전 모든 앱 설치자 필수 
			oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/14th_banner.asp")
			oJson("maineventtype") = "full"
		ElseIf (sDeviceId="661d1937bdcd600b8dcee5714d8c82e8c1b8e22657517f40543a18ce6334f5d6") or (sDeviceId="4de4381c4d85925f93f246ed8ca2d4483c91eced8cbdf1e4e1afab4a159227cc") then
	        oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_64071_Banner.asp")
	    	oJson("maineventtype") = "full"
	    'ElseIf (sDeviceId="c4faf2d7ee0ea3f8c43768ac7cf4d95ee6879afebd6e861521521ce12cf0fdbe") then 
	    '    oJson("maineventurl") = b64encode(strAppWVUrl & "/html/test/test1.asp")
	    '  	 oJson("maineventtype") = "full"
        else
            oJson("maineventurl") = ""
    	    oJson("maineventtype") = ""
    	end if

		dim currenttime
		currenttime = now()


		'// 추후 업데이트시 이동될 AppID
		oJson("appid") = sAppId
		oJson("gcp") = "TUJMaWFQNVVPcHpIRmxTbERobFBxbEhqY09vb1RzYStpSklnRUhSbyszWUgwNTZ4QUorWmo0NmF1UkltTythcAo="

        '//BEST 반영
        IF ((sAppKey="6") And (sVerCd>="99270")) Or ((sAppKey="5") And (sVerCd>="4.044")) Then
            Set oJson("topmenu") = getTopMenuJSon_20211109
        '//2021-08-12 PLAY -> 스토리 변경
        ElseIf ((sAppKey="6") And (sVerCd>="99255")) Or ((sAppKey="5") And (sVerCd>="4.031")) Then
            Set oJson("topmenu") = getTopMenuJSon_2020(true)
		'//2020년 리뉴얼 json
		ElseIf ((sAppKey="6") And (sVerCd>="99200")) Or ((sAppKey="5") And (sVerCd>="4.001")) Then
            Set oJson("topmenu") = getTopMenuJSon_2020(false)
		'//2017년 리뉴얼 json
		ElseIf ((sAppKey="6") And (sVerCd>="99009")) Or ((sAppKey="5") And (sVerCd>="2.21")) Then
			If ((sAppKey="5") And (sVerCd>="2.34")) or ((sAppKey="6") And (sVerCd>="99051")) Then 
				Set oJson("topmenu") = getTopMenuJSon_addPlay_2018
			Else 
				Set oJson("topmenu") = getTopMenuJSon_2018
			End If 
		Else
			if ((sAppKey="6") and (sVerCd>="96")) or ((sAppKey="5") and (sVerCd>="2.0")) then  ''안드로이드 96버전부터 , ios 2.0 부터 2017-09-11 릴리즈용 topmenu
				Set oJson("topmenu") = getTopMenuJSon_2017
			Else
				Set oJson("topmenu") = getTopMenuJSon_2015
			End If 
		End If

		'// 로그인 배너 추가(2019.02.20)
		Dim objRstLoginBanner, appBannerLinkUrl1, appBannerLinkUrl2
		sqlStr = " SELECT top 1 idx " & vbcrlf
		sqlStr = sqlStr & "	, poscode, linktype, fixtype " & vbcrlf
		sqlStr = sqlStr & "	, posVarname, imageurl, linkurl " & vbcrlf
		sqlStr = sqlStr & "	, imagewidth, imageheight, startdate " & vbcrlf
		sqlStr = sqlStr & "	, enddate, regdate, reguserid " & vbcrlf
		sqlStr = sqlStr & "	, isusing, orderidx, linkText " & vbcrlf
		sqlStr = sqlStr & "	, itemDesc, workeruserid, imageurl2 " & vbcrlf
		sqlStr = sqlStr & "	, linkText2, linkText3, linkText4 " & vbcrlf
		sqlStr = sqlStr & "	, altname, lastupdate, bgcode " & vbcrlf
		sqlStr = sqlStr & "	, xbtncolor, maincopy, maincopy2 " & vbcrlf
		sqlStr = sqlStr & "	, subcopy, etctag, etctext " & vbcrlf
		sqlStr = sqlStr & "	, ecode, bannertype, altname2 " & vbcrlf
		sqlStr = sqlStr & "	, bgcode2, linkurl2, evt_code " & vbcrlf
		sqlStr = sqlStr & "	, tag_only, targetOS, targetType " & vbcrlf
		sqlStr = sqlStr & "	, imageurl3, altname3, linkurl3 " & vbcrlf
		sqlStr = sqlStr & "	, categoryOptions " & vbcrlf
		sqlStr = sqlStr & " FROM db_sitemaster.dbo.tbl_main_contents " & vbcrlf
		sqlStr = sqlStr & " WHERE poscode='731' " & vbcrlf
		sqlStr = sqlStr & "	    AND getdate() >= startdate AND getdate() <= enddate " & vbcrlf
		sqlStr = sqlStr & "	    AND isusing='Y' " & vbcrlf
		sqlStr = sqlStr & " ORDER BY orderidx ASC, idx DESC "
		rsget.Open sqlStr,dbget,1
		if Not(rsget.EOF or rsget.BOF) then
			If Instr(db2Html(rsget("linkurl")), "gnbflag=1")>0 Then
				appBannerLinkUrl1 = replace(db2Html(rsget("linkurl")),"gnbflag=1","")
			Else
				appBannerLinkUrl1 = db2Html(rsget("linkurl"))
			End If

			If Instr(db2Html(rsget("linkurl2")), "gnbflag=1")>0 Then
				appBannerLinkUrl2 = replace(db2Html(rsget("linkurl2")),"gnbflag=1","")
			Else
				appBannerLinkUrl2 = db2Html(rsget("linkurl2"))
			End If

    		Set objRstLoginBanner = jsArray()
		    SET objRstLoginBanner(Null) = jsObject()
    			objRstLoginBanner(Null)("bannerimageurl") = b64encode(staticImgUrl & "/main/" + db2Html(rsget("imageurl")))
    			objRstLoginBanner(Null)("bannerlinkurl") = b64encode(strAppWVUrl & appBannerLinkUrl1)
			If rsget("linkurl2") <> "" And rsget("imageurl2") <> "" Then
				SET objRstLoginBanner(Null) = jsObject()
					objRstLoginBanner(Null)("bannerimageurl") = b64encode(staticImgUrl & "/main2/" + db2Html(rsget("imageurl2")))
					objRstLoginBanner(Null)("bannerlinkurl") = b64encode(strAppWVUrl & appBannerLinkUrl2)
			End If
		else
			Set objRstLoginBanner = jsArray()
			SET oJson("loginbanner") = objRstLoginBanner
		end if
		rsget.Close
		Set oJson("loginbanner") = objRstLoginBanner
		Set objRstLoginBanner = Nothing

        ''2015/08/20 추가 넛지 inApp관련 파람
        oJson("ngmmt") = "0,0,0" '' 1,3,4
        
        oJson("setver") = sSetVer           ''환경설정에 표시될 버전
        oJson("setvername") = sSetVerName   ''환경설정에 표시될 버전
		oJson("AmplitudeApiKey") = sAmplitudeApiKey

		'// 세션 아이디 기준으로 wk ui 웹뷰 조건
		If Trim(session.sessionID)<>"" Then
			if right(session.sessionID, 1) <= 9 Then
				'// WK, UI 웹뷰 트리거(True = WKWebView, False=UIWebView)
				If ((sAppKey="5") and (sVerCd>="3.003")) then
					oJson("usewkwebview") = true
		'			response.Cookies("WKWebView") = "Y"(2020.06.05 사용하지 않음)
				End If
			end if
		End If		
	end if

end if

'' 비회원 식별조회 2017/11/07
Call fn_CheckNMakeGGsnCookie
CALL fn_AddIISAppendToLOG_GGSN()

if ERR then Call OnErrNoti()
On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
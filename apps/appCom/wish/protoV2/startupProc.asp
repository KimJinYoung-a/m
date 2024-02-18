﻿<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64New.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<!-- #include virtual="/apps/appCom/wish/protoV2/protoV2Function.asp"-->
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

'---------------------------
'@@ 서버 점검시 아래 주석을 풀어주세요
'Set oJson = jsObject()
'oJson("response") = getErrMsg("9999",sFDesc)
'oJson("faildesc") = "불편을 드려 죄송합니다. 텐바이텐 정기점검 중입니다."
'oJson.flush
'Set oJson = Nothing
'Response.End
'---------------------------

Dim sFDesc
Dim sType, sDeviceId
Dim sOS, sVerCd, sVerNm, sJsonVer, sAppKey, sMinUpVer, sCurrVer, sCurrVerNm, sAppId, sUUID, sPushyn, snID
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
    
    ''2015/07/23
    if ((sAppKey="6") and (sVerCd>="66")) or ((sAppKey="5") and (sVerCd>="1.96")) then  ''안드로이드 66버전부터 , ios 1.96 부터 nid 추가 //2015/07/23
	    if Not ERR THEN
    	    snID = requestCheckVar(oResult.nid,40)
    	    if ERR THEN Err.Clear ''uuid 프로토콜 없음
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
'       sMinUpVer = "0"
'		sCurrVer = "1.2"
'		sCurrVerNm = "1.2"
'		sAppId = "864817011"
'    end if

'' IOS
'' 테스트 1 - 낮은버전(일반 업데이트)
    if (sAppKey="5") then
        sMinUpVer = "1.7"
		sCurrVer = "1.996"
		sCurrVerNm = "1.996"
		sAppId = "864817011"
    end if

'' 테스트 2 - 강제업데이트
'    if (sAppKey="5") then
'        sMinUpVer = "1.7"
'		sCurrVer = "1.7"
'		sCurrVerNm = "1.7"
'		sAppId = "864817011"
'    end if

'' Android
'' 테스트 1 - 낮은버전(일반 업데이트)
    if (sAppKey="6") then
       sMinUpVer = "79"
		sCurrVer = "93"
		sCurrVerNm = "1.92"
		sAppId = "kr.tenbyten.shoping"
    end if

'' 테스트 2 - 강제업데이트
'    if (sAppKey="6") then
'        sMinUpVer = "42"
'		sCurrVer = "42"
'		sCurrVerNm = "1.41"
'		sAppId = "kr.tenbyten.shoping"
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
        ''call addUUIDInfo(sAppKey,sDeviceId,sUUID)
        '' nid 추가 2015/07/23 --------------------------------
        call addUUIDNidInfo(sAppKey,sDeviceId,sUUID,snid)
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
'        isIOSreviewSkip = ((sAppKey="5") and (sVerCd="1.97")) ''심사후 액티브 하면 이줄을 주석 처리 할것
        
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
		ElseIf  (NOT isIOSreviewSkip) and (Now() >= #06/10/2015 00:00:00# And Now() < #06/10/2015 10:00:00#) Then '//비둘기
            sqlStr = "select top 1 deviceid from db_contents.dbo.tbl_app_regInfo"
            sqlStr = sqlStr & "	where (regdate>='2015-06-01' and regdate<'2015-06-10'"              ''시작 날짜 조절할것.
            sqlStr = sqlStr & "	and deviceid='"&sDeviceId&"')"
            sqlStr = sqlStr & " or (deviceid='"&sDeviceId&"' and userid in ('icommang','baboytw','winnie','gawisonten10','greenteenz','edojun','motions','thensi7','tlswjd0428','bjh2546','eugene20','bborami','stella0117','djjung','areum531','cogusdk','kyungae13'))"  ''TEST

            rsget.Open sqlStr,dbget,1
            if Not(rsget.EOF or rsget.BOF) then
    			oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_63373_Banner.asp")
    			oJson("maineventtype") = "full"
    		else
    		    inotval = true
    	    end if
    	    rsget.Close

            if (inotval) then
                sqlStr = "select top 1 * from db_contents.dbo.tbl_app_uuidInfo"
                sqlStr = sqlStr & "	where (regdate>='2015-06-01' and regdate<'2015-06-10')"              ''시작 날짜 조절할것.
                sqlStr = sqlStr & "	and  uuid='"&sUUID&"'"

                rsget.Open sqlStr,dbget,1
                if Not(rsget.EOF or rsget.BOF) then
        			oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_63373_Banner.asp")
        			oJson("maineventtype") = "full"
        		else
        	        oJson("maineventurl") = ""
        		    oJson("maineventtype") = ""
        	    end if
        	    rsget.Close
            end If        
		ElseIf  (NOT isIOSreviewSkip) and (Now() >= #06/19/2015 10:00:00# And Now() < #06/29/2015 00:00:00#) Then '//심심타파
            sqlStr = "select top 1 deviceid from db_contents.dbo.tbl_app_regInfo"
            sqlStr = sqlStr & "	where (regdate>='2015-06-19' and regdate<'2015-06-29'"              ''시작 날짜 조절할것.
            sqlStr = sqlStr & "	and deviceid='"&sDeviceId&"')"
            sqlStr = sqlStr & " or (deviceid='"&sDeviceId&"' and userid in ('icommang','tozzinet','baboytw','winnie','gawisonten10','greenteenz','edojun','motions','thensi7','tlswjd0428','bjh2546','eugene20','bborami','stella0117','djjung','areum531','cogusdk','kyungae13','jinyeonmi'))"  ''TEST

            rsget.Open sqlStr,dbget,1
            if Not(rsget.EOF or rsget.BOF) then
    			oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_63739_Banner.asp")
    			oJson("maineventtype") = "full"
    		else
    		    inotval = true
    	    end if
    	    rsget.Close

            if (inotval) then
                sqlStr = "select top 1 * from db_contents.dbo.tbl_app_uuidInfo"
                sqlStr = sqlStr & "	where (regdate>='2015-06-19' and regdate<'2015-06-29')"              ''시작 날짜 조절할것.
                sqlStr = sqlStr & "	and  uuid='"&sUUID&"'"

                rsget.Open sqlStr,dbget,1
                if Not(rsget.EOF or rsget.BOF) then
        			oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_63739_Banner.asp")
        			oJson("maineventtype") = "full"
        		else
        	        oJson("maineventurl") = ""
        		    oJson("maineventtype") = ""
        	    end if
        	    rsget.Close
            end If
		ElseIf  (NOT isIOSreviewSkip) and (Now() >= #06/29/2015 10:00:00# And Now() < #07/11/2015 00:00:00#) Then '//초능력자들
			If Left(Now(),10)="2015-07-04" Or Left(Now(),10)="2015-07-05" Then		''주말엔 배너 안띄움
				oJson("maineventurl") = ""
				oJson("maineventtype") = ""
			Else
	            sqlStr = "select top 1 deviceid from db_contents.dbo.tbl_app_regInfo"
	            sqlStr = sqlStr & "	where (regdate>='2015-06-29' and regdate<'2015-07-11'"              ''시작 날짜 조절할것.
	            sqlStr = sqlStr & "	and deviceid='"&sDeviceId&"')"
	            sqlStr = sqlStr & " or (deviceid='"&sDeviceId&"' and userid in ('icommang','tozzinet','baboytw','winnie','gawisonten10','greenteenz','edojun','motions','thensi7','tlswjd0428','bjh2546','eugene20','bborami','stella0117','djjung','areum531','cogusdk','kyungae13','jinyeonmi'))"  ''TEST
	
	            rsget.Open sqlStr,dbget,1
	            if Not(rsget.EOF or rsget.BOF) then
	    			oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_64071_Banner.asp")
	    			oJson("maineventtype") = "full"
	    		else
	    		    inotval = true
	    	    end if
	    	    rsget.Close
	
	            if (inotval) then
	                sqlStr = "select top 1 * from db_contents.dbo.tbl_app_uuidInfo"
	                sqlStr = sqlStr & "	where (regdate>='2015-06-29' and regdate<'2015-07-11')"              ''시작 날짜 조절할것.
	                sqlStr = sqlStr & "	and  uuid='"&sUUID&"'"
	
	                rsget.Open sqlStr,dbget,1
	                if Not(rsget.EOF or rsget.BOF) then
	        			oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_64071_Banner.asp")
	        			oJson("maineventtype") = "full"
	        		else
	        	        oJson("maineventurl") = ""
	        		    oJson("maineventtype") = ""
	        	    end if
	        	    rsget.Close
	            end If
	        end If
	    ElseIf  (NOT isIOSreviewSkip) and ((Now() >= #07/13/2015 10:00:00# And Now() < #07/18/2015 00:00:00#) or (Now() >= #07/20/2015 10:00:00# And Now() < #07/23/2015 00:00:00#)) Then '//최저가왕
			sqlStr = "select top 1 deviceid from db_contents.dbo.tbl_app_regInfo"
			sqlStr = sqlStr & "	where (regdate>='2015-07-13' and regdate<'2015-07-23'"              ''시작 날짜 조절할것.
			sqlStr = sqlStr & "	and deviceid='"&sDeviceId&"')"
			sqlStr = sqlStr & " or (deviceid='"&sDeviceId&"' and userid in ('fun','icommang','tozzinet','baboytw','winnie','gawisonten10','greenteenz','edojun','motions','thensi7','tlswjd0428','bjh2546','eugene20','bborami','stella0117','djjung','areum531','cogusdk','kyungae13','jinyeonmi'))"  ''TEST

			rsget.Open sqlStr,dbget,1
			if Not(rsget.EOF or rsget.BOF) then
				oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_64636_Banner.asp")
				oJson("maineventtype") = "full"
			else
				inotval = true
			end if
			rsget.Close

			if (inotval) then
				sqlStr = "select top 1 * from db_contents.dbo.tbl_app_uuidInfo"
				sqlStr = sqlStr & "	where (regdate>='2015-07-13' and regdate<'2015-07-23')"              ''시작 날짜 조절할것.
				sqlStr = sqlStr & "	and  uuid='"&sUUID&"'"

				rsget.Open sqlStr,dbget,1
				if Not(rsget.EOF or rsget.BOF) then
					oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_64636_Banner.asp")
					oJson("maineventtype") = "full"
				else
					oJson("maineventurl") = ""
					oJson("maineventtype") = ""
				end if
				rsget.Close
			end If
		ElseIf  (NOT isIOSreviewSkip) and (Now() >= #07/27/2015 10:00:00# And Now() < #08/08/2015 00:00:00#) Then '//초능력자들
			If Left(Now(),10)="2015-08-01" Or Left(Now(),10)="2015-08-02" Then		''주말엔 배너 안띄움
				oJson("maineventurl") = ""
				oJson("maineventtype") = ""
			Else
	            sqlStr = "select top 1 deviceid from db_contents.dbo.tbl_app_regInfo"
	            sqlStr = sqlStr & "	where (regdate>='2015-07-27' and regdate<'2015-08-08'"              ''시작 날짜 조절할것.
	            sqlStr = sqlStr & "	and deviceid='"&sDeviceId&"')"
	            sqlStr = sqlStr & " or (deviceid='"&sDeviceId&"' and userid in ('icommang','tozzinet','baboytw','winnie','gawisonten10','greenteenz','edojun','motions','thensi7','tlswjd0428','bjh2546','eugene20','bborami','stella0117','djjung','areum531','cogusdk','kyungae13','jinyeonmi'))"  ''TEST
	
	            rsget.Open sqlStr,dbget,1
	            if Not(rsget.EOF or rsget.BOF) then
	    			oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_65010_Banner.asp")
	    			oJson("maineventtype") = "full"
	    		else
	    		    inotval = true
	    	    end if
	    	    rsget.Close
	
	            if (inotval) then
	                sqlStr = "select top 1 * from db_contents.dbo.tbl_app_uuidInfo"
	                sqlStr = sqlStr & "	where (regdate>='2015-07-27' and regdate<'2015-08-08')"              ''시작 날짜 조절할것.
	                sqlStr = sqlStr & "	and  uuid='"&sUUID&"'"
	
	                rsget.Open sqlStr,dbget,1
	                if Not(rsget.EOF or rsget.BOF) then
	        			oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_65010_Banner.asp")
	        			oJson("maineventtype") = "full"
	        		else
	        	        oJson("maineventurl") = ""
	        		    oJson("maineventtype") = ""
	        	    end if
	        	    rsget.Close
	            end If
	        end If
		ElseIf  (NOT isIOSreviewSkip) and (Now() >= #08/10/2015 10:00:00# And Now() < #08/15/2015 00:00:00#) Then '//현상금을 노려라
			sqlStr = "select top 1 deviceid from db_contents.dbo.tbl_app_regInfo"
			sqlStr = sqlStr & "	where (regdate>='2015-08-03' and regdate<'2015-08-15'"              ''시작 날짜 조절할것.
			sqlStr = sqlStr & "	and deviceid='"&sDeviceId&"')"
			sqlStr = sqlStr & " or (deviceid='"&sDeviceId&"' and userid in ('icommang','tozzinet','baboytw','winnie','gawisonten10','greenteenz','edojun','motions','thensi7','tlswjd0428','bjh2546','eugene20','bborami','stella0117','djjung','areum531','cogusdk','kyungae13','jinyeonmi'))"  ''TEST

			rsget.Open sqlStr,dbget,1
			if Not(rsget.EOF or rsget.BOF) then
				oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_65229_Banner.asp")
				oJson("maineventtype") = "full"
			else
				inotval = true
			end if
			rsget.Close

			if (inotval) then
				sqlStr = "select top 1 * from db_contents.dbo.tbl_app_uuidInfo"
				sqlStr = sqlStr & "	where (regdate>='2015-08-03' and regdate<'2015-08-15')"              ''시작 날짜 조절할것.
				sqlStr = sqlStr & "	and  uuid='"&sUUID&"'"

				rsget.Open sqlStr,dbget,1
				if Not(rsget.EOF or rsget.BOF) then
					oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_65229_Banner.asp")
					oJson("maineventtype") = "full"
				else
					oJson("maineventurl") = ""
					oJson("maineventtype") = ""
				end if
				rsget.Close
			end If

		ElseIf  (NOT isIOSreviewSkip) and (Now() >= #08/17/2015 10:00:00# And Now() < #08/28/2015 00:00:00#) Then '//비밀의방
			sqlStr = "select top 1 deviceid from db_contents.dbo.tbl_app_regInfo"
			sqlStr = sqlStr & "	where (regdate>='2015-08-17' and regdate<'2015-08-28'"              ''시작 날짜 조절할것.
			sqlStr = sqlStr & "	and deviceid='"&sDeviceId&"')"
			sqlStr = sqlStr & " or (deviceid='"&sDeviceId&"' and userid in ('fun','icommang','tozzinet','baboytw','winnie','gawisonten10','greenteenz','edojun','motions','thensi7','tlswjd0428','bjh2546','eugene20','bborami','stella0117','djjung','areum531','cogusdk','kyungae13','jinyeonmi'))"  ''TEST

			rsget.Open sqlStr,dbget,1
			if Not(rsget.EOF or rsget.BOF) then
				oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_65477_Banner.asp")
				oJson("maineventtype") = "full"
			else
				inotval = true
			end if
			rsget.Close

			if (inotval) then
				sqlStr = "select top 1 * from db_contents.dbo.tbl_app_uuidInfo"
				sqlStr = sqlStr & "	where (regdate>='2015-08-17' and regdate<'2015-08-28')"              ''시작 날짜 조절할것.
				sqlStr = sqlStr & "	and  uuid='"&sUUID&"'"

				rsget.Open sqlStr,dbget,1
				if Not(rsget.EOF or rsget.BOF) then
					oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_65477_Banner.asp")
					oJson("maineventtype") = "full"
				else
					oJson("maineventurl") = ""
					oJson("maineventtype") = ""
				end if
				rsget.Close
			end If

		ElseIf  (NOT isIOSreviewSkip) and (Now() >= #09/02/2015 10:00:00# And Now() < #09/03/2015 00:00:00#) Then '//동숭동 제목학원
			sqlStr = "select top 1 deviceid from db_contents.dbo.tbl_app_regInfo"
			sqlStr = sqlStr & "	where (regdate>='2015-09-02' and regdate<'2015-09-12'"              ''시작 날짜 조절할것.
			sqlStr = sqlStr & "	and deviceid='"&sDeviceId&"')"
			sqlStr = sqlStr & " or (deviceid='"&sDeviceId&"' and userid in ('fun','icommang','tozzinet','baboytw','winnie','gawisonten10','greenteenz','edojun','motions','thensi7','tlswjd0428','bjh2546','eugene20','bborami','stella0117','djjung','areum531','cogusdk','kyungae13','jinyeonmi'))"  ''TEST

			rsget.Open sqlStr,dbget,1
			if Not(rsget.EOF or rsget.BOF) then
				oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_65841_Banner.asp")
				oJson("maineventtype") = "full"
			else
				inotval = true
			end if
			rsget.Close

			if (inotval) then
				sqlStr = "select top 1 * from db_contents.dbo.tbl_app_uuidInfo"
				sqlStr = sqlStr & "	where (regdate>='2015-09-02' and regdate<'2015-09-12')"              ''시작 날짜 조절할것.
				sqlStr = sqlStr & "	and  uuid='"&sUUID&"'"

				rsget.Open sqlStr,dbget,1
				if Not(rsget.EOF or rsget.BOF) then
					oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_65841_Banner.asp")
					oJson("maineventtype") = "full"
				else
					oJson("maineventurl") = ""
					oJson("maineventtype") = ""
				end if
				rsget.Close
			end If

		ElseIf  (NOT isIOSreviewSkip) and (Now() >= #09/03/2015 10:00:00# And Now() < #09/12/2015 00:00:00#) Then '//동숭동 제목학원
			If TimeSerial(Hour(Now()), minute(Now()), second(Now())) >= TimeSerial(10, 00, 00) And TimeSerial(Hour(Now()), minute(Now()), second(Now())) < TimeSerial(23, 59, 59) Then
				sqlStr = "select top 1 deviceid from db_contents.dbo.tbl_app_regInfo"
				sqlStr = sqlStr & "	where (regdate>='2015-09-02' and regdate<'2015-09-12'"              ''시작 날짜 조절할것.
				sqlStr = sqlStr & "	and deviceid='"&sDeviceId&"')"
				sqlStr = sqlStr & " or (deviceid='"&sDeviceId&"' and userid in ('fun','icommang','tozzinet','baboytw','winnie','gawisonten10','greenteenz','edojun','motions','thensi7','tlswjd0428','bjh2546','eugene20','bborami','stella0117','djjung','areum531','cogusdk','kyungae13','jinyeonmi'))"  ''TEST

				rsget.Open sqlStr,dbget,1
				if Not(rsget.EOF or rsget.BOF) then
					oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_65841_Banner.asp")
					oJson("maineventtype") = "full"
				else
					inotval = true
				end if
				rsget.Close

				if (inotval) then
					sqlStr = "select top 1 * from db_contents.dbo.tbl_app_uuidInfo"
					sqlStr = sqlStr & "	where (regdate>='2015-09-02' and regdate<'2015-09-12')"              ''시작 날짜 조절할것.
					sqlStr = sqlStr & "	and  uuid='"&sUUID&"'"

					rsget.Open sqlStr,dbget,1
					if Not(rsget.EOF or rsget.BOF) then
						oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_65841_Banner.asp")
						oJson("maineventtype") = "full"
					else
						oJson("maineventurl") = ""
						oJson("maineventtype") = ""
					end if
					rsget.Close
				end If
			End If
		ElseIf  (NOT isIOSreviewSkip) and (Now() >= #09/14/2015 10:00:00# And Now() < #09/23/2015 00:00:00#) Then '//봉투맨
			If Left(Now(),10)="2015-09-19" Or Left(Now(),10)="2015-09-20" Then		''주말엔 배너 안띄움
				oJson("maineventurl") = ""
				oJson("maineventtype") = ""
			Else
	            sqlStr = "select top 1 deviceid from db_contents.dbo.tbl_app_regInfo"
	            sqlStr = sqlStr & "	where (regdate>='2015-09-14' and regdate<'2015-09-23'"              ''시작 날짜 조절할것.
	            sqlStr = sqlStr & "	and deviceid='"&sDeviceId&"')"
	            sqlStr = sqlStr & " or (deviceid='"&sDeviceId&"' and userid in ('icommang','tozzinet','baboytw','winnie','gawisonten10','greenteenz','edojun','motions','thensi7','tlswjd0428','bjh2546','eugene20','bborami','stella0117','djjung','areum531','cogusdk','kyungae13','jinyeonmi'))"  ''TEST
	
	            rsget.Open sqlStr,dbget,1
	            if Not(rsget.EOF or rsget.BOF) then
	    			oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_66085_Banner.asp")
	    			oJson("maineventtype") = "full"
	    		else
	    		    inotval = true
	    	    end if
	    	    rsget.Close
	
	            if (inotval) then
	                sqlStr = "select top 1 * from db_contents.dbo.tbl_app_uuidInfo"
	                sqlStr = sqlStr & "	where (regdate>='2015-09-14' and regdate<'2015-09-23')"              ''시작 날짜 조절할것.
	                sqlStr = sqlStr & "	and  uuid='"&sUUID&"'"
	
	                rsget.Open sqlStr,dbget,1
	                if Not(rsget.EOF or rsget.BOF) then
	        			oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_66085_Banner.asp")
	        			oJson("maineventtype") = "full"
	        		else
	        	        oJson("maineventurl") = ""
	        		    oJson("maineventtype") = ""
	        	    end if
	        	    rsget.Close
	            end If
	        end If
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

		ElseIf  (NOT isIOSreviewSkip) and (Now() >= #10/10/2015 10:00:00# And Now() < #10/27/2015 00:00:00#) Then '14주년 오픈 배너 IOS 구버전 모든 앱 설치자 필수 
			oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/14th_banner.asp")
			oJson("maineventtype") = "full"

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
		ElseIf  (NOT isIOSreviewSkip) and (Now() >= #12/09/2015 10:00:00# And Now() < #12/19/2015 00:00:00#) Then '//돌아온 크리스박스
			If Left(Now(),10)="2015-12-12" Or Left(Now(),10)="2015-12-13" Or Left(Now(),10)="2015-12-14" Or Left(Now(),10)="2015-12-15" Then		''배너 안띄우는 날
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
			end if

		ElseIf (sDeviceId="910840a2c6bf500434574b2cbd8f8a51d0f5ba65ab6903d98dd7888a3186018e") or (sDeviceId="15f9beb7b374dc1761d4def91872acc35e836a8d8e263ed556bdaa2a4cc9d088") then
	        oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_64071_Banner.asp")
	    	oJson("maineventtype") = "full"
        else
            oJson("maineventurl") = ""
    	    oJson("maineventtype") = ""
    	end if

		dim currenttime
		currenttime = now()
		'currenttime = #03/16/2015 10:05:00#

'		'//슈퍼백의 기적	'//2015.03.12 한용민 추가
'		if (left(currenttime,10)>="2015-03-16" and left(currenttime,10)<"2015-03-21") or (left(currenttime,10)>="2015-03-23" and left(currenttime,10)<"2015-03-26") then
'			'if Hour(currenttime) >= 10 then
'				oJson("maineventurl") = b64encode(strAppWVUrl & "/event/banner/evt_59795_Banner.asp")
'				oJson("maineventtype") = "full"
'			'else
'			'	oJson("maineventurl") = ""
'			'	oJson("maineventtype") = ""
'			'end if
'		else
'            oJson("maineventurl") = ""
'    	    oJson("maineventtype") = ""
'		end if

		'// 추후 업데이트시 이동될 AppID
		oJson("appid") = sAppId

        '//ProtoV2 추가--------------------------------------------------
        'if (sAppKey="5") and (sVerCd="1.6") and ((sDeviceId="0eaaeeccc086c1bb39ff828cab6bb1237e483344d95c11c9121c1bd890776b71") or (sDeviceId="d9a8afbfec9d9c32a1c031ac4ac6156b9cc049118ab2a42fc0c629284d657558")) then
        '    Set oJson("topmenu") = getTopMenuJSon_iOS_TEST
        'else
        '    Set oJson("topmenu") = getTopMenuJSon
        'end if

		'//ProtoV2 리뉴얼판--------------------------------------------------
'        if ((sDeviceId="APA91bGG7e6vU1VipUCRahb49DMUx2ttAsnRkD8X8mCiaLFw1Ifh0Jsv2qGMJaHo3Q9CqxWgOKUH6ZCm4ml6EwvIStdG5NYPsPj4U1LOhdJc9JvTLybNAZj7PmrV0DFPpFU50hDC2pNyI-krVksiCvgYoqlm4t6q2g") or (sDeviceId="cb20627f2c8be376bda659863e6c0fab5c073e979e672955cd6de81d0797e796") or (sDeviceId="96707d7442900d1338345fa5ede40daf2fe19dafba27bb8a2dea7837760e43dc") or (sDeviceId="6d7128f931fd8670c4a759a845105834487c44ebe51d743551554fe216ff5160") or (sDeviceId="7679e1d17fe8ffdbadda092bc932b1bd46c4b14dc2d425d2c7e0c0bd5e482f9d") or (sDeviceId="a195d4281df7b3f0b6ac79e821d4c858d3f88e53abd35a14924463ead0948164") or (sDeviceId="APA91bHXg943AqvSwAL8iOEtJHbs-wgpViKnwq2sbfsH-8DVBi9boOwhUibGrqpYYDWarqwWBfrSMVGWjC1FQMTLq-aV7WvE4cVUWMcIRTsjv5draKOvQWqSAXHM6Gjj7hf9dEyZsnf-") or (sDeviceId="APA91bGHER0aPFWYUTjSL5T6icP6lLJRDm26uN_RHNscNtz9sO3j_eQ4gPgTv2J7odBETVL8yuiDQ5gvgK8h_Dwi9kLQWmeUo1oXKEc1mjue-NKHSYAZuZPCexjbd8hljKwgabU32ujX9FAL4KA2RNvWXNshAERWoQ")) then
'            Set oJson("topmenu") = getTopMenuJSon_2015
'        else
            Set oJson("topmenu") = getTopMenuJSon_2015
 '       end if

        ''2015/08/20 추가 넛지 inApp관련 파람
        oJson("ngmmt") = "1,3,4" '' 1,3,4
        
	end if

end if

if ERR then Call OnErrNoti()
On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
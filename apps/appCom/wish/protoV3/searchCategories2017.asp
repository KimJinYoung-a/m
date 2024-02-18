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
<!-- #include virtual="/lib/classes/search/searchcls_useDB.asp" -->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/protoV3/searchCategories.asp
' Discription : 카테고리 검색 API
' Request : json > keyword
' Response : response > 결과, categoryid, name
' History : 2017.08.16 강준구 : 신규 생성
'###############################################

'//헤더 출력
Response.ContentType = "application/json"

Dim sFDesc
Dim sKeyword, sOS, snID, sDeviceId, sAppKey, sVerCd
Dim sCateCd, sCateNm
Dim sData : sData = Request.form("json")
Dim oJson


'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	sKeyword = requestCheckVar(oResult.keyword,512)

    if Not ERR THEN
    	'Optional Parameter
		sDeviceId = requestCheckVar(oResult.pushid,256)
		sVerCd = requestCheckVar(oResult.versioncode,20)
		sOS = requestCheckVar(oResult.OS,10)

		'DeviceID 정보 업데이트
		sAppKey = getWishAppKey(sOS)
	    if ERR THEN Err.Clear ''회원id 프로토콜 없음
    END IF
set oResult = Nothing


'// json객체 선언
Set oJson = jsObject()

if sKeyword="" then
	'// 필수 파라메터 없음
	oJson("response") = "fail1"
	oJson("faildesc") = "검색어가 입력되지 않았습니다.[E01]"

else
	dim sqlStr, addSql, chkMode

	'###############################################################################################
	dim Docruzer, vErrMSG
	'독크루저 컨퍼넌트 선언
	SET Docruzer = Server.CreateObject("ATLKSearch.Client")
	
	if Docruzer.BeginSession()<0 then
		'에러시 메세지 표시
		chkMode = "errConn1"
		vErrMSG = "BeginSession: " & Docruzer.GetErrorMessage()
	else
	    IF NOT DocSetOption(Docruzer) THEN
			chkMode = "errConn2"
			vErrMSG = "SetOption: " & Docruzer.GetErrorMessage()
		ELSE
	    	'실행
			Dim SvrAddr, SvrPort, ret, i, nFlag, cnv_str, max_count, kwd_count, kwd_list, rank, meta1, meta2
			Dim vDisp, vDispFullname

			IF application("Svr_Info")	= "Dev" THEN
			    ''SvrAddr = "110.93.128.108"''2차실서버
				SvrAddr = "192.168.50.10"'DocSvrAddr(테섭)
				'SvrAddr = "110.93.128.106"
			ELSE
				''SvrAddr = "192.168.0.109"'DocSvrAddr(실섭)
				SvrAddr = "192.168.0.206"
				'SvrAddr = "110.93.128.106"
			END IF

			if (Application("G_ORGSCH_ADDR")="") then
				Application("G_ORGSCH_ADDR")=SvrAddr
			end if

			SvrAddr = Application("G_ORGSCH_ADDR")
			
			SvrPort = "6167"			'DocSvrPort

			nFlag = 2		'검색방법 (0:앞부터, 1: 뒤부터, 2:앞or뒤)
			cnv_str = ""	'한영자동변환 결과
			max_count = 200	'최대 검색 수

			'자동완성 검색
			ret = Docruzer.CompleteKeyword2( _
						SvrAddr & ":" & SvrPort _
						,kwd_count, kwd_list, rank, meta1, meta2, cnv_str, max_count, sKeyword, nFlag, 6)
				
			'에러 출력
			if(ret<0) then
				chkMode = "errConn3"
				vErrMSG = "Error: " & Docruzer.GetErrorMessage()
			else
				dim oList, oCateItem
				set oList = jsArray()
		
				'-----프로세스 시작
				for i=0 to kwd_count-1
					Set oCateItem = jsObject()
					
					vDisp			= meta1(i)
					vDispFullname	= fnFullNameDisplay(meta2(i),sKeyword)
					vDispFullname = Replace(vDispFullname, "<b>", "")
					vDispFullname = Replace(vDispFullname, "</b>", "")
					vDispFullname = Replace(vDispFullname, "&gt;", ">")

					oCateItem("categoryid") = cStr(vDisp)
					oCateItem("name") = cStr(vDispFullname)

					set oList(null) = oCateItem
					Set oCateItem = Nothing
			
				next
				
				chkMode = "procOK"
				
	    		Call Docruzer.EndSession()
			end if

    	End if
	end if
	
	'독크루저 종료
	Set Docruzer = Nothing
	
    public function DocSetOption(iDocruzer)
        dim ret 
        ret = iDocruzer.SetOption(iDocruzer.OPTION_REQUEST_CHARSET_UTF8,1)
        DocSetOption = (ret>=0)
    end function

	'###############################################################################################

	'// 결과데이터 생성
	Select Case chkMode
		Case "procOK"
			'// 이미 연동 되어있는 경우 성공시 (요청 type: login)
			oJson("response") = getErrMsg("1000",sFDesc)
			set oJson("categories") = oList

		Case "errConn1"
			'// 데이터 없음(오류)
			oJson("response") = "fail2"
			oJson("faildesc") = "검색을 하는데 오류가 발생했습니다.[E02]"
		Case "errConn2"
			'// 데이터 없음(오류)
			oJson("response") = "fail3"
			oJson("faildesc") = "검색을 하는데 오류가 발생했습니다.[E03]"
		Case "errConn3"
			'// 데이터 없음(오류)
			oJson("response") = "fail4"
			oJson("faildesc") = "검색을 하는데 오류가 발생했습니다.[E04]"
	End Select
end if

IF (Err) then
	Set oJson = jsObject()
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."
End if

if ERR then Call OnErrNoti()		'// 오류 이메일로 발송
On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
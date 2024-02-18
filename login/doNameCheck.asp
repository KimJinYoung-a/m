<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% 'Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'response.Charset="euc-kr"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/realname/nice.nuguya.oivs.asp"-->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/header.asp" -->
<%
'==============================================================================
'외부 URL 체크
dim backurl
backurl = request.ServerVariables("HTTP_REFERER")
if InStr(LCase(backurl),"10x10.co.kr") < 1 then
	'Call Alert_Return("잘못된 접속 경로입니다.")
	'response.end
end if
'==============================================================================
'로그인 상태 체크
if Not(IsUserLoginOK) then
	Call Alert_Return("로그인이 필요합니다.")
	response.end
end if

'실명확인 상태 체크
if GetLoginRealNameCheck="Y" then
	Call Alert_Return("이미 실명확인을 하셨습니다.")
	response.end
end if
'==============================================================================
dim uip, chkYn, strMsg
dim username, socno1, socno2, birthDt
Const CCurrentSite = "10x10"
Const COtherSite   = "academy"

uip = Left(request.ServerVariables("REMOTE_ADDR"),32)

'==============================================================================
'배치확인 검사
if Not(getCheckBatchUser(uip)) then
	Call Alert_Return("같은 아이피로 단시간 내에 연속으로 여러번 접속하였습니다.\n잠시 후 다시 시도해주세요.")
	response.end
end if

	'	//#######################################################################################
	'	//#####
	'	//#####	개인/외국인 실명확인 서비스 소스 (실명확인요청)				한국신용정보(주)
	'	//#####	( JScript 처리 )
	'	//#####
	'	//#######################################################################################
	
	'	//=======================================================================================
	'	//=====	MAIN PROCESS
	'	//=======================================================================================
	
		dim strNiceId, strSuccUrl, strFailUrl, strReturnUrl
	

	'	/****************************************************************************************
	'	 *****	▣  NiceCheck.htm 에서 넘겨 받은 SendInfo 값을 복호화 하여 
	'	 *****		주민번호,성명 등 각각의 값을 세팅한다 ▣
	'	 ****************************************************************************************/
		oivsObject.clientData = Request.Form( "SendInfo" )
		oivsObject.desClientData()
	
		'// 복호화 된 값은 아래 주석을 풀어 확인 가능합니다. 기존 회원 체크는 이 부분에서 하시면 됩니다.
	'	response.write("<BR>성명 : "  & oivsObject.userNm)
	'	response.write("<BR>주민번호/외국인번호 : "  & oivsObject.resIdNo)
	'	response.write("<BR>조회사유코드 : "  & oivsObject.inqRsn)
	'	response.write("<BR>내/외국인 구분코드 : "  & oivsObject.foreigner)
	'	response.end


	'	/****************************************************************************************
	'	 *****	▣ 회원사 ID 설정 : 계약시에 발급된 회원사 ID를 설정하십시오. ▣
	'	 ****************************************************************************************/
		Select Case oivsObject.foreigner
			Case 1
				strNiceId = "Ntenxten2"		'내국인 확인
			Case 2
				strNiceId = "Ntenxten3"		'외국인 확인
			Case Else
				Call Alert_Return("내/외국인 구분값이 없습니다."):response.end
		end Select


	'	/****************************************************************************************
	'	 *****	▣ 실명확인 서비스를 호출한다. ▣
	'	 ****************************************************************************************/
		oivsObject.niceId = strNiceId
		oivsObject.callService()
	
		 
	'	//==================================================================================================================
	'	//				응답에 대한 결과 및 변수들에 대한 설명
	'	//------------------------------------------------------------------------------------------------------------------
	'	//
	'	//	< 한국신용정보 온라인 식별 서비스에서 제공하는 정보 >
	'	//
	'	//	oivsObject.message			: 오류 또는 정보성 메시지
	'	//	oivsObject.retCd			: 결과 코드(메뉴얼 참고)// cf. 한국신용정보 성명 등록 및 정정 페이지 : https://www.nuguya.com
	'	//	oivsObject.retDtlCd			: 결과 상세 코드(메뉴얼 참고)
	'	//	oivsObject.minor 			: 성인인증 결과 코드
	'	//									"1"	: 성인
	'	//									"2"	: 미성년
	'	//									"9"	: 확인 불가
	'	//	oivsObject.dupeInfo         : 중복가입확인정보 (iPin서비스를 신청해야 넘어옴.. : 차후 사용.)
	'	//
	'	//=================================================================================================================
	
	'*******************************************
	'* 텐바이텐 처리 부분
	'*******************************************
	
	'결과값에 대한 처리
	Select Case oivsObject.retCd
		Case "1"		'정상 확인
			chkYn = "Y"
			strMsg = "실명 확인"
		Case "2"		'확인 실패
			chkYn = "N"
			strMsg = getRealNameErrMsg(oivsObject.retDtlCd)
		Case Else		'정보 없음
			chkYn = "N"
			strMsg = getRealNameErrMsg(oivsObject.retDtlCd)
	End Select

	'전송 정보 변수 할당
	username = oivsObject.userNm
	socno1   = left(trim(oivsObject.resIdNo),6)
	socno2   = right(trim(oivsObject.resIdNo),7)
	
	'로그저장
	Call saveCheckLog("RN",oivsObject.userNm,socno1,MD5(CStr(socno2)),uip,chkYn,oivsObject.retCd,oivsObject.retDtlCd,strMsg,GetLoginUserID)
	
	'실패면 안내후 페이지 종료!
	if chkYn="N" then
		Call Alert_Return(strMsg)
		response.end
	end if

'==============================================================================



dim juminno, jumin1, sexflag, Enc_jumin2

juminno = CStr(socno1) + "-" + CStr(socno2)
jumin1  = CStr(socno1)
sexflag = Left(socno2, 1)
Enc_jumin2 = MD5(CStr(socno2))

'==============================================================================

'// 가입정보 비교/확인
dim sqlStr, cnt
sqlStr = " select count(userid) "
sqlStr = sqlStr + " from [db_user].[dbo].tbl_user_n "
sqlStr = sqlStr + " where ((jumin1='" + jumin1 + "') and (Enc_jumin2='" + Enc_jumin2 + "')) "
sqlStr = sqlStr + "		and username='" + username + "' "
sqlStr = sqlStr + "		and userid='" + GetLoginUserID + "' "

rsget.Open sqlStr,dbget,1
cnt = 0
if Not(rsget.EOF or rsget.BOF) then
	cnt = rsget(0)
end if
rsget.close

if (cnt > 0) then
	'#################### 실명확인 처리 ####################
	sqlStr = "Update db_user.dbo.tbl_user_n "
	sqlStr = sqlStr & " Set realnamecheck='Y' "
	sqlStr = sqlStr & " Where userid='" & GetLoginUserID & "'"
	dbget.Execute(sqlStr)

	'쿠키/세션 정보 수정
	response.cookies("uinfo").domain = "10x10.co.kr"
	response.cookies("uinfo")("realnamecheck") = "Y"
	session("realnamecheck") = "Y"
	
	'Response.Write "<script langauge=javascript>alert('실명이 확인되었습니다.');</script>"
	Call Alert_Move("실명이 확인되었습니다.",Request.Form("backUrl"))
	Response.End
else
	Call Alert_Return("입력하신 내용이 회원정보와 일치하지 않습니다.\n\n텐바이텐 정보수정 메뉴에서 회원 정보를 확인하신 후 다시 시도해주세요.")
	Response.End
end if


'//최근 IP에서 접근한적이 있는가? - 최근 1분내 3번까지 실명확인허용(배치 검사 제외)
function getCheckBatchUser(uip)
	dim strSql
	strSql = "Select count(chkIdx) " &_
			" From db_log.dbo.tbl_user_checkLog " &_
			" where chkIP='" & uip & "'" &_
			"	and datediff(n,chkDate,getdate())<=1 "
	rsget.Open strSql, dbget, 1
	if rsget(0)>3 then
		getCheckBatchUser = false
	else
		getCheckBatchUser = true
	end if
	rsget.Close
end function

'//확인 로그를 남긴다
Sub saveCheckLog(cDv,unm,jm1,jm2e,uip,uYn,rcd,dcd,rmsg,uid)
	'구분(chkDiv) : RN : 실명확인, CP : 본인확인
	dim strSql
	strSql = "Insert into db_log.dbo.tbl_user_checkLog "
	strSql = strSql & " (chkDiv,chkName,jumin1,jumin2_Enc,chkIP,chkYN,rstCD,rstDtCd,rstMsg,userid) values "
	strSql = strSql & "('" & cDv & "'"
	strSql = strSql & ",'" & unm & "'"
	strSql = strSql & ",'" & jm1 & "'"
	strSql = strSql & ",''"
	strSql = strSql & ",'" & uip & "'"
	strSql = strSql & ",'" & uYn & "'"
	strSql = strSql & ",'" & rcd & "'"
	strSql = strSql & ",'" & dcd & "'"
	strSql = strSql & ",'" & rmsg & "'"
	if uid="" then
		strSql = strSql & ",null)"
	else
		strSql = strSql & ",'" & uid & "')"
	end if
	dbget.Execute(strSql)
end Sub
%>
<!-- #INCLUDE Virtual="/lib/footer.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->
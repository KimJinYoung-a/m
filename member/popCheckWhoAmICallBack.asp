<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/email/maillib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/tenEncUtil.asp" -->
<!-- #include virtual="/lib/util/tenSessionLib.asp" -->
<%
    Response.CacheControl = "no-cache"
    Response.AddHeader "Pragma","no-cache"
    Response.Expires = 0
    Response.Buffer = True
	Response.write "<script type='text/javascript' src='/apps/appCom/wish/web2014/lib/js/customapp.js?v=2.30'></script>"
%>
<%
    ' rec_cert 데이터 변수 선언 ---------------------------------------------------------------
    Dim rec_cert         ' 결과수신DATA
	Dim certNum          ' 요청번호
    Dim date             ' 요청일시
	Dim CI               ' 연계정보(CI)
	Dim DI               ' 중복가입확인정보(DI)
    Dim phoneNo			 ' 휴대폰번호
	Dim phoneCorp		 ' 이동통신사
	Dim birthDay		 ' 생년월일
	Dim gender			 ' 성별
	Dim nation			 ' 내국인
	Dim name			 ' 성명
	Dim M_name			 ' 미성년자 성명
	Dim M_birthDay		 ' 미성년자 생년월일
	Dim M_Gender		 ' 미성년자 성별
	Dim M_nation		 ' 미성년자 내외국인
    Dim result           ' 결과값
    Dim certMet          ' 인증방법
    Dim ip               ' ip주소
	Dim plusInfo
    ' End - rec_cert 데이터 변수 선언 -------------------------------------------------------------

	'복호화 변수 선언
    Dim k_certNum
	Dim decStr_Split	' 복호화 데이터 배열
	Dim dec				' 복호화 변수
	Dim hash            ' 위변조 변수
	Dim hashStr
	Dim encPara			' rec_cert 1차 암호화데이터
	Dim encMsg			' 위변조 검증값
	Dim msgChk			' 위변조 검증 결과
	Dim iv				' 복호화 키값

	' Parameter 수신
	rec_cert  = request("rec_cert")
	k_certNum = request("certNum") 
    iv = k_certNum                 ' certNum값을 복호화키에 세팅

	On Error Resume Next

		'01.1차 복호화
		Set dec = Server.CreateObject("ICERTSecurity.SEED")
			If(Err.Number <> 0) Then
				Response.Write "Error 01 :: ("& Err.Number &") " & Err.Description & vbCrlf & "<br><br>"
			End IF

		    rec_cert = dec.IcertSeedDecript(rec_cert, iv)

			If(Err.Number <> 0) Then
				Response.Write "Error 02 :: ("& Err.Number &") " & Err.Description & vbCrlf & "<br><br>"
			End If

		Set dec = Nothing

        '02. 1차 파싱
        decStr_Split   = Split(rec_cert,"/")
		encPara        = decStr_Split(0)	' rec_cert 1차 암호화데이터
		encMsg         = decStr_Split(1)	' 위변조 검증값

        '03. 위변조 검증
		Set hash = Server.CreateObject("ICERTSecurity.AES")
			If(Err.Number <> 0) Then
				Response.Write "Error 03 :: ("& Err.Number &") " & Err.Description & vbCrlf & "<br><br>"
			End IF

		    hashStr = hash.IcertHMacEncript(encPara)

			If(Err.Number <> 0) Then
				Response.Write "Error 04 :: ("& Err.Number &") " & Err.Description & vbCrlf & "<br><br>"
			End If

		Set hash = Nothing

		msgChk = "N"
		If(hashStr = encMsg) Then
			msgChk = "Y"
		End If

		If(msgChk = "N") Then
			Call Alert_Close("비정상적인 접근입니다.!!")
			dbget.close(): response.End
		End If

        '04. 2차 복호화
		Set dec = Server.CreateObject("ICERTSecurity.SEED")
				If(Err.Number <> 0) Then
					Response.Write "Error 05 :: ("& Err.Number &") " & Err.Description & vbCrlf & "<br><br>"
				End IF

				rec_cert = dec.IcertSeedDecript(encPara, iv)

				If(Err.Number <> 0) Then
					Response.Write "Error 06 :: ("& Err.Number &") " & Err.Description & vbCrlf & "<br><br>"
				End If

		Set dec = Nothing

        '05. 2차 파싱
		decStr_Split		= Split(rec_cert,"/")

		certNum		= decStr_Split(0)
		date		= decStr_Split(1)
		CI       	= decStr_Split(2)
		phoneNo		= decStr_Split(3)
		phoneCorp	= decStr_Split(4)
		birthDay	= decStr_Split(5)
		gender		= decStr_Split(6)
		nation		= decStr_Split(7)
		name		= decStr_Split(8)
		result		= decStr_Split(9)
		certMet		= decStr_Split(10)
		ip			= decStr_Split(11)
		M_name		= decStr_Split(12)
		M_birthDay	= decStr_Split(13)
		M_Gender	= decStr_Split(14)
		M_nation	= decStr_Split(15)
		plusInfo	= decStr_Split(16)
		DI      	= decStr_Split(17)

        '06. CI, DI 복호화
		Set dec = Server.CreateObject("ICERTSecurity.SEED")
				If(Err.Number <> 0) Then
					Response.Write "Error 07 :: ("& Err.Number &") " & Err.Description & vbCrlf & "<br><br>"
				End IF

				CI = dec.IcertSeedDecript(CI, iv)
				DI = dec.IcertSeedDecript(DI, iv)

				If(Err.Number <> 0) Then
					Response.Write "Error 08 :: ("& Err.Number &") " & Err.Description & vbCrlf & "<br><br>"
				End If

		Set dec = Nothing
		
		dim dtBirthDay : dtBirthDay = left(birthDay,4) & "-" & mid(birthDay,5,2) & "-" & right(birthDay,2) & " 00:00:00"

	'Response.WRite "-plusInfo : " & plusInfo &"<br>"
	'Response.WRite "-name : " & name &"<br>"
	'Response.WRite "-dtBirthDay : " & dtBirthDay &"<br>"
	'Response.WRite "-CI : " & CI &"<br>"
	'Response.WRite "-DI : " & DI &"<br>"
	'Response.End
	
	session("CI") = CI
	session("dtBirthDay") = dtBirthDay
	if datediff("m", dtBirthDay, getdate())/12 >= 18 then
		session("isAdult") = True
	else
		session("isAdult") = False
	end if
	
	''비로그인 세션은 여기서 결과 반환
	if plusInfo = "" or isnull(plusInfo) then
		ResultScript(session("isAdult"))
	end if

	'#######################################################################
	' 사용자 정보 체크
	'#######################################################################
	Dim usermail, sql

	''조회로그저장.
	sql = "insert into [db_log].[dbo].tbl_user_search_log"
	sql = sql + " (searchname,searchuid,searchuno,refip)"
	sql = sql + " values("
	sql = sql + " '" + LEFT(name,1) + "**'"
	sql = sql + " ,'" + plusInfo + "'"
	sql = sql + " ,'" + DI + "'"
	sql = sql + " ,'" + ip + "'"
	sql = sql + " )"
	dbget.Execute sql
	
	''배치조회막기.(최근 15분동안 검색수; 2009.05.21.허진원)
	dim recentqcount
	recentqcount=0
	sql = "select count(idx) as cnt "
	sql = sql + " from [db_log].[dbo].tbl_user_search_log "
	sql = sql + " where refip='" + ip + "' "
	sql = sql + " and datediff(n,regdate,getdate())<=15"
	

		
	rsget.Open sql, dbget, 1
		recentqcount = rsget("cnt")
	rsget.Close
	
	if (recentqcount>11) then
	    Call Alert_Close("같은 아이피로 단시간 내에 연속으로 여러번 접속하였습니다.\n잠시 후 다시 시도해주세요.")
	    response.end
	end if

	Dim updateResult : updateResult = setCertInfo(plusInfo,dtBirthDay,  Right(birthDay,6), CI, DI)
	If (updateResult = 0) Then
		session("CI") = null
		session("dtBirthDay") = null
		session("isAdult") = null
		Close_msg("로그인 회원 정보와 인증 정보가 일치하지 않습니다.")
	Else
		Call refreshFrontApiToken(plusInfo)
		ResultScript(session("isAdult"))
	End if
	

'---------------------------------------------------------------------



'//  birthday  CI DI 수정
function setCertInfo(userId, dtBirthDay, jumin1, ci, di)
    
		dim sqlStr

		'##########################################################

		sqlStr = " update [db_user].[dbo].[tbl_user_n] " + vbCrlf
		sqlStr = sqlStr + " set [birthday]='"+dtBirthDay+"' " + vbCrlf
		sqlStr = sqlStr + " ,[connInfo]='" + ci + "'" + vbCrlf
		sqlStr = sqlStr + " ,[dupeInfo]='" + di + "'" + vbCrlf
		sqlStr = sqlStr + " ,[jumin1]='" + jumin1 + "'" + vbCrlf
		sqlStr = sqlStr + " ,[realnamecheck]='Y'" + vbCrlf
		
		sqlStr = sqlStr + " where userid='" + userId + "' and replace(usercell,'-','') = '"+phoneNo+"'"
		
		'rsget.Open sqlStr,dbget,1
		Dim affectedRecs
		dbget.Execute sqlStr, affectedRecs
		
		setCertInfo = affectedRecs
    
    '##########################################################
end function

'// FrontApi 통신용 mssn 쿠키 갱신
Sub refreshFrontApiToken(userId)
	Dim ssnlogindt : ssnlogindt = fnDateTimeToLongTime(now())
	response.Cookies("mssn").domain = GetCookieDomainName
    response.Cookies("mssn")("ssndt") = ssnlogindt
    response.cookies("mssn")("shix") = HashTenID(userId)

    Call set_cookie_secure("CHKSESSION", Left(Now(), 10), "/", 24)

	session("ssnuserid")  = LCase(userId)
    session("ssnlogindt") = ssnlogindt
    session("ssnlastcheckdt") = ssnlogindt
	session("ssnrealnamecheck")	= "Y"

	Dim retSsnHash
	retSsnHash = fnDBSessionCreateV2(ChkIif(isApp,"A","M"),1)
	response.cookies("mssn").Expires = Date + 15
	response.Cookies("mssn")("dtauto") = ssnlogindt
	response.Cookies("mssn")("ssnhash") = retSsnHash
	session("ssnhash") = retSsnHash
End Sub

'//  창닫기 //
Sub Close_refresh()
	dim strTemp
	strTemp = 	"<script language='javascript'>opener.location.reload();self.close();</script>"
	Response.Write strTemp
End Sub
Sub Close_msg(msg)
	dim strTemp
	strTemp = 	"<script language='javascript'>alert('"+msg+"');self.close();</script>"
	Response.Write strTemp
End Sub
Sub ResultScript(isAdult)
	if isAdult Then
		If isApp Then
			if session("adultProductId") <> "" then
			   response.write "<script>fnAPPpopupProduct_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid="& session("adultProductId") &"&adultcb=Y')</script>"
			else
			   Response.redirect session("backpath")
			end if
		Else
			Call Close_refresh
		End if
		
	else
		Call Close_msg("죄송합니다. 미성년자는 접근할 수 없는 콘텐츠입니다.")
	end if
	Response.End
End Sub
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
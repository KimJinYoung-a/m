<%@ codepage="65001" language="VBScript" %>
<%
	Option Explicit
	Response.Expires = -1440
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/tenEncUtil.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/member/iPin/nice.nuguya.oivs.asp" -->
<%

	'========================================================================================
	'=====	▣ 회원사 키스트링 설정 : 계약시에 발급된 키스트링(80자리)를 설정하십시오. ▣
	'========================================================================================	
	'//텐바이텐
	oivsObject.AthKeyStr = "ITTl2qgWEX6GL6nEsBTVrpbCooS4eN2Zpr1OPItNopj0xdnuJVSPaSIY06TV6IQExcsamhRVh9Jr1uz2" '//전달받은 키스트링(80자리) 입력

'	/****************************************************************************************
'	 *****	▣  한국신용정보로 부터 넘겨 받은 SendInfo 값을 복호화 한다 ▣
'	 ****************************************************************************************/
	oivsObject.resolveClientData(  Request.Form( "SendInfo" ) )

	'// 해킹방지를 위해 세션에 저장된 값과 비교 .. 
	Dim ssOrderNo
	ssOrderNo = session("niceOrderNo")
	''ssOrderNo = tenDec(request.cookies("niceChk")("niceOrderNo"))
	If  ssOrderNo <> oivsObject.ordNo then
		response.write "<script>alert('세션정보가 존재하지 않습니다.\n페이지를 새로고침 하신 후 다시 시도해주세요.');self.close();</script>"
		dbget.close()
		Response.End
	End If
	''response.cookies("niceChk")("niceOrderNo") = ""
	session("niceOrderNo") = ""

	'==============================================================================
	dim uip, chkYn, strMsg, strTrans
	dim username, socno1, socno2, birthDt, dupeInfo, connInfo
	Const CCurrentSite = "10x10"
	Const COtherSite   = "academy"
	
	uip = Left(request.ServerVariables("REMOTE_ADDR"),32)

	'==============================================================================
	'배치확인 검사
	if Not(getCheckBatchUser(uip)) then
		Response.Write "<script langauge=javascript>" &_
						"alert('같은 아이피로 단시간 내에 연속으로 여러번 접속하였습니다.\n잠시 후 다시 시도해주세요.');" &_
						"opener.document.location.reload(); "&_
						"self.close();" & _
						"</script>"
		dbget.close()
		Response.End
	end if

	'==============================================================================
	'// 넘어온 값들로 중복체크 및 전송

	'결과값에 대한 처리
	if oivsObject.retCd="1" then
		'정상 확인
		chkYn = "Y"
		strMsg = "아이핀 확인"
	Else
		'정보 없음
		chkYn = "N"
		strMsg = getRealNameErrMsg(oivsObject.retDtlCd)
	End if

	'전송 정보 변수 할당
	username = oivsObject.niceNm
	dupeInfo = oivsObject.dupeInfo
	connInfo = left(oivsObject.coInfo,88)

	'생년월일산출
	birthDt = DateSerial(left(oivsObject.birthday,4),mid(oivsObject.birthday,5,2),right(oivsObject.birthday,2))

	'// 통계를 위한 조합 주민등록번호 생성 (생년월일, 성별, 재외국인 구분용)
	socno1 = right(oivsObject.birthday,6)
	if oivsObject.foreigner="1" then
		'내국인
		if Cint(left(oivsObject.birthday,4))<2000 then
			if oivsObject.sex="1" then
				socno2 = "1000000"
			else
				socno2 = "2000000"
			end if
		else
			if oivsObject.sex="1" then
				socno2 = "3000000"
			else
				socno2 = "4000000"
			end if
		end if
	else
		'외국인
		if Cint(left(oivsObject.birthday,4))<2000 then
			if oivsObject.sex="1" then
				socno2 = "5000000"
			else
				socno2 = "6000000"
			end if
		else
			if oivsObject.sex="1" then
				socno2 = "7000000"
			else
				socno2 = "8000000"
			end if
		end if
	end if

	'// 전송용 데이터 조합 및 암호화
	strTrans = username & "||" & socno1 & "||" & socno2
	strTrans = tenEnc(strTrans)

	'로그저장
	Call saveCheckLog("IP",username,socno1,MD5(CStr(socno2)),uip,chkYn,oivsObject.retCd,oivsObject.retDtlCd,strMsg,getEncLoginUserID)

	'실패면 안내후 빽!
	if chkYn="N" then
		Response.Write "<script langauge=javascript>" &_
						"alert('" & strMsg & "');" &_
						"opener.document.location.href="""&wwwUrl&"/my10x10/userinfo/membermodify.asp"" "&_
						"</script>"
		dbget.close()
		Response.End
	end if

	'==============================================================================
	'로그인 아이디로 DB에 있는 회원명, 주민번호1 을 가져와서 아이핀에서 체크한 정보를 서로 비교 체크
	dim sqlStr, cnt, vIsOK, vEnc_Jumin2
	dim finedUserid
	dim result

	sqlStr = " select top 1 username, jumin1, juminno "
	sqlStr = sqlStr + " from [db_user].[dbo].tbl_user_n "
	sqlStr = sqlStr + " where userid = '" & getEncLoginUserID & "' "
	rsget.Open sqlStr,dbget,1
	
	vIsOK = "x"
	If Not rsget.Eof Then
		If CStr(oivsObject.niceNm) = CStr(rsget("username")) AND CStr(Right(oivsObject.birthday,6)) = CStr(rsget("jumin1")) Then
			vIsOK 		= "o"
			vEnc_Jumin2 = MD5(CStr(socno2))
			rsget.close
		Else
			Response.Write "<script langauge=javascript>" &_
							"alert('텐바이텐 회원데이터에 저장된 명의와 아이핀에서 체크한 명의가 서로 다릅니다.\n자세한 문의는 고객센터 Tel.1644-6030 으로 연락을 주시기 바랍니다.');" &_
							"opener.document.location.reload(); "&_
							"self.close();" & _
							"</script>"
			rsget.close
			dbget.close()
			response.write sqlStr & "<br>" & oivsObject.niceNm & "<br>" & oivsObject.birthday
			Response.End
		End If
	Else
		Response.Write "<script langauge=javascript>" &_
						"alert('잘못된 접근입니다.\n로그아웃을 하시고 다시 로그인을 한 후 해보시거나\n고객센터 Tel.1644-6030 으로 연락을 주시기 바랍니다.');" &_
						"opener.document.location.reload(); "&_
						"self.close();" & _
						"</script>"
		rsget.close
		dbget.close()
		Response.End
	End If
	
	If vIsOK = "o" Then
		sqlStr = "UPDATE [db_user].[dbo].[tbl_user_n] SET " &_
				 "		Enc_jumin2 = '" & vEnc_Jumin2 & "', " &_
				 "		realnamecheck = 'Y', " & _
				 "		dupeInfo = '" & cstr(dupeInfo) & "', " &_
				 "		connInfo = '" & cstr(connInfo) & "', " &_
				 "		iPinCheck = 'Y' " &_
				 "	WHERE userid = '" & getEncLoginUserID & "' "
		dbget.execute sqlStr

		'수정로그 저장
		Call saveUpdateLog(getEncLoginUserID, "C")
	End If

	
	''#############################

	'==============================================================================
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
		'구분(chkDiv) : RN : 실명확인, CP : 본인확인, IP : 아이핀
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

	'// 정보수정 로그 기록(2011.09.09; 허진원)
	Sub saveUpdateLog(uid,udiv)
		'구분(udiv) : I:정보수정, P:패스워드변경, C:아이핀전환
		dim strSql
		strSql = "insert into db_log.dbo.tbl_user_updateLog (userid,updateDiv,siteDiv,refIP) values " &_
				" ('" & uid & "'" &_
				", '" & udiv & "', 'T'" &_
				", '" & Left(request.ServerVariables("REMOTE_ADDR"),32) & "')"
		dbget.Execute strSql
	end Sub
%>
<script language="javascript">
<% If vIsOK = "o" Then %>
	alert("아이핀 인증으로 전환 처리완료 되었습니다.");
	opener.document.location.reload();
	window.close()
<% Else %>
	alert("전환 처리중 문제가 있어 처리 되지 않았습니다.\n자세한 문의는 고객센터 Tel.1644-6030 으로 연락을 주시기 바랍니다.");
	opener.document.location.reload();
	window.close()
<% End If %>
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->
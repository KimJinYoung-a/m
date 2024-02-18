<%@ codepage="65001" language="VBScript" %>
<%
	Option Explicit
	Response.Expires = -1440
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
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
		Response.End
	End If
	''response.cookies("niceChk")("niceOrderNo") = ""
	session("niceOrderNo") = ""

	'####### POINT1010 에서 넘어온건지 체크 #######
	Dim pFlag, vParam
	vParam = "?cDv=IP"
	
	pFlag	= requestCheckVar(request("pflag"),1)
	If pFlag = "o" Then vParam = vParam & "&pflag=o"

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
						"location.href="""&wwwUrl&"/member/gatepage.asp?sMsg=같은 아이피로 단시간 내에 연속으로 여러번 접속하였습니다.<br>잠시 후 다시 시도해주세요.&nbsp;" & Replace(vParam,"?","&") & """ "&_							
						"</script>"
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
	connInfo = oivsObject.coInfo

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
	Call saveCheckLog("IP",username,socno1,MD5(CStr(socno2)),uip,chkYn,oivsObject.retCd,oivsObject.retDtlCd,strMsg,"")

	'실패면 안내후 빽!
	if chkYn="N" then
		Response.Write "<script langauge=javascript>" &_
						"alert('" & strMsg & "');" &_
						"location.href="""&wwwUrl&"/member/gatepage.asp?sMsg="&strMsg&"" & Replace(vParam,"?","&") & """ "&_
						"</script>"
		Response.End
	end if

	'==============================================================================
	'기존에 같은 중복가입확인번호가 있는지 체크
	dim sqlStr, cnt
	dim finedUserid
	dim result

	sqlStr = " select top 1 userid "
	sqlStr = sqlStr + " from [db_user].[dbo].tbl_user_n "
	sqlStr = sqlStr + " where dupeInfo = '" + dupeInfo + "' "
	rsget.Open sqlStr,dbget,1
	cnt = 0
	if Not rsget.Eof then
	        cnt = 1
	        finedUserid = rsget("userid")
	end if
	rsget.close
	
	if (cnt > 0) then
	        result = "exist"
	end if

	''#### 사용 사이트 Check (핑거스 가입후 텐바이텐 이용안함 원하는 고객.) ######
	if (result = "exist") then
	    sqlStr = " select count(*) as cnt "
	    sqlStr = sqlStr & " from db_user.dbo.tbl_user_allow_site"
	    sqlStr = sqlStr & " where userid='" & finedUserid & "'"
	    sqlStr = sqlStr & " and userid<>''"
	    sqlStr = sqlStr & " and sitegubun='" & CCurrentSite & "'"
	    sqlStr = sqlStr & " and siteusing='N'"
	
	    rsget.Open sqlStr,dbget,1
	        ''특정사이트 이용안함.
	        if (rsget("cnt")>0) then
	            result = "existNotUsing"
	        end if
	    rsget.Close
	    
	    if (result = "existNotUsing") then
	        ''핑거스도 사용안하는경우..
	        sqlStr = " select count(*) as cnt "
	        sqlStr = sqlStr & " from db_user.dbo.tbl_user_allow_site"
	        sqlStr = sqlStr & " where userid='" & finedUserid & "'"
	        sqlStr = sqlStr & " and userid<>''"
	        sqlStr = sqlStr & " and sitegubun='" & COtherSite & "'"
	        sqlStr = sqlStr & " and siteusing='N'"
	        rsget.Open sqlStr,dbget,1
	            if (rsget("cnt")>0) then
	                result = "existsAllNotUsing"
	            end if
	        rsget.Close
	    end if
	end if
	''#############################
	
	'==============================================================================
	'14세(한국나이)가 넘었는지 검사
	if (result = "") then
	    if DateDiff("yyyy",birthDt,date())<13 then
	            result = "limitage"
	    end if
	end if
	'==============================================================================
	if (result = "") then
		result = "ok"

		'해킹방지를 위해 이름과 주민번호를 암호화하여 쿠기에 저장(2010.11.25; 허진원)
		 response.Cookies("etc").domain = "10x10.co.kr"
		 response.cookies("etc")("chkJoinNo") = md5(trim(username) & trim(socno1) & trim(socno2))
	end if

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
%>
<script language="javascript">

	function doResult(result)	{
        if (result == "exist") {
                alert("이미 가입하셨습니다.");                
		 location.href="<%=wwwUrl%>/member/gatepage.asp?sMsg=이미 가입하셨습니다.<%=Replace(vParam,"?","&")%>"
        } else if (result == "existNotUsing") {
                alert("귀하는 텐바이텐 서비스에 이미 회원 가입하셨습니다. \n텐바이텐 쇼핑몰을 이용하시려면 핑거스 My Fingers에서 \n이용사이트 설정을 수정하시면 텐바이텐 서비스를 바로 이용하실 수 있습니다.");
                location.href="<%=wwwUrl%>/member/gatepage.asp?sMsg=귀하는 텐바이텐 서비스에 이미 회원 가입하셨습니다. <br>텐바이텐 쇼핑몰을 이용하시려면 핑거스 My Fingers에서 <br>이용사이트 설정을 수정하시면 텐바이텐 서비스를 바로 이용하실 수 있습니다.<br>(<a href='http://thefingers.co.kr/myfingers/membermodify.asp' target='_blank'>-&gt;My Fingers 바로가기</a>)<br>&nbsp;<%=Replace(vParam,"?","&")%>"                
        } else if (result == "existsAllNotUsing") {
                alert("가입후 사용 중지 하신 상태입니다. 고객센터로 문의해 주세요");
                location.href="<%=wwwUrl%>/member/gatepage.asp?sMsg=가입후 사용 중지 하신 상태입니다. 고객센터로 문의해 주세요.<%=Replace(vParam,"?","&")%>"                
        } else if (result == "limitage") {
                alert("만 14세 미만인 분은 가입할 수 없습니다.");
                location.href="<%=wwwUrl%>/member/gatepage.asp?sMsg= 만 14세 미만인 분은 가입할 수 없습니다.<%=Replace(vParam,"?","&")%>"
        } else {
        	location.href="<%=wwwUrl%>/member/gatepage.asp?IR=Y<%=Replace(vParam,"?","&")%>&di=<%=Server.URLEncode(dupeInfo)%>&ci=<%=Server.URLEncode(connInfo)%>&trs=<%=Server.URLEncode(strTrans)%>" ;
        }
	}
	
	doResult("<%=result%>");			
	
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->
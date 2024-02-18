<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_MyCardInfoCls.asp" -->
<%
	'// 변수 선언
	dim masterCardCd, strSql, rstCd, refip, recentqcount

	'// 전송값 확인
	masterCardCd = requestCheckVar(getNumeric(request("masterCardCd")),16)
	
	
	'// 로그 저장/검색 제한
	refip = request.ServerVariables("REMOTE_ADDR")
	
	'// 최근 15분간 5번 제한
	strSql = "select count(idx) as cnt from [db_log].[dbo].[tbl_giftcard_reg_log] where refip='" & refip & "' and datediff(n,regdate,getdate())<=15"
	rsget.CursorLocation = adUseClient
	rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly
		recentqcount = rsget("cnt")
	rsget.close
	if recentqcount>=5 then
		Call Alert_Move("같은 아이피로 단시간 내에 연속으로 여러번 접속하였습니다.\n잠시 후 다시 시도해주세요.","about:blank")
		dbget.close()
		response.End
	end if
	
	
	if masterCardCd="" or len(masterCardCd)<16 then
		Call Alert_Move("기프트카드번호가 없거나 잘못된 코드입니다.[011]","about:blank")
		Call fnGiftCardRegLog("I", Left(masterCardCd,16), "W1")	'### 실패 로그저장.
		dbget.close
		response.End
	end if

	'// 유효코드 확인(없어도 될지도)
	if Not(chkMasterCode(masterCardCd)) then
		Call Alert_Move("잘못된 기프트카드번호입니다.\n입력하신 코드를 다시 확인해주세요.[012]","about:blank")
		Call fnGiftCardRegLog("I", Left(masterCardCd,16), "W2")	'### 실패 로그저장.
		dbget.close
		response.End
	end if
	
	
	'// 등록처리
	rstCd = procGiftCardReg(masterCardCd)
	Select Case rstCd
		Case "W"
			Call Alert_Move("기프트카드번호가 없거나 잘못된 코드입니다.[023]","about:blank")
			dbget.close: response.End
		Case "L"
			Call Alert_Move("죄송합니다. 유효기간이 만료된 카드입니다.[034]","about:blank")
			dbget.close: response.End
		Case "R"
			Call Alert_Move("이미 등록된 카드입니다.[035]","about:blank")
			dbget.close: response.End
		Case "C"
			Call Alert_Move("주문이 취소된 카드입니다.[036]","about:blank")
			dbget.close: response.End
		Case "E"
			Call Alert_Move("죄송합니다. 처리중 오류가 발생했습니다.[047]","about:blank")
			dbget.close: response.End
	End Select

	Response.Write "<script language='javascript'>" & vbCrLf &_
					"alert('감사합니다. 입력하신 카드(" & FormatNumber(rstCd,0) & "원권)가 정상적으로 등록되었습니다.');" & vbCrLf &_
					"top.location.href='/my10x10/giftcard/giftcardUselist.asp';" & vbCrLf &_
					"</script>"
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
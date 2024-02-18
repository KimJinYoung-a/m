<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.Charset ="UTF-8"
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/rndSerial.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_couponcls.asp" -->
<%
	'####### 20110831 메일 발송(A그룹,B그룹) 아낌없이 주는 쿠폰 255(CZBBS),256(GC9WZ),257(TKY7X)
	'A 그룹 : 1(TA6)
	'B 그룹 : 2(CZ3)
	'####### 그룹 쿠분 암호와 3자리와 쿠폰 번호 암호화 5자리를 연속으로 받아옴. 예) A그룹에256쿠폰 -> docoupondown.asp?param=TA6GC9WZ

	Dim vIsErr, sqlStr, userid, ocouponmaster, IsCouponDown
	Dim vParameter, vTable, vCouponIdx
	vParameter	= requestCheckVar(Request("param"),10)
	userid  	= getEncLoginUserID()


	'####### 수동으로 파라메터 조작한것들 잘못된 접근 체크
	Call ParameterErrCheck(vParameter)

	
	vTable		= CHKIIF(rdmSerialDec(Left(vParameter,3))="1","A","B")
	vCouponIdx	= rdmSerialDec(Right(vParameter,5))


	'####### A그룹, B그룹 쿠폰 다운 대상자 체크
	Call CouponDownUserListCheck(vTable)


	Set ocouponmaster = New CCouponMaster
	ocouponmaster.FRectIdx = vCouponIdx
	ocouponmaster.GetSpecialValidCouponMaster
	If ocouponmaster.FresultCount < 1 Then
		Response.Write "<script language='javascript'>alert('쿠폰발급이 마감되었습니다.');document.location.href = 'http://www.10x10.co.kr';</script>"
		dbget.close()
		Response.End
	End IF
	Set ocouponmaster = Nothing
	
	
	'####### 쿠폰 다운 여부 체크
	IsCouponDown = IsCouponDownCheck(vCouponIdx)


	If IsCouponDown = False Then
		sqlStr = "insert into [db_user].[dbo].tbl_user_coupon(masteridx, userid, coupontype, couponvalue, couponname, minbuyprice, targetitemlist, startdate,expiredate,couponmeaipprice)"
		sqlStr = sqlStr + " 	select top 1 " + CStr(vCouponIdx) + ", '" + userid + "', coupontype, couponvalue, couponname, minbuyprice, targetitemlist, startdate,expiredate,couponmeaipprice"
		sqlStr = sqlStr + "		from [db_user].[dbo].tbl_user_coupon_master"
		sqlStr = sqlStr + "		where idx=" + CStr(vCouponIdx)
		rsget.Open sqlStr, dbget, 1
	End If
%>

<script language="javascript">
	<% If IsCouponDown = False Then %>
	alert("쿠폰이 발급되었습니다. 주문시 사용가능합니다.");
	<% Else %>
	alert("이미 쿠폰이 발급되었습니다.");
	<% End IF %>
	document.location.href = "http://www.10x10.co.kr";
</script>

<%
'############################################################ 쿠폰 최종 다운 전 체크할 항목 Function 들 ############################################################

'####### 쿠폰 다운 대상 체크
Function CouponDownUserListCheck(table)
	Dim vQuery
	vQuery = "SELECT COUNT(userid) FROM [db_temp].[dbo].[tbl_20110831_coupondown_" & table & "] WHERE userid = '" & getEncLoginUserID() & "'"
	rsget.Open vQuery, dbget, 1
	If rsget(0) < 1 Then
		Response.Write "<script language='javascript'>alert('쿠폰 다운 대상 회원이 아닙니다.');document.location.href = 'http://www.10x10.co.kr';</script>"
		rsget.close()
		dbget.close()
		Response.End
	Else
		rsget.close()
	End IF
End Function

'####### 쿠폰 다운 여부 체크
Function IsCouponDownCheck(couponidx)
	Dim vQuery, vIsDown
	vQuery = "SELECT COUNT(idx) FROM [db_user].[dbo].tbl_user_coupon WHERE userid = '" & getEncLoginUserID() & "' and masteridx = '" & couponidx & "' and deleteyn='N' "
	rsget.Open vQuery, dbget, 1
	If rsget(0) > 0 Then
		Response.Write "<script language='javascript'>alert('이미 쿠폰이 발급되었습니다.');document.location.href = 'http://www.10x10.co.kr';</script>"
		rsget.close()
		dbget.close()
		Response.End
	Else
		rsget.close()
	End IF
	IsCouponDownCheck = False
End Function

'####### 잘못된 접근 체크
Function ParameterErrCheck(param)
	Dim vParameter, vIsErr
	vParameter = param
	vIsErr = "x"
	
	'### 총 자리수 체크 8자리
	If Len(vParameter) <> 8 Then
		vIsErr = "o"
	Else
		If rdmSerialDec(Left(vParameter,3)) <> "1" AND rdmSerialDec(Left(vParameter,3)) <> "2" Then
			vIsErr = "o"
		End If
		
		'If rdmSerialDec(Right(vParameter,5)) <> "199" AND rdmSerialDec(Right(vParameter,5)) <> "200" AND rdmSerialDec(Right(vParameter,5)) <> "201" Then
		If rdmSerialDec(Right(vParameter,5)) <> "255" AND rdmSerialDec(Right(vParameter,5)) <> "256" AND rdmSerialDec(Right(vParameter,5)) <> "257" Then
			vIsErr = "o"
		End If
	End If
	
	If vIsErr = "o" Then
		Response.Write "<script language='javascript'>alert('잘못된 접근입니다.');document.location.href = 'http://www.10x10.co.kr';</script>"
		dbget.close()
		Response.End
	End If
End Function
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
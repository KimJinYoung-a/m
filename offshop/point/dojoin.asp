<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<% const midx = 0 %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/email/maillib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/offshop/lib/classes/offshopCls.asp" -->
<%
	If GetLoginUserID() = "" Then
		Response.write "<script>self.location='/login/login.asp?backpath=/offshop/point/cardregister.asp';</script>"
		Response.End
	End If

'==============================================================================
'외부 URL 체크
dim backurl
backurl = request.ServerVariables("HTTP_REFERER")
if InStr(LCase(backurl),"10x10.co.kr") < 1 then
    if (Len(backurl)>0) then
        response.redirect backurl
        response.end
    else
        response.write "<script>alert('유효한 접근이 아닙니다.');history.back();</script>"
        response.end
    end if
end if


'==============================================================================
'파라미터 세팅

dim hideventid, sqlStr, viPinCheck
dim txuserid, txpass1, txJumin1, txJumin2, emailok, vUserName, vJumin1, vJumin2_Enc, vQuery, vTotalCardLogQuery, vHpNo, vEmail
dim txSolar, txBirthday1, txBirthday2, txBirthday3
dim txName, txZip1, txZip2, txAddr1, txAddr2, txPhone1, txPhone2, txPhone3, txCell1, txCell2, txCell3
dim sePassConfirm, txPassConfirm
dim email_way2way, email_10x10

Dim vGubun, vUserSeq, vUserSeqTemp, vCardNo, vHaveCardYN, vPoint, vPointTemp, vHaveTotalCardYN
vGubun		= requestCheckVar(Request("flag"),1)	'### 1은 동시가입, 2는 point1010 만 가입
vCardNo		= requestCheckVar(Request("RealCardNo"),16)
vHaveCardYN	= requestCheckVar(Request("havecardyn"),1)
vHaveTotalCardYN	= requestCheckVar(Request("havetotalcardyn"),1)

If vCardNo = "" Then
	Response.Write "<script>alert('잘못된 카드번호 입니다.');location.href='/offshop/point/cardregister.asp';</script>"
	Response.End
End If

vPoint = 0
vPointTemp = 0

'' SMS 추가
dim smsok

hideventid      = requestCheckVar(request.form("hideventid"),32)
txuserid        = GetLoginUserID()

smsok   = requestCheckVar(request.form("smsok_point1010"),1)
emailok	= requestCheckVar(request.form("email_point1010"),1)


'==============================================================================
dim usermail, birthday, refip, juminno, sexflag, Enc_jumin2, sitegubun
dim Enc_userpass, lastrefip


dim errcode

''2011-02-28 추가
dim AssignedRow, mayRegShopID, isForeignCurr, IsPointEventValid, evtAssignedMSG
IsPointEventValid = (now()>"2011-04-18")
''IsPointEventValid = false

On Error Resume Next
dbget.beginTrans


	'######################################### [1] 이름과 주민번호 받아옴. #######################################################################
		If Err.Number = 0 Then
		        errcode = "P01"
		end if

		sqlStr = "SELECT username, jumin1, Enc_jumin2, iPinCheck,usercell,usermail From [db_user].[dbo].tbl_user_n WHERE userid = '" & txuserid & "'"
		rsget.Open sqlStr,dbget
		IF not rsget.Eof THEN
			vUserName	= rsget("username")
			vJumin1		= rsget("jumin1")
			vJumin2_Enc	= rsget("Enc_jumin2")
			viPinCheck  = rsget("iPinCheck")
			vHpNo   = rsget("usercell")
			vEmail  = rsget("usermail")
		END IF
		rsget.Close
	'#############################################################################################################################################



	'######################################### [2] UserSeq 가 있는지 없는지 체크 #################################################################
		If Err.Number = 0 Then
		        errcode = "P02"
		end if

		''연결된 아이디로 먼저 검색.
		sqlStr = "SELECT UserSeq From [db_shop].[dbo].[tbl_total_shop_user] WHERE OnlineUserID='"&txuserid&"'"
	    rsget.Open sqlStr,dbget
		IF not rsget.Eof THEN
			vUserSeq	= rsget("UserSeq")
		END IF
		rsget.Close

'''이부분 문제.. //주민번호로 검사불가. 주석처리.
''    	if (viPinCheck="N") then
''    		sqlStr = "SELECT UserSeq From [db_shop].[dbo].[tbl_total_shop_user] WHERE Jumin1 = '" & vJumin1 & "' AND Jumin2_Enc = '" & vJumin2_Enc & "' and isNULL(OnlineUserID,'')=''"
''    		rsget.Open sqlStr,dbget
''    		IF not rsget.Eof THEN
''    			vUserSeq	= rsget("UserSeq")
''    		END IF
''    		rsget.Close
''		end if
	'#############################################################################################################################################



	'######################################### [3] UserSeq 없을때 tbl_total_shop_user 에 INSERT INTO, 있으면 UPDATE ##############################
		If vUserSeq = "" Then

			If Err.Number = 0 Then
			        errcode = "P03"
			end if

			sqlStr = "INSERT INTO [db_shop].[dbo].tbl_total_shop_user(UserName, Jumin1, Jumin2_Enc, EmailYN, SMSYN, HpNo ,Email ,OnlineUserID) " & _
					 "	 VALUES('" & vUserName & "', '" & vJumin1 & "', '" & vJumin2_Enc & "', '" & emailok & "', '" & smsok & "', '" & vHpNo & "', '" & vEmail & "', '" & txuserid & "')"
			dbget.execute(sqlStr)

			sqlStr = " SELECT @@identity "
			rsget.Open sqlStr,dbget

			IF not rsget.Eof THEN
				vUserSeq = rsget(0)
			END IF
			rsget.Close
		Else
			sqlStr = "UPDATE [db_shop].[dbo].tbl_total_shop_user " &VbCRLF
			sqlStr = sqlStr& "	SET " &VbCRLF
			sqlStr = sqlStr&" 	EmailYN = '" & emailok & "', SMSYN = '" & smsok & "', LastUpdate = getdate()" &VbCRLF
			sqlStr = sqlStr&"   ,HpNo='"&vHpNo&"'"&VbCRLF
			sqlStr = sqlStr&"   ,Email='"&vEmail&"'"&VbCRLF
			sqlStr = sqlStr&"	WHERE UserSeq = '" & vUserSeq & "' "&VbCRLF
			sqlStr = sqlStr&"	and OnlineUserID='"&txuserid&"'"&VbCRLF

			dbget.execute(sqlStr)
		End If
	'#############################################################################################################################################


'----------------------------[ 여기까지 [db_shop].[dbo].tbl_total_shop_user 관련해서 vUserSeq 에 값 저장. ]---------------------------------------


	'######################################### [4] 재발급시 마지막 등록 후 24시간내 등록 불가. ###################################################
		If Err.Number = 0 Then
		        errcode = "P04"
		end if

		''sqlStr = " SELECT COUNT(*) From [db_shop].[dbo].tbl_total_shop_card Where UserSeq = '" & vUserSeq & "' AND UseYN = 'Y' AND datediff(dd,Regdate,getdate()) = 0 "
		sqlStr = " select count(*) from db_shop.dbo.tbl_total_shop_user u" & _
        	     "	    Join db_shop.dbo.tbl_total_shop_card c" & _
        	     "	    on u.UserSeq=c.UserSeq" & _
            	 "	    and c.UseYN = 'Y'" & _
            	 "	    Join db_shop.dbo.tbl_total_shop_log  l" & _
            	 "	    on c.CardNo=l.CardNo" & _
            	 "	    and l.pointCode=3" & _
                 "	where u.UserSeq=" & vUserSeq & _
                 "	and datediff(dd,l.Regdate,getdate())=0 "

		rsget.Open sqlStr,dbget

		IF rsget(0) > 0 THEN
			Response.Write "<script>alert('카드 등록한 당일 내에 재등록을 하실 수 없습니다.\n\n고객센터로 문의를 하시려면 Tel.1644-6030으로 연락을 주세요.');location.href='"&wwwUrl&"/offshop/';</script>"
			dbget.RollBackTrans
			Response.End
		END IF
		rsget.Close
	'#############################################################################################################################################


	'######################################### [5] 현재 포인트 총합구함 ##########################################################################
		If Err.Number = 0 Then
		        errcode = "P05"
		end if

		sqlStr = " SELECT isNull(SUM(Point),0) From [db_shop].[dbo].tbl_total_shop_card " & _
				 "		Where UserSeq = '" & vUserSeq & "' AND UseYN = 'Y' AND CardNo <> '" & vCardNo & "' and UserSeq<>0"
		rsget.Open sqlStr,dbget

		IF not rsget.Eof THEN
			vPoint = rsget(0)
		Else
			vPoint = 0
		END IF
		rsget.Close
	'#############################################################################################################################################



	'######################################## [6] [tbl_total_shop_card] 카드번호에 UserSeq = 0 인게 있는지 없는지 체크, 로그 저장. ###############
		If Err.Number = 0 Then
		        errcode = "P06"
		end if
		mayRegShopID = getMayRegShopid(vCardNo, isForeignCurr)

		sqlStr = "SELECT Point From [db_shop].[dbo].[tbl_total_shop_card] WHERE CardNo = '" & vCardNo & "' AND UserSeq = '0'"
		rsget.Open sqlStr,dbget
		IF NOT rsget.Eof THEN
			'####### UserSeq = 0 있다. UPDATE #######
			sqlStr = "UPDATE [db_shop].[dbo].tbl_total_shop_card " & _
					 "	SET " & _
					 "		UserSeq = '" & vUserSeq & "', Point = Point + '" & vPoint & "' " & _
					 "	WHERE CardNo = '" & vCardNo & "' "
			dbget.execute(sqlStr)
		Else
			'####### UserSeq = 0 없다. INSERT INTO #######

			sqlStr = "INSERT INTO [db_shop].[dbo].tbl_total_shop_card(UserSeq, CardNo, Point, UseYN, RegShopID) " & _
					 "	VALUES('" & vUserSeq & "', '" & vCardNo & "', '" & vPoint & "', 'Y', '"&mayRegShopID&"')"
			dbget.execute(sqlStr)
		END IF
		rsget.Close


		'####### 통합 카드 로그 쿼리. INSERT는 맨 나중에. #######
		vTotalCardLogQuery = "INSERT INTO [db_shop].[dbo].tbl_total_shop_log(CardNo, Point, PointCode, RegShopID, LogDesc) " & _
				 			 "	VALUES('" & vCardNo & "', '" & vPoint & "', '3', '', '카드등록')"
	'#############################################################################################################################################



	'######################################## [7],[8] 기존 카드 UseYN = N, 포인트 = 0, 로그 저장. ################################################
		If Err.Number = 0 Then
		        errcode = "P07"
		end if
		vQuery = ""

		sqlStr = "SELECT CardNo, Point FROM [db_shop].[dbo].tbl_total_shop_card " & _
				 "		WHERE UserSeq = '" & vUserSeq & "' AND CardNo <> '" & vCardNo & "' AND UseYN = 'Y'"
		rsget.Open sqlStr,dbget
		IF not rsget.Eof THEN
			Do Until rsget.Eof
				vQuery = vQuery & "		INSERT INTO [db_shop].[dbo].tbl_total_shop_log(CardNo, Point, PointCode, RegShopID, LogDesc)"
				vQuery = vQuery & "		VALUES('" & Left(rsget(0),20) & "', '-" & rsget(1) & "', '3', '', '포인트이관')		"

			rsget.MoveNext
			Loop

			dbget.execute(vQuery)
		END IF
		rsget.Close


		If Err.Number = 0 Then
		        errcode = "P08"
		end if
		sqlStr = " UPDATE [db_shop].[dbo].tbl_total_shop_card " & _
				 "		SET UseYN = 'N', Point = '0' " & _
				 "	WHERE UserSeq = '" & vUserSeq & "' AND CardNo <> '" & vCardNo & "' AND UseYN = 'Y' "
		dbget.execute(sqlStr)
	'#############################################################################################################################################


'----------------------------[ 여기까지 [db_shop].[dbo].tbl_total_shop_card 관련해서 값 저장. ]---------------------------------------


	'######################################## [9] 카드리스트 UseYN = N ###########################################################################
		If Err.Number = 0 Then
		        errcode = "P09"
		end if
		sqlStr = " UPDATE [db_shop].[dbo].tbl_total_card_list SET UseYN = 'Y' WHERE CardNo = '" & vCardNo & "' "
		dbget.execute(sqlStr)
	'#############################################################################################################################################



	'######################################## [10] 통합 카드 로그 INSERT. & 포인트 다시 업데이트 함. #############################################
		If Err.Number = 0 Then
		        errcode = "P10"
		end if
		dbget.execute(vTotalCardLogQuery)

		'' 카드 신규 등록자 Point(1000) 지급 vCardNo 2011-02-28 ===================================================================
		'' XXXXXXXX 1010 카드 신규발급자 기준/ 다시 발급 받아 등록 하더라도 1,000 포인트 지급. 해외샵(지급 안함)
		'' >>>>>> 1010 카드 등록자 대상 1,000 포인트 지급 (1회한정, 해외샵 카드 제외)
		AssignedRow = 0
		Dim evtPointCode : evtPointCode = 8                            '''바뀌면 추가 지급됨
		Dim evtLogDesc   : evtLogDesc   = "회원 Point카드등록기념"     '''바뀌면 추가 지급됨

		if (Not isForeignCurr) and (IsPointEventValid) then
    		sqlStr = " IF Not Exists( " & VbCrlf
            sqlStr =  sqlStr & " 	select * " & VbCrlf
            sqlStr =  sqlStr & " 	from [db_shop].[dbo].tbl_total_shop_log L " & VbCrlf
            sqlStr =  sqlStr & " 		Join [db_shop].[dbo].tbl_total_shop_card U " & VbCrlf
            sqlStr =  sqlStr & " 		on U.cardno=L.cardNo " & VbCrlf
            sqlStr =  sqlStr & " 	where L.PointCode="&evtPointCode&" " & VbCrlf
            sqlStr =  sqlStr & " 	and L.LogDesc='"&evtLogDesc&"' " & VbCrlf
            sqlStr =  sqlStr & " 	and U.UserSeq="&vUserSeq & VbCrlf
            sqlStr =  sqlStr & " ) " & VbCrlf
            sqlStr =  sqlStr & " BEGIN "
    		sqlStr =  sqlStr & " INSERT INTO [db_shop].[dbo].tbl_total_shop_log(CardNo, Point, PointCode, RegShopID, LogDesc) " & VbCrlf
    		sqlStr =  sqlStr & " VALUES('" & vCardNo & "', 1000, '"&evtPointCode&"', '', '"&evtLogDesc&"')" & VbCrlf
    		sqlStr =  sqlStr & " END " & VbCrlf

    		dbget.Execute sqlStr, AssignedRow

    		if AssignedRow>0 then evtAssignedMSG="신규 카드 등록 기념 포인트 1,000점 지급되었습니다.\r\n포인트카드 등록 시 최초 1회 지급"
    	end if
		'''=========================================================================================================================

	    sqlStr = "update [db_shop].[dbo].tbl_total_shop_card " & _
				 " 	set point = " & _
				 " 		IsNULL((select sum(point) from [db_shop].[dbo].tbl_total_shop_log " & _
				 "  			where CardNo = '" & vCardNo & "' " & _
				 "  			),0) " & _
				 " 	where CardNo = '" & vCardNo & "' "

		dbget.Execute sqlStr
	'#############################################################################################################################################


	If Err.Number = 0 Then
	        dbget.CommitTrans
	Else
	        dbget.RollBackTrans
	        response.write "<script>alert('데이타를 저장하는 도중에 에러가 발생하였습니다.\r\n지속적으로 문제가 발생시에는 고객센타에 연락주시기 바랍니다.(에러코드 : " + CStr(errcode) + ")')</script>"
	        response.write "<script>history.back()</script>"
	        response.end
	End If

on error Goto 0


''0-ETC
''1-구매적립
''2-온라인마일리지전환
''3-카드등록/포인트이관
''9-포인트 사용
'''4 - 보너스 적립 (신규회원 1,000) 포인트
%>
<script>
<% if (evtAssignedMSG<>"") then %>
alert('<%= evtAssignedMSG %>');
<% else %>
alert('등록이 완료 되었습니다.');
<% end if %>
parent.location.replace('<%= wwwUrl %>/offshop/point/mileagelist.asp');
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->
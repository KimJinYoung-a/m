<%
	'//기프트카드 현황 아이템
	Class myGiftCarditem
		public FgiftOrderSerial
		public FmasterCardCode
		public FbuyDate
		public FregDate
		public FcardExpire
		public FsmallImage
		public FcardPrice
		public FcardStatus
		public FcardItemid
		public FCarditemname
		public FcardOptionName

		public FuseCash
		public Fjukyocd
		public Fjukyo
		public Forderserial
		public FsiteDiv
		public Fremain

		Private Sub Class_initialize()	
		End Sub

		Private Sub Class_Terminate()	
		End Sub

		Function getSiteDivName()
			Select Case FsiteDiv
				Case "T"
					getSiteDivName = "텐바이텐"
				Case "F"
					getSiteDivName = "핑거스아카데미"
				Case "S"
					getSiteDivName = "오프라인샾"
				Case Else
					getSiteDivName = FsiteDiv
			End Select
		end Function
	End Class

	'//기프트카드 현황 아이템
	Class myGiftCard
		public FItemList()
		public FTotalCount
		public FResultCount
		public FCurrPage
		public FTotalPage
		public FPageSize
		public FScrollCount
		public FRectUserid
		public FRectSiteDiv

		'# 기프트카드 잔액 확인
		Public Function myGiftCardCurrentCash()
			Dim strSql
			strSQL = "exec [db_user].[dbo].sp_Ten_giftCardCurrentCash '" & CStr(FRectUserid) & "'"
			rsget.CursorLocation = adUseClient
			rsget.CursorType = adOpenStatic
			rsget.LockType = adLockOptimistic
			rsget.Open strSQL, dbget, 1
				if not rsget.EOF then
					myGiftCardCurrentCash = rsget(0)
				else
					myGiftCardCurrentCash = 0
				end if
			rsget.Close
		end Function

		'# 등록 기프트카드 목록
		Public Sub myGiftCardRegList()
			Dim i, strSql

			'카운트
			strSql = "exec [db_user].[dbo].sp_Ten_giftCardRegListCnt '" & CStr(FRectUserid) & "'," & FPageSize
			rsget.CursorLocation = adUseClient
			rsget.CursorType = adOpenStatic
			rsget.LockType = adLockOptimistic
			rsget.Open strSQL, dbget, 1
				FTotalCount = rsget("cnt")
				FTotalPage = rsget("totPg")
			rsget.Close

			'지정페이지가 전체 페이지보다 클 때 함수종료
			if Cint(FCurrPage)>Cint(FTotalPage) then
				FResultCount = 0
				exit sub
			end if

			'내용 접수
			strSql = "exec [db_user].[dbo].sp_Ten_giftCardRegList '" & CStr(FRectUserid) & "'," & FPageSize & "," & FCurrPage
			rsget.CursorLocation = adUseClient
			rsget.CursorType = adOpenStatic
			rsget.LockType = adLockOptimistic
			rsget.pagesize = FPageSize
			rsget.Open strSQL, dbget, 1

			if (FCurrPage * FPageSize < FTotalCount) then
				FResultCount = FPageSize
			else
				FResultCount = FTotalCount - FPageSize*(FCurrPage-1)
			end if
	
			redim preserve FItemList(FResultCount)

			i=0
			if Not(rsget.EOF or rsget.BOF) then
				rsget.absolutepage = FCurrPage
				do until rsget.EOF
					set FItemList(i) = new myGiftCarditem

					FItemList(i).FgiftOrderSerial = rsget("giftOrderSerial")
					FItemList(i).FmasterCardCode = rsget("masterCardCode")
					FItemList(i).FbuyDate = rsget("buyDate")
					FItemList(i).FregDate = rsget("regDate")
					FItemList(i).FcardExpire = rsget("cardExpire")
					FItemList(i).FcardItemid = rsget("cardItemid")
					FItemList(i).FsmallImage = webImgUrl & "/giftcard/small/" & GetImageSubFolderByItemid(rsget("cardItemid")) & "/" & rsget("smallImage")
					FItemList(i).FcardPrice = rsget("cardPrice")
					FItemList(i).FcardStatus = rsget("cardStatus")
					FItemList(i).FCarditemname		= rsget("Carditemname")
					FItemList(i).FcardOptionName	= rsget("cardOptionName")

					rsget.movenext
					i=i+1
				Loop
			end if

			rsget.Close

		End Sub


		'# 기프트카드 사용 내역
		Public Sub myGiftCardLogList()
			Dim i, strSql

			'카운트
			strSql = "exec [db_user].[dbo].sp_Ten_giftCardLogListCnt '" & CStr(FRectUserid) & "'," & FPageSize & ",'" & FRectSiteDiv & "'"
			rsget.CursorLocation = adUseClient
			rsget.CursorType = adOpenStatic
			rsget.LockType = adLockOptimistic
			rsget.Open strSQL, dbget, 1
				FTotalCount = rsget("cnt")
				FTotalPage = rsget("totPg")
			rsget.Close

			'지정페이지가 전체 페이지보다 클 때 함수종료
			if Cint(FCurrPage)>Cint(FTotalPage) then
				FResultCount = 0
				exit sub
			end if

			'내용 접수
			strSql = "exec [db_user].[dbo].sp_Ten_giftCardLogList '" & CStr(FRectUserid) & "'," & FPageSize & "," & FCurrPage & ",'" & FRectSiteDiv & "'"
			rsget.CursorLocation = adUseClient
			rsget.CursorType = adOpenStatic
			rsget.LockType = adLockOptimistic
			rsget.pagesize = FPageSize
			rsget.Open strSQL, dbget, 1

			FResultCount = rsget.recordCount
	
			redim preserve FItemList(FResultCount)

			i=0
			if Not(rsget.EOF or rsget.BOF) then
				do until rsget.EOF
					set FItemList(i) = new myGiftCarditem

					FItemList(i).FuseCash		= rsget("useCash")
					FItemList(i).Fjukyocd		= rsget("jukyocd")
					FItemList(i).Fjukyo			= db2html(rsget("jukyo"))
					FItemList(i).Forderserial	= rsget("OrderSerial")
					FItemList(i).FsiteDiv		= rsget("siteDiv")
					FItemList(i).Fregdate		= rsget("regdate")
					FItemList(i).Fremain        = rsget("remain")

					rsget.movenext
					i=i+1
				Loop
			end if

			rsget.Close

		End Sub

		Private Sub Class_initialize()
		End Sub

		Private Sub Class_Terminate()
		End Sub

		public Function HasPreScroll()
			HasPreScroll = StartScrollPage > 1
		end Function
	
		public Function HasNextScroll()
			HasNextScroll = FTotalPage > StartScrollPage + FScrollCount -1
		end Function
	
		public Function StartScrollPage()
			StartScrollPage = ((FCurrpage-1)\FScrollCount)*FScrollCount +1
		end Function
	End Class

	'// 카드 등록 처리
	Function procGiftCardReg(mcd)
		dim strSql, strChk
		dim giftOrderSerial, cardItemid, cardOption, cardPrice, buyDate

		'등록코드 확인 (전송완료된 코드만)
		strSql = "Select giftOrderSerial, cardItemid, cardOption, totalsum, ipkumdate, jumunDiv, IsNULL(notRegSpendSum,0) as notRegSpendSum " &_
			" From db_order.dbo.tbl_giftcard_order " &_
			" Where masterCardCode='" & mcd & "'" &_
			"	and ipkumDiv>='4' " &_
			"	and cancelYn='N' "
		rsget.Open strSql, dbget, 1

		if rsget.EOF or rsget.BOF then
			procGiftCardReg = "W"			'없는카드 번호
			rsget.close
			Call fnGiftCardRegLog("I", mcd, "W3")	'### 실패 로그저장.
			exit Function
		else
			if rsget("jumunDiv")="7" then
				procGiftCardReg = "R"		'등록된 카드
				rsget.close
				Call fnGiftCardRegLog("I", mcd, "R")	'### 실패 로그저장.
				exit Function
			elseif rsget("jumunDiv")="9" then
				procGiftCardReg = "C"		'취소된 카드
				rsget.close
				Call fnGiftCardRegLog("I", mcd, "C")	'### 실패 로그저장.
				exit Function
			elseif datediff("d",rsget("ipkumdate"),date()) > (365*5) then
				procGiftCardReg = "L"		'유효기간 만료
				rsget.close
				Call fnGiftCardRegLog("I", mcd, "L")	'### 실패 로그저장.
				exit Function
			else
				giftOrderSerial = rsget("giftOrderSerial")
				cardItemid = rsget("cardItemid")
				cardOption = rsget("cardOption")
				cardPrice = rsget("totalsum")-rsget("notRegSpendSum") ''등록전 사용한 잔액 차감.(서동석)
				buyDate = rsget("ipkumdate")
			end if
		end if
	
		rsget.Close

		'' Tran 시작.
		dbget.BeginTrans
		On Error Resume Next

		'등록처리
		strSql = "Insert into db_user.dbo.tbl_giftcard_regList (giftOrderSerial, masterCardCode, cardItemid, cardOption, cardPrice, buyDate, cardExpire, userid, cardStatus)" &_
				" Values " &_
				" ('" & giftOrderSerial & "'" &_
				" ,'" & mcd & "'" &_
				" ,'" & cardItemid & "'" &_
				" ,'" & cardOption & "'" &_
				" ,'" & cardPrice & "'" &_
				" ,'" & formatdatetime(buyDate,2) & " " & formatdatetime(buyDate,4) & "'" &_
				" ,'" & formatdatetime(dateadd("yyyy",5,buyDate),2) & " " & formatdatetime(dateadd("yyyy",5,buyDate),4) & "'" &_
				" ,'" & GetLoginUserID & "'" &_
				" ,'1')"
		dbget.execute(strSql)

		'주문정보 수정 (등록처리)
		strSql = "Update db_order.dbo.tbl_giftcard_order " &_
				" Set jumunDiv='7' " &_
				" where giftOrderSerial='" & giftOrderSerial & "'"
		dbget.execute(strSql)		

		'등록 로그 추가
		strSql = "Insert into db_user.dbo.tbl_giftcard_log (userid, useCash, jukyocd, jukyo, orderserial, reguserid, siteDiv)" &_
				" Values " &_
				" ('" & GetLoginUserID & "'" &_
				" ," & cardPrice &_
				" ,100,'기프트카드 등록'" &_
				" ,'" & giftOrderSerial & "'" &_
				" ,'" & GetLoginUserID & "'" &_
				" ,'T')"
		dbget.execute(strSql)


		'내현황 추가
		strSql = "select count(*) from db_user.dbo.tbl_giftcard_current where userid='" & GetLoginUserID & "'"
		rsget.Open strSql, dbget, 1
			strChk = rsget(0)
		rsget.Close

		if strChk>0 then
			strSql = "Update db_user.dbo.tbl_giftcard_current Set " &_
					"	currentCash = (currentCash + " & cardPrice & ") " &_
					"	,gainCash = (gainCash + " & cardPrice & ") " &_
					"	,lastUpdate = getdate() " &_
					" Where userid='" & GetLoginUserID & "'"
			dbget.execute(strSql)
		else
			strSql = "Insert Into db_user.dbo.tbl_giftcard_current (userid, currentCash, gainCash, lastupdate) values " &_
					" ('" & GetLoginUserID & "'" &_
					" ," & cardPrice &_
					" ," & cardPrice & ",getdate())"
			dbget.execute(strSql)
		end if

        IF (Err) then
		    dbget.RollBackTrans
		    procGiftCardReg = "E"			'처리중 오류발생
		    On Error Goto 0
		    Call fnGiftCardRegLog("I", mcd, "E")	'### 실패 로그저장.
		    Exit Function
		ELSE
		    dbget.CommitTrans
		    procGiftCardReg = cardPrice		'처리 완료(카드금액 반환)
		    On Error Goto 0
		end if
	end Function


	'// 인증번호 확인(주문번호 사용)
	Function getGiftCardMasterCD(osn, byRef resendCnt, byRef oIdx)
		dim strSql, strChk

		'등록코드 확인
		strSql = "Select masterCardCode, ipkumdiv, jumunDiv, ipkumdate, resendCnt, cancelyn, idx " &_
			" From db_order.dbo.tbl_giftcard_order " &_
			" Where giftOrderSerial='" & osn & "'" &_
			"	and cancelYn='N' "
		rsget.Open strSql, dbget, 1

		if rsget.EOF or rsget.BOF then
			getGiftCardMasterCD = "W"			'없는카드 번호
			rsget.close: exit Function
		else
			if rsget("jumunDiv")="1" or rsget("ipkumdiv")<"3" then
				getGiftCardMasterCD = "A"		'결제전 주문
				rsget.close: exit Function
			end if

			if rsget("jumunDiv")="7" then
				getGiftCardMasterCD = "R"		'등록된 카드
				rsget.close: exit Function
			end if

			if rsget("jumunDiv")="9" or rsget("ipkumdiv")="9" or rsget("cancelyn")="Y" then
				getGiftCardMasterCD = "C"		'취소 주문
				rsget.close: exit Function
			end if

			if datediff("d",rsget("ipkumdate"),date()) > (365*5) then
				getGiftCardMasterCD = "E"		'유효기간 만료
				rsget.close: exit Function
			end if

			if rsget("resendCnt")>=2 then
				getGiftCardMasterCD = "O"		'재전송 횟수 초과
				rsget.close: exit Function
			end if
		end if
	
		oIdx = rsget("idx")									'// 주문 일련번호 반환
		resendCnt = rsget("resendCnt")						'// 재전송 횟수 반환
		getGiftCardMasterCD = rsget("masterCardCode")		'// 인증번호 반환

		rsget.Close

	end Function

	'// 기프트카드 인증번호 발급 로그 저장
	sub putGiftCardMasterCDLog(osn,mcd,sh)
		dim strSql
		strSql = "Insert into db_order.dbo.tbl_giftcard_cdLog " &_
				"(giftOrderSerial, masterCardCode, shiftNum) values " &_
				"('" & osn & "', '" & mcd & "'," & sh & ")"
		dbget.Execute strSql
	end sub

	'// 재발송 정보 저장(인증번호 변경)
	sub chgOrderInfoResendMasterCD(osn,mcd)
		dim strSql
		strSql = "Update db_order.dbo.tbl_giftcard_order Set " &_
				"	masterCardCode='" & mcd & "' " &_
				"	,jumunDiv='5' " &_
				"	,resendCnt=resendCnt+1 " &_
				"Where giftOrderSerial='" & osn & "'"
		dbget.Execute strSql
	end sub

	'// 실코드접수(+중복등록검사)
	function getMasterCode_OLD(no,sz,byRef sh)
		dim strSql, blChk
		blChk = false
		if sh="" then sh=0
		do Until blChk
			if (sz-sh-1)<=0 then blChk=true
			strSql = "Select count(idx) from db_order.dbo.tbl_giftcard_cdLog Where masterCardCode='" & makeMasterCode(no,sz,sh) & "'"
			rsget.Open strSql, dbget, 1
				if rsget(0)<=0 then
					blChk=true
					getMasterCode_OLD = makeMasterCode(no,sz,sh)
				end if
			rsget.Close
			sh = sh +1
		loop
	end function
    
    '// 실코드접수(+중복등록검사)
	function getMasterCode(no,sz,byRef sh)
		dim strSql, blChk, bufCode
		blChk = false
		if sh="" then sh=0
		do Until blChk
			if (sz-sh-1)<=0 then blChk=true
			bufCode = makeMasterCode(no,sz,sh)
			strSql = "Select count(idx) from db_order.dbo.tbl_giftcard_cdLog Where masterCardCode='" & bufCode & "'"
			rsget.Open strSql, dbget, 1
				if rsget(0)<=0 then
					IF Not(Left(bufCode,4)="1010" or Left(bufCode,4)="6979") THEN ''preFix 와 중복안되게. (1010: Point1010회원카드, 6979: 실물카드)
					    blChk=true
					    getMasterCode = bufCode
					END IF
				end if
			rsget.Close
			sh = sh +1
		loop
	end function

    '// 실물카드용 코드 접수(+중복등록검사)
	function getMasterCodeOff(no,sz,byRef sh)
		dim strSql, blChk, bufCode, tmpChk, i
		blChk = false
		if sh="" then sh=0
		do Until blChk
			if (sz-sh-1)<=0 then blChk=true
			bufCode = "6979" & makeMasterCode(no,sz-5,sh)

			'검증코드 생성
			for i=1 to Len(bufCode)
				tmpChk = tmpChk + (mid(bufCode,i,1) * i)
			next
			tmpChk = right(tmpChk\Len(bufCode),1)
			bufCode = bufCode & tmpChk

			strSql = "Select count(masterCardCode) from db_order.dbo.tbl_giftcard_offMasterCd Where masterCardCode='" & bufCode & "'"
			rsget.Open strSql, dbget, 1
				if rsget(0)<=0 then
				    blChk=true
				    getMasterCodeOff = bufCode
				end if
			rsget.Close
			sh = sh +1
		loop
	end function

	'// 코드생성(일련번호, 코드길이, 중복시프트 / MD5필요)
	function makeMasterCode(no,sz,sh)
		dim tmpMD, tmpNo, tmpChk, i

		'길이 검사
		if (sz>32) or ((31-sz)<sh) then
			makeMasterCode = string(sz,"0")
			exit Function
		end if

		'숫자코드 생성
		tmpMD = MD5(no)
		for i=1 to Len(tmpMD)
			if mid(tmpMD,i,1)>="0" and mid(tmpMD,i,1)<="9" then
				tmpNo = tmpNo & mid(tmpMD,i,1)
			else
				tmpNo = tmpNo & ASC(mid(tmpMD,i,1)) mod 10
			end if
		next

		tmpNo = left(right(tmpNo,len(tmpNo)-sh),sz-1)
		
		'검증코드 생성
		for i=1 to Len(tmpNo)
			tmpChk = tmpChk + (mid(tmpNo,i,1) * i)
		next
		tmpChk = right(tmpChk\Len(tmpNo),1)
		
		'결과 반환
		makeMasterCode = tmpNo & tmpChk
	end function

	'// 코드 유효성 검사
	function chkMasterCode(cd)
		dim tmpChk, i

		if cd="" or len(cd)<=1 then
			chkMasterCode=false
			exit function
		end if

		for i=1 to Len(cd)-1
			tmpChk = tmpChk + (mid(cd,i,1) * i)
		next
		tmpChk = right(tmpChk\(Len(cd)-1),1)

		if tmpChk=right(cd,1) then
			chkMasterCode = true
		else
			chkMasterCode = false
		end if
	end function

	'// 재전송 횟수 반환
	Function getGiftCardSMSsendcnt(osn)
		dim strSql, tmp
		strSql = "Select masterCardCode, ipkumdiv, jumunDiv, ipkumdate, resendCnt, cancelyn, idx " &_
			" From db_order.dbo.tbl_giftcard_order " &_
			" Where giftOrderSerial='" & osn & "'" &_
			"	and cancelYn='N' "
		rsget.CursorLocation = adUseClient
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly

		if not rsget.EOF then
			tmp = rsget("resendCnt")
		else
			tmp = 0
		end if
		rsget.Close
		
		getGiftCardSMSsendcnt = tmp
	end Function
	
	
	Function fnGiftCardRegLog(g, mcd, rcode)
		Dim sqlStr, refip
		refip = request.ServerVariables("REMOTE_ADDR")
		If g = "I" Then
			sqlStr = "INSERT INTO [db_log].[dbo].[tbl_giftcard_reg_log](searchuid, searchcardno, resultcode, refip) " & _
					 "VALUES('" & getEncLoginUserID() & "', '" & mcd & "', '" & rcode & "', '" & refip & "')"
			dbget.Execute(sqlStr)
		End IF
	End Function
%>
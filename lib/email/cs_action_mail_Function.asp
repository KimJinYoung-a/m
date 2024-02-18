<%
'//+++	외부 서버 메일발송 	+++//
Function SendCsActionMail(id)

    dim oCsAction,strMailHTML,strMailTitle
	Set oCsAction = New CsActionMailCls
	strMailHTML = oCsAction.makeMailTemplate(id)
	strMailTitle = "[텐바이텐]"& oCsAction.FCustomerName & "님께서 요청하신 ["& oCsAction.GetAsDivCDName &"] 처리가 "& oCsAction.FCurrStateName &" 되었습니다."

	'//=======  메일 발송 =========/
	dim oMail
	dim MailHTML

	set oMail = New MailCls

	IF oCsAction.FBuyEmail<>"" THEN

		oMail.MailTitles	= strMailTitle
		oMail.SenderNm		= "텐바이텐"
		oMail.SenderMail	= "mailzine@10x10.co.kr"
		oMail.AddrType		= "string"
		oMail.ReceiverNm	= oCsAction.FCustomerName
		oMail.ReceiverMail	= oCsAction.FBuyEmail
		oMail.MailConts 	= strMailHTML

		''oMail.Send_Mailer()
		oMail.Send_CDO()

	End IF

	SET oMail = nothing

    Set oCsAction = Nothing

End Function


CLASS MailCls

	dim MailTitles		'메일 제목
	dim MailConts		'메일 내용 			(text/html)
	dim SenderMail		'메일 발송자 주소 	(customer@10x10.co.kr,mailzine@10x10.co.kr)
	dim SenderNm		'메일 발송자이름 	(텐바이텐)

	dim MailType		'템플릿 번호 		([4],5,6,7,8,9)

	dim ReceiverNm		'메일 수신자 이름 	($1)
	dim ReceiverMail	'메일 수신자 주소 	(xxxx@aaa.com..)


	dim AddrType				'메일수집 방식 (event,userid)
	dim arrUserId 				'AddrType ="userid" 일경우 사용

	dim AddrString				'메일주소 수집에 쓰일 정보
	dim EvtCode,EvtGroupCode 	'AddrType ="event" 일경우 사용


	dim strQuery 		'이메일 정보 수집 쿼리
	dim EmailDataType	'이메일 정보 수집 방식 (Enum : string - 직접 입력,sql - 쿼리 이용)
	Dim DB_ID 			'선더메일 디비연결 번호 - 고정 (실서버- 4 ; 테스트- 5)


	Private Sub Class_Initialize()
		EvtCode =0
		EvtGroupCode =0
		EmailDataType = "sql"
		MailType = 5

		IF application("Svr_Info")="Dev" THEN
			DB_ID = "5" '//(실서버- 4 ; 테스트- 5)
		ELSE
			DB_ID = "4"
		END IF
		SenderMail	= "mailzine@10x10.co.kr"
		SenderNm	= "텐바이텐"

	End Sub
	
	Private Sub Class_Terminate()

	End Sub

	Public Function Send_CDO()
		dim ArrMailList,intP,ret
	
		ret = fnMakeCdoQuery(ArrMailList)
	
		IF ret < 0 Then
			'response.write "주소 처리 에러"
			Exit Function
		End IF
	
		dim cdoMessage,cdoConfig
	
		'On Error Resume Next
	
		IF isArray(ArrMailList) Then
			For intP=0 To Ubound(ArrMailList,2)
				Set cdoConfig = Server.CreateObject("CDO.Configuration")
				'-> 서버 접근방법을 설정합니다
				cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2 '1 - (cdoSendUsingPickUp)  2 - (cdoSendUsingPort)
				'-> 서버 주소를 설정합니다(dns or ip)-(localhost or 110.93.128.94)
				cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver")="110.93.128.94"
				'-> 접근할 포트번호를 설정합니다
				cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
				'-> 접속시도할 제한시간을 설정합니다
				cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 5
				'-> SMTP 접속 인증방법을 설정합니다
				cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
				'-> SMTP 서버에 인증할 ID를 입력합니다
				cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = "MailSendUser"
				'-> SMTP 서버에 인증할 암호를 입력합니다
				cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = "wjddlswjddls"
				cdoConfig.Fields.Update
	
				Set cdoMessage = CreateObject("CDO.Message")
				Set cdoMessage.Configuration = cdoConfig
	
	
				cdoMessage.To 		= ArrMailList(1,intP) &"<"& ArrMailList(0,intP) &">"
				cdoMessage.From 	= SenderNm &"<"& SenderMail &">"
				cdoMessage.SubJect 	= MailTitles
	            
				'메일 내용이 텍스트일 경우 cdoMessage.TextBody, html일 경우 cdoMessage.HTMLBody
				cdoMessage.HTMLBody	= MailConts
				
				cdoMessage.BodyPart.Charset="ks_c_5601-1987"		'// 한글을 위해선 꼭 넣어 주어야 합니다.
				cdoMessage.HTMLBodyPart.Charset="ks_c_5601-1987"	'// 한글을 위해선 꼭 넣어 주어야 합니다.
				'cdoMessage.BodyPart.Charset="utf-8"		'// 한글을 위해선 꼭 넣어 주어야 합니다.
				'cdoMessage.HTMLBodyPart.Charset="utf-8"	'// 한글을 위해선 꼭 넣어 주어야 합니다.
				
				cdoMessage.Send
	            
				Set cdoMessage = nothing
				Set cdoConfig = nothing
			Next
		End IF
	
		IF Err.Number =0 THEN
			'response.write "메일 발송 성공_Send_CDO<br>"
		ELSE
			'response.write "메일 발송 실패_Send_CDO<br>"
		END IF
	
	End Function
	
	'// cdo 관련 주소 반환
	
	Public Function fnMakeCdoQuery(byref iArr)
	
		dim tmpAddrType , tmpString
	
		dim tmpVar , tmpVar2 , intLp
	
		dim tmpQuery,tmpArrList()
	
		On Error Resume Next
	
		tmpAddrType = AddrType
		tmpString = AddrString
	
		tmpVar = fnReArr(tmpString,",")
	
		IF tmpAddrType = "userid" THEN '// 아이디 배열 입력
	
			IF tmpVar = "" Then
				Err.Number = Err.Number - 1
			End IF
	
			tmpVar = replace(tmpVar,",","','")
			tmpVar = "'" & tmpVar & "'"
	
			tmpQuery = " SELECT UMail, UName FROM db_user.dbo.vw_UserMailList WHERE Uid in (" & tmpVar & ")"

			rsget.open tmpQuery , dbget , 2
			IF not rsget.eof Then
				iArr = rsget.getRows()
			End IF
			rsget.close
	
		ELSEIF tmpAddrType ="string" Then '// 이름 주소 하나만 처리
	
			IF ReceiverMail="" Then
				Err.Number = Err.Number - 1
			End IF
	
			Redim iArr(1,0)
			iArr(0,0) = ReceiverMail
			iArr(1,0) = ReceiverNm
	
		ELSEIF tmpAddrType ="array" Then '// 이름 & 주소 입력 규칙입력
			IF tmpVar = "" Then
				Err.Number = Err.Number - 1
			End IF
			tmpVar = fnReArr(tmpVar,",")
			tmpVar = Split(tmpVar,",")
	
			IF isArray(tmpVar) Then
	
				Redim iArr(1,Ubound(tmpVar))
				For intLp=0 To Ubound(tmpVar)
					tmpVar2 = tmpVar(intLp)
	
					IF instr(tmpVar2,"$")>0 Then
						iArr(0,intLp) = Left(tmpVar2,instr(tmpVar2,"$")-1)
						iArr(1,intLp) = Right(tmpVar2,len(tmpVar2)-instr(tmpVar2,"$"))
					ELSE
						iArr(0,intLp) = tmpVar2
						iArr(1,intLp) = ""
					End IF
				Next
			End IF
		End IF
		IF Err.Number=0 Then
			fnMakeCdoQuery = 0
		ELSE
			fnMakeCdoQuery = -1
		End IF
	
	
	End Function
	
	Public Function fnReArr(byval strVar,byval strChk)

		'// 구분자로 넘어온 값 strChk 체크후 반환
		'// 반환된 값은 "," 로 구분됨

		dim tmpVar , tmpArrVar , intLp

		IF strVar="" or strChk="" Then '넘어온 값 체크 (없거나 잘못된 값이 넘어오면 끝내기)
			Exit Function
		ELSE
			tmpArrVar = trim(strVar)
			tmpArrVar = split(tmpArrVar,strChk)

			IF Ubound(tmpArrVar) < 0 Then Exit Function

			For intLp=0 to Ubound(tmpArrVar)
				IF tmpArrVar(intLp)<>"" Then
					tmpVar = (tmpVar & tmpArrVar(intLp) & ",")
				END IF
			Next
			tmpVar = Left(tmpVar,Len(tmpVar)-1)
		END IF
		fnReArr = tmpVar

	End Function
	
End CLASS


CLASS CsActionMailCls

	Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub

	Dim FAsID
	Dim FDivCD
	Dim FGubun01
	Dim FGubun02

	Dim FDivCDName
	Dim FGubun01Name
	Dim FGubun02Name

	Dim FOrderSerial
	Dim FCustomerName
	Dim FUserid
	Dim FBuyHP
	Dim FBuyEmail
	Dim FWriteUser
	Dim FFinishUser
	Dim FTitle
	Dim FContents_jupsu
	Dim FContents_finish
	Dim FCurrstate
	Dim FCurrstateName
	Dim FRegDate
	Dim FFinishDate

	Dim FDeleteyn
	Dim FExtSiteName

	Dim FOpenTitle
	Dim FOpenContents

	Dim FSiteGubun

	Dim FSongjangDiv
	Dim FSongjangNo
	Dim FSongjangDivName

	Dim FRequireUpche
	Dim FMakerid

	Dim FAdd_upchejungsanDeliveryPay
	Dim FAdd_upchejungsanCause

	Dim FOrgSubTotalPrice
	Dim FOrgItemCostSum
	Dim FOrgBeasongPay
	Dim FOrgMileageSum
	Dim FOrgCouponSum
	Dim FOrgAllatDiscountSum

	Dim FRefundRequire
	Dim FRefundResult
	Dim FReturnMethod

	Dim FRefundMileageSum
	Dim FRefundCouponSum
	Dim FAllatSubTractSum

	Dim FRefundItemCostSum
	Dim FRefundBeasongPay
	Dim FRefundDeliveryPay
	Dim FRefundAdjustPay
	Dim FCancelTotal

	Dim FReturnName
	Dim FReturnPhone
	Dim FReturnHP
	Dim FReturnZipCode
	Dim FReturnZipAddr
	Dim FReturnEtcAddr


	Dim FReBankName
	Dim FReBankAccount
	Dim FReBankOwnerName
	Dim FPayGateTid

	Dim FPayGateResultTid
	Dim FPayGateResultMsg

	Dim FReturnMethodName

	Dim FReqName
	Dim FReqPhone
	Dim FReqHP
	Dim FReqZipcode
	Dim FReqZipAddr
	Dim FReqEtcAddr
	Dim FReqEtcStr
    Dim FInfoHtml

    Dim FupcheReturnSongjangDivName
    Dim FupcheReturnSongjangDivTel

	Dim FSendDate

	Dim FResultCount

    Dim FRectForceCurrState     ''상태값 강제 지정.
    Dim FRectForceBuyEmail      ''이메일 강제지정.

 	public function GetAsDivCDName()
        GetAsDivCDName = db2html(FDivCDName)
	end function

	public function GetCauseDetailString()
        GetCauseDetailString = Fgubun02Name
    end function

	Public Sub GetOneCSASMaster(FRectCsAsID)

		dim strSQL
		strSQL =" SELECT TOP 1 " &_
				" 	A.ID ,A.DivCD ,A.Gubun01 ,A.Gubun02 ,A.OrderSerial ,A.CustomerName ,A.Userid ,A.WriteUser ,A.FinishUser " &_
				"	,A.Title ,A.Contents_Jupsu ,A.Contents_Finish ,A.CurrState ,A.RegDate ,A.FinishDate ,A.Deleteyn ,A.ExtSiteName "&_
				"	,A.OpenTitle ,A.OpenContents ,A.RequireUpche ,A.Makerid ,A.SongjangDiv ,A.SongjangNo ,A.SiteGubun "&_
				"	,(SELECT TOP 1 divname FROM db_order.dbo.tbl_songjang_div WHERE divcd=A.SongjangDiv) AS SongjangDivName " &_
				" 	,o.BuyHp,o.BuyEmail " &_
				" 	,(SELECT TOP 1 comm_name FROM db_cs.dbo.tbl_cs_comm_code WHERE comm_cd=A.divCD) as divcdname " &_
				" 	,(SELECT TOP 1 comm_name FROM db_cs.dbo.tbl_cs_comm_code WHERE comm_cd=A.gubun01) as gubun01name " &_
				" 	,(SELECT TOP 1 comm_name FROM db_cs.dbo.tbl_cs_comm_code WHERE comm_cd=A.gubun02) as gubun02name "
		IF (FRectForceCurrState<>"") then
		    strSQL = strSQL & "  ,(SELECT TOP 1 comm_name FROM db_cs.dbo.tbl_cs_comm_code WHERE comm_cd='"&FRectForceCurrState&"') as currstatename "
        ELSE
            strSQL = strSQL & "  ,(SELECT TOP 1 comm_name FROM db_cs.dbo.tbl_cs_comm_code WHERE comm_cd=A.currstate) as currstatename "
        END IF

		strSQL = strSQL & " 	,IsNULL(J.add_upchejungsandeliverypay,0) as add_upchejungsandeliverypay , J.add_upchejungsancause " &_

				" 	,r.OrgSubTotalPrice,r.OrgItemCostSum,r.OrgBeasongPay,r.OrgMileageSum,r.OrgCouponSum,r.OrgAllatDiscountSum "&_
				" 	,IsNULL(r.RefundRequire,0) as RefundRequire ,isNULL(r.RefundResult,0) as RefundResult "&_
				"	,r.ReturnMethod,r.RefundMileageSum,r.RefundCouponSum,r.AllatSubTractSum "&_
				"	,r.RefundItemCostSum,r.RefundBeasongPay,r.RefundDeliveryPay,r.RefundAdjustPay,r.CancelTotal "&_
				" 	,r.RebankName ,r.RebankAccount ,r.RebankOwnerName ,r.PayGateTid " &_
				" 	,r.paygateresultTid,r.PayGateResultMsg " &_
				" 	,(SELECT top 1 comm_name FROM db_cs.dbo.tbl_cs_comm_code WHERE comm_cd=r.returnmethod and comm_group='Z090') as ReturnMethodName " &_

				" 	,IsNULL(D.ReqName,o.reqname) as ReqName ,IsNULL(D.ReqPhone,o.reqphone) as ReqPhone ,IsNULL(D.ReqHP,o.reqhp) as ReqHP " &_
				" 	,IsNULL(D.ReqZipcode,o.reqzipcode) as ReqZipcode ,IsNULL(D.ReqZipAddr,o.reqzipaddr) as ReqZipAddr ,IsNULL(D.ReqEtcAddr,o.reqaddress) as ReqEtcAddr ,IsNULL(D.ReqEtcStr,'') as ReqEtcStr " &_
				" 	,isNull(p.company_name,'(주)텐바이텐') as ReturnName ,isNull(p.deliver_phone,'1644-6030') as ReturnPhone ,isNull(p.deliver_hp,'') as ReturnHP "&_
				" 	,isNull(p.return_zipcode,'132-010') as ReturnZipCode ,isNull(p.return_address,'서울 도봉구') as ReturnZipAddr ,isNull(p.return_address2,'도봉동 63번지 여인닷컴 3층') as ReturnEtcAddr "&_
                " 	,isNull((SELECT TOP 1 divname FROM db_order.dbo.tbl_songjang_div WHERE divcd=p.defaultsongjangdiv),'') as upcheReturnSongjangDivName "&_
                " 	,isNull((SELECT TOP 1 tel FROM db_order.dbo.tbl_songjang_div WHERE divcd=p.defaultsongjangdiv),'') as upcheReturnSongjangDivTel "&_

				" FROM [db_cs].[dbo].tbl_new_as_list A " &_
				" LEFT JOIN db_order.dbo.tbl_order_master o " &_
				" 	on A.orderserial=o.orderserial " &_
				" LEFT JOIN [db_cs].[dbo].tbl_as_upcheAddjungsan J " &_
				" 	on A.id=J.asid " &_
				" LEFT JOIN [db_cs].[dbo].tbl_as_refund_info r " &_
				" 	on A.id=r.asid " &_
				" LEFT JOIN [db_cs].[dbo].tbl_new_as_delivery d " &_
				" 	on A.id = d.asid " &_
				" LEFT JOIN [db_partner].[dbo].tbl_partner p " &_
				" 	on A.makerid= p.id " &_
				" WHERE A.id=" & CStr(FRectCsAsID)

			rsget.Open strSQL, dbget, 1

	        FResultCount = rsget.RecordCount

	        if  not rsget.EOF  then
	        	'//GetOneCSASMaster
				FAsID		= rsget("ID")
				FDivCD	= rsget("divCD")
				FGubun01	= rsget("gubun01")
				FGubun02	= rsget("gubun02")

				FDivCDName	= rsget("divcdname")
				FGubun01Name	= rsget("gubun01name")
				FGubun02Name	= rsget("gubun02name")

				FOrderSerial	= rsget("orderserial")
				FCustomerName	= rsget("customername")
				FUserid	= rsget("userid")
				FWriteUser	= rsget("writeuser")
				FFinishUser	= rsget("finishuser")
				FBuyHP		= rsget("BuyHP")
				FBuyEmail	= rsget("BuyEmail")

				if (FRectForceBuyEmail<>"") then
				    FBuyEmail = FRectForceBuyEmail
				end if

				FTitle	= rsget("title")
				FContents_jupsu	= rsget("contents_jupsu")
				FContents_finish	= rsget("contents_finish")

				IF (FRectForceCurrState<>"") then  ''상태값 강제 지정 (메일 재발송시 사용.)
				    FCurrState = FRectForceCurrState
				ELSE
    				FCurrState	= rsget("currstate")
    			END IF
				FCurrStateName	= db2html(rsget("currstatename"))
				FRegDate	= rsget("regdate")
				FFinishDate	= rsget("finishdate")

				FDeleteyn	= rsget("Deleteyn")
				FExtSiteName	= rsget("ExtSiteName")

				FOpenTitle	= rsget("OpenTitle")
				FOpenContents	= rsget("OpenContents")

				FSiteGubun	= rsget("SiteGubun")

				FSongjangDiv	= rsget("SongjangDiv")
				FSongjangNo	= rsget("SongjangNo")
				FSongjangDivName = rsget("SongjangDivName")
				FRequireUpche	= rsget("RequireUpche")
				FMakerid	= rsget("Makerid")

				FAdd_upchejungsanDeliveryPay	= rsget("Add_upchejungsanDeliveryPay")
				FAdd_upchejungsanCause	= rsget("Add_upchejungsanCause")

				'//GetOneRefundInfo
				FOrgSubTotalPrice	= rsget("OrgSubTotalPrice")
				FOrgItemCostSum	= rsget("OrgItemCostSum")
				FOrgBeasongPay	= rsget("OrgBeasongPay")
				FOrgMileageSum	= rsget("OrgMileageSum")
				FOrgCouponSum	= rsget("OrgCouponSum")
				FOrgAllatDiscountSum	= rsget("OrgAllatDiscountSum")
				FRefundRequire	= rsget("RefundRequire")
				FRefundResult	= rsget("RefundResult")
				FReturnMethod	= rsget("ReturnMethod")
				FRefundMileageSum	= rsget("RefundMileageSum")
				FRefundCouponSum	= rsget("RefundCouponSum")
				FRefundItemCostSum	= rsget("RefundItemCostSum")
				FRefundBeasongPay	= rsget("RefundBeasongPay")
				FRefundDeliveryPay	= rsget("RefundDeliveryPay")
				FRefundAdjustPay	= rsget("RefundAdjustPay")

				FAllatSubTractSum	= rsget("AllatSubTractSum")
				FCancelTotal	= rsget("CancelTotal")

				FReBankName	= rsget("ReBankName")
				FReBankAccount	= rsget("ReBankAccount")
				FReBankOwnerName	= rsget("ReBankOwnerName")
				FPayGateTid	= rsget("PayGateTid")

				FPayGateResultTid	= rsget("PayGateResultTid")
				FPayGateResultMsg	= rsget("PayGateResultMsg")

				FReturnMethodName	= rsget("ReturnMethodName")

				'//GetReturnAddress
				FReturnName	= rsget("ReturnName")
				FReturnPhone	= rsget("ReturnPhone")
				FReturnHP	= rsget("ReturnHP")
				FReturnZipCode	= rsget("ReturnZipCode")
				FReturnZipAddr	= rsget("ReturnZipAddr")
				FReturnEtcAddr	= rsget("ReturnEtcAddr")

				FReqName	= rsget("ReqName")
				FReqPhone	= rsget("ReqPhone")
				FReqHP		= rsget("ReqHP")
				FReqZipcode	= rsget("ReqZipcode")
				FReqZipAddr	= rsget("ReqZipAddr")
				FReqEtcAddr	= rsget("ReqEtcAddr")
				FReqEtcStr	= rsget("ReqEtcStr")

                FupcheReturnSongjangDivName = db2html(rsget("upcheReturnSongjangDivName"))
                FupcheReturnSongjangDivTel  = db2html(rsget("upcheReturnSongjangDivTel"))
			END IF
		rsget.close

		''기타 안내 사항
		if (FDivCD<>"") and ((FCurrState="B001") or (FCurrState="B007")) then
		    strSQL = " SELECT TOP 1 IsNULL(infoHtml,'') as infoHtml from db_cs.dbo.tbl_cs_comm_div_info"
		    strSQL = strSQL + " where div_comm_cd='" + FDivCD + "'"
		    strSQL = strSQL + " and state_comm_cd='" + FCurrState + "'"

		    rsget.Open strSQL, dbget, 1
		    if  not rsget.EOF  then
		        FInfoHtml = db2Html(rsget("infoHtml"))
		    end if
		    rsget.Close
		end if
	End Sub
	''// 메일 헤더 이미지
	Public Function getMailHeadImage()
		dim tmpImg
		IF FDivCD="A000" Then '// 맞교환출고
			IF FCurrState="B001" Then
				tmpImg = "<img src=""http://fiximage.10x10.co.kr/web2008/mail/csmail_top_a000_01.gif"" width=""586"" height=""240"" border=""0"">"
			ELSEIF FCurrState="B007" Then
				tmpImg = "<img src=""http://fiximage.10x10.co.kr/web2008/mail/csmail_top_a000_07.gif"" width=""586"" height=""240"" border=""0"">"
			End IF
		ELSEIF FDivCD="A001" Then '// 누락재발송
			IF FCurrState="B001" Then
				tmpImg = "<img src=""http://fiximage.10x10.co.kr/web2008/mail/csmail_top_a001_01.gif"" width=""586"" height=""240"" border=""0"">"
			ELSEIF FCurrState="B007" Then
				tmpImg = "<img src=""http://fiximage.10x10.co.kr/web2008/mail/csmail_top_a001_07.gif"" width=""586"" height=""240"" border=""0"">"
			End IF
		ELSEIF FDivCD="A002" Then '// 서비스발송
			IF FCurrState="B001" Then
				tmpImg = "<img src=""http://fiximage.10x10.co.kr/web2008/mail/csmail_top_a002_01.gif"" width=""586"" height=""240"" border=""0"">"
			ELSEIF FCurrState="B007" Then
				tmpImg = "<img src=""http://fiximage.10x10.co.kr/web2008/mail/csmail_top_a002_07.gif"" width=""586"" height=""240"" border=""0"">"
			End IF
		ELSEIF FDivCD="A003" Then '// 환불요청
			IF FCurrState="B001" Then
				tmpImg = "<img src=""http://fiximage.10x10.co.kr/web2008/mail/csmail_top_a003_01.gif"" width=""586"" height=""240"" border=""0"">"
			ELSEIF FCurrState="B007" Then
				tmpImg = "<img src=""http://fiximage.10x10.co.kr/web2008/mail/csmail_top_a003_07.gif"" width=""586"" height=""240"" border=""0"">"
			End IF
		ELSEIF FDivCD="A004" Then '// 반품접수(업)
			IF FCurrState="B001" Then
				tmpImg = "<img src=""http://fiximage.10x10.co.kr/web2008/mail/csmail_top_a004_01.gif"" width=""586"" height=""240"" border=""0"">"
			ELSEIF FCurrState="B007" Then
				tmpImg = "<img src=""http://fiximage.10x10.co.kr/web2008/mail/csmail_top_a004_07.gif"" width=""586"" height=""240"" border=""0"">"
			End IF
		ELSEIF FDivCD="A007" Then '// 신용/이체취소
			IF FCurrState="B001" Then
				tmpImg = "<img src=""http://fiximage.10x10.co.kr/web2008/mail/csmail_top_a007_01.gif"" width=""586"" height=""240"" border=""0"">"
			ELSEIF FCurrState="B007" Then
				tmpImg = "<img src=""http://fiximage.10x10.co.kr/web2008/mail/csmail_top_a007_07.gif"" width=""586"" height=""240"" border=""0"">"
			End IF
		ELSEIF FDivCD="A008" Then '// 주문취소
			IF FCurrState="B001" Then
				'tmpImg = "<img src=""http://fiximage.10x10.co.kr/web2008/mail/csmail_top_a008_01.gif"" width=""586"" height=""240"" border=""0"">"
			ELSEIF FCurrState="B007" Then
				tmpImg = "<img src=""http://fiximage.10x10.co.kr/web2008/mail/csmail_top_a008_07.gif"" width=""586"" height=""240"" border=""0"">"
			End IF
		ELSEIF FDivCD="A010" Then '// 회수신청(텐)
			IF FCurrState="B001" Then
				tmpImg = "<img src=""http://fiximage.10x10.co.kr/web2008/mail/csmail_top_a010_01.gif"" width=""586"" height=""240"" border=""0"">"
			ELSEIF FCurrState="B007" Then
				tmpImg = "<img src=""http://fiximage.10x10.co.kr/web2008/mail/csmail_top_a010_07.gif"" width=""586"" height=""240"" border=""0"">"
			End IF
		ELSEIF FDivCD="A011" Then '// 맞교환회수(텐)
			IF FCurrState="B001" Then
				tmpImg = "<img src=""http://fiximage.10x10.co.kr/web2008/mail/csmail_top_a011_01.gif"" width=""586"" height=""240"" border=""0"">"
			ELSEIF FCurrState="B007" Then
				tmpImg = "<img src=""http://fiximage.10x10.co.kr/web2008/mail/csmail_top_a011_07.gif"" width=""586"" height=""240"" border=""0"">"
			End IF
		ELSEIF FDivCD="A900" Then '// 주문내역변경
			IF FCurrState="B001" Then
				'tmpImg = "<img src=""http://fiximage.10x10.co.kr/web2008/mail/csmail_top_a011_01.gif"" width=""586"" height=""240"" border=""0"">"
			ELSEIF FCurrState="B007" Then
				tmpImg = "<img src=""http://fiximage.10x10.co.kr/web2008/mail/csmail_top_a900_07.gif"" width=""586"" height=""240"" border=""0"">"
			End IF
		ELSE

		END IF
		getMailHeadImage = tmpImg
	End Function



	'// 기타 안내사항
	Public Function getEtcNotice()
		dim tmpHTML

        getEtcNotice = ""

        if (Trim(FInfoHtml)="") then Exit function

		tmpHTML=tmpHTML&"<!-- 기타안내사항 START --> " & vbcrlf
		tmpHTML=tmpHTML&"		<table width=""100%"" border=""0"" cellspacing=""0"" cellpadding=""0"">" & vbcrlf
		tmpHTML=tmpHTML&"		<tr>" & vbcrlf
		tmpHTML=tmpHTML&"			<td class=""sky12pxb"" style=""padding:10 0 5 0;"">*기타안내사항</td>" & vbcrlf
		tmpHTML=tmpHTML&"		</tr>" & vbcrlf
		tmpHTML=tmpHTML&"		<tr>" & vbcrlf
		tmpHTML=tmpHTML&"			<td class=""black12px"" style=""padding:5px;"" bgcolor=""#99CCCC"">" & vbcrlf

		tmpHTML=tmpHTML&" 				"& FInfoHtml & vbcrlf

		tmpHTML=tmpHTML&"			</td> " & vbcrlf
		tmpHTML=tmpHTML&"		</tr> " & vbcrlf
		tmpHTML=tmpHTML&"		</table>" & vbcrlf
		tmpHTML=tmpHTML&"<!-- 기타안내사항 END --> " & vbcrlf


		getEtcNotice = tmpHTML
	End Function

	''// 택배 정보 가져오기
	Function getDlvInfo()
		dim tmpHTML
		tmpHTML=""

        if (IsNULL(FSongjangNo)) or (FSongjangNo="") then Exit function

		IF FDivCD="A000" or FDivCD="A001" or FDivCD="A002" or FDivCD="A004" or FDivCD="A010" or FDivCD="A011" THEN
			tmpHTML=tmpHTML&"<!-- 택배정보 시작 --> " & vbcrlf
			tmpHTML=tmpHTML&"		<table width=""100%"" border=""0"" cellpadding=""0"" cellspacing=""0""> " & vbcrlf
			tmpHTML=tmpHTML&"		<tr> " & vbcrlf
			tmpHTML=tmpHTML&"			<td width=""100"" height=""22"" align=""center"" bgcolor=""#f7f7f7"" class=""black12pxb"" style=""padding-top:2px;"">택배정보</td> " & vbcrlf
			tmpHTML=tmpHTML&"			<td class=""black12px"" style=""padding-left:10px;padding-top:2px;""> " & vbcrlf
						IF FSongjangNo<>"" then
							tmpHTML=tmpHTML& FSongjangDivName &" &nbsp;"& FSongjangNo &"&nbsp;"& vbcrlf
							tmpHTML=tmpHTML& "<a href="""& DeliverDivTrace(Trim(FSongjangDiv)) & FSongjangNo &""" target=""_blank"">>>추적하기</a> " & vbcrlf
						ELSE
							IF FDivCD = "A004" THEN
								tmpHTML=tmpHTML&" 				택배정보가 등록되지 않았습니다.<!-- >>택배정보등록 --> " & vbcrlf
							ELSE
								tmpHTML=tmpHTML&"				택배정보가 등록되지 않았습니다. " & vbcrlf
							END IF
						END IF
			tmpHTML=tmpHTML&"			</td> " & vbcrlf
			tmpHTML=tmpHTML&"		</tr> " & vbcrlf
			tmpHTML=tmpHTML&"		<tr> " & vbcrlf
			tmpHTML=tmpHTML&"			<td height=""1"" colspan=""2"" bgcolor=""#cccccc""></td> " & vbcrlf
			tmpHTML=tmpHTML&"		</tr> " & vbcrlf
			tmpHTML=tmpHTML&"		</table> " & vbcrlf
			tmpHTML=tmpHTML&"<!-- 택배 정보 끝 --> " & vbcrlf
		END IF

		getDlvInfo =  tmpHTML

	END Function

	'// 처리 결과 가져오기
	Function getFinishResult()
		dim tmpHTML
		tmpHTML=""

		IF FCurrState="B007" THEN
		    ''처리 내역이 없을때..
		    if (FOpenContents="") then
		        if (FDivCD="A000") then
		            FOpenContents = "맞교환상품 출고완료"
		        elseif (FDivCD="A001") then
		            FOpenContents = "누락상품 출고완료"
		        elseif (FDivCD="A002") then
		            FOpenContents = "상품 출고완료"
		        elseif (FDivCD="A003") then

		        elseif (FDivCD="A004") then
		            FOpenContents = "상품 반품(회수)완료" '' / 환불등록"

		        elseif (FDivCD="A010") then
		            FOpenContents = "상품 회수완료" '' / 환불등록"
		        elseif (FDivCD="A011") then
		            FOpenContents = "맞교환상품 회수완료"
		        else

		        end if
		    end if

			tmpHTML=tmpHTML&"<!-- 처리 결과 시작--> " & vbcrlf
			tmpHTML=tmpHTML&"		<table width=""100%"" border=""0"" cellpadding=""0"" cellspacing=""0""> " & vbcrlf
			tmpHTML=tmpHTML&"		<tr> " & vbcrlf
			tmpHTML=tmpHTML&"			<td colspan=""2"" class=""sky12pxb"" style=""padding: 10 0 5 0;"">*처리결과</td> " & vbcrlf
			tmpHTML=tmpHTML&"		</tr> " & vbcrlf
			tmpHTML=tmpHTML&"		<tr> " & vbcrlf
			tmpHTML=tmpHTML&"			<td height=""1"" colspan=""2"" bgcolor=""#cccccc""></td> " & vbcrlf
			tmpHTML=tmpHTML&"		</tr> " & vbcrlf
			tmpHTML=tmpHTML&"		<tr> " & vbcrlf
			tmpHTML=tmpHTML&"			<td width=""100"" height=""22"" align=""center"" bgcolor=""#f7f7f7"" class=""black12pxb"" style=""padding-top:2px;"">처리완료일</td> " & vbcrlf
			tmpHTML=tmpHTML&"			<td class=""black12px"" style=""padding-left:10px;padding-top:2px;"">"& FFinishDate &"</td> " & vbcrlf
			tmpHTML=tmpHTML&"		</tr> " & vbcrlf
			tmpHTML=tmpHTML&"		<tr> " & vbcrlf
			tmpHTML=tmpHTML&"			<td height=""1"" colspan=""2"" bgcolor=""#cccccc""></td> " & vbcrlf
			tmpHTML=tmpHTML&"		</tr> " & vbcrlf
			IF (Trim(FOpenContents)<>"") then
    			tmpHTML=tmpHTML&"		<tr> " & vbcrlf
    			tmpHTML=tmpHTML&"			<td height=""22"" align=""center"" bgcolor=""#f7f7f7"" class=""black12pxb"" style=""padding-top:2px;"">처리내용</td> " & vbcrlf
    			tmpHTML=tmpHTML&"			<td class=""black12px"" style=""padding-left:10px;padding-top:2px;""> " & vbcrlf
    			tmpHTML=tmpHTML&"			"& nl2br(FOpenContents) &" " & vbcrlf
    			tmpHTML=tmpHTML&"			</td> " & vbcrlf
    			tmpHTML=tmpHTML&"		</tr> " & vbcrlf
			END IF
			tmpHTML=tmpHTML&"		<tr> " & vbcrlf
			tmpHTML=tmpHTML&"			<td height=""1"" colspan=""2"" bgcolor=""#cccccc""></td> " & vbcrlf
			tmpHTML=tmpHTML&"		</tr> " & vbcrlf
			tmpHTML=tmpHTML&"		</table> " & vbcrlf
			tmpHTML=tmpHTML&"<!-- 처리 결과 끝--> " & vbcrlf
		END IF
		getFinishResult = tmpHTML
	END Function
	''//환불정보 가져오기
	Function getRefundInfo()
		dim tmpHTML
		tmpHTML=""

		IF FDivCD="A003" or FDivCD="A004" or FDivCD="A007" or FDivCD="A008" or FDivCD="A010" THEN
		    ''환불액0이면 return
		    if (FRefundRequire=0) then Exit function

		    ''부정확한 환불 정보 제거
		    if (FReturnMethod="R007") then
		        if (Len(Replace(FReBankAccount,"-",""))<7) then
    		        FReBankName = ""
    		        FReBankAccount = "계좌확인요망"
    		        FReBankOwnerName =""
    		    else
    		        FReBankAccount = Left(FReBankAccount,Len(Trim(FReBankAccount))-3) + "***"
    		    end if
		    end if
			tmpHTML=tmpHTML&"<!-- 환불정보 시작 --> " & vbcrlf
			tmpHTML=tmpHTML&"		<table width=""100%"" border=""0"" cellpadding=""0"" cellspacing=""0""> " & vbcrlf
			tmpHTML=tmpHTML&"		<tr> " & vbcrlf
			tmpHTML=tmpHTML&"			<td width=""100"" height=""24"" align=""center"" bgcolor=""#f7f7f7"" class=""gray12px02b"" style=""padding-top:2px;"">환불예정액</td> " & vbcrlf
			tmpHTML=tmpHTML&"			<td class=""gray12px02"" style=""padding-left:10px;padding-top:2px;"">"& FormatNumber(FRefundRequire,0) &" 원 " & vbcrlf
			'태훈 CS요청 삭제
			'if (FRefundDeliveryPay<>0) then
			'    tmpHTML=tmpHTML&"       (반품배송비차감 : " & FormatNumber(FRefundDeliveryPay,0) &")"
			'end if
			tmpHTML=tmpHTML&"		    </td> " & vbcrlf
			tmpHTML=tmpHTML&"		</tr> " & vbcrlf
			tmpHTML=tmpHTML&"		<tr> " & vbcrlf
			tmpHTML=tmpHTML&"			<td height=""1"" colspan=""2"" bgcolor=""#cccccc""></td> " & vbcrlf
			tmpHTML=tmpHTML&"		</tr> " & vbcrlf
			tmpHTML=tmpHTML&"		<tr> " & vbcrlf
			tmpHTML=tmpHTML&"			<td width=""100"" height=""24"" align=""center"" bgcolor=""#f7f7f7"" class=""gray12px02b"" style=""padding-top:2px;"">환불정보(계좌)</td> " & vbcrlf
			tmpHTML=tmpHTML&"			<td class=""gray12px02"" style=""padding-left:10px;padding-top:2px;""> " & vbcrlf
			tmpHTML=tmpHTML&"				"& FReturnMethodName &"&nbsp;&nbsp; " & vbcrlf
										IF (FReturnMethod="R007") THEN
			tmpHTML=tmpHTML&"				"& FReBankName &"&nbsp;&nbsp; " & vbcrlf
			tmpHTML=tmpHTML&"				"& FReBankAccount &"&nbsp;&nbsp; " & vbcrlf
			tmpHTML=tmpHTML&"				"& FReBankOwnerName &" " & vbcrlf
										ELSEIF (FReturnMethod="R900") or (FReturnMethod="R910") THEN
			tmpHTML=tmpHTML&"				(적립아이디 : "& FUserID &") " & vbcrlf
										ELSEIF (FReturnMethod="R100") or (FReturnMethod="R020") or (FReturnMethod="R080") THEN
			if (Left(FPayGateTid,6)="IniTec") and (FCurrState="B007") then
			    tmpHTML=tmpHTML&"			<a target=_blank href=https://iniweb.inicis.com/DefaultWebApp/mall/cr/cm/mCmReceipt_head.jsp?noTid="& FPayGateTid &"&noMethod=1>[매출전표출력]</a> " & vbcrlf
			end if
										END IF
			tmpHTML=tmpHTML&"			</td> " & vbcrlf
			tmpHTML=tmpHTML&"		</tr> " & vbcrlf
			tmpHTML=tmpHTML&"		<tr> " & vbcrlf
			tmpHTML=tmpHTML&"			<td height=""1"" colspan=""2"" bgcolor=""#cccccc""></td> " & vbcrlf
			tmpHTML=tmpHTML&"		</tr> " & vbcrlf
			tmpHTML=tmpHTML&"		</table> " & vbcrlf
			tmpHTML=tmpHTML&"<!-- 환불정보 끝 --> " & vbcrlf

		END IF
		getRefundInfo = tmpHTML
	END Function


	''//업체 주소 가져오기
	Function getReturnInfo()
		dim tmpHTML
		tmpHTML=""
		IF FDivCD="A004" or FDivCD="A010" or FDivCD="A011" THEN
			tmpHTML=tmpHTML&"<!-- 업체주소 시작 --> " & vbcrlf
			tmpHTML=tmpHTML&"		<table width=""100%"" border=""0"" cellpadding=""0"" cellspacing=""0""> " & vbcrlf
			tmpHTML=tmpHTML&"		<tr> " & vbcrlf
			tmpHTML=tmpHTML&"			<td width=""100"" height=""24"" align=""center"" bgcolor=""#f7f7f7"" class=""gray12px02b"" style=""padding-top:2px;"">반품회수주소</td> " & vbcrlf
			tmpHTML=tmpHTML&"			<td class=""gray12px02"" style=""padding:5px 0px 5px 5px;""> " & vbcrlf
			tmpHTML=tmpHTML&"				<table width=""100%"" border=""0"" cellpadding=""0"" cellspacing=""1"" class=""a"" bgcolor=""#cccccc""> " & vbcrlf
			tmpHTML=tmpHTML&"				<tr height=""22"" align=""center"" bgcolor=""#f7f7f7""> " & vbcrlf
			tmpHTML=tmpHTML&"					<td width=""80"" bgcolor=""#f7f7f7"">업체명</td> " & vbcrlf
			tmpHTML=tmpHTML&"					<td bgcolor=""#FFFFFF"">"& FReturnName &"</td> " & vbcrlf
			tmpHTML=tmpHTML&"					<td width=""80"" bgcolor=""#f7f7f7"">연락처</td> " & vbcrlf
			tmpHTML=tmpHTML&"					<td bgcolor=""#FFFFFF"">"& FReturnPhone &"</td> " & vbcrlf
			tmpHTML=tmpHTML&"				</tr> " & vbcrlf
			tmpHTML=tmpHTML&"				<tr height=""22"" align=""center"" bgcolor=""#f7f7f7""> " & vbcrlf
			tmpHTML=tmpHTML&"					<td bgcolor=""#f7f7f7"">주소</td> " & vbcrlf
			tmpHTML=tmpHTML&"					<td colspan=""3"" bgcolor=""#FFFFFF"">["& FReturnZipCode &"] "& FReturnZipAddr &" &nbsp;"& FReturnEtcAddr &"</td> " & vbcrlf
			tmpHTML=tmpHTML&"				</tr> " & vbcrlf
			if (FReturnName<>"(주)텐바이텐") and (FupcheReturnSongjangDivName<>"") and (Left(FupcheReturnSongjangDivTel,1)="1" or Left(FupcheReturnSongjangDivTel,1)="0") then
			    tmpHTML=tmpHTML&"				<tr height=""22"" align=""center"" bgcolor=""#f7f7f7""> " & vbcrlf
    			tmpHTML=tmpHTML&"					<td width=""80"" bgcolor=""#f7f7f7"">이용택배사</td> " & vbcrlf
    			tmpHTML=tmpHTML&"					<td bgcolor=""#FFFFFF"">"& FupcheReturnSongjangDivName &"</td> " & vbcrlf
    			tmpHTML=tmpHTML&"					<td width=""80"" bgcolor=""#f7f7f7"">택배사연락처</td> " & vbcrlf
    			tmpHTML=tmpHTML&"					<td bgcolor=""#FFFFFF"">"& FupcheReturnSongjangDivTel &"</td> " & vbcrlf
    			tmpHTML=tmpHTML&"				</tr> " & vbcrlf
			end if
			tmpHTML=tmpHTML&"				</table> " & vbcrlf
			tmpHTML=tmpHTML&"			</td> " & vbcrlf
			tmpHTML=tmpHTML&"		</tr> " & vbcrlf
			tmpHTML=tmpHTML&"		<tr> " & vbcrlf
			tmpHTML=tmpHTML&"			<td height=""1"" colspan=""2"" bgcolor=""#cccccc""></td> " & vbcrlf
			tmpHTML=tmpHTML&"		</tr> " & vbcrlf
			tmpHTML=tmpHTML&"		</table> " & vbcrlf
			tmpHTML=tmpHTML&"<!-- 업체주소 끝 --> " & vbcrlf
		END IF

		getReturnInfo = tmpHTML
	END Function

	''//고객주소 가져오기
	Function getReqInfo()
		dim tmpHTML
		tmpHTML=""
		IF FDivCD="A000" or FDivCD="A001" or FDivCD="A002" or FDivCD="A010" THEN 'or FDivCD="A011" THEN
			tmpHTML=tmpHTML&"<!-- 고객주소 시작 --> " & vbcrlf
			tmpHTML=tmpHTML&"		<table width=""100%"" border=""0"" cellpadding=""0"" cellspacing=""0""> " & vbcrlf
			tmpHTML=tmpHTML&"		<tr> " & vbcrlf
			tmpHTML=tmpHTML&"			<td width=""100"" height=""24"" align=""center"" bgcolor=""#f7f7f7"" class=""gray12px02b"" style=""padding-top:2px;"">고객주소</td> " & vbcrlf
			tmpHTML=tmpHTML&"			<td class=""gray12px02"" style=""padding:5px 0px 5px 5px;""> " & vbcrlf
			tmpHTML=tmpHTML&"				<table width=""100%"" border=""0"" cellpadding=""0"" cellspacing=""1"" class=""a"" bgcolor=""#cccccc""> " & vbcrlf
			tmpHTML=tmpHTML&"				<tr height=""22"" align=""center"" bgcolor=""#f7f7f7""> " & vbcrlf
			tmpHTML=tmpHTML&"					<td width=""50"" align=""center"" bgcolor=""#f7f7f7"">고객명</td> " & vbcrlf
			tmpHTML=tmpHTML&"					<td width=""80"" bgcolor=""#FFFFFF"">"& FReqName &"</td> " & vbcrlf
			tmpHTML=tmpHTML&"					<td width=""50"" align=""center"" bgcolor=""#f7f7f7"">연락처</td> " & vbcrlf
			tmpHTML=tmpHTML&"					<td bgcolor=""#FFFFFF"">"& FReqPhone &" / "& FReqHP &"</td> " & vbcrlf
			tmpHTML=tmpHTML&"				</tr> " & vbcrlf
			tmpHTML=tmpHTML&"				<tr height=""22"" align=""center"" bgcolor=""#f7f7f7""> " & vbcrlf
			tmpHTML=tmpHTML&"					<td bgcolor=""#f7f7f7"">주소</td> " & vbcrlf
			tmpHTML=tmpHTML&"					<td colspan=""3"" bgcolor=""#FFFFFF"">["& FReqZipcode &"] "& FReqZipAddr &"&nbsp;"& FReqEtcAddr &"</td> " & vbcrlf
			tmpHTML=tmpHTML&"				</tr> " & vbcrlf
			tmpHTML=tmpHTML&"				</table> " & vbcrlf
			tmpHTML=tmpHTML&"			</td> " & vbcrlf
			tmpHTML=tmpHTML&"		</tr> " & vbcrlf
			tmpHTML=tmpHTML&"		<tr> " & vbcrlf
			tmpHTML=tmpHTML&"			<td height=""1"" colspan=""2"" bgcolor=""#cccccc""></td> " & vbcrlf
			tmpHTML=tmpHTML&"		</tr> " & vbcrlf
			tmpHTML=tmpHTML&"		</table> " & vbcrlf
			tmpHTML=tmpHTML&"<!-- 고객주소 끝 --> " & vbcrlf
		END IF
		getReqInfo = tmpHTML
	END Function

	''//접수 상품 정보 가져오기
	Function getAsItemLIst()
		dim tmpHTML
		dim OCsDetail,i

		tmpHTML = ""

		IF FDivCD="A000" or FDivCD="A001" or FDivCD="A002" or FDivCD="A004" or FDivCD="A008" or FDivCD="A010" or FDivCD="A011" THEN
			tmpHTML=tmpHTML&"<!-- 접수 상품 정보 시작 --> " & vbcrlf

			Set OCsDetail = New CCSASList
			OCsDetail.FRectCsAsID = FAsID
			IF FResultCount>0 THEN
				OCsDetail.GetCsDetailList
			END IF

			if (OCsDetail.FresultCount<1) then Exit function

				tmpHTML=tmpHTML&"		<table width=""100%"" border=""0"" cellpadding=""0"" cellspacing=""0""> " & vbcrlf
				tmpHTML=tmpHTML&"		<tr> " & vbcrlf
				tmpHTML=tmpHTML&"			<td width=""100"" height=""24"" align=""center"" bgcolor=""#f7f7f7"" class=""gray12px02b"" style=""padding-top:2px;"">접수상품</td> " & vbcrlf
				tmpHTML=tmpHTML&"			<td class=""gray12px02"" style=""padding:5px 0px 5px 5px;""> " & vbcrlf
				tmpHTML=tmpHTML&"				<table width=""100%"" border=""0"" cellpadding=""0"" cellspacing=""1"" class=""a"" bgcolor=""#cccccc""> " & vbcrlf
				tmpHTML=tmpHTML&"				<tr height=""22"" align=""center"" bgcolor=""#f7f7f7""> " & vbcrlf
				tmpHTML=tmpHTML&"					<td style=""width:50;"">상품코드</td> " & vbcrlf
				tmpHTML=tmpHTML&"					<td>상품명[옵션]</td> " & vbcrlf
				tmpHTML=tmpHTML&"					<td style=""width:60px;"">판매가</td> " & vbcrlf
				tmpHTML=tmpHTML&"					<td style=""width:30px;"">수량</td> " & vbcrlf
				tmpHTML=tmpHTML&"				</tr> " & vbcrlf
												IF OCsDetail.FresultCount>0 Then
													FOR i=0 TO OCsDetail.FResultCount-1
													    IF (OCsDetail.FItemList(i).Fitemid<>0) or (OCsDetail.FItemList(i).Fitemcost<>0) then
				tmpHTML=tmpHTML&"				<tr height=""22"" align=""center"" bgcolor=""#FFFFFF"" > " & vbcrlf
				tmpHTML=tmpHTML&"					<td>"& OCsDetail.FItemList(i).Fitemid &"</td> " & vbcrlf
				IF (OCsDetail.FItemList(i).Fitemid=0) Then
					tmpHTML=tmpHTML&"					<td> 배송비</td> " & vbcrlf
				ELSE
					tmpHTML=tmpHTML&"					<td>"& OCsDetail.FItemList(i).Fitemname &"</td> " & vbcrlf
				END IF

				IF (OCsDetail.FItemList(i).FdiscountAssingedCost<>0) and (OCsDetail.FItemList(i).Fitemcost>OCsDetail.FItemList(i).FdiscountAssingedCost) then
				    tmpHTML=tmpHTML&"					<td><strike>"& FormatNumber(OCsDetail.FItemList(i).Fitemcost,0) & "</strike><br>" & FormatNumber(OCsDetail.FItemList(i).FdiscountAssingedCost,0) &"</td> " & vbcrlf
				ELSE
				    tmpHTML=tmpHTML&"					<td>"& FormatNumber(OCsDetail.FItemList(i).Fitemcost,0) &"</td> " & vbcrlf
				END IF
				tmpHTML=tmpHTML&"					<td>"& OCsDetail.FItemList(i).Fregitemno &"</td> " & vbcrlf
				tmpHTML=tmpHTML&"				</tr> " & vbcrlf
				                                        END IF
													NEXT
												END IF
				tmpHTML=tmpHTML&"				</table> " & vbcrlf
				tmpHTML=tmpHTML&"			</td> " & vbcrlf
				tmpHTML=tmpHTML&"		</tr> " & vbcrlf
				tmpHTML=tmpHTML&"		<tr> " & vbcrlf
				tmpHTML=tmpHTML&"			<td height=""1"" colspan=""2"" bgcolor=""#cccccc""></td> " & vbcrlf
				tmpHTML=tmpHTML&"		</tr> " & vbcrlf
				tmpHTML=tmpHTML&"		</table> " & vbcrlf
												Set OCsDetail= nothing
				tmpHTML=tmpHTML&"<!-- 접수 상품 정보 끝 --> " & vbcrlf
		END IF
		getAsItemLIst = tmpHTML
	END Function

	''// 접수 기본 내용 가져오기
	Function getAsInfo()
		dim tmpHTML
		tmpHTML = ""

		tmpHTML=tmpHTML&"<!-- 접수 기본 내용 시작 --> " & vbcrlf
		tmpHTML=tmpHTML&"		<table width=""100%"" border=""0"" cellpadding=""0"" cellspacing=""0""> " & vbcrlf
		tmpHTML=tmpHTML&"		<tr> " & vbcrlf
		tmpHTML=tmpHTML&"			<td colspan=""2"" class=""sky12pxb"" style=""padding: 10 0 5 0"">*접수내용</td> " & vbcrlf
		tmpHTML=tmpHTML&"		</tr> " & vbcrlf
		tmpHTML=tmpHTML&"		<tr> " & vbcrlf
		tmpHTML=tmpHTML&"			<td height=""1"" colspan=""2"" bgcolor=""#cccccc""></td> " & vbcrlf
		tmpHTML=tmpHTML&"		</tr> " & vbcrlf
		tmpHTML=tmpHTML&"		<tr> " & vbcrlf
		tmpHTML=tmpHTML&"			<td width=""100"" height=""24"" align=""center"" bgcolor=""#f7f7f7"" class=""gray12px02b"" align=""center"" style=""padding-top:2px;"">서비스코드</td> " & vbcrlf
		tmpHTML=tmpHTML&"			<td class=""gray12px02"" style=""padding-left:10px;padding-top:2px;"">"& FAsID &"</td> " & vbcrlf
		tmpHTML=tmpHTML&"		</tr> " & vbcrlf
		tmpHTML=tmpHTML&"		<tr> " & vbcrlf
		tmpHTML=tmpHTML&"			<td height=""1"" colspan=""2"" bgcolor=""#cccccc""></td> " & vbcrlf
		tmpHTML=tmpHTML&"		</tr> " & vbcrlf
		tmpHTML=tmpHTML&"		<tr> " & vbcrlf
		tmpHTML=tmpHTML&"			<td width=""100"" height=""24"" align=""center"" bgcolor=""#f7f7f7"" class=""gray12px02b"" style=""padding-top:2px;"">주문번호</td> " & vbcrlf
		tmpHTML=tmpHTML&"			<td class=""gray12px02"" style=""padding-left:10px;padding-top:2px;"">"& FOrderSerial &"</td> " & vbcrlf
		tmpHTML=tmpHTML&"		</tr> " & vbcrlf
		tmpHTML=tmpHTML&"		<tr> " & vbcrlf
		tmpHTML=tmpHTML&"			<td height=""1"" colspan=""2"" bgcolor=""#cccccc""></td> " & vbcrlf
		tmpHTML=tmpHTML&"		</tr> " & vbcrlf
		tmpHTML=tmpHTML&"		<tr> " & vbcrlf
		tmpHTML=tmpHTML&"			<td width=""100"" height=""24"" align=""center"" bgcolor=""#f7f7f7"" class=""gray12px02b"" style=""padding-top:2px;"">접수일시</td> " & vbcrlf
		tmpHTML=tmpHTML&"			<td class=""gray12px02"" style=""padding-left:10px;padding-top:2px;"">"& FRegDate &"</td> " & vbcrlf
		tmpHTML=tmpHTML&"		</tr> " & vbcrlf
		tmpHTML=tmpHTML&"		<tr> " & vbcrlf
		tmpHTML=tmpHTML&"			<td height=""1"" colspan=""2"" bgcolor=""#cccccc""></td> " & vbcrlf
		tmpHTML=tmpHTML&"		</tr> " & vbcrlf
		tmpHTML=tmpHTML&"		<tr> " & vbcrlf
		tmpHTML=tmpHTML&"			<td width=""100"" height=""24"" align=""center"" bgcolor=""#f7f7f7"" class=""gray12px02b"" style=""padding-top:2px;"">접수내용</td> " & vbcrlf
		tmpHTML=tmpHTML&"			<td class=""gray12px02"" style=""padding-left:10px;padding-top:2px;"">"& FTitle &"</td> " & vbcrlf
		tmpHTML=tmpHTML&"		</tr> " & vbcrlf
		tmpHTML=tmpHTML&"		<tr> " & vbcrlf
		tmpHTML=tmpHTML&"			<td height=""1"" colspan=""2"" bgcolor=""#cccccc""></td> " & vbcrlf
		tmpHTML=tmpHTML&"		</tr> " & vbcrlf
		tmpHTML=tmpHTML&"		<tr> " & vbcrlf
		tmpHTML=tmpHTML&"			<td width=""100"" height=""24"" align=""center"" bgcolor=""#f7f7f7"" class=""gray12px02b"" style=""padding-top:2px;"">접수사유</td> " & vbcrlf
		tmpHTML=tmpHTML&"			<td class=""gray12px02"" style=""padding-left:10px;padding-top:2px;"">"& GetCauseDetailString &"</td> " & vbcrlf
		tmpHTML=tmpHTML&"		</tr> " & vbcrlf
		tmpHTML=tmpHTML&"		<tr> " & vbcrlf
		tmpHTML=tmpHTML&"			<td height=""1"" colspan=""2"" bgcolor=""#cccccc""></td> " & vbcrlf
		tmpHTML=tmpHTML&"		</tr> " & vbcrlf
		tmpHTML=tmpHTML&"		</table> " & vbcrlf

		tmpHTML=tmpHTML&"<!-- 접수 기본 내용 끝 --> " & vbcrlf

		getAsInfo =tmpHTML

	END Function

	'// SMS보내기
	Public Function sendSMS(byval ipHp, byval ipText)
		dim tmpSms,strSQL
		dim RcvHp,RcvMsg

		'// 직적 입력된 정보 없을경우 자동 생성
		IF ipHp<>"" THEN
			RcvHp=ipHp
		ELSE
			RcvHp=FBuyHP
		END IF

		IF ipText<>"" THEN
			RcvMsg=ipText
		ELSE
			RcvMsg="[텐바이텐] 요청하신 ["& GetAsDivCDName &"] 처리가 "& FCurrStateName &" 되었습니다."
		END IF

		On Error Resume Next

		dbget.beginTrans

		IF RcvHp<>"" and not isnull(RcvHp) THEN
			strSQL = "INSERT INTO [db_sms].[ismsuser].em_tran (tran_phone, tran_callback, tran_status, tran_date, tran_msg)" &vbcrlf
			strSQL = strSQL & "VALUES('"& RcvHp &"','1644-6030','1',getdate(),'" & db2html(RcvMsg) & "')"
			dbget.execute(strSQL)
		END IF

		IF Err.Number = 0 Then
			dbget.commitTrans
			response.write "SMS 발송 - 완료"
			Exit Function
		ELSE
			dbget.RollBackTrans
			response.write "SMS 발송 - 실패"
			Exit Function
		EnD IF

	End Function
	'// mail 보내기
	Function makeMailTemplate(id)
		dim tmpHTML

		Call GetOneCSASMaster(id) '// 값 세팅

		tmpHTML=tmpHTML&"<link href=""http://www.10x10.co.kr/lib/css/2008ten.css"" rel=""stylesheet"" type=""text/css""> " & vbcrlf
		tmpHTML=tmpHTML&"<table width=""600"" border=""0"" align=""center"" cellspacing=""0"" cellpadding=""0"" class=""a""> " & vbcrlf
		tmpHTML=tmpHTML&"<tr> " & vbcrlf
		tmpHTML=tmpHTML&"	<td><a href=""http://www.10x10.co.kr"" target=""_blank"" onFocus=""blur()""> " & vbcrlf
		tmpHTML=tmpHTML&"		<img src=""http://fiximage.10x10.co.kr/web2008/mail/mail_header.gif"" width=""600"" height=""60"" border=""0"" /></a> " & vbcrlf
		tmpHTML=tmpHTML&"	</td> " & vbcrlf
		tmpHTML=tmpHTML&"</tr> " & vbcrlf
		tmpHTML=tmpHTML&"<tr> " & vbcrlf
		tmpHTML=tmpHTML&"	<td style=""border:7px solid #eeeeee;""> " & vbcrlf
		tmpHTML=tmpHTML&"		<table width=""100%"" border=""0"" cellspacing=""0"" cellpadding=""0"" class=""a""> " & vbcrlf
		tmpHTML=tmpHTML&"		<tr> " & vbcrlf
		tmpHTML=tmpHTML&"			<td>"& getMailHeadImage &"</td> " & vbcrlf
		tmpHTML=tmpHTML&"		</tr> " & vbcrlf
		tmpHTML=tmpHTML&"		<tr> " & vbcrlf
		tmpHTML=tmpHTML&"			<td height=""30"" style=""padding:0 15px 0 15px""> " & vbcrlf
		tmpHTML=tmpHTML&"				<!-- 고객명 / 주문번호 --> " & vbcrlf
		tmpHTML=tmpHTML&"				<table width=""100%"" border=""0"" cellspacing=""0"" cellpadding=""0"" class=""a""> " & vbcrlf
		tmpHTML=tmpHTML&"				<tr> " & vbcrlf
		tmpHTML=tmpHTML&"					<td class=""black12px""> " & vbcrlf
		tmpHTML=tmpHTML&"						<strong>"& Fcustomername &"</strong>님이 요청하신 <span class=""sky12pxb"">["& GetAsDivCDName &"]</span>처리가 " & FCurrStateName & " 되었습니다. " & vbcrlf
		tmpHTML=tmpHTML&"					</td> " & vbcrlf
		tmpHTML=tmpHTML&"					<td align=""right"" class=""gray11px02"">주문번호 : <span class=""sale11px01"">"& FOrderSerial &"</span></td> " & vbcrlf
		tmpHTML=tmpHTML&"				</tr> " & vbcrlf
		tmpHTML=tmpHTML&"				<tr> " & vbcrlf
		tmpHTML=tmpHTML&"					<td height=""3"" colspan=""2"" class=""black12px"" style=""padding:5px;"" bgcolor=""#99CCCC""></td> " & vbcrlf
		tmpHTML=tmpHTML&"				</tr> " & vbcrlf
		tmpHTML=tmpHTML&"				</table> " & vbcrlf
		tmpHTML=tmpHTML&"			</td> " & vbcrlf
		tmpHTML=tmpHTML&"		</tr> " & vbcrlf
		tmpHTML=tmpHTML&"		<tr> " & vbcrlf
		tmpHTML=tmpHTML&"			<td style=""padding:5px 15px 20px 15px""> " & vbcrlf
		tmpHTML=tmpHTML&"				<table width=""100%"" border=""0"" cellspacing=""0"" cellpadding=""0""> " & vbcrlf

		tmpHTML=tmpHTML&"				<tr><td> " & vbcrlf
										''// 접수 기본 내용 가져오기
										tmpHTML=tmpHTML& getAsInfo()
		tmpHTML=tmpHTML&"				</td></tr> " & vbcrlf

		tmpHTML=tmpHTML&"				<tr><td> " & vbcrlf
										''// 접수 상품 정보 가져오기
										tmpHTML=tmpHTML& getAsItemLIst()
		tmpHTML=tmpHTML&"				</td></tr> " & vbcrlf

		tmpHTML=tmpHTML&"				<tr><td> " & vbcrlf
										''// 고객주소 가져오기
										tmpHTML=tmpHTML& getReqInfo()
		tmpHTML=tmpHTML&"				</td></tr> " & vbcrlf

		tmpHTML=tmpHTML&"				<tr><td> " & vbcrlf
										''// 업체주소 가져오기
										tmpHTML=tmpHTML& getReturnInfo()
		tmpHTML=tmpHTML&"				</td></tr> " & vbcrlf

		tmpHTML=tmpHTML&"				<tr><td> " & vbcrlf
										''// 환불정보 가져오기
										tmpHTML=tmpHTML& getRefundInfo()
		tmpHTML=tmpHTML&"				</td></tr> " & vbcrlf

		tmpHTML=tmpHTML&"				<tr><td> " & vbcrlf
										''// 처리결과 가져오기
										tmpHTML=tmpHTML& getFinishResult()
		tmpHTML=tmpHTML&"				</td></tr> " & vbcrlf

		tmpHTML=tmpHTML&"				<tr><td> " & vbcrlf
										''// 택배정보 가져오기
										tmpHTML=tmpHTML& getDlvInfo()
		tmpHTML=tmpHTML&"				</td></tr> " & vbcrlf

		tmpHTML=tmpHTML&"				<tr><td> " & vbcrlf
										''// 기타 안내사항
										tmpHTML=tmpHTML&  getEtcNotice()
		tmpHTML=tmpHTML&"				</td></tr> " & vbcrlf

		'tmpHTML=tmpHTML&"				"& FDivCD &" " & vbcrlf
		'tmpHTML=tmpHTML&"				"& FCurrState &" " & vbcrlf
		tmpHTML=tmpHTML&"				</table> " & vbcrlf
		tmpHTML=tmpHTML&"			</td> " & vbcrlf
		tmpHTML=tmpHTML&"		</tr> " & vbcrlf
		tmpHTML=tmpHTML&"		</table> " & vbcrlf
		tmpHTML=tmpHTML&"	</td> " & vbcrlf
		tmpHTML=tmpHTML&"</tr> " & vbcrlf
		tmpHTML=tmpHTML&"<tr> " & vbcrlf
		tmpHTML=tmpHTML&"	<td><img src=""http://fiximage.10x10.co.kr/web2008/mail/mail_footer01.gif"" width=""600"" height=""30"" /></td> " & vbcrlf
		tmpHTML=tmpHTML&"</tr> " & vbcrlf
		tmpHTML=tmpHTML&"<tr> " & vbcrlf
		tmpHTML=tmpHTML&"	<td height=""51"" style=""border-bottom:1px solid #eaeaea;""> " & vbcrlf
		tmpHTML=tmpHTML&"		<table width=""100%"" border=""0"" cellspacing=""0"" cellpadding=""0""> " & vbcrlf
		tmpHTML=tmpHTML&"		<tr> " & vbcrlf
		tmpHTML=tmpHTML&"			<td style=""padding-left:20px;""><img src=""http://fiximage.10x10.co.kr/web2008/mail/mail_footer02.gif"" width=""245"" height=""26"" /></td> " & vbcrlf
		tmpHTML=tmpHTML&"			<td width=""128""><a href=""http://www.10x10.co.kr/cscenter/csmain.asp"" onFocus=""blur()"" target=""_blank""><img src=""http://fiximage.10x10.co.kr/web2008/mail/mail_btn_cs.gif"" width=""108"" height=""31"" border=""0"" /></a></td> " & vbcrlf
		tmpHTML=tmpHTML&"		</tr> " & vbcrlf
		tmpHTML=tmpHTML&"		</table> " & vbcrlf
		tmpHTML=tmpHTML&"	</td> " & vbcrlf
		tmpHTML=tmpHTML&"</tr> " & vbcrlf
		tmpHTML=tmpHTML&"<tr> " & vbcrlf
		tmpHTML=tmpHTML&"	<td style=""padding:10px 0 15px 0;line-height:17px;"" class=""gray11px02""> " & vbcrlf
		tmpHTML=tmpHTML&"	(03086) 서울시 종로구 대학로12길 31 자유빌딩 5층 (주)텐바이텐<br> " & vbcrlf
		tmpHTML=tmpHTML&"	대표이사 : 최은희  &nbsp;사업자등록번호:211-87-00620  &nbsp;통신판매업 신고번호 : 제 01-1968호  &nbsp;개인정보 보호 및 청소년 보호책임자 : 이문재<br> " & vbcrlf
		tmpHTML=tmpHTML&"	<span class=""black11px"">고객행복센터:TEL 1644-6030  &nbsp;E-mail:<a href=""mailto:customer@10x10.co.kr"" class=""link_black11pxb"">customer@10x10.co.kr</a> </span> " & vbcrlf
		tmpHTML=tmpHTML&"	</td> " & vbcrlf
		tmpHTML=tmpHTML&"</tr> " & vbcrlf
		tmpHTML=tmpHTML&"</table> " & vbcrlf
		tmpHTML=tmpHTML&"</body> " & vbcrlf
		tmpHTML=tmpHTML&"</html> " & vbcrlf

		makeMailTemplate = tmpHTML
	End Function
End Class
%>

<%
Class CEventPrize
	public FUserid
	public FCPage
	public FPSize
	public FTotCnt
	public FResultCount
	
	public FGubun
	public FWinnerOX
	
	public Function fnGetEventPrizeList
		Dim strSql,iDelCnt
		strSql = " [db_event].[dbo].sp_Ten_event_winner_listCnt ('"&FUserid&"') "
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF not rsget.EOF THEN
			FTotCnt = rsget(0)
		END IF
			
		rsget.close	
		FResultCount = FTotCnt
		IF FTotCnt > 0 THEN
			iDelCnt =  ((FCPage - 1) * FPSize )+1	
			strSql = " [db_event].[dbo].sp_Ten_event_winner_list ('"&iDelCnt&"','"&FPSize&"','"&FUserid&"') "
			rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF not rsget.EOF THEN		
			fnGetEventPrizeList =rsget.getRows()
		END IF
		rsget.close
		END IF
	End Function
    
    ''2014 추가
    public Function fnGetEventPrizeLastOne
		Dim strSql,iDelCnt
		strSql = " [db_event].[dbo].sp_Ten_event_winner_last_one ('"&FUserid&"') "

		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF not rsget.EOF THEN
			FResultCount = 1
			fnGetEventPrizeLastOne =rsget.getRows()
		END IF
		rsget.close

	End Function
	
	''2015/03/23추가
	public Function fnGetEventPrizeLastOneForApp
		Dim strSql,iDelCnt
		strSql = " [db_event].[dbo].sp_Ten_event_winner_last_one_ForApp ('"&FUserid&"') "

		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF not rsget.EOF THEN
			FResultCount = 1
			fnGetEventPrizeLastOneForApp =rsget.getRows()
		END IF
		rsget.close

	End Function
	
	public Function fnGetEventCheckPrice
		Dim strSql
		strSql = " [db_event].[dbo].sp_Ten_event_winner_listCnt ('"&FUserid&"') "
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF not rsget.EOF THEN
			FTotCnt = rsget(0)
		END IF

		rsget.close	
		FResultCount = FTotCnt
	End Function

	public Function fnGetTesterEventCheck
		Dim strSql
		strSql = " [db_event].[dbo].sp_Ten_TesterWinner_Check ('"&FUserid&"') "
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF not rsget.EOF THEN
			FTotCnt = rsget(0)
		END IF

		rsget.close
		FResultCount = FTotCnt
	End Function


	public Function fnGetEventJoinList
		Dim strSql,iDelCnt
		strSql = " [db_event].[dbo].sp_Ten_event_join_listCnt ('"&FGubun&"','"&FUserid&"','"&FWinnerOX&"') "
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF not rsget.EOF THEN
			FTotCnt = rsget(0)
		END IF
			
		rsget.close	
		FResultCount = FTotCnt
		IF FTotCnt > 0 THEN
			iDelCnt =  (FCPage - 1) * FPSize 
			strSql = " [db_event].[dbo].sp_Ten_event_join_list ('"&FGubun&"','"&iDelCnt&"','"&FPSize&"','"&FUserid&"','"&FWinnerOX&"') "
			'response.write strSql
			rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF not rsget.EOF THEN		
			fnGetEventJoinList =rsget.getRows()
		END IF
		rsget.close
		END IF
	End Function
	
	public FPrizeType	
	public FStatus
	public FStatusDesc
	public FSongjangno
	public FreqDeliverDate
	public FConfirm
	public FSongjangid
	public FPCode
	
	'-----------------------------------------------------------------------  
	' fnSetStatus : 이벤트 공통코드 가져오기
	'-----------------------------------------------------------------------
	public Function fnSetStatus
		FStatusDesc ="-"
		FConfirm ="-"
	IF FPrizeType = 2 THEN 
        FStatusDesc="쿠폰발급완료"
	ELSEIF FPrizeType = 3 THEN
        IF FStatus = 0 THEN 
           FStatusDesc ="배송지입력대기"
           FConfirm="<span class=""btn btn5 gryB w70B""><a href=""javascript:PopOpenEventSongjangEdit('"&FSongjangid&"')"" title='_webapp'>확인하기</a></span>"
        ELSEIF FStatus = 3 THEN 
            IF  FSongjangno <> "" THEN 
            	FStatusDesc="출고완료"
            	FConfirm = "<span class=""btn btn5 gryB w70B""><a href=""javascript:PopOpenEventSongjangView('"&FSongjangid&"')"" title='_webapp'>배송지입력 완료</a></span>"
            ELSE
            	FStatusDesc="상품준비중"
            	if DateDiff("d",FreqDeliverDate,date)<0 then  '' -2=>0 으로 변경
            		FConfirm = "<span class=""btn btn5 gryB w70B""><a href=""javascript:PopOpenEventSongjangEdit('"&FSongjangid&"')"" title='_webapp'>배송지변경</a></span>"
            	else
            		FConfirm = "<span class=""btn btn5 gryB w70B""><a href=""javascript:PopOpenEventSongjangView('"&FSongjangid&"')"" title='_webapp'>배송지입력 완료</a></span>"
            	end if
            END IF
        END IF
      ELSEIF FPrizeType = 4 THEN 	
         IF FStatus = 0 THEN 
         	FStatusDesc="티켓승인대기"
         	FConfirm = "<span class=""btn btn5 gryB w70B""><a href=""javascript:PopOpenEventTicket('"&FPCode&"')"" title='_webapp'>티켓승인하기</a></span>"
         ELSEIF FStatus = 3 THEN 
         	FStatusDesc="티켓승인확정"
         	'FConfirm = "<a href=""javascript:PopOpenEventTicketView('"&FPCode&"')"" title='_webapp'>티켓승인완료</a>"
         END IF
      END IF
	End Function
End Class

Class CTicketPrize
	public Fidx 	
	public FCECode 
	public FWinner 
	public FTel	
	public FHp		
	public FUsing	
	public FComment
	public FPCode
	public FEName
	public FRName
	public FUserName
	public FUserid
	public Fstatus
	public FreqDeliverDate
	public Fprizetype
	public Function fnGetTicket
		Dim strSql
		strSql = " SELECT a.idx, a.evtprize_code, a.cul_evt_code, a.evt_winner, a.tel, a.hp, a.ticket_isusing, a.comment "&_
				", b.evtprize_name, b.evt_rankname, c.username,  b.evtprize_status, b.evtprize_type "&_
				" FROM [db_culture_station].[dbo].[tbl_ticket_prize] a"&_
				"		, [db_event].[dbo].[tbl_event_prize] b "&_
				"		, [db_user].dbo.[tbl_user_n] c "&_
				" WHERE a.evtprize_code = "&FPCode&" and a.evtprize_code = b.evtprize_code and a.evt_winner = c.userid "&_
				" and a.evt_winner='"&FUserid&"'"			
		rsget.Open strSql,dbget
		IF not rsget.EOF THEN
			Fidx 	= rsget("idx")
			FCECode = rsget("cul_evt_code")
			FWinner = rsget("evt_winner")
			FTel	= rsget("tel")
			FHp		= rsget("hp")
			FUsing	= rsget("ticket_isusing")
			FComment = rsget("comment")
			FEName 	= rsget("evtprize_name")
			FRName 	= rsget("evt_rankname")
			FUserName= rsget("username")
			Fstatus			= rsget("evtprize_status")
			FreqDeliverDate	= ""
			Fprizetype			= rsget("evtprize_type")
		END IF		
		rsget.close			
	End Function
End Class
'-----------------------------------------------------------------------  
' fnGetCommCodeArrDesc : 특정종류의 공통코드값의 배열에서 특정값의 코드명 가져오기
'----------------------------------------------------------------------- 
	Function fnGetCommCodeArrDesc(ByVal arrCode, ByVal iCodeValue)
		Dim intLoop		
		IF iCodeValue = "" or isNull(iCodeValue) THEN iCodeValue = -1
		For intLoop =0 To UBound(arrCode,2)		
			IF Cint(iCodeValue) = arrCode(0,intLoop) THEN				
				fnGetCommCodeArrDesc = arrCode(1,intLoop)
				Exit For
			END IF	
		Next	
	End Function
	
	
	Function fnGetCommCodeArrDescCulture(ByVal iCodeValue)
		select Case iCodeValue
			Case 0	'느껴봐
			 	fnGetCommCodeArrDescCulture = "느껴봐"
			Case 1	'읽어봐
				fnGetCommCodeArrDescCulture = "읽어봐"
			Case 2	'들어봐
				fnGetCommCodeArrDescCulture = "들어봐"
			Case Else
				fnGetCommCodeArrDescCulture = ""
		End Select
	End Function
	
'-----------------------------------------------------------------------  
' fnSetCommonCodeArr : 이벤트 공통코드 가져오기
'----------------------------------------------------------------------- 
 Function fnSetCommonCodeArr(ByVal code_type, ByVal blnUse) 
	Dim strSql, arrList, intLoop, strAdd
	Dim intI, intJ, arrCode(), strtype
	strAdd = ""
	IF blnUse THEN
		strAdd= " and code_using ='Y' "
	END IF	
	strSql = " SELECT code_value, code_desc FROM [db_event].[dbo].[tbl_event_commoncode] WHERE code_type='"&code_type&"'"&strAdd&_
			" Order by code_type, code_sort "						
	rsget.Open strSql,dbget
	IF not rsget.EOF THEN
		fnSetCommonCodeArr = rsget.getRows()
	END IF		
	rsget.close	
End Function	


%>
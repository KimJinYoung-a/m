<%
'// 상품
dim vIsTest
IF application("Svr_Info") = "Dev" THEN
	vIsTest = "test"
Else
	vIsTest = ""
End If

Class TimeSaleItemsCls
    '// items
    Public Fid
    Public Fitemid
    Public Fround
    Public Fsortnumber
    Public Fepisode
    Public Fitemdiv
    Public Fbasicimage
    Public Forgprice
    Public Fsailprice
    Public Fsailyn
    Public Fsellcash
    Public Fbuycash
    Public Fitemcouponvalue
    Public Fitemcouponyn
    Public Fitemcoupontype
    Public FsellYn
    Public FtentenImg200
    Public FtentenImg400
    Public FprdImage
    Public FlimitYn
    Public FlimitNo
    Public FlimitSold
    Public FmasterSellCash
    Public FmasterDiscountRate
    Public FcontentName
    Public FiscustomImg
    Public FcontentImg
    Public FevtCode
    Public FcontentType    
    Public FevtSale
    Public FLimitEA
    Public FitemPrice
    Public FcouponRate

	'// 쿠폰 할인 가격
	Public Function fnCouponDiscountPrice()
		Select case Fitemcoupontype
			case "1" ''% 쿠폰
				fnCouponDiscountPrice = CLng(Fitemcouponvalue*Fsellcash/100)
			case "2" ''원 쿠폰
				fnCouponDiscountPrice = Fitemcouponvalue
			case "3" ''무료배송 쿠폰
				fnCouponDiscountPrice = 0
			case else
				fnCouponDiscountPrice = 0
		end Select
	End Function

	'// 쿠폰 할인 문구
	Public Function fnCouponDiscountString()
		Select Case Fitemcoupontype
			Case "1"
				fnCouponDiscountString = CStr(Fitemcouponvalue)
			Case "2"
				fnCouponDiscountString = CStr(Fitemcouponvalue)
			Case "3"
			 	fnCouponDiscountString = 0
			Case Else
				fnCouponDiscountString = Fitemcouponvalue
		End Select
	End Function

	'// 세일 쿠폰 통합 할인 
	Public Function fnSaleAndCouponDiscountString()
		Select Case Fitemcoupontype
			Case "1" '//할인 + %쿠폰
				fnSaleAndCouponDiscountString = ""& CLng((Forgprice-(Fsellcash - CLng(Fitemcouponvalue*Fsellcash/100)))/Forgprice*100) & ""
			Case "2" '//할인 + 원쿠폰
				fnSaleAndCouponDiscountString = ""& CLng((Forgprice-(Fsellcash - Fitemcouponvalue))/Forgprice*100) & ""
			Case "3" '//할인 + 무배쿠폰
				fnSaleAndCouponDiscountString = ""& CLng((Forgprice-Fsellcash)/Forgprice*100) & ""
			Case Else
				fnSaleAndCouponDiscountString = ""
		End Select		
	End Function

	'// 최종가격 및 세일퍼센트 , 쿠폰퍼센트 , 합산퍼센트
	Public Function fnItemPriceInfos(byRef totalPrice , byRef salePercentString , byRef couponPercentString , byRef totalSalePercent)
		'// totalPrice
		totalPrice = formatNumber(Fsellcash - fnCouponDiscountPrice(),0)

		'// salePercentString
		salePercentString = CLng((Forgprice-Fsellcash)/FOrgPrice*100) & chkiif(CLng((Forgprice-Fsellcash)/FOrgPrice*100) > 0 , "%" , "")

		'// couponPercentString
		couponPercentString = fnCouponDiscountString() & chkiif(fnCouponDiscountString() > 0 , chkiif(Fitemcoupontype = 2 , "원" , "%") ,"")

		'// totalSalePercent
		totalSalePercent = fnSaleAndCouponDiscountString() & chkiif(fnSaleAndCouponDiscountString() > 0 , "%" , "")
	End Function

	public sub fnItemLimitedState(byref isSoldOut , byref RemainCount)
		IF FlimitNo<>"" and FlimitSold<>"" Then
			isSoldOut = (FsellYn<>"Y") or ((FlimitYn = "Y") and (clng(FlimitNo)-clng(FlimitSold)<1))
		Else
			isSoldOut = (FsellYn<>"Y")
		End If

		IF isSoldOut Then
			RemainCount = 0
		Else
			RemainCount = (clng(FlimitNo) - clng(FlimitSold))
		End If
	End sub

	'// 상품 쿠폰 여부  '!
	public Function IsCouponItem()
			IsCouponItem = (FItemCouponYN="Y")
	end Function

	'// 상품 쿠폰 내용  '!
	public function GetCouponDiscountStr()

		Select Case Fitemcoupontype
			Case "1"
				GetCouponDiscountStr =CStr(Fitemcouponvalue) + "%"
			Case "2"
				GetCouponDiscountStr = formatNumber(Fitemcouponvalue,0) + "원 할인"
			Case "3"
				GetCouponDiscountStr ="무료배송"
			Case Else
				GetCouponDiscountStr = Fitemcoupontype
		End Select

	end Function

End Class

Class TimeSaleCls
    Public Fepisode
    Public FitemList()
	Public FResultCount
    Public itemStr
    Public evtStartDate
    public evtType
    public FRectEvtCode
    public FCurrentDate
    public mktTest

	Private Sub Class_Initialize()
        redim preserve FitemList(0)

        IF application("Svr_Info") = "Dev" THEN
            mktTest = true
        ElseIf application("Svr_Info")="staging" Then
            mktTest = true    
        Else
            mktTest = false
        End If

        if mktTest then
            '// 테스트용
            'FCurrentDate = CDate("2020-07-23 18:00:00")
            '// 테스트 끝나면 사고 방지 차원에서 서버 시간으로 변경
            FCurrentDate = CDate(Date()&" "&Right("0"&hour(time),2) &":"& Right("0"&minute(time),2) &":"& Right("0"&second(time),2))
        else
            FCurrentDate = CDate(Date()&" "&Right("0"&hour(time),2) &":"& Right("0"&minute(time),2) &":"& Right("0"&second(time),2))
        end if        

        IF mktTest THEN
            If FCurrentDate >= #07/20/2020 18:00:00# and FCurrentDate < #07/21/2020 00:00:00# Then
                itemStr = "2891110,2891112"
                evtStartDate = Cdate("2020-07-20")
            elseIf FCurrentDate >= #07/21/2020 18:00:00# and FCurrentDate < #07/22/2020 00:00:00# Then
                itemStr = "2891111,2891113"
                evtStartDate = Cdate("2020-07-21")
            elseIf FCurrentDate >= #07/22/2020 18:00:00# and FCurrentDate < #07/23/2020 00:00:00# Then
                itemStr = "2891114,2891115"
                evtStartDate = Cdate("2020-07-22")
            elseIf FCurrentDate >= #07/23/2020 18:00:00# and FCurrentDate < #07/24/2020 00:00:00# Then
                itemStr = "2891116,2891117"
                evtStartDate = Cdate("2020-07-23")
            else
                itemStr = ","
                evtStartDate = Cdate("2020-07-20")
            end if
            evtType = "M" 'S(single) 회차 없음 // M(multi) 다중회차
        Else
            If now() >= #07/20/2020 18:00:00# and now() < #07/21/2020 00:00:00# Then
                itemStr = "3020758,3021109"
                evtStartDate = Cdate("2020-07-20")
            elseIf now() >= #07/21/2020 18:00:00# and now() < #07/22/2020 00:00:00# Then
                itemStr = "3021200,3020771"
                evtStartDate = Cdate("2020-07-21")
            elseIf now() >= #07/22/2020 18:00:00# and now() < #07/23/2020 00:00:00# Then
                itemStr = "3020770,3021111"
                evtStartDate = Cdate("2020-07-22")
            elseIf now() >= #07/23/2020 18:00:00# and now() < #07/24/2020 00:00:00# Then
                itemStr = "3021135,3021133"
                evtStartDate = Cdate("2020-07-23")
            else
                itemStr = ","
                evtStartDate = Cdate("2020-07-20")
            end if
            evtType = "M" 'S(single) 회차 없음 // M(multi) 다중회차
        End If

	End Sub

	Private Sub Class_Terminate()

	End Sub
    
    Public Sub getTimeSaleItemLists
		dim strSql , arrayRows , i

		IF Fepisode <> "" THEN
			'strSql = "EXEC [db_event].[dbo].[usp_WWW_Event_TimeSaleItemLists_Get]  "& Fepisode
            strSql = "EXEC [db_event].[dbo].[usp_WWW_Event_NewTimeSaleItemLists_Get]  "& Fepisode & "," & FRectEvtCode
			dim rsMem : set rsMem = getDBCacheSQL(dbget , rsget , "TIMESALE" , strSql , 60 * 1)

	        IF (rsMem is Nothing) THEN EXIT SUB
	        IF not rsMem.EOF  THEN
				arrayRows = rsMem.GetRows
			END IF
			rsMem.Close

			IF isArray(arrayRows) THEN
				FResultCount = Ubound(arrayRows,2) + 1
				redim FitemList(FResultCount)

				FOR i = 0 TO FResultCount-1
					Set FitemList(i) = new TimeSaleItemsCls

                        FitemList(i).Fitemid 		 = arrayRows(0,i) 
                        FitemList(i).Fround 		 = arrayRows(1,i)
                        FitemList(i).Fsortnumber 	 = arrayRows(2,i)
                        FitemList(i).Fepisode 		 = arrayRows(3,i)
                        FitemList(i).Fitemdiv 		 = arrayRows(4,i)

						IF FitemList(i).Fitemdiv = "21" THEN
                            if instr(arrayRows(5,i),"/") > 0 then
	                            FitemList(i).Fbasicimage	 = "http://webimage.10x10.co.kr/image/basic/" + arrayRows(5,i)
                            ELSE
                                FitemList(i).Fbasicimage	 = "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(arrayRows(0,i)) + "/" + arrayRows(5,i)
                            END IF
						ELSE
							FitemList(i).Fbasicimage	 = "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(arrayRows(0,i)) + "/" + arrayRows(5,i)
						END IF 

                        FitemList(i).Forgprice 		 = arrayRows(6,i)
                        FitemList(i).Fsailprice      = arrayRows(7,i)
                        FitemList(i).Fsailyn 		 = arrayRows(8,i)
                        FitemList(i).Fsellcash 		 = arrayRows(9,i)
                        FitemList(i).Fbuycash 		 = arrayRows(10,i)
                        FitemList(i).Fitemcouponvalue= arrayRows(11,i)
                        FitemList(i).Fitemcouponyn   = arrayRows(12,i)
                        FitemList(i).Fitemcoupontype = arrayRows(13,i)
                        FitemList(i).FsellYn         = arrayRows(14,i)
                        FitemList(i).FtentenImg200   = arrayRows(16,i)
                        FitemList(i).FtentenImg400   = arrayRows(17,i)

                        IF Not(isNull(arrayRows(15,i)) Or arrayRows(15,i) = "") THEN
                            FitemList(i).FtentenImg200	= "http://"&vIsTest&"webimage.10x10.co.kr/image/tenten200/" + GetImageSubFolderByItemid(arrayRows(0,i)) + "/" + arrayRows(16,i)
                            FitemList(i).FtentenImg400	= "http://"&vIsTest&"webimage.10x10.co.kr/image/tenten400/" + GetImageSubFolderByItemid(arrayRows(0,i)) + "/" + arrayRows(17,i)
                        END IF

                        IF ImageExists(FitemList(i).FTentenImg400) THEN
                            FitemList(i).FprdImage		= FitemList(i).FTentenImg400
                        ELSEIF ImageExists(FitemList(i).FTentenImg200) THEN
                            FitemList(i).FprdImage		= FitemList(i).FTentenImg200
                        ELSE
                            FitemList(i).FprdImage		= FitemList(i).FBasicimage
                        END IF

                        FitemList(i).FlimitYn           = arrayRows(18,i)
                        FitemList(i).FlimitNo           = arrayRows(19,i)
                        FitemList(i).FlimitSold         = arrayRows(20,i)
                        FitemList(i).FmasterSellCash    = arrayRows(22,i)
                        FitemList(i).FmasterDiscountRate= arrayRows(23,i)
                        FitemList(i).Fsailprice= arrayRows(24,i)
                        FitemList(i).FcontentName= arrayRows(25,i)
                        FitemList(i).FiscustomImg= arrayRows(26,i)
                        FitemList(i).FcontentImg= arrayRows(27,i)
                        if FitemList(i).FiscustomImg = 1 then
                            FitemList(i).FprdImage		= FitemList(i).FcontentImg
                        end if
                        FitemList(i).FevtCode= arrayRows(28,i)
                        FitemList(i).FcontentType= arrayRows(29,i)                        
                        FitemList(i).FevtSale= arrayRows(30,i)
                        FitemList(i).FLimitEA= arrayRows(31,i)                                                
                        FitemList(i).FitemPrice= arrayRows(32,i)
                        FitemList(i).FcouponRate= arrayRows(33,i)
				NEXT
			ELSE
				EXIT SUB
			END IF
		END IF
	End Sub
End Class

Function ImageExists(byval iimg)
	if (IsNull(iimg)) or (trim(iimg)="") or (Right(trim(iimg),1)="\") or (Right(trim(iimg),1)="/") then
		ImageExists = false
	else
		ImageExists = true
	end if
End Function

'// 시간별 타입 구분 다회차
function fnGetCurrentType(isAdmin , currentType)
    if isAdmin and currentType <> "" then 
        fnGetCurrentType = currentType
        Exit function
    elseif isAdmin and currentType = "" then 
        fnGetCurrentType = "0"
        Exit function
    end if

    '// 시간별 타입
    if hour(now) < 9 then 
        fnGetCurrentType = "0" 
    elseif hour(now) >= 9 and hour(now) < 13 then '// am 9 
        fnGetCurrentType = "1"
    elseif hour(now) >= 13 and hour(now) < 16 then '// pm 1  
        fnGetCurrentType = "2"
    elseif hour(now) >= 16 and hour(now) < 20 then  '// pm 4 
        fnGetCurrentType = "3"
    elseif hour(now) >= 20 then '// pm 8 
        fnGetCurrentType = "4"
    end if 
end function

'// 시간별 타입 구분 1회차
function fnGetCurrentSingleType(isAdmin , currentType)
    if isAdmin and currentType <> "" then 
        fnGetCurrentSingleType = currentType
        Exit function
    elseif isAdmin and currentType = "" then 
        fnGetCurrentSingleType = "0"
        Exit function
    end if

    '// 시간별 타입
    if hour(now) < 18 then
    'if hour(now) < 10 then
        fnGetCurrentSingleType = "0" 
    elseif hour(now) >= 18 then '// am 9 
    'elseif hour(now) >= 10 then '// am 9 
        fnGetCurrentSingleType = "1"
    end if 
end function

'// 회차별 시간
function fnGetCurrentTime(currentType)
    select case currentType 
        case "0" 
            fnGetCurrentTime = DateAdd("h",9,Date())
        case "1"
            fnGetCurrentTime = DateAdd("h",13,Date())
        case "2"
            fnGetCurrentTime = DateAdd("h",16,Date())
        case "3"
            fnGetCurrentTime = DateAdd("h",20,Date())
        case "4"
            fnGetCurrentTime = DateAdd("h",24,Date())
        case else
            fnGetCurrentTime = DateAdd("d",1,Date())
    end select 
end function

'// 회차별 시간
function fnGetCurrentSingleTime(currentType)
    select case currentType 
        case "0" 
            fnGetCurrentSingleTime = DateAdd("h",18,Date())
            'fnGetCurrentSingleTime = DateAdd("h",10,Date())
        case "1"
            fnGetCurrentSingleTime = DateAdd("h",24,Date())
        case else
            fnGetCurrentSingleTime = DateAdd("d",1,Date())
    end select 
end function

'// 카카오 메시지 보낼 카운트
function fnGetSendCountToKakaoMassage(currentType)
    dim pushCount

    select case currentType
        case "0" 
            pushCount = 4
        case "1"
            pushCount = 3
        case "2"
            pushCount = 2
        case "3"
            pushCount = 1
        case "4"
            pushCount = 0
        case else
            pushCount = 0
    end select

    '// 10분전 까지 마감 이후 회차 줄어듬
    if currentType <> "0" and currentType <> "4" then 
        fnGetSendCountToKakaoMassage = chkiif(DateDiff("n",DateAdd("n",-40,fnGetCurrentTime(currentType)),now()) < 0 , pushCount , pushCount-1 )
    else
        fnGetSendCountToKakaoMassage = pushCount
    end if 
end function

'// Navi Html
function fnGettimeNavHtml(currentType)
    dim naviHtml , i
    dim timestamp(4) , addClassName(4)

    for i = 1 to 4
        timestamp(i) = i

        if timestamp(i) = Cint(currentType) then 
            addClassName(i) = "on"
        elseif timestamp(i) < Cint(currentType) then 
            addClassName(i) = "end"
        elseif timestamp(i) > Cint(currentType) then 
            addClassName(i) = ""
        end if 
    next

    naviHtml = naviHtml & "<ul class=""time-nav"">"
    naviHtml = naviHtml & "    <li class=""time time1 "& addClassName(1) &""">am8</li>"
    naviHtml = naviHtml & "    <li class=""time time2 "& addClassName(2) &""">pm12</li>"
    naviHtml = naviHtml & "    <li class=""time time3 "& addClassName(3) &""">pm4</li>"
    naviHtml = naviHtml & "    <li class=""time time4 "& addClassName(4) &""">pm8</li>"
    naviHtml = naviHtml & "</ul>"

    response.write naviHtml
end function

'// 다음 타임 display 체크
function fnNextDisplayCheck(currentType)
    dim checkFlag(4) , isDisplay(4) 
    dim i
    for i = 1 to 4
        checkFlag(i) = i

        if checkFlag(i) <= Cint(currentType) then 
            isDisplay(i) = "style=""display:none"""
        elseif checkFlag(i) > Cint(currentType) then 
            isDisplay(i) = "style=""display:block"""
        end if 
    next

    fnNextDisplayCheck = isDisplay
end function

'// 시간별 타입 구분 다회차
function fnGetCurrentItemId(isAdmin , currentType)
    if isAdmin and currentType <> "" then 
		SELECT CASE currentType
			CASE 1
				fnGetCurrentItemId = chkiif(vIsTest = "test" , "2525502" , "2627534")
			CASE 2
				fnGetCurrentItemId = chkiif(vIsTest = "test" , "2519293" , "2627549")
			CASE 3
				fnGetCurrentItemId = chkiif(vIsTest = "test" , "2452029" , "2627553")
			CASE 4
				fnGetCurrentItemId = chkiif(vIsTest = "test" , "2328248" , "2627571")
			CASE ELSE
				fnGetCurrentItemId = ""
		END SELECT
		Exit function
    elseif isAdmin and currentType = "" then 
        fnGetCurrentItemId = ""
        Exit function
    end if

    '// 시간별 미끼상품코드
    if hour(now) < 9 then
        fnGetCurrentItemId = ""
    elseif hour(now) >= 9 and hour(now) < 13 then '// am 9
        fnGetCurrentItemId = "2627534"
    elseif hour(now) >= 13 and hour(now) < 16 then '// pm 1
        fnGetCurrentItemId = "2627549"
    elseif hour(now) >= 16 and hour(now) < 20 then  '// pm 4
        fnGetCurrentItemId = "2627553"
    elseif hour(now) >= 20 then '// pm 8
        fnGetCurrentItemId = "2627571"
    end if
end function


'// 시간별 타임 구분 1회차
function fnGetCurrentSingleItemId(selectNumber)
    IF selectNumber = "" THEN EXIT FUNCTION
    dim timesaleObj : set timesaleObj = new TimeSaleCls
    dim tempitemid : tempitemid = split(timesaleObj.itemStr,",")

    fnGetCurrentSingleItemId = tempitemid(selectNumber)
end function

function fnGetCheckTimeSaleItem(itemid)
    dim currentDate
    fnGetCheckTimeSaleItem=0
    currentDate = CDate(Date()&" "&Right("0"&hour(time),2) &":"& Right("0"&minute(time),2) &":"& Right("0"&second(time),2))
    Select Case cStr(itemid)
        Case "3867259","3739019","3867273","3867274"
            If itemid="3867259" and currentDate >= #06/07/2021 09:00:00# and currentDate < #06/07/2021 12:00:00# Then
                fnGetCheckTimeSaleItem = 111787
            elseif itemid="3739019" and currentDate >= #06/07/2021 12:00:00# and currentDate < #06/07/2021 15:00:00# Then
                fnGetCheckTimeSaleItem = 111787
            elseif itemid="3867273" and currentDate >= #06/07/2021 15:00:00# and currentDate < #06/07/2021 18:00:00# Then
                fnGetCheckTimeSaleItem = 111787
            elseif itemid="3867274" and currentDate >= #06/07/2021 18:00:00# and currentDate < #06/07/2021 21:00:00# Then
                fnGetCheckTimeSaleItem = 111787
            else
                fnGetCheckTimeSaleItem = 1
            end if
        Case "3867231","3713161","3870624","3871258"
            If itemid="3867231" and currentDate >= #06/08/2021 09:00:00# and currentDate < #06/08/2021 12:00:00# Then
                fnGetCheckTimeSaleItem = 111787
            elseif itemid="3713161" and currentDate >= #06/08/2021 12:00:00# and currentDate < #06/08/2021 15:00:00# Then
                fnGetCheckTimeSaleItem = 111787
            elseif itemid="3870624" and currentDate >= #06/08/2021 15:00:00# and currentDate < #06/08/2021 18:00:00# Then
                fnGetCheckTimeSaleItem = 111787
            elseif itemid="3871258" and currentDate >= #06/08/2021 18:00:00# and currentDate < #06/08/2021 21:00:00# Then
                fnGetCheckTimeSaleItem = 111787
            else
                fnGetCheckTimeSaleItem = 1
            end if
        Case "3867260","3738453","3870774","3738635"
            If itemid="3867260" and currentDate >= #06/09/2021 09:00:00# and currentDate < #06/09/2021 12:00:00# Then
                fnGetCheckTimeSaleItem = 111787
            elseif itemid="3738453" and currentDate >= #06/09/2021 12:00:00# and currentDate < #06/09/2021 15:00:00# Then
                fnGetCheckTimeSaleItem = 111787
            elseif itemid="3870774" and currentDate >= #06/09/2021 15:00:00# and currentDate < #06/09/2021 18:00:00# Then
                fnGetCheckTimeSaleItem = 111787
            elseif itemid="3738635" and currentDate >= #06/09/2021 18:00:00# and currentDate < #06/09/2021 21:00:00# Then
                fnGetCheckTimeSaleItem = 111787
            else
                fnGetCheckTimeSaleItem = 1
            end if
    End Select
end function

'public function isOnTimeProduct(itemid)
'    dim timesaleObj : set timesaleObj = new TimeSaleCls
'    dim result : result = true
'
'    if timesaleObj.evtStartDate = "" or timesaleObj.itemStr = "" then exit function
'    ' 이벤트 당일이고 상품이 미끼 상품일 경우 체크
'    if date() <= timesaleObj.evtStartDate  and instr(timesaleObj.itemStr, itemid) > 0 then
'        if fnGetCurrentItemId(false, "") <> itemid then result = false
'        if timesaleObj.evtType = "S" then result = true '// 싱글 타입 
'    end if
'
'    isOnTimeProduct = result
'end function

'2021.02.23 태훈 변경 (DB체크)
public function isOnTimeProduct(userid, itemid, chk_itemarr)
    dim sqlStr, referercheck, cmd, returnValue, returnValue2, bagarr, tmparr, i, usingCheck, nowip, ckdidx
    referercheck = request.ServerVariables("HTTP_REFERER")
    nowip =  Request.ServerVariables("REMOTE_HOST")
    if userid="" then userid = "guest"
    usingCheck = True'True'False '계속 데이터 접근이 필요한가? 일단 이벤트 기간에만 체크하도록 수정
    if usingCheck then
        if instr(itemid,"|")>0 then
            bagarr = split(itemid,"|")
            for i=LBound(bagarr) to UBound(bagarr)
                if Trim(bagarr(i))<>"" then
                    tmparr = split(bagarr(i),",")
                    if UBound(tmparr)>1 then
                        if (tmparr(0)<>"") then
                            Set cmd = Server.CreateObject("ADODB.COMMAND")
                            sqlStr = "[db_event].[dbo].[usp_WWW_Event_ItemOrderValidationCheck_Get]" 
                            cmd.ActiveConnection = dbget
                            cmd.CommandText = sqlStr
                            cmd.CommandType = adCmdStoredProc
                            cmd.Parameters.Append cmd.CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
                            cmd.Parameters.Append cmd.CreateParameter("@ItemID", adInteger, adParamInput, 4, tmparr(0))
                            cmd.Execute
                            returnValue = cmd("RETURN_VALUE").Value
                            Set cmd = Nothing
                            'returnValue = fnGetCheckTimeSaleItem(Trim(tmparr(0)))
                            if returnValue > 0 then ' 1=이벤트 상품 시간외 접근 접근 금지 / 이벤트번호 리턴=레퍼페이지 체크
                                if returnValue > 1 then '정상시간 접근 이벤트 페이지에서  접근 여부 체크
                                    if InStr(referercheck,"eventmain.asp?eventid="&returnValue)<1 Then
                                        isOnTimeProduct = false
                                        '레퍼러 체크 안되지만 이벤트 참여 로그를 확인하고 리턴 시켜준다
                                        Set cmd = Server.CreateObject("ADODB.COMMAND")
                                        sqlStr = "[db_event].[dbo].[usp_WWW_Event_ItemBaguni_ValidationEventCheck_Get]" 
                                        cmd.ActiveConnection = dbget
                                        cmd.CommandText = sqlStr
                                        cmd.CommandType = adCmdStoredProc
                                        cmd.Parameters.Append cmd.CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
                                        cmd.Parameters.Append cmd.CreateParameter("@Evt_Code", adInteger, adParamInput, 4, returnValue)
                                        cmd.Parameters.Append cmd.CreateParameter("@ItemID", adInteger, adParamInput, 4, Trim(tmparr(0)))
                                        cmd.Parameters.Append cmd.CreateParameter("@UserID", adLongVarChar, adParamInput, 32, userid)
                                        cmd.Execute
                                        returnValue2 = cmd("RETURN_VALUE").Value
                                        Set cmd = Nothing
                                        if returnValue2 > 0 then '1번이면 이벤트 로그 없음 접근 금지
                                            isOnTimeProduct = false
                                            Exit For
                                        else
                                            isOnTimeProduct = true
                                        end if
                                    else
                                        isOnTimeProduct = true
                                    end If
                                else '1번이면 이벤트 상품 시간외 접근 접근 금지
                                    isOnTimeProduct = false
                                    Exit For
                                end if
                            else ' 이벤트 상품이 아님
                                isOnTimeProduct = true
                            end If
                        end if
                    end if
                end if
            next
        else
            if instr(itemid,",")>0 then
                bagarr = split(itemid,",")
                chk_itemarr = split(chk_itemarr,",")
                for i=LBound(chk_itemarr) to UBound(chk_itemarr)
                    ckdidx = Trim(chk_itemarr(i))
                    if ckdidx<>"" then
                        Set cmd = Server.CreateObject("ADODB.COMMAND")
                        sqlStr = "[db_event].[dbo].[usp_WWW_Event_ItemOrderValidationCheck_Get]" 
                        cmd.ActiveConnection = dbget
                        cmd.CommandText = sqlStr
                        cmd.CommandType = adCmdStoredProc
                        cmd.Parameters.Append cmd.CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
                        cmd.Parameters.Append cmd.CreateParameter("@ItemID", adInteger, adParamInput, 4, Trim(bagarr(ckdidx)))
                        cmd.Execute
                        returnValue = cmd("RETURN_VALUE").Value
                        Set cmd = Nothing
                        'returnValue = fnGetCheckTimeSaleItem(Trim(bagarr(ckdidx)))
                        if returnValue > 0 then ' 1=이벤트 상품 시간외 접근 접근 금지 / 이벤트번호 리턴=레퍼페이지 체크
                            if returnValue > 1 then '정상시간 접근 이벤트 페이지에서  접근 여부 체크
                                if InStr(referercheck,"eventmain.asp?eventid="&returnValue)<1 Then
                                    isOnTimeProduct = false
                                    '레퍼러 체크 안되지만 이벤트 참여 로그를 확인하고 리턴 시켜준다
                                    Set cmd = Server.CreateObject("ADODB.COMMAND")
                                    sqlStr = "[db_event].[dbo].[usp_WWW_Event_ItemBaguni_ValidationEventCheck_Get]" 
                                    cmd.ActiveConnection = dbget
                                    cmd.CommandText = sqlStr
                                    cmd.CommandType = adCmdStoredProc
                                    cmd.Parameters.Append cmd.CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
                                    cmd.Parameters.Append cmd.CreateParameter("@Evt_Code", adInteger, adParamInput, 4, returnValue)
                                    cmd.Parameters.Append cmd.CreateParameter("@ItemID", adInteger, adParamInput, 4, Trim(bagarr(ckdidx)))
                                    cmd.Parameters.Append cmd.CreateParameter("@UserID", adLongVarChar, adParamInput, 32, userid)
                                    cmd.Execute
                                    returnValue2 = cmd("RETURN_VALUE").Value
                                    Set cmd = Nothing
                                    if returnValue2 > 0 then '1번이면 이벤트 로그 없음 접근 금지
                                        isOnTimeProduct = false
                                        Exit For
                                    else
                                        isOnTimeProduct = true
                                    end if
                                else
                                    isOnTimeProduct = true
                                end If
                            else '1번이면 이벤트 상품 시간외 접근 접근 금지
                                isOnTimeProduct = false
                                Exit For
                            end if
                        else ' 이벤트 상품이 아님
                            isOnTimeProduct = true
                        end If
                    end if
                next
            else'단독상품
                Set cmd = Server.CreateObject("ADODB.COMMAND")
                sqlStr = "[db_event].[dbo].[usp_WWW_Event_ItemOrderValidationCheck_Get]" 
                cmd.ActiveConnection = dbget
                cmd.CommandText = sqlStr
                cmd.CommandType = adCmdStoredProc
                cmd.Parameters.Append cmd.CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
                cmd.Parameters.Append cmd.CreateParameter("@ItemID", adInteger, adParamInput, 4, itemid)
                cmd.Execute
                returnValue = cmd("RETURN_VALUE").Value
                Set cmd = Nothing
                'returnValue = fnGetCheckTimeSaleItem(itemid)
                if returnValue > 0 then ' 1=이벤트 상품 시간외 접근 접근 금지 / 이벤트번호 리턴=레퍼페이지 체크
                    if returnValue > 1 then '정상시간 접근 이벤트 페이지에서  접근 여부 체크
                        if InStr(referercheck,"eventmain.asp?eventid="&returnValue)<1 Then
                            isOnTimeProduct = false
                            '레퍼러 체크 안되지만 이벤트 참여 로그를 확인하고 리턴 시켜준다
                            Set cmd = Server.CreateObject("ADODB.COMMAND")
                            sqlStr = "[db_event].[dbo].[usp_WWW_Event_ItemBaguni_ValidationEventCheck_Get]" 
                            cmd.ActiveConnection = dbget
                            cmd.CommandText = sqlStr
                            cmd.CommandType = adCmdStoredProc
                            cmd.Parameters.Append cmd.CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
                            cmd.Parameters.Append cmd.CreateParameter("@Evt_Code", adInteger, adParamInput, 4, returnValue)
                            cmd.Parameters.Append cmd.CreateParameter("@ItemID", adInteger, adParamInput, 4, itemid)
                            cmd.Parameters.Append cmd.CreateParameter("@UserID", adLongVarChar, adParamInput, 32, userid)
                            cmd.Execute
                            returnValue = cmd("RETURN_VALUE").Value
                            Set cmd = Nothing
                            if returnValue > 0 then '1번이면 이벤트 로그 없음 접근 금지
                                isOnTimeProduct = false
                            else
                                isOnTimeProduct = true
                            end if
                        else
                            isOnTimeProduct = true
                        end If
                    else '1번이면 이벤트 상품 시간외 접근 접근 금지
                        isOnTimeProduct = false
                    end if
                else ' 이벤트 상품이 아님
                    isOnTimeProduct = true
                end If
            end if
        end if
        if not isOnTimeProduct then '비정상 접근 시 로그 남기기
            Set cmd = Server.CreateObject("ADODB.COMMAND")
            sqlStr = "[db_temp].[dbo].[usp_WWW_Event_ItemShoppingBagFailCheck_ADD]" 
            cmd.ActiveConnection = dbget
            cmd.CommandText = sqlStr
            cmd.CommandType = adCmdStoredProc
            cmd.Parameters.Append cmd.CreateParameter("@UserID", adLongVarChar, adParamInput, 32, userid)
            cmd.Parameters.Append cmd.CreateParameter("@ItemID", adLongVarChar, adParamInput, 512, itemid)
            cmd.Parameters.Append cmd.CreateParameter("@ReferURL", adLongVarChar, adParamInput, 512, referercheck)
            cmd.Parameters.Append cmd.CreateParameter("@IPAddress", adLongVarChar, adParamInput, 32, nowip)
            cmd.Parameters.Append cmd.CreateParameter("@Device", adChar, adParamInput, 1, "m")
            cmd.Execute
            Set cmd = Nothing
        end if
    else
        '이벤트 기간이 아닐땐 체크 안 함
        isOnTimeProduct = true
    end if
end function

Public Function fnIsSendKakaoAlarm(eventId,userCell,episode)

	if userCell = "" or eventId = "" then 
        fnIsSendKakaoAlarm = false
        exit function 
    END IF

	dim vQuery , vStatus

	vQuery = "IF EXISTS(SELECT usercell FROM db_temp.dbo.tbl_event_kakaoAlarm WITH(NOLOCK) WHERE eventid = '"& eventId &"' and usercell = '"& userCell &"' and episode='" & episode & "') " &vbCrLf
	vQuery = vQuery & "	BEGIN " &vbCrLf
	vQuery = vQuery & "		SELECT 'I' " &vbCrLf
	vQuery = vQuery & "	END " &vbCrLf
	vQuery = vQuery & "ELSE " &vbCrLf
	vQuery = vQuery & "	BEGIN " &vbCrLf
	vQuery = vQuery & "		SELECT 'U' " &vbCrLf
	vQuery = vQuery &"	END "

	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
	IF Not (rsget.EOF OR rsget.BOF) THEN
		vStatus = rsget(0)
	End IF
	rsget.close

    IF vStatus = "U" THEN  
        vQuery = "INSERT INTO db_temp.dbo.tbl_event_kakaoAlarm (eventid , usercell, episode) values ('"& eventId &"' , '"& userCell &"','" & episode & "') "
        dbget.Execute vQuery
    END IF
	
	fnIsSendKakaoAlarm = chkiif(vStatus = "I", false , true)
End Function
%>
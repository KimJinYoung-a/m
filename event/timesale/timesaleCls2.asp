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

	Private Sub Class_Initialize()
        redim preserve FitemList(0)

        IF application("Svr_Info") = "Dev" THEN
            If now() >= #04/01/2020 18:00:00# and now() < #04/02/2020 00:00:00# Then
            'If now() >= #03/31/2020 19:00:00# and now() < #04/01/2020 00:00:00# Then
                itemStr = "2267297,2461981"
                evtStartDate = Cdate("2020-04-01")
            elseIf now() >= #04/02/2020 18:00:00# and now() < #04/03/2020 00:00:00# Then
                itemStr = "2792463,2793104"
                evtStartDate = Cdate("2020-04-02")
            elseIf now() >= #04/03/2020 18:00:00# and now() < #04/04/2020 00:00:00# Then
                itemStr = "2792470,2792469"
                evtStartDate = Cdate("2020-04-03")
            elseIf now() >= #04/06/2020 18:00:00# and now() < #04/07/2020 00:00:00# Then
                itemStr = "2792464,2793094"
                evtStartDate = Cdate("2020-04-06")
            elseIf now() >= #04/07/2020 18:00:00# and now() < #04/08/2020 00:00:00# Then
                itemStr = "2792466,2793108"
                evtStartDate = Cdate("2020-04-07")
            elseIf now() >= #04/08/2020 18:00:00# and now() < #04/09/2020 00:00:00# Then
                itemStr = "2792471,2792472"
                evtStartDate = Cdate("2020-04-08")
            else
                itemStr = "2267297,2461981"
                evtStartDate = Cdate("2020-04-01")
            end if
            evtType = "M" 'S(single) 회차 없음 // M(multi) 다중회차
        Else
            If now() >= #04/01/2020 18:00:00# and now() < #04/02/2020 00:00:00# Then
            'If now() >= #03/31/2020 19:00:00# and now() < #04/01/2020 00:00:00# Then
                itemStr = "2792465,2792468"
                'evtStartDate = Cdate("2020-03-31")
                evtStartDate = Cdate("2020-04-01")
            elseIf now() >= #04/02/2020 18:00:00# and now() < #04/03/2020 00:00:00# Then
                itemStr = "2792463,2793104"
                evtStartDate = Cdate("2020-04-02")
            elseIf now() >= #04/03/2020 18:00:00# and now() < #04/04/2020 00:00:00# Then
                itemStr = "2792470,2792469"
                evtStartDate = Cdate("2020-04-03")
            elseIf now() >= #04/06/2020 18:00:00# and now() < #04/07/2020 00:00:00# Then
                itemStr = "2792464,2793094"
                evtStartDate = Cdate("2020-04-06")
            elseIf now() >= #04/07/2020 18:00:00# and now() < #04/08/2020 00:00:00# Then
                itemStr = "2792466,2793108"
                evtStartDate = Cdate("2020-04-07")
            elseIf now() >= #04/08/2020 18:00:00# and now() < #04/09/2020 00:00:00# Then
                itemStr = "2792471,2792472"
                evtStartDate = Cdate("2020-04-08")
            else
                itemStr = "2792465,2792468"
                evtStartDate = Cdate("2020-04-01")
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
    'if hour(now) < 19 then
        fnGetCurrentSingleType = "0" 
    elseif hour(now) >= 18 then '// am 9 
    'elseif hour(now) >= 19 then '// am 9 
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
            'fnGetCurrentSingleTime = DateAdd("h",19,Date())
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

public function isOnTimeProduct(itemid)
    dim timesaleObj : set timesaleObj = new TimeSaleCls
    dim result : result = true

    if timesaleObj.evtStartDate = "" or timesaleObj.itemStr = "" then exit function
    ' 이벤트 당일이고 상품이 미끼 상품일 경우 체크
    if date() <= timesaleObj.evtStartDate  and instr(timesaleObj.itemStr, itemid) > 0 then
        If now() >= #04/01/2020 18:00:00# and now() < #04/02/2020 00:00:00# Then
        'If now() >= #03/31/2020 19:00:00# and now() < #04/01/2020 00:00:00# Then
            result = true
        elseIf now() >= #04/02/2020 18:00:00# and now() < #04/03/2020 00:00:00# Then
            result = true
        elseIf now() >= #04/03/2020 18:00:00# and now() < #04/04/2020 00:00:00# Then
            result = true
        elseIf now() >= #04/06/2020 18:00:00# and now() < #04/07/2020 00:00:00# Then
            result = true
        elseIf now() >= #04/07/2020 18:00:00# and now() < #04/08/2020 00:00:00# Then
            result = true
        elseIf now() >= #04/08/2020 18:00:00# and now() < #04/09/2020 00:00:00# Then
            result = true
        else
            result = false
        end if
    end if

    isOnTimeProduct = result
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
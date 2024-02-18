<%
Class CUserLevelOrderSumItem

    public Fyyyymm
    public Fuserlevel
    public FBuyCount
    public FBuySum

    Private Sub Class_Initialize()
        FBuyCount	= 0
        FBuySum		= 0
	End Sub

	Private Sub Class_Terminate()

	End Sub

end Class

Class CMyTenByTenInfo

    public FOneItem
	public FItemList()

    public FRectUserID

    '// 최종 회원 등급 정보 접수
    public function GetLastMonthUserLevelData
        dim sqlStr

		sqlStr = " EXECUTE [db_my10x10].[dbo].[sp_Ten_GetNowUserlevel_Data] '" + userid + "'"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open sqlStr, dbget

		set FOneItem = new CUserLevelOrderSumItem
		if Not rsget.Eof then
		    FOneItem.Fyyyymm		= rsget("yyyymm")
		    FOneItem.Fuserlevel		= rsget("userlevel")
		    FOneItem.FBuyCount		= rsget("BuyCount")
		    FOneItem.FBuySum		= rsget("BuySum")
		end if
		rsget.Close

		if (FOneItem.Fyyyymm="") then
		    FOneItem.Fyyyymm		= Left(Now(),7)
		    FOneItem.Fuserlevel		= GetLoginUserLevel
		    FOneItem.FBuyCount		= 0
		    FOneItem.FBuySum		= 0
		end if

    end function

	'// 다음등급 안내를 위한 현재 고객 구매수 및 구매금액 접수
	public Sub getNextUserBaseInfoData
        dim sqlStr

		sqlStr = " EXECUTE [db_my10x10].[dbo].[sp_Ten_Next_Userlevel_InfoData] '" + userid + "'"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open sqlStr, dbget

		set FOneItem = new CUserLevelOrderSumItem
		if Not rsget.Eof then
		    FOneItem.Fuserlevel		= rsget("userlevel")
		    FOneItem.FBuyCount		= rsget("plusTenBuyCount") + rsget("plusFingerBuyCount")
		    FOneItem.FBuySum		= rsget("TenBuySum") + rsget("FingerBuySum")
		end if
		rsget.Close
	end Sub

    Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

    End Sub

end Class

'// 금액과 구매수로 등급 반환
'// 2018 회원등급 개편
public function getUserLevelByQual(bcnt, bsum)
	IF (bsum>=3000000) then
		getUserLevelByQual = "4"		'# VVIP
	elseIF (bcnt>=5 or bsum>=500000) then
		getUserLevelByQual = "3"		'# VIP GOLD
	elseIF (bcnt>=3 or bsum>=200000) then
		getUserLevelByQual = "2"		'# VIP
	elseIF (bcnt>=1 or bsum>=100000) then
		getUserLevelByQual = "1"		'# RED
	else
		getUserLevelByQual = "0"		'# WHITE
	end if
end Function


'' 회원등급 등업에 필요한 구매수
'// 2018 회원등급 개편
public function getRequireLevelUpBuyCount(culv,bcnt)
    dim rstCnt
    Select Case culv
        Case "0"
        	'WHITE
            rstCnt	= 0 - bcnt
        Case "1"
        	'RED
            rstCnt	= 1 - bcnt
        Case "2"
        	'VIP
            rstCnt	= 3 - bcnt
        Case "3"
        	'VIP GOLD
            rstCnt	= 5 - bcnt
        Case Else
            rstCnt	= 0
    end Select

    if rstCnt<=0 then rstCnt=0

    getRequireLevelUpBuyCount = rstCnt
end function

'' 회원등급 등업에 필요한 구매금액
'// 2018 회원등급 개편
public function getRequireLevelUpBuySum(culv,bsum)
    dim rstSum
    Select Case culv
        Case "0"
        	'WHITE
            rstSum	= 0 - bsum
        Case "1"
        	'RED
            rstSum	= 100000 - bsum
        Case "2"
        	'VIP
            rstSum	= 200000 - bsum
        Case "3"
        	'VIP GOLD
            rstSum	= 500000 - bsum
        Case "4"
        	'VVIP
            rstSum	= 3000000 - bsum
        Case Else
            rstSum	= 0
    end Select

    if rstSum<=0 then rstSum=0

    getRequireLevelUpBuySum = rstSum
end function

'// 2018 회원등급 개편
public function getNextMayLevel(culv)
    Select Case culv
        Case "0"
            getNextMayLevel = "1"
        Case "1"
            getNextMayLevel = "2"
        Case "2"
            getNextMayLevel = "3"
        Case "3"
            getNextMayLevel = "4"
        Case "4"
            getNextMayLevel = "4"
        Case "5"
            getNextMayLevel = "1"
        Case "6"
            getNextMayLevel = "4"
        Case "7"
            getNextMayLevel = "7"
        Case Else
            getNextMayLevel = "0"
    end Select
end Function

'' 회원등급 등업에 필요한 구매수 (2018-01-03 이종화)
'// 2018 회원등급 개편
public function getRequireLevelUpBuyCountPercent(culv,bcnt)
    dim rstCnt
    Select Case culv
        Case "0"
        	'WHITE
            rstCnt	= 0 
        Case "1"
        	'RED
            rstCnt	= (bcnt / 1) * 100
        Case "2"
        	'VIP
            rstCnt	= (bcnt / 3) * 100
        Case "3"
        	'VIP GOLD
            rstCnt	= (bcnt / 5) * 100
        Case Else
            rstCnt	= 0
    end Select
	
    if rstCnt <= 0 then rstCnt = 0
	rstCnt = fix(rstCnt)
	If rstCnt>=100 Then rstCnt = 100

    getRequireLevelUpBuyCountPercent = rstCnt
end function

'' 회원등급 등업에 필요한 구매금액(2016년 기준) (2018-01-03 이종화)
'// 2018 회원등급 개편
public function getRequireLevelUpBuySumPercent(culv,bsum)
    dim rstSum
    Select Case culv
        Case "0"
        	'WHITE
            rstSum	= 0
        Case "1"
        	'RED
            rstSum	= (bsum / 100000) * 100
        Case "2"
        	'VIP
            rstSum	= (bsum / 200000) * 100
        Case "3"
        	'VIP GOLD
            rstSum	= (bsum / 500000) * 100
        Case "4"
        	'VVIP
            rstSum	= (bsum / 3000000) * 100
        Case Else
            rstSum	= 0
    end Select
	
    if rstSum <= 0 then rstSum = 0
	rstSum = fix(rstSum)
	if rstSum >= 100 then rstSum = 100

    getRequireLevelUpBuySumPercent = rstSum
end Function

'' 회원등급 등업에 필요한 구매수
'// 2018 회원등급 개편
public function getRequireLevelUpBuyCountVer2(culv,bcnt)
    dim rstCnt
    Select Case culv
        Case "0"
        	'WHITE
            rstCnt	= 0 - bcnt
        Case "1"
        	'RED
            rstCnt	= 1 - bcnt
        Case "2"
        	'VIP
            rstCnt	= 3 - bcnt
        Case "3"
        	'VIP GOLD
            rstCnt	= 5 - bcnt
        Case Else
            rstCnt	= 0
    end Select

    if rstCnt<=0 then rstCnt=0

    getRequireLevelUpBuyCountVer2 = rstCnt
end function

'' 회원등급 등업에 필요한 구매금액
'// 2018 회원등급 개편
public function getRequireLevelUpBuySumVer2(culv,bsum)
    dim rstSum
    Select Case culv
        Case "0"
        	'WHITE
            rstSum	= 0 - bsum
        Case "1"
        	'RED
            rstSum	= 100000 - bsum
        Case "2"
        	'VIP
            rstSum	= 200000 - bsum
        Case "3"
        	'VIP GOLD
            rstSum	= 500000 - bsum
        Case "4"
        	'VVIP
            rstSum	= 3000000 - bsum
        Case Else
            rstSum	= 0
    end Select

    if rstSum<=0 then rstSum=0

    getRequireLevelUpBuySumVer2 = rstSum
end function
%>

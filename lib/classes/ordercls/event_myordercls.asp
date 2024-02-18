<%
class CMyOrderMasterItem
    public Forderserial
    public Faccountdiv
    public Fregdate
    public Fsubtotalprice
    public FItemNames
    public FItemCount

    ''주문 상품 명
    public function GetItemNames()
		if (FItemCount>1) then
			GetItemNames = FItemNames + " 외 <span class='cBk1'>" + CStr(FItemCount-1) + "건</span>"
		elseif (FItemCount=0) then
			GetItemNames = "배송비 추가결제"
		else
			GetItemNames = FItemNames
		end if
	end function

    Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub
end class

Class CMyOrder
    public FItemList()
	public FResultCount
	public FTotalCount
	public FRectUserID

    public Sub GetMyOrderListProc()
		dim sqlStr, i
		sqlStr = "EXEC [db_event].[dbo].[usp_WWW_Event_LuckyReceipt_MyOrderList_Get] '" & CStr(FRectUserID) & "'"
        rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open sqlStr,dbget,1
		FResultCount = rsget.Recordcount
        FTotalCount = FResultCount
		redim preserve FItemList(FResultCount)
		if not rsget.EOF  then
            i=0
			do until rsget.eof
				set FItemList(i) = new CMyOrderMasterItem
				FItemList(i).FOrderSerial  = rsget("orderserial")
				FItemList(i).FRegdate      = rsget("regdate")
				FItemList(i).FSubTotalPrice= rsget("subtotalprice")
				FItemList(i).Faccountdiv   = Trim(rsget("accountdiv"))
				FItemList(i).FItemNames    = db2html(rsget("itemnames"))
				FItemList(i).FItemCount	   = rsget("itemcount")
				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.Close
	end sub

	Private Sub Class_Initialize()
		redim preserve FItemList(0)
		FResultCount = 0
		FTotalCount =0
	End Sub

	Private Sub Class_Terminate()

	End Sub
end Class

'### 이니렌탈의 납입 개월 수, 월 납입 금액 가져오기
Function fnGetIniRentalOrderInfo(orderserial)
	Dim vQuery, vTemp
	vQuery = "select TOP 1 P_RMESG2 from [db_order].[dbo].[tbl_order_temp] WITH(NOLOCK) "
	vQuery = vQuery & "where orderserial = '" & orderserial & "'"
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
	if not rsget.eof then
		vTemp = rsget(0)
	Else
		vTemp = ""
	end if
	rsget.close
	fnGetIniRentalOrderInfo = vTemp
End Function
%>
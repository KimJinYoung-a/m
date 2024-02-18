<%
'####################################################
' Description :  쿠폰북 클래스
' History : 2014.06.25 한용민 www 이전/생성
'####################################################

Class ClsCouponShop

	public Fitemcouponidx 'Set 쿠폰번호
	public FRecordCount
	public Ftype

	' 유효한 쿠폰 리스트
	public Function fnGetCouponList
		Dim strSql
		strSql = "[db_item].[dbo].sp_Ten_couponshop_list"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetCouponList = rsget.GetRows()
			FRecordCount = rsget.RecordCount
		END IF
		rsget.close
	END Function

	'지정 쿠폰 상품리스트
	public Function fnGetCouponItemList
		Dim strSql
		strSql = "[db_item].[dbo].sp_Ten_couponshop_itemlist("&Fitemcouponidx&")"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetCouponItemList = rsget.GetRows()
		END IF
		rsget.close
	END Function

	'탭별 쿠폰 상품리스트
	public Function fnGetCouponTabList
		Dim strSql
		strSql = "exec [db_item].[dbo].sp_Ten_couponshop_tab "&Ftype&""
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open strSql,dbget,1
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetCouponTabList = rsget.GetRows()
			FRecordCount = rsget.RecordCount
		END IF
		rsget.close
	END Function
End Class

Function FnCouponValueView(vGubun, vValue, vType)
	Dim vLen, vImage, vDanWe, vColor, i
	vLen 	= Len(vValue)
	vImage 	= ""
	vDanWe 	= ""
	vColor	= ""
	i		= 1

	If vGubun = "event" Then
		vColor = "red"
	Else
		vColor = "green"
	End If

	If vType = "1" Then		'### %
		vDanWe = "<img src='http://fiximage.10x10.co.kr/web2013/common/cp_green_num_per.png' alt='%' />"
	ElseIf vType = "2" Then		'### 원
		vDanWe = "<img src='http://fiximage.10x10.co.kr/web2013/common/cp_green_num_won.png' alt='원' />"
	End If

	If IsNumeric(vValue) Then
		vValue = FormatNumber(vValue,0)
	End IF

	For i=1 To Len(vValue)
		If Mid(vValue,i,1) = "," Then
			vImage = vImage & "<img src='http://fiximage.10x10.co.kr/web2013/common/cp_green_num_comma.png' alt=',' />&nbsp;"
		Else
			vImage = vImage & "<img src='http://fiximage.10x10.co.kr/web2013/common/cp_green_num0" + CStr(Mid(vValue,i,1)) + ".png' alt='" + CStr(Mid(vValue,i,1)) + "' />&nbsp;"
		End If
	Next

	FnCouponValueView = vImage & vDanWe
End Function

Function FnCouponValueView_2011(vGubun, vValue, vType)
	Dim vLen, vImage, vDanWe, vColor, i
	vLen 	= Len(vValue)
	vImage 	= ""
	vDanWe 	= ""
	vColor	= ""
	i		= 1

	If vGubun = "event" Then
		vColor = "red"
	Else
		vColor = "green"
	End If

	If vType = "1" Then		'### %
		'vDanWe = "<img src='http://fiximage.10x10.co.kr/web2011/enjoyevent/cp_"&vColor&"_per.png' style='display:inline;'>"
		vDanWe = "<img src='http://fiximage.10x10.co.kr/web2013/common/cp_"&vColor&"_num_per.png' alt='%'>"
	ElseIf vType = "2" Then		'### 원
		'vDanWe = "<img src='http://fiximage.10x10.co.kr/web2011/enjoyevent/cp_"&vColor&"_won.png' style='display:inline;'>"
		vDanWe = "<img src='http://fiximage.10x10.co.kr/web2013/common/cp_"&vColor&"_num_won.png' alt='원'>"
	End If

	If IsNumeric(vValue) Then
		vValue = FormatNumber(vValue,0)
	End IF

	For i=1 To Len(vValue)
		If Mid(vValue,i,1) = "," Then
			'vImage = vImage & "<img src='http://fiximage.10x10.co.kr/web2011/enjoyevent/cp_" & vColor & "_com.png' style='display:inline;'>"
			vImage = vImage & "<img src='http://fiximage.10x10.co.kr/web2013/common/cp_" & vColor & "_num_comma.png' alt=','>&nbsp;"
		Else
			'vImage = vImage & "<img src='http://fiximage.10x10.co.kr/web2011/enjoyevent/cp_" & vColor & "_" & Mid(vValue,i,1) & ".png' style='display:inline;'>"
			vImage = vImage & "<img src='http://fiximage.10x10.co.kr/web2013/common/cp_" & vColor & "_num0" & Mid(vValue,i,1) & ".png' alt='"&Mid(vValue,i,1)&"'>&nbsp;"
		End If
	Next

	FnCouponValueView_2011 = vImage & vDanWe
End Function
%>

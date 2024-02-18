<%
'// 상품
dim vIsTest
IF application("Svr_Info") = "Dev" THEN
	vIsTest = "test"
Else
	vIsTest = ""
End If
		
Class forYouItemCls
    '// items
    public Fitemid
    public FBasicimage
	public Fitemname
	public Fsellcash
	public Forgprice
	public Fsailprice
    public Fitemcouponvalue
	public Forgsuplycash
	public Fsailyn
	public Fsailsuplycash
	public Fitemcouponyn
	public Fitemcoupontype
	public Fcouponbuyprice
	public FbrandName
	public FSecretCouponyn
    public FForyouType
End Class


Class ExhibitionItemsCls
    '// items
    public Fidx
    public Fgubun
    public Fcategory
    public Fitemid
    public Fpickitem
    public Fpicksorting
    public Fcategorysorting
	public Fitemname
	public FMakerid
	public Forgprice
	public Fsailprice
	public Fsailyn
	public Fitemcouponyn
	public Fitemcoupontype
	public Fsailsuplycash
	public Forgsuplycash
	public Fcouponbuyprice
	public FmwDiv
	public Fdeliverytype
	public Fsellcash
	public Fbuycash
    public Fitemcouponvalue
	public FsellYn
	public FbrandName
	public FtotalPoint
	public FevalCnt
	public FfavCnt
	public FTentenImg200
	public FTentenImg400
	public FAddtext1
	public FAddtext2

    '// groupcode
    public Fgidx
    public Fgubuncode
    public Fmastercode
    public Fdetailcode
    public Ftitle
    public Fisusing
	public Fcnt	

    '// common
    public Fregdate
    public Flastupdate
    public Fadminid
    public Flastadminid
	public FImageList
	public FPrdImage
	public FBasicimage
	public Fsorting
End Class

'// 이벤트
Class ExhibitionEventsCls
	public Fidx
	public Fevt_name
	public Fevt_code
	public Fmastercode
	public Fdetailcode
	public Fisusing
	public Fevtsorting
	public Fevt_subcopy
	public Fsquareimage '// PC 정사각 이미지
	public Frectangleimage '// mobile 직사각 이미지
	public Fsaleper '// 할인가
	public Fsalecper '// 쿠폰 할인가
	public Fstartdate '// 시작일
	public Fenddate '// 종료일
	public Fevt_startdate '// 이벤트 시작일
	public Fevt_enddate '// 이벤트 종료일
	public Fregdate
	public Flastupdate
	public Fadminid
	public Flastadminid

	public function IsEndDateExpired()
        IsEndDateExpired = Cdate(Left(now(),10))>Cdate(Left(Fenddate,10))
    end function
End Class

Class ForYouCls

	Public FItemList()
	Public FItem	
	public FResultCount
	public FPageSize
	public FCurrPage
	public Ftotalcount
	public FScrollCount
	public FTotalpage	
    public FPageCount
    public FrectUserId
	
	Private Sub Class_Initialize()
		FCurrPage =1
		FPageSize = 50
		FResultCount = 0
		FScrollCount = 10
		FTotalCount =0
	End Sub
	Private Sub Class_Terminate()

	End Sub
    
'페이징
public sub getForyouItemPageList()
	Dim sqlStr ,i 

    if FrectUserId = "" then exit sub
	sqlStr = "exec [db_my10x10].[dbo].[usp_Ten_foryou_item_list_cnt_get] '" & FrectUserId & "','"& FPageSize &"' "

	'response.write sqlStr & "<br>"
	'Response.end	

    rsget.CursorLocation = adUseClient
    rsget.CursorType = adOpenStatic
    rsget.LockType = adLockOptimistic
    'response.write sqlStr & "<br>"
    rsget.Open sqlStr, dbget
        FTotalCount = rsget("Totalcnt")
        FTotalPage = rsget("totPg")
    rsget.Close

	'지정페이지가 전체 페이지보다 클 때 함수종료
	if Cint(FCurrPage)>Cint(FTotalPage) then
		FResultCount = 0
		exit sub
	end if

	If FTotalCount > 0 Then			

		sqlStr = " EXECUTE [db_my10x10].[dbo].[usp_Ten_foryou_item_list_get] '" & FrectUserId & "', '"&Cstr(FPageSize * FCurrpage)&"'"			 
		
        'response.write sqlStr & "<br>"
        'Response.end	

        rsget.CursorLocation = adUseClient
        rsget.CursorType = adOpenStatic
        rsget.LockType = adLockOptimistic
        rsget.Open sqlStr, dbget
        rsget.pagesize = FPageSize            

		if (FCurrPage * FPageSize < FTotalCount) then
			FResultCount = FPageSize
		else
			FResultCount = FTotalCount - FPageSize*(FCurrPage-1)
		end if

		FTotalPage = (FTotalCount\FPageSize)

		if (FTotalPage <> FTotalCount/FPageSize) then FTotalPage = FTotalPage +1

		redim preserve FItemList(FResultCount)

        FPageCount = FCurrPage - 1
		if not rsget.EOF then
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FItemList(i) = new forYouItemCls

                FItemList(i).Fitemid           = rsget("itemid")              
                FItemList(i).Fitemname         = rsget("itemname")      
                FItemList(i).Fsellcash         = rsget("sellcash")      
                FItemList(i).Forgprice         = rsget("orgprice")      
                FItemList(i).Fsailprice        = rsget("sailprice")      
                FItemList(i).Fitemcouponvalue  = rsget("itemcouponvalue")              
                FItemList(i).Forgsuplycash     = rsget("orgsuplycash")          
                FItemList(i).Fsailyn           = rsget("sailyn")  
                FItemList(i).Fsailsuplycash    = rsget("sailsuplycash")          
                FItemList(i).Fitemcouponyn     = rsget("itemcouponyn")          
                FItemList(i).Fitemcoupontype   = rsget("itemcoupontype")          
                FItemList(i).Fcouponbuyprice   = rsget("couponbuyprice")          
                FItemList(i).FbrandName        = rsget("brandname")      
                FItemList(i).FSecretCouponyn   = rsget("secretcouponyn")
                FItemList(i).FForyouType   = rsget("foryouType")                
			    FItemList(i).FBasicimage	= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FItemList(i).Fitemid) + "/" + rsget("basicimage")			

				i=i+1
				rsget.moveNext
			loop
		end if

		rsget.close
	End If
end Sub
'페이징

'public sub getForyouItemPageList()
'	Dim sqlStr ,i 
'
'    if FrectUserId = "" then exit sub
'	sqlStr = "exec [db_my10x10].[dbo].[usp_Ten_Rebuy_user_foryou_item_list_cnt_get] '" & FrectUserId & "','"& FPageSize &"' "
'
'
'	'response.write sqlStr & "<br>"
'	'Response.end	
'
'	dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"DILS",sqlStr,180)
'	if (rsMem is Nothing) then Exit Sub ''추가
'	
'		FTotalCount = rsMem("Totalcnt")
'		FTotalPage = rsMem("totPg")
'	rsMem.Close          
'
'	'지정페이지가 전체 페이지보다 클 때 함수종료
'	if Cint(FCurrPage)>Cint(FTotalPage) then
'		FResultCount = 0
'		exit sub
'	end if
'
'	If FTotalCount > 0 Then			
'
'		sqlStr = " EXECUTE [db_my10x10].[dbo].[usp_Ten_foryou_item_list_get] '" & FrectUserId & "', '"&Cstr(FPageSize * FCurrpage)&"'"			 
'		
'        'response.write sqlStr & "<br>"
'        'Response.end	
'
'		set rsMem = getDBCacheSQL(dbget,rsget,"DILS",sqlStr,180)
'		if (rsMem is Nothing) then Exit Sub ''추가
'		
'		rsMem.pagesize = FPageSize
'
'		if (FCurrPage * FPageSize < FTotalCount) then
'			FResultCount = FPageSize
'		else
'			FResultCount = FTotalCount - FPageSize*(FCurrPage-1)
'		end if
'
'		FTotalPage = (FTotalCount\FPageSize)
'
'		if (FTotalPage <> FTotalCount/FPageSize) then FTotalPage = FTotalPage +1
'
'		redim preserve FItemList(FResultCount)
'
'        FPageCount = FCurrPage - 1
'		if not rsMem.EOF then
'			rsMem.absolutepage = FCurrPage
'			do until rsMem.eof
'				set FItemList(i) = new forYouItemCls
'
'                FItemList(i).Fitemid           = rsMem("itemid")              
'                FItemList(i).Fitemname         = rsMem("itemname")      
'                FItemList(i).Fsellcash         = rsMem("sellcash")      
'                FItemList(i).Forgprice         = rsMem("orgprice")      
'                FItemList(i).Fsailprice        = rsMem("sailprice")      
'                FItemList(i).Fitemcouponvalue  = rsMem("itemcouponvalue")              
'                FItemList(i).Forgsuplycash     = rsMem("orgsuplycash")          
'                FItemList(i).Fsailyn           = rsMem("sailyn")  
'                FItemList(i).Fsailsuplycash    = rsMem("sailsuplycash")          
'                FItemList(i).Fitemcouponyn     = rsMem("itemcouponyn")          
'                FItemList(i).Fitemcoupontype   = rsMem("itemcoupontype")          
'                FItemList(i).Fcouponbuyprice   = rsMem("couponbuyprice")          
'                FItemList(i).FbrandName        = rsMem("brandname")      
'                FItemList(i).FSecretCouponyn   = rsMem("secretcouponyn")
'			    FItemList(i).FBasicimage	= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FItemList(i).Fitemid) + "/" + rsMem("basicimage")			
'
'				i=i+1
'				rsMem.moveNext
'			loop
'		end if
'
'		rsMem.close
'	End If
'end Sub

Public Function getForyouItemList(userid, numOfItems)
	dim sqlStr,i, itemList()

	sqlStr = " exec [db_my10x10].[dbo].[usp_Ten_foryou_item_list_get] '" & userid & "', '" & numOfItems & "'"
		
	rsget.CursorLocation = adUseClient
	rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

	'rsget.CursorLocation = adUseClient
	'rsget.CursorType=adOpenStatic
	'rsget.Locktype=adLockReadOnly
	'rsget.Open tmpSQL, dbget,2

	redim preserve itemList(rsget.recordcount)

	If Not rsget.EOF Then
		do until rsget.EOF
			set itemList(i) = new forYouItemCls
			
            itemList(i).Fitemid           = rsget("itemid")              
            itemList(i).Fitemname         = rsget("itemname")      
            itemList(i).Fsellcash         = rsget("sellcash")      
            itemList(i).Forgprice         = rsget("orgprice")      
            itemList(i).Fsailprice        = rsget("sailprice")      
            itemList(i).Fitemcouponvalue  = rsget("itemcouponvalue")              
            itemList(i).Forgsuplycash     = rsget("orgsuplycash")          
            itemList(i).Fsailyn           = rsget("sailyn")  
            itemList(i).Fsailsuplycash    = rsget("sailsuplycash")          
            itemList(i).Fitemcouponyn     = rsget("itemcouponyn")          
            itemList(i).Fitemcoupontype   = rsget("itemcoupontype")          
            itemList(i).Fcouponbuyprice   = rsget("couponbuyprice")          
            itemList(i).FbrandName        = rsget("brandname")      
            itemList(i).FSecretCouponyn   = rsget("secretcouponyn")
            itemList(i).FForyouType   = rsget("foryouType")                
            itemList(i).FBasicimage	= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(itemList(i).Fitemid) + "/" + rsget("basicimage")			

			rsget.movenext
			i=i+1
		loop
		getForyouItemList = itemList
	ELSE		
		getForyouItemList = itemList
	End if
	rsget.close
End Function

public Function GetCouponDiscountPrice(couponType, itemcouponvalue, price) '?
	Select case couponType
		case "1" ''% 쿠폰
			GetCouponDiscountPrice = CLng(itemcouponvalue*price/100)
		case "2" ''원 쿠폰
			GetCouponDiscountPrice = itemcouponvalue
		case "3" ''무료배송 쿠폰
			GetCouponDiscountPrice = 0
		case else
			GetCouponDiscountPrice = 0
	end Select
end Function

public function GetCouponDiscountStr(couponType, itemcouponvalue) '!
	Select Case couponType
		Case "1"
			GetCouponDiscountStr =CStr(itemcouponvalue) + "%"
		Case "2"
			GetCouponDiscountStr =FormatNumber(itemcouponvalue,0) + "원"
		Case "3"
			GetCouponDiscountStr ="무료배송"
		Case Else
			GetCouponDiscountStr = couponType
	End Select
end function

End Class

function fnEvalTotalPointAVG(t,g)
	dim vTmp
	vTmp = 0
	If t <> "" Then
		If isNumeric(t) Then
			If t > 0 Then
				If g = "search" Then
					vTmp = (t/4)
				Else
					vTmp = ((Round(t,2) * 100)/4)
				End If
				vTmp = Round(vTmp)
			End If
		End If
	End If
	fnEvalTotalPointAVG = vTmp
end function

function ImageExists(byval iimg)
	if (IsNull(iimg)) or (trim(iimg)="") or (Right(trim(iimg),1)="\") or (Right(trim(iimg),1)="/") then
		ImageExists = false
	else
		ImageExists = true
	end if
end function

function getEvaluations(pItemId, numOfEval)

	if pItemId = "" or numOfEval = "" then
		exit function
	end if

	dim SqlStr 

	sqlStr = ""
	sqlStr = sqlStr & "SELECT TOP "& numOfEval &" userid, contents		"
	sqlStr = sqlStr & "  FROM [db_board].DBO.tbl_Item_Evaluate		"
	sqlStr = sqlStr & " WHERE 1 = 1		"
	sqlStr = sqlStr & "   AND ISUSING = 'Y'		"
	sqlStr = sqlStr & "   AND ITEMID = '"& pItemId &"'		"
	SqlStr = sqlStr & " ORDER BY IDX DESC		"

'       response.write sqlStr &"<br>"
'       response.end
	rsget.CursorLocation = adUseClient
	rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

	if not rsget.EOF then
		getEvaluations = rsget.getRows()    
	end if
	rsget.close         
End function

' 개인화 배너
Public Function getForyouBannerInfo(userid)
	dim SqlStr 

	sqlStr = "EXEC db_my10x10.dbo.usp_Ten_Rebuy_user_alaram_popup_get '"& userid &"'"

	rsget.CursorLocation = adUseClient
	rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

	if not rsget.EOF then
		getForyouBannerInfo = rsget.getRows()    
	end if
	rsget.close         
End Function

Public Function getUserCouponInfo(userid)
	dim SqlStr 

	sqlStr = "EXEC db_my10x10.dbo.usp_Ten_Rebuy_user_foryou_item_maxsail '"& userid &"'"

	rsget.CursorLocation = adUseClient
	rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

	if not rsget.EOF then
		getUserCouponInfo = rsget.getRows()    
	end if
	rsget.close         
End Function
%>
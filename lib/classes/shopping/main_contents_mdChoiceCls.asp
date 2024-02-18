<%
'###########################################################
' Discription : 모바일 mdpick
' History : 2013.12.19 한용민 생성
'###########################################################

Class CMDChoiceItem
    public fitemid
    public fbasicimage
	public FitemName
	public FImageList
	public FImageList120
	public FImageIcon1
	public FOrgprice
	public FSaleyn
	public FSellCash
	public Fitemcouponyn
	public Fitemcouponvalue
	public Fitemcoupontype
	public Fidx

	'// 쿠폰 적용가
	public Function GetCouponAssignPrice() '!
		if (FItemCouponYN="Y") then
			GetCouponAssignPrice = getRealPrice - GetCouponDiscountPrice
		else
			GetCouponAssignPrice = getRealPrice
		end if
	end Function

	'// 쿠폰 할인가 '?
	public Function GetCouponDiscountPrice() 
		Select case Fitemcoupontype
			case "1" ''% 쿠폰
				GetCouponDiscountPrice = CLng(Fitemcouponvalue*getRealPrice/100)
			case "2" ''원 쿠폰
				GetCouponDiscountPrice = Fitemcouponvalue
			case "3" ''무료배송 쿠폰
			    GetCouponDiscountPrice = 0
			case else
				GetCouponDiscountPrice = 0
		end Select

	end Function

	'// 상품 할인율
	public Function getSalePro() 
		if FOrgprice=0 then
			getSalePro = 0
		else
			getSalePro = CLng((FOrgPrice-getRealPrice)/FOrgPrice*100)
		end if
	end Function

	'// 쿠폰 할인율
	public Function getCouponPro() 
		if FOrgprice=0 then
			getCouponPro = 0
		else
			getCouponPro = CLng((FOrgPrice-GetCouponAssignPrice)/FOrgPrice*100)
		end if
	end Function

	'// 상품/쿠폰 할인율
	public Function getSalePercent() 
		dim sSprc, sPer
		sSprc=0 : sPer=0

		if FOrgprice>0 then
			if FSaleyn="Y" then
				sSprc = sSprc + FOrgPrice-getRealPrice
				if Fitemcouponyn="Y" then sSprc = sSprc + GetCouponDiscountPrice
			else
				if Fitemcouponyn="Y" then sSprc = FOrgPrice-GetCouponAssignPrice
			end if
			sPer = CLng(sSprc/FOrgPrice*100)
		end if
		
		getSalePercent = sPer
	end Function

	public function getRealPrice()
		getRealPrice = FSellCash
	end function

    Private Sub Class_Initialize()
	End Sub
	Private Sub Class_Terminate()
	End Sub
end Class

Class CMDChoice
    public FItemList()

	public FPageSize
	public FResultCount
    
    '/chtml/mobile/make_mdpick_xml.asp
    public Sub GetMDChoiceList()
        dim sqlStr, i

		sqlStr = "select top " & FPageSize
		sqlStr = sqlStr & " k.idx, k.itemid, k.isusing, k.startdate, k.enddate, k.orderno, k.regdate, k.lastdate"
		sqlStr = sqlStr & " , k.regadminid, k.lastadminid"
		sqlStr = sqlStr & " , i.itemname, i.listImage120, i.basicimage, i.sellcash, i.orgprice"
		sqlStr = sqlStr & " ,i.sailyn, i.itemcouponyn, i.itemcouponvalue, i.itemcoupontype "
		sqlStr = sqlStr & " from db_sitemaster.dbo.tbl_mobile_main_mdpick as k"
		sqlStr = sqlStr & " Join [db_item].[dbo].tbl_item as i "
		sqlStr = sqlStr & "		on k.itemid=i.itemid "
		sqlStr = sqlStr + " where k.isusing ='Y'"
		sqlStr = sqlStr + " order by k.orderno asc, k.idx desc"
		
		'response.write sqlStr & "<Br>"
		rsget.Open sqlStr, dbget, 1

		FResultCount = rsget.RecordCount

		redim preserve FItemList(FResultCount)
		if  not rsget.EOF  then
		    i = 0
			do until rsget.eof
				set FItemList(i) = new CMDChoiceItem
				
				FItemList(i).fitemid			= rsget("itemid")
				FItemList(i).FitemName		= db2html(rsget("itemname"))
				FItemList(i).FOrgprice		= rsget("orgprice")
				FItemList(i).FSaleyn		= rsget("sailyn")
				FItemList(i).FSellCash		= rsget("sellcash")
				FItemList(i).Fitemcouponyn	= rsget("itemcouponyn")
				FItemList(i).Fitemcouponvalue	= rsget("itemcouponvalue")
				FItemList(i).Fitemcoupontype	= rsget("itemcoupontype")
				if Not(rsget("listImage120")="" or isNull(rsget("listImage120"))) then FItemList(i).FImageList120	= "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listImage120")
				FItemList(i).fbasicimage = "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("basicimage")
				
				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.close
    end Sub

    Private Sub Class_Initialize()
		redim  FItemList(0)
		FPageSize         = 10
	End Sub
	Private Sub Class_Terminate()
    End Sub
end Class
%>

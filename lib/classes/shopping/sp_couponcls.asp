<%
Class CCouponMasterItem
	public Fidx
	public Fcoupontype
	public Fcouponvalue
	public Fcouponname
	public Fminbuyprice
	public Ftargetitemlist
	public Fcouponimage
	public Fregdate
	public Fstartdate
	public Fexpiredate
	public Fisusing
	public FOpenFinishDate
	public Fisopenlistcoupon
	public Fisweekendcoupon
	public Fcouponmeaipprice
    
    public function IsWeekendCoupon()
        IsWeekendCoupon = (Fisweekendcoupon="Y")
    end function
    
    public function IsFreedeliverCoupon()
        IsFreedeliverCoupon = (Fcoupontype="3")
    end function
    
	public function getCouponTypeStr()
		if (Fcoupontype="1") then
			getCouponTypeStr = FormatNumber(Fcouponvalue,0) + " %"
		elseif (Fcoupontype="2") then
			getCouponTypeStr = FormatNumber(Fcouponvalue,0) + " 원"
	    elseif (Fcoupontype="3") then
	        getCouponTypeStr = "배송비"
		end if
	end function

	public function getAvailDateStr()
		getAvailDateStr = Left(Fstartdate,10) + "~" + Left(Fexpiredate,10)
	end function

	public function getAvailDateStrFinish()
		getAvailDateStrFinish = Left(Fexpiredate,10)
	end function

	public function getMiniumBuyPriceStr()
		if Fminbuyprice<>0 then
			getMiniumBuyPriceStr = "상품금액 : " + ForMatNumber(Fminbuyprice,0) + "원 이상 구매"
		else
			getMiniumBuyPriceStr = ""
		end if
		
		if (IsFreedeliverCoupon) then
		    if (Fminbuyprice=0) then
		        getMiniumBuyPriceStr = ""
		    else
		        getMiniumBuyPriceStr = "상품금액 : " + ForMatNumber(Fminbuyprice,0) + "원 이상 구매"
		    end if
		end if
	end function

	Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub
end Class

Class CCouponMaster
	public FItemList()
    public FOneItem
    
	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount
	public FScrollCount

	public FRectIdx
	public FRectUserID

	public function CheckAlreadyReceiveCoupon(byval iidx, byval iuserid)
		dim i,sqlStr
		CheckAlreadyReceiveCoupon = false

		sqlStr = "select count(idx) as cnt from [db_user].[dbo].tbl_user_coupon"
		sqlStr = sqlStr + " where userid='" + iuserid + "'"
		sqlStr = sqlStr + " and masteridx=" + CStr(iidx) + ""
		sqlStr = sqlStr + " and isusing='N' and deleteyn='N'"  '' 할인권 사용후 재발행 가능..
        
		rsget.Open sqlStr, dbget, 1
		if Not rsget.Eof then
			CheckAlreadyReceiveCoupon = rsget("cnt") > 0
		end if
		rsget.Close

	end function
    
    public Sub GetOneAvailCouponMaster
        dim sqlStr

		sqlStr = "select top 1 m.idx, "
		sqlStr = sqlStr + " m.coupontype,m.couponvalue,m.couponname,m.couponimage,"
		sqlStr = sqlStr + " convert(varchar,m.regdate,20) as regdate, convert(varchar,m.startdate,20) as startdate,"
		sqlStr = sqlStr + " convert(varchar,m.expiredate,20) as expiredate, m.isusing, m.minbuyprice,"
		sqlStr = sqlStr + " m.targetitemlist, convert(varchar,m.openfinishdate,20) as openfinishdate,couponmeaipprice,"
		sqlStr = sqlStr + " m.isopenlistcoupon, m.isweekendcoupon"
		
		sqlStr = sqlStr + " from [db_user].[dbo].tbl_user_coupon_master m"
		sqlStr = sqlStr + "	where m.openfinishdate>getdate()"
		sqlStr = sqlStr + "	and m.startdate<=getdate()"
		sqlStr = sqlStr + "	and m.isusing='Y'"
		sqlStr = sqlStr + "	and m.isopenlistcoupon='N'"
		sqlStr = sqlStr + "	order by m.idx desc"

		rsget.Open sqlStr, dbget, 1

		FResultCount = rsget.RecordCount


		if  not rsget.EOF  then
			set FOneItem = new CCouponMasterItem
			FOneItem.Fidx         = rsget("idx")
			FOneItem.Fcoupontype  = rsget("coupontype")
			FOneItem.Fcouponvalue = rsget("couponvalue")
			FOneItem.Fcouponname  = db2html(rsget("couponname"))
			FOneItem.Fcouponimage = "http://www.10x10.co.kr/my10x10/images/" + rsget("couponimage")
			FOneItem.Fregdate     = rsget("regdate")
			FOneItem.Fstartdate   = rsget("startdate")
			FOneItem.Fexpiredate  = rsget("expiredate")
			FOneItem.Fisusing     = rsget("isusing")
			FOneItem.Fminbuyprice = rsget("minbuyprice")
			FOneItem.Ftargetitemlist = rsget("targetitemlist")

			FOneItem.FOpenFinishDate = rsget("openfinishdate")
			FOneItem.Fcouponmeaipprice = rsget("couponmeaipprice")
            
            FOneItem.Fisopenlistcoupon = rsget("isopenlistcoupon")
            FOneItem.Fisweekendcoupon = rsget("isweekendcoupon")
		end if
		rsget.close
	end Sub
	
	public Sub GetAvailCouponMaster
		dim i,sqlStr

		sqlStr = "select top 1 m.idx, "
		sqlStr = sqlStr + " m.coupontype,m.couponvalue,m.couponname,m.couponimage,"
		sqlStr = sqlStr + " convert(varchar,m.regdate,20) as regdate, convert(varchar,m.startdate,20) as startdate,"
		sqlStr = sqlStr + " convert(varchar,m.expiredate,20) as expiredate, m.isusing, m.minbuyprice,"
		sqlStr = sqlStr + " m.targetitemlist, convert(varchar,m.openfinishdate,20) as openfinishdate,couponmeaipprice,"
		sqlStr = sqlStr + " m.isopenlistcoupon, m.isweekendcoupon"
		
		sqlStr = sqlStr + " from [db_user].[dbo].tbl_user_coupon_master m"
		sqlStr = sqlStr + "	where m.openfinishdate>getdate()"
		sqlStr = sqlStr + "	and m.startdate<=getdate()"
		sqlStr = sqlStr + "	and m.isusing='Y'"
		sqlStr = sqlStr + "	and m.isopenlistcoupon='N'"
		sqlStr = sqlStr + "	order by m.idx desc"

		rsget.Open sqlStr, dbget, 1

		FResultCount = rsget.RecordCount

		redim preserve FItemList(FResultCount)

		if  not rsget.EOF  then
			set FItemList(i) = new CCouponMasterItem
			FItemList(i).Fidx         = rsget("idx")
			FItemList(i).Fcoupontype  = rsget("coupontype")
			FItemList(i).Fcouponvalue = rsget("couponvalue")
			FItemList(i).Fcouponname  = db2html(rsget("couponname"))
			FItemList(i).Fcouponimage = "http://www.10x10.co.kr/my10x10/images/" + rsget("couponimage")
			FItemList(i).Fregdate     = rsget("regdate")
			FItemList(i).Fstartdate   = rsget("startdate")
			FItemList(i).Fexpiredate  = rsget("expiredate")
			FItemList(i).Fisusing     = rsget("isusing")
			FItemList(i).Fminbuyprice = rsget("minbuyprice")
			FItemList(i).Ftargetitemlist = rsget("targetitemlist")

			FItemList(i).FOpenFinishDate = rsget("openfinishdate")
			FItemList(i).Fcouponmeaipprice = rsget("couponmeaipprice")
            
            FItemList(i).Fisopenlistcoupon = rsget("isopenlistcoupon")
            FItemList(i).Fisweekendcoupon = rsget("isweekendcoupon")
		end if
		rsget.close
	end Sub

	public Sub GetOneValidCouponMaster
		dim i,sqlStr
		sqlStr = "select top 1 m.idx, "
		sqlStr = sqlStr + " m.coupontype,m.couponvalue,m.couponname,m.couponimage,"
		sqlStr = sqlStr + " convert(varchar,m.regdate,20) as regdate, convert(varchar,m.startdate,20) as startdate,"
		sqlStr = sqlStr + " convert(varchar,m.expiredate,20) as expiredate, m.isusing, m.minbuyprice,"
		sqlStr = sqlStr + " m.targetitemlist, convert(varchar,m.openfinishdate,20) as openfinishdate, couponmeaipprice,"
		sqlStr = sqlStr + " m.isopenlistcoupon, m.isweekendcoupon"
		sqlStr = sqlStr + " from [db_user].[dbo].tbl_user_coupon_master m"
		sqlStr = sqlStr + "	where m.idx=" + CStr(FRectIdx)
		sqlStr = sqlStr + "	and m.openfinishdate>getdate()"
		sqlStr = sqlStr + "	and m.regdate<=getdate()"
		sqlStr = sqlStr + "	and m.isusing='Y'"
		sqlStr = sqlStr + "	order by m.idx desc"

		rsget.Open sqlStr, dbget, 1

		FResultCount = rsget.RecordCount

		redim preserve FItemList(FResultCount)

		if  not rsget.EOF  then
			set FItemList(i) = new CCouponMasterItem
			FItemList(i).Fidx         = rsget("idx")
			FItemList(i).Fcoupontype  = rsget("coupontype")
			FItemList(i).Fcouponvalue = rsget("couponvalue")
			FItemList(i).Fcouponname  = db2html(rsget("couponname"))
			FItemList(i).Fcouponimage = "http://www.10x10.co.kr/my10x10/images/" + rsget("couponimage")
			FItemList(i).Fregdate     = rsget("regdate")
			FItemList(i).Fstartdate   = rsget("startdate")
			FItemList(i).Fexpiredate  = rsget("expiredate")
			FItemList(i).Fisusing     = rsget("isusing")
			FItemList(i).Fminbuyprice = rsget("minbuyprice")
			FItemList(i).Ftargetitemlist = rsget("targetitemlist")

			FItemList(i).FOpenFinishDate = rsget("openfinishdate")
			
			FItemList(i).Fisopenlistcoupon = rsget("isopenlistcoupon")
            FItemList(i).Fisweekendcoupon = rsget("isweekendcoupon")
		end if
		rsget.close
	end Sub

	public Sub GetOneAppointmentCouponMaster
		dim i,sqlStr
		sqlStr = "select top 1 m.idx, "
		sqlStr = sqlStr + " m.coupontype,m.couponvalue,m.couponname,m.couponimage,"
		sqlStr = sqlStr + " convert(varchar,m.regdate,20) as regdate, convert(varchar,m.startdate,20) as startdate,"
		sqlStr = sqlStr + " convert(varchar,m.expiredate,20) as expiredate, m.isusing, m.minbuyprice,"
		sqlStr = sqlStr + " m.targetitemlist, convert(varchar,m.openfinishdate,20) as openfinishdate, m.couponmeaipprice,"
		sqlStr = sqlStr + " m.isopenlistcoupon, m.isweekendcoupon"
		
		sqlStr = sqlStr + " from [db_user].[dbo].tbl_user_coupon_master m,"
		sqlStr = sqlStr + "	[db_user].[dbo].tbl_user_coupon_openlist o"
		sqlStr = sqlStr + "	where m.idx<>0"
		sqlStr = sqlStr + "	and m.idx=o.masteridx"
		sqlStr = sqlStr + "	and o.userid='" + FRectUserID + "'"
		sqlStr = sqlStr + "	and m.openfinishdate>getdate()"
		sqlStr = sqlStr + "	and m.startdate<=getdate()"
		sqlStr = sqlStr + "	and m.isusing='Y'"
		sqlStr = sqlStr + "	order by m.idx desc"

		rsget.Open sqlStr, dbget, 1

		FResultCount = rsget.RecordCount

		if  not rsget.EOF  then
			set FOneItem = new CCouponMasterItem
			FOneItem.Fidx         = rsget("idx")
			FOneItem.Fcoupontype  = rsget("coupontype")
			FOneItem.Fcouponvalue = rsget("couponvalue")
			FOneItem.Fcouponname  = db2html(rsget("couponname"))
			FOneItem.Fcouponimage = "http://www.10x10.co.kr/my10x10/images/" + rsget("couponimage")
			FOneItem.Fregdate     = rsget("regdate")
			FOneItem.Fstartdate   = rsget("startdate")
			FOneItem.Fexpiredate  = rsget("expiredate")
			FOneItem.Fisusing     = rsget("isusing")
			FOneItem.Fminbuyprice = rsget("minbuyprice")
			FOneItem.Ftargetitemlist = rsget("targetitemlist")

			FOneItem.FOpenFinishDate = rsget("openfinishdate")
			
			FOneItem.Fisopenlistcoupon = rsget("isopenlistcoupon")
            FOneItem.Fisweekendcoupon = rsget("isweekendcoupon")
		end if
		rsget.close
	end Sub

	public Sub GetCouponMasterList
		dim i,sqlStr
		sqlStr = " select count(idx) as cnt from [db_user].[dbo].tbl_user_coupon_master"
		if FRectIdx<>"" then
			sqlStr = sqlStr + "	where idx=" + CStr(FRectIdx)
		end if

		rsget.Open sqlStr, dbget, 1
			FTotalCount = rsget("cnt")
		rsget.close

		sqlStr = "select top " + CStr(FPageSize * FCurrPage) + " idx, "
		sqlStr = sqlStr + " coupontype,couponvalue,couponname,couponimage,"
		sqlStr = sqlStr + " convert(varchar,regdate,20) as regdate, convert(varchar,startdate,20) as startdate,"
		sqlStr = sqlStr + " convert(varchar,expiredate,20) as expiredate, isusing, minbuyprice,"
		sqlStr = sqlStr + " targetitemlist, convert(varchar,openfinishdate,20) as openfinishdate"
		sqlStr = sqlStr + " from [db_user].[dbo].tbl_user_coupon_master "
		if FRectIdx<>"" then
			sqlStr = sqlStr + "	where idx=" + CStr(FRectIdx)
		end if
		sqlStr = sqlStr + " order by idx desc "

		rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget, 1

		FtotalPage =  CInt(FTotalCount\FPageSize)
		if  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) then
			FtotalPage = FtotalPage +1
		end if
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))

		redim preserve FItemList(FResultCount)

		if  not rsget.EOF  then
		    i = 0
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FItemList(i) = new CCouponMasterItem
				FItemList(i).Fidx         = rsget("idx")
				FItemList(i).Fcoupontype  = rsget("coupontype")
				FItemList(i).Fcouponvalue = rsget("couponvalue")
				FItemList(i).Fcouponname  = db2html(rsget("couponname"))
				FItemList(i).Fcouponimage = "http://www.10x10.co.kr/my10x10/images/" + rsget("couponimage")
				FItemList(i).Fregdate     = rsget("regdate")
				FItemList(i).Fstartdate   = rsget("startdate")
				FItemList(i).Fexpiredate  = rsget("expiredate")
				FItemList(i).Fisusing     = rsget("isusing")
				FItemList(i).Fminbuyprice = rsget("minbuyprice")
				FItemList(i).Ftargetitemlist = rsget("targetitemlist")

				FItemList(i).FOpenFinishDate = rsget("openfinishdate")
				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.close
	end Sub
	
	public Sub GetSpecialValidCouponMaster
		dim i,sqlStr
		sqlStr = "select top 1 m.idx, "
		sqlStr = sqlStr + " m.coupontype,m.couponvalue,m.couponname,m.couponimage,"
		sqlStr = sqlStr + " convert(varchar,m.regdate,20) as regdate, convert(varchar,m.startdate,20) as startdate,"
		sqlStr = sqlStr + " convert(varchar,m.expiredate,20) as expiredate, m.isusing, m.minbuyprice,"
		sqlStr = sqlStr + " m.targetitemlist, convert(varchar,m.openfinishdate,20) as openfinishdate"
		sqlStr = sqlStr + " from [db_user].[dbo].tbl_user_coupon_master m"
		sqlStr = sqlStr + "	where m.idx=" + CStr(FRectIdx)
		sqlStr = sqlStr + "	and m.openfinishdate>getdate()"
		sqlStr = sqlStr + "	and m.regdate<=getdate()"
		sqlStr = sqlStr + "	and m.isusing='Y'"
		sqlStr = sqlStr + "	order by m.idx desc"
'response.write sqlStr
		rsget.Open sqlStr, dbget, 1
		
		FResultCount = rsget.RecordCount

		redim preserve FItemList(FResultCount)

		if  not rsget.EOF  then
			set FItemList(i) = new CCouponMasterItem
			FItemList(i).Fidx         = rsget("idx")
			FItemList(i).Fcoupontype  = rsget("coupontype")
			FItemList(i).Fcouponvalue = rsget("couponvalue")
			FItemList(i).Fcouponname  = db2html(rsget("couponname"))
			FItemList(i).Fcouponimage = "http://www.10x10.co.kr/my10x10/images/" + rsget("couponimage")
			FItemList(i).Fregdate     = rsget("regdate")
			FItemList(i).Fstartdate   = rsget("startdate")
			FItemList(i).Fexpiredate  = rsget("expiredate")
			FItemList(i).Fisusing     = rsget("isusing")
			FItemList(i).Fminbuyprice = rsget("minbuyprice")
			FItemList(i).Ftargetitemlist = rsget("targetitemlist")

			FItemList(i).FOpenFinishDate = rsget("openfinishdate")
		end if
		rsget.close
	end Sub

	Private Sub Class_Initialize()
		redim preserve FItemList(0)

		FCurrPage         = 1
		FPageSize         = 10
		FResultCount      = 0
		FScrollCount      = 10
		FTotalCount       = 0
	End Sub

	Private Sub Class_Terminate()

	End Sub

	public Function HasPreScroll()
		HasPreScroll = StarScrollPage > 1
	end Function

	public Function HasNextScroll()
		HasNextScroll = FTotalPage > StarScrollPage + FScrollCount -1
	end Function

	public Function StarScrollPage()
		StarScrollPage = ((FCurrpage-1)\FScrollCount)*FScrollCount +1
	end Function
end Class





class CCouponItem
	public Fidx
	public Fuserid
	public Fcoupontype
	public Fcouponvalue
	public Fcouponname
	public Fcouponimage
	public Fregdate
	public Fstartdate
	public Fexpiredate
	public Fisusing
	public Fdeleteyn

	public Fminbuyprice
	public Ftargetitemlist
	public Fcouponmeaipprice
	public FReturn
	
	public Fmasteridx
	public Fpcardno
	public Fscrachdate

	Public Fvalidsitename 'APP

    public Ftargetcpntype
    public Ftargetcpnsource
    public Ftargetcatename
    public Ftargetbrandname
    public FmxCpnDiscount '// 2018 회원등급 개편 2018/07/24
    
    '' 브랜드 쿠폰 여부 2018/01/22
    public function IsBrandTargetCoupon
        IsBrandTargetCoupon = (Ftargetcpntype="B")
    end function
    
    '' 카테고리 쿠폰 여부 2018/01/22
    public function IsCategoryTargetCoupon
        IsCategoryTargetCoupon = (Ftargetcpntype="C")
    end function

    public function getMyTenByTenMainCouponImage()
        if (IsFreedeliverCoupon) then
            getMyTenByTenMainCouponImage = "http://fiximage.10x10.co.kr/web2009/mytenbyten/img_cpfree.gif"
        elseif (Fcoupontype="1") then
            getMyTenByTenMainCouponImage = "http://fiximage.10x10.co.kr/web2009/mytenbyten/img_cp"&Fcouponvalue&".gif"
        elseif (Fcoupontype="2") then
            getMyTenByTenMainCouponImage = "http://fiximage.10x10.co.kr/web2009/mytenbyten/img_cp"&Fcouponvalue&".gif"
        end if
    end function

    public function IsFreedeliverCoupon()
        IsFreedeliverCoupon = (Fcoupontype="3")
    end function
    
	public Function GetCouponValueByMoney(orgcash)
		if (Fcoupontype="1") then
			GetCouponValueByMoney = CLng(orgcash*Fcouponvalue/100)
		else
			GetCouponValueByMoney = Fcouponvalue
		end if
	end function

	public Function IsTargetItemCoupon()
		IsTargetItemCoupon = (Not IsNull(Ftargetitemlist)) and (Ftargetitemlist<>"")
	end function
	'mobile
	public Function IsMobileTargetCoupon()
		IsMobileTargetCoupon = (Fvalidsitename = "mobile")
	end function
	'app
	public Function IsAppTargetCoupon()
		IsAppTargetCoupon = (Fvalidsitename = "app")
	end function

'	public Function getCouponLimitText()
'		if (IsTargetItemCoupon) then
'			getCouponLimitText = "<br>(상품번호 " + Ftargetitemlist & " 구매시 사용 가능)"
'		else
'			if (Fminbuyprice=0) then
'				getCouponLimitText = ""
'			else
'				getCouponLimitText = "<br>(상품금액 " + FormatNumber(Fminbuyprice,0) & "원 이상구매시 사용 가능)"
'			end if
'		end if
'	end function

    public function getCouponAddStringInBaguni()
        dim retStr
        if (Fmasteridx=0) then
            retStr = "("&getAvailDateStrFinish&"까지 "&FormatNumber(Fminbuyprice,0)&"이상구매시)"
        else
            ''getCouponTypeStr 할인
            if (InStr(Fcouponname,"할인")>0) then
                retStr = "("&getAvailDateStrFinish&"까지 "&FormatNumber(Fminbuyprice,0)&"이상구매시)"&getMaxDiscountStr
            else
                retStr = "("&getAvailDateStrFinish&"까지 "&FormatNumber(Fminbuyprice,0)&"이상구매시 "&getCouponTypeStr&" 할인)"&getMaxDiscountStr
            end if
        end if
        getCouponAddStringInBaguni = retStr
    end function
    
	public function getCouponTypeStr()
		if Fcoupontype="1" then
			getCouponTypeStr = FormatNumber(Fcouponvalue,0) + "%"
		elseif Fcoupontype="2" then
			getCouponTypeStr = FormatNumber(Fcouponvalue,0) + "원"
		elseif Fcoupontype="3" then
		    getCouponTypeStr = "배송비"
		end if
	end function

	public function getAvailDateStr()
	    getAvailDateStr = FormatDate(Fstartdate,"00/00/00") & "~" & FormatDate(Fexpiredate,"00/00/00")&" "&FormatDate(Fexpiredate,"00:00")&" 까지"
	end function

	public function getAvailDateStrFinish()
		getAvailDateStrFinish = Left(Fexpiredate,10)
	end function
    
    public function getValidTargetStr()
        if (IsFreedeliverCoupon) then
            'getValidTargetStr ="텐바이텐배송상품"
        elseif Fcoupontype="1" then
            If (IsAppTargetCoupon) Then
				getValidTargetStr ="일부상품제외,앱(APP)전용"
			Else
				getValidTargetStr ="일부상품제외"
			End If
        else
            if (IsTargetItemCoupon) then
                If (IsAppTargetCoupon) then
					getValidTargetStr = "상품번호 " & Ftargetitemlist & ",앱(APP)전용"
				Else
	                getValidTargetStr = "상품번호 " & Ftargetitemlist
				End if
            else
                If (IsAppTargetCoupon) then
					getValidTargetStr = "일부상품제외,앱(APP)전용"
				Else
					getValidTargetStr = "일부상품제외"
				End If 
				
				''2018/01/22
                if (Ftargetcpntype="C") Then
                    getValidTargetStr = ""
                end if
                
                if (Ftargetcpntype="B") Then
                    getValidTargetStr = ""
                end if
            end if
        end if
    end function
    
	public function getMiniumBuyPriceStr()
	    if (IsFreedeliverCoupon) then
            getMiniumBuyPriceStr ="" ''배송비 존재시
            
            if Fminbuyprice<>0 then
                getMiniumBuyPriceStr = getMiniumBuyPriceStr & "텐바이텐 배송 상품금액<br>" & ForMatNumber(Fminbuyprice,0) + "원 이상 구매시"
            end if
        else   
    		if (Fminbuyprice<>0) then
    			getMiniumBuyPriceStr = " " + ForMatNumber(Fminbuyprice,0) + "원 이상 구매시"
    		else
    			getMiniumBuyPriceStr = ""
    		end if
        end if
        
        ''2018/01/22
        if (Ftargetcpntype="C") then
            if (isNULL(Ftargetcatename) or (Ftargetcatename="")) then
                getMiniumBuyPriceStr = "해당카테고리 상품 "+getMiniumBuyPriceStr
            else
		        getMiniumBuyPriceStr = "카테고리("&replace(Ftargetcatename,"^^","&gt;")&") 상품 "+getMiniumBuyPriceStr
		    end if
		elseif (Ftargetcpntype="B") then
		    if (isNULL(Ftargetbrandname) or (Ftargetbrandname="")) then
		        getMiniumBuyPriceStr = "해당브랜드 상품 "+getMiniumBuyPriceStr
		    else
		        getMiniumBuyPriceStr = "브랜드("&Ftargetbrandname&") 상품 "+getMiniumBuyPriceStr
		    end if
		end if
		
		'// 2018 회원등급 개편 2018/07/24 
		if (FmxCpnDiscount>0) then
            getMiniumBuyPriceStr = getMiniumBuyPriceStr & " (최대 "&FormatNumber(FmxCpnDiscount,0)&"원 할인)"
        end if
	end function
	
	'// 2018 회원등급 개편 2018/07/24 
	public function getMaxDiscountStr()
	    getMaxDiscountStr = "" 
	    if Fcoupontype<>"1" then Exit function ''%쿠폰만 있을듯.

	    if (FmxCpnDiscount>0) then
            getMaxDiscountStr = " (최대 "&FormatNumber(FmxCpnDiscount,0)&"원 할인)"
        end if
    end function

	Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub
end Class

class CCoupon
	public FItemList()
    public FOneItem
    
	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount
	public FScrollCount

	public FRectUserID
	public FRectSsnKey
    
    public FRectOrderserial
    public FRectIsUsing
    public FRectDeleteYn
    
    public FGubun
    public FCardNO
    public FMasterIDX
    public FIDX
    public FRefIP
	public Fpcardno
	public Fscrachdate
	public Fexpiredate
	public FReturn
	public Fvalidsitename
    
    
    ''비회원 가능 쿠폰.
	public Sub getGuestsValidCouponList()
		dim i,sqlStr
		sqlStr = "select top 100 * "
		sqlStr = sqlStr + " from [db_user].[dbo].tbl_user_coupon "
		sqlStr = sqlStr + " where userid='guests'"
		sqlStr = sqlStr + " and ssnkey='" + FRectSsnKey + "'"
		sqlStr = sqlStr + " and deleteyn='N'"
		sqlStr = sqlStr + " and startdate<=getdate()"
		sqlStr = sqlStr + " and expiredate>getdate()"
		sqlStr = sqlStr + " and isusing='N'"
		sqlStr = sqlStr + " and notvalid10x10='N'"
		sqlStr = sqlStr + " order by idx desc "

		rsget.Open sqlStr, dbget, 1

		FResultCount = rsget.RecordCount
        FTotalCount  = FResultCount
        
		redim preserve FItemList(FResultCount)

		if  not rsget.EOF  then
		    i = 0
			do until rsget.eof
				set FItemList(i) = new CCouponItem
				FItemList(i).Fidx         = rsget("idx")
				FItemList(i).Fuserid      = rsget("userid")
				FItemList(i).Fcoupontype  = rsget("coupontype")
				FItemList(i).Fcouponvalue = rsget("couponvalue")
				FItemList(i).Fcouponname  = db2html(rsget("couponname"))
				FItemList(i).Fcouponimage = "http://www.10x10.co.kr/my10x10/images/" + rsget("couponimage")
				FItemList(i).Fregdate     = rsget("regdate")
				FItemList(i).Fstartdate   = rsget("startdate")
				FItemList(i).Fexpiredate  = rsget("expiredate")
				FItemList(i).Fisusing     = rsget("isusing")
				FItemList(i).Fdeleteyn    = rsget("deleteyn")

				FItemList(i).Fminbuyprice = rsget("minbuyprice")
				FItemList(i).Ftargetitemlist = rsget("targetitemlist")
				FItemList(i).Fcouponmeaipprice = rsget("couponmeaipprice")
				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.close
	end Sub

    ''회원 가능 쿠폰
	public Sub getValidCouponList()
		dim i,sqlStr
		sqlStr = "EXEC db_user.dbo.sp_Ten_UserBonusCouponList '" & FPageSize & "','" & FRectUserID & "','" & FGubun & "'"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open sqlStr,dbget,1
		FResultCount = rsget.Recordcount
        FTotalCount  = FResultCount
        
		redim preserve FItemList(FResultCount)

		if  not rsget.EOF  then
		    i = 0
			do until rsget.eof
				set FItemList(i) = new CCouponItem
				FItemList(i).Fidx         = rsget("idx")
				FItemList(i).fmasteridx         = rsget("masteridx")
				FItemList(i).Fuserid      = rsget("userid")
				FItemList(i).Fcoupontype  = rsget("coupontype")
				FItemList(i).Fcouponvalue = rsget("couponvalue")
				FItemList(i).Fcouponname  = db2html(rsget("couponname"))
				FItemList(i).Fcouponimage = "http://www.10x10.co.kr/my10x10/images/" + rsget("couponimage")
				FItemList(i).Fregdate     = rsget("regdate")
				FItemList(i).Fstartdate   = rsget("startdate")
				FItemList(i).Fexpiredate  = rsget("expiredate")
				FItemList(i).Fisusing     = rsget("isusing")
				FItemList(i).Fdeleteyn    = rsget("deleteyn")

				FItemList(i).Fminbuyprice = rsget("minbuyprice")
				FItemList(i).Ftargetitemlist = rsget("targetitemlist")
				FItemList(i).Fcouponmeaipprice = rsget("couponmeaipprice")
				FItemList(i).Fvalidsitename = rsget("validsitename")
				
				''2018/01/22 추가됨.
				FItemList(i).Ftargetcpntype     = rsget("targetcpntype")
				FItemList(i).Ftargetcpnsource   = rsget("targetcpnsource")
				FItemList(i).Ftargetcatename    = rsget("targetcatename")
				FItemList(i).Ftargetbrandname   = db2html(rsget("targetbrandname"))
				
				'// 2018 회원등급 개편 2018/07/24 mxCpnDiscount
				FItemList(i).FmxCpnDiscount     = rsget("mxCpnDiscount")
				if isNULL(FItemList(i).FmxCpnDiscount) then FItemList(i).FmxCpnDiscount=0

				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.close
	end Sub
   
	
    ''회원 모든 쿠폰(Expired 사용불가 포함)
	public Sub getAllCouponList()
		dim i,sqlStr
		sqlStr = " select count(idx) as cnt from [db_user].[dbo].tbl_user_coupon"
		sqlStr = sqlStr + " where userid='" + FRectUserID + "'"
		sqlStr = sqlStr + " and deleteyn='N'"

		rsget.Open sqlStr, dbget, 1
		FTotalCount = rsget("cnt")
		rsget.close

		sqlStr = "select top " + CStr(FPageSize * FCurrPage) + " * "
		sqlStr = sqlStr + " from [db_user].[dbo].tbl_user_coupon "
		sqlStr = sqlStr + " where userid='" + FRectUserID + "'"
		sqlStr = sqlStr + " and deleteyn='N'"
		sqlStr = sqlStr + " order by idx desc "

		rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget, 1

		FtotalPage =  CInt(FTotalCount\FPageSize)
		if  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) then
			FtotalPage = FtotalPage +1
		end if
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))

		redim preserve FItemList(FResultCount)

		if  not rsget.EOF  then
		    i = 0
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FItemList(i) = new CCouponItem
				FItemList(i).Fidx         = rsget("idx")
				FItemList(i).Fuserid      = rsget("userid")
				FItemList(i).Fcoupontype  = rsget("coupontype")
				FItemList(i).Fcouponvalue = rsget("couponvalue")
				FItemList(i).Fcouponname  = db2html(rsget("couponname"))
				FItemList(i).Fcouponimage = "http://www.10x10.co.kr/my10x10/images/" + rsget("couponimage")
				FItemList(i).Fregdate     = rsget("regdate")
				FItemList(i).Fstartdate   = rsget("startdate")
				FItemList(i).Fexpiredate  = rsget("expiredate")
				FItemList(i).Fisusing     = rsget("isusing")
				FItemList(i).Fdeleteyn    = rsget("deleteyn")

				FItemList(i).Fminbuyprice = rsget("minbuyprice")
				FItemList(i).Ftargetitemlist = rsget("targetitemlist")

				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.close

	end Sub
    
    public Sub getOneUserCoupon()
        dim sqlStr
        sqlStr = "select top " + CStr(FPageSize * FCurrPage) + " * "
		sqlStr = sqlStr + " from [db_user].[dbo].tbl_user_coupon "
		sqlStr = sqlStr + " where 1=1"
		
		if FRectUserID<>"" then
		    sqlStr = sqlStr + " and userid='" + FRectUserID + "'"
		end if
		
		if FRectOrderserial<>"" then
		    sqlStr = sqlStr + " and orderserial='" + FRectOrderserial + "'"
		end if
		
		if FRectIsUsing<>"" then
		    sqlStr = sqlStr + " and isusing='" + FRectIsUsing + "'"
		end if
		
		if FRectDeleteYn<>"" then
		    sqlStr = sqlStr + " and deleteyn='" + FRectDeleteYn + "'"
		end if
		
		sqlStr = sqlStr + " order by idx desc "
		
		rsget.Open sqlStr, dbget, 1
		FResultCount = rsget.RecordCount
		set FOneItem = new CCouponItem
		
		if  not rsget.EOF  then
			FOneItem.Fidx         = rsget("idx")
			FOneItem.Fuserid      = rsget("userid")
			FOneItem.Fcoupontype  = rsget("coupontype")
			FOneItem.Fcouponvalue = rsget("couponvalue")
			FOneItem.Fcouponname  = db2html(rsget("couponname"))
			
			FOneItem.Fregdate     = rsget("regdate")
			FOneItem.Fstartdate   = rsget("startdate")
			FOneItem.Fexpiredate  = rsget("expiredate")
			FOneItem.Fisusing     = rsget("isusing")
			FOneItem.Fdeleteyn    = rsget("deleteyn")

			FOneItem.Fminbuyprice = rsget("minbuyprice")
			FOneItem.Ftargetitemlist = rsget("targetitemlist")
			
			FOneItem.Fcouponimage = "http://www.10x10.co.kr/my10x10/images/" + rsget("couponimage")

		end if
		rsget.close
		
    end Sub
    
    
	public Sub UserCouponProc()
		dim i,sqlStr
		sqlStr = "EXEC db_user.dbo.sp_Ten_UserCouponProc '" & FGubun & "','" & FCardNO & "','" & FMasterIDX & "','" & FRectUserID & "','" & FIDX & "','" & FRefIP & "'"
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open sqlStr,dbget,1

		If FGubun = "1" Then
			set FOneItem = new CCoupon
			if  not rsget.EOF  then
				FOneItem.Fidx = rsget("idx")
				FOneItem.Fmasteridx = rsget("couponmasteridx")
				FOneItem.Fpcardno = rsget("authodata")
				FOneItem.Fexpiredate = rsget("expiredate")
				FOneItem.Fscrachdate = rsget("scrachdate")
				FOneItem.Fvalidsitename = rsget("validsitename")
				
				if IsNULL(FOneItem.Fvalidsitename) then FOneItem.Fvalidsitename=""
			else
				FOneItem.Fidx = ""
			end if
		ElseIf FGubun = "2" Then
			set FOneItem = new CCouponItem
			if  not rsget.EOF  then
				FOneItem.Fidx = rsget("idx")
			else
				FOneItem.Fidx = ""
			end if
		ElseIf FGubun = "3" Then
			set FOneItem = new CCouponItem
			if  not rsget.EOF  then
				FOneItem.FReturn = rsget(0)
			else
				FOneItem.FReturn = "0"
			end if
		End If
		rsget.close
	end Sub
	
    
	Private Sub Class_Initialize()
		redim preserve FItemList(0)

		FCurrPage         = 1
		FPageSize         = 10
		FResultCount      = 0
		FScrollCount      = 10
		FTotalCount       = 0

	End Sub

	Private Sub Class_Terminate()

	End Sub

	public Function HasPreScroll()
		HasPreScroll = StarScrollPage > 1
	end Function

	public Function HasNextScroll()
		HasNextScroll = FTotalPage > StarScrollPage + FScrollCount -1
	end Function

	public Function StarScrollPage()
		StarScrollPage = ((FCurrpage-1)\FScrollCount)*FScrollCount +1
	end Function
end Class

%>

<%
Class CExpireYearItem
    public FregYear
    public Fuserid
    public Fexpiredate
    public Fbonusgainmileage
    public Fordergainmileage
    public Forderminusmileage
    public FpreYearAssignedSpendmileage
    public FrealExpiredMileage

    public FspendMileage
    public FaccumulateGainSum
    public FaccumulateOrderMinusMileage
    public FaccumulateExpiredSum

    public function getKorExpireDateStr()
        getKorExpireDateStr = Left(Fexpiredate,4) &"년 " & Mid(Fexpiredate,6,2) & "월 " & Mid(Fexpiredate,9,2) & "일"
    end function

    public function getMayExpireTotal()
        getMayExpireTotal = getGainMileage-Fspendmileage-FrealExpiredMileage

        if (getMayExpireTotal<1) then getMayExpireTotal=0
    end function

    public function getGainMileage()
        getGainMileage = Fbonusgainmileage + Fordergainmileage + Forderminusmileage
    end function

    public function getYearMaySpendMileage_OLD()
        dim acctremain
        acctremain = (FaccumulateGainSum + FaccumulateOrderMinusMileage) - Fspendmileage
        if (acctremain=<0) then
            getYearMaySpendMileage_OLD = getGainMileage
        elseif (acctremain>=getGainMileage) then
            getYearMaySpendMileage_OLD = 0
        else
            getYearMaySpendMileage_OLD = getGainMileage-acctremain
        end if


    end function

    public function getYearMaySpendMileage()
        dim acctremain
        acctremain = (FaccumulateGainSum + FaccumulateOrderMinusMileage - (FaccumulateExpiredSum - FrealExpiredMileage)) - Fspendmileage

        if (acctremain=<0) or (acctremain<=FrealExpiredMileage) then
            getYearMaySpendMileage = getGainMileage - FrealExpiredMileage
        elseif (acctremain>=getGainMileage) then
            getYearMaySpendMileage = 0
        elseif (getGainMileage<=FrealExpiredMileage) then
            getYearMaySpendMileage = 0
        else
            getYearMaySpendMileage = getGainMileage - FrealExpiredMileage -acctremain
        end if
    end function


    public function getYearMayRemainMileage()
        getYearMayRemainMileage = getGainMileage - getYearMaySpendMileage - FrealExpiredMileage
    end function

    Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub
end Class

class CMileageLogItem
	public Fid
	public Fuserid
	public Fmileage
	public Fjukyocd
	public Fjukyo
	public Fregdate
	public Forderserial
	public Fitemid
	public Fdeleteyn
	public Fstatusflag
	public Fremain
	public Fstatusflagstring

	Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub
end Class

class CMileageLog
	public FItemList()
    public FOneItem

	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount
	public FScrollCount

	public FRectUserID
	public FRectMileageLogType
    public FRectExpireDate
    public FRectShowDelete

	public Sub getMileageLog()
		dim sqlStr, i
        sqlStr = "exec [db_user].[dbo].sp_Ten_UserMileageLog_Count '" & FRectUserID & "','" & FRectMileageLogType & "'"

        rsget.Open sqlStr,dbget,1
		    FTotalCount = rsget("Cnt")
		rsget.Close

        sqlStr = "exec [db_user].[dbo].sp_Ten_UserMileageLog " & CStr(FPageSize*FCurrPage) & ",'" & FRectUserID & "','" & FRectMileageLogType & "'"

        rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic

		rsget.pagesize = FPageSize
		rsget.Open sqlStr,dbget,1

		FtotalPage =  CInt(FTotalCount\FPageSize)
		if  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) then
			FtotalPage = FtotalPage +1
		end if
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
        IF (FResultCount<1) then FResultCount=0

		redim preserve FItemList(FResultCount)
		i=0
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FItemList(i) = new CMileageLogItem
				FItemList(i).Fuserid        = FRectUserID
				FItemList(i).Fmileage       = rsget("mileage")
				FItemList(i).Fjukyocd       = rsget("jukyocd")
				FItemList(i).Fregdate       = chkIIF(isNull(rsget("regdate")),"",rsget("regdate"))
				FItemList(i).Forderserial   = rsget("orderserial")

				if (FRectMileageLogType="O") then
				    if (FItemList(i).Fmileage<0) then
				        FItemList(i).Fjukyo         = "주문반품"
				    else
    				    FItemList(i).Fjukyo         = "주문적립"
    				end if
    				FItemList(i).Fdeleteyn      = "N"
				else
				    FItemList(i).Fid            = rsget("id")
    				FItemList(i).Fjukyo         = html2db(rsget("jukyo"))
    				FItemList(i).Fitemid        = rsget("itemid")
    				FItemList(i).Fdeleteyn      = rsget("deleteyn")
                end if

				i=i+1
				rsget.moveNext
			loop
		end if

		rsget.Close


	end Sub
	
	public Sub getMileageLogAll()

		dim sqlStr, i

	    FTotalCount = 0
	    FResultCount = 0

        sqlStr = "exec [db_user].[dbo].sp_Ten_UserMileageLogAllCount " & FPageSize & ", " & FCurrPage & ", '" & FRectUserID & "', '" & FRectShowDelete & "' "
        rsget.CursorLocation = adUseClient                              ''' require RecordCount
	    rsget.Open sqlStr,dbget,adOpenForwardOnly, adLockReadOnly
	    if Not (Rsget.Eof) then
	        FTotalCount = rsget("CNT")
	    end if
	    rsget.Close

	    sqlStr = "exec [db_user].[dbo].sp_Ten_UserMileageLogAll " & FPageSize & ", " & FCurrPage & ", '" & FRectUserID & "', '" & FRectShowDelete & "' "
	    rsget.CursorLocation = adUseClient                              ''' require RecordCount
	    rsget.Open sqlStr,dbget,adOpenForwardOnly, adLockReadOnly

		FResultCount = rsget.RecordCount
	    if (FResultCount<1) then FResultCount=0
		FTotalPage = CInt(FTotalCount\FPageSize) + 1

	    redim preserve FItemList(FResultCount)

	    i = 0
	    if Not (Rsget.Eof) then
	        do until rsget.eof
				set FItemList(i) = new CMileageLogItem

		        Fitemlist(i).FUserID = FRectUserID
		        Fitemlist(i).Fmileage = rsget("mileage")
		        Fitemlist(i).Fjukyocd = rsget("jukyocd")
		        Fitemlist(i).Fjukyo = rsget("jukyo")
		        Fitemlist(i).Fregdate = rsget("regdate")
		        Fitemlist(i).Forderserial = rsget("orderserial")
		        Fitemlist(i).Fdeleteyn = rsget("deleteyn")
		        Fitemlist(i).Fstatusflag = rsget("statusflag")
		        Fitemlist(i).Fremain = rsget("remain")

		        if (Fitemlist(i).Fstatusflag = "S") then
		        	Fitemlist(i).Fstatusflagstring = "사용"
		        elseif (Fitemlist(i).Fstatusflag = "B") then
		        	Fitemlist(i).Fstatusflagstring = "보너스"
		        elseif (Fitemlist(i).Fstatusflag = "X") then
		        	Fitemlist(i).Fstatusflagstring = "소멸"
		        else
		        	Fitemlist(i).Fstatusflagstring = "주문"
		        end if

				if ((FRectMileageLogType="O") or ((FRectMileageLogType="A") and (rsget("userid")="O"))) then
				    if (FItemList(i).Fmileage < 0) then
				        FItemList(i).Fjukyo         = "주문반품"
				    else
    				    FItemList(i).Fjukyo         = "주문적립"
    				end if
				end if
                i=i+1
				rsget.moveNext

            loop
	    end if
    	rsget.Close
	end sub


    ''다음년초에 Expire될 마일리지 합계.
    public Sub getNextExpireMileageSum()
        dim sqlStr

        sqlStr = " select c.userid, c.spendmileage,'"&FRectExpireDate&"' as expiredate,"
        sqlStr = sqlStr & " IsNULL(T.bonusgainmileage,0) as bonusgainmileage, IsNULL(T.ordergainmileage,0) as ordergainmileage,"
        sqlStr = sqlStr & " IsNULL(T.orderminusmileage,0) as orderminusmileage, IsNULL(T.preYearAssignedSpendMileage,0) as preYearAssignedSpendMileage,"
        sqlStr = sqlStr & " IsNULL(T.realExpiredMileage,0) as realExpiredMileage"
        sqlStr = sqlStr & " from db_user.[dbo].tbl_user_current_mileage c"
        sqlStr = sqlStr & " left join ("
        sqlStr = sqlStr & "     select e.userid,  sum(e.bonusgainmileage) as bonusgainmileage, sum(e.ordergainmileage) as ordergainmileage,"
        sqlStr = sqlStr & "     sum(e.orderminusmileage) as orderminusmileage, sum(e.preYearAssignedSpendMileage) as preYearAssignedSpendMileage,"
        sqlStr = sqlStr & "     sum(e.realExpiredMileage) as realExpiredMileage"
        sqlStr = sqlStr & "     from db_user.dbo.tbl_mileage_Year_Expire e"
        sqlStr = sqlStr & "     where e.userid='" & FRectUserid & "'"
        sqlStr = sqlStr & "     and e.expiredate<='" & FRectExpireDate & "'"
        sqlStr = sqlStr & "     group by e.userid"
        sqlStr = sqlStr & " ) T"
        sqlStr = sqlStr & " on c.userid=T.userid"
        sqlStr = sqlStr & " where c.userid='" & FRectUserid & "'"

        rsget.Open sqlStr,dbget,1

        FTotalCount = rsget.RecordCount
        FResultCount = FTotalCount


        if  not rsget.EOF  then
			set FOneItem = new CExpireYearItem
            FOneItem.Fuserid                      = rsget("userid")
            FOneItem.Fexpiredate                  = FRectExpireDate
            FOneItem.Fbonusgainmileage            = rsget("bonusgainmileage")
            FOneItem.Fordergainmileage            = rsget("ordergainmileage")
            FOneItem.Forderminusmileage           = rsget("orderminusmileage")
            FOneItem.FpreYearAssignedSpendmileage = rsget("preYearAssignedSpendmileage")
            FOneItem.FrealExpiredMileage          = rsget("realExpiredMileage")

            FOneItem.FspendMileage                = rsget("spendMileage")
        else
            '' 만료 예정내역이 없을 경우.
            set FOneItem = new CExpireYearItem
            FOneItem.Fuserid = FRectUserid
            FOneItem.Fexpiredate = FRectExpireDate
            FOneItem.Fbonusgainmileage  = 0
            FOneItem.Fordergainmileage  = 0
            FOneItem.FpreYearAssignedSpendmileage = 0
            FOneItem.FrealExpiredMileage = 0
            FOneItem.FspendMileage = 0
		end if
		rsget.Close

    end sub


    ''다음년초에 Expire될 마일리지 년도별 합계.
    public Sub getNextExpireMileageYearList()
        dim sqlStr,i
        dim t_accumulateGainSum, t_accumulateOrderMinusMileage, t_accumulateExpiredSum

        sqlStr = " select e.regYear, e.userid, e.expiredate, e.bonusgainmileage, e.ordergainmileage,"
        sqlStr = sqlStr & " e.orderminusmileage, e.preYearAssignedSpendMileage,"
        sqlStr = sqlStr & " e.realExpiredMileage,"
        sqlStr = sqlStr & " IsNULL(c.spendmileage,0) as spendmileage"
        sqlStr = sqlStr & " from db_user.dbo.tbl_mileage_Year_Expire e"
        sqlStr = sqlStr & " left join db_user.[dbo].tbl_user_current_mileage c"
        sqlStr = sqlStr & " on e.userid=c.userid"
        sqlStr = sqlStr & " where e.userid='" & FRectUserid & "'"
        if (FRectExpireDate<>"") then
            sqlStr = sqlStr & " and e.expiredate='" & FRectExpireDate & "'"
        end if
        sqlStr = sqlStr & " order by e.regYear"
		''response.write sqlStr

        rsget.pagesize = FPageSize
		rsget.Open sqlStr,dbget,1

		FtotalPage =  CInt(FTotalCount\FPageSize)
		if  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) then
			FtotalPage = FtotalPage +1
		end if
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))

        if (FResultCount<1) then FResultCount=0

		redim preserve FItemList(FResultCount)
		i=0
		t_accumulateGainSum =0
		t_accumulateOrderMinusMileage =0
		t_accumulateExpiredSum =0
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.eof
    			set FItemList(i) = new CExpireYearItem
    			FItemList(i).FregYear                       = rsget("regYear")
                FItemList(i).Fuserid                        = rsget("userid")
                FItemList(i).Fexpiredate                    = rsget("expiredate")
                FItemList(i).Fbonusgainmileage              = rsget("bonusgainmileage")
                FItemList(i).Fordergainmileage              = rsget("ordergainmileage")
                FItemList(i).Forderminusmileage             = rsget("orderminusmileage")
                FItemList(i).FpreYearAssignedSpendmileage   = rsget("preYearAssignedSpendmileage")
                FItemList(i).FrealExpiredMileage            = rsget("realExpiredMileage")

                FItemList(i).FspendMileage                  = rsget("spendMileage")

                ''누적 적립마일리지
                t_accumulateGainSum                         = t_accumulateGainSum + FItemList(i).Fbonusgainmileage + FItemList(i).Fordergainmileage
                t_accumulateOrderMinusMileage               = t_accumulateOrderMinusMileage + FItemList(i).Forderminusmileage
                t_accumulateExpiredSum                      = t_accumulateExpiredSum + FItemList(i).FrealExpiredMileage
                FItemList(i).FaccumulateGainSum             = t_accumulateGainSum
                FItemList(i).FaccumulateOrderMinusMileage   = t_accumulateOrderMinusMileage
                FItemList(i).FaccumulateExpiredSum          = t_accumulateExpiredSum
                i=i+1
				rsget.moveNext
			loop
		end if

		rsget.Close

    end sub


	Private Sub Class_Initialize()
		redim FItemList(0)
		FCurrPage =1
		FPageSize = 12
		FResultCount = 0
		FScrollCount = 10
		FTotalCount =0

	End Sub

	Private Sub Class_Terminate()

	End Sub

	public Function HasPreScroll()
		HasPreScroll = StartScrollPage > 1
	end Function

	public Function HasNextScroll()
		HasNextScroll = FTotalPage > StartScrollPage + FScrollCount -1
	end Function

	public Function StartScrollPage()
		StartScrollPage = ((FCurrpage-1)\FScrollCount)*FScrollCount +1
	end Function
end Class

%>

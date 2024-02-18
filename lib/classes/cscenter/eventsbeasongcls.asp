<%
Class CEventsBeasongItem
	public Fid
	public Fgubuncd
	public Fgubunname
	public Fuserid
	public Fusername
	public Freqname
	public Freqphone
	public Freqhp
	public Freqzipcode
	public Freqzipcode2
	public Freqaddress1
	public Freqaddress2
	public Freqetc
	public Fregdate
	public Fsongjangno
	public Fsongjangdiv
	public Fsenddate
	public Fissended
	public Finputdate
	public FPrizeTitle
	public FPCode
	public Fstatus
	public FreqDeliverDate
	public Fprizetype

	public function IsInputData()
		if IsNULL(Finputdate) or (Finputdate="") then
			IsInputData = false
		else
			IsInputData = true
		end if
	end function

	public function IsSended()
		if (Fissended="Y") then
			IsSended = true
		else
			IsSended = false
		end if
	end function

	Private Sub Class_Initialize()
                '
	End Sub

	Private Sub Class_Terminate()
                '
	End Sub

end Class

Class CEventsBeasong
	public FOneItem
	public FItemList()

	public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount
	public FScrollCount
	public FTotalCount

	public FRectUserID
	public FRectId

	Private Sub Class_Initialize()
        redim preserve FItemList(0)
        FCurrPage =1

		FPageSize = 10
		FResultCount = 0
		FScrollCount = 10
		FTotalCount =0
	End Sub

	Private Sub Class_Terminate()
                '
	End Sub

	public Sub GetOneWinnerItem()
		dim sqlStr , i
		sqlStr = "select top 1 a.*, a.evtprize_code, b.giftkind_name, c.evtprize_status, c.evtprize_type from [db_sitemaster].[dbo].tbl_etc_songjang as a left outer join [db_event].[dbo].[tbl_giftkind] as b "
		sqlStr = sqlStr + " on a.evtprize_giftkindcode = b.giftkind_code "
		sqlStr = sqlStr + " 	left outer join [db_event].[dbo].[tbl_event_prize] as c on a.evtprize_code = c.evtprize_code "
		sqlStr = sqlStr + " where  id=" + CStr(FRectId) + ""
		sqlStr = sqlStr + " and userid='" + FRectUserID + "'"
        sqlStr = sqlStr + " and deleteyn='N'"        
		rsget.Open sqlStr,dbget,1

		FResultCount = rsget.RecordCount

		if Not rsget.Eof then
			set FOneItem = new CEventsBeasongItem

			FOneItem.Fid           = rsget("id")
			FOneItem.Fgubuncd      = rsget("gubuncd")
			FOneItem.Fgubunname    = db2html(rsget("gubunname"))
			FOneItem.Fuserid       = rsget("userid")
			FOneItem.Fusername     = db2html(rsget("username"))
			FOneItem.Freqname      = db2html(rsget("reqname"))
			FOneItem.Freqphone     = rsget("reqphone")
			FOneItem.Freqhp        = rsget("reqhp")
			FOneItem.Freqzipcode   = rsget("reqzipcode")
'			FOneItem.Freqzipcode   = left(rsget("reqzipcode"),3)
'			FOneItem.Freqzipcode2   = right(rsget("reqzipcode"),3)
			FOneItem.Freqaddress1  = db2html(rsget("reqaddress1"))
			FOneItem.Freqaddress2  = db2html(rsget("reqaddress2"))
			FOneItem.Freqetc       = db2html(rsget("reqetc"))
			FOneItem.Fregdate      = rsget("regdate")
			FOneItem.Fsongjangno   = rsget("songjangno")
			FOneItem.Fsongjangdiv  = rsget("songjangdiv")
			FOneItem.Fsenddate     = rsget("senddate")
			FOneItem.Fissended     = rsget("issended")
			FOneItem.Finputdate	   = rsget("inputdate")
			FOneItem.FPCode			= rsget("evtprize_code")
			IF rsget("giftkind_name") <> "" THEN
				FOneItem.FPrizeTitle	= db2html(rsget("giftkind_name"))
			ELSE	
				FOneItem.FPrizeTitle	= db2html(rsget("prizetitle"))
			END IF
			FOneItem.Fstatus			= rsget("evtprize_status")
			FOneItem.FreqDeliverDate	= rsget("reqdeliverdate")
			FOneItem.Fprizetype			= rsget("evtprize_type")
			
		end if
		rsget.close

	end Sub

	public Sub GetWinnerList()
		dim sqlStr , i

		sqlStr = "select count(id) as cnt from [db_sitemaster].[dbo].tbl_etc_songjang"
		sqlStr = sqlStr + " where userid='" + FRectUserID + "'"
        sqlStr = sqlStr + " and deleteyn='N'"
		''1달 안에 입력안하면 보이지 않게 함..
		sqlStr = sqlStr + " and ((inputdate is Not Null) or ((inputdate is Null) and (datediff(d,regdate,getdate())<31)))"
		if FRectId<>"" then
			sqlStr = sqlStr + " and id=" + FRectId + ""
		end if

		rsget.Open sqlStr,dbget,1
		    FTotalCount = rsget("cnt")
		rsget.Close

		sqlStr = "select top " + CStr(FPageSize*FCurrPage) + " * from [db_sitemaster].[dbo].tbl_etc_songjang"
		sqlStr = sqlStr + " where userid='" + FRectUserID + "'"
		sqlStr = sqlStr + " and deleteyn='N'"
		sqlStr = sqlStr + " and ((inputdate is Not Null) or ((inputdate is Null) and (datediff(d,regdate,getdate())<31)))"
		if FRectId<>"" then
			sqlStr = sqlStr + " and id=" + FRectId + ""
		end if
		sqlStr = sqlStr + " order by id desc"

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
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FItemList(i) = new CEventsBeasongItem

				FItemList(i).Fid           = rsget("id")
				FItemList(i).Fgubuncd      = rsget("gubuncd")
				FItemList(i).Fgubunname    = db2html(rsget("gubunname"))
				FItemList(i).Fuserid       = rsget("userid")
				FItemList(i).Fusername     = db2html(rsget("username"))
				FItemList(i).Freqname      = db2html(rsget("reqname"))
				FItemList(i).Freqphone     = rsget("reqphone")
				FItemList(i).Freqhp        = rsget("reqhp")
				FItemList(i).Freqzipcode   = rsget("reqzipcode")
				FItemList(i).Freqaddress1  = db2html(rsget("reqaddress1"))
				FItemList(i).Freqaddress2  = db2html(rsget("reqaddress2"))
				FItemList(i).Freqetc       = db2html(rsget("reqetc"))
				FItemList(i).Fregdate      = rsget("regdate")
				FItemList(i).Fsongjangno   = rsget("songjangno")
				FItemList(i).Fsongjangdiv  = rsget("songjangdiv")
				FItemList(i).Fsenddate     = rsget("senddate")
				FItemList(i).Fissended     = rsget("issended")
				FItemList(i).Finputdate	   = rsget("inputdate")
				FItemList(i).FPrizeTitle	= db2html(rsget("prizetitle"))
				i=i+1
				rsget.moveNext
			loop
		end if

		rsget.Close

	end Sub

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
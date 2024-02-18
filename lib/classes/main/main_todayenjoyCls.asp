<%
'###############################################
' PageName :enjoyevent
' Discription : 사이트 메인 공지 배너 관리
' History : 2014.06.09 이종화 생성
'###############################################

Class CMainbannerItem
	public fidx
	Public Fevtimg
	Public Fevtalt
	Public Flinktype
	Public Flinkurl
	Public Fevttitle
	Public Fissalecoupon
	Public Fissalecoupontxt
	Public Fevtstdate
	Public Fevteddate
	Public Fstartdate
	Public Fenddate 
	Public Fadminid
	Public Flastadminid
	public Fisusing 
	Public Fregdate
	Public Fusername
	Public Flastupdate
	Public Fordertext
	Public Fsortnum
	Public Ftodaybanner

	Public Fxmlregdate
	
    Private Sub Class_Initialize()
	End Sub
	Private Sub Class_Terminate()
	End Sub
end Class

Class CMainbanner
    public FOneItem
    public FItemList()

	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount
	public FScrollCount
       
    public FRectIdx
    public Fisusing
	Public Fsdt
	Public Fedt
	
	'//admin/appmanage/today/enjoyevent/enjoy_insert.asp
    public Sub GetOneContents()
        dim sqlStr
        sqlStr = "select top 1 t.* , d.evt_todaybanner "
        sqlStr = sqlStr + " from db_sitemaster.dbo.tbl_mobile_main_enjoyevent_new as t "
		sqlStr = sqlStr + " left outer join db_event.dbo.tbl_event_display as d "
        sqlStr = sqlStr + " on t.evt_code = d.evt_code"
        sqlStr = sqlStr + " where idx=" + CStr(FRectIdx)

		'rw sqlStr & "<Br>"
        rsget.Open SqlStr, dbget, 1
        FResultCount = rsget.RecordCount
        
        set FOneItem = new CMainbannerItem
        
        if Not rsget.Eof then
    		FOneItem.fidx				= rsget("idx")
			FOneItem.Fevtimg			= staticImgUrl & "/mobile/enjoyevent" & rsget("evtimg")
			FOneItem.Fevtalt			= rsget("evtalt")
			FOneItem.Flinkurl			= rsget("linkurl")
			FOneItem.Fevttitle			= rsget("evttitle")
			FOneItem.Fissalecoupon		= rsget("issalecoupon")
			FOneItem.Fevtstdate			= rsget("evtstdate")
			FOneItem.Fevteddate			= rsget("evteddate")
			FOneItem.Fissalecoupontxt	= rsget("issalecoupontxt")
			FOneItem.Fstartdate			= rsget("startdate")
			FOneItem.Fenddate			= rsget("enddate")
			FOneItem.Fadminid			= rsget("adminid")
			FOneItem.Flastadminid		= rsget("lastadminid")
			FOneItem.Fisusing			= rsget("isusing")
			FOneItem.Fordertext			= rsget("ordertext")
			FOneItem.Flinktype			= rsget("linktype")
			FOneItem.Fsortnum			= rsget("sortnum")
			FOneItem.Ftodaybanner		= rsget("evt_todaybanner")
        end If
        
        rsget.Close
    end Sub
	
	'//admin/appmanage/today/enjoyevent/index.asp
    public Sub GetContentsList()
        dim sqlStr, i

		sqlStr = " select count(idx) as cnt from db_sitemaster.dbo.tbl_mobile_main_enjoyevent_new "
		sqlStr = sqlStr + " where 1=1"
        
        if Fisusing<>"" then
            sqlStr = sqlStr + " and isusing='" + CStr(Fisusing) + "'"
        end If

		if Fsdt<>"" then sqlStr = sqlStr & " and StartDate>='" & Fsdt & " 00:00:00' and StartDate<='" & Fsdt & " 23:59:59' "

		'response.write sqlStr &"<br>"
        rsget.Open sqlStr, dbget, 1
			FTotalCount = rsget("cnt")
		rsget.close
        
        if FTotalCount < 1 then exit Sub
        	
        sqlStr = "select top " + CStr(FPageSize * FCurrPage) + " "
		 sqlStr = sqlStr + " t.idx , t.evtimg , t.evtalt , t.linkurl , t.evttitle , t.issalecoupon , t.startdate , t.enddate , t.adminid , t.lastadminid , t.isusing ,t.regdate , t.lastupdate , t.xmlregdate , t.linktype , t.sortnum , d.evt_todaybanner"
        sqlStr = sqlStr + " from db_sitemaster.dbo.tbl_mobile_main_enjoyevent_new as t "
        sqlStr = sqlStr + " left outer join db_event.dbo.tbl_event_display as d "
        sqlStr = sqlStr + " on t.evt_code = d.evt_code"
        sqlStr = sqlStr + " where 1=1"

		'Response.write sqlStr

        if Fisusing<>"" then
            sqlStr = sqlStr + " and isusing='" + CStr(Fisusing) + "'"
        end If

		if Fsdt<>"" then sqlStr = sqlStr & " and StartDate>='" & Fsdt & " 00:00:00' and StartDate<='" & Fsdt & " 23:59:59' "
        
		sqlStr = sqlStr + " order by  t.idx desc" 

		'response.write sqlStr &"<br>"
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
				set FItemList(i) = new CMainbannerItem
				
				FItemList(i).fidx				= rsget("idx")
				FItemList(i).Fevtimg			= staticImgUrl & "/mobile/enjoyevent" & rsget("evtimg")
				FItemList(i).Fevtalt			= rsget("evtalt")
				FItemList(i).Flinkurl			= rsget("linkurl")
				FItemList(i).Fevttitle			= rsget("evttitle")
				FItemList(i).Fissalecoupon		= rsget("issalecoupon")
				FItemList(i).Fstartdate			= rsget("startdate")
				FItemList(i).Fenddate			= rsget("enddate")
				FItemList(i).Fadminid			= rsget("adminid")
				FItemList(i).Flastadminid		= rsget("lastadminid")
				FItemList(i).Fisusing			= rsget("isusing")
				FItemList(i).Fregdate			= rsget("regdate")
				FItemList(i).Flastupdate		= rsget("lastupdate")
				FItemList(i).Fxmlregdate		= rsget("xmlregdate")
				FItemList(i).Flinktype			= rsget("linktype")
				FItemList(i).Fsortnum			= rsget("sortnum")
				FItemList(i).Ftodaybanner		= rsget("evt_todaybanner")

				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.close
    end Sub
    

    Private Sub Class_Initialize()
		redim  FItemList(0)

		FCurrPage         = 1
		FPageSize         = 10
		FResultCount      = 0
		FScrollCount      = 10
		FTotalCount       = 0

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

'// STAFF 이름 접수
public Function getStaffUserName(uid)
	if uid="" or isNull(uid) then
		exit Function
	end if

	Dim strSql
	strSql = "Select top 1 username From db_partner.dbo.tbl_user_tenbyten Where userid='" & uid & "'"
	rsget.Open strSql, dbget, 1
	if Not(rsget.EOF or rsget.BOF) then
		getStaffUserName = rsget("username")
	end if
	rsget.Close
End Function
%>
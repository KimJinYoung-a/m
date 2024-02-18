<%
'//evt 49169
Class Cevt_49169
	public FUserid
	public Fitemid
	public Fitemimg
	public Fitemname

    Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub
end Class


Class Cevt_49169_c
    public FItemList()

	public FTotalCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FResultCount
	public FScrollCount

	Public FRectEvtcode

	public function evt_itemlist()
        dim sqlStr, sqlsearch, i

		If FRectEvtcode <> "" Then
			sqlsearch = sqlsearch & " and e.evt_code = '"& FRectEvtcode  &"'"
		End If 

		sqlStr = "select count(*) as cnt"
        sqlStr = sqlStr & " from db_event.dbo.tbl_event_subscript as e "
        sqlStr = sqlStr & " inner join db_item.dbo.tbl_item as i "
        sqlStr = sqlStr & " on e.sub_opt1 = i.itemid "
        sqlStr = sqlStr & " where 1=1 " & sqlsearch

		'response.write sqlStr &"<Br>"
        rsget.Open sqlStr,dbget,1
            FTotalCount = rsget("cnt")
        rsget.Close

		if FTotalCount < 1 then exit function

        ''// 본문 내용 접수
        sqlStr = "select top " + Cstr(FPageSize * FCurrPage)
        sqlStr = sqlStr & " e.userid , i.itemid , i.itemname , i.basicimage "
        sqlStr = sqlStr & " from db_event.dbo.tbl_event_subscript as e "
        sqlStr = sqlStr & " inner join db_item.dbo.tbl_item as i "
        sqlStr = sqlStr & " on e.sub_opt1 = i.itemid "
        sqlStr = sqlStr & " where 1=1 " & sqlsearch
        sqlStr = sqlStr & " order by e.sub_idx desc "

		'' response.write sqlStr &"<Br>"
		'' response.end
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
            do until rsget.EOF
                set FItemList(i) = new Cevt_49169

                FItemList(i).Fuserid					= rsget("userid")
				FItemList(i).Fitemid					= rsget("itemid")
				FItemList(i).Fitemname				= rsget("itemname")
                FItemList(i).Fitemimg				= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("basicimage")

                rsget.movenext
                i=i+1
            loop
        end if
        rsget.Close
    end Function

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
%>

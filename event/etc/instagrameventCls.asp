<%
'###########################################################
' Description : 인스타그램 이벤트 데이터 리스트
' Hieditor : 2016.06.23 유태욱 생성
'###########################################################
%>
<%
class CinstagrameventItem
	Private Sub Class_Initialize()
	End Sub
	Private Sub Class_Terminate()
	End Sub

	public Fcontentsidx
	public Fevt_code
	public Fuserid
	public Fimgurl
	public Flinkurl
	public Fisusing
	public FRegdate
end class

				
class Cinstagrameventlist
	public FItemList()
	public FCurrPage
	public FPageSize
	public FPageCount
	public FTotalPage
	public FTotalCount
	public FScrollCount
	public FResultCount
	
	public FrectIsusing
	public	FrectEcode

	public Function fnGetinstagrameventList
		dim sqlStr, sqlsearch, i

		if FrectIsusing <> "" then
			sqlsearch = sqlsearch & " and isusing = '"&FrectIsusing&"'"
		end If

		if FrectEcode <> "" then
			sqlsearch = sqlsearch & " and evt_code = '"&FrectEcode&"'"
		end If
		
		'글의 총 갯수 구하기
		sqlStr = "select count(*) as cnt"
		sqlStr = sqlStr & " from [db_temp].[dbo].[tbl_event_instagram]"
		sqlStr = sqlStr & " where 1=1 " & sqlsearch

		'response.write sqlStr &"<br>"	
		rsget.Open sqlStr,dbget,1
			FTotalCount = rsget("cnt")
		rsget.Close

		'DB 데이터 리스트
		sqlStr = "select top " & Cstr(FPageSize * FCurrPage)
		sqlStr = sqlStr & " idx,evt_code,imgurl,userid,linkurl,isusing,regdate"
		sqlStr = sqlStr & " from [db_temp].[dbo].[tbl_event_instagram]"
		sqlStr = sqlStr & " where 1=1 " & sqlsearch +  vbcrlf
		sqlStr = sqlStr & " order by idx Desc"

		'response.write sqlStr &"<br>"
		rsget.pagesize = FPageSize
		rsget.Open sqlStr,dbget,1

		if (FCurrPage * FPageSize < FTotalCount) then
			FResultCount = FPageSize
		else
			FResultCount = FTotalCount - FPageSize*(FCurrPage-1)
		end if

		FTotalPage = (FTotalCount\FPageSize)
		if (FTotalPage<>FTotalCount/FPageSize) then FTotalPage = FTotalPage +1

		redim preserve FItemList(FResultCount)

		FPageCount = FCurrPage - 1

		i=0
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.EOF
				set FItemList(i) = new CinstagrameventItem
				FItemList(i).Fcontentsidx= rsget("idx")
				FItemList(i).Fevt_code	= rsget("evt_code")
				FItemList(i).Fimgurl 	= rsget("imgurl")
				FItemList(i).Fuserid 	= db2html(rsget("userid"))
				FItemList(i).Flinkurl	= rsget("linkurl")
				FItemList(i).FIsusing 	= rsget("isusing")
				FItemList(i).FRegdate 	= rsget("regdate")
				rsget.movenext
				i=i+1
			loop
		end if
		rsget.Close
	End Function

	Private Sub Class_Initialize()
		FCurrPage =1
		FPageSize = 10
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
end class

%>
	
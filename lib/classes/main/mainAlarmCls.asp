<%
'###############################################
' PageName : mainAlarmCls.asp
' Discription : 사이트 메인 알람 공지 클래스
' History : 2013.04.09 허진원 : 생성
'###############################################

'===============================================
'// 클래스 아이템 선언
'===============================================
Class CMainbannerItem
	public Fiidx 
	public FutArr 
	public FutnArr
	public Fstartday 
	public Fendday 
	public Ftitle
	public Ftext 
	public Ftexturl 
	Public Fwritedate
	Public Flastupdate
	Public Ftextcopy

    Private Sub Class_Initialize()
	End Sub

	Private Sub Class_Terminate()
	End Sub
end Class



'===============================================
'// 알람 클래스
'===============================================
Class CMainbanner
    public FOneItem
    public FItemList()
	public FResultCount
       
    public FRectUserlevel
	    
    public Sub GetContentsList()
        dim sqlStr, addSql, i

		addSql = " Where isUsing='1' "
		addSql = addSql + " and getdate() between startdate and enddate "

        if FRectUserlevel <>"" then
            sqlStr = sqlStr + " and usertype like '%" + CStr(FRectUserlevel) + "%'"
        end If

        sqlStr = "select * "
        sqlStr = sqlStr + " from db_sitemaster.dbo.tbl_mobile_noticebanner "
        sqlStr = sqlStr + addSql
		sqlStr = sqlStr + " order by sorting desc, idx desc "
        
		rsget.Open sqlStr, dbget, 1

		FResultCount = rsget.RecordCount

		redim preserve FItemList(FResultCount)
		if  not rsget.EOF  then
		    i = 0
			do until rsget.eof
				set FItemList(i) = new CMainbannerItem

				FItemList(i).Fiidx		= rsget("idx")
				FItemList(i).FutArr		= rsget("usertype")
				FItemList(i).FutnArr	= rsget("usertypename")
				FItemList(i).Fstartday	= rsget("startdate")
				FItemList(i).Fendday	= rsget("enddate")
				FItemList(i).Ftitle		= rsget("title")
				FItemList(i).Ftext		= rsget("textcontents")
				FItemList(i).Ftexturl	= rsget("texturl")
				FItemList(i).Fwritedate	= rsget("writedate")
				FItemList(i).Ftextcopy	= rsget("textcopy")

				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.close
    end Sub
    

    Private Sub Class_Initialize()
		redim  FItemList(0)
	End Sub

	Private Sub Class_Terminate()
    End Sub

end Class 
%>
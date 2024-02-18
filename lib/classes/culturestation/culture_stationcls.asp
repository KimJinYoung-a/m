<%
'#######################################################
'	History	:  2010.04.07 한용민 생성
'	History	:  2016.04.18 유태욱 : isusing 추가
'	Description : culturestation
'#######################################################
%>
<%
Class Cboard_item
	public Fid
	public Ftitle
	public Fcontents
	public Fregdate
	public Fyuhyostart
	public Fyuhyoend
	public Fisusing
	public FCateName
	public FFixYn
	public Fnoticetype
	public fidx
    
    public function IsNewNotics()
        IsNewNotics = (datediff("d",Fregdate,Now()) < 3)
    end function
    
	Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub
end Class

Class Cboard_list
    public FItemList()
    public FOneItem

	public FCurrPage
	public FTotalPage
	public FTotalCount
	public FPageSize
	public FResultCount
	public FScrollCount

	public FIDBefore
	public FIDAfter
	public FRectFixonly
    
    public FRectid
	public FRectmalltype
	public FRectNoticetype
	public FRectNoticeOrder
	public frectd_day
	public frecttoplimit
	
    public Function HasPreScroll()
		HasPreScroll = StartScrollPage > 1
	end Function

	public Function HasNextScroll()
		HasNextScroll = FTotalPage > StartScrollPage + FScrollCount -1
	end Function

	public Function StartScrollPage()
		StartScrollPage = ((FCurrpage-1)\FScrollCount)*FScrollCount +1
	end Function

	Private Sub Class_Initialize()
		redim preserve FItemList(0)
		FResultCount  = 0
		FTotalCount = 0
		FPageSize = 12
		FCurrpage = 1
		FScrollCount = 10
	End Sub

	Private Sub Class_Terminate()

    End Sub

	'/culturestation/culturestation_dday_event.asp '/culturestation/culturestation.asp
	public sub fnotice()
		dim sqlStr,i
		
		sqlStr = "select " + vbcrlf
		if frecttoplimit <> "" then
		sqlStr = sqlStr & " top "&frecttoplimit&" " + vbcrlf		
		end if
		sqlStr = sqlStr & " title , id" + vbcrlf
		sqlStr = sqlStr & " from db_cs.dbo.tbl_notice" + vbcrlf
		sqlStr = sqlStr & " where noticetype = 06" + vbcrlf
		sqlStr = sqlStr & " and isusing = 'Y'" + vbcrlf

			if frectd_day <> "" then
				sqlStr = sqlStr & " and '"& frectd_day &"' between yuhyostart and yuhyoend" + vbcrlf	
			end if
	
		sqlStr = sqlStr & " order by regdate desc" + vbcrlf

		'response.write sqlStr
		rsget.open sqlStr,dbget,1
 
		FTotalCount = rsget.recordcount
	
			redim FItemList(FTotalCount)
			i = 0
		
		if not rsget.eof then						
			do until rsget.eof						
				set FItemList(i) = new Cboard_item

				FItemList(i).ftitle = db2html(rsget("title"))				
				FItemList(i).fidx = rsget("id")											
				i=i+1
				rsget.moveNext
			loop
		end if

		rsget.Close
	end sub

	'//culturestation/news_popup.asp
	Public Function getOneNotics()
        dim strSQL, i

		strSQL = "exec [db_culture_station].[dbo].sp_Ten_NoticsOne " & CStr(FRectid)
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open strSQL, dbget, 1

        FResultCount = rsget.RecordCount

        if not rsget.EOF then
            set FOneItem = new Cboard_item

            FOneItem.Fid         = rsget("id")
            FOneItem.Ftitle      = db2html(rsget("title"))
            FOneItem.Fcontents   = db2html(rsget("contents"))
            FOneItem.Fregdate    = rsget("regdate")
            FOneItem.Fyuhyostart = rsget("yuhyostart")
            FOneItem.Fyuhyoend   = rsget("yuhyoend")
            FOneItem.FCateName	   = rsget("code_nm")
        end if
        rsget.close
	end Function
	
	'//culturestation/news_popup.asp
	Public Function getNoticsList_culture()	
        dim strSQL, i
        
        'FRectFixonly="Y" - 고정글 만'
        'FRectFixonly="N" - 고정 아닌글만''
        'FRectFixonly="" - 고정 여부 상관없이''
        'FRectNoticeOrder=7 - 고정글->일반글 순서
        
		strSQL = "EXECUTE [db_culture_station].[dbo].sp_Ten_NoticsCount "&_
        	" @onlyValid = " & CStr(1) & ","&_
			" @fixyn='" & FRectFixonly & "',"&_
			" @noticetype='"&FRectNoticetype&"'" &_
			" , @mallType='"&FRectMallType&"'"
			
		rsget.Open strSQL, dbget
            FTotalCount = rsget("cnt")
        rsget.Close
        
        strSQL =" EXECUTE [db_culture_station].[dbo].sp_Ten_NoticsList "&_
        	" @iTopCnt = "& CStr(FPageSize*FCurrPage) &_
			" ,@onlyValid = " & CStr(1) &_
			" ,@fixyn='" & FRectFixonly &"'"&_
			" ,@noticetype='"&FRectNoticetype&"'"&_
			" ,@orderType = '"&FRectNoticeOrder&"'"  &_
			" , @mallType='"&FRectMallType&"'"
			
		'response.write strSQL
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.pagesize = FPageSize
		rsget.Open strSQL, dbget, 1
        
	    FtotalPage = CInt(FTotalCount\FPageSize)
		if  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) then
			FtotalPage = FtotalPage +1
		end if
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
        
        if (FResultCount<1) then FResultCount=0
        
		redim preserve FItemList(FResultCount)

        if not rsget.EOF then
            i = 0
            rsget.absolutepage = FCurrPage
            do until (rsget.eof)
                set FItemList(i) = new Cboard_item
    
                FItemList(i).Fid           	= rsget("id")
                FItemList(i).Ftitle        	= db2html(rsget("title"))
                FItemList(i).Fregdate      	= rsget("regdate")
                FItemList(i).Fyuhyostart   	= rsget("yuhyostart")
                FItemList(i).Fyuhyoend     	= rsget("yuhyoend")
    			FItemList(i).FCateName	   	= rsget("code_nm")
    			FItemList(i).FFixYn			= rsget("fixyn")
    			FItemList(i).Fnoticetype	= rsget("noticetype")
    			
        		rsget.MoveNext
        		i = i + 1
            loop
        end if
        rsget.close
	end Function

end Class

Class ceditor_oneitem
	Private Sub Class_Initialize()
	End Sub
	Private Sub Class_Terminate()
	End Sub
	
	public fidx
	public fuserid
	public fcomment
	public feditor_no
	public fregdate
	public feditor_name
	public fisusing
	public fimage_main
	public fimage_main2
	public fimage_main3
	public fimage_main4
	public fimage_main5	
	public fimage_main_link
	public fimage_barner
	public fimage_barner2
	public fimage_list
	public fimage_list2
	public fimage_list2015
	public fcomment_isusing
	public feditor_no_count
end class

class ceditor_list
	public FItemList()
	public FTotalCount
	public FResultCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FScrollCount
	public FPageCount
	public foneitem
	
	public frecteditor_no_count
	public frecteditor_no
	public frectisusing
	public frecttoplimit
	public frectChkImg
	public frectUserid

	Private Sub Class_Initialize()
		FCurrPage =1
		FPageSize = 50
		FResultCount = 0
		FScrollCount = 10
		FTotalCount =0
	End Sub
	Private Sub Class_Terminate()
	End Sub

	'/chtml/culturestation_editorbestmake.asp '왼쪽매뉴 배스트에디터 스크립트생성
	public sub feditor_beststory_make()
		dim sqlStr , i

		sqlStr = "select top "&frecttoplimit&"" + vbcrlf
		sqlStr = sqlStr & " editor_no, image_barner2" + vbcrlf
		sqlStr = sqlStr & " from db_culture_station.dbo.tbl_culturestation_editor" + vbcrlf
		sqlStr = sqlStr & " where isusing = 'Y' " + vbcrlf
		sqlStr = sqlStr & " and image_barner2 <> '' and image_barner2 is not null " + vbcrlf
		
		if frecteditor_no <> "" then
			sqlStr = sqlStr & " and editor_no in ("& frecteditor_no &")"			
		end if
		
		sqlStr = sqlStr & " order by editor_no desc" + vbcrlf

		'response.write sqlStr &"<br>"
		rsget.pagesize = FPageSize
		rsget.Open sqlStr,dbget,1
		
		ftotalcount = rsget.recordcount
		redim preserve FItemList(ftotalcount)

		i=0
		if  not rsget.EOF  then
			do until rsget.EOF
				set FItemList(i) = new ceditor_oneitem
				
		            fitemlist(i).feditor_no = rsget("editor_no")		            
		            fitemlist(i).fimage_barner2 = rsget("image_barner2")
																									
				rsget.movenext
				i=i+1
			loop
		end if
		rsget.Close
	end sub

	''//에디터 코맨트 베스트스토리 //culturestation/inc_culturestation_editor_beststory.asp 
	public sub feditor_beststory()
		dim sqlStr,i

		sqlStr = "exec [db_culture_station].dbo.ten_culturestation_beststory "
		
		'Response.write sqlStr &"<br>"

        rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
        rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget
		
		ftotalcount = rsget.recordcount
		redim preserve FItemList(ftotalcount)

		i=0
		if  not rsget.EOF  then
			
			do until rsget.EOF
				set fitemlist(i) = new ceditor_oneitem
				
		            fitemlist(i).feditor_no = rsget("editor_no")
		            fitemlist(i).feditor_no_count = rsget("editor_no_count")          
		            fitemlist(i).fimage_barner = rsget("image_barner")  
		            
				rsget.movenext
				i=i+1
			loop
		end if
		rsget.Close
	end sub  

	''//에디터 로그기준 베스트스토리 //culturestation/inc_culturestation_editor_beststory.asp 
	public sub feditor_beststory_log()
		dim sqlStr,i

		sqlStr = "exec [db_culture_station].dbo.ten_culturestation_beststory_log "
		
		'Response.write sqlStr &"<br>"

        rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
        rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget
		
		ftotalcount = rsget.recordcount
		redim preserve FItemList(ftotalcount)

		i=0
		if  not rsget.EOF  then
			
			do until rsget.EOF
				set fitemlist(i) = new ceditor_oneitem
				
		            fitemlist(i).feditor_no = rsget("editor_no")
		            fitemlist(i).feditor_no_count = rsget("editor_no_count")          
		            fitemlist(i).fimage_barner = rsget("image_barner")  
		            
				rsget.movenext
				i=i+1
			loop
		end if
		rsget.Close
	end sub  

	''//에디터 리스트 //admin/culturestation/culturestation_editor.asp 
	public sub feditor()
		dim sqlStr,i

		sqlStr = "exec [db_culture_station].dbo.ten_culturestation_editor '"&frecteditor_no&"', '"&frectisusing&"' "
		
		'Response.write sqlStr &"<br>"

        rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
        rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget
		
		ftotalcount = rsget.recordcount
		redim preserve FItemList(ftotalcount)

		i=0
		if  not rsget.EOF  then
			
			do until rsget.EOF
				set fitemlist(i) = new ceditor_oneitem
				
				FItemList(i).feditor_no = rsget("editor_no")
				FItemList(i).fregdate = rsget("regdate")
				FItemList(i).feditor_name = db2html(rsget("editor_name"))
				FItemList(i).fisusing = rsget("isusing")
				FItemList(i).fimage_main = rsget("image_main")
				FItemList(i).fimage_main2 = rsget("image_main2")
				FItemList(i).fimage_main3 = rsget("image_main3")
				FItemList(i).fimage_main4 = rsget("image_main4")
				FItemList(i).fimage_main5 = rsget("image_main5")				
				FItemList(i).fimage_main_link = rsget("image_main_link")
				FItemList(i).fimage_barner2 = rsget("image_barner2")
				FItemList(i).fimage_list2 = rsget("image_list2")
				FItemList(i).fimage_list2015 = rsget("image_list2015")
				FItemList(i).fcomment_isusing = rsget("comment_isusing")
		            
				rsget.movenext
				i=i+1
			loop
		end if
		rsget.Close
	end sub  

	'// 에디터 고객이 작성한 코맨트 리스트  '///admin/culturestation2009/editor_comment_list.asp
	public sub feditor_comment_list()
		dim sqlStr, addSql, i

		addSql = ""
		if frecteditor_no <> "" then
			addSql = addSql & " and editor_no = "& frecteditor_no &"" + vbcrlf		
		end if
		if frectUserid<>"" then
			addSql = addSql & " and userid = '"& frectUserid &"'" + vbcrlf		
		end if

		'총 갯수 구하기
		sqlStr = " select count(idx) as cnt" + vbcrlf
		sqlStr = sqlStr & " from db_culture_station.dbo.tbl_culturestation_editor_comment " + vbcrlf
		sqlStr = sqlStr & " where isusing = 'Y'" & addSql + vbcrlf
			
		rsget.Open sqlStr,dbget,1
			FTotalCount = rsget("cnt")
		rsget.Close
				
		'데이터 리스트 	
		sqlStr = "select top " & Cstr(FPageSize * FCurrPage) + vbcrlf
		sqlStr = sqlStr & " idx , editor_no , userid , comment , regdate , isusing "  + vbcrlf
		sqlStr = sqlStr & " from db_culture_station.dbo.tbl_culturestation_editor_comment " + vbcrlf
		sqlStr = sqlStr & " where 1=1 and isusing = 'Y' " & addSql + vbcrlf
		sqlStr = sqlStr & " order by idx desc " + vbcrlf		
				
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
				set FItemList(i) = new ceditor_oneitem

				FItemList(i).fidx = rsget("idx")
				FItemList(i).feditor_no = rsget("editor_no")
				FItemList(i).fuserid = rsget("userid")
				FItemList(i).fcomment = db2html(rsget("comment"))
				FItemList(i).fregdate = rsget("regdate")
				FItemList(i).fisusing = rsget("isusing")
																	
				rsget.movenext
				i=i+1
			loop
		end if
		rsget.Close
	end sub

	'/컬쳐스테이션 에디터 리스트  //culturestation/inc_culturestation_editorlist.asp
	public sub feditor_list()
		dim sqlStr,i, addSql

		'총 갯수 구하기
		sqlStr = "select " + vbcrlf 
		sqlStr = sqlStr & " count(editor_no) as cnt " + vbcrlf 
		sqlStr = sqlStr & " from db_culture_station.dbo.tbl_culturestation_editor " + vbcrlf 
'		sqlStr = sqlStr & " where" + vbcrlf

		if frectisusing<>"" then
			sqlStr = sqlStr & " where isusing='Y' " + vbcrlf 
		else
			sqlStr = sqlStr & " where isusing='Y' or isusing='N'" + vbcrlf 
		end if

		if frectChkImg="Y" then
			sqlStr = sqlStr & " and image_list2<>'' and image_list2 is not null" + vbcrlf 
		end if
		
		if frecteditor_no <> "" then
		sqlStr = sqlStr & " and editor_no = "& frecteditor_no &"" + vbcrlf 				
		end if

		'response.write sqlStr
		rsget.Open sqlStr,dbget,1
			FTotalCount = rsget("cnt")
		rsget.Close
		
		'데이터 리스트 
		sqlStr = "select top " & Cstr(FPageSize * FCurrPage) + vbcrlf
		sqlStr = sqlStr & " editor_no, regdate, editor_name, isusing, image_main" + vbcrlf
		sqlStr = sqlStr & " , image_main2, image_main3, image_main_link, image_barner2" + vbcrlf
		sqlStr = sqlStr & " , image_list2, comment_isusing " + vbcrlf
		sqlStr = sqlStr & " , image_main4 , image_main5, image_list2015" + vbcrlf
		sqlStr = sqlStr & " from db_culture_station.dbo.tbl_culturestation_editor " + vbcrlf
'		sqlStr = sqlStr & " where 1+1" + vbcrlf

		if frectisusing<>"" then
			sqlStr = sqlStr & " where isusing='Y' " + vbcrlf 
		else
			sqlStr = sqlStr & " where isusing='Y' or isusing='N'" + vbcrlf 
		end if

		if frectChkImg="Y" then
			sqlStr = sqlStr & " and image_list2<>'' and image_list2 is not null" + vbcrlf 
		end if

		if frecteditor_no <> "" then
		sqlStr = sqlStr & " and editor_no = "& frecteditor_no &"" + vbcrlf 				
		end if 

		sqlStr = sqlStr & " order by editor_no Desc" + vbcrlf

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
				set FItemList(i) = new ceditor_oneitem

				FItemList(i).feditor_no = rsget("editor_no")
				FItemList(i).fregdate = rsget("regdate")
				FItemList(i).feditor_name = db2html(rsget("editor_name"))
				FItemList(i).fisusing = rsget("isusing")
				FItemList(i).fimage_main = rsget("image_main")
				FItemList(i).fimage_main2 = rsget("image_main2")
				FItemList(i).fimage_main3 = rsget("image_main3")
				FItemList(i).fimage_main4 = rsget("image_main4")
				FItemList(i).fimage_main5 = rsget("image_main5")				
				FItemList(i).fimage_main_link = rsget("image_main_link")
	            if Not(rsget("image_barner2")="" or isNull(rsget("image_barner2"))) then
	            	FItemList(i).fimage_barner2		= webImgUrl & "/culturestation/editor/2009/barner2/" & rsget("image_barner2")
	            end if
	            if Not(rsget("image_list2")="" or isNull(rsget("image_list2"))) then
	            	FItemList(i).fimage_list2		= webImgUrl & "/culturestation/editor/2009/list2/" & rsget("image_list2")
	            end If
	            if Not(rsget("image_list2015")="" or isNull(rsget("image_list2015"))) then
	            	FItemList(i).fimage_list2015		= webImgUrl & "/culturestation/editor/2009/list2015/" & rsget("image_list2015")
				Else
	            	FItemList(i).fimage_list2015		= ""
	            end if	            

				FItemList(i).fcomment_isusing = rsget("comment_isusing")

				rsget.movenext
				i=i+1
			loop
		end if
		rsget.Close
	end sub
	
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

Class cthanks10x10_oneitem
	Private Sub Class_Initialize()
	End Sub
	Private Sub Class_Terminate()
	End Sub

	public fidx
	public fuserid
	public ftitle
	public fimage
	public fimage_path
	public fcontents
	public fisusing
	public fevt_code
	public freg_date
	public fcomment
	public fisusing_del
	public fgubun
	public fisusing_display
	public fconfirm_regdate
	
end class

class cthanks10x10_list
	public FItemList()
	public FTotalCount
	public FResultCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FScrollCount
	public FPageCount
	public FsearchFlag
	
	public frectevent_limit
	Private Sub Class_Initialize()
		FCurrPage =1
		FPageSize = 50
		FResultCount = 0
		FScrollCount = 10
		FTotalCount =0
	End Sub
	Private Sub Class_Terminate()

	End Sub
	
	'// 컬쳐스테이션 고마워텐바이텐 페이지 리스트 /culturestation/culturestation_thanks10x10.asp
	public sub fthanks10x10_list()
		dim sqlStr, addSql, i
		if FsearchFlag="my" then
			addSql = " and a.userid='" & GetLoginUserID & "'"
		end if

		'총 갯수 구하기
		sqlStr = "select count(a.idx) as cnt" + vbcrlf
		sqlStr = sqlStr & " from db_culture_station.dbo.tbl_thanks_10x10 a" + vbcrlf
		sqlStr = sqlStr & " left join db_culture_station.dbo.tbl_thanks_10x10_comment b"
		sqlStr = sqlStr & " on a.idx = b.idx"	
		sqlStr = sqlStr & " where a.isusing_del = 'N' and a.isusing_display = 'Y'" + addSql + vbcrlf

		rsget.Open sqlStr,dbget,1
			FTotalCount = rsget("cnt")
		rsget.Close
		
		'데이터 리스트
		sqlStr = "select top " & Cstr(FPageSize * FCurrPage) + vbcrlf
		sqlStr = sqlStr & " a.isusing_del ,a.idx ,a.userid, a.contents, a.isusing_display, a.reg_date" + vbcrlf
		sqlStr = sqlStr & " , isnull(b.comment,'') as comment , a.gubun , b.confirm_regdate" + vbcrlf
		sqlStr = sqlStr & " from db_culture_station.dbo.tbl_thanks_10x10 a" + vbcrlf
		sqlStr = sqlStr & " left join db_culture_station.dbo.tbl_thanks_10x10_comment b"
		sqlStr = sqlStr & " on a.idx = b.idx"
		sqlStr = sqlStr & " where a.isusing_del = 'N' and a.isusing_display = 'Y'" + addSql + vbcrlf
		sqlStr = sqlStr & " order by a.idx Desc" + vbcrlf

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
				set FItemList(i) = new cthanks10x10_oneitem
	
				FItemList(i).fidx = rsget("idx")
				FItemList(i).fuserid = rsget("userid")
				FItemList(i).fcontents = db2html(rsget("contents"))
				FItemList(i).fisusing_display = rsget("isusing_display")
				FItemList(i).fisusing_del = rsget("isusing_del")
				FItemList(i).freg_date = rsget("reg_date")
				FItemList(i).fcomment = db2html(rsget("comment"))
				FItemList(i).fgubun = rsget("gubun")				
				FItemList(i).fconfirm_regdate = rsget("confirm_regdate")													
				rsget.movenext
				i=i+1
			loop
		end if
		rsget.Close
	end sub

	''''////메인페이지 고마워텐바이텐 배너2개	/culturestation/culturestation.asp
	public sub fthanks10x10_banner()		
		dim sqlStr,i		

		sqlStr = "select"
			if frectevent_limit <> "" then
			sqlStr = sqlStr & " top "& frectevent_limit &"" + vbcrlf			
			end if			
		sqlStr = sqlStr & " idx, userid, contents, reg_date , gubun" + vbcrlf
		sqlStr = sqlStr & " from db_culture_station.dbo.tbl_thanks_10x10" + vbcrlf
		sqlStr = sqlStr & " where isusing_display='Y' and isusing_del = 'N'" + vbcrlf
		sqlStr = sqlStr & " order by idx Desc" + vbcrlf

		'response.write sqlStr &"<br>"
		rsget.pagesize = FPageSize
		rsget.Open sqlStr,dbget,1

		ftotalcount = rsget.recordcount
		redim preserve FItemList(ftotalcount)

		FPageCount = FCurrPage - 1

		i=0
		if  not rsget.EOF  then
			do until rsget.EOF
				set FItemList(i) = new cthanks10x10_oneitem
	
				FItemList(i).fidx = rsget("idx")
				FItemList(i).fuserid = rsget("userid")
				FItemList(i).fcontents = db2html(rsget("contents"))
				FItemList(i).freg_date = rsget("reg_date")
				FItemList(i).fgubun = rsget("gubun")				
												
				rsget.movenext
				i=i+1
			loop
		end if
		rsget.Close
	end sub
		

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

Class cevent_oneitem
	Private Sub Class_Initialize()
	End Sub
	Private Sub Class_Terminate()
	End Sub
	
	public	fevt_code
	public	fevt_name
	public	fevt_comment
	public	fregdate
	public	fstartdate
	public	fenddate
	public	fisusing
	public	fevt_type
	public	fimage_main
	public	fimage_main2
	public	fimage_main_link
	public	fimage_barner
	public	fimage_barner2
	public	fimage_barner3
	public	fimage_list
	public	fcomment
	public	fidx
	public	fuserid	
	public	ftitle
	public	feventdate
	public	fimage_main3
	public 	fimage_main4	
	public 	fimage_main5	
	public	fdcount
	public	feventcount
	public	fwrite_work 
	public	fdevice
	public	fevt_kind
    public fevt_html
    public fevt_html_mo
	public fcomm_isusing
	public ffreebie_img
	public fcomm_start
	public fcomm_end
	public fcomm_text
	public fthemecolor
	public fiscomment
	public fevt_prizedate
	public fevt_state

	Public Function GetEvtKindName
		If fevt_kind="0" Then
			GetEvtKindName="영화"
		ElseIf fevt_kind="1" Then
			GetEvtKindName="연극"
		ElseIf fevt_kind="2" Then
			GetEvtKindName="공연"
		ElseIf fevt_kind="3" Then
			GetEvtKindName="뮤지컬"
		ElseIf fevt_kind="4" Then
			GetEvtKindName="도서"
		ElseIf fevt_kind="5" Then
			GetEvtKindName="전시"
		ElseIf fevt_kind="6" Then
			GetEvtKindName="공모"
		End If
	End Function

	public Function fnEventThemeColorCode
		If fthemecolor="1" Then
			fnEventThemeColorCode = "#ed6c6c"
		ElseIf fthemecolor="2" Then
			fnEventThemeColorCode = "#f385af"
		ElseIf fthemecolor="3" Then
			fnEventThemeColorCode = "#f3a056"
		ElseIf fthemecolor="4" Then
			fnEventThemeColorCode = "#e7b93c"
		ElseIf fthemecolor="5" Then
			fnEventThemeColorCode = "#8eba4a"
		ElseIf fthemecolor="6" Then
			fnEventThemeColorCode = "#43a251"
		ElseIf fthemecolor="7" Then
			fnEventThemeColorCode = "#50bdd1"
		ElseIf fthemecolor="8" Then
			fnEventThemeColorCode = "#5aa5ea"
		ElseIf fthemecolor="9" Then
			fnEventThemeColorCode = "#2672bf"
		ElseIf fthemecolor="10" Then
			fnEventThemeColorCode = "#2c5a85"
		ElseIf fthemecolor="11" Then
			fnEventThemeColorCode = "#848484"
		ElseIf fthemecolor="12" Then
			fnEventThemeColorCode = "#ff427c"
		ElseIf fthemecolor="13" Then
			fnEventThemeColorCode = "#4d96fd"
		ElseIf fthemecolor="14" Then
			fnEventThemeColorCode = "#ff2977"
		ElseIf fthemecolor="15" Then
			fnEventThemeColorCode = "#018fec"
		ElseIf fthemecolor="16" Then
			fnEventThemeColorCode = "#004ae1"
		ElseIf fthemecolor="17" Then
			fnEventThemeColorCode = "#ff664e"
		ElseIf fthemecolor="18" Then
			fnEventThemeColorCode = "#4ecbc0"
		ElseIf fthemecolor="19" Then
			fnEventThemeColorCode = "#58d82a"
		ElseIf fthemecolor="20" Then
			fnEventThemeColorCode = "#a5447d"
		ElseIf fthemecolor="21" Then
			fnEventThemeColorCode = "#e784a2"
		ElseIf fthemecolor="22" Then
			fnEventThemeColorCode = "#4b6182"
		ElseIf fthemecolor="23" Then
			fnEventThemeColorCode = "#d88664"
		ElseIf fthemecolor="24" Then
			fnEventThemeColorCode = "#d84950"
		ElseIf fthemecolor="25" Then
			fnEventThemeColorCode = "#1e4c54"
		ElseIf fthemecolor="26" Then
			fnEventThemeColorCode = "#ff7e45"
		ElseIf fthemecolor="27" Then
			fnEventThemeColorCode = "#a2b72e"
		Else
			fnEventThemeColorCode = "#656565"
		End If
	End Function

end class

class cevent_list
	public FItemList()
	public FTotalCount
	public FResultCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FScrollCount
	public FPageCount
	public FOneItem
	
	public frectevt_code
	public frectevt_type	
	public frectisusing
	public frectevent_limit
	public frecttoplimit
	public frectidx
	public frectdate
	public frectd_day
	public frectSrotMtd
	public frectUserid
	public FRectXmlEvtCode
    public FMenuIDX

	Private Sub Class_Initialize()
		FCurrPage =1
		FPageSize = 50
		FResultCount = 0
		FScrollCount = 10
		FTotalCount =0
	End Sub
	Private Sub Class_Terminate()
	End Sub

	'//culturestation/index.asp	'이벤트 목록 접수
	public sub fevent_list()
		dim sqlStr, addSql, i
		
		addSql = "Where e.evt_kind=5"
		If frectUserid <> "" Then
		addSql = addSql & " and e.evt_code in (select evt_code from [db_event].[dbo].[tbl_event_comment] where userid='" + Cstr(frectUserid) + "' group by evt_code)"
		End If
		if frectevt_type<>"" then
		addSql = addSql & " and d.eventtype_pc=" & frectevt_type
		end if
		addSql = addSql & " and e.evt_using='Y' and (d.evt_mainimg<>'' or d.evt_mainimg is not null)"
		addSql = addSql & " and e.evt_startdate<=getdate() and e.evt_enddate >= getdate()"
		addSql = addSql & " and d.eventtype_mo>=0"
		addSql = addSql & " and e.evt_state = 7" & vbcrlf

        '전체 카운트
        sqlStr = "select count(e.evt_code), CEILING(CAST(Count(e.evt_code) AS FLOAT)/" & FPageSize & ")" + vbcrlf
        sqlStr = sqlStr & " From db_event.dbo.tbl_event as e"
        sqlStr = sqlStr & " LEFT JOIN [db_event].[dbo].[tbl_event_display] as d on e.evt_code=d.evt_code" + vbcrlf
        sqlStr = sqlStr & addSql
        rsget.Open sqlStr, dbget, 1
			FTotalCount = rsget(0)
			FtotalPage = rsget(1)
		rsget.close

		'지정페이지가 전체 페이지보다 클 때 함수종료
		if Cint(FCurrPage)>Cint(FTotalPage) then
			FResultCount = 0
			exit sub
		end if

		'목록 접수
        sqlStr = "Select top " + CStr(FPageSize * FCurrPage)
        sqlStr = sqlStr & " e.evt_code, e.evt_name, e.evt_subcopyK, e.evt_regdate, e.evt_startdate, e.evt_enddate"
        sqlStr = sqlStr & ", d.eventtype_pc as evt_type, d.evt_mainimg, d.eventtype_mo as evt_kind"
		sqlStr = sqlStr & ", (select count(evtcom_idx) from db_event.dbo.tbl_event_comment as c "
		sqlStr = sqlStr & "	where evtcom_using='Y' and c.evt_code = e.evt_code) as comCnt "
        sqlStr = sqlStr & " From db_event.dbo.tbl_event as e" + vbcrlf
        sqlStr = sqlStr & " LEFT JOIN [db_event].[dbo].[tbl_event_display] as d on e.evt_code=d.evt_code" + vbcrlf
        sqlStr = sqlStr & addSql
        If frectSrotMtd="fav" then
        	sqlStr = sqlStr & " order by comCnt desc, e.evt_code desc"
		ElseIf frectSrotMtd="dl" then
        	sqlStr = sqlStr & " order by e.evt_enddate asc"
        else
        	sqlStr = sqlStr & " order by e.evt_code desc"
        end if
		'response.write sqlStr
        rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget, 1
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
		redim preserve FItemList(FResultCount)

		if Not(rsget.EOF or rsget.BOF) then
			i = 0
			rsget.absolutepage = FCurrPage
			Do until rsget.eof
				set FItemList(i) = new cevent_oneitem

	            FItemList(i).fevt_code			= rsget("evt_code")
	            FItemList(i).fevt_name			= rsget("evt_name")
	            FItemList(i).fevt_comment		= rsget("evt_subcopyK")
	            FItemList(i).fregdate			= rsget("evt_regdate")
	            FItemList(i).fstartdate			= rsget("evt_startdate")
	            FItemList(i).fenddate			= rsget("evt_enddate")
	            FItemList(i).fevt_type			= rsget("evt_type")
            	FItemList(i).fimage_barner2		= rsget("evt_mainimg")
	            FItemList(i).fdcount			= rsget("comCnt")
				FItemList(i).fevt_kind			= rsget("evt_kind")

				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.close

	end Sub

	public sub fevent_top5_list()
		dim sqlStr, addSql, i
		
		addSql = "Where e.evt_kind=5" + vbcrlf
		addSql = addSql & " and e.evt_using='Y' and (d.evt_mainimg<>'' or d.evt_mainimg is not null)" + vbcrlf
		addSql = addSql & " and e.evt_startdate<=getdate() and e.evt_enddate >= getdate()" + vbcrlf
		addSql = addSql & " and d.eventtype_mo>=0" + vbcrlf
		addSql = addSql & " and e.evt_state = 7" + vbcrlf

		'목록 접수
        sqlStr = "Select top 5 e.evt_code, e.evt_name, e.evt_subcopyK, e.evt_regdate, e.evt_startdate, e.evt_enddate" + vbcrlf
        sqlStr = sqlStr & ", d.eventtype_pc as evt_type, d.evt_mainimg, d.eventtype_mo as evt_kind" + vbcrlf
		sqlStr = sqlStr & ", (select count(evtcom_idx) from db_event.dbo.tbl_event_comment as c " + vbcrlf
		sqlStr = sqlStr & "	where evtcom_using='Y' and c.evt_code = e.evt_code) as comCnt" + vbcrlf
        sqlStr = sqlStr & " From db_event.dbo.tbl_event as e" + vbcrlf
        sqlStr = sqlStr & " LEFT JOIN [db_event].[dbo].[tbl_event_display] as d on e.evt_code=d.evt_code" + vbcrlf
        sqlStr = sqlStr & addSql
       	sqlStr = sqlStr & " order by evt_code desc"

		rsget.Open sqlStr, dbget, 1
		FResultCount = rsget.RecordCount
		redim preserve FItemList(FResultCount)

		if Not(rsget.EOF or rsget.BOF) then
			i = 0
			Do until rsget.eof
				set FItemList(i) = new cevent_oneitem
	            FItemList(i).fevt_code			= rsget("evt_code")
	            FItemList(i).fevt_name			= rsget("evt_name")
	            FItemList(i).fevt_comment		= rsget("evt_subcopyK")
	            FItemList(i).fregdate			= rsget("evt_regdate")
	            FItemList(i).fstartdate			= rsget("evt_startdate")
	            FItemList(i).fenddate			= rsget("evt_enddate")
	            FItemList(i).fevt_type			= rsget("evt_type")
            	FItemList(i).fimage_barner2		= rsget("evt_mainimg")
	            FItemList(i).fdcount			= rsget("comCnt")
				FItemList(i).fevt_kind			= rsget("evt_kind")
				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.close
	end Sub

	public sub fevent_list_more()
		dim sqlStr, addSql, i

	    addSql = "Where e.evt_kind=5"
		If frectUserid <> "" Then
		addSql = addSql & " and e.evt_code in (select evt_code from [db_event].[dbo].[tbl_event_comment] where userid='" + Cstr(frectUserid) + "' group by evt_code)"
		End If
		addSql = addSql & " and (d.evt_mainimg<>'' or d.evt_mainimg is not null)"
		addSql = addSql & " and e.evt_startdate<=getdate() and e.evt_enddate >= getdate()"
		addSql = addSql & " and d.eventtype_mo>=0"
		addSql = addSql & " and e.evt_state = 7"
		if frectevt_type<>"" then
		addSql = addSql & " and d.eventtype_pc=" & frectevt_type
		end if
        '전체 카운트
        sqlStr = "select count(e.evt_code), CEILING(CAST(Count(e.evt_code) AS FLOAT)/" & FPageSize & ")" + vbcrlf
        sqlStr = sqlStr & " From db_event.dbo.tbl_event as e"
        sqlStr = sqlStr & " LEFT JOIN [db_event].[dbo].[tbl_event_display] as d on e.evt_code=d.evt_code" + vbcrlf
        sqlStr = sqlStr & addSql
        rsget.Open sqlStr, dbget, 1
			FTotalCount = rsget(0)
			FtotalPage = rsget(1)
		rsget.close

		'지정페이지가 전체 페이지보다 클 때 함수종료
		if Cint(FCurrPage)>Cint(FTotalPage) then
			FResultCount = 0
			exit sub
		end if

		'목록 접수
        sqlStr = "Select top " + CStr(FPageSize * FCurrPage)
        sqlStr = sqlStr & " e.evt_code, e.evt_name, e.evt_subcopyK, e.evt_regdate, e.evt_startdate, e.evt_enddate"
        sqlStr = sqlStr & ", d.eventtype_pc as evt_type, d.evt_mainimg, d.eventtype_mo as evt_kind"
		sqlStr = sqlStr & ", (select count(evtcom_idx) from db_event.dbo.tbl_event_comment as c "
		sqlStr = sqlStr & "	where evtcom_using='Y' and c.evt_code = e.evt_code) as comCnt "
        sqlStr = sqlStr & " From db_event.dbo.tbl_event as e" + vbcrlf
        sqlStr = sqlStr & " LEFT JOIN [db_event].[dbo].[tbl_event_display] as d on e.evt_code=d.evt_code" + vbcrlf
        sqlStr = sqlStr & addSql
        If frectSrotMtd="fav" then
        	sqlStr = sqlStr & " order by comCnt desc, e.evt_code desc"
		ElseIf frectSrotMtd="dl" then
        	sqlStr = sqlStr & " order by e.evt_enddate asc"
        else
        	sqlStr = sqlStr & " order by e.evt_code desc"
        end if
        rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget, 1
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
		redim preserve FItemList(FResultCount)

		if Not(rsget.EOF or rsget.BOF) then
			i = 0
			rsget.absolutepage = FCurrPage
			Do until rsget.eof
				set FItemList(i) = new cevent_oneitem

	            FItemList(i).fevt_code			= rsget("evt_code")
	            FItemList(i).fevt_name			= rsget("evt_name")
	            FItemList(i).fevt_comment		= rsget("evt_subcopyK")
	            FItemList(i).fregdate			= rsget("evt_regdate")
	            FItemList(i).fstartdate			= rsget("evt_startdate")
	            FItemList(i).fenddate			= rsget("evt_enddate")
	            FItemList(i).fevt_type			= rsget("evt_type")
            	FItemList(i).fimage_barner2		= rsget("evt_mainimg")
	            FItemList(i).fdcount			= rsget("comCnt")
				FItemList(i).fevt_kind			= rsget("evt_kind")

				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.close

	end Sub

	'//culturestation/culturestation_event.asp
    public Sub fevent_view()
        dim sqlStr
		sqlStr = "select" + vbcrlf
		
		if frectevent_limit <> "" then
		sqlStr = sqlStr & " top "& frectevent_limit &"" + vbcrlf			
		end if	
		
		sqlStr = sqlStr & " d.iscomment, e.evt_code, e.evt_name, e.evt_regdate, e.evt_startdate, e.evt_enddate, e.evt_using" + vbcrlf
		sqlStr = sqlStr & " , d.eventtype_pc as evt_type, d.eventtype_mo as evt_kind, d.evt_mainimg, datediff(d,e.evt_enddate,getdate()) as dcount, d.themecolor" + vbcrlf
        sqlStr = sqlStr & " , d.evt_html, d.evt_html_mo, t.comm_isusing, t.comm_text, t.freebie_img, t.comm_start, t.comm_end, e.evt_prizedate, e.evt_state" + vbcrlf
		sqlStr = sqlStr & " From db_event.dbo.tbl_event as e" + vbcrlf
        sqlStr = sqlStr & " LEFT JOIN [db_event].[dbo].[tbl_event_display] as d on e.evt_code=d.evt_code" + vbcrlf
        sqlStr = sqlStr & " LEFT JOIN [db_event].[dbo].[tbl_event_md_theme] as t on e.evt_code=t.evt_code" + vbcrlf
		
		If GetLoginUserLevel = "7" Then
			sqlStr = sqlStr & " where 1=1" + vbcrlf
		Else
			sqlStr = sqlStr & " where e.evt_using='Y'" + vbcrlf
		End IF

			if frectevt_code <> "" then
				sqlStr = sqlStr & " and e.evt_code in ("& frectevt_code &")" + vbcrlf		
			end if	
				
			if frectevt_type <> "" then
				sqlStr = sqlStr & " and d.eventtype_pc = "& frectevt_type &"" + vbcrlf		
			end if				
	
		sqlStr = sqlStr & " order by e.evt_code desc " + vbcrlf

        'response.write sqlStr&"<br>"
        rsget.Open SqlStr, dbget, 1
        ftotalcount = rsget.RecordCount

        set FOneItem = new cevent_oneitem

        if Not rsget.Eof then
		
            FOneItem.fevt_code = rsget("evt_code")
            FOneItem.fevt_name = db2html(rsget("evt_name"))
            FOneItem.fregdate = rsget("evt_regdate")
            FOneItem.fstartdate = rsget("evt_startdate")
            FOneItem.fenddate = rsget("evt_enddate")
            FOneItem.fisusing = rsget("evt_using")
            FOneItem.fevt_type = rsget("evt_type")
			FOneItem.fevt_kind = rsget("evt_kind")
            FOneItem.Fimage_barner2 = rsget("evt_mainimg")
            FOneItem.fdcount = rsget("dcount")
            FOneItem.fevt_html = db2html(rsget("evt_html"))
            FOneItem.fevt_html_mo = db2html(rsget("evt_html_mo"))
            FOneItem.fcomm_isusing = rsget("comm_isusing")
            FOneItem.ffreebie_img = rsget("freebie_img")
            FOneItem.fcomm_start = rsget("comm_start")
            FOneItem.fcomm_end = rsget("comm_end")
            FOneItem.fcomm_text = nl2br(db2html(rsget("comm_text")))
            FOneItem.fthemecolor = rsget("themecolor")
            FOneItem.fiscomment = rsget("iscomment")
			FOneItem.fevt_prizedate = rsget("evt_prizedate")
			FOneItem.fevt_state = rsget("evt_state")

        end if
        rsget.Close
    end Sub

	'//chtml/culturestation_categorymake.asp left 이미지 생성 사용
	public sub fevent_make()
		dim sqlStr,i
		
		sqlStr = "select" + vbcrlf
		
		if frectevent_limit <> "" then
		sqlStr = sqlStr & " top "& frectevent_limit &"" + vbcrlf			
		end if	
		
		sqlStr = sqlStr & " a.comment, a.evt_code, a.evt_name, a.regdate, a.startdate, a.enddate, a.isusing" + vbcrlf
		sqlStr = sqlStr & " ,a.evt_type, a.image_main, a.image_main2, a.image_main_link, a.image_barner, a.image_list" + vbcrlf
		sqlStr = sqlStr & " , a.image_main3, a.image_main4 ,a.image_main5 , datediff(d,a.enddate,getdate()) as dcount" + vbcrlf
		sqlStr = sqlStr & " ,(select count(evt_code) from db_culture_station.dbo.tbl_culturestation_event" + vbcrlf
		sqlStr = sqlStr & " 	where a.isusing='Y' and a.evt_type = evt_type" + vbcrlf

			if frectevt_code <> "" then
				sqlStr = sqlStr & " and evt_code in ("& frectevt_code &")" + vbcrlf		
			end if	
				
			if frectevt_type <> "" then
				sqlStr = sqlStr & " and evt_type = "& frectevt_type &"" + vbcrlf		
			end if
		
		sqlStr = sqlStr & "		) as eventcount" + vbcrlf
		sqlStr = sqlStr & " from db_culture_station.dbo.tbl_culturestation_event a" + vbcrlf
		sqlStr = sqlStr & " where a.isusing='Y'" + vbcrlf

			if frectevt_code <> "" then
				sqlStr = sqlStr & " and a.evt_code in ("& frectevt_code &")" + vbcrlf		
			end if	
				
			if frectevt_type <> "" then
				sqlStr = sqlStr & " and a.evt_type = "& frectevt_type &"" + vbcrlf		
			end if				
	
		sqlStr = sqlStr & " order by a.web_sortNo asc, a.evt_code desc " + vbcrlf

		'response.write sqlStr			'오류시 뿌려본다.
		rsget.open sqlStr,dbget,1
 
		FTotalCount = rsget.recordcount
	
			redim FItemList(FTotalCount)
			i = 0
		
		if not rsget.eof then						
			do until rsget.eof						
				set FItemList(i) = new cevent_oneitem

				FItemList(i).feventcount = rsget("eventcount")
				FItemList(i).fcomment = rsget("comment")				
				FItemList(i).fevt_code = rsget("evt_code")
				FItemList(i).fevt_name = db2html(rsget("evt_name"))
				FItemList(i).fregdate = rsget("regdate")
				FItemList(i).fstartdate = rsget("startdate")
				FItemList(i).fenddate = rsget("enddate")
				FItemList(i).fisusing = rsget("isusing")
				FItemList(i).fevt_type = rsget("evt_type")
				FItemList(i).fimage_main = rsget("image_main")
				FItemList(i).fimage_main2 = rsget("image_main2")
				FItemList(i).fimage_main3 = rsget("image_main3")				
				FItemList(i).fimage_main4 = rsget("image_main4")
				FItemList(i).fimage_main5 = rsget("image_main5")
				FItemList(i).fimage_main_link = rsget("image_main_link")
				FItemList(i).fimage_barner = rsget("image_barner")
				FItemList(i).fimage_list = rsget("image_list")		
				FItemList(i).fdcount = rsget("dcount")	
													
				i=i+1
				rsget.moveNext
			loop
		end if

		rsget.Close
	end sub

	'//컬쳐스테이션 이벤트 페이지 코맨트 /culturestation/culturestation_event_comment.asp
	public sub fevent_comment()
		dim sqlStr, addSql, i

		addSql = ""
		if frectevt_code<>"" then
			addSql = addSql & " and evt_code = "& frectevt_code &"" + vbcrlf		
		end if
		if frectUserid<>"" then
			addSql = addSql & " and userid = '"& frectUserid &"'" + vbcrlf		
		end if

		'총 갯수 구하기
		sqlStr = "select count(evt_code) as cnt" + vbcrlf
		sqlStr = sqlStr & " from db_culture_station.dbo.tbl_culturestation_event_comment" + vbcrlf
		sqlStr = sqlStr & " where isusing='Y' " & addSql + vbcrlf
					
		rsget.Open sqlStr,dbget,1
			FTotalCount = rsget("cnt")
		rsget.Close
		
		'데이터 리스트
		sqlStr = "select top " & Cstr(FPageSize * FCurrPage) + vbcrlf
		sqlStr = sqlStr & " idx,evt_code,userid,comment,regdate,device" + vbcrlf
		sqlStr = sqlStr & " from db_culture_station.dbo.tbl_culturestation_event_comment as C" + vbcrlf
		sqlStr = sqlStr & " where isusing='Y' " & addSql + vbcrlf
		sqlStr = sqlStr & " order by idx Desc" + vbcrlf

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
        if (FResultCount<1) then FResultCount=0
		redim preserve FItemList(FResultCount)

		FPageCount = FCurrPage - 1

		i=0
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.EOF
				set FItemList(i) = new cevent_oneitem
				
				FItemList(i).fidx = rsget("idx")
				FItemList(i).fevt_code = rsget("evt_code")
			 	FItemList(i).fuserid = rsget("userid")
				FItemList(i).fcomment = db2html(rsget("comment"))
				FItemList(i).fregdate = rsget("regdate")
				FItemList(i).fdevice = rsget("device")
									
				rsget.movenext
				i=i+1
			loop
		end if
		rsget.Close
	end sub

	'//컬쳐스테이션 최근이벤트 가져오기  '//culturestation/culturestatioin.asp
	public sub fevent_type()
		dim SqlStr 

		sqlStr = "exec [db_culture_station].dbo.ten_event_type '"&frectevt_type&"'"
		
		'Response.write sqlStr &"<br>"

        rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
        rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget

		'response.write SqlStr&"<br>"
		FTotalCount = rsget.recordcount
		
		if not rsget.EOF then
			set FOneItem = new cevent_oneitem	
			
            FOneItem.fevt_code = rsget("evt_code")      
            					
		end if
		rsget.close
	end sub

	Public Sub FXml12Bannerlist()
		Dim sqlStr, i
        sqlStr = ""
        sqlStr = sqlStr & " SELECT count(evt_code), CEILING(CAST(Count(evt_code) AS FLOAT)/" & FPageSize & ") "
        sqlStr = sqlStr & " FROM db_culture_station.dbo.tbl_culturestation_event "
        sqlStr = sqlStr & " WHERE isusing = 'Y' and evt_code in ("& FRectXmlEvtCode &")"
        rsget.Open sqlStr, dbget, 1
			FTotalCount = rsget(0)
			FTotalPage = rsget(1)
		rsget.close

		If Cint(FCurrPage) > Cint(FTotalPage) then
			FResultCount = 0
			Exit Sub
		End If

        sqlStr = ""
        sqlStr = sqlStr & " SELECT TOP " & CStr(FPageSize * FCurrPage)
        sqlStr = sqlStr & " evt_code, evt_name, evt_type, isusing, isNull(image_barner2, '') as image_barner2, evt_comment "
        sqlStr = sqlStr & " FROM db_culture_station.dbo.tbl_culturestation_event "
        sqlStr = sqlStr & " WHERE isusing = 'Y' and image_barner2 <> '' and evt_code in ("& FRectXmlEvtCode &") "
        sqlStr = sqlStr & " ORDER BY evt_code DESC "
        rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget, 1
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
		Redim preserve FItemList(FResultCount)
		If Not(rsget.EOF or rsget.BOF) Then
			i = 0
			rsget.absolutepage = FCurrPage
			Do until rsget.EOF
				Set FItemList(i) = new cevent_oneitem
		            FItemList(i).FEvt_code			= rsget("evt_code")
		            FItemList(i).FEvt_name			= rsget("evt_name")
		            FItemList(i).FEvt_type			= rsget("evt_type")
		            FItemList(i).FEvt_comment			= rsget("evt_comment")

					IF application("Svr_Info") = "Dev" THEN
	            		FItemList(i).Fimage_barner2		= webImgUrl & "/culturestation/2009/barner2/" & rsget("image_barner2")
	            	Else
	            		FItemList(i).Fimage_barner2		= "http://thumbnail.10x10.co.kr/webimage/culturestation/2009/barner2/" & rsget("image_barner2") & "?cmd=thumb&w=156&h=195&fit=true&ws=false"
	            	End If
				i = i + 1
				rsget.moveNext
			Loop
		End If
		rsget.close
	End Sub

	'멀티 컨텐츠 마스터 정보
	public Function fnGetEventMultiContentsMaster
		Dim strSql
		If frectevt_code = "" THEN Exit Function
		strSql ="[db_event].[dbo].[usp_WWW_Event_MultiContentsMaster_Get] ("&frectevt_code&")"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetEventMultiContentsMaster = rsget.getRows()
		END IF
		rsget.close
	End Function

	'멀티 컨텐츠 이미지 & 영상 정보
	public Function fnGetEventMultiContentsSwife
		Dim strSql
		If FMenuIDX = "" THEN Exit Function
		strSql ="[db_event].[dbo].[usp_WWW_Event_MultiContentsImageVideoSwife_Get] ("&FMenuIDX&",'W')"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetEventMultiContentsSwife = rsget.getRows()
		END IF
		rsget.close
	End Function

	'멀티 컨텐츠 이미지 & 영상 정보
	public Function fnGetEventMultiContentsVideo
		Dim strSql
		If FMenuIDX = "" THEN Exit Function
		strSql ="[db_event].[dbo].[usp_WWW_Event_MultiContentsVideo_Get] ("&FMenuIDX&")"
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
		IF Not (rsget.EOF OR rsget.BOF) THEN
			fnGetEventMultiContentsVideo = rsget.getRows()
		END IF
		rsget.close
	End Function

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

Class cposcode_oneitem
	Private Sub Class_Initialize()
	End Sub
	Private Sub Class_Terminate()
	End Sub
	
	public fidx
	public fposcode
	public fposname
	public fimagetype
	public fimagewidth
	public fimageheight
	public fisusing
	public fimagepath
	public flinkpath
	public fevt_code
	public fregdate
	public fimagecount
	public fitemid
	public fevt_type
	public FEvt_comment
	public fimagepath2
	public fimage_order

    public function GetImageUrl()
        if (IsNULL(fimagepath) or (fimagepath="")) then
            GetImageUrl = ""
        else
			IF application("Svr_Info") = "Dev" THEN
				GetImageUrl = "http://testimgstatic.10x10.co.kr/culturestation/main/" & fimagepath
			Else
				GetImageUrl = "http://imgstatic.10x10.co.kr/culturestation/main/" & fimagepath
			End If
        end if
    end function
	
end class

class cposcode_list
	public FItemList()
	public FTotalCount
	public FResultCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FScrollCount
	public FPageCount
	public FOneItem
	
	public FRectPoscode
	public FRectIsusing
	public FRectvaliddate
	public FRectIdx
	public frecttoplimit

	Private Sub Class_Initialize()
		FCurrPage =1
		FPageSize = 50
		FResultCount = 0
		FScrollCount = 10
		FTotalCount =0
	End Sub
	Private Sub Class_Terminate()

	End Sub

	'/chtml/culturestation_imagemake.asp  '이미지 스크립트 생성 어드민에서 타고들어옴
    public Sub fculturestation_makeimage()
        dim sqlStr
        sqlStr = "select" +vbcrlf
		sqlStr = sqlStr & " a.idx,a.imagepath,a.linkpath,a.evt_code,a.regdate,a.poscode,a.isusing,a.image_order" + vbcrlf
		sqlStr = sqlStr & " ,a.imagepath2,b.imagecount,b.posname,b.imagewidth,b.imageheight" + vbcrlf
		sqlStr = sqlStr & " from db_culture_station.dbo.tbl_culturestation_poscode_image a" + vbcrlf
		sqlStr = sqlStr & " left join db_culture_station.dbo.tbl_culturestation_poscode b" + vbcrlf
        sqlStr = sqlStr & " on a.poscode = b.poscode"   + vbcrlf
        sqlStr = sqlStr & " where a.idx in ( "& FRectIdx&" )" + vbcrlf
        sqlStr = sqlStr & " order by a.image_order asc"

        'response.write sqlStr&"<br>"
        rsget.Open SqlStr, dbget, 1
        ftotalcount = rsget.RecordCount

        set FOneItem = new cposcode_oneitem

        if Not rsget.Eof then
			
			FOneItem.fimagepath2 = db2html(rsget("imagepath2"))
			FOneItem.fidx = rsget("idx")
			FOneItem.fimagepath = db2html(rsget("imagepath"))
			FOneItem.flinkpath = db2html(rsget("linkpath"))			
			FOneItem.fevt_code = rsget("evt_code")
			FOneItem.fregdate = rsget("regdate")
			FOneItem.fimagecount = rsget("imagecount")
			FOneItem.fimage_order = rsget("image_order")
			FOneItem.fposcode = rsget("poscode")
			FOneItem.fposname = rsget("posname")
			FOneItem.fimagewidth = rsget("imagewidth")
			FOneItem.fimageheight = rsget("imageheight")			

        end if
        rsget.Close
    end Sub

end class

function editor_log(editor_no)
	dim sql
	
	if editor_no <> "" then
	sql = "update db_culture_station.dbo.tbl_culturestation_editor set " & vbcrlf
	sql = sql & " editor_count = editor_count + 1" & vbcrlf
	sql = sql & " where editor_no = "& editor_no &""
	
	'response.write sql &"<br>"
	dbget.execute sql
	end if
end function 
%>
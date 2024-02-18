<%
Class cevent_oneitem
	Private Sub Class_Initialize()
	End Sub
	Private Sub Class_Terminate()
	End Sub

	public	fevt_code
	public	fevt_name
	public	fregdate
	public	fstartdate
	public	fenddate
	public	fisusing
	public	fevt_type
	public	fimage_main
	public	fimage_main2
	public	fimage_main_link
	public	fimage_barner
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
	Public	fm_img_comm
	public	fm_isusing
	public	fm_img_icon
	public	fm_img_main1
	public	fm_img_main2
	public	fm_main_content
	public	fm_cmt_desc
	public	fm_sortNo
	public fm_evtbn_code

	public fimage_barner2
	public fimage_barner3
	Public fevt_comment
	Public fevt_kind

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
	public fuserid
	public fsort
	public FRectXmlEvtCode
	Private Sub Class_Initialize()
		FCurrPage =1
		FPageSize = 5
		FResultCount = 0
		FScrollCount = 10
		FTotalCount =0
	End Sub
	Private Sub Class_Terminate()
	End Sub

	'//culturestation/culturestation_event.asp
    public Sub fevent_view()
        dim sqlStr
		sqlStr = "select" + vbcrlf
		sqlStr = sqlStr & " top "& frectevent_limit &" * " + vbcrlf
		sqlStr = sqlStr & " from ( " + vbcrlf
		sqlStr = sqlStr & " 	select top 3 image_barner2, comment, evt_code, evt_name, regdate, startdate, enddate, eventdate, isusing ,evt_type, datediff(d,enddate,getdate()) as dcount, m_isusing, m_img_icon, m_img_main1, m_img_main2, m_main_content, m_cmt_desc, m_sortNo, m_evtbn_code, image_list" + vbcrlf
		sqlStr = sqlStr & " 	from db_culture_station.dbo.tbl_culturestation_event " + vbcrlf
		sqlStr = sqlStr & " where isusing='Y' and m_isusing = 'Y' and getdate() < enddate " + vbcrlf

		if frectevt_code <> "" then
			sqlStr = sqlStr & " and evt_code in ("& frectevt_code &")" + vbcrlf
		end if

		if frectevt_type <> "" then
			sqlStr = sqlStr & " and evt_type = "& frectevt_type &"" + vbcrlf
		end if

		sqlStr = sqlStr & " ) as T " + vbcrlf
		sqlStr = sqlStr & " order by newid() " + vbcrlf

		'response.write sqlStr&"<br>"
        rsget.Open SqlStr, dbget, 1
        ftotalcount = rsget.RecordCount

        set FOneItem = new cevent_oneitem

        if Not rsget.Eof then

				FOneItem.fcomment = rsget("comment")
				FOneItem.fevt_code = rsget("evt_code")
				FOneItem.fevt_name = db2html(rsget("evt_name"))
				FOneItem.fregdate = rsget("regdate")
				FOneItem.fstartdate = rsget("startdate")
				FOneItem.fenddate = rsget("enddate")
				FOneItem.feventdate = rsget("eventdate")
				FOneItem.fisusing = rsget("isusing")
				FOneItem.fevt_type = rsget("evt_type")
				FOneItem.fdcount = rsget("dcount")

				FOneItem.fm_isusing = rsget("m_isusing")
				FOneItem.fm_img_icon = rsget("m_img_icon")
				FOneItem.fm_img_comm = rsget("m_img_main1")
				FOneItem.fm_img_main2 = rsget("m_img_main2")
				FOneItem.fm_main_content = rsget("m_main_content")
				FOneItem.fm_cmt_desc = rsget("m_cmt_desc")
				FOneItem.fm_sortNo = rsget("m_sortNo")
				FOneItem.fm_evtbn_code = rsget("m_evtbn_code")

				IF application("Svr_Info") = "Dev" THEN
            		FOneItem.Fimage_barner2		= webImgUrl & "/culturestation/2009/barner2/" & rsget("image_barner2")
            		FOneItem.fm_img_main1		= webImgUrl & "/culturestation/2009/mMain1/" & rsget("m_img_main1")
            		if FOneItem.fm_img_main2 <> "" then
            			FOneItem.fm_img_main2		= webImgUrl & "/culturestation/2009/mMain2/" & rsget("m_img_main2")
            		end if
            	Else
            		FOneItem.Fimage_barner2		= webImgUrl & "/culturestation/2009/barner2/" & rsget("image_barner2")
            		FOneItem.fm_img_main1		= webImgUrl & "/culturestation/2009/mMain1/" & rsget("m_img_main1")
					If rsget("image_barner2")="" Then
						FOneItem.Fimage_barner2=webImgUrl & "/culturestation/2009/list200/" & rsget("image_list")
					End If
            		if FOneItem.fm_img_main2 <> "" then
            			FOneItem.fm_img_main2		= webImgUrl & "/culturestation/2009/mMain2/" & rsget("m_img_main2")
            		end if
          '  		FOneItem.Fimage_barner2		= "http://thumbnail.10x10.co.kr/webimage/culturestation/2009/barner2/" & rsget("image_barner2") & "?cmd=thumb&w=156&h=195&fit=true&ws=false"
          '  		FOneItem.fm_img_main1		= "http://thumbnail.10x10.co.kr/webimage/culturestation/2009/mMain1/" & rsget("m_img_main1") & "?cmd=thumb&w=156&h=195&fit=true&ws=false"
            	End If
        end if
        rsget.Close
    end Sub

	'//컬쳐스테이션 이벤트 페이지 코맨트 /culturestation/culturestation_event_comment.asp
	public sub fevent_comment()
		dim sqlStr,i

		'총 갯수 구하기
		sqlStr = "select count(evt_code) as cnt, CEILING(CAST(Count(*) AS FLOAT)/'"&FPageSize&"' ) as totPg" + vbcrlf
		sqlStr = sqlStr & " from db_culture_station.dbo.tbl_culturestation_event_comment" + vbcrlf
		sqlStr = sqlStr & " where isusing='Y' " + vbcrlf
		sqlStr = sqlStr & " and evt_code = "& frectevt_code &"" + vbcrlf
		'response.write sqlStr
		rsget.Open sqlStr,dbget,1
			FTotalCount = rsget("cnt")
			FTotalPage = rsget("totPg")
		rsget.Close

		'지정페이지가 전체 페이지보다 클 때 함수종료
		if Cint(FCurrPage)>Cint(FTotalPage) then
			FResultCount = 0
			exit sub
		end if

		'데이터 리스트
		sqlStr = "select top " & Cstr(FPageSize * FCurrPage) + vbcrlf
		sqlStr = sqlStr & "	c.idx, c.evt_code, c.userid, c.comment, c.regdate, e.evt_name, c.device " + vbcrlf
		sqlStr = sqlStr & "		from db_culture_station.dbo.tbl_culturestation_event_comment as c " + vbcrlf
		sqlStr = sqlStr & "		Inner Join db_culture_station.dbo.tbl_culturestation_event as e on C.evt_code = e.evt_code " + vbcrlf
		sqlStr = sqlStr & "		where c.isusing='Y' and c.evt_code = "& frectevt_code &"" + vbcrlf
		sqlStr = sqlStr & "		order by c.idx Desc  " + vbcrlf
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
				FItemList(i).fevt_name = rsget("evt_name")
				FItemList(i).fdevice = rsget("device")
				rsget.movenext
				i=i+1
			loop
		end if
		rsget.Close
	end sub


	'//컬쳐스테이션 이벤트
	public sub fevent()
		dim sqlStr,i, addSql

		sqlStr = "select count(evt_code) as cnt, CEILING(CAST(Count(*) AS FLOAT)/'"&FPageSize&"' ) as totPg" + vbcrlf
		sqlStr = sqlStr & " from db_culture_station.dbo.tbl_culturestation_event " + vbcrlf
		sqlStr = sqlStr & " where isusing='Y' and m_isusing='Y'  and getdate() < enddate  " + vbcrlf
		'response.write sqlStr
		rsget.Open sqlStr,dbget,1
			FTotalCount = rsget("cnt")
			FTotalPage = rsget("totPg")
		rsget.Close

		If fsort="1" Then
		addSql = addSql + " order by a.m_sortNo asc, a.evt_code desc"
		else
			addSql = addSql + " order by cnt desc "
		End If

		if FTotalCount < 1 then exit sub

		'데이터 리스트
		sqlStr = "select top " & Cstr(FPageSize * FCurrPage) + vbcrlf
		sqlStr = sqlStr & "	a.evt_code,a.evt_name, a.m_isusing, a.m_img_icon, a.m_sortNo, count(a.evt_code) as cnt " + vbcrlf
		sqlStr = sqlStr & "		from db_culture_station.dbo.tbl_culturestation_event as a " + vbcrlf
		sqlStr = sqlStr & "		left outer join db_culture_station.dbo.tbl_culturestation_event_comment as b " + vbcrlf
		sqlStr = sqlStr & "		on a.evt_code= b.evt_code " + vbcrlf
		sqlStr = sqlStr & "		where a.isusing='Y' and a.m_isusing = 'Y' and getdate() < a.enddate  " + vbcrlf
		sqlStr = sqlStr & "		group by a.evt_code,a.evt_name, a.m_isusing, a.m_img_icon, a.m_sortNo  " & addSql + vbcrlf

		'response.write sqlStr &"<br>"
		rsget.pagesize = FPageSize
		rsget.Open sqlStr,dbget,1

		'FResultCount = rsget.RecordCount
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))

		redim preserve FItemList(FResultCount)
		i=0
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FItemList(i) = new cevent_oneitem
				FItemList(i).fevt_code = rsget("evt_code")
				FItemList(i).fevt_name = rsget("evt_name")
				FItemList(i).fm_isusing = rsget("m_isusing")
				FItemList(i).fm_img_icon = rsget("m_img_icon")
				FItemList(i).fm_sortNo = rsget("m_sortNo")
				rsget.movenext
				i=i+1
			loop
		end if
		rsget.Close
	end sub

	'//컬쳐스테이션 베스트 이벤트
	public sub fbestevent()
		dim sqlStr,i

		'데이터 리스트
		sqlStr = "select top 3 " + vbcrlf
		sqlStr = sqlStr & "	evt_code,evt_name, m_isusing, m_img_icon, m_sortNo " + vbcrlf
		sqlStr = sqlStr & "		from db_culture_station.dbo.tbl_culturestation_event " + vbcrlf
		sqlStr = sqlStr & "		where isusing='Y' and m_isusing = 'Y' and getdate() < enddate " + vbcrlf
		sqlStr = sqlStr & "		order by m_sortNo asc, evt_code desc " + vbcrlf
		'response.write sqlStr &"<br>"
		rsget.pagesize = FPageSize
		rsget.Open sqlStr,dbget,1

		FResultCount = rsget.RecordCount
		redim preserve FItemList(FResultCount)
		i=0
		if  not rsget.EOF  then
			do until rsget.eof
				set FItemList(i) = new cevent_oneitem
				FItemList(i).fevt_code = rsget("evt_code")
				FItemList(i).fevt_name = rsget("evt_name")
				FItemList(i).fm_isusing = rsget("m_isusing")
				FItemList(i).fm_img_icon = rsget("m_img_icon")
				FItemList(i).fm_sortNo = rsget("m_sortNo")
				rsget.movenext
				i=i+1
			loop
		end if
		rsget.Close
	end sub
	'//컬쳐스테이션 최근이벤트 가져오기  '//culturestation/culturestatioin.asp
	public sub fevent_type()
		dim SqlStr

		sqlStr = "exec [db_culture_station].dbo.new_mobile_one "

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

'2015-07-01 모바일 XML배너 유태욱 추가
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

'		If Cint(FCurrPage) > Cint(FTotalPage) then
'			FResultCount = 0
'			Exit Sub
'		End If

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
	            		FItemList(i).Fimage_barner2		= webImgUrl & "/culturestation/2009/barner2/" & rsget("image_barner2")
	            		'FItemList(i).Fimage_barner2		= "http://thumbnail.10x10.co.kr/webimage/culturestation/2009/barner2/" & rsget("image_barner2") & "?cmd=thumb&w=156&h=195&fit=true&ws=false"
	            	End If
				i = i + 1
				rsget.moveNext
			Loop
		End If
		rsget.close
	End Sub

	public sub fevent_top5_list()
		dim sqlStr, addSql, i
		
		addSql = "Where evt_type in ('0','1')"
		addSql = addSql & " and isusing='Y' and (image_list<>'' or image_list is not null)"
		addSql = addSql & " and startdate<=getdate() and enddate >= getdate()"
		addSql = addSql & " and evt_kind>=0"
		If frectevt_code<>"" Then
		addSql = addSql & " and evt_code<>" & frectevt_code
		End If

		'목록 접수
        sqlStr = "Select top 8 evt_code, evt_name, evt_comment, regdate, startdate, enddate, evt_type, image_barner2, image_barner3, evt_kind, image_list "
		sqlStr = sqlStr & "	,(select count(idx) from db_culture_station.dbo.tbl_culturestation_event_comment as c "
		sqlStr = sqlStr & "	where isusing='Y' and c.evt_code = e.evt_code) as comCnt "
        sqlStr = sqlStr & " From db_culture_station.dbo.tbl_culturestation_event as e "
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
	            FItemList(i).fevt_comment		= rsget("evt_comment")
	            FItemList(i).fregdate			= rsget("regdate")
	            FItemList(i).fstartdate			= rsget("startdate")
	            FItemList(i).fenddate			= rsget("enddate")
	            FItemList(i).fevt_type			= rsget("evt_type")
	            if Not(rsget("image_list")="" or isNull(rsget("image_list"))) then
	            	FItemList(i).fimage_barner2		= webImgUrl & "/culturestation/2009/list/" & rsget("image_list")
	            end if
	            if Not(rsget("image_barner3")="" or isNull(rsget("image_barner3"))) then
	            	FItemList(i).fimage_barner3		= webImgUrl & "/culturestation/2009/barner3/" & rsget("image_barner3")
	            else
	            	FItemList(i).fimage_barner3 = FItemList(i).fimage_barner2		'//작은게 없으면 큰거 삽입
	            end if
	            FItemList(i).fdcount			= rsget("comCnt")
				FItemList(i).fevt_kind			= rsget("evt_kind")
				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.close
	end Sub
'내가 쓴 글 갯수 구하기
	public sub fMyevent_comment_cnt()
		dim sqlStr

		sqlStr = "select count(evt_code) as cnt" + vbcrlf
		sqlStr = sqlStr & " from db_culture_station.dbo.tbl_culturestation_event_comment" + vbcrlf
		sqlStr = sqlStr & " where isusing='Y' " + vbcrlf
		sqlStr = sqlStr & " and evt_code = "& frectevt_code &" and userid = '"&fuserid&"'" + vbcrlf
		'response.write sqlStr
		rsget.Open sqlStr,dbget,1
			FTotalCount = rsget("cnt")
		rsget.Close
	end sub

'내가 쓴 글 수정시
	public sub fMyevent_comment()
		dim sqlStr

		sqlStr = "select * " + vbcrlf
		sqlStr = sqlStr & " from db_culture_station.dbo.tbl_culturestation_event_comment" + vbcrlf
		sqlStr = sqlStr & " where isusing='Y' " + vbcrlf
		sqlStr = sqlStr & " and evt_code = "& frectevt_code &" and userid = '"&fuserid&"' and idx = '"&frectidx&"'" + vbcrlf
        rsget.Open sqlStr, dbget, 1
        FTotalCount = rsget.recordcount
        set FOneItem = new cevent_oneitem
	        if Not rsget.Eof then
				FOneItem.fidx = rsget("idx")
				FOneItem.fevt_code = rsget("evt_code")
				FOneItem.fcomment = db2html(rsget("comment"))
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
%>
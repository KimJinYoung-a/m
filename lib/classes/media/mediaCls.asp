<%
'// 상품
dim vIsTest
IF application("Svr_Info") = "Dev" THEN
	vIsTest = "test"
Else
	vIsTest = ""
End If

Class MediaContentsCls
    '// contents
	public Fcidx
	public Fservicecode
	public Fgroupcode
	public Fctitle
	public Fmainimage
	public Fcommenteventid
	public Fstartdate
	public Fenddate
	public Fisaod
	public Fctext
	public Fvideourl
	public Fevtlinkimage1
	public Fevtlinkcode1
	public Fevtlinkimage2
	public Fevtlinkcode2
	public Fevtlinkimage3
	public Fevtlinkcode3
	public Fevtlinkimage4
	public Fevtlinkcode4
	public Fevtlinkimage5
	public Fevtlinkcode5
	public Fviewcount
	public Flikecount
	public Fisusing
	public Fregdate
	public Flastupdate
	public Fgroupname
	public Ftitlename
	public Fprofile
	public Fprofileimage
	public Fmylikecount
	public Fevtlinkimage1pc
	public Fevtlinkimage2pc
	public Fevtlinkimage3pc
	public Fevtlinkimage4pc
	public Fevtlinkimage5pc
    
End Class

Class MediaCls

	Public FItemList()
	Public FItem	
	public FResultCount
	public FPageSize
	public FCurrPage
	public Ftotalcount
	public FScrollCount
	public FTotalpage
	public FPageCount
	public FOneItem
	public FrectCidx
	public FrectIsusing
	public FrectUserId

	public FrectSortMet
	public FrectListType
	public FrectServiceCode
	public FrectGroupCode	
	
	Private Sub Class_Initialize()
		FCurrPage =1
		FPageSize = 50
		FResultCount = 0
		FScrollCount = 10
		FTotalCount =0
	End Sub
	Private Sub Class_Terminate()

	End Sub
		
	'페이징
	public sub getContentsPageListProc()
		Dim sqlStr ,i , vari , vartmp, vOrderBy, tempDetailCode			
		
		sqlStr = " EXECUTE [db_sitemaster].[dbo].[usp_cm_media_list_cnt_get] '"&FrectListType&"','"&FPageSize&"','"&FrectServiceCode&"','"&FrectGroupCode&"'"		 		

		'response.write sqlStr & "<br>"
		'Response.end

		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"DILS",sqlStr,10)
		if (rsMem is Nothing) then Exit Sub ''추가
		
			FTotalCount = rsMem("Totalcnt")
			FTotalPage = rsMem("totPg")
		rsMem.Close

		'지정페이지가 전체 페이지보다 클 때 함수종료
		if Cint(FCurrPage)>Cint(FTotalPage) then
			FResultCount = 0
			exit sub
		end if

		If FTotalCount > 0 Then			

			sqlStr = " EXECUTE [db_sitemaster].[dbo].[usp_cm_media_list_get] '"&FrectListType&"','"&Cstr(FPageSize * FCurrpage)&"','"&FrectServiceCode&"','"&FrectGroupCode&"', '"&FrectSortMet&"' , '"& FrectUserId &"'"
			
			set rsMem = getDBCacheSQL(dbget,rsget,"DILS",sqlStr,10)
			if (rsMem is Nothing) then Exit Sub ''추가
			
			rsMem.pagesize = FPageSize

			if (FCurrPage * FPageSize < FTotalCount) then
				FResultCount = FPageSize
			else
				FResultCount = FTotalCount - FPageSize*(FCurrPage-1)
			end if

			FTotalPage = (FTotalCount\FPageSize)

			if (FTotalPage<>FTotalCount/FPageSize) then FTotalPage = FTotalPage +1

			redim preserve FItemList(FResultCount)

			FPageCount = FCurrPage - 1
			if  not rsMem.EOF  then
				rsMem.absolutePage=FCurrPage
				do until rsMem.eof
					set FItemList(i) = new MediaContentsCls
														
					FItemList(i).Fcidx			= rsMem("cidx")
					FItemList(i).Fservicecode	= rsMem("servicecode")
					FItemList(i).Fgroupcode		= rsMem("groupcode")
					FItemList(i).Fctitle		= rsMem("ctitle")
					FItemList(i).Fmainimage		= rsMem("mainimage")
					FItemList(i).Fcommenteventid= rsMem("commenteventid")
					FItemList(i).Fstartdate		= rsMem("startdate")
					FItemList(i).Fenddate		= rsMem("enddate")
					FItemList(i).Fisaod			= rsMem("isaod")
					FItemList(i).Fctext			= rsMem("ctext")
					FItemList(i).Fvideourl		= rsMem("videourl")
					FItemList(i).Fevtlinkimage1	= rsMem("evtlinkimage1")
					FItemList(i).Fevtlinkcode1	= rsMem("evtlinkcode1")
					FItemList(i).Fevtlinkimage2	= rsMem("evtlinkimage2")
					FItemList(i).Fevtlinkcode2	= rsMem("evtlinkcode2")
					FItemList(i).Fevtlinkimage3	= rsMem("evtlinkimage3")
					FItemList(i).Fevtlinkcode3	= rsMem("evtlinkcode3")
					FItemList(i).Fevtlinkimage4	= rsMem("evtlinkimage4")
					FItemList(i).Fevtlinkcode4	= rsMem("evtlinkcode4")
					FItemList(i).Fevtlinkimage5	= rsMem("evtlinkimage5")
					FItemList(i).Fevtlinkcode5	= rsMem("evtlinkcode5")
					FItemList(i).Fviewcount		= rsMem("viewcount")
					FItemList(i).Flikecount		= rsMem("likecount")
					FItemList(i).Fisusing		= rsMem("isusing")
					FItemList(i).Fregdate		= rsMem("regdate")
					FItemList(i).Flastupdate	= rsMem("lastupdate")
					FItemList(i).Fgroupname		= rsMem("groupname")
					if FrectUserId <> "" then 
						FItemList(i).Fmylikecount	= rsMem("mylikecount")
					else
						FItemList(i).Fmylikecount	= 0
					end if 

					i=i+1
					rsMem.moveNext
				loop
			end if

			rsMem.Close
		End If
	end Sub

    public Sub getOneContents()
        dim sqlStr
        		
		sqlStr = sqlStr + " SELECT * "&vbCrLf
		sqlStr = sqlStr + "   FROM db_sitemaster.dbo.tbl_media_contents AS c "&vbCrLf
		sqlStr = sqlStr + "   INNER JOIN db_sitemaster.dbo.tbl_media_manage as m "&vbCrLf
		sqlStr = sqlStr + "   ON c.servicecode = m.servicecode and c.groupcode = m.groupcode "&vbCrLf
		sqlStr = sqlStr + "  WHERE c.isusing = 1 "&vbCrLf
		sqlStr = sqlStr + " AND c.cidx = '" & FrectCidx & "'"&vbCrLf
		' sqlStr = sqlStr + " AND getdate() >= startdate "&vbCrLf
   		' sqlStr = sqlStr + " AND getdate() <= enddate "&vbCrLf

        rsget.CursorLocation = adUseClient
		rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
        
        set FOneItem = new MediaContentsCls
        
        if Not rsget.Eof Then				
			FOneItem.Fcidx			 = rsget("cidx")
			FOneItem.Fservicecode	 = rsget("servicecode")
			FOneItem.Fgroupcode		 = rsget("groupcode")
			FOneItem.Fctitle		 = rsget("ctitle")
			FOneItem.Fmainimage		 = rsget("mainimage")
			FOneItem.Fcommenteventid = rsget("commenteventid")
			FOneItem.Fstartdate		 = rsget("startdate")
			FOneItem.Fenddate		 = rsget("enddate")
			FOneItem.Fisaod			 = rsget("isaod")
			FOneItem.Fctext			 = rsget("ctext")
			FOneItem.Fvideourl		 = rsget("videourl")
			FOneItem.Fevtlinkimage1	 = rsget("evtlinkimage1")
			FOneItem.Fevtlinkcode1	 = rsget("evtlinkcode1")
			FOneItem.Fevtlinkimage2	 = rsget("evtlinkimage2")
			FOneItem.Fevtlinkcode2	 = rsget("evtlinkcode2")
			FOneItem.Fevtlinkimage3	 = rsget("evtlinkimage3")
			FOneItem.Fevtlinkcode3	 = rsget("evtlinkcode3")
			FOneItem.Fevtlinkimage4	 = rsget("evtlinkimage4")
			FOneItem.Fevtlinkcode4	 = rsget("evtlinkcode4")
			FOneItem.Fevtlinkimage5	 = rsget("evtlinkimage5")
			FOneItem.Fevtlinkcode5	 = rsget("evtlinkcode5")
			FOneItem.Fviewcount		 = rsget("viewcount")
			FOneItem.Flikecount		 = rsget("likecount")
			FOneItem.Fisusing		 = rsget("isusing")
			FOneItem.Fregdate		 = rsget("regdate")
			FOneItem.Flastupdate	 = rsget("lastupdate")
			FOneItem.Ftitlename	 	 = rsget("titlename")
			FOneItem.Fprofile	 	 = rsget("profile")
			FOneItem.Fprofileimage 	 = rsget("profileimage")

			FOneItem.Fevtlinkimage1pc	 = rsget("evtlinkimage1pc")
			FOneItem.Fevtlinkimage2pc	 = rsget("evtlinkimage2pc")
			FOneItem.Fevtlinkimage3pc	 = rsget("evtlinkimage3pc")
			FOneItem.Fevtlinkimage4pc	 = rsget("evtlinkimage4pc")
			FOneItem.Fevtlinkimage5pc	 = rsget("evtlinkimage5pc")

        end If
        
        rsget.Close
    end Sub	

	Public Function getDetailGroupList(masterCode)
		dim tmpSQL,i, detailGroupList()	

		tmpSQL = " SELECT DETAILCODE	"
		tmpSQL = tmpSQL & "     , TITLE	"
		tmpSQL = tmpSQL & "  FROM db_event.dbo.tbl_exhibition_groupcode	"
		tmpSQL = tmpSQL & " WHERE detailcode IN (	"
		tmpSQL = tmpSQL & "	select a.detailcode	 	"
		tmpSQL = tmpSQL & "	  from db_event.dbo.tbl_exhibition_items as a	"
		tmpSQL = tmpSQL & "	 where mastercode = '" & mastercode& "'	"
		tmpSQL = tmpSQL & "	 group by detailcode 	"
		tmpSQL = tmpSQL & " )	"
		tmpSQL = tmpSQL & "   AND mastercode = '"& mastercode &"'	"
		tmpSQL = tmpSQL & "   AND gubuncode = 2	"
		tmpSQL = tmpSQL & "   AND ISUSING = 1	"
		tmpSQL = tmpSQL & "   ORDER BY DETAILCODE ASC	"
		
		
		rsget.CursorLocation = adUseClient
		rsget.CursorType=adOpenStatic
		rsget.Locktype=adLockReadOnly
		rsget.Open tmpSQL, dbget,2

		redim preserve detailGroupList(rsget.recordcount)

		If Not rsget.EOF Then
			do until rsget.EOF
				set detailGroupList(i) = new ExhibitionItemsCls

				detailGroupList(i).Fdetailcode	= rsget("detailcode")			
				detailGroupList(i).Ftitle		= rsget("title")

				rsget.movenext
				i=i+1
			loop
			getDetailGroupList = detailGroupList
		ELSE
			getDetailGroupList = detailGroupList
		End if
		rsget.close
	End Function

	Public Function getSwipeBanner(serviceCode,channel)
		if serviceCode = "" or channel= "" then
			exit function
		end if

		dim SqlStr 
		sqlStr = sqlStr & " SELECT top 5 "&vbCrLf 
		sqlStr = sqlStr & " b.servicecode , b.bannerimage, b.maincopy, b.subcopy, b.linkurl, b.startdate, b.enddate	"&vbCrLf
		sqlStr = sqlStr & " , b.isaod, b.isusing, b.sortnumber, b.channel , b.evt_code , b.cidx "&vbCrLf
		sqlStr = sqlStr & " FROM db_sitemaster.dbo.tbl_media_bannermanage AS b WITH(NOLOCK) "&vbCrLf
		sqlStr = sqlStr & " OUTER APPLY (SELECT evt_state FROM db_event.dbo.tbl_event WITH(NOLOCK) WHERE evt_code = b.evt_code) AS et "&vbCrLf
		sqlStr = sqlStr & " WHERE b.servicecode = '"& serviceCode &"' AND b.channel = "& channel &"	"&vbCrLf
		sqlStr = sqlStr & " AND b.isusing = 1 AND isnull(b.bannerimage , '') <> '' "&vbCrLf
		sqlStr = sqlStr & " AND ((convert(varchar(10),b.startdate,120) <= convert(varchar(10),getdate(),120) AND convert(varchar(10),b.enddate,120) >= convert(varchar(10),getdate(),120)) OR b.isaod = 1) "&vbCrLf
		sqlStr = sqlStr & " AND (et.evt_state is null OR et.evt_state = 7) "&vbCrLf
		sqlStr = sqlStr & " ORDER BY b.sortnumber ASC , b.idx DESC "

		'  response.write sqlStr &"<br>"
		'  response.end
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

		if not rsget.EOF then
			getSwipeBanner = rsget.getRows()    
		end if
		rsget.close 
	End Function
	
	public Function getRelatedItems(cIdx)
		if cIdx = "" then
			exit function
		end if

		dim SqlStr 

		sqlStr = sqlStr & " select A.cidx	"
		sqlStr = sqlStr & " 	 , A.itemid	"
		sqlStr = sqlStr & " 	 , isNull(convert(int,(ROUND(eps.TotalPoint,2)*100)),0) as totalpoint 	"
		sqlStr = sqlStr & " 	 , b.basicImage	"
		sqlStr = sqlStr & " 	 , b.itemname	"
		sqlStr = sqlStr & " 	 , B.tentenimage	"
		sqlStr = sqlStr & " 	 , B.tentenimage200	"
		sqlStr = sqlStr & " 	 , B.tentenimage400	"
		sqlStr = sqlStr & " 	 , FAVCOUNT	"
		sqlStr = sqlStr & " 	 , b.sellyn	"
		sqlStr = sqlStr & "   from db_sitemaster.dbo.tbl_media_items AS A	"
		sqlStr = sqlStr & "  INNER JOIN DB_ITEM.DBO.TBL_ITEM B ON A.itemid = B.itemid	"
		sqlStr = sqlStr & "  INNER JOIN DB_ITEM.DBO.TBL_ITEM_CONTENTS C ON A.ITEMID = C.ITEMID	"
		sqlStr = sqlStr & "   LEFT JOIN [db_board].[dbo].[tbl_const_eval_PointSummary] AS eps on eps.itemid = a.itemid 	"
		sqlStr = sqlStr & "  where cidx = '"& cIdx &"'	"

	'       response.write sqlStr &"<br>"
	'       response.end
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

		if not rsget.EOF then
			getRelatedItems = rsget.getRows()    
		end if
		rsget.close 
	end Function

	public Function getRelatedEvents(serviceCode)
		if serviceCode = "" then
			exit function
		end if

		dim SqlStr 

		sqlStr = sqlStr & " select A.idx	"
		sqlStr = sqlStr & " 	 , A.servicecode	"
		sqlStr = sqlStr & " 	 , A.evt_code	"
		sqlStr = sqlStr & " 	 , B.evt_startdate	"
		sqlStr = sqlStr & " 	 , B.evt_enddate	"
		sqlStr = sqlStr & " 	 , A.isusing	"
		sqlStr = sqlStr & " 	 , A.evtsortnumber 	"
		sqlStr = sqlStr & "   from db_sitemaster.dbo.tbl_media_addonevent a	"
		sqlStr = sqlStr & "   inner join db_event.dbo.tbl_event b on a.evt_code = b.evt_code "
		sqlStr = sqlStr & "  where 1 = 1	"
		sqlStr = sqlStr & "    and A.isusing = 1	"
		sqlStr = sqlStr & "    and A.servicecode = '"& serviceCode &"'	"		
   		sqlStr = sqlStr & "    and CONVERT(VARCHAR(10), GETDATE(), 120) >= CONVERT(VARCHAR(10), B.EVT_STARTDATE, 120) "
   		sqlStr = sqlStr & "    and CONVERT(VARCHAR(10), GETDATE(), 120) <= CONVERT(VARCHAR(10), B.EVT_ENDDATE, 120) 		"
		sqlStr = sqlStr & "  order by A.evtsortnumber asc	"
		
	'       response.write sqlStr &"<br>"
	'       response.end
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

		if not rsget.EOF then
			getRelatedEvents = rsget.getRows()    
		end if
		rsget.close 
	end Function

	'// 영상에 등장한 상품 - 상세
	Public Function getContentsItemsList(contentsIdx)
		if contentsIdx = "" then
			exit function
		end if

		dim SqlStr 
		sqlStr = sqlStr & " SELECT "&vbCrLf 
		sqlStr = sqlStr & " ci.itemid , i.basicimage , i.tentenimage400 , i.itemname , i.evalcnt , c.favcount "&vbCrLf
		sqlStr = sqlStr & " ,isNull(convert(int ,(ROUND(eps.TotalPoint,2)*100)),0) AS totalpoint "&vbCrLf
		sqlStr = sqlStr & " ,i.sellyn , i.limityn , i.limitno , i.limitsold "&vbCrLf
		sqlStr = sqlStr & " FROM db_sitemaster.dbo.tbl_media_items AS ci WITH(NOLOCK) "&vbCrLf
		sqlStr = sqlStr & " INNER JOIN db_item.dbo.tbl_item AS i WITH(NOLOCK) "&vbCrLf
		sqlStr = sqlStr & " ON ci.itemid = i.itemid "&vbCrLf
		sqlStr = sqlStr & " LEFT OUTER JOIN db_board.dbo.tbl_const_eval_pointsummary AS eps WITH(NOLOCK) "&vbCrLf
		sqlStr = sqlStr & " ON eps.itemid = ci.itemid "&vbCrLf
		sqlStr = sqlStr & " LEFT OUTER JOIN db_item.dbo.tbl_item_contents AS C WITH(NOLOCK) "&vbCrLf
		sqlStr = sqlStr & " ON c.itemid = ci.itemid "&vbCrLf
		sqlStr = sqlStr & " WHERE ci.cidx = "& contentsIdx &" "

		' response.write sqlStr &"<br>"
		' response.end
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

		if not rsget.EOF then
			getContentsItemsList = rsget.getRows()    
		end if
		rsget.close 
	End Function

	'// 키워드 목록 - 상세
	Public Function getContentsKeywordList(contentsIdx)
		if contentsIdx = "" then
			exit function
		end if

		dim SqlStr 
		sqlStr = sqlStr & " SELECT * FROM "&vbCrLf 
		sqlStr = sqlStr & " db_sitemaster.dbo.tbl_media_keywordlog "&vbCrLf
		sqlStr = sqlStr & " WHERE cidx = "& contentsIdx &" "

		' response.write sqlStr &"<br>"
		' response.end
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

		if not rsget.EOF then
			getContentsKeywordList = rsget.getRows()    
		end if
		rsget.close 
	End Function

	'// 좋아요 등록 
	public function setContentsLikeCount(vCidx , vUserid , vUserLevel , vDevice , vClickCount)
		if vCidx="" or vUserid="" or vUserLevel ="" or vDevice ="" or vClickCount ="" then exit function
		dim vQuery , intLoop
		'### log 입력
		for intloop = 0 to cint(vClickCount)-1
			vQuery = vQuery & "INSERT INTO db_sitemaster.dbo.tbl_media_clicklog "&vbCrLf 
			vQuery = vQuery & "(cidx , userid , userlevel , device , type) "&vbCrLf 
			vQuery = vQuery & "VALUES ('"& vCidx &"' , '"& vUserid &"' , '"& vUserLevel &"' , '"& vDevice &"' , '2');"&vbCrLf 
		next
		dbget.execute vQuery

		'### likecount 증가
		vQuery = "UPDATE db_sitemaster.dbo.tbl_media_contents SET likecount = likecount + "& vClickCount &" WHERE cidx = "& vCidx &" "
		dbget.execute vQuery
		setContentsLikeCount = true
	end function

	'// 조회수 등록 
	public function setContentsViewCount(vCidx , vUserid , vUserLevel , vDevice)
		dim vQuery
		'### log 입력
		vQuery = "INSERT INTO db_sitemaster.dbo.tbl_media_clicklog "&vbCrLf 
		vQuery = vQuery & "(cidx , userid , userlevel , device , type) "&vbCrLf 
		vQuery = vQuery & "VALUES ('"& vCidx &"' , '"& vUserid &"' , '"& vUserLevel &"' , '"& vDevice &"' , '1')"&vbCrLf 
		dbget.execute vQuery

		'### viewcount 증가
		vQuery = "UPDATE db_sitemaster.dbo.tbl_media_contents SET viewcount = viewcount + 1 WHERE cidx = "& vCidx &" "
		dbget.execute vQuery
	end function

	'// wish리스트
	Public Function getMyMediaWishList(userId, folderName)
		if folderName = "" or userId = "" then
			exit function
		end if

		dim SqlStr 
		dim vRs , objCmd

		sqlStr = " select itemid "&vbCrLf
		sqlStr = sqlStr & " from db_my10x10.dbo.tbl_myfavorite_folder as ff with(nolock)	" & vbCrLf
		sqlStr = sqlStr & " left join db_my10x10.dbo.tbl_myfavorite as f with(nolock)	" & vbCrLf
		sqlStr = sqlStr & " on ff.fidx = f.fidx and ff.userid = f.userid " & vbCrLf
		sqlStr = sqlStr & " where ff.userid = ? and foldername = ? "

		Set objCmd = Server.CreateObject("ADODB.COMMAND")
		With objCmd
			.ActiveConnection = dbget
			.CommandType = adCmdText
			.CommandText = sqlStr
			.Prepared = true
			.Parameters.Append .CreateParameter("userid", adVarChar, adParamInput, Len(userId), userId)
			.Parameters.Append .CreateParameter("foldername", adVarChar, adParamInput, 32, folderName)
			SET vRs = objCmd.Execute
				if not vRs.EOF then
					getMyMediaWishList = vRs.getRows()
				end if
			SET vRs = nothing
		End With
		Set objCmd = Nothing
	End Function

	Public Function getMylikeCount(userId, cIdx)
		if userId = "" or cIdx = "" then
			exit function
		end if

		dim SqlStr 

		sqlStr = sqlStr & " SELECT COUNT(*) as mylikecount "&vbCrLf
		sqlStr = sqlStr & "  FROM db_sitemaster.dbo.tbl_media_clicklog 	"&vbCrLf
		sqlStr = sqlStr & " WHERE Cidx = " & cIdx & " "&vbCrLf
		sqlStr = sqlStr & "   and userid = '" & userId & "'	"&vbCrLf
		sqlStr = sqlStr & "   and type = 2 "&vbCrLf

		' response.write sqlStr &"<br>"
		' response.end
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

		if not rsget.EOF then
			getMylikeCount = rsget("mylikecount")
		end if
		rsget.close 
	End Function	

	function fnEvalTotalPointAVG(t,g)
		dim vTmp
		vTmp = 0
		If t <> "" Then
			If isNumeric(t) Then
				If t > 0 Then
					If g = "search" Then
						vTmp = (t/4)
					Else
						vTmp = ((Round(t,2) * 100)/4)
					End If
					vTmp = Round(vTmp)
				End If
			End If
		End If
		fnEvalTotalPointAVG = vTmp
	end function		
End Class
%>
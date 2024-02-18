<%

class CEvaluateSearcherItem
	Public Fidx
	public FUserID
	public FTitle
	public FUesdContents
	public FManiaPoint
	public FTotalPoint
	public FPoint
	public FPoint_fun
	public FPoint_dgn
	public FPoint_prc
	public FPoint_stf
	public Fimgsmall
	
	
	public FIcon1
	public FIcon2
	
	public Flinkimg1
	public Flinkimg2
	public Flinkimg3
	public Flinkimg4
	public Flinkimg5
		
	Public FImgContents1
	Public FImgContents2
	Public FImgContents3
	Public FImgContents4
	Public FImgContents5
	
	public FItemID
	public Fimglist
	Public Fgubun
	public FRegdate
	
	Public FItemname
	Public FItemCost
	Public FItemDiv
	Public FItemOption
	Public FOptionName
	Public FMakerName
	Public FMakerID
	Public FOrderSerial
	Public FOrderDate
	Public FImageList100
	Public FImageList120
	Public FEvalRegDate
	Public FEvalCnt
	
	Public FEvtprize_Code
	Public FEvt_Code
	
	
	Public F100ShopIdx
	Public FCouponName
	Public FCouponValue
	Public FCouponType
	Public FCouponStartDate
	Public FCouponExpireDate
	Public Fminbuyprice

	Public Fhitcount
	Public Fcommentcount
	Public Fscoresum
	Public Fsellcash
	Public Fcontents
	Public Fnourlfile1
	Public Ffile1
	Public Fnourlfile2
	Public Ffile2
	Public Fnourlfile3
	Public Ffile3
	Public Fnourlfile4
	Public Ffile4
	Public Fnourlfile5
	Public Ffile5
	Public Fnourlicon1

	Public FstartDate
	Public FendDate
	
	Public FUseGood
	Public FUseBad
	Public FUseETC
	Public FMyBlog
	Public FEvalCount
	Public FFavCount
	Public FImageIcon2

	public Function getUsingTitle(LimitSize)
	
		if Len(FUesdContents) > LimitSize then
			getUsingTitle = Left(FUesdContents,LimitSize) + "..."
		else
			getUsingTitle = FUesdContents
		end if
	
	end Function 
	
	public function IsPhotoExist()
		IsPhotoExist = (Flinkimg1<>"") or (Flinkimg2<>"")
	end function
	
	public Function getLinkImage1()
		getLinkImage1 = "http://imgstatic.10x10.co.kr/testgoodsimage/" + GetImageSubFolderByItemid(Fitemid) + "/" + Flinkimg1
	end function 
	
	public Function getLinkImage2()
		getLinkImage2 =	"http://imgstatic.10x10.co.kr/testgoodsimage/" + GetImageSubFolderByItemid(Fitemid) + "/" + Flinkimg2
	end function 
	
	public Function getLinkImage3()
		getLinkImage3 =	"http://imgstatic.10x10.co.kr/testgoodsimage/" + GetImageSubFolderByItemid(Fitemid) + "/" + Flinkimg3
	end function 
	
	public Function getLinkImage4()
		getLinkImage4 =	"http://imgstatic.10x10.co.kr/testgoodsimage/" + GetImageSubFolderByItemid(Fitemid) + "/" + Flinkimg4
	end function 
	
	public Function getLinkImage5()
		getLinkImage5 =	"http://imgstatic.10x10.co.kr/testgoodsimage/" + GetImageSubFolderByItemid(Fitemid) + "/" + Flinkimg5
	end function 
	


	Private Sub Class_Terminate()

	End Sub

	public sub Class_Initialize()

	end sub
end Class

Class CEvaluateSearcher
	public FItemList()
	public FcdLCnt()
	public FcdLTotalPage
	public FEvalItem


	public FTotTotalCount
	public FTotalCount
	public FResultCount
	public FCurrPage
	public FTotalPage
	public FPageSize
	public FScrollCount

	public FIdx
	public Fgubun
	public FRectUserID
	public FRectItemID
	public FECode	'이벤트코드
	public FPCode	'이벤트당첨코드
	public FDiscountRate
	public FRectStartPoint
	public FSortMethod
	public FRectcdL
	public FRectDisp
	public FRectEvaluatedYN
	public FRectOrderSerial
	public FRectOption
	public FRectSearchtype
	public FRectsearchrect

	Private Sub Class_Initialize()
		redim preserve FItemList(0)

		FCurrPage     = 1
		FPageSize     = 5
		FResultCount  = 0
		FScrollCount  = 10
		FTotalCount   = 0

		FDiscountRate = 1
	End Sub

	Private Sub Class_Terminate()

	End Sub



	Public Sub getIsTesterEvaluatedWrite()
		dim sqlStr,i
		sqlStr = " SELECT COUNT(idx) FROM [db_event].[dbo].tbl_tester_Item_Evaluate " & _
				 " WHERE userid='" & FRectUserID & "' AND evtprize_code = '" & FPCode & "' AND evt_code = '" & FECode & "' AND itemid = '" & FRectItemID & "' AND IsUsing = 'Y' "
		rsget.open sqlStr ,dbget,1
		
		If not rsget.eof THEN
			If rsget(0) > 0 Then
				Fgubun = "o"
			Else
				Fgubun = "x"
			End IF
		End If
		rsget.close
	End Sub



	'// 후기쓴 상품 리스트 
	Public Sub EvalutedItemList()
		
		dim sqlStr,i
			sqlStr = "" &_
			
				" select Count(e.idx) as TotalCnt , Ceiling(cast(count(e.idx) as Float)/" & Cstr(FPageSize) & ") as TotalPage " &_
				" FROM  [db_event].[dbo].tbl_tester_Item_Evaluate e WITH(READUNCOMMITTED)"&_
				" inner JOIN db_item.[dbo].tbl_item i WITH(READUNCOMMITTED) on e.itemid=i.itemid "&_
				"	Inner Join [db_event].[dbo].tbl_tester_event_winner AS w on w.evt_winner = e.UserID AND w.evtprize_code = e.evtprize_code AND w.evt_code = e.evt_code " & _
				" WHERE userid='" & FRectUserID & "' "&_
				" and e.isusing='Y' " 
				
				if FRectDisp <> "" then 
					sqlStr = sqlStr & " and i.dispcate1 = '" & FRectDisp & "'"
				end if
				
				
				rsget.open sqlStr ,dbget,1
				
				IF not rsget.eof THEN 
					FTotalCount = rsget("TotalCnt")
					FTotalPage =  rsget("TotalPage")
				End if
				rsget.close	
				
				
			sqlStr = " " &_
				" SELECT Top " & Cstr(FPageSize*(FCurrPage)) &_
				"   e.idx , e.contents ,  e.regdate " &_
				" , e.file1 , e.file2 , e.file3 ,e.file4 , e.file5 "&_
				" , isnull(e.TotalPoint,0) as TotalPoint "&_
				" , isnull(e.Point_function,0) as Point_function "&_
				" , isnull(e.Point_Design,0) as Point_Design "&_
				" , isnull(e.Point_Price,0) as Point_Price "&_ 
				" , isnull(e.Point_satisfy,0) as Point_satisfy "&_
				" , i.itemid , w.itemname , i.sellcash , (Case When isNull(i.frontMakerid,'')='' then i.makerid else i.frontMakerid end) as makerid , i.brandname , i.listimage120 , i.listimage , i.itemdiv  "&_
				" , w.usewrite_edate, w.evtprize_code, w.evt_code, e.UseGood, e.UseBad, e.UseETC, e.MyBlog, i.icon2image " & _
				" FROM  [db_event].[dbo].tbl_tester_Item_Evaluate e "&_
				" inner JOIN db_item.[dbo].tbl_item i on e.itemid=i.itemid "&_
				"	Inner Join [db_event].[dbo].tbl_tester_event_winner AS w on w.evt_winner = e.UserID AND w.evtprize_code = e.evtprize_code AND w.evt_code = e.evt_code " & _
				" WHERE userid='" & FRectUserID & "' "&_
				" and e.isusing='Y' " 
				
				if FRectDisp <> "" then 
					sqlStr = sqlStr & " and i.dispcate1 = '" & FRectDisp & "'"
				end if
				
				'response.write sqlStr
				
			
			rsget.pagesize = FPageSize
			rsget.open sqlStr ,dbget,1
			
			FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
			
			redim preserve FItemList(FResultCount) 
			i=0 
			
			IF not rsget.eof THEN 
				rsget.absolutepage = FCurrPage
				do until rsget.eof 
					
					set FItemList(i) = new CEvaluateSearcherItem
					
					FItemList(i).FItemID 			= rsget("itemid")
					FItemList(i).FItemname 			= db2html(rsget("itemname"))
					FItemList(i).FItemCost			= rsget("sellcash")
					FItemList(i).FItemDiv			= rsget("itemdiv")
					FItemList(i).FMakerName			= db2html(rsget("brandname"))
					FItemList(i).FMakerID			= rsget("makerID")
					FItemList(i).FImageList100 		= "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listimage")
					FItemList(i).FImageList120 		= "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listimage120")
					FItemList(i).FImageIcon2		= "http://webimage.10x10.co.kr/image/icon2/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("icon2image")
					
					FItemList(i).Fidx				= rsget("idx")
					
					FItemList(i).FTotalPoint		= rsget("TotalPoint")
					FItemList(i).FUesdContents 		= db2html(rsget("contents"))
					FItemList(i).FPoint_fun			= rsget("Point_Function")
					FItemList(i).FPoint_dgn			= rsget("Point_Design")
					FItemList(i).FPoint_prc			= rsget("Point_Price")
					FItemList(i).FPoint_stf			= rsget("Point_Satisfy")
					
					FItemList(i).Flinkimg1			= rsget("file1")
					FItemList(i).Flinkimg2			= rsget("file2")
					FItemList(i).Flinkimg3			= rsget("file3")
					FItemList(i).Flinkimg4			= rsget("file4")
					FItemList(i).Flinkimg5			= rsget("file5")
					
					FItemList(i).FRegDate			= rsget("regdate")
					FItemList(i).FendDate			= rsget("usewrite_edate")
				
					FItemList(i).FEvtprize_Code		= rsget("evtprize_code")
					FItemList(i).FEvt_Code			= rsget("evt_code")
					
					FItemList(i).FUseGood			= rsget("UseGood")
					FItemList(i).FUseBad			= rsget("UseBad")
					FItemList(i).FUseETC			= rsget("UseETC")
					FItemList(i).FMyBlog			= rsget("MyBlog")
					
					i=i+1
					rsget.movenext
				loop 
			END IF
			
			rsget.close
	
	End Sub
	

	'// 최근 3개월 이내 구매 & 후기 안쓰인 상품 리스트 
	Public Sub NotEvalutedItemList()
		
		dim sqlStr ,i
		
		sqlStr = "" &_
				" SELECT Count(w.evtprize_code) as TotalCnt , Ceiling(cast(count(w.evtprize_code) as Float)/" & Cstr(FPageSize) & ") as TotalPage " &_
				" FROM [db_event].[dbo].tbl_tester_event_winner AS w  WITH(READUNCOMMITTED)"&_
				" 	LEFT JOIN [db_event].[dbo].tbl_tester_Item_Evaluate AS e  WITH(READUNCOMMITTED) "&_
				" 		on w.evt_winner = e.UserID AND w.evtprize_code = e.evtprize_code AND w.evt_code = e.evt_code and e.isusing = 'Y'  "&_
				" 	LEFT JOIN [db_item].[dbo].tbl_item AS i WITH(READUNCOMMITTED) on i.itemid = w.itemid " & _
				" WHERE E.IDX is NULL " &_
				" 	and w.evt_winner = '" & FRectUserID & "' and w.itemuse_sdate < getdate() and DateDiff(dd,getdate(),w.usewrite_edate) >= 0 "
				
				if FRectDisp <> "" then 
					sqlStr = sqlStr & " and i.dispcate1 = '" & FRectDisp & "'"
				end if

				
				rsget.open sqlStr ,dbget,1
				
				IF not rsget.eof THEN 
					FTotalCount = rsget("TotalCnt")
					FTotalPage =  rsget("TotalPage")
				End if
				rsget.close	

		sqlStr = " " &_
				" SELECT TOP " & Cstr(FPageSize*(FCurrPage)) &_ 
				"  w.itemid , i.sellcash , w.itemname , i.brandname , (Case When isNull(i.frontMakerid,'')='' then i.makerid else i.frontMakerid end) as makerid , i.listimage120, i.listimage , i.itemdiv, i.evalcnt "&_
				" ,e.regdate, w.evtprize_code, w.evt_code, w.usewrite_sdate, w.usewrite_edate, i.evalcnt, c.favcount, i.icon2image " &_
				" FROM [db_event].[dbo].tbl_tester_event_winner AS w  "&_
				" 	LEFT JOIN [db_event].[dbo].tbl_tester_Item_Evaluate AS e   "&_
				" 			on w.evt_winner = e.UserID AND w.evtprize_code = e.evtprize_code AND w.evt_code = e.evt_code and e.isusing = 'Y'  "&_
				" 	LEFT JOIN [db_item].[dbo].tbl_item AS i on i.itemid = w.itemid " & _
				" 	LEFT JOIN [db_item].[dbo].tbl_item_Contents AS c on i.itemid = c.itemid " & _
				" WHERE E.IDX is NULL " &_
				"  and w.evt_winner = '" & FRectUserID & "' and w.itemuse_sdate < getdate() and DateDiff(dd,getdate(),w.usewrite_edate) >= 0 "
				
				if FRectDisp <> "" then 
					sqlStr = sqlStr & " and i.dispcate1 = '" & FRectDisp & "'"
				end if
				
		

				rsget.pagesize = FPageSize
				rsget.open sqlStr ,dbget,1
				'response.write sqlStr
				
				FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))
				if (FResultCount<1) then FResultCount=0
				redim preserve FItemList(FResultCount) 
				i=0 
				
				IF not rsget.eof THEN 
					rsget.absolutepage = FCurrPage
					do until rsget.eof 
						
						set FItemList(i) = new CEvaluateSearcherItem
						
						FItemList(i).FItemID 			= rsget("itemid")
						FItemList(i).FItemname 			= db2html(rsget("itemname"))
						FItemList(i).FItemCost			= rsget("sellcash")
						FItemList(i).FItemDiv			= rsget("itemdiv")
						FItemList(i).FMakerName			= db2html(rsget("brandname"))
						FItemList(i).FMakerID			= rsget("makerID")
						FItemList(i).FOrderDate 		= rsget("regdate")
						FItemList(i).FImageList100 		= "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listimage")
						FItemList(i).FImageList120 		= "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listimage120")
						FItemList(i).FImageIcon2		= "http://webimage.10x10.co.kr/image/icon2/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("icon2image")
						FItemList(i).FRegDate			= rsget("regdate")
						FItemList(i).FEvalCnt			= rsget("evalcnt")
						FItemList(i).FstartDate			= rsget("usewrite_sdate")
						FItemList(i).FendDate			= rsget("usewrite_edate")
						FItemList(i).FEvtprize_Code		= rsget("evtprize_code")
						FItemList(i).FEvt_Code			= rsget("evt_code")
						FItemList(i).FEvalCount			= rsget("evalcnt")
						FItemList(i).FFavCount			= rsget("favcount")
						
						i=i+1
						rsget.movenext
					loop 
				END IF
				
				rsget.close
				
	End Sub
	
	
	
	
	
	'// 후기 쓴 상품 
	Public Sub getEvaluatedItem()
		dim sqlStr
		
		sqlStr = " " &_
			"	SELECT Top 1 " & _
			"		isNull(E.IDX,0) AS IDX, isNull(E.TotalPoint,0) AS TotalPoint, isNull(E.Point_Function,0) AS Point_Function,  " & _
			"		isNull(E.Point_Design,0) AS Point_Design, isNull(E.Point_Price,0) AS Point_Price, isNull(E.Point_Satisfy,0) AS Point_Satisfy, " & _
			"		isNull(E.File1,'') AS file1, isNull(E.File2,'') AS file2, isNull(E.File3,'') AS file3, isNull(E.File4,'') AS file4, isNull(E.File5,'') AS file5,  " & _
			"		isNull(E.Title,'') AS title, isNull(E.Contents,'') AS Contents, " & _
			"		isNull(E.ImgContents1,'') AS ImgContents1, isNull(E.ImgContents2,'') AS ImgContents2, isNull(E.ImgContents3,'') AS ImgContents3, isNull(E.ImgContents4,'') AS ImgContents4, isNull(E.ImgContents5,'') AS ImgContents5, " & _
			"		isNull(E.UseGood, '') AS UseGood, isNull(E.UseBad, '') AS UseBad, isNull(E.UseETC, '') AS UseETC, isNull(E.MyBlog, '') AS MyBlog, " & _
			"		I.sellcash, I.brandname, I.listimage, I.itemname, W.itemid, i.icon2image " & _
			"	FROM [db_event].[dbo].[tbl_tester_event_winner] AS W WITH(READUNCOMMITTED)" & _
			"		Left Join [db_event].[dbo].[tbl_tester_Item_Evaluate] AS E WITH(READUNCOMMITTED) ON W.evtprize_code = E.evtprize_code AND W.evt_code = E.evt_code AND E.isusing = 'Y' " & _
			"		Left Join [db_item].[dbo].[tbl_item] AS I WITH(READUNCOMMITTED) ON W.itemid = I.itemid " & _
			"	WHERE " & _
			"		W.evtprize_code = '" & FPCode & "' AND W.evt_code = '" & FECode & "' AND W.itemid = '" & FRectItemID & "' AND W.evt_winner = '" & FRectUserID & "' "
			
			'response.write sqlStr
			rsget.open sqlStr ,dbget,1
			
			FResultCount = rsget.RecordCount
			
			set FEvalItem = new CEvaluateSearcherItem
			IF not rsget.eof THEN 
					
					FEvalItem.FItemID 			= rsget("itemid")
					FEvalItem.FItemname 		= db2html(rsget("itemname"))
					FEvalItem.FItemCost			= rsget("sellcash")
					FEvalItem.FMakerName		= db2html(rsget("BrandName"))
					FEvalItem.FImageList100 	= "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listimage")
					FEvalItem.FImageIcon2		= "http://webimage.10x10.co.kr/image/icon2/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("icon2image")
					'FEvalItem.FImageList120 	= "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(rsget("itemid")) + "/" + rsget("listimage120")
					
					FEvalItem.Fidx				= rsget("idx")
					FEvalItem.FTitle			= rsget("title")
					FEvalItem.FUesdContents 	= db2html(rsget("contents"))
					
					FEvalItem.FTotalPoint		= rsget("TotalPoint")
					FEvalItem.FPoint_fun		= rsget("Point_Function")
					FEvalItem.FPoint_dgn		= rsget("Point_Design")
					FEvalItem.FPoint_prc		= rsget("Point_Price")
					FEvalItem.FPoint_stf		= rsget("Point_Satisfy")
					
					FEvalItem.Flinkimg1			= rsget("file1")
					FEvalItem.Flinkimg2			= rsget("file2")
					FEvalItem.Flinkimg3			= rsget("file3")
					FEvalItem.Flinkimg4			= rsget("file4")
					FEvalItem.Flinkimg5			= rsget("file5")
					
					FEvalItem.FImgContents1		= rsget("imgcontents1")
					FEvalItem.FImgContents2		= rsget("imgcontents2")
					FEvalItem.FImgContents3		= rsget("imgcontents3")
					FEvalItem.FImgContents4		= rsget("imgcontents4")
					FEvalItem.FImgContents5		= rsget("imgcontents5")

					FEvalItem.FUseGood			= rsget("UseGood")
					FEvalItem.FUseBad			= rsget("UseBad")
					FEvalItem.FUseETC			= rsget("UseETC")
					FEvalItem.FMyBlog			= rsget("MyBlog")
					
			END IF
			
			rsget.close
	
	End Sub
	
	
	
	


	'// 포토 후기 이미지 중간 폴더명 지정 //
	public function GetImageFolerName(byval i)
		GetImageFolerName = GetImageSubFolderByItemid(FItemList(i).FItemID)
	end function


	public Function HasPreScroll()
		HasPreScroll = StartScrollPage > 1
	end Function

	public Function HasNextScroll()
		HasNextScroll = FTotalPage > StartScrollPage + FScrollCount -1
	end Function

	public Function StartScrollPage()
		StartScrollPage = ((FCurrpage-1)\FScrollCount)*FScrollCount +1
	end Function
End Class

%>

<%
'################################################
'	디자인 핑거스
'	2008.03.18 정윤정 생성
'################################################

	Class CDesignFingers
	public FDFSeq
	public FDFCodeSeq
	public FPCodeSeq
	public FCategory
	public FSort
	public FSearchTxt
	public FUserId
	public FGubun
	
	public FDFType
	public FTitle
	public FContents
	public FPrizeDate
	public FCommentTxt
	
	public FTotCnt
	public FCPage
	public FPSize
	public FPerCnt
	
	public FTopImgURL
	public FEventLeftImg
	public FEventRightImg
	
	public FArrWinner	
	public FArrImgAdd(50,3)
	public FArrImg3dv(10,4)

	public FCategoryPrdList()
	public FResultCount
	public FResultCountW
		
	public FRDFS
	public FRImgURL
	public FRTitle
	
	public FProdName
	public FProdSize
	public FProdColor
	public FProdJe
	public FProdGu
	public FProdSpe
	public FItemList()
	public FDevice
	public FIsMovie
	public FOpenDate
	
	Private Sub Class_Initialize()
		redim preserve FCategoryPrdList(0)		
	End Sub

	Private Sub Class_Terminate()
	End Sub
	
		'//내용 보여주기
	public Function fnGetDFContents			
			Dim strSql, arrImg	
			Dim tmp3dv
			Dim i
				
			IF FDFSeq = "" THEN FDFSeq = 0
				
			'Get Text	
			strSql ="[db_sitemaster].[dbo].sp_Ten_designfingers_GetContents ("&FDFSeq&")"			
			rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
			IF Not (rsget.EOF OR rsget.BOF) THEN
				FDFSeq 		= rsget(0)
				FDFType 	= fnSetFTypeImg(rsget(1))
				FTitle		= db2html(rsget(2))
				FContents	= nl2br(db2html(rsget(3)))
				FPrizeDate	= rsget(4)
				FCommentTxt	= db2html(rsget(5))
				FProdName	= db2html(rsget(9))
				FProdSize	= db2html(rsget(10))
				FProdColor	= db2html(rsget(11))
				FProdJe		= db2html(rsget(12))
				FProdGu		= db2html(rsget(13))
				FProdSpe	= db2html(rsget(14))
				FOpenDate	= rsget(17)
				FIsMovie	= rsget(15)
			END IF
			rsget.close
			
			'Get Image - 3dview, addimg
			strSql = "[db_sitemaster].[dbo].sp_Ten_designfingers_GetImage_Mobile ("&FDFSeq&")"		
			rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
			IF Not (rsget.EOF OR rsget.BOF) THEN
				arrImg = rsget.getRows()
			END IF
			rsget.close				
			
			IF isArray(arrImg) THEN
				For intLoop = 0 To UBound(arrImg,2)
					IF arrImg(1,intLoop) = 2 THEN '//main top 이미지
						FTopImgURL = arrImg(3,intLoop)
					ELSEIF arrImg(1,intLoop) = 24 THEN	'//add image						
						FArrImgAdd(arrImg(2,intLoop),0)  =  arrImg(2,intLoop)	'이미지 ID
						FArrImgAdd(arrImg(2,intLoop),1)  =  arrImg(3,intLoop)	'이미지 url
						FArrImgAdd(arrImg(2,intLoop),2) =  db2html(arrImg(4,intLoop))	'맵
						FArrImgAdd(arrImg(2,intLoop),3) =  arrImg(1,intLoop)	'구분
						
					ELSEIF 	arrImg(1,intLoop) = 7 THEN '// 3dview image
						FArrImg3dv(arrImg(2,intLoop),0) = arrImg(2,intLoop)		'이미지 ID
						FArrImg3dv(arrImg(2,intLoop),1) = arrImg(3,intLoop)		'이미지 url
						tmp3dv = split(arrImg(3,intLoop),"/")
						FArrImg3dv(arrImg(2,intLoop),2) = replace(arrImg(3,intLoop),tmp3dv(uBound(tmp3dv)),"icon/icon_"&tmp3dv(uBound(tmp3dv)))	'아이콘 이미지
						FArrImg3dv(arrImg(2,intLoop),3) = arrImg(6,intLoop)		'이미지 위치명
					ElseIf arrImg(1,intLoop) = 22 THEN '//event left 이미지
						FEventLeftImg = arrImg(3,intLoop)
					ElseIf arrImg(1,intLoop) = 23 THEN '//event right 이미지
						FEventRightImg = arrImg(3,intLoop)
					END IF	
					IF FTopImgURL = "" AND arrImg(1,intLoop) = 2 Then
						FTopImgURL = arrImg(3,intLoop)
					END IF
				Next
			END IF	
			
			'Get Winner
			strSql ="[db_sitemaster].[dbo].sp_Ten_designfingers_GetWinner ("&FDFSeq&")"	
			rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
			IF Not (rsget.EOF OR rsget.BOF) THEN
				FArrWinner = rsget.getRows()
			END IF
			rsget.close
			
			'Get item			
			strSql ="[db_item].[dbo].[sp_Ten_designfingers_GetItem]("&FDFSeq&")"				
			rsget.CursorLocation = adUseClient			
			rsget.Open strSql, dbget, adOpenStatic ,adLockOptimistic, adCmdStoredProc			
			FResultCount = rsget.RecordCount			
			redim preserve FCategoryPrdList(FResultCount)		
			IF Not (rsget.EOF OR rsget.BOF) THEN
				i=0
				do until rsget.eof
			set FCategoryPrdList(i) = new CCategoryPrdItem
				FCategoryPrdList(i).FItemID  		= rsget("itemid")				
				FCategoryPrdList(i).Fitemname    	= db2html(rsget("itemname"))
											
				FCategoryPrdList(i).FSellcash     	= rsget("sellcash")
				FCategoryPrdList(i).FOrgPrice   	= rsget("orgprice")
				FCategoryPrdList(i).FMakerID 		= rsget("makerid")
				FCategoryPrdList(i).FBrandName		= rsget("BrandName")
				
				FCategoryPrdList(i).FSellYn       	= rsget("sellyn")
				FCategoryPrdList(i).FSaleYn    		= rsget("sailyn")		
							
				FCategoryPrdList(i).FLimitYn      	= rsget("limityn")
				FCategoryPrdList(i).FLimitNo      	= rsget("limitno")
				FCategoryPrdList(i).FLimitSold    	= rsget("limitsold")	
				
				FCategoryPrdList(i).FDeliverytype 	= rsget("deliverytype")				
				FCategoryPrdList(i).FReipgodate		= rsget("reipgodate")
				
				FCategoryPrdList(i).FItemCouponValue= rsget("ItemCouponValue")
				FCategoryPrdList(i).Fitemcouponyn 	= rsget("itemcouponyn")
				FCategoryPrdList(i).Fitemcoupontype	= rsget("itemcoupontype")
			
				FCategoryPrdList(i).Fevalcnt 		= rsget("evalcnt")				
				FCategoryPrdList(i).FRegdate 		= rsget("regdate")						
				
				FCategoryPrdList(i).FImageSmall 	= "http://webimage.10x10.co.kr/image/small/" + GetImageSubFolderByItemid(FCategoryPrdList(i).FItemID) + "/" + rsget("smallimage")
				FCategoryPrdList(i).FImageList 		= "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(FCategoryPrdList(i).FItemID) + "/" + rsget("listimage")				
				FCategoryPrdList(i).FImageBasic		= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FCategoryPrdList(i).FItemID) + "/" + rsget("basicimage")
				rsget.movenext
				i=i+1
				loop
			End IF
			rsget.close
			
	End Function
			
		'//set type image URL 
	private Function fnSetFTypeImg(ByVal iDFType)		
			fnSetFTypeImg = "http://fiximage.10x10.co.kr/web2008/designfingers/title01_"&iDFType&".gif"
	End Function
		
		
		'// 최근
	public Function fnGetRecent
		Dim strSql
			strSql = "[db_sitemaster].[dbo].sp_Ten_designfingers_GetRecent"
				rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
				IF Not (rsget.EOF OR rsget.BOF) THEN
					FRDFS 	 = rsget(0)
					FRTitle	 = db2html(rsget(1))
					FRImgURL = rsget(2)					
				END IF
				rsget.close
	End Function
		
		'// 리스트
	public Function fnGetList
			Dim strSqlCnt, strSql, vTemp
			IF FRDFS ="" THEN FRDFS = 0
				
			IF application("Svr_Info") = "Dev" THEN
				vTemp = ""
			Else
				vTemp = "_Mobile"
			End If
				
			strSqlCnt = "[db_sitemaster].[dbo].[sp_Ten_designfingers" & vTemp & "_GetListCnt] ("&FRDFS&","&FDFCodeSeq&","&FCategory&",'"&FSort&"','"&FSearchTxt&"') "			
			rsget.Open strSqlCnt, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
			IF Not rsget.EOF THEN
				FTotCnt = rsget(0)
			END IF
			rsget.close

			IF FTotCnt >0 THEN
				strSql = "[db_sitemaster].[dbo].sp_Ten_designfingers" & vTemp & "_GetList("&FRDFS&","&FDFCodeSeq&","&FCategory&",'"&FSort&"','"&FSearchTxt&"',"&FCPage&","&FPSize&")"
				rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
				IF Not (rsget.EOF OR rsget.BOF) THEN
					fnGetList =rsget.getRows() 
				END IF
				rsget.close
			END IF	
	End Function
		
	public sub sbGetSmallListDisplay
		Dim arrList,intLoop	
		Dim iStartPage, iEndPage, iTotalPage, ix
			
	
		IF FCPage = "" THEN	FCPage = 1	   		
		FPerCnt = 5		'보여지는 페이지 간격	
	 	'FPSize = 12	'페이지 사이즈 

	 	FTotCnt = FTotCnt '배너리스트 총 갯수
	 	
		iTotalPage 	=  Int(FTotCnt/FPSize)	'전체 페이지 수
		IF (FTotCnt MOD FPSize) > 0 THEN	iTotalPage = iTotalPage + 1	
						

		iStartPage = (Int((FCPage-1)/FPerCnt)*FPerCnt) + 1	
		
		If (FCPage mod FPerCnt) = 0 Then																
			iEndPage = FCPage
		Else								
			iEndPage = iStartPage + (FPerCnt-1)
		End If				
%>            

		<% if FTotCnt > 0 then %>
		<div id="paging">
			<% if Cint(iStartPage-1 )> 0 then %>
				<a href="javascript:jsGoListPage(<%= iStartPage-1 %>)" title="_webapp" class="numArrow"><img src="http://fiximage.10x10.co.kr/m/common/paging_prev.png"></a>
			<%else%>
				<a href="javascript:jsGoListPage(1)" title="_webapp" class="numArrow"><img src="http://fiximage.10x10.co.kr/m/common/paging_prev.png"></a>
			<%end if%>
			<% for ix = iStartPage  to iEndPage %>
				<% if (ix > iTotalPage) then Exit for %>
				<a href="javascript:jsGoListPage(<%= ix %>)" class="num<% if Cint(ix) = Cint(FCPage) then %>On<% end if %>Box" title="_webapp"><%=ix%></a> 

			<% next %>
			<% if Cint(iTotalPage) > Cint(iEndPage) then %>
				<a href="javascript:jsGoListPage(<%= ix%>)" title="_webapp" class="numArrow"><img src="http://fiximage.10x10.co.kr/m/common/paging_next.png" /></a>
			<%else%>
				<a href="javascript:jsGoListPage(<%= iTotalPage %>)" title="_webapp" class="numArrow"><img src="http://fiximage.10x10.co.kr/m/common/paging_next.png" /></a>
			<% end if %>
		</div>
		<% end if %>

<%            
		End sub
		
		
	public sub sbGetSmallListDisplayAjax
		Dim arrList,intLoop	
		Dim iStartPage, iEndPage, iTotalPage, ix
			
	
		IF FCPage = "" THEN	FCPage = 1	   		
		FPerCnt = 5		'보여지는 페이지 간격	
	 	'FPSize = 12	'페이지 사이즈 

	 	FTotCnt = FTotCnt '배너리스트 총 갯수
	 	
		iTotalPage 	=  Int(FTotCnt/FPSize)	'전체 페이지 수
		IF (FTotCnt MOD FPSize) > 0 THEN	iTotalPage = iTotalPage + 1	
						

		iStartPage = (Int((FCPage-1)/FPerCnt)*FPerCnt) + 1	
		
		If (FCPage mod FPerCnt) = 0 Then																
			iEndPage = FCPage
		Else								
			iEndPage = iStartPage + (FPerCnt-1)
		End If				
		
		IF iTotalPage < 1 THEN
      		If FGubun = "F" Then
      			Response.Write "<span class='eng11pxblack'>1</span>"
      		Else
      			Response.Write "<table><tr><td style='padding:5 0 5 0'>[등록하신 관심핑거스가 없습니다.]</td></tr></table>"
      		End IF
      	Else
%>            
            
            <table  border="0" cellspacing="4">
            <tr>
                <td width="11">
                  	<a href="javascript:CtgBestRefresh(1,'<%=FGubun%>','x')" onfocus="this.blur();"><img src="http://fiximage.10x10.co.kr/web2008/designfingers/btn_pageprev02.gif" width="11" height="11" border="0" align="absmiddle"></td>
				<td  width="11">
                  	<% if Cint(iStartPage-1 )> 0 then %>
                  		<a href="javascript:CtgBestRefresh(<%= iStartPage-1 %>,'<%=FGubun%>','x')" onfocus="this.blur();"><img src="http://fiximage.10x10.co.kr/web2008/designfingers/btn_pageprev01.gif" width="11" height="11" border="0" align="absmiddle"></a>
                   <%else%>	
                  	   <img src="http://fiximage.10x10.co.kr/web2008/designfingers/btn_pageprev01.gif" width="11" height="11" border="0" align="absmiddle">
                   <% end if %>
                </td>
                <td class="pagenum01" align="center">
                  <% IF iTotalPage < 1 THEN%><span class="eng11pxblack">1</span>                  	
                  <% ELSE
						for ix = iStartPage  to iEndPage
							if (ix > iTotalPage) then Exit for
							if Cint(ix) = Cint(FCPage) then
				   %><a href="javascript:CtgBestRefresh(<%= ix %>,'<%=FGubun%>','x')" onfocus="this.blur();"><span class="eng11pxblack"><%=ix%></span></a>
				  <%		else %>				   
				    <a href="javascript:CtgBestRefresh(<%= ix %>,'<%=FGubun%>','x')" onfocus="this.blur();"><%=ix%></a>
				  <%
							end if
						next
					END IF	
				  %>   
				</td>
                <td  width="11">
                	<% if Cint(iTotalPage) > Cint(iEndPage)   then %>
                  		<a href="javascript:CtgBestRefresh(<%= ix%>,'<%=FGubun%>','x')" onfocus="this.blur();"><img src="http://fiximage.10x10.co.kr/web2008/designfingers/btn_pagenext01.gif" width="11" height="11" border="0" align="absmiddle"></a>
                  	<%else %>
                  	  <img src="http://fiximage.10x10.co.kr/web2008/designfingers/btn_pagenext01.gif" width="11" height="11" border="0" align="absmiddle">
                  	<% end if %>
				</td>
                <td><a href="javascript:CtgBestRefresh(<%= iTotalPage %>,'<%=FGubun%>','x')" onfocus="this.blur();"><img src="http://fiximage.10x10.co.kr/web2008/designfingers/btn_pagenext02.gif" width="11" height="11" border="0" align="absmiddle"></a></td>
			</tr>
            </table>

<%
		End If
		End sub
		
		
		'// 카테고리 코드값 가져오기
		public Function fnGetCode
			Dim strSql, strSearch
			strSql = " [db_sitemaster].[dbo].sp_Ten_designfingers_CodeList (" & FPCodeSeq & ") "
			rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
			IF Not (rsget.EOF OR rsget.BOF) THEN
				fnGetCode =rsget.getRows() 
			END IF
			rsget.Close	
		End Function


		'// 핑거위시 처리하기
		public Function fnFingerWishProc
			Dim strSql, i
			For i = LBound(Split(FPCodeSeq,",")) To UBound(Split(FPCodeSeq,","))
				strSql = " [db_sitemaster].[dbo].sp_Ten_designfingers_wishProc ('" & FGubun & "'," & Split(FPCodeSeq,",")(i) & ",'" & FUserId & "','" & FDevice & "') "
				dbget.Execute strSql
			Next
		End Function
		
		
		'// 핑거위시리스트
		public Function fnGetWishList
				Dim strSqlCnt, strSql
				IF FRDFS ="" THEN FRDFS = 0
					
				strSqlCnt = "[db_sitemaster].[dbo].[sp_Ten_designfingers_GetWishListCnt] ('"&FUserID&"',"&FRDFS&","&FDFCodeSeq&","&FCategory&",'"&FSort&"','"&FSearchTxt&"') "			
				rsget.Open strSqlCnt, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
				IF Not rsget.EOF THEN
					FTotCnt = rsget(0)
				END IF
				rsget.close
	
				IF FTotCnt > 0 THEN
					strSql = "[db_sitemaster].[dbo].sp_Ten_designfingers_GetWishList ('"&FUserID&"',"&FRDFS&","&FDFCodeSeq&","&FCategory&",'"&FSort&"','"&FSearchTxt&"',"&FCPage&","&FPSize&")"	
					rsget.CursorLocation = adUseClient
					rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
					IF Not (rsget.EOF OR rsget.BOF) THEN
						fnGetWishList = rsget.getRows()
						FResultCountW = rsget.RecordCount
					Else
						FResultCountW = 1
					END IF
					rsget.close
				END IF	
		End Function
		

		'// 최근 코맨트 4개 가져오기
		public Function fnGetRecentComment
			Dim strSql, strSearch
			strSql = " [db_sitemaster].[dbo].sp_Ten_designfingers_RecentComment "
			rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
			IF Not (rsget.EOF OR rsget.BOF) THEN
				fnGetRecentComment =rsget.getRows() 
			END IF
			rsget.Close	
		End Function
		
		
		'// 최근 코맨트 4개 가져오기
		public Function fnGetMainOne
			Dim strSql, strSearch
			strSql = " [db_sitemaster].[dbo].sp_Ten_designfingers_Main_One "
			rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
			IF Not (rsget.EOF OR rsget.BOF) THEN
				fnGetMainOne =rsget.getRows() 
			END IF
			rsget.Close	
		End Function
		

	End Class
	
	
	Function ImageOn(gb1, gb2)
		If gb1 = gb2 Then
			ImageOn = "_on"
		Else
			ImageOn = ""
		End If
	End Function
	

%>

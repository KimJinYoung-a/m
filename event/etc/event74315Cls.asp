<%
CLASS CatePrdCls
	Public FItemList()
	Public FResultCount

	Private Sub Class_Initialize()
	End Sub

	Private Sub Class_Terminate()
	End Sub

	Public Sub get74315RollingItemList(ByVal dispsunseo)
		Dim strSQL, i
		strSQL = ""
		strSQL = strSQL & " SELECT TOP 5 "
		strSQL = strSQL & " i.itemid,i.ItemName, "
		strSQL = strSQL & " (Case When isNull(i.frontMakerid,'')='' then i.makerid else i.frontMakerid end) as Makerid, "
		strSQL = strSQL & " i.isUsing,i.SellYn,i.SellCash,i.OrgPrice,i.Mileage, "
		strSQL = strSQL & " i.limitYn,i.sailyn,i.isExtUsing, "
		strSQL = strSQL & " i.LimitNo,i.LimitSold, "
		strSQL = strSQL & " i.ItemCouponYn,i.CurrItemCouponIdx,i.ItemCouponType,i.ItemCouponValue, "
		strSQL = strSQL & " i.BasicImage,i.BasicImage600,i.BasicImage1000,i.smallimage,i.listImage,i.MainImage,i.MainImage2,i.MainImage3, "
		strSQL = strSQL & " i.MaskImage,i.MaskImage1000,i.ListImage120,i.icon2image "
		strSQL = strSQL & " ,i.tentenimage, i.tentenimage50, i.tentenimage200, i.tentenimage400, i.tentenimage600, i.tentenimage1000 "
		strSQL = strSQL & " ,e.isOnlyYn, e.sortNo "
		strSQL = strSQL & " FROM [db_item].[dbo].tbl_item i "
		strSQL = strSQL & " JOIN db_temp.dbo.tbl_event_Mobile_74315 as e on i.itemid = e.itemid "
		strSQL = strSQL & " WHERE e.dispsunseo = '" & CStr(dispsunseo) & "'" 
		strSQL = strSQL & " ORDER BY e.sortNo ASC "
		rsget.Open strSQL, dbget, 1
		FResultCount = rsget.RecordCount
		redim preserve FItemList(FResultCount)
		If  not rsget.EOF Then
			i = 0
			Do until rsget.eof
				Set FItemList(i) = new CCategoryPrdItem
				FItemList(i).FItemid    	= rsget("Itemid")  '상품 코드
				FItemList(i).FMakerid 		= rsget("makerid") '업체 아이디(표시 브랜드)
				FItemList(i).Fitemname 			= db2html(rsget("itemname")) '상품명
				FItemList(i).FOrgprice			= rsget("orgprice")		'원가
				FItemList(i).FMileage				= rsget("mileage")	'마일리지
				FItemList(i).FSellCash 			= rsget("sellcash")		'판매가
				FItemList(i).FLimitNo      = rsget("limitno")			'한정수량
				FItemList(i).FLimitSold      = rsget("LimitSold")		'한정판매수량
				FItemList(i).FCurrItemCouponIdx 		= rsget("curritemcouponidx")
				FItemList(i).FisUsing				= rsget("isUsing")
				FItemList(i).FSellYn					= rsget("sellyn")
				FItemList(i).FSaleYn					= rsget("sailyn")
				FItemList(i).FLimitYn 				= rsget("limityn")
				FItemList(i).FItemCouponYN		= rsget("itemcouponyn")
				FItemList(i).FItemCouponType 	=	rsget("itemcoupontype")
				FItemList(i).FItemCouponValue	= rsget("itemcouponvalue")
				FItemList(i).FImageMain 		= "http://webimage.10x10.co.kr/image/main/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsget("mainimage")
				FItemList(i).FImageMain2		= "http://webimage.10x10.co.kr/image/main2/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsget("mainimage2")
				FItemList(i).FImageMain3		= "http://webimage.10x10.co.kr/image/main3/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsget("mainimage3")
				FItemList(i).FImageList 		= "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsget("listimage")
				FItemList(i).FImageList120 	= "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsget("listimage120")
				FItemList(i).FImageSmall 		= "http://webimage.10x10.co.kr/image/small/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsget("smallimage")
				If isNull(rsget("basicimage600")) OR rsget("basicimage600") = "" Then
					If isNull(rsget("basicimage")) OR rsget("basicimage") = "" Then
						FItemList(i).FImageBasic 	= ""						
					else
						FItemList(i).FImageBasic 	= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsget("basicimage")
					end if
				Else
					FItemList(i).FImageBasic 		= "http://webimage.10x10.co.kr/image/basic600/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsget("basicimage600")
				End If

				If Not(isNull(rsget("maskimage")) OR rsget("maskimage") = "") Then
					FItemList(i).FImageMask 	= "http://webimage.10x10.co.kr/image/mask/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsget("maskimage")
				end if

				FItemList(i).FImageBasicIcon 	= "http://webimage.10x10.co.kr/image/basicicon/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/C" + rsget("basicimage")
				FItemList(i).FImageMaskIcon 	= "http://webimage.10x10.co.kr/image/maskicon/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/C" + rsget("maskimage")
				'FItemList(i).FImageicon2 		= "http://webimage.10x10.co.kr/image/icon2/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsget("icon2image")
				If Not(isNull(rsget("tentenimage")) Or rsget("tentenimage") = "") Then '텐텐 기본이미지
					FItemList(i).Ftentenimage	= "http://webimage.10x10.co.kr/image/tenten/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsget("tentenimage")
					FItemList(i).Ftentenimage50	= "http://webimage.10x10.co.kr/image/tenten50/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsget("tentenimage50")
					FItemList(i).Ftentenimage200	= "http://webimage.10x10.co.kr/image/tenten200/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsget("tentenimage200")
					FItemList(i).Ftentenimage400	= "http://webimage.10x10.co.kr/image/tenten400/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsget("tentenimage400")
					FItemList(i).Ftentenimage600	= "http://webimage.10x10.co.kr/image/tenten600/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsget("tentenimage600")
					FItemList(i).Ftentenimage1000	= "http://webimage.10x10.co.kr/image/tenten1000/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsget("tentenimage1000")
				End If
				FItemList(i).FtenOnlyYn				= rsget("isOnlyYn")
				FItemList(i).ForderMinNum			= rsget("sortNo")
				i = i + 1
				rsget.moveNext
			Loop
		End If
		rsget.close
	End Sub

	Public Sub get74315UnderItemList(ByVal underGubun)
		Dim strSQL, i
		strSQL = ""
		strSQL = strSQL & " SELECT TOP 23 "
		strSQL = strSQL & " i.itemid,i.ItemName, "
		strSQL = strSQL & " (Case When isNull(i.frontMakerid,'')='' then i.makerid else i.frontMakerid end) as Makerid, "
		strSQL = strSQL & " i.isUsing,i.SellYn,i.SellCash,i.OrgPrice,i.Mileage, "
		strSQL = strSQL & " i.limitYn,i.sailyn,i.isExtUsing, "
		strSQL = strSQL & " i.LimitNo,i.LimitSold, "
		strSQL = strSQL & " i.ItemCouponYn,i.CurrItemCouponIdx,i.ItemCouponType,i.ItemCouponValue, "
		strSQL = strSQL & " i.BasicImage,i.BasicImage600,i.BasicImage1000,i.smallimage,i.listImage,i.MainImage,i.MainImage2,i.MainImage3, "
		strSQL = strSQL & " i.MaskImage,i.MaskImage1000,i.ListImage120,i.icon2image "
		strSQL = strSQL & " ,i.tentenimage, i.tentenimage50, i.tentenimage200, i.tentenimage400, i.tentenimage600, i.tentenimage1000 "
		strSQL = strSQL & " ,e.isOnlyYn, e.sortNo "
		strSQL = strSQL & " FROM [db_item].[dbo].tbl_item i "
		strSQL = strSQL & " JOIN db_temp.dbo.tbl_event_Mobile_74315 as e on i.itemid = e.itemid "
		strSQL = strSQL & " WHERE e.underGubun = '" & CStr(underGubun) & "'" 
		strSQL = strSQL & " ORDER BY e.sortNo ASC "
		rsget.Open strSQL, dbget, 1
		FResultCount = rsget.RecordCount
		redim preserve FItemList(FResultCount)
		If  not rsget.EOF Then
			i = 0
			Do until rsget.eof
				Set FItemList(i) = new CCategoryPrdItem
				FItemList(i).FItemid    	= rsget("Itemid")  '상품 코드
				FItemList(i).FMakerid 		= rsget("makerid") '업체 아이디(표시 브랜드)
				FItemList(i).Fitemname 			= db2html(rsget("itemname")) '상품명
				FItemList(i).FOrgprice			= rsget("orgprice")		'원가
				FItemList(i).FMileage				= rsget("mileage")	'마일리지
				FItemList(i).FSellCash 			= rsget("sellcash")		'판매가
				FItemList(i).FLimitNo      = rsget("limitno")			'한정수량
				FItemList(i).FLimitSold      = rsget("LimitSold")		'한정판매수량
				FItemList(i).FCurrItemCouponIdx 		= rsget("curritemcouponidx")
				FItemList(i).FisUsing				= rsget("isUsing")
				FItemList(i).FSellYn					= rsget("sellyn")
				FItemList(i).FSaleYn					= rsget("sailyn")
				FItemList(i).FLimitYn 				= rsget("limityn")
				FItemList(i).FItemCouponYN		= rsget("itemcouponyn")
				FItemList(i).FItemCouponType 	=	rsget("itemcoupontype")
				FItemList(i).FItemCouponValue	= rsget("itemcouponvalue")
				FItemList(i).FImageMain 		= "http://webimage.10x10.co.kr/image/main/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsget("mainimage")
				FItemList(i).FImageMain2		= "http://webimage.10x10.co.kr/image/main2/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsget("mainimage2")
				FItemList(i).FImageMain3		= "http://webimage.10x10.co.kr/image/main3/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsget("mainimage3")
				FItemList(i).FImageList 		= "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsget("listimage")
				FItemList(i).FImageList120 	= "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsget("listimage120")
				FItemList(i).FImageSmall 		= "http://webimage.10x10.co.kr/image/small/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsget("smallimage")
				If isNull(rsget("basicimage600")) OR rsget("basicimage600") = "" Then
					If isNull(rsget("basicimage")) OR rsget("basicimage") = "" Then
						FItemList(i).FImageBasic 	= ""						
					else
						FItemList(i).FImageBasic 	= "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsget("basicimage")
					end if
				Else
					FItemList(i).FImageBasic 		= "http://webimage.10x10.co.kr/image/basic600/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsget("basicimage600")
				End If

				If Not(isNull(rsget("maskimage")) OR rsget("maskimage") = "") Then
					FItemList(i).FImageMask 	= "http://webimage.10x10.co.kr/image/mask/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsget("maskimage")
				end if

				FItemList(i).FImageBasicIcon 	= "http://webimage.10x10.co.kr/image/basicicon/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/C" + rsget("basicimage")
				FItemList(i).FImageMaskIcon 	= "http://webimage.10x10.co.kr/image/maskicon/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/C" + rsget("maskimage")
				'FItemList(i).FImageicon2 		= "http://webimage.10x10.co.kr/image/icon2/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsget("icon2image")
				If Not(isNull(rsget("tentenimage")) Or rsget("tentenimage") = "") Then '텐텐 기본이미지
					FItemList(i).Ftentenimage	= "http://webimage.10x10.co.kr/image/tenten/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsget("tentenimage")
					FItemList(i).Ftentenimage50	= "http://webimage.10x10.co.kr/image/tenten50/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsget("tentenimage50")
					FItemList(i).Ftentenimage200	= "http://webimage.10x10.co.kr/image/tenten200/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsget("tentenimage200")
					FItemList(i).Ftentenimage400	= "http://webimage.10x10.co.kr/image/tenten400/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsget("tentenimage400")
					FItemList(i).Ftentenimage600	= "http://webimage.10x10.co.kr/image/tenten600/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsget("tentenimage600")
					FItemList(i).Ftentenimage1000	= "http://webimage.10x10.co.kr/image/tenten1000/" + GetImageSubFolderByItemid(FItemList(i).FItemid) + "/" + rsget("tentenimage1000")
				End If
				FItemList(i).FtenOnlyYn				= rsget("isOnlyYn")
				FItemList(i).ForderMinNum			= rsget("sortNo")
				i = i + 1
				rsget.moveNext
			Loop
		End If
		rsget.close
	End Sub
End Class
%>
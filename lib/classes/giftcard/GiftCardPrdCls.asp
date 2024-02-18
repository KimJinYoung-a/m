<%

CLASS GiftCardPrdCls

	Private Sub Class_Initialize()
		'FCurrPage =1
		'FPageSize = 10
		'FTotalPage = 1
		'FResultCount = 0
		'FScrollCount = 10
		'FTotalCount =0
	End Sub

	Private Sub Class_Terminate()
	End Sub

	dim Prd
	dim FADD
	dim FResultCount
	dim itEvtImg

	Public Sub GetItemData(ByVal iid)

		dim strSQL

		strSQL = "execute [db_item].[dbo].[sp_Ten_GiftCardPrd] @vCardItemid ='" & CStr(iid) & "'"

		rsget.CursorLocation = adUseClient
		rsget.CursorType=adOpenStatic
		rsget.Locktype=adLockReadOnly
		rsget.Open strSQL, dbget

		set Prd = new CGiftCardPrdItem

		if  not rsget.EOF  then

			FResultCount = 1
			rsget.Movefirst

				Prd.FCardItemID    	= rsget("Carditemid")  '상품 코드
				Prd.FCardItemName 	= db2html(rsget("Carditemname")) '상품명
				Prd.FCardInfo		= db2html(rsget("Cardinfo"))  '상품 간략 설명
				Prd.FCardDesc 		= db2html(rsget("Carddesc"))	'상품 상세 설명
				Prd.FCardSellYn		= rsget("Cardsellyn")	'판매여부
				Prd.FRegDate		= rsget("Regdate")	'등록일
				Prd.FImageBasic 	= webImgUrl & "/giftcard/basic/" + GetImageSubFolderByItemid(Prd.FCardItemID) + "/" + rsget("basicimage")
				Prd.FImageBasic600 	= webImgUrl & "/giftcard/basic600/" + GetImageSubFolderByItemid(Prd.FCardItemID) + "/" + rsget("Basicimage600")
				Prd.FImageList 		= webImgUrl & "/giftcard/list/" + GetImageSubFolderByItemid(Prd.FCardItemID) + "/" + rsget("listimage")
				Prd.FImageList120 	= webImgUrl & "/giftcard/list120/" + GetImageSubFolderByItemid(Prd.FCardItemID) + "/" + rsget("listimage120")
				Prd.FImageSmall 	= webImgUrl & "/giftcard0/small/" + GetImageSubFolderByItemid(Prd.FCardItemID) + "/" + rsget("smallimage")

		else
			FResultCount = 0
		end if

		rsget.close

	End Sub

End Class
%>

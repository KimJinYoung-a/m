<%
	'// 기프트 상품 연결정보(카운트) 업데이트
	Sub updateGiftItemInfo(vDiv,vIdx)
		dim sqlStr
		if vDiv="" or vIdx="" then Exit Sub

		Select Case vDiv
			Case "talk"
				'// 기프트 톡
				sqlStr = "Update f "
				sqlStr = sqlStr & "set f.talkCount=c.cnt "
				sqlStr = sqlStr & "From db_board.dbo.tbl_gift_itemInfo as f "
				sqlStr = sqlStr & "	join ( "
				sqlStr = sqlStr & "		Select d.itemid, sum(Case When m.useyn='y' Then 1 Else 0 end) as cnt "
				sqlStr = sqlStr & "		from db_board.dbo.tbl_shopping_talk as m "
				sqlStr = sqlStr & "			Join db_board.dbo.tbl_shopping_talk_item as d "
				sqlStr = sqlStr & "				on m.talk_idx=d.talk_idx "
				sqlStr = sqlStr & "		where d.itemid in ( "
				sqlStr = sqlStr & "				Select itemid "
				sqlStr = sqlStr & "				from db_board.dbo.tbl_shopping_talk_item "
				sqlStr = sqlStr & "				where talk_idx in (" & vIdx & ")"
				sqlStr = sqlStr & "			) "
				sqlStr = sqlStr & "		group by d.itemid "
				sqlStr = sqlStr & "	) as c "
				sqlStr = sqlStr & "		on f.itemid=c.itemid "
				dbget.Execute(sqlStr)

				sqlStr = "insert into db_board.dbo.tbl_gift_itemInfo (itemid,talkCount) "
				sqlStr = sqlStr & "Select i.itemid, c.cnt "
				sqlStr = sqlStr & "from db_item.dbo.tbl_item as i "
				sqlStr = sqlStr & "	join ( "
				sqlStr = sqlStr & "		Select d.itemid, count(d.idx) as cnt "
				sqlStr = sqlStr & "		from db_board.dbo.tbl_shopping_talk as m "
				sqlStr = sqlStr & "			Join db_board.dbo.tbl_shopping_talk_item as d "
				sqlStr = sqlStr & "				on m.talk_idx=d.talk_idx "
				sqlStr = sqlStr & "		where m.useyn='y' and m.talk_idx in (" & vIdx & ")"
				sqlStr = sqlStr & "		group by d.itemid "
				sqlStr = sqlStr & "	) as c "
				sqlStr = sqlStr & "		on i.itemid=c.itemid "
				sqlStr = sqlStr & "where i.itemid not in ( "
				sqlStr = sqlStr & "		Select itemid "
				sqlStr = sqlStr & "		from db_board.dbo.tbl_gift_itemInfo "
				sqlStr = sqlStr & "	) "
				dbget.Execute(sqlStr)

			Case "day"
				'// 기프트 데이
				sqlStr = "Update f "
				sqlStr = sqlStr & "set f.dayCount=c.cnt "
				sqlStr = sqlStr & "From db_board.dbo.tbl_gift_itemInfo as f "
				sqlStr = sqlStr & "	join ( "
				sqlStr = sqlStr & "		Select d.itemid, sum(Case When m.isUsing='Y' and d.isUsing='Y' Then 1 Else 0 end) as cnt "
				sqlStr = sqlStr & "		from db_board.dbo.tbl_giftDay_detail as m "
				sqlStr = sqlStr & "			Join db_board.dbo.tbl_giftDay_detail_item as d "
				sqlStr = sqlStr & "				on m.detailIdx=d.detailIdx "
				sqlStr = sqlStr & "		where d.itemid in ( "
				sqlStr = sqlStr & "				Select itemid "
				sqlStr = sqlStr & "				from db_board.dbo.tbl_giftDay_detail_item "
				sqlStr = sqlStr & "				where detailIdx in (" & vIdx & ")"
				sqlStr = sqlStr & "			) "
				sqlStr = sqlStr & "		group by d.itemid "
				sqlStr = sqlStr & "	) as c "
				sqlStr = sqlStr & "		on f.itemid=c.itemid "
				dbget.Execute(sqlStr)

				sqlStr = "insert into db_board.dbo.tbl_gift_itemInfo (itemid,dayCount) "
				sqlStr = sqlStr & "Select i.itemid, c.cnt "
				sqlStr = sqlStr & "from db_item.dbo.tbl_item as i "
				sqlStr = sqlStr & "	join ( "
				sqlStr = sqlStr & "		Select d.itemid, count(d.detailitemidx) as cnt "
				sqlStr = sqlStr & "		from db_board.dbo.tbl_giftDay_detail as m "
				sqlStr = sqlStr & "			Join db_board.dbo.tbl_giftDay_detail_item as d "
				sqlStr = sqlStr & "				on m.detailIdx=d.detailIdx and d.isUsing='Y' "
				sqlStr = sqlStr & "		where m.isUsing='Y' and m.detailIdx in (" & vIdx & ")"
				sqlStr = sqlStr & "		group by d.itemid "
				sqlStr = sqlStr & "	) as c "
				sqlStr = sqlStr & "		on i.itemid=c.itemid "
				sqlStr = sqlStr & "where i.itemid not in ( "
				sqlStr = sqlStr & "		Select itemid "
				sqlStr = sqlStr & "		from db_board.dbo.tbl_gift_itemInfo "
				sqlStr = sqlStr & "	) "
				dbget.Execute(sqlStr)

			Case "shop"
				'// 기프트 샾
				sqlStr = "Update f "
				sqlStr = sqlStr & "set f.themeCount=c.cnt "
				sqlStr = sqlStr & "From db_board.dbo.tbl_gift_itemInfo as f "
				sqlStr = sqlStr & "	join ( "
				sqlStr = sqlStr & "		Select d.itemid, sum(Case When m.isOpen='Y' and m.isUsing='Y' Then 1 Else 0 end) as cnt "
				sqlStr = sqlStr & "		from db_board.dbo.tbl_giftShop_theme as m "
				sqlStr = sqlStr & "			join db_board.dbo.tbl_giftShop_theme_item as d "
				sqlStr = sqlStr & "				on m.themeIdx=d.themeIdx "
				sqlStr = sqlStr & "		where d.itemid in ( "
				sqlStr = sqlStr & "				Select itemid "
				sqlStr = sqlStr & "				from db_board.dbo.tbl_giftShop_theme_item "
				sqlStr = sqlStr & "				where themeIdx in (" & vIdx & ")"
				sqlStr = sqlStr & "			) "
				sqlStr = sqlStr & "		group by d.itemid "
				sqlStr = sqlStr & "	) as c "
				sqlStr = sqlStr & "		on f.itemid=c.itemid "
				dbget.Execute(sqlStr)

				sqlStr = "insert into db_board.dbo.tbl_gift_itemInfo (itemid,themeCount) "
				sqlStr = sqlStr & "Select i.itemid, c.cnt "
				sqlStr = sqlStr & "from db_item.dbo.tbl_item as i "
				sqlStr = sqlStr & "	join ( "
				sqlStr = sqlStr & "		Select d.itemid, count(d.themeIdx) as cnt "
				sqlStr = sqlStr & "		from db_board.dbo.tbl_giftShop_theme as m "
				sqlStr = sqlStr & "			join db_board.dbo.tbl_giftShop_theme_item as d "
				sqlStr = sqlStr & "				on m.themeIdx=d.themeIdx "
				sqlStr = sqlStr & "		where m.isOpen='Y' and m.isUsing='Y' "
				sqlStr = sqlStr & "			and m.themeIdx in (" & vIdx & ")"
				sqlStr = sqlStr & "		group by d.itemid "
				sqlStr = sqlStr & "	) as c "
				sqlStr = sqlStr & "		on i.itemid=c.itemid "
				sqlStr = sqlStr & "where i.itemid not in ( "
				sqlStr = sqlStr & "		Select itemid "
				sqlStr = sqlStr & "		from db_board.dbo.tbl_gift_itemInfo "
				sqlStr = sqlStr & "	) "
				dbget.Execute(sqlStr)
		End Select
	End Sub
%>
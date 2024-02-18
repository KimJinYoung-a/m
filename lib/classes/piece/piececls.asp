<%
'####################################################
' Description :  피스 클래스(Front)
' History : 2017.09.14 원승현 생성
'####################################################

'// PIECE 관련 클래스
Class Cpiece
	Public Fidx	'// 피스 리스트 idx값 또는 nickname 테이블의 idx값
	Public Ffidx '// 피스 리스트 순서값(제일먼저 정렬기준이 되어야함)
	Public Fgubun '// 피스 구분값(1-조각, 2-파이, 3-스페셜피스(베스트조각), 4-이벤트배너, 5-회원조각)
	Public Fbannergubun '// 배너 구분값(1-텍스트, 2-이미지)
	Public Fnoticeyn '// 피스 오프닝(공지) 해당 오프닝은 전체 반드시 한개만 존재함.
	Public Flistimg '// 피스 리스트 이미지
	Public Flisttext '// 피스 내용
	Public Fshorttext '// 여는말??
	Public Flisttitle '// 피스 제목
	Public Fadminid '// 등록자 scm 어드민 아이디(해당 어드민 아이디를 기준으로 nickname을 불러온다.)
	Public Fusertype '// 1-관리자, 2-유저(기본값은 1이며 보통 유저가 등록한 값은 2로 등록된다.)
	Public Fetclink '// 기타링크??
	Public Fsnsbtncnt '// 공유버튼 클릭 카운트
	Public Fitemid '// 해당 피스에 등록된 상품아이디값(배열형태로 들어감)
	Public Fpieceidx '// 파이 연관조각
	Public Fisusing '// 사용여부 기본값은 N
	Public Fstartdate '// 해당 피스 시작일
	Public Fenddate '// 해당 피스 종료일
	Public Fregdate '// 해당 피스 등록일
	Public Flastupdate '// 해당 피스 마지막 수정일(등록시엔 regdate랑 동일값 들어감.)
	Public FDeleteYn	'// 해당 피스 삭제여부(Y-삭제, N-삭제아님)
	Public FTagText		'// 태그입력값
	Public FRItemid		'// 연관상품 상품아이디
	Public FRitemname '// 연관상품 상품명
	Public FRisusing	'// 해당상품 사용여부
	Public FRlimitno	'// 해당상품 한정갯수
	Public FRlimitsold	'// 해당상품 한정판매갯수
	Public FRmainimage	'// 메인이미지(잘안씀)
	Public FRlistimage	'// 100x100이미지
	Public FRlistimage120	'// 120x120이미지
	Public FRbasicimage	'// 400x400이미지
	Public FRicon1image	'// 200x200이미지
	Public FRicon2image	'// 150x150이미지
	Public FRsellyn	'// 판매여부
	Public FRlimityn	'// 한정상품여부
	Public Fpitem '// 아이템 정보

	Public Foccupation
	Public Fnickname

	Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub
End Class


Class Cgetpiece

	Public FtotalCount
	Public FRectadminid
	public FOneUser
	Public FPieceList()
	Public FRectMaxIdx
	Public FRectStanum
	Public FRectEndnum
	Public FOneOpening
	Public FOnePiece
	Public FRectpagesize
	Public FRectcurrpage
	Public FResultCount
	Public FtotalPage
	Public FRectDeal
	Public FRectOpen
	Public FRectkeyword
	Public FRectSchword
	Public FRectIdx
	Public FRectArrItemId
	Public FRelationItemlist()
	Public FRectPieceIdx

	'// 피스 오프닝 데이터
	public Sub getPieceOpening()
		dim sqlStr
		sqlstr = " Select top 1 p.idx, p.fidx, p.gubun, p.bannergubun, p.noticeYN, p.listimg, p.listtext, p.shorttext, p.listtitle, p.adminid,  "
		sqlstr = sqlstr & " p.usertype, p.etclink, p.snsbtncnt, p.pieceidx, p.isusing, p.startdate, p.enddate, p.regdate, p.lastupdate, n.nickname, n.occupation, p.deleteyn, "
		sqlstr = sqlstr & " 	( "
		sqlstr = sqlstr & " 		Select stuff(( "
		sqlstr = sqlstr & " 			Select ','+tagtext "
		sqlstr = sqlstr & " 			From db_sitemaster.dbo.tbl_piece_tag "
		sqlstr = sqlstr & " 			Where pidx=p.idx "
		sqlstr = sqlstr & " 			for xml path('') "
		sqlstr = sqlstr & " 			), 1, 1, '')  "
		sqlstr = sqlstr & " 	) as tagtext, "
		sqlstr = sqlstr & " 	( "
		sqlstr = sqlstr & " 		Select stuff(( "
		sqlstr = sqlstr & " 			Select ','+convert(varchar(30), itemid) "
		sqlstr = sqlstr & " 			From db_sitemaster.dbo.tbl_piece_item "
		sqlstr = sqlstr & " 			Where pidx=p.idx "
		sqlstr = sqlstr & " 			for xml path('') "
		sqlstr = sqlstr & " 			), 1, 1, '')  "
		sqlstr = sqlstr & " 	) as itemid "
		sqlstr = sqlstr & " From db_sitemaster.dbo.tbl_piece p "
		sqlstr = sqlstr & " inner join db_sitemaster.dbo.tbl_piece_nickname n on p.adminid = n.adminid "
		sqlstr = sqlstr & " Where p.deleteyn='N' And p.noticeYN='Y' And isusing='Y' "
		sqlstr = sqlstr & " order by p.idx desc "
		rsget.Open SqlStr, dbget, 1
		FResultCount = rsget.RecordCount
		set FOneOpening = new Cpiece

		if Not rsget.Eof Then
			FOneOpening.Fidx = rsget("idx")
			FOneOpening.Ffidx = rsget("fidx")
			FOneOpening.Fgubun = rsget("gubun")
			FOneOpening.Fbannergubun = rsget("bannergubun")
			FOneOpening.Fnoticeyn = rsget("noticeYN")
			FOneOpening.Flistimg = rsget("listimg")
			FOneOpening.Flisttext = rsget("listtext")
			FOneOpening.Fshorttext = rsget("shorttext")
			FOneOpening.Flisttitle = rsget("listtitle")
			FOneOpening.Fadminid = rsget("adminid")
			FOneOpening.Fusertype = rsget("usertype")
			FOneOpening.Fetclink = rsget("etclink")
			FOneOpening.Fsnsbtncnt = rsget("snsbtncnt")
			FOneOpening.Fitemid = rsget("itemid")
			FOneOpening.Fpieceidx = rsget("pieceidx")
			FOneOpening.Fisusing = rsget("isusing")
			FOneOpening.Fstartdate = rsget("startdate")
			FOneOpening.Fenddate = rsget("enddate")
			FOneOpening.Fregdate = rsget("regdate")
			FOneOpening.Flastupdate = rsget("lastupdate")
			FOneOpening.FDeleteYn = rsget("deleteyn")
			FOneOpening.Foccupation = rsget("occupation")
			FOneOpening.Fnickname = rsget("nickname")
			FOneOpening.FTagText = rsget("tagtext")
		end if
		rsget.Close
	End Sub

	'// 피스 데이터 view
	public Sub getPieceview()
		dim sqlStr
		sqlstr = " Select top 1 p.idx, p.fidx, p.gubun,p.bannergubun, p.noticeYN, p.listimg, p.listtext, p.shorttext, p.listtitle, p.adminid,  "
		sqlstr = sqlstr & " p.usertype, p.etclink, p.snsbtncnt, p.itemid, p.pieceidx, p.isusing, p.startdate, p.enddate, p.regdate, p.lastupdate, n.nickname, n.occupation, p.deleteyn, "
		sqlstr = sqlstr & " STUFF(( "
		sqlstr = sqlstr & "	SELECT ',' + cast(t.tagtext as nvarchar(32)) + '$$' + cast(isNull(t.tagcnt,0) as varchar(15)) "
		sqlstr = sqlstr & "	FROM db_sitemaster.dbo.tbl_piece_tag as t "
		sqlstr = sqlstr & "	WHERE t.pidx = p.idx "
		sqlstr = sqlstr & " FOR XML PATH('') "
		sqlstr = sqlstr & " ), 1, 1, '') AS TagText, "
		sqlstr = sqlstr & " STUFF(( "
		sqlstr = sqlstr & " SELECT ',' + cast(ip.itemid as varchar(20)) + '$$' + cast(isNull(i.basicimage,0) as varchar(20)) "
		sqlstr = sqlstr & "	FROM db_sitemaster.dbo.tbl_piece_item as ip "
		sqlstr = sqlstr & "		left join db_item.dbo.tbl_item as i on ip.itemid = i.itemid "
		sqlstr = sqlstr & " WHERE ip.pidx = p.idx "
		sqlstr = sqlstr & " FOR XML PATH('') "
		sqlstr = sqlstr & " ), 1, 1, '') AS item "
		sqlstr = sqlstr & " From db_sitemaster.dbo.tbl_piece p "
		sqlstr = sqlstr & " inner join db_sitemaster.dbo.tbl_piece_nickname n on p.adminid = n.adminid "
		sqlstr = sqlstr & " Where p.deleteyn='N' And p.idx='"&FRectIdx&"' "
		sqlstr = sqlstr & " order by p.idx desc "
		rsget.Open SqlStr, dbget, 1
		FResultCount = rsget.RecordCount
		set FOnePiece = new Cpiece

		if Not rsget.Eof Then
			FOnePiece.Fidx		= rsget("idx")
			FOnePiece.Ffidx		= rsget("fidx")
			FOnePiece.Fgubun	= rsget("gubun")
			FOnePiece.Fbannergubun = rsget("bannergubun")
			FOnePiece.Fnoticeyn = rsget("noticeYN")
			FOnePiece.Flistimg	= rsget("listimg")
			FOnePiece.Flisttext = rsget("listtext")
			FOnePiece.Fshorttext = rsget("shorttext")
			FOnePiece.Flisttitle = rsget("listtitle")
			FOnePiece.Fadminid	= rsget("adminid")
			FOnePiece.Fusertype = rsget("usertype")
			FOnePiece.Fetclink	= rsget("etclink")
			FOnePiece.Fsnsbtncnt= rsget("snsbtncnt")
			FOnePiece.Fitemid	= rsget("itemid")
			FOnePiece.Fpieceidx = rsget("pieceidx")
			FOnePiece.Fisusing	= rsget("isusing")
			FOnePiece.Fstartdate = rsget("startdate")
			FOnePiece.Fenddate	= rsget("enddate")
			FOnePiece.Fregdate	= rsget("regdate")
			FOnePiece.Flastupdate = rsget("lastupdate")
			FOnePiece.FDeleteYn = rsget("deleteyn")
			FOnePiece.Foccupation = rsget("occupation")
			FOnePiece.Fnickname = rsget("nickname")
			FOnePiece.FTagText	= rsget("tagtext")
			FOnePiece.Fpitem	= rsget("item")
		end if
		rsget.Close
	End Sub

	'// 피스 리스트
	public sub GetpieceList()

		dim i, j, sqlStr

		sqlstr = " Select * From "
		sqlstr = sqlstr & " ( "
		sqlstr = sqlstr & " 	select  "
		sqlstr = sqlstr & " 	ROW_NUMBER() OVER (ORDER BY p.fidx desc) as rwnum, "
		sqlstr = sqlstr & " 	p.idx, p.fidx, p.gubun, p.bannergubun, p.noticeYN, p.listimg, p.listtext, p.shorttext, p.listtitle, "
		sqlstr = sqlstr & " 	p.adminid, p.usertype, p.etclink, p.snsbtncnt,isNull(n.nickname,'') as nickname, "
		sqlstr = sqlstr & " 	( "
		sqlstr = sqlstr & " 		Select stuff(( "
		sqlstr = sqlstr & " 			Select ','+tagtext "
		sqlstr = sqlstr & " 			From db_sitemaster.dbo.tbl_piece_tag "
		sqlstr = sqlstr & " 			Where pidx=p.idx "
		sqlstr = sqlstr & " 			for xml path('') "
		sqlstr = sqlstr & " 			), 1, 1, '')  "
		sqlstr = sqlstr & " 	) as tagtext, "
		sqlstr = sqlstr & " 	( "
		sqlstr = sqlstr & " 		Select stuff(( "
		sqlstr = sqlstr & " 			Select ','+convert(varchar(30), itemid) "
		sqlstr = sqlstr & " 			From db_sitemaster.dbo.tbl_piece_item "
		sqlstr = sqlstr & " 			Where pidx=p.idx "
		sqlstr = sqlstr & " 			for xml path('') "
		sqlstr = sqlstr & " 			), 1, 1, '')  "
		sqlstr = sqlstr & " 	) as itemid "
		sqlstr = sqlstr & " 	from db_sitemaster.dbo.tbl_piece as p "
		sqlstr = sqlstr & " 	left join db_sitemaster.dbo.tbl_piece_nickname as n on p.adminid = n.nickname "
		sqlstr = sqlstr & " 	where p.isusing = 'Y' and p.deleteyn = 'N' And p.idx <= '"&FRectMaxIdx&"' "
		sqlstr = sqlstr & " ) pp Where pp.rwnum >= '"&FRectStanum&"' And pp.rwnum < '"&FRectEndnum&"' "
		sqlstr = sqlstr & " order by pp.fidx desc "
		rsget.Open sqlstr, dbget, 1

		FResultCount = rsget.RecordCount
		redim FPieceList(FResultCount)

		i=0
		if not rsget.EOF  Then
			rsget.absolutepage = FRectcurrpage		
			do until rsget.eof
				set FPieceList(i) = new Cpiece
				FPieceList(i).Fidx = rsget("idx")
				FPieceList(i).Ffidx = rsget("fidx")
				FPieceList(i).Fgubun = rsget("gubun")
				FPieceList(i).Fbannergubun = rsget("bannergubun")
				FPieceList(i).Fnoticeyn = rsget("noticeYN")
				FPieceList(i).Flistimg = rsget("listimg")
				FPieceList(i).Flisttext = rsget("listtext")
				FPieceList(i).Fshorttext = rsget("shorttext")
				FPieceList(i).Flisttitle = rsget("listtitle")
				FPieceList(i).Fadminid = rsget("adminid")
				FPieceList(i).Fusertype = rsget("usertype")
				FPieceList(i).Fetclink = rsget("etclink")
				FPieceList(i).Fsnsbtncnt = rsget("snsbtncnt")
				FPieceList(i).Fitemid = rsget("itemid")
				FPieceList(i).Fpieceidx = rsget("pieceidx")
				FPieceList(i).Fisusing = rsget("isusing")
				FPieceList(i).Fstartdate = rsget("startdate")
				FPieceList(i).Fenddate = rsget("enddate")
				FPieceList(i).Fregdate = rsget("regdate")
				FPieceList(i).Flastupdate = rsget("lastupdate")
				FPieceList(i).FDeleteYn = rsget("deleteyn")
				FPieceList(i).Foccupation = rsget("occupation")
				FPieceList(i).Fnickname = rsget("nickname")
				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.Close
	End Sub
	
	'// 연관상품 가져오기
	public sub GetRelationItemList()
		dim i, j, sqlStr
		sqlstr = " Select i.itemid, i.itemname, i.isusing, i.limitno, i.limitsold, i.mainimage, i.listimage, i.listimage120, i.basicimage, i.icon1image, i.icon2image, i.sellyn, i.limityn"
		sqlstr = sqlstr & " From db_item.[dbo].[tbl_item] i"
		sqlstr = sqlstr & " inner join db_sitemaster.dbo.tbl_piece_item p on i.itemid = p.itemid "
		sqlstr = sqlstr & " Where p.pidx='"&FRectIdx&"' "
		sqlstr = sqlstr & " order by idx "
		rsget.Open SqlStr, dbget, 1
		FResultCount = rsget.RecordCount
		redim FRelationItemlist(FResultCount)
		i=0
		if not rsget.EOF  Then
			do until rsget.eof
				set FRelationItemlist(i) = new Cpiece
				FRelationItemlist(i).FRItemid = rsget("itemid")
				FRelationItemlist(i).FRitemname = rsget("itemname")
				FRelationItemlist(i).FRisusing = rsget("isusing")
				FRelationItemlist(i).FRlimitno = rsget("limitno")
				FRelationItemlist(i).FRlimitsold = rsget("limitsold")
				FRelationItemlist(i).FRmainimage = webImgUrl&"/image/main/"&GetImageSubFolderByItemid(FRelationItemlist(i).FRItemid)&"/"&rsget("mainimage")
				FRelationItemlist(i).FRlistimage = webImgUrl&"/image/list/"&GetImageSubFolderByItemid(FRelationItemlist(i).FRItemid)&"/"&rsget("listimage")
				FRelationItemlist(i).FRlistimage120 = webImgUrl&"/image/list120/"&GetImageSubFolderByItemid(FRelationItemlist(i).FRItemid)&"/"&rsget("listimage120")
				FRelationItemlist(i).FRbasicimage = webImgUrl&"/image/basic/"&GetImageSubFolderByItemid(FRelationItemlist(i).FRItemid)&"/"&rsget("basicimage")
				FRelationItemlist(i).FRicon1image = webImgUrl&"/image/icon1/"&GetImageSubFolderByItemid(FRelationItemlist(i).FRItemid)&"/"&rsget("icon1image")
				FRelationItemlist(i).FRicon2image = webImgUrl&"/image/icon2/"&GetImageSubFolderByItemid(FRelationItemlist(i).FRItemid)&"/"&rsget("icon2image")
				FRelationItemlist(i).FRsellyn = rsget("sellyn")
				FRelationItemlist(i).FRlimityn = rsget("limityn")
				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.Close

	End Sub

	'// 파이 리스트
	public sub GetPieList()

		dim i, j, sqlStr

		sqlstr = " Select idx , listimg , shorttext "
		sqlstr = sqlstr & "	from db_sitemaster.dbo.tbl_piece as p "
		sqlstr = sqlstr & "	where isusing = 'Y' and deleteyn = 'N' And p.idx in ("& Trim(FRectPieceIdx) &")"
		sqlstr = sqlstr & " order by fidx desc "

		rsget.Open sqlstr, dbget, 1

		FResultCount = rsget.RecordCount
		redim FPieceList(FResultCount)

		i=0
		if not rsget.EOF  Then
			do until rsget.eof
				set FPieceList(i) = new Cpiece
				FPieceList(i).Fidx = rsget("idx")
				FPieceList(i).Flistimg = rsget("listimg")
				FPieceList(i).Fshorttext = rsget("shorttext")
				i=i+1
				rsget.moveNext
			loop
		end if
		rsget.Close
	End Sub

	'// 피스 데이터 preview
	public Sub getPiecepreview()
		dim sqlStr
		sqlstr = " Select top 1 p.idx, p.fidx, p.gubun,p.bannergubun, p.noticeYN, p.listimg, p.listtext, p.shorttext, p.listtitle, p.adminid,  "
		sqlstr = sqlstr & " p.usertype, p.etclink, p.snsbtncnt, p.itemid, p.pieceidx, p.isusing, p.startdate, p.enddate, p.regdate, p.lastupdate, n.nickname, n.occupation, p.deleteyn, "
		sqlstr = sqlstr & " STUFF(( "
		sqlstr = sqlstr & "	SELECT ',' + cast(t.tagtext as nvarchar(32)) + '$$' + cast(isNull(t.tagcnt,0) as varchar(15)) "
		sqlstr = sqlstr & "	FROM db_sitemaster.dbo.tbl_piece_tag as t "
		sqlstr = sqlstr & "	WHERE t.pidx = p.idx "
		sqlstr = sqlstr & " FOR XML PATH('') "
		sqlstr = sqlstr & " ), 1, 1, '') AS TagText, "
		sqlstr = sqlstr & " STUFF(( "
		sqlstr = sqlstr & " SELECT ',' + cast(ip.itemid as varchar(20)) + '$$' + cast(isNull(i.basicimage,0) as varchar(20)) "
		sqlstr = sqlstr & "	FROM db_sitemaster.dbo.tbl_piece_item as ip "
		sqlstr = sqlstr & "		left join db_item.dbo.tbl_item as i on ip.itemid = i.itemid "
		sqlstr = sqlstr & " WHERE ip.pidx = p.idx "
		sqlstr = sqlstr & " FOR XML PATH('') "
		sqlstr = sqlstr & " ), 1, 1, '') AS item "
		sqlstr = sqlstr & " From db_sitemaster.dbo.tbl_piece p "
		sqlstr = sqlstr & " inner join db_sitemaster.dbo.tbl_piece_nickname n on p.adminid = n.adminid "
		sqlstr = sqlstr & " Where p.idx='"&FRectIdx&"' "
		sqlstr = sqlstr & " order by p.idx desc "
		rsget.Open SqlStr, dbget, 1
		FResultCount = rsget.RecordCount
		set FOnePiece = new Cpiece

		if Not rsget.Eof Then
			FOnePiece.Fidx		= rsget("idx")
			FOnePiece.Ffidx		= rsget("fidx")
			FOnePiece.Fgubun	= rsget("gubun")
			FOnePiece.Fbannergubun = rsget("bannergubun")
			FOnePiece.Fnoticeyn = rsget("noticeYN")
			FOnePiece.Flistimg	= rsget("listimg")
			FOnePiece.Flisttext = rsget("listtext")
			FOnePiece.Fshorttext = rsget("shorttext")
			FOnePiece.Flisttitle = rsget("listtitle")
			FOnePiece.Fadminid	= rsget("adminid")
			FOnePiece.Fusertype = rsget("usertype")
			FOnePiece.Fetclink	= rsget("etclink")
			FOnePiece.Fsnsbtncnt= rsget("snsbtncnt")
			FOnePiece.Fitemid	= rsget("itemid")
			FOnePiece.Fpieceidx = rsget("pieceidx")
			FOnePiece.Fisusing	= rsget("isusing")
			FOnePiece.Fstartdate = rsget("startdate")
			FOnePiece.Fenddate	= rsget("enddate")
			FOnePiece.Fregdate	= rsget("regdate")
			FOnePiece.Flastupdate = rsget("lastupdate")
			FOnePiece.FDeleteYn = rsget("deleteyn")
			FOnePiece.Foccupation = rsget("occupation")
			FOnePiece.Fnickname = rsget("nickname")
			FOnePiece.FTagText	= rsget("tagtext")
			FOnePiece.Fpitem	= rsget("item")
		end if
		rsget.Close
	End Sub

End Class

'// 나의 조각 갯수 가져오기
Function pieceMyCnt(adid)
	dim sqlStr
	sqlStr = " Select count(idx) From db_sitemaster.dbo.tbl_piece Where adminid='"&adid&"' And DeleteYn = 'N' "
	rsget.CursorLocation = adUseClient
	rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
	pieceMyCnt = rsget(0)
	rsget.close
End Function


'// 나의 조각 갯수 가져오기
Function pieceMySNSCnt(adid)
	dim sqlStr
	sqlStr = " Select isNull(sum(snsbtncnt),0) From db_sitemaster.dbo.tbl_piece Where adminid='"&adid&"' And DeleteYn = 'N' "
	rsget.CursorLocation = adUseClient
	rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
	pieceMySNSCnt = FormatNumber(rsget(0),0)
	rsget.close
End Function


'// 나의 piece 위시 가져오기
Function fnGetMyPieceWishItem()
	dim sqlStr, vTmp
	sqlStr = "select f.itemid from db_my10x10.dbo.tbl_myfavorite_folder as ff "
	sqlStr = sqlStr & "left join db_my10x10.dbo.tbl_myfavorite as f on ff.fidx = f.fidx and ff.userid = f.userid "
	sqlStr = sqlStr & "where f.userid = '" & getLoginUserid() & "' and ff.foldername = 'Piece' "
	rsget.CursorLocation = adUseClient
	rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
	if not rsget.eof then
		vTmp = rsget.getrows()
	end if
	rsget.close
	fnGetMyPieceWishItem = vTmp
End Function


Function fnDayCheckText(d)
	Dim vTmp, v
	d = Left(d,4) & "-" & Mid(d,5,2) & "-" & Mid(d,7,2)
	v = DateDiff("d",CDate(d),date())
	
	SELECT CASE v
		Case 1 : vTmp = "어제"
		Case 2 : vTmp = "이틀전"
		Case Else
			If v > 2 Then
				vTmp = "오래전"
			Else
				vTmp = ""
			End If
	END SELECT
	
	fnDayCheckText = vTmp
End Function


Function fnSplitTxt(t,num)
	Dim vTmp
	
	If t <> "" Then
		vTmp = Split(t,"$$")(num)
	End IF
	
	fnSplitTxt = vTmp
End Function

Function fnTagCountUpdate(tag)
	dim sqlStr
	sqlstr = "if exists(select top 1 tagtext from db_sitemaster.dbo.tbl_piece_tag where tagtext = '"& tag &"') "
	sqlstr = sqlstr & "update db_sitemaster.dbo.tbl_piece_tag set tagcnt = tagcnt + 1 where tagtext = '"& tag &"' "
	dbget.execute sqlstr
End Function

'// 공유 카운트
Function fnShareCountUpdate(idx)
	dim sqlStr
	sqlstr = "if exists(select top 1 idx from db_sitemaster.dbo.tbl_piece where idx = '"& idx &"') "
	sqlstr = sqlstr & "update db_sitemaster.dbo.tbl_piece set snsbtncnt = snsbtncnt + 1 where idx = '"& idx &"' "
	dbget.execute sqlstr
End function
%>
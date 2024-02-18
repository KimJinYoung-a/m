<%
dim oEval,ix, intEval, oEvPhoto

dim arrUserid2, bdgUid2, bdgBno2, i

set oEval = new CEvaluateSearcher

oEval.FPageSize = 2
oEval.FCurrpage = 1
oEval.FECode = eCode
oEval.GetTopEventGoodUsingList_new

	'//포토상품 후기
	set oEvPhoto = new CEvaluateSearcher
	oEvPhoto.FGubun = ""
	oEvPhoto.FPageSize = 2
	oEvPhoto.FCurrpage = 1
	oEvPhoto.FsortMethod = "ph"
	oEvPhoto.FECode = eCode
	if (oEval.FResultCount>0) then
	    oEvPhoto.GetTopEventGoodUsingList_new
    end if
%>
<div class="tab01">
	<ul class="tabNav tNum2">
		<li class="current"><a href="#allCmt">전체(<%= oEval.FTotalCount %>)<span></span></a></li>
		<li><a href="#photoCmt">포토후기(<%= oEvPhoto.FTotalCount %>)<span></span></a></li>
	</ul>
	<div class="tabContainer box1 mar0 evtReviewV15">
		<div class="rt"><p class="goWriteV15" onclick="location.href='/my10x10/goodsusing.asp';" style="cursor:pointer;"><span>후기쓰기</span></p></div>
		<!-- 전체 후기 -->
		<div id="allCmt" class="tabContent">
			<div class="postscript">
				<ul class="replyList">
					<%
						if oEval.FResultCount > 0 then
							'사용자 아이디 모음 생성(for Badge)
							for i = 0 to oEval.FResultCount -1
								arrUserid2 = arrUserid2 & chkIIF(arrUserid2<>"",",","") & "''" & trim(oEval.FItemList(i).FUserID) & "''"
							next
							'뱃지 목록 접수(순서 랜덤)
							Call getUserBadgeList(arrUserid2,bdgUid2,bdgBno2,"Y")
							for i = 0 to oEval.FResultCount - 1
					%>
					<li>
						<p class="pic"><a href="/category/category_itemPrd.asp?itemid=<%=oEval.FItemList(i).FItemID%>"><img src="<%=oEval.FItemList(i).FImageList120%>" alt="<%=oEval.FItemList(i).FItemID%>" /></a></p>
						<div class="replyCont">
							<p class="pdtName"><%=oEval.FItemList(i).FItemname %></p>
							<p class="rating">
								<span class="icon-rating">
									<% If oEval.FItemList(i).FTotalPoint <> "" Then %>
										<i style="width:<%=oEval.FItemList(i).FTotalPoint*20%>%">리뷰 종합 별점 <%=oEval.FItemList(i).FTotalPoint*20%>점</i>
									<% End If %>
								</span>
							</p>
							<p><%= eva_db2html(oEval.FItemList(i).getUsingTitle(50)) %></p>
							<div class="writerInfo">
								<p><%= FormatDate(oEval.FItemList(i).FRegdate,"0000/00/00") %> <span class="bar">/</span> <%= printUserId(oEval.FItemList(i).FUserID,2,"*") %></p>
								<p class="badge">
									<%=getUserBadgeIcon(oEval.FItemList(i).FUserID,bdgUid2,bdgBno2,3)%>
								</p>
							</div>
							<p class="tPad05 lh1">
								<% if oEval.FItemList(i).Flinkimg1<>"" then %>
								<img src="<%= oEval.FItemList(i).getLinkImage1 %>" alt="file1<% = i %>" />
								<% end if %>
								<% if oEval.FItemList(i).Flinkimg2<>"" then %>
								<img src="<%= oEval.FItemList(i).getLinkImage2 %>" alt="file2<% = i %>" />
								<% end if %>
							</p>
						</div>
					</li>
					<% 
							Next
						Else
					%>
					<p class="no-data ct">해당 게시물이 없습니다.</p>
					<% End If %>
				</ul>
				<% if oEval.FResultCount > 0 Then %>
				<p class="goViewV15" onclick="fnOpenModal('/event/event_usingpost.asp?view=l&eventid=<%=eCode%>&linkevt=<%=LinkEvtCode%>&blnB=<%=blnBlogURL%>'); return false;"><span>더보기</span></p>
				<% End If %>
			</div>
		</div>
		<!--// 전체 후기 -->

		<!-- 포토후기 -->
		<div id="photoCmt" class="tabContent">
			<div class="postscript">
				<ul class="replyList">
					<%
						if oEvPhoto.FResultCount > 0 then
							'사용자 아이디 모음 생성(for Badge)
							for i = 0 to oEvPhoto.FResultCount -1
								arrUserid2 = arrUserid2 & chkIIF(arrUserid2<>"",",","") & "''" & trim(oEvPhoto.FItemList(i).FUserID) & "''"
							next

							'뱃지 목록 접수(순서 랜덤)
							Call getUserBadgeList(arrUserid2,bdgUid2,bdgBno2,"Y")

							for i = 0 to oEvPhoto.FResultCount - 1
					%>
					<li>
						<p class="pic"><a href="/category/category_itemPrd.asp?itemid=<%=oEvPhoto.FItemList(i).FItemID%>"><img src="<%=oEvPhoto.FItemList(i).FImageList120%>" alt="<%=oEvPhoto.FItemList(i).FItemID%>" /></a></p>
						<div class="replyCont">
							<p class="pdtName"><%=oEvPhoto.FItemList(i).FItemname %></p>
							<p class="rating">
								<span class="icon-rating">
									<% If oEvPhoto.FItemList(i).FTotalPoint <> "" Then %>
										<i style="width:<%=oEvPhoto.FItemList(i).FTotalPoint*20%>%">리뷰 종합 별점 <%=oEvPhoto.FItemList(i).FTotalPoint*20%>점</i>
									<% End If %>
								</span>
							</p>
							<p><%= eva_db2html(oEvPhoto.FItemList(i).getUsingTitle(50)) %></p>
							<div class="writerInfo">
								<p><%= FormatDate(oEvPhoto.FItemList(i).FRegdate,"0000/00/00") %> <span class="bar">/</span> <%= printUserId(oEvPhoto.FItemList(i).FUserID,2,"*") %></p>
								<p class="badge">
									<%=getUserBadgeIcon(oEvPhoto.FItemList(i).FUserID,bdgUid2,bdgBno2,3)%>
								</p>
							</div>
							<p class="tPad05 lh1">
								<% if oEvPhoto.FItemList(i).Flinkimg1<>"" then %>
									<img src="<%= oEvPhoto.FItemList(i).getLinkImage1 %>" alt="file1<% = i %>" />
								<% end if %>
								<% if oEvPhoto.FItemList(i).Flinkimg2<>"" then %>
									<img src="<%= oEvPhoto.FItemList(i).getLinkImage2 %>" alt="file2<% = i %>" />
								<% end if %>
							</p>
						</div>
					</li>
					<% 
							Next
						Else
					%>
					<p class="no-data ct">해당 게시물이 없습니다.</p>
					<% End If %>
				</ul>
				<% if oEvPhoto.FResultCount > 0 Then %>
				<p class="goViewV15" onclick="fnOpenModal('/event/event_usingpost.asp?view=p&eventid=<%=eCode%>&linkevt=<%=LinkEvtCode%>&blnB=<%=blnBlogURL%>');return false;"><span>더보기</span></p>
				<% End If %>
			</div>
		</div>
		<!--// 포토후기 -->
	</div>
</div>
<%
set oEval = Nothing
set oEvPhoto = Nothing

function eva_db2html(checkvalue)
	dim v
	v = checkvalue
	if Isnull(v) then Exit function

    On Error resume Next
    v = replace(v, "&amp;", "&")
    v = replace(v, "&lt;", "<")
    v = replace(v, "&gt;", ">")
    v = replace(v, "&quot;", "'")
    v = Replace(v, "", "<br />")
    v = Replace(v, "\0x5C", "\")
    v = Replace(v, "\0x22", "'")
    v = Replace(v, "\0x25", "'")
    v = Replace(v, "\0x27", "%")
    v = Replace(v, "\0x2F", "/")
    v = Replace(v, "\0x5F", "_")
	'v = Replace(v, "><!", "&gt;&lt;!")
	v = Replace(v, ">", "&gt;")
	v = Replace(v, "<", "&lt;")
	v = Replace(v, "&lt;br&gt;", "<br>")
	v = Replace(v, "&lt;br/&gt;", "<br/>")
	v = Replace(v, "&lt;br /&gt;", "<br />")

    eva_db2html = v
end function
%>
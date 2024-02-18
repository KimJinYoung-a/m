<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/classes/event/eventApplyCls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_evaluatesearchercls.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<% 
'####################################################
'# 상품 후기 레이어 - ajax
'# 2015-03-27 이종화
'####################################################

dim eCode , LinkEvtCode
dim iCPageSize, iCCurrpage 
dim vView , vPage
			
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	eCode		= requestCheckVar(Request("eventid"),10) '이벤트 코드번호
	vView		= requestCheckVar(Request("view"),1) '전체보기 포토후기 구분
	If vView = "l" then
		vPage = "goPage1"
	Else
		vPage = "goPage2"
	End If 

	If vView = "" Then vView = "l" End If

	If eCode = "" Then
		Response.Write "<script>alert('올바른 접근이 아닙니다.');window.close();</script>"
		dbget.close()
		Response.End
	End If

	iCPageSize = 10		'한 페이지의 보여지는 열의 수
		
	'데이터 가져오기
	
	dim oEval,ix, intEval, oEvPhoto
	'//뱃찌
	dim arrUserid2, bdgUid2, bdgBno2, i
	set oEval = new CEvaluateSearcher

	oEval.FPageSize = iCPageSize
	oEval.FCurrpage = iCCurrpage
	oEval.FECode = eCode
	If vView = "p" then
	oEval.FsortMethod = "ph"
	End If 
	oEval.GetTopEventGoodUsingList_new


%>
<div class="tabContent">
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
				<p class="pic"><img src="<%=oEval.FItemList(i).FImageList120%>" alt="<%=oEval.FItemList(i).FItemID%>" /></p>
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
		<div class="paging">
			<%=fnDisplayPaging_New(oEval.FCurrpage,oEval.FTotalCount,iCPageSize,4,vPage)%>
		</div>
	</div>
</div>
<% 
	set oEval=Nothing 

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
		v = Replace(v, ">", "&gt;")
		v = Replace(v, "<", "&lt;")
		v = Replace(v, "&lt;br&gt;", "<br>")
		v = Replace(v, "&lt;br/&gt;", "<br/>")
		v = Replace(v, "&lt;br /&gt;", "<br />")

		eva_db2html = v
	end function
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->
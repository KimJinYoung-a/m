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
'# 상품 후기 레이어
'# 2015-03-27 이종화
'####################################################

dim eCode , LinkEvtCode
dim iCPageSize, iCCurrpage 
dim vView
			
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	eCode		= requestCheckVar(Request("eventid"),10) '이벤트 코드번호
	vView		= requestCheckVar(Request("view"),1) '전체보기 포토후기 구분
	If vView = "" Then vView = "l" End If

	If eCode = "" Then
		Response.Write "<script>alert('올바른 접근이 아닙니다.');window.close();</script>"
		dbget.close()
		Response.End
	End If

	IF iCCurrpage = "" THEN
		iCCurrpage = 1	
	END IF	
	IF LinkEvtCode = "" THEN
		LinkEvtCode = 0
	END IF
	  
	iCPageSize = 10		'한 페이지의 보여지는 열의 수
		
	'데이터 가져오기
	
	dim oEval,ix, intEval, oEvPhoto
	'//뱃찌
	dim arrUserid2, bdgUid2, bdgBno2, i
	set oEval = new CEvaluateSearcher

	oEval.FPageSize = iCPageSize
	oEval.FCurrpage = iCCurrpage
	oEval.FECode = eCode
	oEval.GetTopEventGoodUsingList_new

		'//포토상품 후기
		set oEvPhoto = new CEvaluateSearcher
		oEvPhoto.FGubun = ""
		oEvPhoto.FPageSize = iCPageSize
		oEvPhoto.FCurrpage = iCCurrpage
		oEvPhoto.FsortMethod = "ph"
		oEvPhoto.FECode = eCode
		if (oEval.FResultCount>0) then
			oEvPhoto.GetTopEventGoodUsingList_new
		end if
%>

<script>
//'전체보기용
function goPage1(page)
{
	$.ajax({
		url: "/event/event_usingpostajax.asp?view=l&iCC="+page+"&eventid=<%=eCode%>",
		cache: false,
		async: false,
		success: function(message) {
			$("#photodiv").hide();
			$("#listdiv").show();
			$("#commentlistajax").empty().append(message);
		    setTimeout(function () {
		        myScroll.refresh();
		        myScroll.scrollTo(0,0,50);
		    }, 500);
		}
	});
}

//'포토후기용
function goPage2(page)
{
	$.ajax({
		url: "/event/event_usingpostajax.asp?view=p&iCC="+page+"&eventid=<%=eCode%>",
		cache: false,
		async: false,
		success: function(message) {
			$("#photodiv").show();
			$("#listdiv").hide();
			$("#photolistajax").empty().append(message);
		    setTimeout(function () {
		        myScroll.refresh();
		        myScroll.scrollTo(0,0,50);
		    }, 500);
		}
	});
}

function jsDivView(d){
	if(d == "p"){
		$("#photodiv").show();
		$("#listdiv").hide();
		setTimeout(function () {
			myScroll.refresh();
		}, 500);
	}else{
		$("#photodiv").hide();
		$("#listdiv").show();
		setTimeout(function () {
			myScroll.refresh();
		}, 500);
	}
}
</script>

<div class="layerPopup">
	<div class="popWin">
		<div class="header">
			<h1>후기</h1>
			<p class="btnPopClose"><button type="button" class="pButton" onclick="fnCloseModal();">닫기</button></p>
		</div>
		<div class="content bgGry" id="layerScroll">
			<div id="scrollarea">
				<div class="inner5 tMar15 cmtCont">
					<div class="tab01 noMove" id="listdiv" style="display:<%=CHKIIF(vView="l","block","none")%>;">
						<ul class="tabNav tNum2">
							<li id="ltabw" class="current"><a href="" onClick="jsDivView('l'); return false;">전체보기<span></span></a></li>
							<li id="ltabl"><a href="" onClick="jsDivView('p'); return false;">포토후기<span></span></a></li>
						</ul>

						<div class="tabContainer box1" id="commentlistajax">
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
												<p><%=db2html(oEval.FItemList(i).FUesdContents)%></p>
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
										<%=fnDisplayPaging_New(oEval.FCurrpage,oEval.FTotalCount,iCPageSize,4,"goPage1")%>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="tab01 noMove" id="photodiv" style="display:<%=CHKIIF(vView="p","block","none")%>;">
						<ul class="tabNav tNum2">
							<li id="ltabw"><a href="" onClick="jsDivView('l'); return false;">전체보기<span></span></a></li>
							<li id="ltabl" class="current"><a href="" onClick="jsDivView('p'); return false;">포토후기<span></span></a></li>
						</ul>
						<div class="tabContainer box1" id="photolistajax">
							<div class="tabContent">
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
											<p class="pic"><img src="<%=oEvPhoto.FItemList(i).FImageList120%>" alt="<%=oEvPhoto.FItemList(i).FItemID%>" /></p>
											<div class="replyCont">
												<p class="pdtName"><%=oEvPhoto.FItemList(i).FItemname %></p>
												<p class="rating">
													<span class="icon-rating">
														<% If oEvPhoto.FItemList(i).FTotalPoint <> "" Then %>
															<i style="width:<%=oEvPhoto.FItemList(i).FTotalPoint*20%>%">리뷰 종합 별점 <%=oEvPhoto.FItemList(i).FTotalPoint*20%>점</i>
														<% End If %>
													</span>
												</p>
												<p><%=db2html(oEvPhoto.FItemList(i).FUesdContents)%></p>
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
									<div class="paging">
										<%=fnDisplayPaging_New(oEvPhoto.FCurrpage,oEvPhoto.FTotalCount,iCPageSize,4,"goPage2")%>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
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
<!-- #include virtual="/lib/db/dbclose.asp" -->
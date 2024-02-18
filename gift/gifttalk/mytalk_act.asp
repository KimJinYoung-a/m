<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'###########################################################
' Description :  기프트
' History : 2015.02.09 한용민 생성
'###########################################################
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/gift/giftCls.asp" -->
<!-- #include virtual="/gift/Underconstruction_gift.asp" -->

<%
Dim vCurrPage, vSelectUserID, i, j, vSort, UserProfileImg, cTalkComm, PageSize, beforepageminidx, beforepagedispyn
dim vtmpitemid, vtmpImageBasic, vtmpidx, vtmpTalkIdx, vtmpSelectoxab, vtmpgood
	vCurrPage = requestCheckVar(Request("cpg"),5)
	vSort = requestCheckVar(Request("sort"),1)
	PageSize = getNumeric(requestCheckVar(request("psz"),9))
	beforepageminidx = getNumeric(requestCheckVar(request("beforepageminidx"),10))

If PageSize="" Then PageSize = 10
If vCurrPage = "" Then vCurrPage = 1
beforepagedispyn="Y"

If isNumeric(vCurrPage) = False Then
	Response.Write "<script>alert('잘못된 경로입니다.');</script>"
	dbget.close()
	Response.End
End If
'response.write "<script>alert('" & vCurrPage & "/" & PageSize & "');</script>"
vSelectUserID = GetLoginUserID()

Dim cTalk
SET cTalk = New CGiftTalk
	cTalk.FPageSize = PageSize
	cTalk.FCurrpage = vCurrPage
	cTalk.FRectUserId = GetLoginUserID()
	cTalk.FRectselectuserid = vSelectUserID
	'cTalk.FRectItemId = vItemID
	'cTalk.FRectTheme = vTheme
	'cTalk.FRectSort = vSort
	cTalk.FRectUseYN = "y"
	cTalk.getGiftTalkList

%>
<% If (cTalk.FResultCount < 1) Then %>
	<% if vCurrPage="1" then %>
		<script type="text/javascript">$("#nodata").show();</script>
	<% else %>
		<!--<script type="text/javascript">$("#nodata_act").show();</script>-->
	<% end if %>
<% Else %>
	<% For i = 0 To cTalk.FResultCount-1 %>
	<%
	if vCurrPage>1 then
		'/이전페이지에 있는 내용은 제낀다.
		if CStr(beforepageminidx) > CStr(cTalk.FItemList(i).FTalkIdx) then
			
			beforepagedispyn="Y"
		else
			beforepagedispyn="N"
		end if
		'response.write beforepageminidx & "/" &  cTalk.FItemList(i).FTalkIdx & "/" & beforepagedispyn & "<br>"
	end if

	if beforepagedispyn="Y" then
	%>
		<%
		'//상품 2개 짜리
		If cTalk.FItemList(i).FTheme = "2" Then
		%>
			<%
			'//페이지 부하로 인하여 쿼리(조인방식으로 변경)해서 가져온후, 필요한 부분만 가공해서 뿌린다.		'//서이사님 지시
			if (CStr(vtmpTalkIdx)=CStr(cTalk.FItemList(i).FTalkIdx)) then
			%>
				<div class="box1 select<%=CHKIIF(cTalk.FItemList(i).FTheme="2","AB","YN")%>">
					<div class="topic">
						<div class="profile">
							<span class="thumb"><img src="<%=GetUserProfileImg(UserProfileImg, cTalk.FItemList(i).FUserID)%>" alt="프로필이미지" /></span>
							<strong class="id"><%=printUserId(cTalk.FItemList(i).FUserID,2,"*")%><% If cTalk.FItemList(i).FDevice = "m" Then %><span class="mo"><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_mobile.png" alt="모바일에서 작성" /></span><% End If %></strong>
							<span class="date"><%=fnTalkRegTime(cTalk.FItemList(i).FRegdate)%></span>
						</div>
						<h3><%=chrbyte(cTalk.FItemList(i).FContents,200,"Y")%></h3>
						<% If cTalk.FItemList(i).FUserID = GetLoginUserID() Then %>
							<div class="btnwrap">
								<a href="" onClick="writeShoppingTalk('<%=cTalk.FItemList(i).FTalkIdx%>','<%= cTalk.FItemList(i).fitemid %>'); return false;">수정</a>
								<button onClick="jsMyTalkEdit('<%=cTalk.FItemList(i).FTalkIdx%>'); return false;" type="button">삭제</button>
							</div>
						<% end if %>
					</div>
					<div class="desc descAB">
						<div class="thumb">
							<a href="/category/category_itemprd.asp?itemid=<%= vtmpitemid %>" id="Hlink1">
							<img src="<%=getThumbImgFromURL(vtmpImageBasic,300,300,"true","false")%>" alt="<%= vtmpitemid %>" /></a>
							<a href="/category/category_itemprd.asp?itemid=<%= cTalk.FItemList(i).fitemid %>" id="Hlink2">
							<img src="<%=getThumbImgFromURL(cTalk.FItemList(i).FImageBasic,300,300,"true","false")%>" alt="<%= cTalk.FItemList(i).fitemid %>" /></a>
						</div>
						<div class="vote">
							<span>
								<button type="button" onclick="jsTalkvote('<%= vtmpidx %>','<%= vtmpTalkIdx %>','good','<%= i %>','<%= cTalk.FItemList(i).FTheme %>','A'); return false;" id="btgood<%= vtmpIdx %>" <% If vtmpSelectoxab="A" then%> class="on" <% End if %>>A 선택</button> 
								<em id="countgood<%= vtmpIdx %>"><%= vtmpgood %></em>
							</span>
							<span>
								<button type="button" onclick="jsTalkvote('<%= cTalk.FItemList(i).Fidx %>','<%= cTalk.FItemList(i).FTalkIdx %>','good','<%= i %>','<%= cTalk.FItemList(i).FTheme %>','B'); return false;" id="btgood<%= cTalk.FItemList(i).FIdx %>" <% If cTalk.FItemList(i).FSelectoxab="B" then%> class="on" <% End if %>>B 선택</button> 
								<em id="countgood<%= cTalk.FItemList(i).FIdx %>"><%= cTalk.FItemList(i).fgood %></em>
							</span>
						</div>
					</div>
					<div class="comment">
						<div class="replyList" id="commentcnt<%= cTalk.FItemList(i).FTalkIdx %>" commentcnt="<%= cTalk.FItemList(i).FCommCnt %>">
							<% 'for dev msg : 코멘트가 있을경우에 클래스명 total을 넣어주세요. <h4 class="total">...</h4> %>
							<% If cTalk.FItemList(i).FCommCnt > 0 Then %>
								<h4 onclick="getcommentlist_act('<%=cTalk.FItemList(i).FTalkIdx%>'); return false;" talkidx="<%= cTalk.FItemList(i).FTalkIdx %>" id="commenttotal<%= cTalk.FItemList(i).FTalkIdx %>" class="total"><em class="cRd1"><%= cTalk.FItemList(i).FCommCnt %></em>개의 코멘트 보기</h4>
							<% Else %>
								<h4><a href="" onClick="fnOpenModal('/gift/gifttalk/talk_view.asp?talkidx=<%=cTalk.FItemList(i).FTalkIdx%>&wagubun=w'); return false;">코멘트 쓰기</a></h4>
							<% End if %>
							<div id="comment<%= cTalk.FItemList(i).FTalkIdx %>" class="cmtWrap">
							</div>
						</div>
					</div>
				</div>
				<%
				vtmpitemid=""
				vtmpImageBasic=""
				vtmpidx=""
				vtmpTalkIdx=""
				vtmpSelectoxab=""
				vtmpgood=""
				%>			
			<% else %>
				<%
				vtmpitemid=cTalk.FItemList(i).fitemid
				vtmpImageBasic=cTalk.FItemList(i).FImageBasic
				vtmpidx=cTalk.FItemList(i).Fidx
				vtmpTalkIdx=cTalk.FItemList(i).FTalkIdx
				vtmpSelectoxab=cTalk.FItemList(i).FSelectoxab
				vtmpgood=cTalk.FItemList(i).fgood
	
				%>
			<% end if %>
		<%
		'/상품 1개 짜리
		Else
		%>
			<div class="box1 select<%=CHKIIF(cTalk.FItemList(i).FTheme="2","AB","YN")%>">
				<div class="topic">
					<div class="profile">
						<span class="thumb"><img src="<%=GetUserProfileImg(UserProfileImg, cTalk.FItemList(i).FUserID)%>" alt="프로필이미지" /></span>
						<strong class="id"><%=printUserId(cTalk.FItemList(i).FUserID,2,"*")%><% If cTalk.FItemList(i).FDevice = "m" Then %><span class="mo"><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_mobile.png" alt="모바일에서 작성" /></span><% End If %></strong>
						<span class="date"><%=fnTalkRegTime(cTalk.FItemList(i).FRegdate)%></span>
					</div>
					<h3><%=chrbyte(cTalk.FItemList(i).FContents,200,"Y")%></h3>
					<% If cTalk.FItemList(i).FUserID = GetLoginUserID() Then %>
						<div class="btnwrap">
							<a href="" onClick="writeShoppingTalk('<%=cTalk.FItemList(i).FTalkIdx%>','<%= cTalk.FItemList(i).fitemid %>'); return false;">수정</a>
							<button onClick="jsMyTalkEdit('<%=cTalk.FItemList(i).FTalkIdx%>'); return false;" type="button">삭제</button>
						</div>
					<% end if %>
				</div>
				<div class="desc">
					<div class="thumb">
						<a href="/category/category_itemprd.asp?itemid=<%= cTalk.FItemList(i).fitemid %>" id="Hlink1">
						<img src="<%=getThumbImgFromURL(cTalk.FItemList(i).FImageBasic,400,400,"true","false")%>" alt="<%= cTalk.FItemList(i).fitemid %>" /></a>
					</div>
					<div class="vote">
						<span>
							<button type="button" id="btgood<%= cTalk.FItemList(i).FIdx %>" onclick="jsTalkvote('<%= cTalk.FItemList(i).fidx %>','<%=cTalk.FItemList(i).FTalkIdx%>','good','<%=i%>','<%=cTalk.FItemList(i).FTheme%>','O');" <% If cTalk.FItemList(i).FSelectoxab ="O" then%> class="on" <% End if %>>찬성</button> 
							<em id="countgood<%= cTalk.FItemList(i).FIdx %>"><%= cTalk.FItemList(i).fgood %></em>
						</span>
						<span>
							<button type="button" id="btbad<%= cTalk.FItemList(i).FIdx %>" onclick="jsTalkvote('<%= cTalk.FItemList(i).fidx %>','<%=cTalk.FItemList(i).FTalkIdx%>','bad','<%=i%>','<%=cTalk.FItemList(i).FTheme%>','X');" <% If cTalk.FItemList(i).FSelectoxab ="X" then%> class="on" <% End if %>>반대</button> 
							<em id="countbad<%= cTalk.FItemList(i).FIdx %>"><%= cTalk.FItemList(i).fbad %></em>
						</span>
					</div>
				</div>
				<div class="comment">
					<div class="replyList" id="commentcnt<%= cTalk.FItemList(i).FTalkIdx %>" commentcnt="<%= cTalk.FItemList(i).FCommCnt %>">
						<% 'for dev msg : 코멘트가 있을경우에 클래스명 total을 넣어주세요. <h4 class="total">...</h4> %>
						<% If cTalk.FItemList(i).FCommCnt > 0 Then %>
							<h4 onclick="getcommentlist_act('<%=cTalk.FItemList(i).FTalkIdx%>'); return false;" talkidx="<%= cTalk.FItemList(i).FTalkIdx %>" id="commenttotal<%= cTalk.FItemList(i).FTalkIdx %>" class="total"><em class="cRd1"><%= cTalk.FItemList(i).FCommCnt %></em>개의 코멘트 보기</h4>
						<% Else %>
							<h4><a href="" onClick="fnOpenModal('/gift/gifttalk/talk_view.asp?talkidx=<%=cTalk.FItemList(i).FTalkIdx%>&wagubun=w'); return false;">코멘트 쓰기</a></h4>
						<% End if %>
						<div id="comment<%= cTalk.FItemList(i).FTalkIdx %>" class="cmtWrap">
						</div>
					</div>
				</div>
			</div>
		<% End If %>
	<% End If %>
	
	<% if i = cTalk.FResultCount-1 then %>
		<script type="text/javascript">
			mygiftfrm.beforepageminidx.value="<%= cTalk.FItemList(i).FTalkIdx %>"
		</script>
	<% End If %>

	<% Next %>
<% End If %>

<% SET cTalk = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->
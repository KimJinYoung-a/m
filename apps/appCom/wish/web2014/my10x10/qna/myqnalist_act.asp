<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 1:1 상담
' History : 2015.05.27 이상구 생성
'			2016.03.25 한용민 수정(문의분야 모두 DB화 시킴)
'###########################################################
%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<% const MenuSelect = "" %>
<!-- #include virtual="/apps/appCom/wish/web2014/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/apps/appCom/wish/web2014/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/cscenter/myqnacls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/designfingers/designfingersCls.asp" -->
<!-- #include virtual="/lib/classes/designfingers/dfCommentCls.asp" -->
<%
dim page, i, j, lp, currEvalPoint, tmpqadivname
	page = request("page")

if (page = "") then page = 1

dim boardqna
set boardqna = New CMyQNA
	boardqna.FCurrPage = page
	boardqna.FPageSize = 10
	boardqna.FScrollCount = 3
	
	if IsUserLoginOK() then
	    boardqna.FRectUserID = getEncLoginUserID()
	elseif IsGuestLoginOK() then
	    boardqna.FRectOrderSerial = GetGuestLoginOrderserial()
	end if
	
	if (IsUserLoginOK() or IsGuestLoginOK()) then
		boardqna.GetMyQnaList
	end if

%>

<%
if boardqna.FResultCount < 1 then
	if page = "1" then
%>
		<script>$("#myqnanodata").show();</script>
<%
	end if
Else
%>
	<ul class="myQnaList inquiry-list">
		<%
		for i = 0 to (boardqna.FResultCount - 1)

		if isarray(split(boardqna.FItemList(i).fqadivname,"!@#")) then
			if ubound(split(boardqna.FItemList(i).fqadivname,"!@#")) > 0 then
				tmpqadivname =  split(boardqna.FItemList(i).fqadivname,"!@#")(1)
			end if
		end if
		%>
		<li>
			<div class="type">
				<span class="ftLt fs11"><%= tmpqadivname %></span>
				<span class="ftRt"><%=Formatdate(boardqna.FItemList(i).Fregdate,"0000.00.00")%></span>
			</div>
			<div class="q <%=chkiif(boardqna.FItemList(i).Freplyuser <> "","isA","")%>">
				<p class="tit"><%= nl2br(stripHTML(boardqna.FItemList(i).Ftitle)) %></p>
				<div><%= nl2br(stripHTML(boardqna.FItemList(i).Fcontents)) %></div>
				<p class="btnWrap">
					<span class="button btS2 btWht cBk1"><a href="javascript:DelQna('<%= boardqna.FItemList(i).Fid %>');">삭제</a></span>
				</p>
			</div>
			<% if (boardqna.FItemList(i).Freplyuser <> "") then %>
			<div class="a">
				<div><%= nl2br(stripHTML(boardqna.FItemList(i).Freplytitle)) %><br><br><%= nl2br(stripHTML(boardqna.FItemList(i).Freplycontents)) %></div>
			</div>
			<% End If %>
			<%
			IF boardqna.FItemList(i).Freplydate<>"" and boardqna.FItemList(i).Freplydate>"2008-07-18" Then
				If boardqna.FItemList(i).Fevalpoint = "5" Or boardqna.FItemList(i).Fevalpoint = "0" Or boardqna.FItemList(i).Fevalpoint = "" Then
					currEvalPoint = 5
				else
					currEvalPoint = boardqna.FItemList(i).Fevalpoint
				end if
			%>
			<form name="teneval_<%= page %>_<%= i %>" action="myqna_process.asp" method="post">
				<input type="hidden" name="mode" value="PNT">
				<input type="hidden" name="id" value="<%= boardqna.FItemList(i).Fid %>">
				<input type="hidden" name="md5key" value="<%'= boardqna.FItemList(i).Fmd5Key %>">
				<input type="hidden" name="evalPoint" value="<%= currEvalPoint %>" id="evalPoint">
			</form>
			<div class="starRating">
				<p>만족스러운 답변이 되셨나요?<br />별을 터치하여 별점을 매겨주세요.</p>
				<div class="score" id="score_<%= page %>_<%= i %>">
					<span class="<% if (currEvalPoint >= 1) then %>on<% end if %>"></span>
					<span class="<% if (currEvalPoint >= 2) then %>on<% end if %>"></span>
					<span class="<% if (currEvalPoint >= 3) then %>on<% end if %>"></span>
					<span class="<% if (currEvalPoint >= 4) then %>on<% end if %>"></span>
					<span class="<% if (currEvalPoint >= 5) then %>on<% end if %>"></span>
				</div>
				<% IF (boardqna.FItemList(i).FEvalPoint="0" or isnull(boardqna.FItemList(i).FEvalPoint)) Then %>
				<script>
				$('#score_<%= page %>_<%= i %> span').each(function(index){
					$(this).on('click', function(){
						$('#score_<%= page %>_<%= i %> span').addClass('on');
						$('#score_<%= page %>_<%= i %> span:gt('+index+')').removeClass('on');
						var rate = index+1;
						teneval_<%= page %>_<%= i %>.evalPoint.value = rate;
						return false;
					});
				});
				</script>
				<span class="button btM2 btRed cWh1"><a href="javascript:teneval_<%= page %>_<%= i %>.submit();">평가하기</a></span>
				<% else %>
				<span class="button btM2 btGry2 cWh1"><em>평가완료</em></span>
				<% end if %>
			</div>
			<% End If %>
		</li>
		<% Next %>
	</ul>
<% End If %>

<%
set boardqna = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->

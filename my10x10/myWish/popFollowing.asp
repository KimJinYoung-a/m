<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/login/checkLogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/wish/WishCls.asp" -->
<%

	Dim vErrBackLocationUrl
	dim userid, i
	userid = requestCheckVar(Request("uid"),200)

	'// userid Decoding
	userid = tenDec(userid)

	if userid="" then userid=getEncLoginUserID

Dim oDoc,iLp, TotalCnt
Set oDoc = new CAutoWish
	oDoc.FuserID = userid
	oDoc.FTargetUserID = getEncLoginUserID
	oDoc.GetWishFollowingList
	TotalCnt = oDoc.FResultCount


%>
<script>
function FIDAjaxPopFollower(uid, tid)
{
	var sgubunpopFollower;
	var sUrlpopFollower;

	sgubunpopFollower = $("#SpanChg-"+tid).text().trim();

	if (sgubunpopFollower=="팔로우")
	{
		sgubunpopFollower = "ins";
	}
	else if (sgubunpopFollower=="팔로잉")
	{
		sgubunpopFollower = "del";
	}
	sUrlpopFollower = "/my10x10/mywish/FFInsDelProcessAjax.asp?Fuid="+uid+"&Tuid="+tid+"&gubun="+sgubunpopFollower;

	$.ajax({
		url:sUrlpopFollower,
		cache:false,
		success : function(rst) {

			if (rst=="1") {
				$("#SpanTextChg-"+tid).text('팔로잉');
				$("#SpanChg-"+tid).attr("class","button btM2 btRed cWh1");
				$("#emChg-"+tid).attr("class","checkArr");
				fnAPPopenerJsCall("location.reload()");
			}
			else if (rst=="2") {
				$("#SpanTextChg-"+tid).text('팔로우');
				$("#SpanChg-"+tid).attr("class","button btM2 btWht cBk1");
				$("#emChg-"+tid).attr("class","plusArr");
				fnAPPopenerJsCall("location.reload()");
			}
			else if (rst=="3") {
				alert('오류가 발생하였습니다. 고객센터로 문의해 주시기 바랍니다.');
				return;
			}

		}
		,error: function(err) {
			alert(err.responseText);
		}
	});
}
</script>
<div class="layerPopup">
	<div class="popWin">
		<div class="header">
			<h1>팔로잉</h1>
			<p class="btnPopClose"><button type="button" class="pButton" onclick="location.reload();">닫기</button></p>
		</div>
		<!-- content area -->
		<div class="content" id="layerScroll">
			<div id="scrollarea">
				<ul class="followList">
				<% IF oDoc.FResultCount >0 then %>
					<%
					For i=0 To TotalCnt-1

					IF (i <= TotalCnt-1) Then
				%>
					<li>
						<div class="wishProfile">
							<a href="/my10x10/myWish/myWish.asp?ucid=<%=Server.UrlEncode(tenEnc(oDoc.FWishPrdList(i).Fuserid))%>"><%' 클릭시 프로필 페이지로 이동 %>
								<p><img src="<%=GetUserProfileImg(oDoc.FWishPrdList(i).FUserIconNo, oDoc.FWishPrdList(i).Fuserid)%>" alt=""></p>
								<% If oDoc.FWishPrdList(i).FFavCount <> "0" Then %>
									<span class="mateView"><em><%=oDoc.FWishPrdList(i).FFavCount%></em></span>
								<% End If %>
								<p class="userId">
								<% If oDoc.FWishPrdList(i).Fuserid = getEncLoginUserID Then 
											response.write getEncLoginUserID 
									  Else 
											response.write printUserId(oDoc.FWishPrdList(i).Fuserid,2,"*") 
									  End If
								%>
								</p>

							</a>
						</div>
							<% If getEncLoginUserID=oDoc.FWishPrdList(i).Fuserid Then %>
							<% Else %>
								<span class="button btM2 <% If IsNull(oDoc.FWishPrdList(i).FisMyWishChk) Or oDoc.FWishPrdList(i).FisMyWishChk="" Then %>btWht cBk1<%else%>btRed cWh1<% End If %>" id="SpanChg-<%=oDoc.FWishPrdList(i).Fuserid%>"><a href="#" onclick="FIDAjaxPopFollower('<%=getEncLoginUserID%>','<%=oDoc.FWishPrdList(i).Fuserid%>');"><em class="<% If IsNull(oDoc.FWishPrdList(i).FisMyWishChk) Or oDoc.FWishPrdList(i).FisMyWishChk="" Then %>plusArr<% Else %>checkArr<% End If %>" id="emChg-<%=oDoc.FWishPrdList(i).Fuserid%>"></em><span id="SpanTextChg-<%=oDoc.FWishPrdList(i).Fuserid%>"><% If IsNull(oDoc.FWishPrdList(i).FisMyWishChk) Or oDoc.FWishPrdList(i).FisMyWishChk="" Then %>팔로우<% Else %>팔로잉</span><%End If %></a></span>
							<% End If %>
					</li>
					<% End IF %>
					<% Next %>
				<% end if %>
				</ul>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>
<% Set oDoc = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->
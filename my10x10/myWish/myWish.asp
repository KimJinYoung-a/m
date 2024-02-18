<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/login/checkLogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/wish/WishCls.asp" -->
<!-- #include virtual="/lib/util/badgelibUTF8.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
'해더 타이틀
strHeadTitleName = "위시"

	Dim vUserId	: vUserId = requestCheckVar(request("ucid"),400)
	Dim vUid, arrBadgeList, i, badgeDispNo, badgeObtainYN, badgeTitle, isViewingChk, vFIdx
	Dim PageSize	: PageSize = getNumeric(requestCheckVar(request("psz"),9))
	Dim CurrPage 	: CurrPage = getNumeric(requestCheckVar(request("cpg"),9))
	Dim vtFIdx 	: vtFIdx = getNumeric(requestCheckVar(request("fIdx"),9))
	Dim viewListGubun : viewListGubun = requestCheckVar(request("vlg"),9)


	If CurrPage="" Then CurrPage=1
	If PageSize="" Then PageSize = 29

	'// vUserId Decoding
	vUserId = tenDec(vUserId)
	isViewingChk = False
	
	'// vUserID값이 없거나 로그인 아이디와 동일할 경우 자신의 프로필을 띄워준다.
	If Trim(vUserId)=getEncLoginUserID() Or Trim(vUserId)="" Then
		vUserId = getEncLoginUserID()
		isViewingChk = True
	End If


	If Trim(viewListGubun) = "" Then
		If isViewingChk Then
			viewListGubun = "flist"
		Else
			viewListGubun = "wlist"
		End If
	End If



	'// 뱃지값 가져오기
	'뱃지목록 Get
	arrBadgeList = MyBadge_MyBadgeList(vUserId)
	dim totalObtainBadgeCount : totalObtainBadgeCount = 0
	dim firstObtainBadgeIdx : firstObtainBadgeIdx = 0
	IF isArray(arrBadgeList) THEN
		for i = 0 to UBound(arrBadgeList,2)
			if (arrBadgeList(2,i) = "Y") Then
				'내가 취득한 총 뱃지 수
				totalObtainBadgeCount = totalObtainBadgeCount + 1
				'초기 뱃지 표시
				if (firstObtainBadgeIdx = 0) then firstObtainBadgeIdx = arrBadgeList(4,i)
			Else
				if (vUserId = "10x10green") and (i < 12) then
					totalObtainBadgeCount = totalObtainBadgeCount + 1
				End If

			end if
		next
	end If

Dim oDoc, FollowingCnt, FollowerCnt, WishPrdCnt, WishMatchingCnt, UserProfileImg, FollowerChk, TotalCnt

'// 팔로잉 유저 카운트
Set oDoc = new CAutoWish
	oDoc.FuserID				= vUserid
	oDoc.GetWishFollowingCnt
		FollowingCnt = oDoc.FFollowingCnt
Set oDoc = Nothing

'// 팔로워 유저 카운트
Set oDoc = new CAutoWish
	oDoc.FuserID				= vUserid
	oDoc.GetWishFollowerCnt
		FollowerCnt = oDoc.FFollowerCnt
Set oDoc = Nothing

'// 팔로워 체크
Set oDoc = new CAutoWish
	oDoc.FuserID = getEncLoginUserID()
	oDoc.FTargetUserID = vUserID
	oDoc.GetWishFollowerChk
		FollowerChk = oDoc.FFollowerChk
Set oDoc = Nothing

'// 내 위시상품 갯수
Set oDoc = new CAutoWish
	oDoc.FuserID				= vUserid
	oDoc.FFvUChk				= isViewingChk
	oDoc.GetWishPrdCnt
		WishPrdCnt = oDoc.FchkResult
		UserProfileImg = oDoc.FUserIconNo
Set oDoc = Nothing


'// 위시 매치 카운트
Set oDoc = new CAutoWish
	oDoc.FuserID = getEncLoginUserID()
	oDoc.FTargetUserID = vUserID
	oDoc.GetWishMatchingCnt
		WishMatchingCnt = oDoc.FchkResult
Set oDoc = Nothing


%>
<title>10x10: My Wish</title>
<style type="text/css">
.myWish {padding-bottom:2.56rem;}
.btn-top {bottom:5.88rem;}
@media only screen and (device-width : 375px) and (device-height : 812px) and (-webkit-device-pixel-ratio : 3) {
	.myWish {padding-bottom:4.27rem;}
	.btn-top {bottom:94px;}
}
</style>
<script>
$(function() {
	$('.wishCollectList li:nth-child(1)').addClass('big');
	$('.wishCollectList li:nth-child(8)').addClass('big');
	$('.wishCollectList li:nth-child(10n+1)').addClass('big');
	$('.wishCollectList li:nth-child(10n+8)').addClass('big');
	$('.wishCollectList li:nth-child(8)').addClass('ftRt');
	$('.wishCollectList li:nth-child(10n+8)').addClass('ftRt');


	$('img').load(function(){
		var thumb2H = $('.wishFolderList li:nth-child(2)').height();
		$('.wishFolderList li.subTit').css('height', thumb2H+'px');

		var thumbH = $('.wishCollectList li:nth-child(3)').height();
		$('.wishCollectList li.subTit').css('height', thumbH*2+'px');
	});
	var thumb2H = $('.wishFolderList li:nth-child(2)').height();
	$('.wishFolderList li.subTit').css('height', thumb2H+'px');
	var thumbH = $('.wishCollectList li:nth-child(3)').height();
	$('.wishCollectList li.subTit').css('height', thumbH*2+'px');

	<% If isViewingChk Then %>
		// Top버튼 위치 이동
		$(".goTop").addClass("topHigh");
	<% end if %>


	$('.wishCollectList li').click(function(e){
		if ($("#md").css("display")=="none")
		{
			e.preventDefault();
			$(this).toggleClass("selected");
		}
	});

	$('.wishEditBtn').click(function(e){
		if ($("#vlg").val()=="flist")
		{
			e.preventDefault();
			top.location.href='/common/popWishFolder.asp?vWUserId=<%=vUserId%>&ErBValue=8';
		}
		else
		{
			if ($(this).attr("id")=="md")
			{

				$("#md").css("display","none");
				$("#de").css("display","");
				$("#mo").css("display","");
				$("#cn").css("display","");
				e.preventDefault();
				$('.wishCollectList li').prepend('<span></span>');
			}
			else if ($(this).attr("id")=="cn")
			{
				$("#md").css("display","");
				$("#de").css("display","none");
				$("#mo").css("display","none");
				$("#cn").css("display","none");
				e.preventDefault();
				$('.wishCollectList li span').remove();
				$('.wishCollectList li').removeClass('selected');
			}
			else if ($(this).attr("id")=="de")
			{
				var itemSplitData;
				e.preventDefault();
				$('.wishCollectList .selected').each(function(){

					itemSplitData = $(this).attr("value")+","+itemSplitData;
				});
				if (typeof itemSplitData=="undefined")
				{
					alert("삭제할 위시를 선택해주세요.");
					return;
				}
				itemSplitData = itemSplitData.replace(/,undefined/g,"");

				if (confirm("선택하신 위시를 삭제하시겠습니까?")==true){
					$("#itemsplitdata").val(itemSplitData);
					document.frmDelWishList.action="DelWishPrdList.asp";
					document.frmDelWishList.submit();

				}
				else {
					return;
				}
			}
			else if ($(this).attr("id")=="mo")
			{
				var itemSplitData;
				e.preventDefault();
				$('.wishCollectList .selected').each(function(){

					itemSplitData = $(this).attr("value")+","+itemSplitData;
				});
				if (typeof itemSplitData=="undefined")
				{
					alert("이동할 위시상품을 선택해주세요.");
					return;
				}
				itemSplitData = itemSplitData.replace(/,undefined/g,"");

				if (confirm("선택하신 위시를 이동하시겠습니까?")==true){
					$("#bagarray").val(itemSplitData);
					document.frmModifyFolder.action="/common/popWishFolder.asp";
					document.frmModifyFolder.submit();
				}
				else {
					return;
				}

			}
		}
	});
});

function FollowInsertDeleteAjax(uid, tid)
{
	var sgubun;
	sgubun = $("#FollowText").text().trim();

	$("#Fuid").val(uid);
	$("#Tuid").val(tid);
	if (sgubun=="팔로우") {
		$("#gubun").val("ins");
	} else if (sgubun=="팔로잉") {
		$("#gubun").val("del");
	}

	$.ajax({
		type:"GET",
		url:"FFInsDelProcessAjax.asp",
        data: $("#popFollowerID").serialize(),
        dataType: "text",
		async:false,
		cache:true,
		success : function(Data, textStatus, jqXHR){
			if (jqXHR.readyState == 4) {
				if (jqXHR.status == 200) {
					if(Data!="") {
						if (Data=="3") {
							alert('오류가 발생하였습니다. 고객센터로 문의해 주시기 바랍니다.');
							return;
						}
						// 팔로잉 처리 이후가 없어서 일단 이것과 하단에 A링크에 return false 만 넣어놨심돠~ (20140929; 허진원)
						// alert("뭘하지? 새로고침? 그래!");
						location.reload();
						// -->
					} else {
						alert('오류가 발생하였습니다. 고객센터로 문의해 주시기 바랍니다.');
						return;
					}
				}
			}
		},
		error:function(jqXHR, textStatus, errorThrown){
		}
	});
}

<%'popFollower.asp에서 쓰는 펑션%>
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
			}
			else if (rst=="2") {
				$("#SpanTextChg-"+tid).text('팔로우');
				$("#SpanChg-"+tid).attr("class","button btM2 btWht cBk1");
				$("#emChg-"+tid).attr("class","plusArr");
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

function goPage(pg){
	var frm = document.frmmywish;
	frm.cpg.value=pg;
	frm.submit();
}

</script>
</head>
<body>
<form id="popFollowerID" name="popFollowerID" method="get" style="margin:0px;">
	<input type="hidden" name="Fuid" id="Fuid">
	<input type="hidden" name="Tuid" id="Tuid">
	<input type="hidden" name="gubun" id="gubun">
</form>
<form id="frmDelWishList" name="frmDelWishList" method="post">
	<input type="hidden" name="duid" id="duid" value="<%=vUserId%>">
	<input type="hidden" name="dcpg" id="dcpg" value="<%=CurrPage%>">
	<input type="hidden" name="dfIdx" id="dfIdx" value="<%=vtFIdx%>">
	<input type="hidden" name="dvlg" id="dvlg" value="<%=viewListGubun%>">
	<input type="hidden" name="itemsplitdata" id="itemsplitdata">
</form>
<form id="frmModifyFolder" name="frmModifyFolder" method="post">
	<input type="hidden" name="mfuid" id="mfuid" value="<%=vUserId%>">
	<input type="hidden" name="mfcpg" id="mfcpg" value="<%=CurrPage%>">
	<input type="hidden" name="mffIdx" id="mffIdx" value="<%=vtFIdx%>">
	<input type="hidden" name="mfvlg" id="mfvlg" value="<%=viewListGubun%>">
	<input type="hidden" name="bagarray" id="bagarray">
	<input type="hidden" name="folderAction" id="folderAction" value="Change">
</form>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
				<div class="myWish">
					<div class="myBox">
						<p class="pvtId"><%If isViewingChk Then response.write vUserId Else response.write printUserId(vUserId, 2, "*") End If %></p>
						<div class="pvtImgWrap">
							<div class="pvtImg"><img src="<%=GetUserProfileImg(UserProfileImg, vUserId)%>" alt="" /></div><%' 로그인 후엔 고객이 지정한 이미지 불려집니다(thumb_member01.png~thumb_member30.png) %>
							<% If vUserId <> getEncLoginUserID() Then %>
								<p class="circleBtn mateView">
									<% if WishMatchingCnt>0 then %>
									<a href="/my10x10/myWish/MateSelectList.asp?uid=<%=Server.Urlencode(tenEnc(vUserId))%>">
									<% else %>
									<a href="" onclick="return false;">
									<% end if %>
										<span><%=FormatNumber(WishMatchingCnt, 0)%></span>
										<span>메이트</span>
									</a>
								</p>
								<p class="circleBtn followView <% If Trim(FollowerChk)="1" Then %>following<% End If %>">
									<a href="" onclick="FollowInsertDeleteAjax('<%=getEncLoginUserID()%>','<%=vUserId%>'); return false;">
										<% If Trim(FollowerChk)="1" Then %>
											<span class="ico"></span>
										<% Else %>
											<span>+</span>
										<% End If %>
										<span id="FollowText"><% If Trim(FollowerChk)="1" Then %>팔로잉<% Else %>팔로우<% End If %></span>
									</a>
								</p>
							<% End If %>
							<ul class="myBadgeView">
								<a href="" onclick="fnOpenModal('/my10x10/myWish/popBadge.asp?uid=<%=Server.UrlEncode(tenEnc(vUserId))%>'); return false;">
								<%
									for i = 0 to UBound(arrBadgeList,2)
										If i>3 Then 
											Exit For
										End If

										IF isArray(arrBadgeList) THEN
											if (UBound(arrBadgeList,2) < i) Then
												badgeDispNo = "00"
												badgeObtainYN = "N"
											Else
												badgeDispNo = arrBadgeList(0,i)
												badgeObtainYN = arrBadgeList(2,i)
												badgeTitle = arrBadgeList(1,i)
								
												if (vUid = "10x10green") and (i < 12) then
													'// 테스트 계정은 전부 표시
													badgeObtainYN = "Y"
												end If
											End If
										Else
											badgeDispNo = "0"
										End If

										If totalObtainBadgeCount > 0 Then
											If badgeObtainYN="Y" Then
								%>
									<li><div><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_white_badge<%=Num2Str(badgeDispNo, 2, "0", "R")%>.png" alt="<%=badgeTitle%>" /></div></li>
								<%
											End If
										End If
									Next
								%>
								<% If totalObtainBadgeCount > 0 Then %>
									<% If totalObtainBadgeCount > 4 Then %>
										<li><div>+<%=CInt(totalObtainBadgeCount-4)%></div></li>
									<% Else %>
										<li><div>+0</div></li>
									<% End If %>
								<% End If %>
								</a>
							</ul>
						</div>
						<ul class="myWishFollow">
							<li>
								<p><%=FormatNumber(WishPrdCnt, 0)%></p> <span>위시</span>
							</li>
							<li>
								<a href="" onclick="fnOpenModal('/my10x10/myWish/popFollower.asp?uid=<%=Server.UrlEncode(tenEnc(vUserId))%>'); return false;">
									<p id="followCnt"><%=FormatNumber(FollowerCnt, 0)%></p> <span>팔로워</span>
								</a>
							</li>
							<li>
								<a href="" onclick="fnOpenModal('/my10x10/myWish/popFollowing.asp?uid=<%=Server.UrlEncode(tenEnc(vUserId))%>'); return false;">
									<p><%=FormatNumber(FollowingCnt, 0)%></p> <span>팔로잉</span>
								</a>
							</li>
						</ul>
					</div>
					<% If Now() >= #12/14/2015 00:00:00# AND Now() < #12/21/2015 00:00:00# Then %>
						<p><a href="/event/eventmain.asp?eventid=67490" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67490/m/bnr_wish.png" alt="크리스마스 위시 이벤트 확인하러 가기" /></a></p>
					<% End if %>

					<% If Now() >= #02/10/2016 10:00:00# AND Now() < #02/15/2016 00:00:00# Then %>
						<p class="tMar15"><a href="/event/eventmain.asp?eventid=68889" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68889/m/bnr.png" alt="새해 위시 이벤트 오늘은 WISH를 털날" /></a></p>
					<% End if %>
					
					<% If Trim(viewListGubun) = "" Or Trim(viewListGubun)="wlist" Then %>
						<!-- #include virtual="/my10x10/mywish/inc_pWishList.asp" -->

					<% ElseIf Trim(viewListGubun)="flist" Then %>
						<!-- #include virtual="/my10x10/mywish/inc_folderList.asp" -->
					<% Else %>
						<!-- #include virtual="/my10x10/mywish/inc_pWishList.asp" -->
					<% End If %>
				</div>
			</div>
	
			<!-- //content area -->
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
<form name="frmmywish" method="get" action="myWish.asp">
	<input type="hidden" name="ucid" id="ucid" value="<%=tenEnc(vUserId)%>">
	<input type="hidden" name="cpg" value="<%=CurrPage%>">
	<input type="hidden" name="fIdx" value="<%=vtFIdx%>">
	<input type="hidden" name="vlg" id="vlg" value="<%=viewListGubun%>">
</form>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	Description : 상품상세정보 보기
'	History	: 2014-08-19 이종화 생성
'           : 2014-09-17 허진원 2014 하반기 리뉴얼
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	dim itemid	: itemid = requestCheckVar(request("itemid"),9)

	if itemid="" then
		Call Alert_Return("상품번호가 없습니다.")
		response.End
	elseif Not(isNumeric(itemid)) then
		Call Alert_Return("잘못된 상품번호입니다.")
		response.End
	else
		'정수형태로 변환
		itemid=CLng(itemid)
	end if

	dim oItem, ItemContent, itemVideos
	set oItem = new CatePrdCls
	oItem.GetItemData itemid

	'// 추가 이미지
	dim oADD, i
	set oADD = new CatePrdCls
	oADD.getAddImage itemid
	
	function ImageExists(byval iimg)
		if (IsNull(iimg)) or (trim(iimg)="") or (Right(trim(iimg),1)="\") or (Right(trim(iimg),1)="/") then
			ImageExists = false
		else
			ImageExists = true
		end if
	end Function

	'## 설명이미지 표시 (1순위:모바일상품설명이미지, 2순위:캡쳐 이미지, 3순위: html이미지+상품설명이미지)
	dim itemContImg, tmpExtImgArr, mtmpAddImgChk, vCaptureExist, adjs, isUseCaptureView, VCaptureImgArr

	adjs = 0
	mtmpAddImgChk = False
	isUseCaptureView = False
	
	'추가이미지
	IF oAdd.FResultCount > 0 THEN
		FOR i= 0 to oAdd.FResultCount-1
			IF oAdd.FADD(i).FAddImageType=2 Then
				If oAdd.FADD(i).FIsExistAddimg Then
					mtmpAddImgChk = True
					If adjs > 0 Then
						itemContImg = itemContImg & "<img data-original='"&oAdd.FADD(i).FAddimage&"' border='0' style='width:100%;' class='lazy'>"
					Else
						itemContImg = itemContImg & "<img src='"&oAdd.FADD(i).FAddimage&"' border='0' style='width:100%; height:auto;'>"
					End If
					adjs = adjs + 1
				End If
			End If
		NEXT
	end If
	
	'캡쳐이미지
	oItem.sbDetailCaptureViewCount itemid
	vCaptureExist = oItem.FCaptureExist

	If vCaptureExist = "1" Then
		isUseCaptureView = true
		VCaptureImgArr = oItem.sbDetailCaptureViewImages(itemid)
	End If


	
	'// 상품상세설명 동영상 추가
	Set itemVideos = New catePrdCls
		itemVideos.fnGetItemVideos itemid, "video1"
%>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=2.0">
<meta name="format-detection" content="telephone=no" />
<link rel="stylesheet" type="text/css" href="/lib/css/default.css">
<link rel="stylesheet" type="text/css" href="/lib/css/common.css">
<link rel="stylesheet" type="text/css" href="/lib/css/content.css">
<script type="text/javascript" src="/lib/js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="/lib/js/common.js"></script>
<script type="text/javascript" src="/lib/js/jquery.lazyload.min.js"></script>
<script type="text/javascript">
$(function(){
	$('#itemContView').find("img").css("width","100%");
    $("img.lazy").lazyload().removeClass("lazy");
});
</script>
</head>
<body class="body-popup">
<header class="tenten-header header-popup">
	<div class="title-wrap">
		<h1>상품상세 보기</h1>
		<% if itemid = "2011257" or itemid = "533652" or itemid = "1726677" or itemid = "635081" then '//상품상세 PlusSale testitem %>
		<button type="button" class="btn-close" onclick="window.close();">닫기</button>
		<% else %>		
		<button type="button" class="btn-close" onclick="goBack('<%=wwwUrl%>/category/category_itemprd.asp?itemid=<%=itemid%>'); return false;">닫기</button>
		<% end if %>
	</div>
</header>
<!-- content area -->
<div class="content" id="content">
	<div class="detailViewArea" id="itemContView">
		<% If mtmpAddImgChk Then %>
			<%' 모바일 상품상세 이미지 %>
			<%=itemContImg%>
		<% ElseIf ((isUseCaptureView)) Then %>				
			<%' 캡쳐 이미지%>
			<div class="pdtImgViewV16a">
				<% if isArray(VCaptureImgArr) then %>
					<% for i=0 to UBound(VCaptureImgArr,2) %>
						<% if i<3 then %>
							<img src="<%= VCaptureImgArr(2,i) %>" border="0" style="width:100%; height:auto;" />
						<% else %>
							<img data-original="<%= VCaptureImgArr(2,i) %>" border="0" style="width:100%;" class="lazy" />
						<% end if %>
					<% next %>
				<% end if %>
			</div>

		<% Else %>
			<%
				ItemContent = oItem.Prd.FItemContent

				'링크는 새창으로
				ItemContent = Replace(ItemContent,"<a ","<a target='_blank' ")
				ItemContent = Replace(ItemContent,"<A ","<A target='_blank' ")
				'높이태그 제거
				ItemContent = Replace(ItemContent,"height=","h=")
				ItemContent = Replace(ItemContent,"HEIGHT=","h=")
				'너비태그 제거
				ItemContent = Replace(ItemContent,"width=","w=")
				ItemContent = Replace(ItemContent,"WIDTH=","w=")

				'// 태그 중복 제거
				ItemContent = Replace(ItemContent,">>",">")
				ItemContent = Replace(ItemContent,"<<","<")

				IF oItem.Prd.FUsingHTML="Y" THEN
					Response.write ItemContent
				ELSEIF oItem.Prd.FUsingHTML="H" THEN
					Response.write nl2br(ItemContent)
				ELSE
					Response.write nl2br(stripHTML(ItemContent))
				END IF
			%>
			<% '// 강제 width값 100% table%>
			<script>
				(function(){
					var $contents = $("#itemContView");
					$contents.find("table").css("width","100%");
					$contents.find("div").css("width","100%");
				})(jQuery);
			</script>
			<% IF oAdd.FResultCount > 0 THEN %>
				<% FOR i= 0 to oAdd.FResultCount-1  %>
					<%IF oAdd.FADD(i).FAddImageType=1 AND oAdd.FADD(i).FIsExistAddimg THEN %>
						<img src="<%= oAdd.FADD(i).FAddimage %>" border="0" style="width:100%; height:auto;" />
					<%End IF %>
				<% NEXT %>
			<% END IF %>
			<% if ImageExists(oItem.Prd.FImageMain) then %>
				<img src="<% = oItem.Prd.FImageMain %>" border="0" style="width:100%; height:auto;" />
			<% end if %>
			<% if ImageExists(oItem.Prd.FImageMain2) then %>
				<img src="<% = oItem.Prd.FImageMain2 %>" border="0" style="width:100%; height:auto;" />
			<% end if %>
			<% if ImageExists(oItem.Prd.FImageMain3) then %>
				<img src="<% = oItem.Prd.FImageMain3 %>" border="0" style="width:100%; height:auto;" />
			<% end if %>
		<% End If %>
		<%'// 상품상세설명 동영상 추가 %>
		<% If Not(itemVideos.Prd.FvideoFullUrl="") Then %>
			<center>
				<p>&nbsp;</p>
				<iframe class="youtube-player" type="text/html" width="320" height="180" src="<%=itemVideos.Prd.FvideoUrl%>" frameborder="0"></iframe>
			</center>
		<% End If %>
	</div>
	<!--span id="gotop" class="goTop">TOP</span-->
	<div id="gotop" class="btn-top"><button type="button">맨위로</button></div>
</div>
<!-- //content area -->
</body>
</html>
<%
	Set oItem = Nothing
	Set oADD = Nothing
	Set itemVideos = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
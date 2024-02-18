<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	Description : 상품상세정보 보기
'	History	:  2014.06.12 허진원 생성
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/web2014/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/ItemOptionCls.asp" -->
<!-- #include virtual="/lib/classes/item/sp_evaluatesearchercls.asp" -->
<!-- #include virtual="/lib/classes/item/sp_item_qnacls.asp" -->
<!-- #include virtual="/lib/classes/item/PlusSaleItemCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
    Dim isUseCaptureView : isUseCaptureView = false
    
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

	dim oItem, ItemContent, vCaptureExist, VCaptureImgArr, itemVideos
	set oItem = new CatePrdCls
	oItem.GetItemData itemid
	
	'### 상품 VIEW Count Plus
	oItem.sbDetailCaptureViewCount itemid
	vCaptureExist = oItem.FCaptureExist

    ''캡쳐로 보여줄지 분기
    if ((vCaptureExist="1")) then ''(flgDevice="A") and 
        isUseCaptureView = true
        VCaptureImgArr = oItem.sbDetailCaptureViewImages(itemid)
    end if
    
    if (getLoginUserid="icommang") then
        'isUseCaptureView = false
    end if
    
	'// 추가 이미지
	dim oADD, i
	set oADD = new CatePrdCls
	Set itemVideos = New catePrdCls '// 상품상세설명 동영상 추가
	itemVideos.fnGetItemVideos itemid, "video1"	 '// 상품상세설명 동영상 추가
	
	if (Not isUseCaptureView) then ''캡쳐뷰면 쿼리 안함.
	    oADD.getAddImage itemid
    end if
	
	function ImageExists(byval iimg)
		if (IsNull(iimg)) or (trim(iimg)="") or (Right(trim(iimg),1)="\") or (Right(trim(iimg),1)="/") then
			ImageExists = false
		else
			ImageExists = true
		end if
	end function

	'// 동영상 아이디 추출
	Dim tmpvideonum, videonumValue
	If Trim(itemVideos.Prd.FvideoUrl)<>"" Then
		tmpvideonum = Split(itemVideos.Prd.FvideoUrl,"/")
		If InStr(tmpvideonum(ubound(tmpvideonum)), "?") > 0 Then
			videonumValue = mid(tmpvideonum(ubound(tmpvideonum)), 9, 100)
		Else
			videonumValue = tmpvideonum(ubound(tmpvideonum))
		End If
	End If	
	
%>
<% IF (isUseCaptureView) then %>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="user-scalable=yes, initial-scale=1.0, minimum-scale=1.0, maximum-scale=2.0, width=device-width">
<meta name="format-detection" content="telephone=no" />
<title>10X10: <%= oItem.Prd.FItemName %></title>
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/common.css">
<!-- link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/content.css" -->
<script type="text/javascript" src="/lib/js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="/lib/js/common.js"></script>
<script type="text/javascript" src="/lib/js/jquery.lazyload.min.js"></script>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js"></script>
<script type="text/javascript">
$(function(){
	//$('#itemContView').find("img").css("width","100%");
	
	// 순차 로딩
	<% if (flgDevice="A") then %>
	    $("img.lazy").lazyload().removeClass("lazy");
	<% else %>
	    $("img.lazy").lazyload({threshold : 900});
    <% end if %>


	<%'// 상품상세설명 동영상 추가 %>
	<% If Not(itemVideos.Prd.FvideoFullUrl="") Then %>
		<% if itemVideos.Prd.FvideoType="vimeo" then %>
			<%'// 킷캣일 경우에만 새창호출
				If InStr(Lcase(Request.ServerVariables("HTTP_USER_AGENT")),"android 4.4")>0 Then
			%>
				$.ajax({
					type:'GET',
					url: 'http://vimeo.com/api/v2/video/<%=videonumValue%>.json',
					jsonp: 'callback',
					dataType: 'jsonp',
					success: function(data){
						var thumbnail_src = data[0].thumbnail_large;
						$('#thumb_wrapper').empty().html('<img src="' + thumbnail_src + '"/>');
					}
				});
			<% end if %>
		<% end if %>
	<% end if %>


});

</script>
<style>
	.detailMoviewrap {margin:5%;}
	.detailMovie .movieBox {overflow:hidden; position:relative; height:0; padding-bottom:56.25%; background-color:#000;}
	.detailMovie .movieBox .movieControler {overflow:hidden; position:absolute; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.3) url(http://fiximage.10x10.co.kr/m/2016/common/play_controler.png) 50% 50% no-repeat; background-size:37px auto; z-index:2; text-indent:-999em;}
	.detailMovie .movieBox iframe, .detailMovie .movieBox div {position:absolute; top:0; left:0; width:100%; height:100%;}
</style>
</head>
<body>
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div class="content" id="contentArea">
			<div class="detailViewArea" id="itemContView">
			<% if isArray(VCaptureImgArr) then %>
			    <% for i=0 to UBound(VCaptureImgArr,2) %>
			    <% if i<3 then %>
			        <img src="<%= VCaptureImgArr(2,i) %>" border="0" style="width:100%;" />
			    <% else %>
			        <img data-original="<%= VCaptureImgArr(2,i) %>" border="0" style="width:100%;" class="lazy" />
			    <% end if %>
			    <% next %>
			<% end if %>

			<%'// 상품상세설명 동영상 추가 %>
			<% If Not(itemVideos.Prd.FvideoFullUrl="") Then %>
				<%'// 킷캣일 경우에만 새창호출
					If InStr(Lcase(Request.ServerVariables("HTTP_USER_AGENT")),"android 4.4")>0 Then
				%>
					<a href="" onclick="fnAPPpopupExternalBrowser('<%=itemVideos.Prd.FvideoUrl%>');return false;">
						<div class="detailMoviewrap">
							<div class="detailMovie">
								<div class="movieBox">
									<div class="movieControler">play start</div>
									<div id="thumb_wrapper"><img src="https://img.youtube.com/vi/<%=videonumValue%>/0.jpg" /></div>
								</div>
							</div>
						</div>
					</a>
				<% Else %>
					<div class="detailMoviewrap">
						<div class="detailMovie">
							<div class="movieBox">
								<iframe class="youtube-player" type="text/html" src="<%=itemVideos.Prd.FvideoUrl%>" frameborder="0"></iframe>
							</div>
						</div>
					</div>
				<% End If %>
			<% End If %>
			</div>
			<span id="gotop" class="goTop">TOP</span>
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>
<% else %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="user-scalable=yes, initial-scale=1.0, minimum-scale=1.0, maximum-scale=2.0, width=device-width">
<meta name="format-detection" content="telephone=no" />
<title>10X10: <%= oItem.Prd.FItemName %></title>
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/common.css">
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/content.css">
<script type="text/javascript" src="/lib/js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="/lib/js/common.js"></script>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js"></script>
<script type="text/javascript">
$(function(){
	$('#itemContView').find("img").css("width","100%");

	<%'// 상품상세설명 동영상 추가 %>
	<% If Not(itemVideos.Prd.FvideoFullUrl="") Then %>
		<% if itemVideos.Prd.FvideoType="vimeo" then %>
			<%'// 킷캣일 경우에만 새창호출
				If InStr(Lcase(Request.ServerVariables("HTTP_USER_AGENT")),"android 4.4")>0 Then
			%>
				$.ajax({
					type:'GET',
					url: 'http://vimeo.com/api/v2/video/<%=videonumValue%>.json',
					jsonp: 'callback',
					dataType: 'jsonp',
					success: function(data){
						var thumbnail_src = data[0].thumbnail_large;
						$('#thumb_wrapper').empty().html('<img src="' + thumbnail_src + '"/>');
					}
				});
			<% end if %>
		<% end if %>
	<% end if %>

});
</script>
<style>
	.detailMoviewrap {margin:5%;}
	.detailMovie .movieBox {overflow:hidden; position:relative; height:0; padding-bottom:56.25%; background-color:#000;}
	.detailMovie .movieBox .movieControler {overflow:hidden; position:absolute; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.3) url(http://fiximage.10x10.co.kr/m/2016/common/play_controler.png) 50% 50% no-repeat; background-size:37px auto; z-index:2; text-indent:-999em;}
	.detailMovie .movieBox iframe, .detailMovie .movieBox div {position:absolute; top:0; left:0; width:100%; height:100%;}
</style>
</head>
<body>
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div class="content" id="contentArea">
			<div class="detailViewArea" id="itemContView">
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

				IF oItem.Prd.FUsingHTML="Y" THEN
					Response.write ItemContent
				ELSEIF oItem.Prd.FUsingHTML="H" THEN
					Response.write nl2br(ItemContent)
				ELSE
					Response.write nl2br(stripHTML(ItemContent))
				END IF
			%>
			<% IF oAdd.FResultCount > 0 THEN %>
				<% FOR i= 0 to oAdd.FResultCount-1  %>
					<%IF oAdd.FADD(i).FAddImageType=1 AND oAdd.FADD(i).FIsExistAddimg THEN %>
					<img src="<%= oAdd.FADD(i).FAddimage %>" border="0" style="width:100%;" />
					<%End IF %>
				<% NEXT %>
			<% END IF %>
			<% if ImageExists(oItem.Prd.FImageMain) then %>
			<img src="<% = oItem.Prd.FImageMain %>" border="0" style="width:100%;" />
			<% end if %>
			<% if ImageExists(oItem.Prd.FImageMain2) then %>
			<img src="<% = oItem.Prd.FImageMain2 %>" border="0" style="width:100%;" />
			<% end if %>
			<% if ImageExists(oItem.Prd.FImageMain3) then %>
			<img src="<% = oItem.Prd.FImageMain3 %>" border="0" style="width:100%;" />
			<% end if %>

			<%'// 상품상세설명 동영상 추가 %>
			<% If Not(itemVideos.Prd.FvideoFullUrl="") Then %>
				<%'// 킷캣일 경우에만 새창호출
					If InStr(Lcase(Request.ServerVariables("HTTP_USER_AGENT")),"android 4.4")>0 Then
				%>
					<a href="" onclick="fnAPPpopupExternalBrowser('<%=itemVideos.Prd.FvideoUrl%>');return false;">
						<div class="detailMoviewrap">
							<div class="detailMovie">
								<div class="movieBox">
									<div class="movieControler">play start</div>
									<div id="thumb_wrapper"><img src="https://img.youtube.com/vi/<%=videonumValue%>/0.jpg" /></div>
								</div>
							</div>
						</div>
					</a>
				<% Else %>
					<div class="detailMoviewrap">
						<div class="detailMovie">
							<div class="movieBox">
								<iframe class="youtube-player" type="text/html" src="<%=itemVideos.Prd.FvideoUrl%>" frameborder="0"></iframe>
							</div>
						</div>
					</div>
				<% End If %>
			<% End If %>
			</div>
			<span id="gotop" class="goTop">TOP</span>
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>
<% end if %>
<%
	Set oItem = Nothing
	Set oADD = Nothing
	Set itemVideos = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
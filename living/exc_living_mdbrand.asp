<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.charset = "utf-8"
Session.Codepage = 65001
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'#######################################################
' Discription : mobile_main_banner // cache DB경유
' History : 2016-04-27 이종화 생성
'#######################################################
Dim intI ,intJ
Dim sqlStr , arrList
Dim gaParam : gaParam = "&gaparam=living_brand_0" '//GA 체크 변수
Dim CtrlDate : CtrlDate = now()
Dim limitcnt : limitcnt = 0 '//최대 배너 갯수

Dim topcnt : topcnt = 8
Dim userid : userid = getEncLoginUserID

If isapp = "1" Then
	limitcnt = 8 '배열이라 -1개 총 4개 (app 전용 배너)
Else
	limitcnt = 8 '배열이라 -1개 총 4개 (M 전용 배너)
End If

sqlStr = "EXEC [db_sitemaster].[dbo].[usp_WWW_MobileGNB_MDBrand_Get] '"  & userid & "'"
rsget.CursorLocation = adUseClient
rsget.Open sqlStr,dbget,1
	IF Not (rsget.EOF OR rsget.BOF) THEN
		arrList = rsget.GetRows
	END If
rsget.close

on Error Resume Next
intJ = 0
If IsArray(arrList) Then

	Dim BrandID, BrandName, brandIMG, SubCopy, MyBrand
	Dim opttag, link, alink
%>
		<div class="ctgy-brand">
			<h2><small>Living Brand</small>텐바이텐 MD 추천 브랜드</h2>
			<div class="swiper-container">
				<div class="swiper-wrapper">
<%
	For intI = 0 To ubound(arrlist,2)
		opttag = ""
		If intJ > limitcnt Then Exit For '//매뉴별 최대 갯수

		BrandID			= arrlist(0,intI)
		BrandName	= db2Html( arrlist(1,intI))
		brandIMG		= db2Html(arrlist(2,intI))
		SubCopy		= db2Html(arrlist(3,intI))
		MyBrand		= arrlist(4,intI)

		If isapp = "1" Then
			link = "javascript:fnAPPpopupAutoUrl('/street/street_brand.asp?makerid=" + BrandID + "')"
			If InStr(link,"/clearancesale/") > 0 Then
				alink = "fnAmplitudeEventAction('click_living_brand_mainrolling','rollingnumber','"&intJ+1&"', function(bool){if(bool) {fnAPPpopupClearance_URL('"& link & gaparamchk(link,gaParam) & (intJ+1) &"');}});return false;"
			Else
				alink = "fnAmplitudeEventAction('click_living_brand_mainrolling','rollingnumber','"&intJ+1&"', function(bool){if(bool) {fnAPPpopupAutoUrl('"& link & gaparamchk(link,gaParam) & (intJ+1) &"');}});return false;"
			End If
		Else
			link = "/brand/brand_detail2020.asp?brandid=" + Cstr(BrandID)
			alink = link & gaparamchk(link,gaParam) & (intJ+1)
		End If
%>
					<div class="swiper-slide">
						<a href="<%=link%>" onclick="<%=alink%>">
							<div class="thumbnail"><img src="<%=brandIMG%>" alt="<%=BrandName%>" /></div>
							<div class="desc">
								<h3 class="headline"><%=BrandName%></h3>
								<p class="headline">&quot;<%=SubCopy%>&quot;</p>
							</div>
						</a>
						<% If MyBrand>0 Then %>
						<a href="javascript:myzzimbrand('<%=BrandID%>','zzim<%=intI%>');" id="zzim<%=intI%>" class="btn-zzim ziim-on">찜브랜드 추가</a>
						<% Else %>
						<a href="javascript:myzzimbrand('<%=BrandID%>','zzim<%=intI%>');" id="zzim<%=intI%>" class="btn-zzim">찜브랜드 추가</a>
						<% End If %>
					</div>
<%
		intJ = intJ + 1
	Next
%>
				</div>
			</div>
		</div>
<script>
//스와이퍼
function toprollingslide(){
	/* hot brand */
	var fBrandSwiper = new Swiper(".ctgy-brand .swiper-container",{
		centeredSlides:true,
		slidesPerView:'auto',
		speed:600
	});
}

setTimeout(function(){
	toprollingslide();
},100);

function myzzimbrand(makerid,clsid){
	$.ajax({
		type:"GET",
		url:"/street/myzzimbrand.asp",
		data: "makerid="+makerid,
		dataType: "text",
		async:false,
		success : function(Data){
			result = jQuery.parseJSON(Data);
			if (result.resultcode=="11"){
				$("#"+clsid).addClass("ziim-on");
				alert('찜브랜드에 추가 되었습니다.');
				return;
			}
			else if (result.resultcode=="22"){
				$("#"+clsid).removeClass("ziim-on");
				alert('찜브랜드에 삭제 되었습니다.');
				return;
			}
			else if (result.resultcode=="00"){
				alert('로그인 후에 이용 하실 수 있습니다.');
				return;
			}
			else if (result.resultcode=="99"){
				alert('브랜드를 선택 해주세요');
				return;
			}
		}
	});
}
</script>
<%
End If
on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
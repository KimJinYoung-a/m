<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/wish/WishCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'####################################################
' Description : 텐큐 메인
' History : 2018-03-29 정태훈
'####################################################
Dim eCode, userid, SubIdx , eventid

eventid = RequestCheckVar(Request("eventid"),5)
If eventid = "" Then '// 이메일용
	Response.Redirect "http://m.10x10.co.kr/event/eventmain.asp?eventid=85144"
	REsponse.End
End If

IF application("Svr_Info") = "Dev" THEN
	eCode   =  67514
Else
	eCode   =  85021
End If
Dim typechk : typechk = false
userid = GetEncLoginUserID()

strHeadTitleName = "이벤트"
Dim strOGMeta
'head.asp에서 출력
strOGMeta = strOGMeta & "<meta property=""og:title"" content=""[텐바이텐] 텐큐베리 감사!"">" & vbCrLf
strOGMeta = strOGMeta & "<meta property=""og:type"" content=""website"" />" & vbCrLf
strOGMeta = strOGMeta & "<meta property=""og:url"" content=""http://m.10x10.co.kr/event/eventmain.asp?eventid=85144"" />" & vbCrLf
strOGMeta = strOGMeta & "<meta property=""og:image"" content=""http://webimage.10x10.co.kr/eventIMG/2018/tenq/m/bnr_kakao.jpg"">" & vbCrLf
strOGMeta = strOGMeta & "<meta property=""og:description"" content=""최대 25% 쿠폰과 함께 , 4월에도 텐바이텐에서 즐거운 쇼핑하세요!"">" & vbCrLf
'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg, vIsEnd, vQuery, vState, vNowTime, vCouponMaxCount
Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle	= Server.URLEncode("[텐바이텐] 텐큐베리 감사!")
If isapp = "1" Then '앱일경우
	snpLink		= Server.URLEncode("http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=85144")
Else '앱이 아닐경우
	snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=85144")
End If
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/eventIMG/2018/tenq/m/bnr_kakao.jpg")

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐] 텐큐베리 감사!"
Dim kakaodescription : kakaodescription = "올해도어김없이 찾아온봄 할인 행사! 4/2~16, 총 15일간다양한 혜택과 상품이당신을 기다립니다.최대 25%의다양한 할인쿠폰 까지?지금 도전해보세요!오직 텐바이텐에서!"
Dim kakaooldver : kakaooldver = "[텐바이텐] 텐큐베리 감사!\n\n올해에도\n어김없이 찾아온\n봄 할인 행사!\n\n4/2~16 총 15일간\n다양한 혜택과 상품이\n당신을 기다립니다.\n\n최대 25%의\n다양한 할인쿠폰까지?!\n\n지금 도전해보세요!\n오직 텐바이텐에서!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2018/tenq/m/bnr_kakao.jpg"
Dim kakaolink_url
If isapp = "1" Then '앱일경우
	kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=85144"
Else '앱이 아닐경우
	kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid=85144"
End If

Dim cPopular, vDisp, vSort, vCurrPage, i, j, vArrEval , PageSize
vDisp = RequestCheckVar(Request("disp"),18)
vSort = requestCheckVar(request("sort"),12)
vCurrPage = RequestCheckVar(Request("cpg"),5)
PageSize = getNumeric(requestCheckVar(request("psz"),9))

If vCurrPage = "" Then vCurrPage = 1

If vSort = "" Then vSort = "3"

If Trim(PageSize) = "" Or Len(Trim(PageSize))=0 Then
	PageSize="6"
End If

Dim MyCouponCheck
If userid <> "" Then
	vQuery = ""
	vQuery = vQuery & " select count(itemcouponidx) as cnt From [db_item].[dbo].[tbl_user_item_coupon] Where userid='"& userid &"' and itemcouponidx in (13739,13740,13741,13742,13787) and usedyn='N'"
	rsget.Open vQuery, dbget, 1
	IF Not rsget.Eof Then
		MyCouponCheck = rsget(0)
	Else
		MyCouponCheck=0
	End If
	rsget.close
Else
	MyCouponCheck=0
End If
%>
<style type="text/css">
.tenq-main {position:relative;}
.tenq-main .deco {position:absolute;}
.tenq-main .arrow {position:absolute; width:2.67%; z-index:30; animation:bounce2 .4s 50 alternate;}
.tenq-main h2 {position:relative;}
.tenq-main h2:before,
.tenq-main h2:after {content:''; display:inline-block; position:absolute; background-position:0 0; background-repeat:no-repeat; background-size:100% auto;}
.tenq-main h2:before {left:17.8%; top:4%; width:16.6%; height:18.5%; background-image:url(http://webimage.10x10.co.kr/eventIMG/2018/tenq/85144/pang_1.gif);}
.tenq-main h2:after {left:68.1%; top:28%; width:17.3%; height:19.3%; background-image:url(http://webimage.10x10.co.kr/eventIMG/2018/tenq/85144/m/pang_2.gif);}
.section1 .navigation li {position:relative;}
.section1 .nav1 button {width:100%; background:transparent;}
.section1 .nav1 .coupon {position:absolute; right:13.6%; bottom:-1%; z-index:20; width:27.2%;}
.section1 .nav1 .coupon em {position:absolute; left:0; top:-6%; width:100%; animation:bounce .5s 50 alternate;}
.section1 .nav2 .deco {left:5%; top:6%; width:50%;}
.section1 .nav2 .arrow {left:78%; top:69.78%;}
.section1 .nav2:after {content:''; display:inline-block; position:absolute; left:11%; top:0; width:7.73%; height:5.3%; background:url(http://webimage.10x10.co.kr/eventIMG/2018/tenq/85144/m/txt_num_02.png) 0 0 no-repeat; background-size:100% auto;}
.section1 .nav3 .deco {left:24.53%; top:18.73%; width:53.06%;}
.section1 .nav3 .arrow {left:89.7%; top:76.51%;}
.section1 .nav4 .deco {left:22.4%; top:15%; width:47.5%;}
.section1 .nav4 .arrow {left:67%; top:77%;}
.section1 .nav5 .deco {left:34.4%; top:20%; width:49.73%;}
.section1 .nav5 .arrow {left:89.6%; top:70%;}
.section2 {background-color:#abe9d5;}
.section2 .btn-more {display:block; width:100%; margin:1.02rem 0 2.5rem;}
.share {position:relative; margin-top:1.28rem;}
.share a {display:block; position:absolute; right:6.5%; top:12%; width:24%; height:35.5%; text-indent:-999em;}
.share a.btn-fb {top:52.5%;}
.bounce {animation:bounce .5s 50 alternate;}

#lyrCoupon {display:none; position:fixed; left:4.5%; top:12%; z-index:999; width:91%;}
#lyrCoupon .btn-close {position:absolute; left:50%; bottom:7%; width:36%; margin-left:-18%; background:transparent;}
@keyframes bounce {
	0% {transform:translateY(0);}
	100% {transform:translateY(-10px);}
}
@keyframes bounce2 {
	0% {transform:translateX(0);}
	100% {transform:translateX(4px);}
}
</style>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type="text/javascript">
$(function(){
	// 쿠폰 다운로드 레이어
	$('.nav1 .btn-coupon').click(function(){
		//$('#lyrCoupon').fadeIn(300);
	});
	// 레이어닫기
	$('#lyrCoupon .btn-close').click(function(){
		$('#lyrCoupon').fadeOut(200);
	});
	getWishList();
});


function jsDownCoupon(stype,idx){
	<% if Not(IsUserLoginOK) then %>
		jsEventLogin();
	<% else %>
	$.ajax({
		type: "post",
		url: "/shoppingtoday/act_couponshop_process.asp",
		data: "idx="+idx+"&stype="+stype,
		cache: false,
		success: function(message) {
			if(typeof(message)=="object") {
				if(message.response=="Ok") {
					$("#lyrCoupon").show();
				} else {
					alert(message.message);
				}
			} else {
				alert("처리중 오류가 발생했습니다.");
			}
		},
		error: function(err) {
			console.log(err.responseText);
		}
	});
	<% end if %>
}

function jsEventLogin(){
<% if isApp="1" then %>
	calllogin();
<% else %>
	jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=85144")%>');
<% end if %>
	return;
}

function snschk(snsnum) {
	if(snsnum=="fb"){
		popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
	}else if(snsnum=="pt"){
		pinit('<%=snpLink%>','<%=snpImg%>')
	}else if(snsnum=="ka"){
		<% if isapp then %>

		parent_kakaolink('<%=kakaooldver%>' , '<%=kakaoimage%>' , '200' ,'200' , '<%=kakaolink_url%>');

		<% else %>
		event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaolink_url%>' );
		<% end if %>
		return false;
	}
}

function getWishList() {

	var str=$.ajax({
		type:"GET",
		url:"/event/tenq/inc_WishList.asp",
		data:$("#popularfrm").serialize(),
		dataType:"text",
		async:false
	}).responseText;
	//alert(str);
	if(str!="") {
    	if($("#popularfrm input[name='cpg']").val()=="0") {
        	//내용 넣기
        	$('#incwishListValue').html(str);
		} else {
			$('#incwishListValue').append(str);
		}
		isloading=false;
		$("#viewLoading").fadeOut(500);
	} else {
    	$(window).off("scroll",vAddScr);
		$("#viewLoading").hide();

		//alert("위시 리스트가 더 이상 없습니다.");
	}
}

function fnWishMore(){
	<% if isapp then %>
	fnAPPpopupBrowserURL('WISH','http://m.10x10.co.kr/apps/appCom/wish/web2014/wish/');
	<% else %>
	window.open("/wish/","_blank");
	<% end if %>
}
</script>
<form id="popularfrm" name="popularfrm" method="get" style="margin:0px;">
	<input type="hidden" name="cpg" id="cpg" value="<%=vCurrPage%>" />
	<input type="hidden" name="psz" id="psz" value="<%=PageSize%>">
	<input type="hidden" name="sort" id="sort" value="<%=vSort%>" />
	<input type="hidden" name="disp" id="disp" value="<%=vDisp%>" />
</form>
			<!-- 텐큐베리감사 : 메인 -->
			<div class="mEvt85144 tenq-main">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85144/m/tit_thankyou.png?v=1.1" alt="텐~큐 베리감사" /></h2>
				<div class="section1">
					<ul class="navigation">
						<li class="nav1">
							<% if Not(IsUserLoginOK) then %>
							<button class="btn-coupon" onclick="jsEventLogin();return false;">
							<% Else %>
							<button class="btn-coupon" onclick="jsDownCoupon('prd,prd,prd,prd,prd','13739,13740,13741,13742,13787');return false;">
							<% End If %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85144/m/nav_coupon.png?v=1.3" alt="땡큐쿠폰" />
								<!-- 쿠폰 발급 전 -->
								<% If MyCouponCheck >= 5 Then %>
								<div class="coupon">
									<em><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85144/m/btn_finish.png?v=1" alt="발급완료" /></em>
									<img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85144/m/bg_down_2.png?v=1" alt="" />
								</div>
								<% Else %>
								<div class="coupon">
									<em><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85144/m/btn_down.png?v=1" alt="쿠폰받기" /></em>
									<img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85144/m/bg_down_1.png?v=1" alt="" />
								</div>
								<% End IF %>
							</button>
							<!-- 쿠폰 다운로드 레이어 -->
							<div id="lyrCoupon" style="display:none">
								<div><a href=""><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85144/m/img_coupon.png?v=1" alt="쿠폰이 발급되었습니다. 발급된 쿠폰은 마이텐바이텐에서 확인하실 수 있습니다." /></a></div>
								<button type="button" class="btn-close"><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85144/m/btn_close.png" alt="닫기" /></button>
							</div>
							<!--// 쿠폰 다운로드 레이어 -->
						</li>
						<li class="nav2">
						<% if isApp="1" then %>
							<a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '100원의 기적', [BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=85145');">
						<% else %>
							<a href="/event/eventmain.asp?eventid=85145">
						<% end if %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85144/m/nav_miracle.png?v=1.3" alt="100원의 기적" />
								<div class="deco"><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85144/m/deco_2.gif?v=1.2" alt="" /></div>
								<div class="arrow"><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85144/m/blt_arrow_1.png" alt="" /></div>
							</a>
						</li>
						<li class="nav3">
						<% if isApp="1" then %>
							<a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '매일리지', [BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=85146');">
						<% else %>
							<a href="/event/eventmain.asp?eventid=85634">
						<% end if %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85144/m/nav_mileage.png?v=1.1" alt="매일리지" />
								<div class="deco"><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85144/m/deco_3.gif" alt="" /></div>
								<div class="arrow"><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85144/m/blt_arrow_2.png" alt="" /></div>
							</a>
						</li>
						<li class="nav4">
						<% if isApp="1" then %>
							<a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '매일리지', [BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=85147');">
						<% else %>
							<a href="/event/eventmain.asp?eventid=85147">
						<% end if %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85144/m/nav_gift.png?v=1" alt="땡큐 베리 박스" />
								<div class="deco"><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85144/m/deco_4.gif" alt="" /></div>
								<div class="arrow"><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85144/m/blt_arrow_3.png" alt="" /></div>
							</a>
						</li>
						<li class="nav5">
						<% if isApp="1" then %>
							<a href="javascript:fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '매일리지', [BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=85148');">
						<% else %>
							<a href="/event/eventmain.asp?eventid=85148">
						<% end if %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85144/m/nav_1100.png?v=1.4" alt="1,100만원" />
								<div class="deco"><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85144/m/deco_5.gif" alt="" /></div>
								<div class="arrow"><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85144/m/blt_arrow_4.png" alt="" /></div>
							</a>
						</li>
					</ul>
				</div>
				<div class="section2">
					<h3><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85144/m/tit_popular.png?v=1" alt="지금, 인기있는 상품 - 다른 사람들의 위시를 실시간으로 만나보세요!" /></h3>
					<!-- for  dev msg : ↓현재 위시 페이지와 마크업 동일 -->
					<div class="wishListV15a">
						<ul id="incwishListValue"></ul>
						<button type="button" class="btn-more" onclick="fnWishMore();"><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85144/m/btn_more.png?v=1" alt="상품 더보기" /></button>
					</div>
				</div>
				<!-- SNS공유 -->
				<div class="share">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2018/tenq/85144/m/txt_share.png?v=1" alt="텐큐베리감사를 공유해주세요!" /></p>
					<a href="" class="btn-kakao" onclick="snschk('ka'); return false;">카카오톡으로 공유하기</a>
					<a href="" class="btn-fb" onclick="snschk('fb'); return false;">페이스북으로 공유하기</a>
				</div>
			</div>
	<div id="viewLoading" style="position:absolute; left:50%; margin:-25px 0 0 -25px;z-index:1000 ">
		<img src="http://fiximage.10x10.co.kr/m/2014/common/loading.gif" width="50x" height="50px">
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
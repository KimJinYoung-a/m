<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim eCode, sqlStr, i, vArr, vUserID, vCount(5), vCheck(5)
	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "66123"
	Else
		eCode 		= "70687"
	End If

	vUserID = GetEncLoginUserID
	vCount(0) = 0
	vCount(1) = 0
	vCount(2) = 0
	vCount(3) = 0
	vCount(4) = 0
	vCount(5) = 0
	
	sqlstr = "select " & _
			 "isNull(sum(case when sub_opt2 = '1' then 1 else 0 end),0), isNull(sum(case when sub_opt2 = '2' then 1 else 0 end),0), " & _
			 "isNull(sum(case when sub_opt2 = '3' then 1 else 0 end),0), isNull(sum(case when sub_opt2 = '4' then 1 else 0 end),0), " & _
			 "isNull(sum(case when sub_opt2 = '5' then 1 else 0 end),0), isNull(sum(case when sub_opt2 = '6' then 1 else 0 end),0) " & _
			 "from [db_event].[dbo].[tbl_event_subscript] where evt_code = '" & eCode & "'"
	rsget.CursorLocation = adUseClient
	rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
	If Not rsget.Eof Then
		vCount(0) = rsget(0)
		vCount(1) = rsget(1)
		vCount(2) = rsget(2)
		vCount(3) = rsget(3)
		vCount(4) = rsget(4)
		vCount(5) = rsget(5)
	End If
	rsget.Close
	
	If IsUserLoginOK Then
		'// 이벤트에 참여하였는지 확인한다.
		sqlstr = "Select sub_opt2 From db_event.dbo.tbl_event_subscript WHERE evt_code='" & eCode & "' and userid='" & vUserID & "'"
		rsget.CursorLocation = adUseClient
		rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
		If Not rsget.Eof Then
			vArr = rsget.getRows()
		End If
		rsget.Close
	End If
%>
<style type="text/css">
img {vertical-align:top;}

.item {position:relative;}
.item span {display:inline-block; position:absolute; left:50%; width:57%; height:4rem; padding:1.1rem 0.5rem 1rem 0.5rem; margin-left:-28.5%; text-align:center; border-radius:2rem 2rem; line-height:2rem; vertical-align:top;}
.item span button {overflow:hidden; display:inline-block; width:8rem; height:1.8rem; background:transparent url(http://webimage.10x10.co.kr/eventIMG/2016/70687/m/ico_like.png) 50% 0 no-repeat; background-size:100%; text-indent:-999em;vertical-align:top;outline:none;}
.item span button.heartOn {background-position:50% 100%;}
.item span strong {display:inline-block; min-width:1rem; padding:0 0.3rem 0 0.5rem; font-size:1.65rem; line-height:1.75rem; color:#000; font-family:'helvetica Neue', helveticaNeue, helvetica, sans-serif !important; text-align:right;}
.item a {overflow:hidden; display:block; position:absolute; left:50%; width:86%; margin-left:-43%; text-indent:-9999em;}
.item01 span {top:46.5%; background-color:#e3fafb;}
.item01 span:before {position:absolute; left:-2.8rem; top:-0.5rem; width:3.95rem; height:1.85rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/70687/m/txt_click.png) no-repeat 0 0; background-size:100%; content:''}
.item01 a {top:58.5%; height:40%;}
.item02 span {top:45.5%; background-color:#fff1f1;}
.item02 a {top:58.5%; height:38%;}
.item03 span {bottom:9.5%; background-color:#fff1f1;}
.item03 a {top:0; height:75%;}
.item04 span {bottom:9.5%; background-color:#fffcd7;}
.item04 a {top:0; height:75%;}
.item05 span {bottom:9%; background-color:#feeaf9;}
.item05 a {top:0; height:75%;}
.item06 span {bottom:17%; background-color:#e0f9f6;}
.item06 a {top:0; height:67%;}
.rolling {position:relative;}
.rolling .swiper {position:relative;}
.rolling .swiper .swiper-container {width:100%;}
.rolling .swiper button {position:absolute; top:38%; z-index:20; width:6.875%; background:transparent;}
.rolling .swiper .btnPrev {left:0;}
.rolling .swiper .btnNext {right:0;}
.rolling .swiper .pagination {overflow:hidden; position:absolute; bottom:1rem; left:0; width:100%; height:0.8rem; z-index:50; padding-top:0; text-align:center;}
.rolling .swiper .pagination .swiper-pagination-switch {display:inline-block; position:relative; z-index:50; width:0.8rem; height:0.8rem; border:2px solid #fff; margin:0 0.3rem; background-color:transparent; cursor:pointer;}
.rolling .swiper .pagination .swiper-active-switch {background-color:#fff;}
</style>
<script type="text/javascript">
$(function() {
	mySwiper1 = new Swiper('.swiper1',{
		loop:true,
		autoplay:2000,
		speed:800,
		pagination:".pagination",
		paginationClickable:true,
		autoplayDisableOnInteraction:false,
		nextButton:".btnNext",
		prevButton:".btnPrev"
	});

	mySwiper2 = new Swiper('.swiper2',{
		loop:true,
		autoplay:2000,
		speed:800,
		pagination:".pagination",
		paginationClickable:true,
		autoplayDisableOnInteraction:false,
		nextButton:".btnNext",
		prevButton:".btnPrev"
	});
	//화면 회전시 리드로잉(지연 실행)
	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
			mySwiper1.reInit();
			mySwiper2.reInit();
			clearInterval(oTm);
		}, 500);
	});

	var chkapp = navigator.userAgent.match('tenapp');
	if (chkapp){
		$(".app").show();
		$(".mo").hide();
	} else {
		$(".app").hide();
		$(".mo").show();
	}
});

	function jsClickGood(g){
		<% If vUserID = "" Then %>
			if ("<%=IsUserLoginOK%>"=="False") {
				<% if isApp=1 then %>
					parent.calllogin();
					return false;
				<% else %>
					parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eCode)%>');
					return false;
				<% end if %>
				return false;
			}
		<% Else %>
			$.ajax({
				type:"GET",
				url:"/event/etc/doEventSubscript70687.asp?g="+g+"",
				dataType: "text",
				async:false,
				cache:false,
				success : function(Data, textStatus, jqXHR){
					if (jqXHR.readyState == 4) {
						if (jqXHR.status == 200) {
							if(Data!="") {
								var str;
								var r1;
								var r2;
								for(var i in Data)
								{
									 if(Data.hasOwnProperty(i))
									{
										str += Data[i];
									}
								}
								str = str.replace("undefined","");
								res = str.split("|");
								if (res[0]=="OK")
								{
									r1 = res[1].substring(0,1);
									r2 = res[1].substring(1);
									$("#checkcnt"+g).empty().text(r2);
									
									if(r1 == "I"){
										$("#goodbtn"+g).addClass("heartOn");
									}else{
										$("#goodbtn"+g).removeClass("heartOn");
									}
									return false;
								}
								else
								{
									errorMsg = res[1].replace(">?n", "\n");
									alert(errorMsg);
									document.location.reload();
									return false;
								}
							} else {
								alert("잘못된 접근 입니다.1");
								document.location.reload();
								return false;
							}
						}
					}
				},
				error:function(jqXHR, textStatus, errorThrown){
					alert("잘못된 접근 입니다.2");
					document.location.reload();
					return false;
				}
			});
		<% End If %>
	}
	function fnlayerClose(){
		$("#resultLayer").hide();
	}
</script>
<div class="evtContV15">
	<div class="mEvt70687">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/70687/m/tit_between.png" alt="메리 비트윈! - 비트윈 캐릭터 상품을 구매하신 고객 중 선착순 100분께 비트윈 에코백을 드립니다.(랜덤발송)" /></h2>
		<div class="item item01">
			<span><button type="button" <%=CHKIIF(fnMyGoodCheck(vArr,1),"class='heartOn'","")%> id="goodbtn1" onclick="jsClickGood('1');return false;">좋아요</button><strong id="checkcnt1"><%=vCount(0)%></strong><img src="http://webimage.10x10.co.kr/eventIMG/2016/70687/m/txt_num.png" alt="개" style="width:1.5rem" /></span>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70687/m/img_between_like1.png" alt="Mochi Couple 찰떡 궁합 모찌 커플!" /></p>
			<% if isApp=1 then %>
				<a href="" onclick="fnAPPpopupProduct('1410057&amp;pEtr=70687');return false;" class="app">Mochi Couple 찰떡 궁합 모찌 커플!</a>
			<% else %>
				<a href="/category/category_itemPrd.asp?itemid=1410057&amp;pEtr=70687" class="mo">Mochi Couple 찰떡 궁합 모찌 커플!</a>
			<% end if %>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70687/m/img_between_item1.png" alt="Mochi Couple 찰떡 궁합 모찌 커플!" /></p>
		</div>
		<div class="item item02">
			<span><button type="button" <%=CHKIIF(fnMyGoodCheck(vArr,2),"class='heartOn'","")%> id="goodbtn2" onclick="jsClickGood('2');return false;">좋아요</button><strong id="checkcnt2"><%=vCount(1)%></strong><img src="http://webimage.10x10.co.kr/eventIMG/2016/70687/m/txt_num.png" alt="개" style="width:1.5rem" /></span>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70687/m/img_between_like2.png" alt="Merry 비트윈 대표 여친 메리!" /></p>
			<% if isApp=1 then %>
				<a href="" onclick="fnAPPpopupProduct('1485266&amp;pEtr=70687');return false;" class="app">Merry 비트윈 대표 여친 메리!</a>
			<% else %>
				<a href="/category/category_itemPrd.asp?itemid=1485266&amp;pEtr=70687" class="mo">Merry 비트윈 대표 여친 메리!</a>
			<% end if %>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70687/m/img_between_item2.png" alt="Merry 비트윈 대표 여친 메리!" /></p>
		</div>
		<div class="rolling">
			<div class="swiper">
				<div class="swiper-container swiper1">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70687/m/img_slide1.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70687/m/img_slide2.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70687/m/img_slide3.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70687/m/img_slide4.jpg" alt="" /></div>
					</div>
				</div>
				<div class="pagination"></div>
				<button type="button" class="btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70687/m/btn_slide1_prev.png" alt="이전" /></button>
				<button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70687/m/btn_slide1_next.png" alt="다음" /></button>
			</div>
		</div>
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/70687/m/subtit_between.png" alt="비트윈에서 놀러온 다른 친구들도 소개합니다!" /></h3>
		<div class="item item03">
			<span><button type="button" <%=CHKIIF(fnMyGoodCheck(vArr,3),"class='heartOn'","")%> id="goodbtn3" onclick="jsClickGood('3');return false;">좋아요</button><strong id="checkcnt3"><%=vCount(2)%></strong><img src="http://webimage.10x10.co.kr/eventIMG/2016/70687/m/txt_num.png" alt="개" style="width:1.5rem" /></span>
			<% if isApp=1 then %>
				<a href="" onclick="fnAPPpopupProduct('1291762&amp;pEtr=70687');return false;" class="app">Milk 메리의 똥강아지, 허당 로맨티스트 밀크</a>
			<% else %>
				<a href="/category/category_itemPrd.asp?itemid=1291762&amp;pEtr=70687" class="mo">Milk 메리의 똥강아지, 허당 로맨티스트 밀크</a>
			<% end if %>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70687/m/img_between_item3.jpg" alt="Milk 메리의 똥강아지, 허당 로맨티스트 밀크" /></p>
		</div>
		<div class="item item04">
			<span><button type="button" <%=CHKIIF(fnMyGoodCheck(vArr,4),"class='heartOn'","")%> id="goodbtn4" onclick="jsClickGood('4');return false;">좋아요</button><strong id="checkcnt4"><%=vCount(3)%></strong><img src="http://webimage.10x10.co.kr/eventIMG/2016/70687/m/txt_num.png" alt="개" style="width:1.5rem" /></span>
			<% if isApp=1 then %>
				<a href="" onclick="fnAPPpopupProduct('1342237&amp;pEtr=70687');return false;" class="app">Gray 과묵하고 시크한 회색곰 그레이</a>
			<% else %>
				<a href="/category/category_itemPrd.asp?itemid=1342237&amp;pEtr=70687" class="mo">Gray 과묵하고 시크한 회색곰 그레이</a>
			<% end if %>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70687/m/img_between_item4.jpg" alt="Gray 과묵하고 시크한 회색곰 그레이" /></p>
		</div>
		<div class="item item05">
			<span><button type="button" <%=CHKIIF(fnMyGoodCheck(vArr,5),"class='heartOn'","")%> id="goodbtn5" onclick="jsClickGood('5');return false;">좋아요</button><strong id="checkcnt5"><%=vCount(4)%></strong><img src="http://webimage.10x10.co.kr/eventIMG/2016/70687/m/txt_num.png" alt="개" style="width:1.5rem" /></span>
			<% if isApp=1 then %>
				<a href="" onclick="fnAPPpopupProduct('1350015&amp;pEtr=70687');return false;" class="app">Ivy 시골 출신이지만, 지금은 도도한 도시여자 아이비</a>
			<% else %>
				<a href="/category/category_itemPrd.asp?itemid=1350015&amp;pEtr=70687" class="mo">Ivy 시골 출신이지만, 지금은 도도한 도시여자 아이비</a>
			<% end if %>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70687/m/img_between_item5.jpg" alt="Ivy 시골 출신이지만, 지금은 도도한 도시여자 아이비" /></p>
		</div>
		<div class="item item06">
			<span><button type="button" <%=CHKIIF(fnMyGoodCheck(vArr,6),"class='heartOn'","")%> id="goodbtn6" onclick="jsClickGood('6');return false;">좋아요</button><strong id="checkcnt6"><%=vCount(5)%></strong><img src="http://webimage.10x10.co.kr/eventIMG/2016/70687/m/txt_num.png" alt="개" style="width:1.5rem" /></span>
			<% if isApp=1 then %>
				<a href="" onclick="fnAPPpopupProduct('1350017&amp;pEtr=70687');return false;" class="app">Robin Egg 귀요미 궁디 팡! 사랑꾼 로빈에그</a>
			<% else %>
				<a href="/category/category_itemPrd.asp?itemid=1350017&amp;pEtr=70687" class="mo">Robin Egg 귀요미 궁디 팡! 사랑꾼 로빈에그</a>
			<% end if %>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70687/m/img_between_item6.jpg" alt="Robin Egg 귀요미 궁디 팡! 사랑꾼 로빈에그" /></p>
		</div>
		<div class="rolling">
			<div class="swiper">
				<div class="swiper-container swiper2">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70687/m/img_slide11.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70687/m/img_slide12.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70687/m/img_slide13.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70687/m/img_slide14.jpg" alt="" /></div>
					</div>
				</div>
				<div class="pagination"></div>
				<button type="button" class="btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70687/m/btn_slide2_prev.png" alt="이전" /></button>
				<button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70687/m/btn_slide2_next.png" alt="다음" /></button>
			</div>
		</div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70687/m/txt_between.png" alt="" /></p>
	</div>
</div>
<%
Function fnMyGoodCheck(arr,num)
	Dim vTmp, i
	vTmp = False
	If IsUserLoginOK Then
		If IsArray(arr) Then
			For i = 0 To UBound(arr,2)
				If CStr(arr(0,i)) = CStr(num) Then
					vTmp = True
					Exit For
				End IF
			Next
		End If
	End If
	fnMyGoodCheck = vTmp
End Function
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
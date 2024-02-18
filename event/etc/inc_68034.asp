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

'###########################################################
' Description : 선물포장 이벤트 i 선물 u
' History : 2015.12.10 원승현
'###########################################################

dim eCode, cnt, sqlStr, couponkey, regdate, gubun, arrList, i, totalsum, linkeCode, imgLoop, imgLoopVal, irdsite20, arrRdSite, vUserID, evtCnt, giftCnt
	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "65980"
	Else
		eCode 		= "68034"
	End If

	vUserID = GetEncLoginUserID

	If IsUserLoginOK Then
		'// 선물포장 이벤트 신청자인지 확인한다.
		sqlstr = "Select count(sub_idx) as cnt" &_
				" From db_event.dbo.tbl_event_subscript" &_
				" WHERE evt_code='" & eCode & "' and userid='" & vUserID & "'"
				'response.write sqlstr
		rsget.Open sqlStr,dbget,1
			evtCnt = rsget(0)
		rsget.Close

		'// 선물포장 신청 대상자인지 확인한다.
		sqlstr = " select count(distinct m.userid) "
		sqlstr = sqlstr & " from db_order.dbo.tbl_order_master as m "
		sqlstr = sqlstr & " inner join db_order.dbo.tbl_order_detail as d "
		sqlstr = sqlstr & " on m.orderserial=d.orderserial "
		sqlstr = sqlstr & " where m.jumundiv<>'9' and m.ipkumdiv > 3 and m.cancelyn = 'N' "
		sqlstr = sqlstr & " and d.cancelyn<>'Y' and d.itemid<>'0' "
		sqlstr = sqlstr & " and m.regdate >= '2015-12-14' And ordersheetyn='P' And m.userid='"&vUserID&"' "
		rsget.Open sqlStr,dbget,1
			giftCnt = rsget(0)
		rsget.close
	End If

	'// 선물포장 신청 총 카운트
	sqlstr = "Select count(sub_idx) as cnt" &_
			" From db_event.dbo.tbl_event_subscript" &_
			" WHERE evt_code='" & eCode & "' "
			'response.write sqlstr
	rsget.Open sqlStr,dbget,1
		totalsum = rsget(0)
	rsget.Close
%>
<style type="text/css">
img {vertical-align:top;}
.mEvt68031 .hidden {visibility:hidden; width:0; height:0;}
.mEvt68031 button {background-color:transparent;}

.good {position:relative;}
.rolling {position:absolute; top:24%; left:0; width:100%;}
.rolling .swiper {position:relative;}
.rolling .swiper .swiper-container {width:100%;}
.rolling .swiper-slide {position:relative;}
.rolling .swiper .pagination {position:absolute; bottom:-12%; left:0; width:100%; height:auto; z-index:100; padding-top:0; text-align:center;}
.rolling .swiper .pagination .swiper-pagination-switch {display:inline-block; width:11px; height:11px; margin:0 2px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/68034/m/btn_pagination.png) no-repeat 50% 0; background-size:11px 22px; cursor:pointer; transition:all 0.6s ease;}
.rolling .swiper .pagination .swiper-active-switch {background-position:0 -11px;}

@media all and (min-width:480px){
	.rolling .swiper .pagination .swiper-pagination-switch {width:22px; height:22px; margin:0 4px; background-size:22px 44px;}
	.rolling .swiper .pagination .swiper-active-switch {background-position:0 -22px;}
}


.event {position:relative;}
.event .btnEvent {position:absolute; bottom:11.5%; left:50%; width:84.06%; margin-left:-42.03%;}
</style>


<script type="text/javascript">

	function checkform(){
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
		<% End If %>
		<% If vUserID <> "" Then %>
			<% If Now() >= #12/10/2015 10:00:00# And now() < #01/01/2016 00:00:00# Then %>
				<% if evtCnt > 0 then %>
					alert("마일리지 페이백 신청은 1회만 가능합니다.");
					return;				
				<% else %>
					<% if giftCnt > 0 then %>
						$.ajax({
							type:"GET",
							url:"/event/etc/doEventSubscript68034.asp",
							dataType: "text",
							async:false,
							cache:true,
							success : function(Data, textStatus, jqXHR){
								if (jqXHR.readyState == 4) {
									if (jqXHR.status == 200) {
										if(Data!="") {
											var str;
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
												okMsg = res[1].replace(">?n", "\n");
												alert(okMsg);
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
											alert("잘못된 접근 입니다.");
											document.location.reload();
											return false;
										}
									}
								}
							},
							error:function(jqXHR, textStatus, errorThrown){
								alert("잘못된 접근 입니다.");
								//var str;
								//for(var i in jqXHR)
								//{
								//	 if(jqXHR.hasOwnProperty(i))
								//	{
								//		str += jqXHR[i];
								//	}
								//}
								//alert(str);
								document.location.reload();
								return false;
							}
						});
					<% else %>
						alert("선물포장 서비스를 이용하셔야 신청하실 수 있습니다.");
						return;				
					<% end if %>
				<% end if %>
			<% else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;				
			<% end if %>
		<% End If %>
	}

</script>

<div class="mEvt68031">
	<article>
		<h2 class="hidden">I 선물 U</h2>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/68034/m/txt_i_present_u.png" alt="텐바이텐 선물 포장 서비스 런칭 당신의 마음까지 포장하세요" /></p>

		<section class="good">
			<h3 class="hidden">포장 서비스 이런 점이 좋아요</h3>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/68034/m/txt_good.png" alt="여러 가지 상품을 한번에 모아서 주고 싶을 때 여러 사람에게 줄 선물을 한 번에 준비해야 할 때 누군가에게 줄 선물도 사면서 내가 필요한 것도 사고 싶을 때 받아서 포장하고 카드 쓰는 번거로움을 줄이고 싶을 때" /></p>
		</section>

		<section class="good">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/68034/m/tit_preview.png" alt="포장 서비스 이용방법은?" /></h3>
			<div class="rolling">
				<div class="swiper">
					<div class="swiper-container swiper1">
						<div class="swiper-wrapper">
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68034/m/img_slide_01.png" alt="STEP1 포장 가능한 상품인지 확인하고 바로구매 클릭" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68034/m/img_slide_02.png" alt="STEP2 주문결제 페이지에서 선물포장 신청 클릭" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68034/m/img_slide_03.png" alt="STEP3 선물포장 될 상품들을 확인하고, 메시지도 적기" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68034/m/img_slide_04.png" alt="STEP4 선물포장 부분의 선물상자가 빨간색이면 성공" /></div>
						</div>
					</div>
					<div class="pagination"></div>
				</div>
			</div>
		</section>

		<section class="event">
			<h3 class="hidden">포장 서비스 이런 점이 좋아요</h3>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/68034/m/txt_event.png" alt="선물포장 서비스를 무료로 이용하세요 선물포장 서비스를 이용하고 응모하세요. 선착순 100분에게 2,000마일리지를 페이백 해드립니다. 신청자가 많을 경우 자동 종료됩니다." /></p>
			<%' for dev msg : 페이백 신청하기 %>
			<% If totalsum >= 100 Then %>
				<button type="button" class="btnEvent" onclick="alert('마일리지 페이백이 종료되었습니다.');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68034/m/btn_event.png" alt="2,000 마일리지 페이백 신청하기" /></button>
			<% Else %>
				<button type="button" class="btnEvent" onclick="checkform();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68034/m/btn_event.png" alt="2,000 마일리지 페이백 신청하기" /></button>
			<% End If %>
		</section>

	</article>
</div>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper('.swiper1',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		autoplay:3000,
		speed:800,
		pagination:".pagination",
		paginationClickable:true,
		autoplayDisableOnInteraction:false
	});

	//화면 회전시 리드로잉(지연 실행)
	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
			mySwiper.reInit();
				clearInterval(oTm);
		}, 500);
	});
});
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->
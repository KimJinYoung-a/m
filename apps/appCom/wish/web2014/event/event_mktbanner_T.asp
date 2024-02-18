<%
'#######################################################
' Discription : Mobile mktevent_banner
' History : 2015-01-08 이종화 생성
'#######################################################
Dim sqlStr , arrMktevt , i
Dim evtimg , startdate , enddate 
Dim gubun , mktimg , m_eventid , a_eventid , isusing , regdate , sortnum 
Dim isurl '// URL 경로

	sqlStr = "select top 12 t.* "
	sqlStr = sqlStr + " from db_sitemaster.dbo.tbl_mobile_event_mktbanner as t "
	sqlStr = sqlStr & " where t.isusing = 'Y' "
	sqlStr = sqlStr & "		and t.enddate >= getdate() "
	sqlStr = sqlStr & "		and ( getdate() between t.startdate and t.enddate )"
	sqlStr = sqlStr & "		and t.mktimg <> '' "
	sqlStr = sqlStr & "		and gubun in (1,3) "
	sqlStr = sqlStr & " order by t.sortnum asc , t.startdate asc "

	'response.write sqlStr
	dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"MEVT",sqlStr,60*3)
	If Not rsMem.EOF Then
		arrMktevt 	= rsMem.GetRows
	End if
	rsMem.close
%>
<script>
$(function(){
	var _maxSwipe = <%=ubound(arrMktevt,2)%>;
    var _iSwipe=0;
	evtSwiper = new Swiper('.evtTopBnr .swiper-container',{
		pagination:false,
		resizeReInit:true,
		calculateHeight:true,
		<% If isArray(arrMktevt) and not(isnull(arrMktevt)) Then %>
		loop:true,
		autoplay:3500,
		<% end if %>
		resizeReInit:true,
		calculateHeight:true,
		autoplayDisableOnInteraction:false,
		speed :500,
		followFinger:false,
		onSlideChangeStart:function(){
			$('.evtBnrPaging .page strong').text(evtSwiper.activeLoopIndex+1);
		},
		onSlideChangeEnd: function(swiper){
          _iSwipe++;
          if (_iSwipe>_maxSwipe){
            swiper.stopAutoplay();
          }
        },
		onImagesReady:function(){
			rectPosition();
		}
	});

	$('.arrow-left').on('click', function(e){
		e.preventDefault()
		evtSwiper.swipePrev()
	});
	$('.arrow-right').on('click', function(e){
		e.preventDefault()
		evtSwiper.swipeNext()
	});

	$('.evtBnrPaging .page strong').text(1);
	$('.evtBnrPaging .page span').text(evtSwiper.slides.length-2);

	//화면 회전시 리드로잉(지연 실행)
	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
			evtSwiper.reInit();
			clearInterval(oTm);
		}, 500);
	});
});

function rectPosition() {
	var recX1 = $('.evtTopBnr .swiper-container').width()/100*15;
	var recY1 = 0;
	var recX2 = $('.evtTopBnr .swiper-container').width()/100*85;
	var recY2 = $('.evtTopBnr .swiper-container').height();
    
    alert(parseInt(recX1)+','+parseInt(recY1)+','+parseInt(recX2)+','+parseInt(recY2)+','+parseInt(window.innerWidth));
	fnSetSwipeCancelArea(parseInt(recX1),parseInt(recY1),parseInt(recX2),parseInt(recY2),parseInt(window.innerWidth));
	
}
</script>
<div class="evtTopBnr">
	<div class="swiper-container">
		<div class="swiper-wrapper">
			<%
				If isArray(arrMktevt) and not(isnull(arrMktevt)) Then 
					FOR i=0 to ubound(arrMktevt,2)
						gubun				= arrMktevt(1,i)
						mktimg				= staticImgUrl & "/mobile/enjoyevent" & arrMktevt(2,i)
						m_eventid			= arrMktevt(3,i)
						a_eventid			= arrMktevt(4,i)
			%>
			<div class="swiper-slide">
				<a href="" onclick="fnAPPpopupEvent('<%=Trim(a_eventid)%>');return false;"><img src="<%=mktimg%>" alt="" /></a>
			</div>
			<%
					Next 
				End If
			%>
			<div class="swiper-slide">
				<a href="" onclick="fnAPPpopupBrowserURL('쿠폰북','<%=wwwUrl%>/apps/appCom/wish/web2014/shoppingtoday/couponshop.asp');return false;"><img src="http://fiximage.10x10.co.kr/m/2014/common/topbnr_coupon_book.png" alt="텐바이텐의 할인상품을 한눈에! COUPON BOOK" /></a>
			</div>
		</div>
	</div>
	<% If isArray(arrMktevt) and not(isnull(arrMktevt)) Then  %>
	<div class="evtBnrPaging">
		<p class="page"><strong></strong>/<span></span></p>
		<button type="button" class="arrow-left">이전</button>
		<button type="button" class="arrow-right">다음</button>
	</div>
	<% End If %>
</div>
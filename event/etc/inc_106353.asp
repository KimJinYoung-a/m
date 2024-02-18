<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
' Description : 19주년 구매사은품
' History : 2020-10-16 원승현
'####################################################
Dim eCode, userid
Dim vEvtOrderCnt, vEvtOrderSumPrice, vMyThisEvtCnt, sqlstr, vQuery

IF application("Svr_Info") = "Dev" THEN
	eCode   =  103242
Else
	eCode   =  106353
End If

userid = GetEncLoginUserID()

'// 이벤트 기간 구매 내역 체킹(10월 5일부터 10월 29일까지)
sqlStr = " EXEC [db_order].[dbo].[sp_Ten_MyOrderList_SUM_19THEVENT] '" & userid & "', '', '', '2020-10-05', '2020-10-30', '10x10', '', 'issue' "
'response.write sqlStr & "<br>"
rsget.CursorLocation = adUseClient
rsget.CursorType = adOpenStatic
rsget.LockType = adLockOptimistic
rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
	vEvtOrderCnt = rsget("cnt")
	vEvtOrderSumPrice   = CHKIIF(isNull(rsget("tsum")),0,rsget("tsum"))
'	vEvtOrderCnt = 1
'	vEvtOrderSumPrice   = 1000
rsget.Close

' 현재 이벤트 본인 참여수
vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' And userid='"&userid&"' And sub_opt3='event' "
rsget.CursorLocation = adUseClient
rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
IF Not rsget.Eof Then
	vMyThisEvtCnt = rsget(0)
End IF
rsget.close

'response.write vEvtOrderCnt&"<br>"&vEvtOrderSumPrice&"<br>"&vMyThisEvtCnt

%>
<style type="text/css">
.mEvt106353 a {position:absolute; left:50%; width:60%; height:5%; transform:translateX(-50%); font-size:0; color:transparent;}
.mEvt106353 .gift li {position:relative;}
.mEvt106353 .gift .g1 a {bottom:4%; width:60%; height:10%;}
.mEvt106353 .gift .g2 a {top:53%; width:50%; height:4%;}
.mEvt106353 .gift li .soldout {position:absolute; left:0; top:0; width:100%;}
.mEvt106353 .pagination {position:absolute; left:0; bottom:4.8vw; z-index:50; width:100%; height:auto; padding-top:0; text-align:center;}
.mEvt106353 .pagination span {width:2.67vw; height:2.67vw; margin:0 1.3vw; background:#d4d4d4;}
.mEvt106353 .pagination span.swiper-active-switch {background:#ffd648;}
.mEvt106353 .gift-diary {position:relative;}
.mEvt106353 .gift-diary a {bottom:10%; height:10%;}
</style>
<script>
$(function(){
    swiper1 = new Swiper('.make .swiper-container',{
		autoplay:1000,
        speed:900,
        loop:true,
		pagination:".make .pagination",
		paginationClickable:true,
		effect:'fade'
    });
    $(".btn-more").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top}, 800);
	});
});

function jsSubmit106353(){
	<% If IsUserLoginOK() Then %>
		<% If not(left(now(),10)>="2020-10-19" and left(now(),10)<"2020-10-30") Then %>
			alert("이벤트 신청 기간이 아닙니다.");
			return false;
        <% else %>
            <% if vMyThisEvtCnt > 0 then '// 1회만 신청되기때문에 신청내역이 있으면 튕김 %>
                alert("이미 신청이 완료되었습니다.");
                return;
            <% end if %>        

			<% if vEvtOrderCnt >= 3 And vEvtOrderSumPrice >= 150000 then '// 기간내 구매횟수 3회 이상, 구매금액 15만원 이상일 경우만 응모가능 %>
				$.ajax({
					type:"GET",
					url:"/event/etc/doEventSubscript106353.asp?mode=ins",
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
									res = str.split("|");
									if (res[0]=="OK")
									{
										alert("신청이 완료 되었습니다.\n마일리지는 11월 9일에 지급 될 예정입니다.");
										//document.location.reload();
										return false;
									}
									else
									{
										errorMsg = res[1].replace(">?n", "\n");
										alert(errorMsg );
										return false;
									}
								} else {
									alert("잘못된 접근 입니다.");
									//document.location.reload();
									return false;
								}
							}
						}
					},
					error:function(jqXHR, textStatus, errorThrown){
						alert("잘못된 접근 입니다.");
						var str;
						for(var i in jqXHR)
						{
							 if(jqXHR.hasOwnProperty(i))
							{
								str += jqXHR[i];
							}
						}
						//alert(str);
						document.location.reload();
						return false;
					}
				});
			<% else %>
                alert("신청조건에 맞지 않습니다.");
                return;
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End IF %>
}
</script>
<%'<!-- 106353 -->%>
<div class="mEvt106353">
    <h2><img src="http://webimage.10x10.co.kr/eventIMG/2020/106353/main_mo20200929172927.JPEG" alt="19주년 특별선물"></h2>
    <div class="make">
        <div class="swiper-container">
            <div class="swiper-wrapper">
                <div class="swiper-slide"><img src="//webimage.10x10.co.kr/eventIMG/2020/106353/m_slide1.jpg?v=2" alt=""></div>
                <div class="swiper-slide"><img src="//webimage.10x10.co.kr/eventIMG/2020/106353/m_slide2.jpg?v=2" alt=""></div>
                <div class="swiper-slide"><img src="//webimage.10x10.co.kr/eventIMG/2020/106353/m_slide3.jpg?v=2" alt=""></div>
                <div class="swiper-slide"><img src="//webimage.10x10.co.kr/eventIMG/2020/106353/m_slide4.jpg?v=2" alt=""></div>
            </div>
            <div class="pagination"></div>
        </div>
    </div>
    <div class="gift">
        <ul>
            <li class="g1">
                <img src="//webimage.10x10.co.kr/eventIMG/2020/106353/m_gift_1.jpg?v=2" alt="3회 이상 구매 시 5,000P 증정">
                <a href="" onclick="jsSubmit106353();return false;">신청하기</a>
            </li>
            <li class="g2">
                <img src="//webimage.10x10.co.kr/eventIMG/2020/106353/m_gift_2.jpg" alt="">
                <a href="#noti" class="btn-more">자세히보기</a>
                <div class="soldout"><img src="//webimage.10x10.co.kr/eventIMG/2020/106353/m_soldout.png" alt="soldout"></div>
            </li>
        </ul>
    </div>
    <div class="gift-diary">
        <p><img src="//webimage.10x10.co.kr/eventIMG/2020/106353/m_diary_gift_v2.jpg" alt="앗! 잠깐만요 다이어리 구매하면 드리는 사은품도 있다구요!"></p>
        <a href="/diarystory2021/special_benefit.asp" class="mWeb" target="_blank">선물 자세히 보기</a>
        <a href="javascript:fnAPPpopupBrowserURL('다이어리 스토리','http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2021/special_benefit.asp');" class="mApp">선물 자세히 보기</a>
    </div>
    <div id="noti" class="noti">
        <p><img src="//webimage.10x10.co.kr/eventIMG/2020/106353/m_noti.png?v=2" alt="유의사항"></p>
    </div>
</div>
<%'<!--// 106353 -->%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
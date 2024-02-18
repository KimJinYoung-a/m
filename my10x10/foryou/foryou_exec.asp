<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  for you
' History : 2019-05-28 최종원 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/foryou/foryouCls.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/util/commlib.asp" -->
<%
    if not IsUserLoginOK() then
        if isapp = 1 then             
            dim strTemp
            strTemp = 	"<script>" & vbCrLf &_
                    "alert('로그인을 하셔야 접근하실수 있는 페이지입니다.');" & vbCrLf &_
                    "calllogin();" & vbCrLf &_
                    "</script>"
            Response.Write strTemp                        
        else
            Call Alert_Return("로그인을 하셔야 접근하실수 있는 페이지입니다.")
            response.End
        end if
    end if

	Dim vCurrPage 
	vCurrPage = RequestCheckVar(Request("cpg"),5)
	
	If vCurrPage = "" Then vCurrPage = 1
	
	dim i, userid

	userid = getencLoginUserid()
    dim foryouObj, userCouponInfoResult, userCouponType, userCouponValue
    set foryouObj = new ForYouCls
    
    userCouponInfoResult = getUserCouponInfo(userid)

    if isArray(userCouponInfoResult) then
        for i=0 to ubound(userCouponInfoResult,2)
            userCouponType = Trim(userCouponInfoResult(0, i))
            userCouponValue = Trim(userCouponInfoResult(1, i))
        next
    end if    
%>
<style>
.for-you {position: relative; background-color: #fff;}
.for-you .tit-area .bg-area {position: absolute; overflow: hidden; height: 32rem; width: 100%; background-color: #87ffc7; }
.for-you .tit-area .bg-area svg {width: 33rem; height: 33rem;}
.for-you .tit-area .bg-area svg circle {fill:#fdff8e; r: 190; }
.for-you .tit-area .bg-area.on svg  {animation:bounce 1.5s infinite; transform-origin: 50% 80%; transition-timing-function: linear; }
    @keyframes bounce{ 50%{margin-left:-1rem;}}
.for-you .tit-area .topic {position: relative; width: 27.9rem; padding-top: 5.55rem; margin: 0 auto; text-align: left;  }
.for-you .tit-area .topic h2 {font-size: 3.07rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; line-height: 4.01rem; }
.for-you .tit-area .topic h2 b {font-family:'CoreSansCLight', 'AppleSDGothicNeo-Regular', 'NotoSansKRRegular', sans-serif;}
.for-you .tit-area .topic .bubble {position: relative; display: inline-block; height: 2.73rem; padding: 0 1.28rem; margin: 4.27rem 0 -1.7rem; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; font-size: 1.37rem; line-height: 2.73rem ; text-align: center; border-radius: 5rem; background-color: #fff; box-shadow: 0 .85rem 1.28rem 0 rgba(0, 0, 0, 0.15); }
.for-you .tit-area .topic .bubble:after { content: ' '; position: absolute; bottom: 0; left: 0; width: 0; height: 0; border-style: solid; border-width: 1.37rem 1.37rem 0 0; border-color: #fff transparent transparent transparent; }

.for-you .items {position: relative; width: 27.9rem; margin: 4.27rem auto 0; padding-bottom: 3.37rem; background-color: transparent;}
.for-you .items ul {display: inline-block; overflow:hidden; width: 100%;}
.for-you .items ul:after {display:block; clear:both; content:'';}
.for-you .items li {float:left; width: 13.31rem; margin: 1.92rem 1.28rem 0 0;}
.for-you .main .items li:nth-child(2n+1) {margin-right: 0;}
.for-you .other .items li:nth-child(2n) {margin-right: 0;}
.for-you .items li .thumbnail:after {content:' '; position:absolute; top:0; left:0; z-index:10; width:100%; height:100%; background-color:rgba(0, 0, 0, 0.03);}
.for-you .items li .thumbnail {width: 100%; height: 13.31rem;; margin-bottom: 0.85rem;}
.for-you .items li .thumbnail img {width:100%; height:100%;}
.for-you .items li .desc {position:relative; }
.for-you .items li .desc .name {width:100%; height: auto; max-height: 3.07rem; font-size: 1.11rem; margin: 0 0 .6rem; color:#666; }
.for-you .items li .desc .scr-coupon {height: 1.15rem; margin-bottom: 0.1rem; font-weight: 500; font-size: .94rem; line-height: 1.15rem; color: #00b160;}
.for-you .items li .desc .scr-coupon .discount {font-size: .94rem;}
.for-you .items li .desc .scr-coupon .discount.color-red,
.for-you .items li .desc .scr-coupon .discount.color-green {margin-right: .3rem;}
.for-you .items li .desc .price {height: 1.62rem; margin: 0; line-height: 1.62rem;  }
.for-you .items li .desc .price .sum {font-size:1.19rem; font-weight: 500; color: #000;}
.for-you .items li .desc .price .won {font-size: 1.02rem; font-weight: 500; color: #000;}
.for-you .items li .desc .price s {margin-left: .41rem; font-size: 1.02rem; color: #999;}
.for-you .items li.bigger {width: 100%; margin-top: 0;}
.for-you .items li.bigger .thumbnail {width: 100%; height: auto; margin-bottom: 1.28rem;}
.for-you .items li.bigger .desc {position: absolute; bottom: 3.41rem; right: 0; width: 18rem; height: 9.56rem; padding: 1.28rem 0 0  1.28rem; background-color: #fff; z-index: 999;}
.for-you .items li.bigger .desc .price {height: 2.35rem;  line-height: 2.35rem;}
.for-you .items li.bigger .desc .price .sum {font-size: 1.71rem;  letter-spacing: -.04rem;}
.for-you .items li.bigger .desc .price .won {font-size: 1.28rem;}
.for-you .items li.bigger .desc .price s {font-size: 1.11rem;}

.for-you .other .tit-area .topic {padding-top: 2.82rem;}
.for-you .other .tit-area .topic h3 {font-size: 1.45rem; font-weight: 600;}
.for-you .other .tit-area .bg-area {position: absolute; overflow: hidden; height: 12.8rem; width: 100%; background-color: #fdff8e;}
.for-you .other .items {margin-top: .2rem;}
@keyframes ani1 {
    50%{transform: translateX(10rem) scale(1.5);}
}
</style>
<script>
$(function(){
    $('.bg-area').addClass('on')
    $(window).scroll(function() {
        var st=$(this).scrollTop();
        var wh=window.innerHeight;
        var topic=$('.bg-area');
        if(topic.offset().top+topic.innerHeight()<st){topic.removeClass('on')}
        else{topic.addClass('on')}
        calc=190+(st*1.2)
        $('.bg-area.on').find('circle').css({'r':calc});
    })
})
</script>
<script type="text/javascript">
var isloading=true;

$(function(){	
	getList();

	//스크롤 이벤트 시작
	$(window).scroll(function() {
      if ($(window).scrollTop() >= $(document).height() - $(window).height() - 350){
          if (isloading==false){
            isloading=true;
			var pg = $("#foryoufrm input[name='cpg']").val();
			pg++;
			$("#foryoufrm input[name='cpg']").val(pg);
            setTimeout("getList()",500);
          }
      }
    });
});

function getList() {
	var str = $.ajax({
			type: "GET",
	        url: "/my10x10/foryou/foryou_act.asp",
	        data: $("#foryoufrm").serialize(),
	        dataType: "text",
	        async: false
	}).responseText;

	if(str!="") {
    	if($("#foryoufrm input[name='cpg']").val()=="1") {
        	//내용 넣기			
        	$('#lySearchResult').html(str);					
        } else {        	
       		$str = $(str)       		
       		$('#lySearchResult').append($str)               
        }
        isloading=false;        
    } else {
    	//더이상 자료가 없다면 스크롤 이벤트 종료
    	$(window).unbind("scroll");
    }
}
function submitForm(){
	var sortMetValue = document.getElementById("sort").value;
	$('#lySearchResult').empty()
	$("#foryoufrm input[name='cpg']").val(1);	
	$("#foryoufrm input[name='sortMet']").val(sortMetValue);		
	getList();
}
</script>
            <!-- for you -->

            <div class="for-you">
                <div class="section main">
                    <div class="tit-area">
                        <div class="bg-area"><svg><circle/></svg></div>
                        <% if userCouponType <> "" then %>
                        <div class="topic">
                            <h2><b><%=GetLoginUserName()%>님만을 위한</b><br><%=foryouObj.GetCouponDiscountStr(userCouponType, userCouponValue)%> 시크릿-쿠폰이<br>있습니다!</h2>
                            <p class="bubble">오늘 12시까지만 이 가격!</p>
                        </div>
                        <% else %>
                        <div class="topic">
                            <h2><b><%=GetLoginUserName()%>님만을 위한</b><br>이런 상품은 어때요?</h2>
                        </div>
                        <% end if %>
                    </div>
                    <div class="items">                        
                        <ul id="lySearchResult"></ul>                                                
                    </div>
                </div>
            </div>
            <form id="foryoufrm" name="foryoufrm" method="get" style="margin:0px;">
                <input type="hidden" name="cpg" value="1" />				            									
                <input type="hidden" name="sortMet" value="1" />				            									
            </form>	            
            <!-- // for you -->
<!-- #include virtual="/lib/db/dbclose.asp" -->            
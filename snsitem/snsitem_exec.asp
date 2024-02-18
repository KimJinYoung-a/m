<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  snsitem 기획전
' History : 2019-02-19 최종원 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/exhibition/exhibitionCls.asp" -->
<%
	Dim vCurrPage 
	vCurrPage = RequestCheckVar(Request("cpg"),5)
	
	If vCurrPage = "" Then vCurrPage = 1
	

	dim myWishArr, sqlStr
	dim i, userid , objCmd , vRs

	userid = getencLoginUserid()

	if userid <> "" then
		Set objCmd = Server.CreateObject("ADODB.COMMAND")
		With objCmd
			.ActiveConnection = dbget
			.CommandType = adCmdText
			.CommandText = "SELECT itemid from db_my10x10.dbo.tbl_myfavorite where userid = ? "
			.Prepared = true
			.Parameters.Append .CreateParameter("userid", adVarChar, adParamInput, Len(userid), userid)
			SET vRs = objCmd.Execute
				if not vRs.EOF then
					myWishArr = vRs.getRows()
				end if
			SET vRs = nothing
		End With
		Set objCmd = Nothing
	end if
%>
<style>
.sns-best{background-color:#f4f4f4;}
.sns-best h2 {position:relative;}
.sns-best h2:after {display:inline-block; position:absolute; top:10.3%; right:21.9%; width:5.03rem; height:4.35rem; background-image:url(//fiximage.10x10.co.kr/m/2019/common/img_heart.png); background-repeat:no-repeat; background-size:100%; content:''; animation:zoomInUp .8s 1; transform-origin:0 100%;}

.sns-best .sorting-bar {position:relative; margin:0 1.28rem; border-bottom:solid 1px #e5e5e5; background-color:#f4f4f4;}
.sns-best .sorting-bar:after {display:block; clear:both; content:'';}
.sns-best .sorting-bar select {position:relative; z-index:20; height:auto; padding:1.62rem 1.3rem .85rem 1rem; margin:0; border:0; border-radius:0; background:none; color:#0d0d0d; font-size:1.11rem; direction:rtl;}
.sns-best .sorting-bar select option {direction:ltr;}
.sns-best .sorting-bar .icon-arrow {position:absolute; top:1.96rem; right:0; z-index:10; width:0.85rem; height:0.85rem;}
.sns-best .sorting-bar .icon-arrow {background-image:url(http://fiximage.10x10.co.kr/m/2019/common/btn_arrow_black.png); background-repeat:no-repeat; background-size:100%;}

.sns-items {padding:1.71rem 4% 5rem; background-color:#f4f4f4;}
.sns-items > ul > li {overflow:hidden; margin-top:2.56rem;  background-color:#fff; border-radius:.43rem; box-shadow:.43rem .43rem 1.28rem 0 rgba(0, 0, 0, 0.1);}
.sns-items > ul > li:first-child {margin-top:0;}
.sns-items .thumbnail:after {display:Inline-block; position:absolute; top:0; left:0; z-index:10; width:100%; height:100%; background-color:rgba(0,0,0,.02); content:'';}
.sns-items .desc {position:relative; padding-left:.43rem;}
.sns-items .desc, .sns-items .review {margin:0 2.13rem;}
.sns-items .desc .name {padding-top:3.41rem; padding-right:8.1rem; font:1.11rem/1.38 'AvenirNext-Medium', 'AppleSDGothicNeo-Medium';}
.sns-items .desc .price {margin:.51rem 0 2.1rem;}
.sns-items .desc .price .discount {margin-right:.4rem; font-weight:600;}
.sns-items .btn-wish {position:absolute; top:-2.13rem; right:0; z-index:20; width:4.27rem; height:4.27rem; background-color:#fff; border-radius:50%; color:#999; font-size:.94rem; line-height:1.36;}
.sns-items .btn-wish i {display:inline-block; width:1.71rem; height:1.71rem; position:absolute; top:1.35rem; left:50%; margin-left:-.86rem; background-image:url(//fiximage.10x10.co.kr/m/2019/common/ico_heart.png?v=1.02); background-position:0 0; background-size:1.71rem auto;}
.sns-items .btn-wish.on i {background-position:0 100%; animation:scale .4s forwards;}
.sns-items .btn-wish span {position:relative; top:1.8rem;}
.sns-items .review {position:relative; padding:1.02rem 0 1.28rem; border-top:solid 1px #eee; color:#999;}
.sns-items .review .no-data {position:relative; padding-top:.94rem; color:#666; font-size:.94rem;}
.sns-items .review .no-data:after {display:inline-block; position:relative; top:.1rem; left:-.2rem; width:1.36rem; height:.86rem; background-image:url(//fiximage.10x10.co.kr/m/2019/common/btn_arrow_grey_2.png?v=1.02); background-repeat:no-repeat; background-size:100%; transform:rotate(90deg); content:'';}
.sns-items .review .counting {display:inline-block; vertical-align:0.17rem;}
.sns-items .review ul {margin-top:.51rem}
.sns-items .review li {padding:.85rem .43rem; border-top:solid 1px rgba(0,0,0,0.1);}
.sns-items .review li:first-child {border-top:0;}
.sns-items .review li .writer {margin-bottom:.43rem; line-height:1.37;}
.sns-items .review li > div {display:-webkit-box; overflow:hidden; max-width:100%; max-height:2.9rem; color:#666; font-size:1.02rem; line-height:1.42; white-space:normal; -webkit-line-clamp:2; -webkit-box-orient:vertical; text-overflow:ellipsis;}
.sns-items .btn-more {display:inline-block; position:absolute; top:1.41rem; right:.85rem; width:1.36rem; height:.86rem; background-image:url(//fiximage.10x10.co.kr/m/2019/common/btn_arrow_grey_2.png?v=1.02); background-repeat:no-repeat; background-size:100%; transition:all .6s;}
.sns-items .btn-more.unfold {transform:rotate(180deg);}
.icon-rating {display:inline-block; position:relative; width:6.4rem; height:1.28rem; margin-right:.23rem; margin-left:.1rem;}
.icon-rating:before, .icon-rating i {display:inline-block; width:100%; height:1.28rem; background-image:url(//fiximage.10x10.co.kr/m/2019/common/ico_star.png); background-repeat:no-repeat; background-size:6.4rem auto;}
.icon-rating:before {background-position:0 100%; content:' ';}
.icon-rating i {position:absolute; top:0; left:0; background-position:0 0; text-indent:-999em;}

.bnr-sns {overflow:hidden; position:fixed; bottom:1.45rem; right:6.31rem; z-index:30; padding:.85rem 1.28rem .78rem 1.28rem; border-radius:2.05rem; background-image:linear-gradient(to right, #b478ff, #d873f9); opacity:.9; transition:all .4s .1s;}
.bnr-sns span {display:inline-block; position:absolute; z-index:10; left:1.71rem; top:-10rem; color:#fff; font:1.02rem/1.33 'AvenirNext-Medium', 'AppleSDGothicNeo-Medium'; transition:all .2s;}
.bnr-sns ul {overflow:hidden; position:relative; top:0rem;}
.bnr-sns ul li {float:left; width:2.56rem; margin-left:.85rem;}
.bnr-sns ul li:first-child {margin-left:0;}
.bnr-sns ul li img {opacity:1;}

.bnr-sns.on {padding:.85rem 5% .78rem 52.5%; background-image:linear-gradient(to right, #6eb6fb, #7c8cf8 20%, #d873f9); transition:all .2s;}
.bnr-sns.on span {top:.85rem; transition:all .4s .1s;}

/* iphoneX */
/*
@media only screen and (device-width : 375px) and (device-height : 812px) and (-webkit-device-pixel-ratio : 3) {
.bnr-sns {padding-bottom:2.56rem;}
.bnr-sns.nav-down {bottom:-6.83rem;}
}
*/
/* iphoneXs Max , iphoneXr */
/*
@media only screen and (device-width : 414px) and (device-height : 896px) {
.bnr-sns {padding-bottom:2.56rem;}
.bnr-sns.nav-down {bottom:-6.83rem;}
}
*/

@keyframes zoomInUp {
    from {opacity:0; transform:scale(0.3); animation-timing-function:cubic-bezier(0.55, 0.055, 0.675, 0.19);}
    60% {opacity:1; transform:scale(0.475); animation-timing-function:cubic-bezier(0.175, 0.885, 0.32, 1);}
}
@keyframes scale {
    from {transform:scale(1); animation-timing-function:ease-out;}
    30% {transform:scale(1.3); animation-timing-function:ease-out;}
    to {transform:scale(1); animation-timing-function:ease-out;}
}
</style>
<script type="text/javascript">
$(function(){
    $('.btn-wish').click(function(e){
        e.preventDefault()
        $(this).toggleClass('on');
    });

	$( ".btn-more" ).click(function(e) {
        e.preventDefault()
		$(this).parent().siblings('ul').slideToggle("slow");
		$(this).toggleClass("unfold");
		reviewOption();
	});

    //scroll
    $(window).scroll(function(){
        var nowPos = $(this).scrollTop();
        var topPos = $(".sns-items").offset().top;
        if (topPos < nowPos) {
            $(".bnr-sns").removeClass('on');
        } else {
            $(".bnr-sns").addClass('on');
        }
    });
    setTimeout(function(){$(".bnr-sns").addClass('on');}, 40000);
});
</script>
<script type="text/javascript">
var isloading=true;
var myWish = ''

<%
if isArray(myWishArr) then
	for i=0 to uBound(myWishArr,2) 
	%>
	myWish = myWish + '<%=myWishArr(0,i)%>,'
	<%
	next
end if
%>
$(function(){
	fnAmplitudeEventMultiPropertiesAction('view_snsitem_main','','');
	//첫페이지 접수
	getList();

	//스크롤 이벤트 시작
	$(window).scroll(function() {
      if ($(window).scrollTop() >= $(document).height() - $(window).height() - 350){
          if (isloading==false){
            isloading=true;
			var pg = $("#popularfrm input[name='cpg']").val();
			pg++;
			$("#popularfrm input[name='cpg']").val(pg);
            setTimeout("getList()",500);
          }
      }
    });
});

function getList() {
	var str = $.ajax({
			type: "GET",
	        url: "/snsitem/snsitem_act.asp",
	        data: $("#popularfrm").serialize(),
	        dataType: "text",
	        async: false
	}).responseText;

	if(str!="") {
    	if($("#popularfrm input[name='cpg']").val()=="1") {
        	//내용 넣기			
        	$('#lySearchResult').html(str);					
        } else {        	
       		$str = $(str)       		
       		$('#lySearchResult').append($str)               
        }
        isloading=false;
        chkMyWish()	
    } else {
    	//더이상 자료가 없다면 스크롤 이벤트 종료
    	$(window).unbind("scroll");
    }
}
function chkMyWish(){	
    $('.item-list').each(function(index, item){
        if(myWish.indexOf($(this).attr("itemid")) > -1){
            $(this).find(".btn-wish").addClass("on")
        }        
    })
}
function TnAddFavoritePrd(iitemid){
<% if isapp = 1 then %>
    <% If IsUserLoginOK() Then %>        
        setTimeout(function(){
            fnAPPpopupBrowserURL("위시폴더","<%=wwwUrl%>/apps/appcom/wish/web2014/common/popWishFolder.asp?itemid="+iitemid+"&ErBValue=3");
        }, 100);
    <% Else %>
        calllogin();
    <% End If %>
<% else %>
    <% If IsUserLoginOK() Then %>
        top.location.href="/common/popWishFolder.asp?itemid="+iitemid+"&ErBValue=3";
    <% Else %>
        top.location.href = "/login/login.asp?backpath=<%=Server.URLencode(CurrURLQ())%>";
    <% End If %>
<% end if %>
}
function submitForm(){
	var sortMetValue = document.getElementById("sort").value;
	$('#lySearchResult').empty()
	$("#popularfrm input[name='cpg']").val(1);	
	$("#popularfrm input[name='sortMet']").val(sortMetValue);		
	getList();
}
</script>
            <div class="sns-best">
                <h2><img src="//fiximage.10x10.co.kr/m/2019/common/tit_sns_item.png" alt=""></h2>
                <div class="sorting-bar">
				
                    <select class="ftRt" id="sort" onchange="submitForm()" >
						<option value="1">등록 순</option>
                        <option value="2">NEW 아이템 순</option>
                        <option value="3">후기 많은 순</option>
                        <option value="4">위시 많은 순</option>
                    </select>
				<form id="popularfrm" name="popularfrm" method="get" style="margin:0px;">
					<input type="hidden" name="cpg" value="1" />				            									
					<input type="hidden" name="sortMet" value="1" />				            									
				</form>	
                    <i class="icon icon-arrow"></i>
                </div>
                <div class="sns-items">
                    <ul id="lySearchResult"></ul>									
                </div>
				<div class="bnr-sns on" id="bnr-sns">
					<span>텐바이텐 SNS 구독하고<br>다양한 소식을 빠르게 받아보세요!</span>
					<ul class="mWeb">
						<li><a href="http://bit.ly/2TMmgyd" target="_blank" onclick="fnAmplitudeEventMultiPropertiesAction('click_snsitem_facebook','','');"><img src="//fiximage.10x10.co.kr/m/2019/common/ico_facebook_3.png" alt="페이스북"></a></li>
						<li><a href="http://bit.ly/2TMn7ip" target="_blank" onclick="fnAmplitudeEventMultiPropertiesAction('click_snsitem_instar','','');" ><img src="//fiximage.10x10.co.kr/m/2019/common/ico_instagram_3.png" alt="인스트그램"></a></li>
					</ul>
					<ul class="mApp">
						<li><a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_snsitem_facebook','','', function(bool){if(bool) {fnAPPpopupExternalBrowser('http://bit.ly/2TMmgyd'); return false;}});return false;" ><img src="//fiximage.10x10.co.kr/m/2019/common/ico_facebook_3.png" alt="페이스북"></a></li>
						<li><a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_snsitem_instar','','', function(bool){if(bool) {fnAPPpopupExternalBrowser('http://bit.ly/2TMn7ip'); return false;}});return false;" ><img src="//fiximage.10x10.co.kr/m/2019/common/ico_instagram_3.png" alt="인스트그램"></a></li>
					</ul>
				</div>
            </div>     				
<!-- #include virtual="/lib/db/dbclose.asp" -->            
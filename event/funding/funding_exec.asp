<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  펀딩템 기획전
' History : 2019-04-15 최종원 생성
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
@import url('https://cdn.rawgit.com/openhiun/hangul/14c0f6faa2941116bb53001d6a7dcd5e82300c3f/nanumbarungothic.css');
.fundingtem {position: relative; padding-bottom: 2rem; background-color: #fff; font-family:  'AvenirNext-Bold', 'Nanum Barun Gothic', '나눔바른고딕', 'roboto', sans-serif; font-size: 1.11rem;}
.fundingtem > div {position: relative;}
.fundingtem .topic h2 {position: absolute; top: 0; left: 0; width: 100%; overflow: hidden; z-index: 999;}
.fundingtem .topic h2 img {position: relative; z-index: 999;}
.fundingtem .topic ul {position: relative;}
.fundingtem .topic ul li {position: absolute; display: block; width: 100%; transition:1s; z-index: 7;}
.fundingtem .topic ul li.on {width: 100%; z-index: 8;}
.fundingtem .topic ul li p {position: absolute; top: 0; left: 0; width: 0; overflow: hidden; overflow: hidden;}
.fundingtem .topic ul li.on p {animation: slidebg .4s both linear ; transform-origin: 0 0; }
.fundingtem .topic ul li span {position: absolute; bottom: 0; left: 0; z-index: 99; opacity: 0; }
.fundingtem .topic ul li.on span {animation: slideimg 5.8s .7s both ease-out ; transform: translateX(-.3rem);} 
.fundingtem .topic ul li,.fundingtem .topic ul li p {background-size: cover;}
.slide-01.on, .slide-03.on p {background-image: url(//webimage.10x10.co.kr/fixevent/event/2019/funding/m/bg_funding3.jpg?v=1.01);}
.slide-02.on, .slide-01.on p {background-image: url(//webimage.10x10.co.kr/fixevent/event/2019/funding/m/bg_funding1.jpg?v=1.01);}
.slide-03.on, .slide-02.on p {background-image: url(//webimage.10x10.co.kr/fixevent/event/2019/funding/m/bg_funding2.jpg?v=1.01);}
.fundingtem .topic dl {display: table; width: 32rem; padding: 2.56rem 1.27rem; margin: 0 auto; align-items: center;}
.fundingtem .topic dt {display: table-cell; width:34.78%; padding: 0 1rem; box-sizing: border-box; vertical-align: middle;}
.fundingtem .topic dd {display: table-cell; width: 64%; padding-left: .8rem; line-height: 1.54; color: #2a1c6c;}
.fundingtem .topic dd b {color: #cf59ff;}
.fundingtem .inner {width: 32rem; padding: 0 1.27rem; margin: 0 auto; box-sizing: border-box; border-top: 0.1rem solid #efefef; }
.fundingtem .sorting-bar {padding: 2.56rem 0 1.62rem; *zoom:1} 
.fundingtem .sorting-bar:after {display:block; clear:both; content:'';} 
.fundingtem .sorting-bar li {display: inline-block; margin-right: 1rem;}
.fundingtem .sorting-bar li:last-child {margin-right:0;}
.fundingtem .sorting-bar li a {position: relative; color: #b0b0b0; font-weight: bold;}
.fundingtem .sorting-bar li.on a {color: #342b78;}
.fundingtem .sorting-bar li.on a:after {content: ''; position: absolute; bottom: -0.35rem; left: 0; width: 100%; height: 0.13rem; background-color: #342b78;}
.fundingtem .items li {width: 100%; padding-bottom: 2.56rem; margin-bottom: 2.56rem; border-bottom: 0.1rem solid #f0f0f0;}
.fundingtem .items li:last-child {border: 0;}
.fundingtem .items li .pic {position: relative; display: block; overflow: hidden; height: 29.44rem; box-sizing: border-box;}
.fundingtem .items li .pic .thumbnail {background-color: #000;}
.fundingtem .items li .pic .thumbnail img {opacity: 0.98;}
.fundingtem .items li .pic .desc {position: absolute; bottom: 0; width: 100%; height: 4.01rem; color: #fff; background-color: rgba(0, 0, 0, 0.2); z-index: 999; *zoom:1} 
.fundingtem .items li .pic .desc:after {display:block; clear:both; content:'';} 
.fundingtem .items li .pic .desc .name {float: left; display: block; width: calc(100% - 9rem);  margin: 0; padding: 0 0.85rem; letter-spacing:0; box-sizing: border-box;}
.fundingtem .items li .pic .desc .name span {display: block; height: 4.01rem; padding-top: .1rem; line-height: 4.01rem; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; }
.fundingtem .items li .pic .desc .btn-wish {float: right; display: block; max-width:9rem; height:4.01rem; margin:0; background-color:transparent; text-align:center;}
.fundingtem .items li .pic .desc .btn-wish span {display: block; height: 4.01rem; line-height: 4.01rem; padding: .1rem 1rem 0 2rem; background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/funding/m/ico_heart.png); background-position: 0 1.3rem; background-size: 1.5rem auto; background-repeat:no-repeat; color:#fff; font-size: 1.11rem; font-weight:500;}
.fundingtem .items li .pic .desc .btn-wish.on span {background-position:0 -4.9rem;}
.fundingtem .items li .txt {padding: 1.28rem 0.85rem 0;}
.fundingtem .items li .txt p {margin-bottom: 0.42rem; color: #000; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; font-size: 1.27rem; letter-spacing: 0.04rem; line-height: 1.4; }
.fundingtem .items li .txt span {display: block; margin-bottom: 1.28rem; font-family:'CoreSansCLight', 'AppleSDGothicNeo-Regular', 'NotoSansKRRegular', sans-serif;	color: #666; line-height: 1.38; letter-spacing: 0.04rem; }
.fundingtem .items li .brand a {margin-left: 0.85rem; color: #cf59ff; font-size: 1.02rem;}
@keyframes slidebg {
	100% {width: 100%;}
}
@keyframes slideimg {
	20%,88% {transform: translateX(0); opacity: 1;}
	100% {opacity: 0; transform: translateX(.5rem);}
}
@-webkit-keyframes slidebg {
	100% {width: 100%;}
}
@-webkit-keyframes slideimg {
	20%,85% {transform: translateX(0); opacity: 1;}
	100% {opacity: 0; transform: translateX(.5rem);}
}
</style>
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
	//상단비쥬얼
	$('.topic li').append('<p></p>')
	var height=$('.topic h2').height();
	$('.topic ul,.topic li,.topic li p').css({'height':height});
	var id=0
	var moVing=setInterval(moVing,6500)
	function moVing(){
		if(id>1){id=0}
		else{id++;}
		$('.topic li').eq(id).addClass('on').siblings().removeClass('on');
	}
	
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
	$(".sorting-bar ul li").click(function(){        
		var sort = $(this).attr("sort");
		$(this).parent().children().removeClass("on")
		$(this).addClass("on")
		
		$("#popularfrm input[name='cpg']").val(1);
		$("#popularfrm input[name='sortMet']").val(sort);
		//데이터
		$('#lySearchResult').empty()
		getList();
	});  	
});

function getList() {
	var str = $.ajax({
			type: "GET",
	        url: "/event/funding/funding_act.asp",
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
</script>
            <!-- funding item  -->
            <div class="fundingtem">
                <div class="topic">
                    <h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/funding/m/tit_funding.png" alt="crowd funding item"></h2>
					<ul>
                        <li class="slide-01 on"><span><img src="//webimage.10x10.co.kr/fixevent/event/2019/funding/m/img_funding1.png" alt=""></span></li>
                        <li class="slide-02"><span><img src="//webimage.10x10.co.kr/fixevent/event/2019/funding/m/img_funding2.png?v=1.01" alt=""></span></li>
                        <li class="slide-03"><span><img src="//webimage.10x10.co.kr/fixevent/event/2019/funding/m/img_funding3.png" alt=""></span></li>
                    </ul>
					<dl>
                        <dt><img src="//webimage.10x10.co.kr/fixevent/event/2019/funding/m/txt_funding.png" alt="funding"></dt>
                        <dd>대중으로부터 <b>자금을 모아</b> 프로젝트를 <br>진행하는 소셜펀딩. 펀딩 달성에 성공한<br>잇템들을 텐바이텐에서 만나보세요!</dd>
                    </dl>
                </div>
                <div class="inner">                    
                    <div class="sorting-bar">
                        <ul class="ftRt">
							<li class="on" sort=1><a>최신 등록순</a></li>
                            <li sort=4><a>베스트 펀딩템</a></li>                            
                        </ul>
                    </div>
					<form id="popularfrm" name="popularfrm" method="get" style="margin:0px;">
						<input type="hidden" name="cpg" value="1" />				            									
						<input type="hidden" name="sortMet" value="1" />				            									
					</form>						                    
                    <div class="items type-thumb">
						<ul id="lySearchResult"></ul>									
                    </div>
                </div>
            </div>
            <!-- funding item  -->  				
<!-- #include virtual="/lib/db/dbclose.asp" -->            
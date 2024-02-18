<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 월페이퍼 detail페이지
' History : 2019-01-21 최종원
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, vUserID

vUserID = getEncLoginUserID
eCode = request("eventid")
%>
<%
dim sqlstr
dim evt_name
dim tempEventNameArr, wallpaperName, htmlValue

sqlstr = "           SELECT TOP 1 A.EVT_CODE "  + vbcrlf
sqlstr = sqlstr & " 	  , A.EVT_NAME  " + vbcrlf
sqlstr = sqlstr & " 	  , ISNULL(B.SUB_OPT2, 0) AS CNT    " + vbcrlf
sqlstr = sqlstr & " 	  , EVT_FORWARD_MO  " + vbcrlf
sqlstr = sqlstr & " 	  , evt_html_mo  " + vbcrlf  
sqlstr = sqlstr & "    FROM DB_EVENT.DBO.TBL_EVENT AS A     " + vbcrlf
sqlstr = sqlstr & "   LEFT JOIN DB_EVENT.DBO.TBL_EVENT_SUBSCRIPT B ON A.EVT_CODE = B.EVT_CODE       " + vbcrlf
sqlstr = sqlstr & "   INNER JOIN DB_EVENT.DBO.TBL_EVENT_DISPLAY C ON A.EVT_CODE = C.EVT_CODE    " + vbcrlf
sqlstr = sqlstr & "   WHERE EVT_KIND = 33   " + vbcrlf
sqlstr = sqlstr & "   AND A.EVT_CODE = '"& eCode &"'" + vbcrlf

rsget.Open sqlstr,dbget,1

if not rsget.EOF then
	htmlValue = rsget("evt_html_mo")	
	evt_name = rsget("evt_name")		
end if
rsget.close()   

	tempEventNameArr = split(evt_name, "_")                    
	if Ubound(tempEventNameArr) > 0 then
		wallpaperName = tempEventNameArr(1)
	end if                
%>
<script>
var initialValue
</script>
<%=htmlValue%>
<script>
$(function(){
    if(initialValue){
		console.log(initialValue.itemIds)
		//이미지 가져오기
		$.ajax({			
			type: "get",
			url: "/wallpaper/prdimgAjax.asp",
			data: "arriid="+initialValue.itemIds,
			cache: false,
			success: function(message) {
				console.log(message.items)
				$("#item-list li a").each(function(idx, item){
					<% if isApp="1" or isApp="2" then %>
						$(this).attr("href", "javascript:void(0)") 
						$(this).on("click", function(){
							TnGotoProduct(message.items[idx].itemid);
						})
					<% else %>
						$(this).attr("href", "/category/category_itemPrd.asp?itemid="+message.items[idx].itemid) 
					<% end if %>        
						$(this).find("img").attr("src", message.items[idx].imgurl);
						$(".wallpaper-story").html(initialValue.copy);
				})
			},
			error: function(err) {
				console.log(err.responseText);
			}
		});
	}
})
</script>
<script type="text/javascript">
$(function(){
	var itemSwiper = new Swiper(".wallpaper-swiper .swiper-container", {
			loop:true,
			speed:1000,
			autoplay:2000,
			pagination:".wallpaper-swiper .pagination-dot",
			paginationClickable:true
	});	
});
function loginCheckDownLoad() {	
	if ("<%=IsUserLoginOK%>"=="False") {		
		<% If isApp="1" or isApp="2" Then %>
			alert('로그인을 하셔야 다운받으실 수 있습니다.');
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>	
	}else{
		var viewval = '<%=eCode%>'
		var str = $.ajax({
			type: "GET",
			url:"/event/etc/doeventsubscript/doEventSubscript_wallpaper.asp",
			data: "viewval="+viewval+"&mode=down",
			dataType: "text",
			async: false,
			success: function(message) {
				fileDownload(initialValue.imgDownLoadNum);
			}			
		}).responseText;				
	}
}
</script>
<div class="weekly-wallpaper">
	<div class="wallpaper-swiper">
		<div class="swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/<%=eCode%>/m/img_detail_wallpaper1.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/<%=eCode%>/m/img_detail_wallpaper2.jpg" alt="" /></div>
			</div>
			<div class="pagination-dot wallpaper-dot"></div>
		</div>
		<div class="wallpaper-info">
			<div>
				<strong><%= wallpaperName %></strong>
				<a href="javascript:loginCheckDownLoad();" class="btn-download">다운로드 받기</a>
			</div>
		</div>
	</div>
	<div class="wallpaper-story">
		
	</div>
	<div class="wallpaper-related">
		<h2><span>바탕화면과</span> 관련된 상품</h2>
		<ul id="item-list">
			<li>
				<a href="" onclick=""><img src="" alt="" /></a>
			</li>
			<li>
				<a href="" onclick=""><img src="" alt="" /></a>
			</li>
			<li>
				<a href="" onclick=""><img src="" alt="" /></a>
			</li>
			<li>
				<a href="" onclick=""><img src="" alt="" /></a>
			</li>
		</ul>
		<a href="" onclick="fnAPPRCVpopSNS(); return false;" class="btn-share mApp">공유하기</a>
		<a href="" onclick="popSNSShareNew(); return false;" class="btn-share mWeb">공유하기</a>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
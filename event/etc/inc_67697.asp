<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 중국 사이트 오픈 이벤트
' History : 2015-11-25 원승현
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
Dim eCode , userid , strSql 
Dim myregcnt , myzipcode , myaddr
userid = GetEncLoginUserID()

IF application("Svr_Info") = "Dev" THEN
	eCode   =  65961
Else
	eCode   =  67697
End If

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg

dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle = Server.URLEncode("[10x10]Hello!10x10CHINA")
snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode)
snpPre = Server.URLEncode("10x10 Event")

'기본 태그
snpTag = Server.URLEncode("TenByTen")
snpTag2 = Server.URLEncode("#10x10")

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "拥有最多最全创意设计用品的10x10中文网正式上线啦\n\n从现在起,在中国也轻松收到来自韩国的10x10商品.\n\n10x10中文网,韩国潮流的最前端,期待你的关注! :）\n\n http://cn.10x10shop.com/Mobile"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2015/67697/img_bnr_kakao.png"
Dim kakaoimg_width : kakaoimg_width = "200"
Dim kakaoimg_height : kakaoimg_height = "200"
Dim kakaolink_url
	If isapp = "1" Then '앱일경우
		kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode
	Else '앱이 아닐경우
		kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode
	end if
%>
<style type="text/css">
img {vertical-align:top;}

.mEvt67697 h2 {visibility:hidden; width:0; height:0;}

.tentenBenefit {position:relative;}
.tentenBenefit .btnChina {position:absolute; bottom:8%; left:50%; width:90.625%; margin-left:-45.3125%;}

.sns {position:relative;}
.sns ul {overflow:hidden; position:absolute; bottom:12%; left:50%; width:64%; margin-left:-32%;}
.sns ul li {float:left; width:33.333%;}
.sns ul li a {overflow:hidden; display:block; position:relative; height:0; margin:0 7%; padding-bottom:80.25%; color:transparent; font-size:11px; line-height:11px; text-align:center;}
.sns ul li span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:black; opacity:0; filter:alpha(opacity=0); cursor:pointer;}
</style>
<script>

function jsevtchk(sns){

	var result;
	$.ajax({
		type:"GET",
		url:"/event/etc/doEventSubscript67697.asp",
		data: "mode=sns&snsgubun="+sns,
		dataType: "text",
		async:false,
		cache:false,
		success : function(Data){
			result = jQuery.parseJSON(Data);
			if(result.stcode=="tw") 
			{
				popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');
			}
			else if(result.stcode=="fb")
			{
				popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
			}
			else if(result.stcode=="ka")
			{
				parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>');
			}
			else if(result.stcode=="ln")
			{
				popSNSPost('ln','<%=snpTitle%>','<%=snpLink%>','','');
			}
			else if(result.stcode=="77")
			{
				alert('로그인 후에 이용 하실 수 있습니다.');
				return false;
			}
			else
			{
				alert('오류가 발생했습니다.');
				return false;
			}
		}
	});
}
</script>

<%' [M/A] 67697 HELLO! 10X10 CHINA %>
<div class="mEvt67697">
	<article>
		<h2 lang="en">HELLO! 10X10 CHINA</h2>
		<p lang="zh"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67697/txt_hello_china_v1.gif" alt="韩国最热创意设计品聚集地！从日记本到家居装饰品,应有尽有" /></p>

		<div class="tentenBenefit">
			<p lang="zh"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67697/txt_tenten_v1.jpg" alt="￥50($7.5)优惠券 注册就送, 10x10特别收纳小包 200个名额,先买先得!" /></p>
			<%' for dev msg : 중문모바일웹 링크 %>
			<div class="btnChina">
				<% If isApp="1" Then %>
					<a href="" onclick="fnAPPpopupExternalBrowser('http://cn.10x10shop.com/Mobile');return false;" lang="zh">
				<% Else %>
					<a href="http://www.10x10shop.com/Mobile" lang="zh" target="_blank">
				<% End If %>
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/67697/btn_tenten_china.png" alt="点击进入10x10中文网" />
				</a>
			</div>
		</div>

		<%' sns share %>
		<div class="sns">
			<p lang="zh"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67697/txt_sns.png" alt="快把惊喜消息告诉周围朋友们吧！" /></p>
			<ul>
				<li><a href="" lang="en" onclick="jsevtchk('fb'); return false;"><span></span>Facebook</a></li>
				<li><a href="" lang="en" onclick="jsevtchk('ka'); return false;"><span></span>Kakao Talk</a></li>
				<li><a href="" lang="en" onclick="jsevtchk('ln'); return false;"><span></span>LINE</a></li>
			</ul>
		</div>
	</article>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
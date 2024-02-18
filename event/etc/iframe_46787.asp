<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  21004
Else
	eCode   =  46787
End If

dim com_egCode, bidx
	Dim iCTotCnt, arrCList
	Dim timeTern, totComCnt

	com_egCode = requestCheckVar(Request("eGC"),1)	'그룹 번호(엣지1, 초식2, 연하3)

%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 내년에는 생겨요</title>
<style type="text/css">
.mEvt46787 {}
.mEvt46787 img {vertical-align:top;}
.mEvt46787 .nextYearPkg ul {overflow:hidden; width:100%;}
.mEvt46787 .nextYearPkg li {float:left; width:50%;}
.mEvt46787 .nextYearPkg .apply {position:relative;}
.mEvt46787 .nextYearPkg .apply .applyBtn {position:absolute; top:25%; left:50%; display:block; width:46%; margin-left:-23%;}
</style>

<script type="text/javascript">
	function jsSubmitComment(frm){
	<% if datediff("d",date(),"2013-11-24")>0 then %>
		<% if Not(IsUserLoginOK) then %>
		    jsChklogin('<%=IsUserLoginOK%>');
		    return false;
		<% end if %>

	   frm.action = "/event/etc/doEventSubscript46787.asp";
	   return true;

	<% else %>
			alert('이벤트가 종료되었습니다.');
			return;
	<% end if %>
	}
</script>
<div id="fb-root"></div>
<script>(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/ko_KR/all.js#xfbml=1";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));</script>
</head>
<body>

			<!-- content area -->
			<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;">
			<input type="hidden" name="eventid" value="<%=eCode%>">
			<input type="hidden" name="bidx" value="<%=bidx%>">
			<input type="hidden" name="iCTot" value="">
			<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
			<div class="content" id="contentArea">
				<div class="mEvt46787">
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/46787/46787_head.png" alt="내년에는 생겨요" style="width:100%;" /></div>
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/46787/46787_img01.png" alt="추첨을 통해 총 150분께 내년에는 생겨요 패키지 중 1종을 랜덤으로 보내드립니다!" style="width:100%;" /></div>
					<dl class="nextYearPkg">
						<dt><img src="http://webimage.10x10.co.kr/eventIMG/2013/46787/46787_img02.png" alt="내년에는 생겨요 패키지" style="width:100%;" /></dt>
						<dd>
							<ul>
								<li><img src="http://webimage.10x10.co.kr/eventIMG/2013/46787/46787_img03.png" alt="KNIT MUFFLER" style="width:100%;" /></li>
								<li><img src="http://webimage.10x10.co.kr/eventIMG/2013/46787/46787_img04.png" alt="CARD HOLDER" style="width:100%;" /></li>
								<li style="width:100%;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46787/46787_img05.png" alt="DENIM TOTE BAG" style="width:100%;" /></li>
							</ul>
						</dd>
						<dd class="apply">
							<img src="http://webimage.10x10.co.kr/eventIMG/2013/46787/46787_img06.png" alt="" style="width:100%;" />
							<input type="image"  class="applyBtn" src="http://webimage.10x10.co.kr/eventIMG/2013/46787/46787_btn_apply.png" alt="응모하기" />

						</dd>
					</dl>
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/46787/46787_notice.png" alt="이벤트 안내" style="width:100%;" /></div>
				</div>
			</div>
			</form>
			<!-- //content area -->
<div class="fb-comments" data-href="http://www.10x10.co.kr/event/etc/iframe_suprise46224.asp" data-width="750" data-numposts="2" data-colorscheme="light"></div>
</body>
</html>
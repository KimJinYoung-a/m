<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
	<!-- #include virtual="/lib/inc/head.asp" -->
	<title>생활감성채널, 텐바이텐 > 감성 충전을 위한 히치하이킹</title>
	<style type="text/css">
		.evt42035 img {vertical-align:top;}
		.evt42035 .hitcShare {position:relative; width:100%;}
		.evt42035 .hitcShare p {margin-left:-20px; color:#999; font-size:0.75em; font-weight:bold; letter-spacing:-1px;}
		.evt42035 .hitcShare .hitcBtn {overflow:hidden; position:absolute; right:10px; top:25%;}
		.evt42035 .hitcShare .hitcBtn a {display:inline-block; float:left; margin-left:3px; }
	</style>


			<!-- content area -->
			<div class="content" id="contentArea">
				<div class="evt42035">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42035/42035_img01.png" alt="감성충전을 위한 히치하이킹" style="width:100%;" /></p>
					<p><a href="https://itunes.apple.com/kr/app/10x10-hichihaikeo/id635127946?mt=8 "><img src="http://webimage.10x10.co.kr/eventIMG/2013/42035/42035_img02.png" alt="Download on the App store" style="width:100%;" /></a></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42035/42035_img03.png" alt="이야기로 힘을 얻고, 이야기에 힘이 되는 히치하이커" style="width:100%;" /></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42035/42035_img04.png" alt="주요기능1. 북마크" style="width:100%;" /></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42035/42035_img05.png" alt="주요기능2. 공유하기" style="width:100%;" /></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42035/42035_img06.png" alt="주요기능3. 배경음악" style="width:100%;" /></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42035/42035_img07.png" alt="" style="width:100%;" /></p>
					<div class="hitcShare">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42035/42035_img08.png" alt="히치하이커 앱 출시소식! 친구들에게도 전해주세요" style="width:100%;" /></p>
								<%
									dim snpTitle, snpLink, snpPre, snpTag, snpTag2
									snpTitle = Server.URLEncode("감성충전을 위한 히치하이킹")
									snpLink = Server.URLEncode("http://www.10x10.co.kr/event/eventmain.asp?eventid=42034")

									'기본 태그
									snpPre = Server.URLEncode("텐바이텐")
									snpTag = Server.URLEncode("텐바이텐 HITCHHIKER E-BOOK APP OPEN")
									snpTag2 = Server.URLEncode("#10x10")
								%>
						<div class="hitcBtn">
							<a href=""><img src="http://webimage.10x10.co.kr/eventIMG/2013/42035/42035_sns01.png" onClick="popSNSPost('m2','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag%>')" alt="미투데이" style="width:25px;cursor:pointer;" /></a>
							<a href=""><img src="http://webimage.10x10.co.kr/eventIMG/2013/42035/42035_sns02.png" onClick="popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>')" alt="트위터" style="width:25px;cursor:pointer;" /></a>
							<a href=""><img src="http://webimage.10x10.co.kr/eventIMG/2013/42035/42035_sns03.png" onClick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','')" alt="페이스북" style="width:25px;cursor:pointer;" /></a>
						</div>
					</div>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42035/42035_img09.png" alt="" style="width:100%;" /></p>
				</div>
			</div>
			<!-- //content area -->

<!-- #INCLUDE Virtual="/lib/footer.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->
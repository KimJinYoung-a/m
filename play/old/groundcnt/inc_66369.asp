<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 텐바이텐 고향사진전
' History : 2015.09.25 원승현 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbCTopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->

<%
Dim eCode, eCodedisp
IF application("Svr_Info") = "Dev" THEN
	eCode   =  64899
Else
	eCode   =  66369
End If

dim userid, i, vreload
	userid = getloginuserid()
	vreload	= requestCheckVar(Request("reload"),2)

dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop
dim iCPageSize, iCCurrpage, isMyComm
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt, sqlstr
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호

IF iCCurrpage = "" THEN
	iCCurrpage = 1
END IF
IF iCTotCnt = "" THEN
	iCTotCnt = -1
END IF

iCPerCnt = 4		'보여지는 페이지 간격
'한 페이지의 보여지는 열의 수
if blnFull then
	iCPageSize = 6	'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
else
	iCPageSize = 6	'메뉴가 있으면 10개			'/수기이벤트 둘다 강제 12고정
end if

'// sns데이터 총 카운팅 가져옴
sqlstr = "select count(*) "
sqlstr = sqlstr & " from [db_Appwish].[dbo].[tbl_snsSelectData]"
sqlstr = sqlstr & " Where evt_code="& eCode &""

'response.write sqlstr & "<br>"
rsCTget.Open sqlstr, dbCTget, adOpenForwardOnly, adLockReadOnly
	iCTotCnt = rsCTget(0)
rsCTget.close

iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1
%>

<style type="text/css">
img {vertical-align:top;}

.topic {position:relative;}
.topic .btngo {position:absolute; bottom:12%; left:50%; width:43.125%; margin-left:-21.562%;}

.instagram {position:relative;}
.instagramwrap {position:absolute; top:15%; left:0; width:100%;}
.instagramList {overflow:hidden; padding:0 4%;}
.instagramList li {float:left; width:50%;}
.instagramList li a {display:block; margin:0 5% 30%; padding:7%; background-color:#fff; box-shadow:0px 0px 6px -1px rgba(000,000,000,0.15);}
.instagramList li .article {overflow:hidden; height:52px; color:#404040; font-size:11px;}
.instagramList li .article p {line-height:1.375em;}
.instagramList li .id {display:block; margin:5% 0 1%; color:#396991; font-weight:bold; font-size:12px;}

.paging {position:absolute; bottom:18%; left:0; width:100%;}
.paging span, .paging span.arrow {border:1px solid #acaeae;}
.paging span a {color:#000;}
.paging span.arrow {background-color:#aaabab;}
.paging span.current {background-color:rgba(255,255,255,0.8); border:1px solid #486cc8;}
.paging span.current a {color:#486cc8;}

@media all and (min-width:360px){
	.instagramList li .article {height:58px; font-size:12px;}
	.instagramList li .id {font-size:13px;}
}

@media all and (min-width:375px){
	.instagramList li .linkarea {margin-bottom:31%;}
}

@media all and (min-width:480px){
	.instagramList li .article {height:90px; font-size:16px;}
	.instagramList li .id {font-size:18px;}
}
</style>
<script type="text/javascript">

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

</script>


<div class="mPlay20150928">
	<article>
		<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20150928/tit_hometown.png" alt="내고향 사진전" /></h2>
		<div class="topic">
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150928/txt_today.png" alt="오늘은 추석입니다! 고향으로 떠나서 반가운 가족, 친구들과 만나셨나요? 혹은 일이 있어 미처 가지 못하셨나요? 자주 찾아가지 못하고 명절에만 만나는 고향이지만 언제나 같은 자리에서 그 모습 그대로 나를 반겨주는 기분입니다." /></p>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150928/txt_your_hometown.png" alt="여러분의 고향은 어디인가요? 플레이에서 이미 고향에 계신 분들은 내 고향 자랑도 하고, 가지 못하신 분들은 동향인 분들을 통해 나의 고향 소식을 만나보세요!" /></p>
			<div class="btngo"><a href="#instagram"><img src="http://webimage.10x10.co.kr/playmo/ground/20150928/btn_go.png" alt="고향으로 떠나기" /></a></div>
		</div>

		<div class="photo">
			<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20150928/tit_photo_exhibition.png" alt="내고향 사진전" /></h3>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150928/txt_photo_exhibition.jpg" alt="전시 참여 방법 고향의 사진을 촬영하거나 앨범에 저장된 고향 사진을 선택합니다. 인스타그램에 #텐바이텐고향전 해시태그와 함께 업로드 해주세요!" /></p>
		</div>


		<% '<!-- 인스타그램 이미지 불러오기 --> %>
		<div class="instagram" id="instagram">
			<div class="instagramwrap">
				<%
				sqlstr = "Select * From "
				sqlstr = sqlstr & " ( "
				sqlstr = sqlstr & " 	Select row_Number() over (order by idx desc) as rownum, snsid, link, img_low, img_thum, img_stand, text, snsuserid, snsusername, regdate "
				sqlstr = sqlstr & " 	From db_AppWish.dbo.tbl_snsSelectData "
				sqlstr = sqlstr & " 	Where evt_code="& eCode &""
				sqlstr = sqlstr & " ) as T "
				sqlstr = sqlstr & " Where RowNum between "&(iCCurrpage*iCPageSize)-5&" And "&iCCurrpage*iCPageSize&" "
				
				'response.write sqlstr & "<br>"
				rsCTget.Open sqlstr, dbCTget, adOpenForwardOnly, adLockReadOnly
				If Not(rsCTget.bof Or rsCTget.eof) Then
				%>
				<ul class="instagramList">
					<%
						Do Until rsCTget.eof
					%>
					<% '6개 뿌리기 %>
					<li>
						<% If IsApp="1" Then %>
							<a href="" onclick="openbrowser('<%=rsCTget("link")%>'); return false;" target="_blank">
						<% Else %>
							<a href="<%=rsCTget("link")%>"  target="_blank">
						<% End If %>
						<div class="figure"><img src="<%=rsCTget("img_stand")%>" alt="" /></div>
						<div class="article"><span class="id"><%= printUserId(rsCTget("snsusername"),2,"*") %></span> <p><%=chrbyte(stripHTML(rsCTget("text")),23,"Y")%></p></div>
						</a>
					</li>
					<%
					rsCTget.movenext
					Loop
					%>
				</ul>
			</div>
			<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
			<img src="http://webimage.10x10.co.kr/playmo/ground/20150928/bg_road_01.jpg" alt="" />
			<img src="http://webimage.10x10.co.kr/playmo/ground/20150928/bg_road_02.jpg" alt="" />
			<img src="http://webimage.10x10.co.kr/playmo/ground/20150928/bg_road_03.jpg" alt="" />
			<%
			End If
			rsCTget.close
			%>
		</div>
		<% '<!--// 인스타그램 이미지 불러오기 --> %>
		<div class="memory">
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150928/txt_memory.png" alt="언제나 그 자리에서 기다려주는 고향의 아름다움을 사진으로 남겨보세요! :)" /></p>
		</div>

	</article>
</div>
<!-- //CAMERA #4 -->

<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
<input type="hidden" name="iCC" value="1">
<input type="hidden" name="reload" value="ON">
<input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
</form>

<script type="text/javascript">
$(function(){
	$(".btngo a").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top},1000);
	});

	<% if vreload<>"" then %>
		$('html,body').animate({scrollTop: $("#instagram").offset().top},'slow');
	<% end if %>

});
</script>

<!-- #include virtual="/lib/db/dbclose.asp" -->
<!-- #include virtual="/lib/db/dbCTclose.asp" -->
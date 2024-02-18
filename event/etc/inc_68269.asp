<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 따따블 마일리지 응팔 사전 구매 고객 대상
' History : 2015-12-21 이종화
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<%
Dim eCode

IF application("Svr_Info") = "Dev" THEN
	eCode   =  65990
Else
	eCode   =  68269
End If
%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:21px;}}

img {vertical-align:top;}

.mEvt68269 button {width:100%; background:transparent; vertical-align:top;}

.noti {padding:2.5rem 2rem; background-color:#f6f6f6;}
.noti h3 {color:#4b4b4b; font-size:1.4rem;}
.noti h3 strong {border-bottom:2px solid #4b4b4b;}
.noti ul {margin-top:2rem;}
.noti ul li {position:relative; margin-top:0.5rem; padding-left:1rem; color:#666; font-size:1.1rem; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:0.6rem; left:0; width:0.5rem; height:0.15rem; background-color:#666;}
</style>
<div class="mEvt68269">
	<article>
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/68269/m/double_mileage_tit.png" alt="따따블 마일리지" /></h2>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/68269/m/double_mileage_img.png" alt="" /></p>
		<button onclick="<%=chkiif(isapp=1,"fnAPPpopupMyGoodsusing()","location.href='/my10x10/goodsusing.asp'")%>;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68269/m/double_mileage_btn.png" alt="포토후기 남기기" /></button>
		<section class="noti">
			<h3><strong>이벤트 안내</strong></h3>
			<ul>
				<li>텐바이텐 회원대상 이벤트 입니다. (비회원 참여 불가)</li>
				<li><strong>본 이벤트는 응답하라 포토후기를 남기신 고객분들에게만 12월 31일 300마일리지가 지급될 예정입니다.</strong></li>
			</ul>
		</section>
	</article>
</div>
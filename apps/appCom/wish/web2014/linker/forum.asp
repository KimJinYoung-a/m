<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'####################################################
' Description : 링커(20주년) 포럼
' History : 2021-09-24 이전도 생성
'####################################################
dim gnbflag : gnbflag = RequestCheckVar(request("gnbflag"),1)
If gnbflag = "1" Then '//gnb 숨김 여부
	gnbflag = true
Else
	gnbflag = False
	strHeadTitleName = "베스트 서머리"
End if

Dim index : index = Request("idx")

Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle = "저 텐바이텐이 드디어 스무 살이 되었거든요!"
snpLink = wwwUrl & "/linker/forum.asp?idx=" & index
snpPre = "10x10 20th"

'기본 태그
snpTag = "저 텐바이텐이 드디어 스무 살이 되었거든요!"
snpTag2 = "#10x10"
snpImg = "http://fiximage.10x10.co.kr/web2021/anniv2021/m/sharing.jpg"

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "저 텐바이텐이 드디어 스무 살이 되었거든요! - 텐텐이들의 칭찬과 축하에 감사하며 다양한 이벤트와 이야기를 준비했어요"
Dim kakaoimage : kakaoimage = "http://fiximage.10x10.co.kr/web2021/anniv2021/m/sharing.jpg"
Dim kakaoimg_width : kakaoimg_width = "200"
Dim kakaoimg_height : kakaoimg_height = "200"
Dim kakaolink_url

If isapp = "1" Then '앱일경우
	kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/linker/forum.asp?idx=" & index
Else '앱이 아닐경우
	kakaolink_url = "http://m.10x10.co.kr/linker/forum.asp?idx=" & index
end if 

%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<style>
.header-white,
.header-white .title-wrap {background-color:rgba(255, 255, 255, 0.9);}
.header-popup {position:fixed;}
.header-popup .title-wrap {background-color:#f7f7f7;}
.header-popup h2 {overflow:hidden; width:15.01rem; margin:-0.17rem auto 0; padding-top:0.17rem; color:#000; font-size:1.45rem; line-height:1.88rem; text-overflow:ellipsis; white-space:nowrap; text-align:center;}
.tenten-header {width:100%;}
.tenten-header .title-wrap {position:relative; height:4.78rem; padding:1.62rem 1.19rem 0 1.54rem; background-color:rgba(255, 255, 255, 0.93);}
.tenten-header .btn-close {position:absolute; top:50%; right:1.19rem; margin-top:-1.11rem; background-color:transparent; background-position:-13.01rem -1.83rem; text-indent:-999em;}
.sns-list .icon {display:block; position:relative; border-radius:50%;}
.sns-list .icon:after {content:' '; position:absolute; top:0; left:0; width:100%; height:100%;}
/* fixed css */
.fixed-top {position:fixed; top:0; left:0; z-index:10;}
.fixed-bottom {position:fixed; bottom:0; left:0;}
/*.bnr-newmember-event a:after,*/
.header-white .btn-close:after,
.header-white .btn-close-down:after {background-image:url(http://fiximage.10x10.co.kr/m/2017/common/bg_sp.png?v=1.94); background-repeat:no-repeat; background-size:17.07rem auto;}

/* sns share layer */
.ly-sns {display:none;}
.ly-sns .inner,.ly-sns .tenten-header,.ly-sns .title-wrap {border-radius:.68rem .68rem 0 0;}
.ly-sns .inner {z-index:100001; width:100%; background-color:#fff;}
.ly-sns .tenten-header {display:block !important; position:static;}
.ly-sns .tenten-header:after {display:none;}
.ly-sns .title-wrap {height:4.35rem; padding:1.71rem 0 0;}
.ly-sns h2 {width:29.26rem; padding-bottom:.99rem; padding-top:0; padding-left:.68rem; margin:0 auto; border-bottom:solid #f5f5f5 .09rem; font-size:1.37rem; line-height:1.22; text-align:left;}
.ly-sns .btn-close {position:absolute; top:.23rem; right:0; width:4.43rem; height:100%; margin-top:0; background:transparent none; color:transparent;}
.ly-sns .btn-close:after {content:' '; position:absolute; top:50%; left:50%; width:1.37rem; height:1.37rem; margin:-0.68rem 0 0 -0.68rem; background-position:-13.78rem 0;}
.ly-sns .sns-list ul {display:flex; flex-wrap:wrap; margin-top:.68rem; margin-bottom:4.35rem;}
.ly-sns .sns-list li {width:33.333%; margin:2.05rem 0 0;}
.ly-sns .icon {width:4.78rem; height:4.78rem; margin:0 auto; background-image:url(http://fiximage.10x10.co.kr/m/2020/common/ico_sns.png); background-size:15.64rem 18.49rem; background-color:#eee; text-indent:-999em;}
.ly-sns .icon-url {background-position:0 -10.41rem}
.ly-sns .icon-kakao {background-position:-10.41rem 0;}
.ly-sns .icon-line {background-position:0 -5.21rem;}
.ly-sns .icon-insta {background-position:-5.21rem 0;}
.ly-sns .icon-facebook {background-position:0 0;}
.ly-sns .icon-pinterest {background-position:-5.21rem -5.21rem;}
.ly-sns .icon-twitter {background-position:-10.41rem -5.21rem;}
.ly-sns .icon-url:after {background-position:0 -10.41rem;}
.ly-sns .icon:after {display:none;}
/* app 전용 */
.ly-sns .sns-list .share-url {display:flex; width:80.93%; height:2.73rem; margin:2.05rem auto 0;}
.ly-sns .sns-list .share-url .ellipsis {overflow:hidden; width:72.63%; height:100%; padding:0 1.11rem; color:#999; font-size:1.11rem; line-height:2.83rem; font-family:'CoreSansCLight', 'AppleSDGothicNeo-Light', 'NotoSansKRLight'; border:solid .085rem #eee; border-radius:.34rem 0 0 .34rem; text-overflow:ellipsis;}
.ly-sns .sns-list .share-url .btn-url {width:27.37%; height:100%; background-color:#00be91; border-radius:0 .34rem .34rem 0; color:#fff; font-size:1.19rem; line-height:3.03rem; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.lySlideUp {animation:lySlideUp 0.5s cubic-bezier(.17,.67,.62,.88);}
@keyframes lySlideUp {
	0% {bottom:-20.82rem;}
	100% {bottom:0;}
}
.lySlideDown {animation:lySlideDown 0.5s cubic-bezier(.17,.67,.62,.88);}
@keyframes lySlideDown {
	0% {bottom:0;}
	100% {bottom:-20.82rem;}
}

<% If gnbflag = true Then %>
.modal_type4 .modal_wrap {height:calc(93vh - 40px);}
<% End If %>
</style>
<meta property="og:image" content="http://fiximage.10x10.co.kr/web2021/anniv2021/m/sharing.jpg"/>
</head>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<body class="default-font body-<%=chkiif(gnbflag,"main","sub")%>">
	<% server.Execute("/linker/exc_forum.asp") %>
	<input type="hidden" id="layerKind" value="event">
	<input type="hidden" id="layerItemId" value="">
	<input type="hidden" id="layerItemName" value="">
	<script>
		$(function() {
			fnAPPchangPopCaption('😘💬');
		});

		// SNS 공유 팝업
		function fnAPPRCVpopSNS(){
			$("#lySns").show();
			$("#lySns .inner").removeClass("lySlideDown").addClass("lySlideUp");
			return false;
		}
	</script>
	<!-- #include virtual="/apps/appCom/wish/web2014/common/LayerShare.asp" -->
</body>
</html>
<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : MD 텐텐 문구 페어
' History : 2021-02-26 임보라
'####################################################
dim brandListMasterIdx, deviceType, mastercode
IF application("Svr_Info") = "Dev" THEN
	masterCode = "16"
	brandListMasterIdx = "2"
else
	masterCode = "19"
	brandListMasterIdx = "4"
end if

if flgDevice = "M" then
	deviceType = "m"
else
	deviceType = "a"
end if
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<style>
.stationery-fair {position:relative;}
.stationery-fair .topic {position:relative; background:#fff04b;}
.stationery-fair .topic .deco {position:absolute;}
.stationery-fair .topic .deco:nth-of-type(1) {left:7.6%; top:19.3vw; width:18.8vw; height:18.8vw; background:#00b0e9; animation:slideY 1s 10 alternate linear;}
.stationery-fair .topic .deco:nth-of-type(2) {left:50.9%; top:51.2vw; border:solid transparent; border-width:10.3vw 0 10.3vw 17.8vw; border-left-color:#00b0e9; animation:pulse 1s 10 alternate linear;}
.stationery-fair .topic .deco:nth-of-type(3) {left:70.5%; top:82.8vw; border:solid transparent; border-width:0 12vw 12vw; border-bottom-color:#ff85b3; animation:slideY 1s 10 alternate linear;}
.stationery-fair .topic .deco:nth-of-type(3)::after {content:' '; position:absolute; top:12vw; left:-12vw; border:solid transparent; border-width:12vw 12vw 0; border-top-color:#ff85b3;}
.stationery-fair .intro {position:relative;}
.stationery-fair .intro .btn-brand {position:absolute; top:61%; right:6%; width:46.3%; background:none; animation:bounce 1s 20;}

.section-oneday {position:relative; background:#fff04b;}
.section-oneday .desc {position:absolute; top:61vw; left:0; width:100%; padding:0 8%;}
.section-oneday .headline {font-size:7.73vw; line-height:1.24; color:#000; font-family:var(--bd);}
.section-oneday .subcopy {font-size:4.13vw; line-height:1.45; color:#444; margin-top:.5rem;}
.section-special {position:relative; background:#f7f4df;}
.section-special .thumbnail {overflow:hidden; height:32rem;}
.section-special .desc {position:relative; margin-top:8%; padding:0 8% 12%; font-family:var(--sb);}
.section-special .headline {max-width:80%; font-size:6vw; line-height:1.24; color:#000; margin-bottom:.5rem; word-break:break-all;}
.section-special .subcopy {font-size:4.13vw; line-height:1.45; color:#444; font-family:var(--md);}
.section-special .discount {position:absolute; right:8%; top:.2rem; font-size:6vw; color:#ff335a;}
.stationery-fair .evt-slider .pagination-progressbar {position:absolute; width:100%; height:.6rem; left:0; top:32rem; background:#fff; z-index:10;}
.stationery-fair .evt-slider .pagination-progressbar-fill {position:absolute; left:0; top:0; width:100%; height:100%; background:#00b0e9; transform:scaleX(0); transform-origin:left top; transition-duration:300ms;}

.section-justsold {position:relative; padding-bottom:10%; background:#00b0e9;}
.section-justsold .items-list {margin-top:1rem;}
.section-justsold .items-list ul {display:flex; flex-flow:row wrap; padding:0 7%;}
.section-justsold .items-list ul::after {content:' '; display:block; clear:both;}
.section-justsold .items-list li {position:relative; float:left; width:50%; padding:0 1% 12%;}
.section-justsold .items-list li > a {display:block; position:relative;}
.section-justsold .items-list .label-time {position:absolute; left:0; top:-1rem; z-index:10; height:2.1rem; padding:0 .7em; font-size:1.19rem; line-height:2.4rem; color:#fff; letter-spacing:-.5px; background:#000; border-radius:.5em .5em .5em 0;}
.section-justsold .items-list .label-time::after {content:' '; position:absolute; left:0; bottom:-.4rem; border:solid transparent; border-width:.43rem .51rem 0 0; border-top-color:#000;}
.section-justsold .items-list .desc {padding:1rem .5rem 0; font-size:1.19rem; line-height:1.3; color:#fff; word-break:break-all;}
.section-justsold .items-list .price {font-family:var(--bd);}
.section-justsold .items-list .discount {padding-left:.8em; color:#f3df02;}
.section-justsold .items-list .name {margin-top:.7em;}
.section-justsold .items-list .thumbnail:before {left:0; top:0; z-index:5; width:100%; height:100%; margin:0; background:rgba(0,0,0,.02);}
.section-justsold .items-list .soldout .thumbnail:before {content:'일시 품절'; padding-top:41%; text-align:center; color:#fff; font:normal 2rem/1.2 'AppleSDGothicNeo-SemiBold','NotoSansKRMedium'; background:rgba(0,0,0,.4); box-sizing:border-box;}
.section-justsold .items-list .adult .thumbnail:before {background:#f5f5f5;}
.section-justsold .items-list .adult .thumbnail:after {content:'19'; position:absolute; left:50%; top:50%; z-index:6; width:6.84rem; height:6.84rem; margin:-3.59rem 0 0 -3.59rem; color:#ccc; text-align:center; font:normal 3rem/6.84rem 'CoreSansCMedium'; border:.34rem solid #ddd; border-radius:50%;}

.section-brand {position:relative; padding-bottom:15%; background:#fff;}
.section-brand .tab {display:flex; justify-content:center; margin-bottom:4%;}
.section-brand .tab button {width:40%; height:3.41rem; margin:0 .2em; padding-top:.1em; font-family:var(--bd); font-size:1.5rem; color:#222; background:none; border:1px solid #222;}
.section-brand .tab button.active {color:#fff; background:#444;}
.section-brand .brand-list {font-family:var(--bd); font-size:1.2rem; line-height:1.2; color:rgba(0,0,0,.9);}
.section-brand .brand-list ul {display:flex; flex-flow:row wrap; padding:0 8% 0 16%;}
.section-brand .brand-list ul::after {content:' '; display:block; clear:both;}
.section-brand .brand-list li {position:relative; float:left; width:50%;}
.section-brand .brand-list li > a {overflow:hidden; display:block; width:80%; padding:.8em 0; word-break:break-all; white-space:nowrap; text-overflow:ellipsis;}

@keyframes pulse {
	0% {transform:scale3d(.9,.9,.9);}
	100% {transform:scale3d(1.1,1.1,1.1);}
}
@keyframes slideY {
	0% {transform:translateY(-.8rem);}
	100% {transform:translateY(.8rem);}
}
@keyframes bounce {
	from, to {transform:none; animation-timing-function:ease-in;}
	50% {transform:translateY(1rem); animation-timing-function:ease-out;}
}
</style>
<script>
    // 개발 여부
    const is_develop = unescape(location.href).includes('//testm') || unescape(location.href).includes('//localm');
    // 앱 여부
    const is_app = location.pathname.toLowerCase().indexOf('/apps/appcom/wish/web2014') > -1;

    // API 공통url
    const apiurl = function() {
        let apiUrl
        if( is_develop ) {
            apiUrl =  '//testfapi.10x10.co.kr/api/web/v1'
        } else {
            apiUrl =  '//fapi.10x10.co.kr/api/web/v1'
        }
        return apiUrl;
    }();
</script>
<div class="stationery-fair">
	<div class="topic">
		<h2><img src="//webimage.10x10.co.kr/fixevent/event/2021/109789/m/tit_fair.jpg" alt="텐텐 문구 페어"></h2>
		<i class="deco"></i><i class="deco"></i><i class="deco"></i>
	</div>
	<div class="intro">
		<p><img src="//webimage.10x10.co.kr/fixevent/event/2021/109789/m/txt_intro.jpg" alt="최대 20% 쿠폰 증정"></p>
		<a href="#brand" class="btn-brand"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109789/m/btn_brand.png" alt="참여브랜드 보러가기"></a>
	</div>

    <!-- #include Virtual="/event/etc/StationeryFair/inc_oneday_rolling.asp" -->

	<!-- 방금 판매된 상품 -->
	<!-- #include virtual="/event/etc/StationeryFair/inc_justsold_list.asp" -->

	<!-- 브랜드 -->
	<!-- #include virtual="/event/etc/StationeryFair/inc_brand_list.asp" -->
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
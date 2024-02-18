<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 링커(20주년) 포럼
' History : 2021-09-24 이전도 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
    '// pc일경우 m -> pc 리다이렉트
    Dim redirect_url : redirect_url = fnRedirectToPc()
    If redirect_url <> "" Then
        Response.redirect redirect_url & "/linker/forum.asp?idx=" & forumIndex
        Response.end
    End If

    dim gnbflag , testmode, defaultAPIURL
    gnbflag = RequestCheckVar(request("gnbflag"),1)
    If gnbflag <> "" Then '//gnb 숨김 여부
        gnbflag = true
    Else
        gnbflag = False
        strHeadTitleName = "헤더"
    End if
%>
<script src="https://unpkg.com/lodash@4.13.1/lodash.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.auto.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bodymovin/5.7.4/lottie_svg.min.js"></script>
<script src="/lib/js/mobile-detect.js"></script>
<% IF application("Svr_Info") = "Dev" or testmode = "1" THEN %>
<script src="/vue/vue_dev.js"></script>
<% Else %>
<script src="/vue/2.5/vue.min.js"></script>
<% End If %>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="/vue/vuex.min.js"></script>
<script>
    const staticImgUpUrl = "<%= staticImgUpUrl %>";
    const wwwUrl = "<%=wwwUrl%>";
    var userAgent = navigator.userAgent.toLowerCase();
</script>
<style>
.fade-enter-active, .fade-leave-active {transition: opacity .4s;}
.fade-enter, .fade-leave-to  {opacity: 0;}
</style>

<div id="app"></div>

<script src="/lib/js/infinitegrid.gridlayout.min.js"></script>

<script src="/vue/components/common/functions/common.js"></script>
<script src="/vue/components/linker/linker_mixins.js?v=1.1"></script>
<script src="/vue/components/common/functions/modal_mixins.js"></script>
<script src="/vue/components/common/modal2.js"></script>
<script src="/vue/components/common/btn_top.js"></script>
<script src="/vue/linker/forum_list/index.js?v=1.69"></script>

<%
    If GetLoginUserID <> "" Then
        Response.Write "<script>app.isLogin = true;app.userId = '" & GetLoginUserID & "';</script>"
    End If
%>
<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
'####################################################
' Description : 4월정기세일 마케팅 수신동의 이벤트
' History : 2021.03.22 이전도 생성
'####################################################

Dim eCode, testValue

IF application("Svr_Info") = "Dev" THEN
    eCode = "104332"
Else
    eCode = "110104"
End If
%>
<style>
.checklist {overflow:hidden; position:relative; background-color:#ff524e;}
.checklist .btns-wrap {position:relative;}
.checklist .btn-list {display:flex; flex-direction:column; position:absolute; left:0; top:0; width:100%; height:100%;}
.checklist h3 {font-size:0; color:transparent;}
.checklist button {display:block; width:100%; font-size:0; color:transparent; background:transparent; -webkit-tap-highlight-color:rgba(0,0,0,0);}
.checklist .btn-list h3:nth-of-type(1) {height:9%;}
.checklist .btn-list button:nth-of-type(1) {height:5%;}
.checklist .btn-list button:nth-of-type(2) {height:8%;}
.checklist .btn-list h3:nth-of-type(2) {height:13.5%;}
.checklist .btn-list button:nth-of-type(3) {height:5%;}
.checklist .btn-list button:nth-of-type(4) {height:8%;}
.checklist .btn-list h3:nth-of-type(3) {height:9.5%;}
.checklist .btn-list button:nth-of-type(5) {height:5%;}
.checklist .btn-list button:nth-of-type(6) {height:8%;}
.checklist .btn-list h3:nth-of-type(4) {height:10%;}
.checklist .btn-list button:nth-of-type(7) {height:8.5%;}
.checklist .popup {position:fixed; top:0; right:0; bottom:0; left:0; z-index:30; background:rgba(0,0,0,.9);}
.checklist .popup .inner {overflow:hidden; position:absolute; top:50%; left:50%; width:90%; max-height:90%; transform:translate(-50%,-50%);}
.checklist .popup .btn-close {position:absolute; top:0; right:0; width:15vw; height:15vw; font-size:0; color:transparent;}
.fade-enter-active, .fade-leave-active {transition: opacity .5s;}
.fade-enter, .fade-leave-to  {opacity: 0;}
</style>

<div class="mEvt110104 checklist">
    <div id="app"></div>
</div>

<% IF application("Svr_Info") = "Dev" THEN %>
    <script src="https://unpkg.com/vue"></script>
    <script src="https://unpkg.com/vuex"></script>
    <script src="/vue/vue.lazyimg.min.js"></script>
<% Else %>
    <script src="/vue/2.5/vue.min.js"></script>
    <script src="/vue/vue.lazyimg.min.js"></script>
    <script src="/vue/vuex.min.js"></script>
<% End If %>

<script>
    const login_user_id = '<%=GetLoginUserID%>';
</script>
<script src="/vue/event/etc/110104/modal.js?v=1.00"></script>
<script src="/vue/event/etc/110104/vue_110104.js?v=1.15"></script>
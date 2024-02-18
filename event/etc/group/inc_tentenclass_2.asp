<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim currentdate
	currentdate = date()
	'currentdate = "2015-03-09"

	'response.write currentdate
%>
<%
'#######################################################################
'	작업자 전달 사항
'
'	* 어드민에 소스 넣을때.asp 뒤에 ?eventid=코드 꼭 넣으세요!!
'
'#######################################################################
	Dim vEventID, appevturl , vGnbflag
	Dim gnbUse : gnbUse = False '//app GNB영역 구분
	vEventID = requestCheckVar(Request("eventid"),9)
	vGnbflag = requestCheckVar(Request("gnbflag"),1)

	If vGnbflag = "1" Then
		gnbUse = true
	End If

	If isapp = "1" Then
		If gnbUse Then
			appevturl = "/apps/appcom/wish/web2014/event/gnbeventmain.asp?"
		Else
			appevturl = "/apps/appcom/wish/web2014/event/eventmain.asp?"
		End If
	Else
		appevturl = "/event/eventmain.asp?"
	End If
%>
<style type="text/css">
.navigator {height:4.7rem; padding:0 5.33%; color:#ba301d; background:#f96653;}
.navigator:after {content:' '; display:block; overflow:hidden;}
.navigator li {display:none; position:relative; float:left; width:25%; height:4.7rem; text-align:center; font:1.2rem/4.85rem 'AvenirNext-Bold', 'AppleSDGothicNeo-Bold'; font-weight:bold;}
.navigator li:before {content:''; position:absolute; right:-0.17rem; top:50%; width:0.34rem; height:0.34rem; margin-top:-0.2rem;background:#e34530; border-radius:50%;}
.navigator li.last:before {display:none;}
.navigator li.open a {color:#b01500;}
.navigator li.current a {color:#fff;}
.navigator li.current:after {content:''; position:absolute; left:0; bottom:-.41rem; z-index:1000; width:100%; height:0.73rem; background:url(http://webimage.10x10.co.kr/eventIMG/2018/83619/m/img_arrow.png)no-repeat; background-size:100%;}
.navigator li a {display:block; height:4.7rem;}
.navigator li.all a {color:#fff;}
</style>
<script>
$(function(){
	$(".navigator li.all").show()
	$(".navigator li.open").last().show().addClass("last");
	$(".navigator li.open").last().prev().show();
	$(".navigator li.open").last().prev().prev().show();
});
</script>
<ul id="navigator" class="navigator">
	<li class="all">
		<% If isapp = "1" Then %>
		<a href="" onclick="fnAPPpopupCategory('104119'); return false;">ALL </a>
		<% Else %>
		<a href="/category/category_list.asp?disp=104119">ALL</a>
		<% End If %>
	</li>

	<% if currentdate < "2017-12-07" then %>
	<li>12.07</li>
	<% Else %>
	<li class="open <%=CHKIIF(vEventID="82776"," current","")%>">
		<a href="<%=appevturl%>eventid=82776<%=chkiif(gnbUse,"&gnbflag=1","")%>" target="_top">12.07</a>
	</li>
	<% End If %>

	<% if currentdate < "2017-12-14" then %>
	<li>12.14</li>
	<% Else %>
	<li class="open <%=CHKIIF(vEventID="82988"," current","")%>">
		<a href="<%=appevturl%>eventid=82988<%=chkiif(gnbUse,"&gnbflag=1","")%>" target="_top">12.14</a>
	</li>
	<% End If %>

	<% if currentdate < "2017-12-21" then %>
	<li>12.14</li>
	<% Else %>
	<li class="open <%=CHKIIF(vEventID="83161"," current","")%>">
		<a href="<%=appevturl%>eventid=83161<%=chkiif(gnbUse,"&gnbflag=1","")%>" target="_top">12.21</a>
	</li>
	<% End If %>

	<% if currentdate < "2017-12-28" then %>
	<li>12.28</li>
	<% Else %>
	<li class="open <%=CHKIIF(vEventID="83172"," current","")%>">
		<a href="<%=appevturl%>eventid=83172<%=chkiif(gnbUse,"&gnbflag=1","")%>" target="_top">12.28</a>
	</li>
	<% End If %>

	<% if currentdate < "2018-01-04" then %>
	<li>01.04</li>
	<% Else %>
	<li class="open <%=CHKIIF(vEventID="83483"," current","")%>">
		<a href="<%=appevturl%>eventid=83483<%=chkiif(gnbUse,"&gnbflag=1","")%>" target="_top">01.04</a>
	</li>
	<% End If %>

	<% if currentdate < "2018-01-11" then %>
	<li>01.11</li>
	<% Else %>
	<li class="open <%=CHKIIF(vEventID="83619"," current","")%>">
		<a href="<%=appevturl%>eventid=83619<%=chkiif(gnbUse,"&gnbflag=1","")%>" target="_top">01.11</a>
	</li>
	<% End If %>

	<% if currentdate < "2018-01-15" then %>
	<li>01.15</li>
	<% Else %>
	<li class="open <%=CHKIIF(vEventID="83730"," current","")%>">
		<a href="<%=appevturl%>eventid=83730<%=chkiif(gnbUse,"&gnbflag=1","")%>" target="_top">01.15</a>
	</li>
	<% End If %>

	<% if currentdate < "2018-01-17" then %>
	<li>01.17</li>
	<% Else %>
	<li class="open <%=CHKIIF(vEventID="83732"," current","")%>">
		<a href="<%=appevturl%>eventid=83732<%=chkiif(gnbUse,"&gnbflag=1","")%>" target="_top">01.17</a>
	</li>
	<% End If %>

	<% if currentdate < "2018-01-19" then %>
	<li>01.19</li>
	<% Else %>
	<li class="open <%=CHKIIF(vEventID="83733"," current","")%>">
		<a href="<%=appevturl%>eventid=83733<%=chkiif(gnbUse,"&gnbflag=1","")%>" target="_top">01.19</a>
	</li>
	<% End If %>

	<% if currentdate < "2018-01-23" then %>
	<li>01.23</li>
	<% Else %>
	<li class="open <%=CHKIIF(vEventID="83943"," current","")%>">
		<a href="<%=appevturl%>eventid=83943<%=chkiif(gnbUse,"&gnbflag=1","")%>" target="_top">01.23</a>
	</li>
	<% End If %>

	<% if currentdate < "2018-01-26" then %>
	<li>01.26</li>
	<% Else %>
	<li class="open <%=CHKIIF(vEventID="84017"," current","")%>">
		<a href="<%=appevturl%>eventid=84017<%=chkiif(gnbUse,"&gnbflag=1","")%>" target="_top">01.26</a>
	</li>
	<% End If %>

	<% if currentdate < "2018-01-30" then %>
	<li>01.30</li>
	<% Else %>
	<li class="open <%=CHKIIF(vEventID="84203"," current","")%>">
		<a href="<%=appevturl%>eventid=84203<%=chkiif(gnbUse,"&gnbflag=1","")%>" target="_top">01.30</a>
	</li>
	<% End If %>

	<% if currentdate < "2018-02-02" then %>
	<li>02.02</li>
	<% Else %>
	<li class="open <%=CHKIIF(vEventID="84204"," current","")%>">
		<a href="<%=appevturl%>eventid=84204<%=chkiif(gnbUse,"&gnbflag=1","")%>" target="_top">02.02</a>
	</li>
	<% End If %>

	<% if currentdate < "2018-02-06" then %>
	<li>02.06</li>
	<% Else %>
	<li class="open <%=CHKIIF(vEventID="84353"," current","")%>">
		<a href="<%=appevturl%>eventid=84353<%=chkiif(gnbUse,"&gnbflag=1","")%>" target="_top">02.06</a>
	</li>
	<% End If %>

	<% if currentdate < "2018-02-09" then %>
	<li>02.09</li>
	<% Else %>
	<li class="open <%=CHKIIF(vEventID="84354"," current","")%>">
		<a href="<%=appevturl%>eventid=84354<%=chkiif(gnbUse,"&gnbflag=1","")%>" target="_top">02.09</a>
	</li>
	<% End If %>

	<% if currentdate < "2018-02-14" then %>
	<li>02.14</li>
	<% Else %>
	<li class="open <%=CHKIIF(vEventID="84577"," current","")%>">
		<a href="<%=appevturl%>eventid=84577<%=chkiif(gnbUse,"&gnbflag=1","")%>" target="_top">02.14</a>
	</li>
	<% End If %>

	<% if currentdate < "2018-02-20" then %>
	<li>02.20</li>
	<% Else %>
	<li class="open <%=CHKIIF(vEventID="84648"," current","")%>">
		<a href="<%=appevturl%>eventid=84648<%=chkiif(gnbUse,"&gnbflag=1","")%>" target="_top">02.20</a>
	</li>
	<% End If %>

	<% if currentdate < "2018-02-23" then %>
	<li>02.23</li>
	<% Else %>
	<li class="open <%=CHKIIF(vEventID="84649"," current","")%>">
		<a href="<%=appevturl%>eventid=84649<%=chkiif(gnbUse,"&gnbflag=1","")%>" target="_top">02.23</a>
	</li>
	<% End If %>

	<% if currentdate < "2018-02-27" then %>
	<li>02.27</li>
	<% Else %>
	<li class="open <%=CHKIIF(vEventID="84839"," current","")%>">
		<a href="<%=appevturl%>eventid=84839<%=chkiif(gnbUse,"&gnbflag=1","")%>" target="_top">02.27</a>
	</li>
	<% End If %>

	<% if currentdate < "2018-03-02" then %>
	<li>03.02</li>
	<% Else %>
	<li class="open <%=CHKIIF(vEventID="84840"," current","")%>">
		<a href="<%=appevturl%>eventid=84840<%=chkiif(gnbUse,"&gnbflag=1","")%>" target="_top">03.02</a>
	</li>
	<% End If %>

	<% if currentdate < "2018-03-06" then %>
	<li>03.06</li>
	<% Else %>
	<li class="open <%=CHKIIF(vEventID="84928"," current","")%>">
		<a href="<%=appevturl%>eventid=84928<%=chkiif(gnbUse,"&gnbflag=1","")%>" target="_top">03.06</a>
	</li>
	<% End If %>

	<% if currentdate < "2018-03-09" then %>
	<li>03.09</li>
	<% Else %>
	<li class="open <%=CHKIIF(vEventID="84929"," current","")%>">
		<a href="<%=appevturl%>eventid=84929<%=chkiif(gnbUse,"&gnbflag=1","")%>" target="_top">03.09</a>
	</li>
	<% End If %>

	<% if currentdate < "2018-03-13" then %>
	<li>03.13</li>
	<% Else %>
	<li class="open <%=CHKIIF(vEventID="85098"," current","")%>">
		<a href="<%=appevturl%>eventid=85098<%=chkiif(gnbUse,"&gnbflag=1","")%>" target="_top">03.13</a>
	</li>
	<% End If %>

	<% if currentdate < "2018-03-16" then %>
	<li>03.16</li>
	<% Else %>
	<li class="open <%=CHKIIF(vEventID="85099"," current","")%>">
		<a href="<%=appevturl%>eventid=85099<%=chkiif(gnbUse,"&gnbflag=1","")%>" target="_top">03.16</a>
	</li>
	<% End If %>
</ul>
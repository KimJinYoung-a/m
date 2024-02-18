<%
'#######################################################
'	Description : 캘린더앱 헤더
'	History	:  2014.02.17 한용민 생성
'#######################################################

Dim strPageTitle
	if strPageTitle="" then strPageTitle = "10X10 CALENDAR APP"
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, width=device-width">
<meta name="format-detection" content="telephone=no" />
<title><%= strPageTitle %></title>
<link rel="stylesheet" type="text/css" href="../lib/css/calAppStyle.css">
<script type="text/javascript" src="../lib/js/jquery-1.10.1.min.js"></script>
<script type="text/javascript" src="../lib/js/jquery-masonry.min.js"></script>
<script type="text/javascript" src="../lib/js/tencommon.js"></script>
<!--[if lt IE 9]>
	<script src="../lib/js/respond.min.js"></script>
<![endif]-->
<%

    Dim temp_idx
    Dim tenRecentKeywords(3)
	Dim duplicateKeywordIndex : duplicateKeywordIndex = -1

    for temp_idx=0 to 3
        IF "" <> request.Cookies("tenRecentKeywords")("k" & temp_idx) Then
            IF keyword = request.Cookies("tenRecentKeywords")("k" & temp_idx) Then
                duplicateKeywordIndex = temp_idx
            End IF

            tenRecentKeywords(temp_idx) = requestCheckVar(request.Cookies("tenRecentKeywords")("k" & temp_idx), 100)
        ELSE
            Exit For
        End IF
    NEXT

    Dim j
    IF duplicateKeywordIndex <> -1 then
        temp_idx = temp_idx - 1
        for j = duplicateKeywordIndex to temp_idx
            if j = temp_idx then
                tenRecentKeywords(j) = keyword
            else
                tenRecentKeywords(j) = tenRecentKeywords(j+1)
            end if
        next
    ELSEIF temp_idx = 4 THEN
        temp_idx = 3
        for j = 0 to 2
            tenRecentKeywords(j) = tenRecentKeywords(j+1)
        next
        tenRecentKeywords(3) = keyword
    ELSE
        tenRecentKeywords(temp_idx) = keyword
    end if

	Dim iCookieDomainName : iCookieDomainName = GetCookieDomainName

    response.Cookies("tenRecentKeywords").domain = iCookieDomainName
    Dim cookie_index
    for cookie_index = 0 to temp_idx
        response.Cookies("tenRecentKeywords")("k"&cookie_index) = tenRecentKeywords(cookie_index)
    next
    response.Cookies("tenRecentKeywords").Expires = DateAdd("d",7,now())

%>
<script>
    const tenRecentKeywords = [];
    <% for temp_idx=0 to 3 %>
        <% if "" <> tenRecentKeywords(temp_idx) Then %>
            tenRecentKeywords.push('<%=tenRecentKeywords(temp_idx)%>');
        <% else Exit For end if %>
    <% next %>
</script>
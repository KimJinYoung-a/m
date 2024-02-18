<%
' UI 개발 가이드
'###########################################################
'   CASE 테스트이벤트코드 , 실서버이벤트코드 ----> 진행되는 이벤트 코드 구분
'       keywordArray = 키워드,키워드,키워드 ---->콤마로 구분

'       IF instr(keywordArray,couponname) > 0 THEN  ----> 위의 지정된 키워드와 넘겨 받은 키워드 비교 
'           couponidx = chkiif(application("Svr_Info") = "Dev" , "테스트보너스쿠폰번호" , "실서버쿠폰번호") ----> 참일 경우 (테스트서버 / 실서버 보너스쿠폰 반환)
'       END IF 
'###########################################################
'위의 코드 블럭을 이벤트 진행시 하단에 추가함
'###########################################################
PUBLIC SUB shopperKeyword(eventid , couponname , byref couponidx)
    couponidx = ""

    dim keywordArray
    SELECT CASE eventid '// test eventid / real eventid
        CASE 90412 , 97856
            
            keywordArray = "호담,럭셜황후,1010쿠폰,텐텐러블,유랑,땡이,하주임,하리미지니,쏘쇼,정자동비버댁,견우네,죵이,이매콤,데이지,로와제이,알로하니모,꾸우미맘,호담,럭셜황후,1010쿠폰,텐텐러블,유랑,땡이,하주임,하리미지니,쏘쇼,정자동비버댁,하얘,까칠한그녀,레이라,보라초,헤일리,순둥작가,꼬비,서아맘,나나킴,민조이,아양,하늘을달리다,용햄,솔솔,달키,봄지,주주맘,지지지혜,액션몽자,위드윤,욜로걸,한방이,수리,레이첼,슈퍼보리,디어루씨,마슝이,꼬꼬마,꽃혜지,율희,보쨘,이반나,다이애나,유부림짱,얌치"

            IF instr(keywordArray,couponname) > 0 THEN 
                couponidx = chkiif(application("Svr_Info") = "Dev" , "2910" , "1219")
            END IF 

        CASE 90470 , 100761

            keywordArray = "와이비니,솜솜,스윗써니,애뚜,빡가씨,먹순이,현블리,도톨벼리,은날,스리링,꼬꽁이,주주맘,손끝느낌,비비드씨,하율,콩콩이오빠토리,비비,스치는별하나,니니로그,은똥"

            IF instr(keywordArray,couponname) > 0 THEN 
                couponidx = chkiif(application("Svr_Info") = "Dev" , "2950" , "1300")
            END IF

        CASE 101599 , 101774

            keywordArray = "김햅삐,주주맘,불당댁,꼬비,하주임,도톨벼리,쏘쇼,꼬꼬마,지끙쿠폰,땡이,여행가세라,빡가씨,까칠한그녀,현블리,하리미지니,유후,먹순이,죵이,애뚜,크롬웰,민희멜리사,파파라쭈,봄지,지지지혜,기유,하얘,레비올라,용햄,스리링,민조이,송살랑,푸키베베,쭌별맘,둥이둥,한방이,호담,유부림짱,베베샤,하이헬로쿠폰,수수양,곰두,윤탱,yoosso,담콩이,y_jih_,뮤즈,114_282_6,정후니,몰리맘,차수리미,샬롯,효니스타일,히럽,지오니,blue20,뇽뇽,쥬,은스타,텐러우,설아,텐바이텐유빈,수아이니,보라비,주영,마키,예쁘지윤맘,sean,예빈,크리스탈,민주우,봄날의하루,부산뉴스,우키,유주사랑,데이지차,쿠카,영은천,지구별,유디,구니여니,도록,양시스터즈,령아,준타시온,다맨,샤탕,베이비아지,뷰스타폴라,송살랑,럭셜황후,순둥작가,압둘,꼬꽁이,보라초,치유쿠폰,헤일리,알로하니모"

            IF instr(keywordArray,couponname) > 0 THEN 
                couponidx = chkiif(application("Svr_Info") = "Dev" , "2953" , "1320")
            END IF 
            
        CASE 102155 , 102229

            keywordArray = "깡지,뚜띠홀릭,케이트,수리마밍,김알숭,뇽뇽,닭똥집,힘찬이,라잇퐁,세지쓰,미미룽,레이첼,베일리,혜윰제이,삼삼삼,자루,아해,리시안셔스,볼볼볼,소다자매뚜뜨"

            IF instr(keywordArray,couponname) > 0 THEN 
                couponidx = chkiif(application("Svr_Info") = "Dev" , "2954" , "1327")
            END IF 

         CASE 102194 , 104071

            keywordArray = "율러블리,텐텐천사,휘나,유아이,정자동비버댁,쌤쌤티비,시크한애미,오늘도헬로우,모민하우스,멍젤라,셩블리,이솝,루비,달달새댁,꽃구름,수박씨,알프스토끼,율짱,청순하다,꼬맹이누나"

            IF instr(keywordArray,couponname) > 0 THEN 
                couponidx = chkiif(application("Svr_Info") = "Dev" , "2958" , "1365")
            END IF 

         CASE 103241 , 106597

            keywordArray = "깡지,고도리,텐텐천사,아원맘,민주부,김똑술,서서히,뽀냥,민사임당,스위트카렌,마로,윤줌마,럭키윰,혜주,라라루루,소다자매뚜뜨,고미,뽀이언니,쉬즈,꽃꼬마"

            IF instr(keywordArray,couponname) > 0 THEN 
                couponidx = chkiif(application("Svr_Info") = "Dev" , "2962" , "1457")
            END IF

        CASE 104303 , 108970

            keywordArray = "웅이맘,쁘띠민,땡큐맘나무,이솝,백호,일공사홈,소다자매뚜뜨,김똑술,하리미지니,닭똥집,별구름,잡주부,어쏠,건맘,스위트비,가노가노,하영담다,쑥,주니호맘,한율"

            IF instr(keywordArray,couponname) > 0 THEN 
                couponidx = chkiif(application("Svr_Info") = "Dev" , "2964" , "1559")
            END IF
        
        CASE 104327 , 110069

            keywordArray = "산본댁,껌딱이,자루,푸르매,비커밍제인,이솝,먹순이,꽃꼬마,달달새댁,텐텐천사,혜윰제이,청순하다,bol,루비,쉬즈,김똑술,미미룽,별구름,아빠빨리와요,아해,아원맘,일공사홈,알프스토끼,스위트비,욘아,텐텐,텐텐천사,빙양,스위트카렌,푸르매,멍젤라,뚜뜨,솜솜,동네형,케이트,미셸,둘맘"

            IF instr(keywordArray,couponname) > 0 THEN 
                couponidx = chkiif(application("Svr_Info") = "Dev" , "2965" , "1624")
            END IF
            
    END SELECT
END SUB
%>
Vue.component('MODAL-LINK', {
    template : `
        <div id="modalLink" class="modalV20 modal_type4">
            <div @click="close" class="modal_overlay"></div>
            <div class="modal_wrap modal_forum">
                <div class="modal_header">
                    <h2>모달</h2>
                    <button @click="close" class="btn_close"><i class="i_close"></i>모달닫기</button>
                    <button @click="addLink" :class="['btn-apply_link', {on:selectedItem.id}]">추가하기</button>
                </div>
                <div class="modal_body">
                    <div @scroll="scroll" class="modal_cont forum_conts">
                    
                        <!--region 상단 탭-->
                        <div v-show="type !== 'url'" class="menu_list">
                            <li :class="[{on:onTab==='search'}]" @click="changeTab('search')"><a href="#">검색하기</a></li>
                            <li :class="[{on:onTab==='wish'}]" @click="changeTab('wish')" v-if="type==='product' || type==='brand'"><a href="#">{{type === 'product' ? '내 위시' : '찜브랜드'}}</a></li>
                            <li :class="[{on:onTab==='basket'}]" @click="changeTab('basket')" v-if="type==='product'"><a href="#">장바구니</a></li>
                            <li :class="[{on:onTab==='order'}]" @click="changeTab('order')" v-if="type==='product'"><a href="#">주문내역</a></li>
                        </div>
                        <!--endregion-->
                        
                        <!--region 검색바-->
                        <div v-show="type !== 'url'" id="searchbar" class="srchbar_wrap">
                            <div class="srchbar input_txt">
                                <input @input="updateKeyword" @keyup.enter="keywordSearch" id="searchBar" 
                                    type="search" title="검색어 입력" placeholder="검색어를 입력해주세요" class="srch_input">
                                <div class="kwd_list" style="display:none;">
                                    <div class="kwd_inner">
                                        <span><em></em></span>
                                    </div>
                                </div>
                                <button v-show="keyword" @click="clickKeywordDeleteButton" class="btn_del">
                                    <i class="i_close"></i>
                                </button> 
                            </div>
                        </div>
                        <div v-show="keyword && autoKeywords.length > 0" class="srch_kwd_list type3">
                            <ul>
                                <li v-for="(k, index) in autoKeywords" :key="index">
                                    <a @click="clickAuthKeyword(k.keyword)" v-html="k.tag"></a>
                                </li>
                            </ul>
                        </div>
                        <!--endregion-->
                        
                        <!--region 최근 본 아이템-->
                        <div v-show="onTab === 'search' && (type === 'product' || type === 'brand' || type === 'event') && !doSearch" class="forum_search_result">
                            <div class="search_total">
                                <div class="total_num"><div>최근 본 {{typeKor}}</div></div>
                            </div>
                            <div clas="search_list_area">
                                <MODAL-LINK-ITEM v-for="item in recentlyViewItems" :key="item.id" :type="type" :item="item"
                                    :selectedValue="selectedItem.id" @selectItem="selectItem "/>
                            </div>
                        </div>
                        <!--endregion-->
                        
                        <!--region 검색 결과-->
                        <div v-show="doSearch && (onTab !== 'wish' || searchTotalCount > 0)" class="forum_search_result">
                            <div class="search_total">
                                <div class="total_num"><div>총 <span>{{numberFormat(searchTotalCount)}}</span>건</div></div>
                                <select @change="changeSearchOrder" v-if="onTab === 'search'">
                                    <option value="best">인기순</option>
                                    <option value="new">신규순</option>
                                </select>
                            </div>
                            <div clas="search_list_area">
                                <MODAL-LINK-ITEM v-for="result in searchResult" :key="result.id" :type="type" :item="result"
                                    :selectedValue="selectedItem.id" @selectItem="selectItem "/>
                            </div>
                        </div>
                        <!--endregion-->
                        
                        <!-- region 검색 결과 없음 -->
                        <div v-show="!searchLoading && doSearch && searchTotalCount === 0" class="empty_post">
                            <span class="img_empty"></span>   
                            <p class="tit">아쉽게도 알맞은 컨텐츠가 없어요</p>
                            <p class="txt">마음에드는 상품이나 컨텐츠를<br/>
                                찾아보세요:)</p>
                        </div>
                        <!-- endregion -->
                        
                        <!-- region 링크추가 -->
                        <div v-show="type === 'url'" class="copy_link_area">
                            <div class="input">
                                <textarea @input="inputLinkContent" id="linkContent" placeholder="연결이 가능한 URL을 입력해주세요"></textarea>
                                <button v-if="!linkerApp" @click="clipboardPaste" type="button" class="btn_copy_link">복사한 링크 넣기</button>
                            </div>
                            <div class="copy_view">
                                <div class="link_info">
                                    <div class="url_img"></div>
                                    <div class="link">{{linkContent}}</div>
                                </div>
                            </div>
                            <div class="copy_noti">
                                <div class="sns">
                                    <div class="youtube"><img src="http://fiximage.10x10.co.kr/web2021/anniv2021/m/icon_sns_youtube.png" alt="유튜브"></div>
                                    <div class="insta"><img src="http://fiximage.10x10.co.kr/web2021/anniv2021/m/icon_sns_insta.png" alt="인스타그램"></div>
                                    <div class="notion"><img src="http://fiximage.10x10.co.kr/web2021/anniv2021/m/icon_sns_notion.png" alt="notion"></div>
                                    <div class="blog"><img src="http://fiximage.10x10.co.kr/web2021/anniv2021/m/icon_sns_blog.png" alt="blog"></div>
                                </div>
                                <p class="noti">동영상, 포스팅, 공유 문서 등을<br/>
                                    자유롭게 연결해주세요</p>
                            </div>
                        </div>
                        <!-- endregion -->
                    </div>
                </div>
            </div>
        </div>
    `,
    //region data
    data() {return {
        type : 'product', // 링크 유형
        onTab : 'search', // 활성화된 탭

        doSearch : false, // 검색 실행 여부
        recentlyViewItems : [], // 최근 본 아이템 리스트

        keyword : '', // 검색 키워드
        searchedKeyword : '', // 검색 한 키워드
        sortMethod : 'best', // 정렬기준
        tempAutoKeywords : [], // 자동완성 키워드 리스트
        currentPage : 1, // 현재 페이지
        searchTotalCount : 0, // 검색 총 결과 수
        searchResult : [], // 검색 결과
        searchLoading : false, // 검색 중 여부
        searchAll : false, // 마지막 페이지까지 전부 불러왔는지 여부

        selectedItem : {}, // 선택된 아이템
        linkContent : '', // 외부링크 내용
    }},
    //endregion
    computed : {
        //region autoKeywords 자동완성 키워드 리스트
        autoKeywords() {
            let autoKeywords = [];
            if( this.tempAutoKeywords != null && this.tempAutoKeywords.length > 0 ) {
                for( let i=0 ; i<this.tempAutoKeywords.length ; i++ ) {
                    // 일치하는 문자 <b>태그 처리
                    autoKeywords.push({
                        keyword : this.tempAutoKeywords[i].keyword,
                        tag : this.tempAutoKeywords[i].keyword.replaceAll(this.keyword, `<b>${this.keyword}</b>`)
                    });
                }
            }
            return autoKeywords;
        },
        //endregion
        //region typeKor 유형 한글
        typeKor() {
            switch (this.type) {
                case 'product' : return '상품';
                case 'brand' : return '브랜드';
                case 'event' : return '기획전/이벤트';
            }
        },
        //endregion
    },
    methods : {
        //region open 모달 열기
        open(type) {
            this.type = type;
            this.recentlyViewItems = [];

            if( type === 'product' )
                this.getRecentlyViewProducts();
            else if( type === 'brand' )
                this.getRecentlyViewBrands();
            else if( type === 'event' )
                this.getRecentlyViewEvents();

            this.openModal('modalLink');
        },
        //endregion
        //region close 모달 닫기
        close() {
            this.changeTab('search');
            this.doSearch = false;
            this.clearLinkContent();
            this.closeModal('modalLink');
        },
        //endregion
        //region scroll 스크롤
        scroll(e) {
            const modal_height = e.target.scrollHeight; // 모달창 총 Height
            const current_bottom = e.target.offsetHeight + e.target.scrollTop; // 현재 Y위치(하단기준) => 화면높이 + 현재 상단 Y위치

            // 페이지 로딩
            if( !this.searchLoading && !this.searchAll && (modal_height - current_bottom) < 1200 ) {
                this.loadMoreSearchItems();
            }
        },
        //endregion
        //region keywordSearch 키워드 검색
        keywordSearch() {
            if( this.keyword.trim() === '' )
                return false;
            else if( this.keyword.length > 100 )
                this.keyword = this.keyword.substr(0, 100);

            this.clearSearchResult();
            this.searchedKeyword = this.keyword;

            switch(this.onTab) {
                case 'search': this.search(1); break;
                case 'wish': this.wishSearch(1); break;
                case 'basket': this.basketSearch(1); break;
                case 'order': this.orderSearch(1); break;
            }
        },
        //endregion
        //region clickAuthKeyword 자동완성 키워드 클릭
        clickAuthKeyword(keyword) {
            this.keyword = keyword;
            $('#searchBar').val(keyword);
            this.keywordSearch();
        },
        //endregion
        //region search 검색탭 검색
        search(currentPage) {
            const url = this.getSearchUrl();
            const data = {
                keyword : this.searchedKeyword,
                sortMethod : this.sortMethod,
                currentPage : currentPage
            }
            this.callSearchApi(url, data);
        },
        //endregion
        //region getSearchUrl Get 검색 Url
        getSearchUrl() {
            let url = '/linker';
            switch(this.type) {
                case 'product' : return url + '/products/search';
                case 'brand' : return url + '/brands/search';
                case 'event' : return url + '/exhibitions/search';
            }
        },
        //endregion
        //region wishSearch 위시탭 검색
        wishSearch(currentPage) {
            let data = {
                keyword : this.searchedKeyword,
                page : currentPage
            };
            let url;
            if( this.type === 'product' ) {
                url = '/linker/products';
                data.searchType = 'wish';
            } else {
                url = '/linker/brand/wish'
            }
            this.callSearchApi(url, data);
        },
        //endregion
        //region basketSearch 장바구니탭 검색
        basketSearch(currentPage) {
            const url = '/linker/products';
            const data = {
                keyword : this.searchedKeyword,
                searchType : 'basket',
                page : currentPage
            }
            this.callSearchApi(url, data);
        },
        //endregion
        //region orderSearch 주문내역탭 검색
        orderSearch(currentPage) {
            const url = '/linker/products';
            const data = {
                keyword : this.searchedKeyword,
                searchType : 'order',
                page : currentPage
            }
            this.callSearchApi(url, data);
        },
        //endregion
        //region loadMoreSearchItems 페이지 더 불러오기
        loadMoreSearchItems() {
            this.currentPage++;

            if( this.doSearch ) {
                switch(this.onTab) {
                    case 'search': this.search(this.currentPage); break;
                    case 'wish': this.wishSearch(this.currentPage); break;
                    case 'basket': this.basketSearch(this.currentPage); break;
                    case 'order': this.orderSearch(this.currentPage); break;
                }
            } else {
                this.getRecentlyViewItems();
            }
        },
        //endregion
        //region callSearchApi 검색 실행
        callSearchApi(url, data) {
            this.searchLoading = true;
            this.doSearch = true;

            const _this = this;
            const success = function(data) {
                _this.searchTotalCount = data.totalCount;

                for( let i=0 ; i<data.items.length ; i++ ) {
                    switch(_this.type) {
                        case 'product': _this.searchResult.push(_this.convertSearchProductItem(data.items[i])); break;
                        case 'brand': _this.searchResult.push(_this.convertSearchBrandItem(data.items[i])); break;
                        case 'event': _this.searchResult.push(_this.convertSearchEventItem(data.items[i])); break;
                    }
                }

                if( data.currentPage === data.lastPage ) {
                    _this.searchAll = true;
                }
                _this.searchLoading = false;
            }
            getFrontApiDataV2('GET', url, data, success);
        },
        //endregion
        //region getDefaultSearchData Get 기본 검색 Data
        getDefaultSearchData() {
            return {
                'keyword' : this.keyword,
                'sortMethod' : 'best',
                'currentPage' : 1
            };
        },
        //endregion
        //region changeTab 활성화 탭 변경
        changeTab(tab) {
            this.onTab = tab;
            this.clearKeyword();
            this.clearSearchResult();
            this.clearSelect();
            this.linkContent = '';

            if( tab === 'wish' ) {
                this.wishSearch(1);
            } else if( tab === 'basket' ) {
                this.basketSearch(1);
            } else if( tab === 'order' ) {
                this.orderSearch(1);
            }
        },
        //endregion
        //region convertSearchProductItem 상품검색결과 -> 결과Item
        convertSearchProductItem(result) {
            return {
                id : result.productId.toString(),
                image: decodeBase64(result.productImage),
                subTitle: result.brandName,
                title: result.productName,
                price: result.productPrice
            }
        },
        //endregion
        //region convertSearchBrandItem 브랜드검색결과 -> 결과Item
        convertSearchBrandItem(result) {
            return {
                id : result.brandId,
                image: decodeBase64(result.brandImage),
                title: result.brandName,
                subTitle: result.brandNameEn
            }
        },
        //endregion
        //region convertSearchEventItem 브랜드검색결과 -> 결과Item
        convertSearchEventItem(result) {
            return {
                id : result.evt_code.toString(),
                image: decodeBase64(result.banner_img),
                title: result.evt_name
            }
        },
        //endregion
        //region clickKeywordDeleteButton 키워드 삭제 버튼 클릭
        clickKeywordDeleteButton() {
            this.keyword = '';
            $('#searchBar').val('');
            $('#searchBar').focus();
        },
        //endregion
        //region clearKeyword 키워드 초기화
        clearKeyword() {
            this.keyword = '';
            this.searchedKeyword = '';
            document.getElementById('searchBar').value = '';
        },
        //endregion
        //region clearSearchResult 검색결과 초기화
        clearSearchResult() {
            this.searchTotalCount = 0;
            this.currentPage = 1;
            this.searchResult = [];
            this.doSearch = false;
            this.searchAll = false;
            this.tempAutoKeywords = [];
        },
        //endregion
        //region clearSelect 선택아이템 초기화
        clearSelect() {
            this.selectedItem = {}
        },
        //endregion
        //region clearLinkContent 링크 URL 초기화
        clearLinkContent() {
            this.linkContent = '';
            $('#linkContent').val('');
        },
        //endregion
        //region selectItem 아이템 선택
        selectItem(item) {
            this.selectedItem = item;
        },
        //endregion
        //region updateKeyword 키워드 수정
        updateKeyword(e) {
            this.keyword = e.target.value.trim();
            if( this.keyword !== '' ) {
                this.getAuthKeywords();
            }
        },
        //endregion
        //region getRecentlyViewItems 최근 본 아이템 가져오기
        getRecentlyViewItems() {
            if( this.type === 'product' )
                this.getRecentlyViewProducts();
            else if( this.type === 'brand' )
                this.getRecentlyViewBrands();
            else if( this.type === 'event' )
                this.getRecentlyViewEvents();
        },
        //endregion
        //region getRecentlyViewProducts 최근 본 상품 리스트 불러오기
        getRecentlyViewProducts() {
            const _this = this;
            this.searchLoading = true;
            const success = function(data) {
                if( data != null ) {
                    for( let i=0 ; i<data.length ; i++ ) {
                        _this.recentlyViewItems.push({
                            id : data[i].productId.toString(),
                            image : decodeBase64(data[i].productImage),
                            title : data[i].productName,
                            subTitle : data[i].brandName,
                            price : data[i].productPrice
                        });
                    }

                    if( data.length === 0 ) {
                        _this.searchAll = true;
                    }
                    _this.searchLoading = false;
                }
            }
            getFrontApiDataV2('GET', `/linker/products/view/recently/page/${this.currentPage}`, null, success);
        },
        //endregion
        //region getRecentlyViewBrands 최근 본 브랜드 리스트 불러오기
        getRecentlyViewBrands() {
            const _this = this;
            this.searchLoading = true;
            const success = function(data) {
                if( data != null ) {
                    for( let i=0 ; i<data.length ; i++ ) {
                        _this.recentlyViewItems.push({
                            id : data[i].brandId,
                            image : decodeBase64(data[i].brandImage),
                            title : data[i].brandName,
                            subTitle : data[i].brandNameEn
                        });
                    }

                    if( data.length === 0 ) {
                        _this.searchAll = true;
                    }
                    _this.searchLoading = false;
                }
            }
            getFrontApiDataV2('GET', `/linker/brands/view/recently/page/${this.currentPage}`, null, success);
        },
        //endregion
        //region getRecentlyViewEvents 최근 본 이벤트 리스트 불러오기
        getRecentlyViewEvents() {
            const _this = this;
            this.searchLoading = true;
            const success = function(data) {
                if( data != null ) {
                    for( let i=0 ; i<data.length ; i++ ) {
                        _this.recentlyViewItems.push({
                            id : data[i].eventId.toString(),
                            image : decodeBase64(data[i].eventImage),
                            title : data[i].eventName
                        });
                    }

                    if( data.length === 0 ) {
                        _this.searchAll = true;
                    }
                    _this.searchLoading = false;
                }
            }
            getFrontApiDataV2('GET', `/linker/events/view/recently/page/${this.currentPage}`, null, success);
        },
        //endregion
        //region getAuthKeywords 자동완성 키워드리스트 불러오기
        getAuthKeywords() {
            const _this = this;
            const success = function(data) {
                _this.tempAutoKeywords = data.keywords;
            }
            getFrontApiData('GET', '/search/completeKeywords?keyword=' + this.keyword, null, success);
        },
        //endregion
        //region addLink 링크 추가
        addLink() {
            if( this.selectedItem.id ) {
                if( this.type === 'url' ) {
                    const _this = this;
                    getFrontApiDataV2('GET', '/linker/link/thumbnail', {'link' : this.selectedItem.id}, data => {
                        _this.selectedItem.image = data.thumbnail ? data.thumbnail : _this.selectedItem.image;
                        _this.emitAddLinkAndClose();
                    }, this.emitAddLinkAndClose)
                } else {
                    this.emitAddLinkAndClose();
                }
            }
        },
        //endregion
        //region emitAddLinkAndClose 링크추가 전송 & 링크모달 닫기
        emitAddLinkAndClose() {
            this.$emit('addLink', this.type, this.selectedItem);
            this.close();
        },
        //endregion
        //region changeSearchOrder 검색 정렬 순서 변경
        changeSearchOrder(e) {
            this.sortMethod = e.target.value;
            this.clearSearchResult();
            this.search(1);
        },
        //endregion
        //region inputLinkContent 외부 링크 입력
        inputLinkContent(e) {
            this.updateLinkContent(e.target.value);
        },
        //endregion
        //region updateLinkContent 외부 링크 내용 update
        updateLinkContent(value) {
            this.linkContent = value;

            this.selectedItem = {
                id : this.linkContent,
                image : 'http://fiximage.10x10.co.kr/web2021/anniv2021/m/icon_url_default.png?v=1.0',
                title : this.linkContent
            };
        },
        //endregion
        //region clipboardPaste 클립보드 붙여넣기
        clipboardPaste() {
            const _this = this;
            navigator.clipboard.readText()
                .then(text => {
                    $('#linkContent').val(text);
                    _this.updateLinkContent(text);
                })
                .catch(e => {
                    alert(e);
                });
        },
        //endregion
    },
})
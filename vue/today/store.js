const store = new Vuex.Store({
    state : {
        mdPicks : {
            mdPick : [],
            newProducts : [],
            onSale : [],
        },
        oneBanners : [],
        exhibitions : [],
        keywords : [],
        enjoys : [],
        brands : [],
        twinItems : [],
        categories : [],
    },
    getters : {
        mdPicks(state) { return state.mdPicks; },
        oneBanners(state) { return state.oneBanners; },
        exhibitions(state) { return state.exhibitions; },
        keywords(state) { return state.keywords; },
        enjoys(state) { return state.enjoys; },
        brands(state) { return state.brands; },
        twinItems(state) { return state.twinItems; },
        categories(state) { return state.categories; },
    },
    mutations : {
        SET_TODAY(state, data) {
            state.mdPicks = data.mdPicks;
            state.oneBanners = data.oneBanners;
            state.exhibitions = data.exhibitions;
            state.keywords = data.keywords;
            state.enjoys = data.enjoys;
            state.brands = data.brands;
            state.twinItems = data.twinItems;
            state.categories = data.categories;
        }
    },
    actions : {
        GET_TODAY(context, isApp) {
            const data = {
                deviceType : isApp ? 'APP' : 'MOBILE'
            }
            getFrontApiData('GET', '/today/', data,
                data => {
                    console.log(data);
                    context.commit('SET_TODAY', data);
                });
        }
    }
});
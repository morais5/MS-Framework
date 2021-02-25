const mdtApp = new Vue({
    el: "#content",
    data: {
        page: "Home",
        officer: {
            name: "Guest"
        },

        offenses: [],
        warrants: [],

        homepage: {
            button_press: 0,
            reports: false,
            warrants: false
        },
        recent_searches: {
            person: [],
            vehicle: []
        },

        report_search: "",
        report_edit: {
            enable: false,
            data: {}
        },
        report_results: {
            query: "",
            results: false
        },
        report_selected: {
            id: null,
            date: null,
            name: null,
            title: null,
            incident: null,
            charges: null,
            author: null,
            jailtime: null
        },
        report_new: {
            title: "",
            charges: {},
            charges_search: "",
            incident: "",
            name: null,
            char_id: null,
            focus: "name",
            recommended_fine: 0,
            recommended_sentence: 0,
            sentence: ''
        },

        offender_search: "",
        offender_results: {
            query: "",
            results: false
        },
        offender_selected: {
            firstname: null,
            lastname: null,
            notes: "",
            licenses: false,
            convictions: null,
            mugshot_url: "",
            fingerprint: "",
            dateofbirth: null,
            id: null,
            identifier: null,
            haswarrant: false
        },
        offender_changes: {
            notes: "",
            mugshot_url: "",
            fingerprint: "",
            convictions: [],
            convictions_removed: []
        },

        vehicle_search: "",
        vehicle_results: {
            query: "",
            results: false
        },
        vehicle_selected: {
            plate: null,
            type: null,
            owner: null,
            owner_id: null,
            model: null,
            color: null
        },

        warrant_search: "",
        warrant_results: {
            query: "",
            results: {}
        },
        warrant_selected: {
            name: null,
            id: null,
            char_id: null,
            report_id: null,
            report_title: null,
            report_charges: {},
            date: null,
            expire: null,
            notes: null
        },
        warrant_new: {
            name: null,
            char_id: null,
            report_id: null,
            report_title: null,
            report_search: "",
            charges: {},
            notes: null
        }
    },
    methods: {
        changePage(page) {
            this.page = page;
            ClearActiveNavItems();
            if (page == "Home") {
                $("#home").addClass("nav-active");
            } else if (page == "Search Reports") {
                $("#search-reports").addClass("nav-active");
            } else if (page == "Search Offenders") {
                $("#search-offenders").addClass("nav-active");
            } else if (page == "Search Vehicles") {
                $("#search-vehicles").addClass("nav-active");
            } else if (page == "Warrants") {
                $.post('http://mdt/getWarrants', JSON.stringify({}));
                $("#warrants").addClass("nav-active");
            } else if (page == "Submit Report") {
                $("#submit-report").addClass("nav-active");
            }
        },
        closeMDT() {
            $.post('http://mdt/close', JSON.stringify({}));
        },
        OffenderSearch() {
            if (this.offender_search) {

                this.offender_results.query = this.offender_search;
                $.post('http://mdt/performOffenderSearch', JSON.stringify({
                    query: this.offender_search
                }));

                this.offender_results.results = false;
                return;
            }
        },
        ForensicsSearch() {
            if (this.offender_search) {

                this.offender_results.query = this.offender_search;
                $.post('http://mdt/performForensicsSearch', JSON.stringify({
                    query: this.offender_search
                }));

                this.offender_results.results = false;
                return;
            }
        },
        OpenOffenderDetails(id) {
            for (var key in this.offender_results.results) {
                if (id == this.offender_results.results[key].citizenid) {

                    $.post('http://mdt/viewOffender', JSON.stringify({
                        offender: this.offender_results.results[key]
                    }));

                    return;
                }
            }
        },
        SaveOffenderChanges() {
            $.post('http://mdt/saveOffenderChanges', JSON.stringify({
                changes: this.offender_changes,
                id: this.offender_selected.char_id,
                identifier: this.offender_selected.char_id
            }));
            this.changePage("Search Offenders");
            this.offender_selected.notes = this.offender_changes.notes;
            this.offender_selected.mugshot_url = this.offender_changes.mugshot_url;
            this.offender_selected.fingerprint = this.offender_changes.fingerprint;
            this.offender_selected.convictions = this.offender_changes.convictions;
            return;
        },
        ReportSearch() {
            if (this.report_search) {

                this.report_results.query = this.report_search
                this.warrant_new.report_search = this.report_search
                $.post('http://mdt/performReportSearch', JSON.stringify({
                    query: this.report_search
                }));

                this.report_results.results = false;
                this.report_selected = {
                    id: null,
                    date: null,
                    name: null,
                    title: null,
                    report: null,
                    charges: null,
                    author: null
                };
                return;
            }
        },
        AddCharge(id) {
            for (var key in this.offenses) {
                if (id == this.offenses[key].id) {
                    var offense_name = this.offenses[key].label
                    if (this.report_new.charges[offense_name]) {
                        Vue.set(this.report_new.charges, offense_name, this.report_new.charges[offense_name] + 1);
                    } else {
                        Vue.set(this.report_new.charges, offense_name, 1);
                    }

                    this.report_new.recommended_fine = this.report_new.recommended_fine + this.offenses[key].amount
                    if (this.offenses[key].jailtime) {
                        this.report_new.recommended_sentence = this.report_new.recommended_sentence + this.offenses[key].jailtime
                    }

                    return;
                }
            }

        },
        RemoveCharge(offense) {
            for (var key in this.report_new.charges) {
                if (offense == key) {
                    if ((this.report_new.charges[offense] - 1) > 0) {
                        Vue.set(this.report_new.charges, offense, this.report_new.charges[offense] - 1)
                    } else {
                        Vue.delete(this.report_new.charges, offense)
                    }

                    for (var key in this.offenses) {
                        if (offense == this.offenses[key].label) {
                            this.report_new.recommended_fine = this.report_new.recommended_fine - this.offenses[key].amount
                            if (this.offenses[key].jailtime) {
                                this.report_new.recommended_sentence = this.report_new.recommended_sentence - this.offenses[key].jailtime
                            }
                        }
                    }

                    return;
                }
            }
        },
        SubmitNewReport() {
            if (this.report_new.title && this.report_new.char_id && (Object.keys(this.report_new.charges).length > 0) && this.report_new.incident) {
                $.post('http://mdt/submitNewReport', JSON.stringify({
                    title: this.report_new.title,
                    char_id: this.report_new.char_id,
                    name: this.report_new.name,
                    charges: this.report_new.charges,
                    incident: this.report_new.incident,
                    sentence: this.report_new.sentence
                }));

                this.report_new.title = "";
                this.report_new.charges = {};
                this.report_new.charges_search = "";
                this.report_new.incident = "";
                this.report_new.name = null;
                this.report_new.char_id = null;
                this.report_new.focus = "name";
                this.report_new.recommended_fine = 0;
                this.report_new.recommended_sentence = 0;
                this.report_new.sentence = "";
                this.offender_search = "";
                this.offender_results.query = "";
                this.offender_results.results = false;
                this.changePage("Search Reports");
                return;   
            }
        },
        OpenOffenderDetailsById(id) {
            $.post('http://mdt/getOffender', JSON.stringify({
                char_id: id
            }));

            return;
        },
        ToggleReportEdit() {
            if (this.report_edit.enable) {
                this.report_edit.enable = false;
                this.report_edit.data = {}
            } else {
                this.report_edit.enable = true;
                this.report_edit.data.title = this.report_selected.title;
                this.report_edit.data.incident = this.report_selected.incident;
            }
            return;
        },
        DeleteSelectedReport() {
            $.post('http://mdt/deleteReport', JSON.stringify({
                id: this.report_selected.id,
            }));
            this.changePage("Search Reports");
            this.report_selected = {
                id: null,
                date: null,
                name: null,
                title: null,
                report: null,
                charges: null,
                author: null
            };
            this.report_results = {
                query: "",
                results: false
            };
            this.report_search = "";
            return;
        },
        SaveReportEditChanges() {
            $.post('http://mdt/saveReportChanges', JSON.stringify({
                id: this.report_selected.id,
                title: this.report_edit.data.title,
                incident: this.report_edit.data.incident
            }));

            this.report_selected.title = this.report_edit.data.title;
            this.report_selected.incident = this.report_edit.data.incident;
            this.ToggleReportEdit();
            return;
        },
        VehicleSearch() {
            if (this.vehicle_search) {

                this.vehicle_results.query = this.vehicle_search;
                $.post('http://mdt/vehicleSearch', JSON.stringify({
                    plate: this.vehicle_search
                }));

                this.vehicle_results.results = false;
                return;
            }
        },
        OpenVehicleDetails(result) {
            $.post('http://mdt/getVehicle', JSON.stringify({
                vehicle: result
            }));

            return;
        },
        WarrantReportSearch() {
            if (this.warrant_new.report_search) {

                this.report_results.query = this.report_search
                $.post('http://mdt/performReportSearch', JSON.stringify({
                    query: this.report_search
                }));

                this.report_results.results = false;
                this.report_selected = {
                    id: null,
                    date: null,
                    name: null,
                    title: null,
                    report: null,
                    charges: null,
                    author: null
                };
                return;
            }
        },
        SubmitNewWarrant() {
            var date = new Date();
            date.setDate(date.getDate() + 7);
            $.post('http://mdt/submitNewWarrant', JSON.stringify({
                name: this.warrant_new.name,
                char_id: this.warrant_new.char_id,
                report_id: this.warrant_new.report_id,
                report_title: this.warrant_new.report_title,
                charges: this.warrant_new.charges,
                notes: this.warrant_new.notes,
                expire: date
            }));
            this.warrant_new = {
                name: null,
                char_id: null,
                report_id: null,
                report_title: null,
                report_search: "",
                charges: {},
                notes: null
            }
            this.report_results.results = false;
            this.report_results.query = "";
            return;
        },
        DeleteSelectedWarrant() {
            $.post('http://mdt/deleteWarrant', JSON.stringify({
                id: this.warrant_selected.id,
            }));
            this.warrant_selected = {
                name: null,
                id: null,
                char_id: null,
                report_id: null,
                report_title: null,
                report_charges: {},
                date: null,
                expire: null,
                notes: null
            };
            return;
        },
        OpenReportById(id) {
            $.post('http://mdt/getReport', JSON.stringify({
                id: id
            }));
            return;
        },
        RemoveConviction(conviction) {
            for (var offense in this.offender_selected.convictions) {
                if (offense == conviction) {
                    if ((this.offender_changes.convictions[offense] - 1) > 0) {
                        Vue.set(this.offender_changes.convictions, offense, this.offender_changes.convictions[offense] - 1)
                    } else {
                        Vue.delete(this.offender_changes.convictions, offense)
                        this.offender_changes.convictions_removed.push(offense)
                    }
                }
            }
        },
        SentencePlayer() {
            var fine = 0
            for (var key in this.report_selected.charges) {
                for (var offense in this.offenses) {
                    if (this.offenses[offense].label == key) {
                        fine = fine + (this.offenses[offense].amount * this.report_selected.charges[key])
                    }
                }
            }
            $.post('http://mdt/sentencePlayer', JSON.stringify({
                char_id: this.report_selected.char_id,
                jailtime: this.report_selected.jailtime,
                charges: this.report_selected.charges,
                fine: fine
            }));
        }
    },
    computed: {
        filtered_offenses() {
            return this.offenses.filter(offense => {
                if (
                    offense.label.toLowerCase().search(this.report_new.charges_search.toLowerCase()) != -1
                    )
                    return offense;
            })
        },
        filtered_warrants() {
            return this.warrants.filter(warrant => {
                if (
                    warrant.name.toLowerCase().search(this.warrant_search.toLowerCase()) != -1
                    )
                    return warrant;
            })
        }
    }
});

$("#home").addClass("nav-active");

document.onreadystatechange = () => {
    if (document.readyState === "complete") {
        window.addEventListener('message', function(event) {
            if (event.data.type == "enable") {
                document.body.style.display = event.data.isVisible ? "block" : "none";
            } else if (event.data.type == "returnedPersonMatches") {
                mdtApp.offender_results.results = event.data.matches;
            } else if (event.data.type == "returnedOffenderDetails") {
                mdtApp.offender_selected = event.data.details;
                mdtApp.offender_results.results = false;
                mdtApp.offender_results.query = "";
                mdtApp.offender_changes.notes = mdtApp.offender_selected.notes;
                mdtApp.offender_changes.mugshot_url = mdtApp.offender_selected.mugshot_url;
                mdtApp.offender_changes.fingerprint = mdtApp.offender_selected.fingerprint;
                mdtApp.offender_changes.licenses = mdtApp.offender_selected.licenses;
                mdtApp.offender_changes.licenses_removed = [];
                mdtApp.offender_changes.convictions = mdtApp.offender_selected.convictions;
                mdtApp.offender_changes.convictions_removed = [];
                mdtApp.offender_search = mdtApp.offender_selected.firstname + " " + mdtApp.offender_selected.lastname;
                mdtApp.changePage("Search Offenders");

                mdtApp.recent_searches.person.unshift(event.data.details);
                if (mdtApp.recent_searches.person.length > 3) {
                    Vue.delete(mdtApp.recent_searches.person, 3)
                }
            } else if (event.data.type == "offensesAndOfficerLoaded") {
                mdtApp.offenses = event.data.offenses;
                mdtApp.officer.name = event.data.name;
            } else if (event.data.type == "returnedReportMatches") {
                mdtApp.report_results.results = event.data.matches;
            } else if (event.data.type == "returnedVehicleMatches") {
                mdtApp.vehicle_results.results = event.data.matches;
                mdtApp.vehicle_selected = {
                    plate: null,
                    type: null,
                    owner: null,
                    owner_id: null,
                    model: null,
                    color: null
                };
            } else if (event.data.type == "returnedVehicleDetails") {
                mdtApp.vehicle_selected = event.data.details;
                mdtApp.vehicle_search = mdtApp.vehicle_selected.plate;

                mdtApp.recent_searches.vehicle.unshift(event.data.details);
                if (mdtApp.recent_searches.vehicle.length > 3) {
                    Vue.delete(mdtApp.recent_searches.vehicle, 3)
                }
            } else if (event.data.type == "returnedVehicleMatchesInFront") {
                mdtApp.vehicle_results.results = event.data.matches;
                mdtApp.vehicle_results.query = event.data.plate;
                mdtApp.vehicle_search = event.data.plate;
                mdtApp.vehicle_selected = {
                    plate: null,
                    type: null,
                    owner: null,
                    owner_id: null,
                    model: null,
                    color: null
                };
                mdtApp.changePage("Search Vehicles");
            } else if (event.data.type == "returnedWarrants") {
                mdtApp.warrants = event.data.warrants;
            } else if (event.data.type == "completedWarrantAction") {
                mdtApp.changePage("Warrants");
            } else if (event.data.type == "returnedReportDetails") {
                mdtApp.changePage("Search Reports");
                mdtApp.report_selected = event.data.details;
            } else if (event.data.type == "recentReportsAndWarrantsLoaded") {
                mdtApp.homepage.reports = event.data.reports;
                mdtApp.homepage.warrants = event.data.warrants;
                mdtApp.officer.name = event.data.officer;
            };
        });
    };
};

document.onkeydown = function (data) {
    if (data.which == 27 || data.which == 112) { // ESC or F1
        $.post('http://mdt/close', JSON.stringify({}));
    } else if (data.which == 13) { // enter
        /* stop enter key from crashing MDT in an input?  */
        var textarea = document.getElementsByTagName('textarea');
        if (!$(textarea).is(':focus')) {
            return false;
        }
    }
};

function ClearActiveNavItems() {
    $("#home").removeClass("nav-active");
    $("#search-reports").removeClass("nav-active");
    $("#search-offenders").removeClass("nav-active");
    $("#search-vehicles").removeClass("nav-active");
    $("#warrants").removeClass("nav-active");
    $("#submit-report").removeClass("nav-active");
}

function WarrantTimer() {
    var timer = setInterval(function() {
        for (var key in mdtApp.warrants) {
            var warrant = mdtApp.warrants[key]
            var now = new Date().getTime();
            var expire_time = new Date(warrant.expire).getTime();
            var t = expire_time - now;
            if (t >= 0) {
                var days = Math.floor(t / (1000 * 60 * 60 * 24));
                var hours = Math.floor((t % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                var mins = Math.floor((t % (1000 * 60 * 60)) / (1000 * 60));
                var secs = Math.floor((t % (1000 * 60)) / 1000);
                warrant.expire_time = days + 'd ' + hours + 'h ' + mins + 'm ' + secs + 's';
            } else {
                warrant.expire_time = 'EXPIRED';
                $.post('http://mdt/deleteWarrant', JSON.stringify({
                    id: warrant.id
                }));
                Vue.delete(mdtApp.warrants, key)
            }
        }
    }, 1000);
}

WarrantTimer()
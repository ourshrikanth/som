var team_user_detail_ctrl = app.controller('teamUserDetailCtrl',['$scope', '$state', '$http', 'ngTableParams', '$stateParams', '$filter', '$q', 'teamUserService', 'userService',function($scope, $state, $http, ngTableParams, $stateParams, $filter, $q, teamUserService, userService) {


    //years data
    var arr = ['2014', '2015', '2016', '2017']
    $scope.years = arr;
    $scope.currentYear = arr[1]
    $scope.currentWeek = new Date().getWeek()
        //build the data for weeknumber selection by default 
    setDataForWeekSelectBox($scope.currentYear);
    //dynamically update the week drop, when year changes. 
    $scope.$watch(
        "tableParams.filter()['year']",
        function(value) {
            if (value != '') {
                setDataForWeekSelectBox(value)
                $scope.currentYear = value
            } else {
                console.log("value empty")
                $scope.weeks = ''
                $scope.currentWeek = ''
                $scope.currentYear = ''
            }
        });

    function setDataForWeekSelectBox(year) {
        var no_of_weeks = getNoOfWeeks(year);
        var arr = [];
        for (var i = 0; i < no_of_weeks; i++) {
            arr.push(i + 1)
        }
        // var weeksearch = $('#weekno').empty().append('<option>select</option>');
        var tempElem = [];
        for (var k in arr) {
            var v = arr[k];
            var date_text = 'Week ' + v + ' (' + getMondayToFridayFromWeekNum(v, parseInt(year)) + ')';
            // tempElem.push('<option value=' + v + '>' + date_text + '</option>')
            tempElem.push({
                id: v,
                value: date_text
            })
        }
        $scope.weeks = tempElem;
        // weeksearch.append(tempElem);
    }



    // get the monday & friday based on week number
    function getMondayToFridayFromWeekNum(weekNum, year) {
            var date = new Date(year, 0, (1 + (weekNum - 1) * 7));
            var monday = new Date(date.setDate(date.getDate() - date.getDay() + 1));
            var friday = new Date(date.setDate(date.getDate() - date.getDay() + 5));
            // while (monday.getDay() !== 1) {
            //     monday.setDate(monday.getDate());
            // }
            // var friday = addDays(monday, 4)
            var fri = [friday.getMonth() + 1, friday.getDate(), friday.getFullYear()].join('/');
            var mon = [monday.getMonth() + 1, monday.getDate(), monday.getFullYear()].join('/');
            return mon + ' - ' + fri;

        }
        //return the new date by adding days to theDate paramater
    function addDays(theDate, days) {
        return new Date(theDate.getTime() + days * 24 * 60 * 60 * 1000);
    }

    //retun the number of weeks in a year
    function getNoOfWeeks(year) {
        var d,
            isLeap;
        d = new Date(year, 0, 1);
        isLeap = new Date(year, 1, 29).getMonth() === 1;
        //check for a Jan 1 that's a Thursday or a leap year that has a 
        //Wednesday jan 1. Otherwise it's 52
        return d.getDay() === 4 || isLeap && d.getDay() === 3 ? 53 : 52
    }

    $scope.data = [];
    $scope.tableParams = new ngTableParams({
        page: 1, // show first page
        count: 10, // count per page
        sorting: {
            'planning_sheets.id': 'desc' // initial sorting
        },
        filter: {
            year: $scope.currentYear,
            week_no: $scope.currentWeek // initial filter
        }
    }, {
        getData: function($defer, params) {
            req = {
                page: params.page(),
                limit: params.count(),
                team_id: $stateParams.team_id,
                order_by: params.sorting(),
                filters: params.filter()
            }
            teamUserService.getAllPlanningSheet(req).success(function(response) {
                params.total(response.count);
                $scope.data = response.data;
                $defer.resolve($scope.data);
            }).error(function(err) {
                console.log(err);
            });


        }
    });


    //show user planning sheet id. 
    $scope.showSheet = function(planning_sheet_id) {
        $state.go('userplansheet', {
            id: planning_sheet_id
        });
    };
    //get all plannning sheet status 
    $scope.getStatus = function(data) {
        var def = $q.defer(),
            names = [];
        names.push({
            'id': 'submitted',
            'title': 'submitted'
        }, {
            'id': 'draft',
            'title': 'draft'
        }, {
            'id': 'approved',
            'title': 'approved'
        }, {
            'id': 'rejected',
            'title': 'rejected'
        });
        def.resolve(names);
        return def;

    }

}]);

team_user_detail_ctrl.isUserApproverOfTeam = function($stateParams, $q, $window, $state, notify, teamUserService) {
    teamUserService.isUserApproverOfTeam($stateParams.team_id).then(function(response) {
        if (!response.data){
            $state.go('dashboard')
               //alert error message
            notify({
                classes: 'alert-danger',
                message: "You are not a reviewer for a requested team or doesnt exists. ",
                templateUrl: ""
            });
        } 
         
    })
}

Date.prototype.getWeek = function() {
    var determinedate = new Date();
    determinedate.setFullYear(this.getFullYear(), this.getMonth(), this.getDate());
    var D = determinedate.getDay();
    if (D == 0) D = 7;
    determinedate.setDate(determinedate.getDate() + (4 - D));
    var YN = determinedate.getFullYear();
    var ZBDoCY = Math.floor((determinedate.getTime() - new Date(YN, 0, 1, -6)) / 86400000);
    var WN = 1 + Math.floor(ZBDoCY / 7);
    return WN;
}

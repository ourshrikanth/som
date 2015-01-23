app.service('planningSheetsService', ['$http',function($http) {
    var sheet = {}

    sheet.getPlanningSheet = function(id) {
        return $http.get('/planning_sheets/' + id + '.json')
    }
    return sheet;


}]);

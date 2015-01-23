app.controller('teamUserCtrl', ['$scope', '$state','$stateParams', 'teamUserService', function($scope, $state, $stateParams, teamUserService) {
    // console.log("am inside of teamUserCtrl");
    $scope.data = teamUserService.team_users;
    // $scope.planning_sheets = {};
    $scope.show_sheets = function(team_id) {
        console.log(team_id);
        // teamUserService.getAllPlanningSheet(team_id).success(function(response) {
        //         $state.go('initialplanningsheet', {
        //             id: team_id
        //         });
        //         // console.log(response);
        //         $scope.planning_sheets = response;
        //         return response;
        //     }).error(function(err) {
        //         console.log(er);
        //     })
             $state.go('teamPlanningSheets', {
                    team_id: team_id
                });
            //$scope.planning_sheets = teamUserService.team_users;
    };

   
    // console.log($scope.planning_sheets);

}]);

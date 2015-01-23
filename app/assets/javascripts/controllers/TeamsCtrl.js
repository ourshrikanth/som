app.controller('TeamsCtrl',['$scope', 'departments', 'department', 'teams', '$state', 'notify', '$q',function($scope, departments, department, teams, $state, notify, $q) {
    $scope.departments = departments.departments;
    $scope.department = department;
    $scope.teamData = department;
    //handle adding team


    console.log("insideteam controller");
    console.log($scope.department);
    $scope.addTeam = function() {
        if (!$scope.name || $scope.name === '') {
            return;
        }
        //calling teams service
        teams.create({
            name: $scope.name,
            department_id: department.id
        }).success(function(team) {
            $scope.department.teams.push(team);
            // /alert success message
            notify({
                classes: 'alert alert-success',
                message: $scope.name + "  team created successfully",
                templateUrl: ""
            });
            $scope.name = '';
            //reset the form
            $scope.addteamForm.$setPristine();
        }).error(function(error) {
            //alert error message
            notify({
                classes: 'alert-danger',
                message: "There is a problem in your request, Please try again",
                templateUrl: ""
            });
        });
    };

    $scope.deteteTeam = function(team) {
        var index = $scope.department.teams.indexOf(team);
        teams.delete(team).then(function(response) {
            //updating status to inactive
             angular.forEach($scope.department.teams, function(u, i) {
                if (u.id == response.data.id) {
                    $scope.department.teams[i] = response.data;
                }
            });

            // /alert success message
            notify({
                classes: 'alert alert-success',
                message: team.name + "  team deleted successfully",
                templateUrl: ""
            });
        }, function(error) {
            //alert error message
            notify({
                classes: 'alert alert-danger',
                message: "There is a problem in your request, Please try again",
                templateUrl: ""
            });
        });

    };
    //handle updating 
    $scope.updateDepartment = function(department) {
        if (!$scope.department.name || $scope.department.name === '') {
            return;
        }
        console.log("updatedept");
        console.log($scope.department);
        //call departments service to update department data
        departments.update({
            name: $scope.department.name,
            id: department.id
        }).then(function(data) {
            // /alert success message
            notify({
                classes: 'alert alert-success',
                message: "department name updated successfully",
                templateUrl: ""
            });
            $state.go('departments');
        }, function(error) {
            //alert error message
            notify({
                classes: 'alert-danger',
                message: "There is a problem in your request, Please try again",
                templateUrl: ""
            });
        });
    };

    //handle when view users button is clicked, to show all users of a team. 
    $scope.showAllUsersOfTeam = function(team_id) {
            $state.go('users', {
                id: team_id
            });
        }
        //handle when edit team button is clicked, to edit a team. 
        // $scope.editTeam = function(team_id) {
        //     $state.go('edit_team', {
        //         team_id: team_id
        //     });
        // }

    $scope.editTeam = function(team, data) {
        var d = $q.defer();
        teams.update(team, data).success(function(res) {
            res = res || {};
            console.log(res);
            if (res.status == true) { // {status: "ok"}
                d.resolve()
            } else { // {status: "error", msg: "Username should be `awesome`!"}
                d.resolve(res.msg)
            }
        }).error(function(e) {
            d.reject('Server error!');
        });
        return d.promise;
    };


    //handle when update team button is clicked 
    $scope.updateTeam = function(teamData) {
        //call teams service to update team data
        teams.update(teamData).then(function(data) {
            $state.go('show_department', {
                    id: teamData.department_id
                })
                // /alert success message
            notify({
                classes: 'alert alert-success',
                message: "team name updated successfully",
                templateUrl: ""
            });
        }, function(err) {
            //alert error message
            notify({
                classes: 'alert-danger',
                message: "There is a problem in your request, Please try again",
                templateUrl: ""
            });
        })
    }

}]);

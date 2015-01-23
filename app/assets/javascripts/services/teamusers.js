app.factory('teamUserService',['$http','$window',function($http,$window) {
    var team_users_factory_data = {
        team_users: []
    };
    team_users_factory_data.getAll = function() {
        return $http.get('/team_users').success(function(rm_data) {
            console.log(rm_data);
            team_users_factory_data.team_users = rm_data;
            //                     angular.copy(rm_data, team_users.team_users);
        });
    };
    team_users_factory_data.getAllPlanningSheet = function(data) {
        return $http.post('team_users/users_planning_sheet.json',
            data
        ).success(function(rm_data) {
            // console.log("rm_data");
            // team_users_factory_data.team_users = rm_data;
            // angular.copy(rm_data, team_users_factory_data.team_users);
        });
    };
    team_users_factory_data.getUserPlanningSheetDetails = function(data) {
        return $http.post('team_users/user_planning_sheet_detail', data).success(function(rm_data) {
            team_users_factory_data.team_users = rm_data;
        });
    };
    team_users_factory_data.updateUserPlanningSheet = function(sheet_id, status, comment) {
            return $http.post('team_users/update_planning_sheet.json', {
                id: sheet_id,
                status: status,
                comment: comment
            }).success(function(response) {});

        }
        //to check whether user has rights to approved team or not. 
        //params : team_id
    team_users_factory_data.isUserApproverOfTeam = function(team_id) {
        console.log(team_id)
        return $http.get('team_users/isUserReviewer.json', {
            params: {
                team_id: team_id
            }
        })
    }

    team_users_factory_data.isSheetBelongsToTeam = function(sheet_id){
         console.log(sheet_id)
         return $http.get('team_users/isSheetBelongsToTeam.json', {
            params: {
                sheet_id: sheet_id,
                 role:$window.sessionStorage._role
            }
        })
    }


    // console.log("i am in factory.")
    return team_users_factory_data;
}]);

        app.controller('UsersCtrl', ['$window','$scope', '$http', 'ngTableParams', '$state', '$stateParams', '$timeout', '$filter', '$q', 'Auth', 'userService', 'roleService', 'teams', 'notify', 'technologiesService',function($window,$scope, $http, ngTableParams, $state, $stateParams, $timeout, $filter, $q, Auth, userService, roleService, teams, notify, technologiesService) {
            console.log("inside  UsersCtrl");
            userService.getCurrentUserDetails($window.sessionStorage._userId).then(function(response){
                $scope.edit_user_detail=  response.data;
                // console.log(response.data.technologies)
                $scope.edit_user_detail.technologies = _.pluck(response.data.technologies, "id");
                // console.log($scope.edit_user_detail)
            });
             // $scope.edit_user_detail = user_details

            if ($stateParams.team_id) {
                console.log("team id is present")
                teams.get($stateParams.team_id).success(function(data) {
                    $scope.team = data;
                });
            }
            $scope.employee = {};
            $scope.employee.newTeams = [];
            $scope.employee.technologies = [];
            if ($stateParams.user_id) {
                console.log("user id is present")
                userService.getUserDetail($stateParams.user_id).success(function(response) {
                    $scope.employee = response;
                    console.log(response.team_users)
                    $scope.employee.newTeams = response.team_users;
                    console.log(response.technologies)
                    $scope.employee.technologies = _.pluck(response.technologies, "id");
                    })
            }


            $scope.userDetail = userService.users;
            $scope.roles = roleService.roles;
            teams.getAll().success(function(response) {
                $scope.all_teams = response;
            });
            $scope.technology_list = {};
            var defer = $q.defer();
            technologiesService.getAll().then(function(response) {
                var technology_list = response.data;
                defer.resolve(technology_list);
                return defer.promise;
            });

            // defer.promise.then(function(data) {
            //     $scope.technology_list = data;
            //    console.log($scope.technology_list)
            //     chosen_update();
            // }, function(err) {
            //     console.log(err)
            // });

            defer.promise.then(function success(data) {
                $scope.technology_list = data;
                $timeout(chosen_update, 1000);

            });



            $scope.addNewTeam = function() {
                addDefaultTeam();
            };

            $scope.removeTeam = function($index, $event) {
                $scope.employee.newTeams.splice($index, 1);
            };


            var defaultNewTeam = function(team) {
                return _.defaults(team || {}, DEFAULT_TEAM)
            };

            var addDefaultTeam = function() {
                $scope.employee.newTeams.push(defaultNewTeam());
            };

            var DEFAULT_TEAM = {
                team_id: '',
                approver: '',

            };

            $scope.employee.newTeams = [];

            $data = [];
            $scope.tableParams = new ngTableParams({
                page: 1,
                count: 10
            }, {
                getData: function($defer, params) {
                    console.log("inside getData UsersCtrl");
                    $http.get('users/' + $stateParams.id + '/getAllUsersOfTeam.json', {
                            params: {
                                page: params.page(),
                                limit: params.count(),
                                team_id: $stateParams.id

                            }
                        })
                        .success(function(response, status) {
                            $data = response.data;
                            $scope.team_id = response.team_id;
                            params.total(response.count);
                            $defer.resolve($data);
                            // $scope.emit('UNLOAD');
                        });
                }
            });

            //show user
            $scope.showUser = function(user_id) {
                console.log(user_id);
                $state.go('show-user', {
                    user_id: user_id
                });
            };


            //edit user
            $scope.editUser = function(user_id, team_id) {
                $state.go('edit-user', {
                    user_id: user_id,
                    team_id: team_id
                });
            };
            //update user details
            $scope.updateUser = function(user_id) {
                userService.update($scope.employee, user_id).then(function(user, user_id) {
                    $state.go('allUsers', {});
                    notify({
                      classes: 'alert alert-success',
                      message: $scope.employee.first_name+" "+$scope.employee.last_name+" user updated successfully"
                    });
                }, function(error) {
                    notify({
                      classes: 'alert-danger',
                      message: 'user updataion failed due to some error'
                    });
                    console.log('user updataion failed due to following errors:- ')
                    console.log(error)
                });

            }

            //handling registration form
            $scope.register = function() {
                userService.create($scope.employee).success(function(response) {
                    console.log(response);
                    $state.go('allUsers', {});
                    notify({
                      classes: 'alert alert-success',
                      message: response
                    });
                }, function(error) {
                    console.log('registration failed due to following errors:- ')
                    console.log(error)
                });
            }



            $scope.usersTableParams = new ngTableParams({
                page: 1, // show first page
                count: 10, // count per page
                sorting: {
                    'users.id': 'desc' // initial sorting
                },
            }, {
                //total: data.length, // length of data
                getData: function($defer, params) {
                    $http.get('users.json', {
                            params: {
                                page: params.page(),
                                limit: params.count(),
                                order_by: params.sorting(),
                                filters: params.filter()
                            }
                        })
                        .success(function(response, status) {
                            var data = response.data;
                            params.total(response.count);
                            // var orderedData = params.sorting() ?
                            //     $filter('orderBy')(data, params.orderBy()) : data;

                            // filteredData = params.filter() ?
                            //     $filter('filter')(orderedData, params.filter()) : orderedData;
                            $scope.users = data;
                            $defer.resolve($scope.users);
                        });
                },
            });

            $scope.teams = function(column) {
                var def = $q.defer(),
                    arr = [],
                    names = [];
                all_teams = teams.getAll().success(function(response) {
                    angular.forEach(response, function(item) {
                        names.push({
                            'id': item.id,
                            'title': item.name
                        });
                    });
                });
                def.resolve(names);
                return def;
            };

            $scope.technologies = function(column) {
                var def = $q.defer(),
                    arr = [],
                    names = [];
                all_teams = technologiesService.getAll().success(function(response) {
                    angular.forEach(response, function(item) {
                        names.push({
                            'id': item.id,
                            'title': item.name
                        });
                    });
                });
                def.resolve(names);
                return def;
            };

            $scope.deactivateUser = function(user) {
                userService.deactivateUser(user).success(function(response) {
                    $scope.users.splice(user, 1);
                    notify({
                        classes: 'alert alert-success',
                        message: user.first_name + "  user deactivated successfully"});
                });

            };
            $scope.updateProfile = function(){
                console.log($scope.edit_user_detail)
                userService.updateProfile($scope.edit_user_detail,$scope.edit_user_detail.id ).then(function(response){
                    if(response.data.status==true){
                        notify({
                            classes: 'alert alert-success',
                            message: "Profile updated successfully"
                        });
                        $state.go('dashboard');
                    }
                    else if(response.data.status=="password_missing"){
                        notify({
                            classes: 'alert-danger',
                            message: "Password Missing"
                        });
                    }
                    else{
                        notify({
                            classes: 'alert-danger',
                            message: "Current Password Not Matching"
                        });

                    }
                })

            };


            //  Auth.currentUser().then(function (user){
            //     $scope.user = user;
            //     $scope.$on('devise:new-registration', function (e, employee){
            //        console.log("devise:new-registration");
            //         console.log($scope.employee);
            //         // $scope.user = '';
            //     });

            //     $scope.$on('devise:login', function (e, user){
            //         $scope.user = user;
            //     });

            //     $scope.$on('devise:logout', function (e, user){
            //         $scope.user = {};
            //     });
            // });


        }]);

        var app = angular.module('som', ['ui.router', 'templates', 'Devise', 'ngTable', 'ngDialog', 'cgNotify', 'localytics.directives', 'xeditable','daterangepicker'])
        app.config(
            function($stateProvider, $urlRouterProvider) {
                $stateProvider
                    .state('home', {
                        url: '/home',
                        templateUrl: 'home.html',
                        controller: 'MainCtrl'
                    }).state('login', {
                        url: '/login',
                        templateUrl: 'auth/login.html',
                        controller: 'AuthCtrl',
                        title: 'Login',
                        onEnter: ['$state', 'Auth', function($state, Auth) {
                            Auth.currentUser().then(function() {
                                $state.go('dashboard');
                            })
                        }]
                    }).state('register', {
                        url: '/register',
                        templateUrl: 'auth/register.html',
                        controller: 'AuthCtrl'
                    }).state('forgot_password', {
                        url: '/forgot_password',
                        templateUrl: 'auth/forgot_password.html',
                        controller: 'AuthCtrl'
                    }).state('update_password', {
                        url: '/users/password/edit/{reset_password_token}',
                        templateUrl: 'auth/update_password.html',
                        controller: 'AuthCtrl'
                    }).state('departments', {
                        url: '/departments',
                        templateUrl: 'departments/index.html',
                        controller: 'DepartmentsCtrl',
                        resolve: {
                            postPromise: ['departments', function(departments) {
                                return departments.getAll();
                            }]
                        }
                    }).state('show_department', {
                        url: '/departments/{id}',
                        templateUrl: 'teams/index.html',
                        controller: 'TeamsCtrl',
                        resolve: {
                            department: ['$stateParams', 'departments', function($stateParams, departments) {
                                return departments.get($stateParams.id);
                            }]
                        }
                    }).state('edit_profile', {
                        url: '/editMyProfile',
                        templateUrl: 'users/profile.html',
                        controller: 'UsersCtrl'
                        // resolve: {
                        //     user_details: ['$window', 'userService', function($window, userService) {
                        //         return userService.getCurrentUserDetails($window.sessionStorage._userId).then(function(response){
                        //             return response.data;
                        //         });
                        //     }]
                        // }
                    }).state('edit_department', {
                        url: '/departments/{id}/edit',
                        templateUrl: 'departments/edit.html',
                        controller: 'TeamsCtrl',
                        resolve: {
                            department: ['$stateParams', 'departments', function($stateParams, departments) {
                                console.log(departments.get($stateParams.id))
                                return departments.get($stateParams.id);
                            }]
                        }
                    }).state('edit_team', {
                        url: '/teams/{team_id}/edit',
                        templateUrl: 'teams/edit.html',
                        controller: 'TeamsCtrl',
                        resolve: {
                            department: ['$stateParams', 'teams', function($stateParams, teams) {
                                return teams.get($stateParams.team_id);
                            }]
                        }
                    }).state('users', {
                        url: '/teams/{id}',
                        templateUrl: 'users/team_users.html',
                        controller: 'UsersCtrl'
                    }).state('show-user', {
                        url: '/users/{user_id}/show',
                        templateUrl: 'users/show.html',
                        controller: 'UsersCtrl',
                    }).state('add-user', {
                        url: '/users/add',
                        templateUrl: 'users/add.html',
                        controller: 'UsersCtrl'
                    }).state('edit-user', {
                        url: '/users/{user_id}/edit',
                        templateUrl: 'users/edit.html',
                        controller: 'UsersCtrl'
                    }).state('planning-sheet', {
                        url: '/planning-sheet/:id',
                        templateUrl: 'planning_sheets/show.html',
                        controller: 'PlanningSheetDetailCtrl',
                        resolve: {
                            isOwner: planning_sheet_ctrl.isSheetCanBeShown
                        }
                    }).state('planning-sheet-edit', {
                        url: '/planning-sheet/:id/edit',
                        templateUrl: 'planning_sheets/edit.html',
                        controller: 'PlanningSheetEditCtrl',
                        resolve: {
                            isOwner: planning_sheet_edit_ctrl.isSheetCanBeEdited
                        }
                    }).state('dashboard', {
                        url: '/dashboard',
                        templateUrl: 'planning_sheets/index.html',
                        controller: 'PlanningSheetsCtrl'
                    }).state('teamuser', {
                        url: '/teamuser',
                        templateUrl: 'teamusers/index.html',
                        controller: 'teamUserCtrl',
                        resolve: {
                            postPromise: ['teamUserService', function(teamUserService) {
                                return teamUserService.getAll();
                            }]
                        }
                    }).state('teamPlanningSheets', {
                        url: '/reviewplansheet/:team_id',
                        templateUrl: 'teamusers/reviewplansheet.html',
                        controller: 'teamUserDetailCtrl',
                        resolve: {
                            isApprover: team_user_detail_ctrl.isUserApproverOfTeam
                        }
                    }).state('userplansheet', {
                        url: '/userplansheet/:id',
                        templateUrl: 'teamusers/userplansheet.html',
                        controller: 'teamUserPlanSheetCtrl',
                        resolve: {
                            isSheetBelongsToTeam: team_user_plan_sheet_ctrl.isSheetBelongsToTeam
                        }
                        // resolve: {
                        //     planning_sheets: ['$stateParams', 'teamUserService', function($stateParams, teamUserService) {
                        //         return teamUserService.getUserPlanningSheetDetails($stateParams.id);
                        //     }]
                        // }
                    }).state('allUsers', {
                        url: '/users',
                        templateUrl: 'users/index.html',
                        controller: 'UsersCtrl',
                    }).state('resource-utilization', {
                        url: '/resource-utilization',
                        templateUrl: 'planning_sheets/resource-utilization.html',
                        controller: 'resourceUtilizationCtrl'
                    }).state('technologiesList', {
                        url: '/technologies',
                        templateUrl: 'technologies/index.html',
                        controller: 'TechnologiesCtrl'
                    }).state('editTechnology', {
                        url: '/technologies/{{id}}/edit',
                        templateUrl: 'technologies/edit.html',
                        controller: 'TechnologiesCtrl'
                    }).state('projects', {
                        url: '/projects',
                        templateUrl: 'projects/list.html',
                        controller: 'projectsCtrl'
                    }).state('resource-allocation', {
                        url: '/resource-allocation',
                        controller: 'ResourceAllocationCtrl',
                        templateUrl: 'resources/allocation-list.html'
                    });
                $urlRouterProvider.otherwise('login');
            }
        );
        //where we will store the attempted url

        app.value('redirectToUrlAfterLogin', {
            url: '/dashboard'
        });
        //handling ACL
        app.run(['$rootScope', '$state', 'Auth', '$q', '$window', '$location', 'authService', 'userService', 'editableOptions', 'redirectToUrlAfterLogin', function($rootScope, $state, Auth, $q, $window, $location, authService, userService, editableOptions, redirectToUrlAfterLogin) {
            editableOptions.theme = 'bs3'; // bootstrap3 theme. Can be also 'bs2', 'default'
            $rootScope.$on('$stateChangeStart', function(event, to, toParams, from, fromParams) {
                // if route requires auth and user is not logged in
                var role_name = $q.defer();
                Auth.currentUser().then(function(user) {
                    $window.sessionStorage._userId = user.id
                    userService.getMyRole(user.id).then(function(response) {
                        var user = response.data;
                        role_name.resolve(user.role_name)
                        $rootScope.isLoggedIn = true
                    });
                    return role_name;
                }, function(err) {
                    console.log($location.url());
                    if($location.url()!='/forgot_password' && $location.url()!='/update_password'){
                    userService.saveAttemptUrl($location.url());
                    }
                    if($state.current.name!='forgot_password' && $state.current.name!='update_password'){
                     $state.go('login')
                 }
                    $rootScope.isLoggedIn = false
                    $rootScope.bodylayout = 'loginPage';
                });

                var promise = role_name.promise;
                promise.then(function success(data) {
                    $rootScope.userRole = data
                    $window.sessionStorage._role = data
                        // mapRouteForUserRole(data)
                    if (!(authService.isUrlAccessibleForUser(to.name, data))) {
                        console.log("not allowed")
                        $state.go('login')
                        event.preventDefault();
                    }
                });

                function mapRouteForUserRole(role) {
                    console.log(authService.isUrlAccessibleForUser(to.name, role))
                    if (!(authService.isUrlAccessibleForUser(to.name, role))) {
                        console.log("not allowed")
                        $state.go('login')
                        event.preventDefault();
                    }
                }

            });
        }]);

        // ACL - auth service. 
        app.factory('authService', function() {


            var userRoleRouteMap = {
                "employee": ['login', 'dashboard', 'planning-sheet', 'planning-sheet-edit','forgot_password','update_password'],
                "reporting manager": ['login', 'dashboard', 'planning-sheet', 'planning-sheet-edit', 'teamuser', 'initialplanningsheet', 'userplansheet', 'teamPlanningSheets','forgot_password','update_password'],
                "admin": ['login', 'dashboard', 'departments', 'show_department', 'edit_department', 'users', 'show-user', 'edit-user', 'planning-sheet',
                    'planning-sheet-edit', 'allUsers', 'resource-utilization', 'teamuser', 'teamPlanningSheets', 'userplansheet', 'add-user', 'edit_team', 'technologiesList', 'editTechnology', 'projects', 'resource-allocation','edit_profile','forgot_password','update_password'
                ],
                "project manager": ['login', 'dashboard', 'resource-allocation','forgot_password','update_password']

            }

            return {
                isUrlAccessibleForUser: function(route, userRole) {
                    console.log(route, userRole)
                    var role = userRole;
                    var validUrlsForRole = userRoleRouteMap[role];
                    if (validUrlsForRole) {
                        for (var j = 0; j < validUrlsForRole.length; j++) {
                            if (validUrlsForRole[j] == route)
                                return true;
                        }
                    }

                    return false;
                }
            };
        });

        function chosen_update() {
            $('select').trigger("chosen:updated");
        }


    app.factory('userService', ['$http', 'redirectToUrlAfterLogin', '$state', '$location', function($http, redirectToUrlAfterLogin, $state, $location) {
        var user = {
            users: []
        };
        //checking uniqueness of user attribute such as email , employee Id. 
        // user.checkUniqueValue = function(model,id, property, value) {
        //     if (!id) id = 0;
        //     return $http.get('users/checkUniqueFields?model='+model+'&user_id=' + id + '&property=' +
        //         property + '&value=' + escape(value)).then(
        //         function(results) {
        //             return results.data;
        //         });
        // };


        user.getAllUsersOfTeam = function(params) {
            return $http.post('users/getAllUsersOfTeam.json', params).success(function(data) {
                angular.copy(data, user.users);
            }).error(function(err) {
                console.log(err);
            });
        };

        user.getUserDetails = function(team_id, user_id) {
            return $http.get('/teams/' + team_id + '/users/' + user_id + '.json').then(function(res) {
                console.log("---resp of getUserDetails--");
                user.users = res.data;

            });
        }
        user.create = function(user) {
            return $http.post('/users/save', user)
        }
        user.update = function(user, user_id) {
            return $http.put('/users/' + user_id, user)
        }

        user.getMyRole = function(user_id) {
            return $http.post('users/getMyRole.json', {
                user_id: user_id
            }).success(function(response) {
                response.data;
            }).error(function(err) {
                console.log(err);
            });
        }
        user.getAll = function(params) {
            return $http.get('/users.json', {
                params: params
            })
        }
        user.getUserDetail = function(id) {
            return $http.get('/users/' + id + '.json')
        }
        user.deactivateUser = function(user) {
            return $http.delete('/users/' + user.id + '.json')
        };
        user.saveAttemptUrl = function(url) {
            if (url.toLowerCase() != '/login') {
                redirectToUrlAfterLogin.url = url;
            }

        }
        user.redirectToAttemptedUrl = function() {
            $location.path(redirectToUrlAfterLogin.url)
            redirectToUrlAfterLogin.url = "/dashboard"
        }
        user.forgot_password = function(user) {
            user = {
                user: user
            }
            return $http.post('/users/password.json', user)
        }
        user.reset_password = function(user) {
            user = {
                user: user
            }
            return $http.put('/users/password.json', user)
        }


        user.getCurrentUserDetails = function(id) {
            // body...
            return $http.get('/users/'+id+'/edit.json');
        };
        user.updateProfile = function(user){
            return $http.patch('/users/update_profile',user);
        }; 



        return user;

    }]);

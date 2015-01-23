    app.controller('AuthCtrl', ['$scope', '$rootScope', '$state', '$http', 'Auth', 'userService','$stateParams','notify',
        function($scope, $rootScope, $state, $http, Auth, userService,$stateParams,notify) {
           if($stateParams.reset_password_token){
            $scope.reset_password_token= $stateParams.reset_password_token;
            }
            $scope.errors = [];
            $scope.login = function() {
                $scope.errors.splice(0, $scope.errors.length);
                Auth.login($scope.user).then(function(user) {
                    //ACL attaching role. 
                    // userService.getMyRole(user.id).then(function(response) {
                    //     var user = response.data;
                    //     console.log("current user role : " + user.role_name);
                    //     AclService.flushRoles();
                    //     //attach role to ACL
                    //     AclService.attachRole(user.role_name);
                    //     console.log("attached successfully");
                    //     $state.go('dashboard');
                    // });
                    console.log("logged in successfully..!!!");
                    // $state.go('dashboard');
                    userService.redirectToAttemptedUrl();
                }, function(errors, status) {
                    $scope.errors.push(errors.data.error);
                });
            };
           $scope.reset_password = function() {
               userService.forgot_password($scope.user)
                 .success( function(data, status) {
                     notify({
                            classes: 'alert alert-success',
                            message: "If your e-mail address is on file then password reset instructions have been sent to that e-mail address"
                        });
                 })
                 .error( function( data, status ) {
                    notify({
                            classes: 'alert alert-success',
                            message: "Email "+data.errors.email[0]
                        })
                 });
             };
               $scope.update_password = function() {
                  userService.reset_password($scope.user)
                    .success( function() {
                     notify({
                            classes: 'alert alert-success',
                            message: "Password is updated successfully"
                        });
                    $state.go('dashboard');
                 })
                 .error( function( data, status ) {
                 });
             };
             $scope.forgot_password_link = function(){
                 $state.go('forgot_password')
             }
        }
    ]);

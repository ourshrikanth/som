app.controller('NavCtrl',['$scope', 'Auth', '$state', '$location',function($scope, Auth, $state, $location ) {
    $scope.signedIn = Auth.isAuthenticated;
    $scope.logout = Auth.logout;
    Auth.currentUser().then(function(user) {
        $scope.user = user;
        $scope.$on('devise:new-registration', function(e, user) {
            $scope.user = user;
        });

        $scope.$on('devise:login', function(e, user) {
            $scope.user = user;
        });

        $scope.$on('devise:logout', function(e, user) {
            $scope.user = {};
        });
    });

    // for making current navigation panel active
    $scope.isActive = function(route) {
        return $location.path().match(route);
    }


    $scope.logOut = function() {
        Auth.logout().then(function(oldUser) {
            $state.go('login');
        }, function(error) {
            // An error occurred logging out.
        });
    }

}]);

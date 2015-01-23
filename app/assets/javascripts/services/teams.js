app.factory('teams', [
        '$http',
        function($http) {
            var team = {
                teams: []
            };
            team.getAll = function() {
                return $http.get('/teams.json').success(function(data) {
                    angular.copy(data, team.teams);
                });
            };
            team.create = function(team) {
                return $http.post('/teams.json', team).success(function(data) {});
            };

            team.get = function(id) {
                return $http.get('/teams/' + id + '.json').then(function(res) {
                    return res.data;
                });
            };

            team.update = function(team,name) {
                console.log(team);
                return $http.put('/teams/' + team.id + '.json?name='+name);
            };
            team.delete = function(team) {
                return $http.delete('/teams/' + team.id + '.json').then(function(response) {
                    // console.log(response);
                    return response;
                });
            };
        
        return team;
    }]);

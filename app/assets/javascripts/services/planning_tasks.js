app.factory('planned_tasks', [
    '$http',
    function($http) {
        var task = {
            tasks: []
        };
        task.getAll = function() {
            return $http.get('/planned_tasks.json').success(function(data) {
                angular.copy(data, task.tasks);
            });
        };
        task.create = function(task) {
            return $http.post('/planned_tasks.json', task).success(function(data) {
                // task.tasks.push(data);
            });
        };
        task.get = function(id) {
            return $http.get('/planned_tasks/' + id + '.json').then(function(res) {
                return res.data;
            });
        };
        task.update = function(task) {
            console.log("----inside planned_tasks service----------");
            console.log(task);
            console.log(task.data.id);
            return $http.put('/planned_tasks/' + task.data.id + '.json', task);
        };
        task.delete = function(task) {
            return $http.delete('/planned_tasks/' + task.id + '.json')
        };
        return task;
    }
])

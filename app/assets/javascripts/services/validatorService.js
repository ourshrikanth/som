app.factory('validatorService', ['$http', function($http){
	var temp={ };
	temp.checkUniqueFields=function(model,id,property,value) {
        if (!id) id = 0;
        return $http.get('users/checkUniqueFields?model='+model+'&user_id=' + id + '&property=' +
            property + '&value=' + escape(value)).then(
            function(results) {
                return results.data;
            });
    };
    return temp
}]);
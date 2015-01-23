var EMAIL_REGEXP = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/i;
//directive to valiate email. 
app.directive('validEmail', function() {
    return {
        restrict: "A",
        require: "?ngModel",
        link: function(scope, element, attributes, ngModel) {
            ngModel.$validators.validEmail = function(modelValue) {
                return EMAIL_REGEXP.test(modelValue);
            };
        }
    };
});

app.directive('uniqueField', ['validatorService', function(validatorService) {
    return {
        restrict: 'A',
        require: 'ngModel',
        link: function(scope, element, attrs, ngModel) {
            element.bind('blur keyup', function(e) {
                if (attrs.isChecked==true) {
                    var keyProperty = {
                        key: 0,
                        property: attrs.name
                    }
                }else{
                    var keyProperty = {
                        key: attrs.objectId,
                        property: attrs.name
                    }
                }
                var model = attrs.model
                var currentValue = element.val();

                validatorService.checkUniqueFields(model,keyProperty.key, keyProperty.property, currentValue)
                    .then(function(unique) {
                        //Ensure value that being checked hasn't changed
                        //since the Ajax call was made
                        if (currentValue == element.val()) {
                            ngModel.$setValidity('unique', unique);
                        }
                    }, function() {
                        //Probably want a more robust way to handle an error
                        //For this demo we'll set unique to true though
                        ngModel.$setValidity('unique', true);
                    });
                
            });

        }
    };
}]);

app.filter('capitalize', function() {
  return function(input, scope) {
    if (input!=null)
    input = input.toLowerCase();
    return input.substring(0,1).toUpperCase()+input.substring(1);
  }
});
app.directive('ngConfirmClick', [
        function(){
            return {
                link: function (scope, element, attr) {
                    var msg = attr.ngConfirmClick || "Are you sure?";
                    var clickAction = attr.confirmedClick;
                    element.bind('click',function (event) {
                        if ( window.confirm(msg) ) {
                            scope.$eval(clickAction)
                        }
                    });
                }
            };
    }]);


app.directive('lowerThan', [
  function() {
    var link = function($scope, $element, $attrs, ctrl) {

      var validate = function(viewValue) {
        var comparisonModel = $attrs.lowerThan;
        if(!viewValue || !comparisonModel){
          // It's valid because we have nothing to compare against
          ctrl.$setValidity('lowerThan', true);
        }

        // It's valid if model is lower than the model we're comparing against
        ctrl.$setValidity('lowerThan', parseInt(viewValue, 10) <= parseInt(comparisonModel, 10) );
        return viewValue;
      };

      ctrl.$parsers.unshift(validate);
      ctrl.$formatters.push(validate);

      $attrs.$observe('lowerThan', function(comparisonModel){
        return validate(ctrl.$viewValue);
      });
      
    };

    return {
      require: 'ngModel',
      link: link
    };

  }
]);



app.directive('pwdValidity', [
  function() {
    var link = function($scope, $element, $attrs, ctrl) {

      var validate = function(viewValue) {
        var comparisonModel = $attrs.pwdValidity;
        if(!viewValue || !comparisonModel){
          // It's valid because we have nothing to compare against
          ctrl.$setValidity('pwdValidity', true);
        }

        // It's valid if model is lower than the model we're comparing against
        ctrl.$setValidity('pwdValidity', viewValue == comparisonModel);
        return viewValue;
      };

      ctrl.$parsers.unshift(validate);
      ctrl.$formatters.push(validate);

      $attrs.$observe('pwdValidity', function(comparisonModel){
        return validate(ctrl.$viewValue);
      });
      
    };

    return {
      require: 'ngModel',
      link: link
    };

  }
]);



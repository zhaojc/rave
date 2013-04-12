angular.module('rave.directive', [])
    .directive('renderWidget', ['rave', '$parse', function (rave, $parse) {
        return function postLink(scope, el, attrs) {
            var fn = $parse(attrs.renderWidget);
            var renderWidgetId = fn(scope);
            rave.getWidget(renderWidgetId).render(el[0]);
        }
    }]);
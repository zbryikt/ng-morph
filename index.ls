angular.module \ui-morph, <[]>
.directive \uiMorph ($compile, $interval) ->
  return
    restrict: \A
    scope: {
      uiMorph: \@
    }
    link: (s,e,a) ->
      s <<< des: {}, cur: {}, src: {}, ani: {}, time: {}
      s.$watch 'uiMorph', (v) ->
        u = s.$eval v
        dur = u.dur or 1000
        [[k,v] for k,v of s.$eval v]map ->
          if it.0==\dur => return
          s.des[it.0] = s.src[it.0] = s.cur[it.0] = s.$parent.$eval it.1
          ( (d) ->
            s.$parent.$watch d.1, ->
              s.des[d.0] = it
              s.src[d.0] = s.cur[d.0]
              if s.ani[d.0] => $interval.cancel(s.ani[d.0])
              if s.cur[d.0] == s.des[@cur] => return
              s.time[d.0] = new Date!getTime!
              s.ani[d.0] = $interval ->
                ct = new Date!getTime!
                ratio = (( ct - s.time[d.0]) / dur) <? 1
                s.cur[d.0] = s.src[d.0] + (s.des[d.0] - s.src[d.0]) * ratio
                e.attr d.0, s.cur[d.0]
          ) it

.controller \mainCtrl, ($scope, $interval) ->
  $scope.b = 0
  $scope.c = 1
  $interval (-> $scope.b = Math.random!*100), 1000


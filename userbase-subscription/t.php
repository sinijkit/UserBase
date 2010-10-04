<?
  include('Subscription.php');
  
  $a = new PlanMgmt('/var/www/html/userbase-subscription/plans');
  $l = $a->getPlans();
  foreach($l as $k => $v) {
    echo $v->title,"\n";
//    $v->getSchedule();
    echo "<pre>",serialize($v),"</pre>";
  }
?>
